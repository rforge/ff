# ffchunk in R.ff
# (c) 2010 Jens Oehlschägel
# Licence: GPL2
# Provided 'as is', use at your own risk
# Created: 2010-03-21
# Last changed: 2010-03-21

# source("d:/mwp/eanalysis/R.ff/R/ffchunk.R")

sfIsInit <- function() {
  exists("sfOption", envir=asNamespace("snowfall")) && ( length( snowfall:::.sfOption ) > 0 ) && snowfall:::.sfOption$init && !snowfall:::.sfOption$stopped
}

#! \name{ffchunk}
#! \alias{ffchunk}
#! \title{
#!   Chunked looping
#! }
#! \description{
#!   Evaluate an indexed expression in a chunked loop, potentially in parallel
#! }
#! \usage{
#! ffchunk(x = NULL
#! , chunks = NULL
#! , from = NULL
#! , to = NULL
#! , by = NULL
#! , length.out = NULL
#! , envir = parent.frame()
#! , loopvar = "i"
#! , funcvar = "chunkFUN"
#! , parallel = NULL
#! , cpus = NULL
#! , method = c("ind","pos","nam")
#! , RETURN = NULL
#! , RECORDBYTES = NULL
#! , BATCHBYTES = getOption("ffbatchbytes")
#! , VERBOSE = FALSE
#! )
#! }
#! \arguments{
#!   \item{x}{an expression that can be evaluated in chunks identified by an index named according to argument loopvar}
#!   \item{chunks}{ optionally a list with range indices as created by \code{\link[=chunk.ff_vector]{chunk}}}
#!   \item{from}{ optionally the position where to start the chunking (ignored if argument chunks is not NULL)}
#!   \item{to}{ optionally the position where to stop the chunking (ignored if argument chunks is not NULL)}
#!   \item{by}{ optionally the size of a chunk  (ignored if argument chunks is not NULL)}
#!   \item{length.out}{ optionally the number of chunks  (ignored if argument chunks is not NULL)}
#!   \item{envir}{ the environment where to evaluate the expression x }
#!   \item{loopvar}{ the name of the variable used for the chunk index (must not conflict with other object names) }
#!   \item{funcvar}{ the name of the function realizing the expression on snowfall slaves }
#!   \item{parallel}{ set to FALSE to force local sequential evaluation }
#!   \item{cpus}{ the number of cpus (ignored if snowfall cluster is already initialized) }
#!   \item{method}{ either "ind" or "pos" or "nam", see details }
#!   \item{RETURN}{ set to TRUE or FALSE to force/suppress returning from the expression }
#!   \item{RECORDBYTES}{ the number of bytes required for processing one single element of the loop, used for automatic chunk size determination }
#!   \item{BATCHBYTES}{ the maximum number of bytes available for processing one chunk }
#!   \item{VERBOSE}{ set to TRUE for measuring execution time }
#! }
#! \details{
#! \code{ffchunk} automatically estimates the size of the chunks based on RECORDBYTES and BATCHBYTES.
#! If not parallel=FALSE and if we have more than one chunk then the chunking is done in parallel.
#! Currently snowfall is used.
#! If no snowfall cluster is initialized, \code{ffchunk} will call \code{\link[snowfall]{sfInit}} and \code{\link[snowfall]{sfStop}} on.exit.
#! \code{ffchunk} makes sure that packages \code{bit} and/or \code{ff} are loaded if needed.
#! \code{ffchunk} also copies all objects used in the expression to the snowfall slaves. \cr
#!  By default (\code{method='ind'}) the \emph{loopvar} represents the \code{\link[bit:ri]{range index}} of the current chunk.
#!  Sometimes it is necessary to loop simultaneously over several types of objects:
#!  with \code{method='pos'} the loopvar represents the position of the chunk in the list of \code{chunks},
#!  with \code{method='nam'} the loopvar represents the name of the chunk in in the list of \code{chunks},
#!  note that the latter only works if you submit argument \code{chunks} as a named list of \code{\link[bit]{ri}}.
#! }
#! \value{
#! Either invisible() or a list with the returned values per chunk.
#! Argument RETURN decides whether a list is returned.
#! If RETURN is NULL then it is determined automatically:
#! if the expression x contains a call to return then RETURN is set to TRUE,
#! otherwise if an "<-" assigment is found, RETURN is set to FALSE.
#! }
#! \author{
#!   Jens Oehlschlägel
#! }
#! \seealso{
#!   \code{\link[ff]{ffvecapply}}, \code{\link[bit]{chunk}}
#! }
#! \examples{
#!   n <- 1e3
#!   a <- ff(vmode="double", length=n)
#!   b <- ff(vmode="double", length=n)
#!   d <- ffdf(a,b)
#!   z <- d$a
#!
#!   ffchunk({d$a[i] <- d$b[i] + rnorm(sum(i))}, length=10, VERBOSE=TRUE)
#!
#!   sfInit(cpus=2)
#!   ffchunk({d$a[i] <- d$b[i] + rnorm(sum(i))}, length=10, VERBOSE=TRUE)
#!   sfStop()
#!
#!   ffchunk(summary(d$a[i]), length=10, VERBOSE=TRUE)
#! }
#! \keyword{ iteration }
#! \keyword{ IO }
#! \keyword{ data }

ffchunk <- function(
  x       = NULL
, chunks     = NULL      # optional chunks
, from       = NULL      # optional start position
, to         = NULL      # optional stop position
, by         = NULL      # optional size of chunks
, length.out = NULL      # optional number of chunks
, envir = parent.frame()
, loopvar = "i"
, funcvar = "chunkFUN"
, parallel = NULL
, cpus     = NULL
, method   = c("ind","pos", "nam")
, RETURN   = NULL
, RECORDBYTES = NULL
, BATCHBYTES  = getOption("ffbatchbytes")   # batch size restriction in bytes
, VERBOSE     = FALSE
)
{
  start.time <- proc.time()[3]
  method <- match.arg(method)

  MUST_RETURN <- FALSE
  HAS_ASSIGN <- FALSE

  rec1 <- function(x){
    ne <- length(x)
    if (ne>1){
      tokens <- character()
      if (x[[1]]==as.symbol("<-")){
        HAS_ASSIGN <<- TRUE
        for (i in 2:ne){
          tokens <- c(tokens, rec1(x[[i]]))
        }
      }else if (x[[1]]==as.symbol("$")){
        tok <- as.character(x[[2]])
        names(tok) <- vmode(get(tok, envir=envir)[[as.character(x[[3]])]])
        tokens <- c(tokens, tok)
      }else{
        if (x[[1]]=="return")
          MUST_RETURN <<- TRUE
        for (i in 2:ne){
          tokens <- c(tokens, rec1(x[[i]]))
        }
      }
      tokens
    }else{
      if (is.name(x) && x!=loopvar){
        as.character(x)
      }else{
        character()
      }
    }
  }

  # turn the expression into a function
  e <- substitute(x)
  tokens <- rec1(e)
  if (is.null(RETURN))
    RETURN <- MUST_RETURN || !HAS_ASSIGN
  if (!RETURN){
    if (e[[1]]=="{"){
      e <- as.list(e)
      e[[length(e)+1]] <- quote(invisible())
      e <- as.call(e)
    }else{
      e <- call("{", e, quote(invisible()))
    }
  }

  k <- length(tokens)
  tokdup <- duplicated(tokens)
  tokmod <- names(tokens)
  if (is.null(tokmod))
    tokmod <- rep("", k)

  #ffmodes <- integer(k)
  bytes <- double(k)
  lengths <- integer(k)
  types <- factor(c("bit","ff","ram"))  # so far we do not need to distinguish between ffdf and ff
  types <- rep(types[NA], length.out=k)
  for (i in 1:k){
    if (tokdup[i]){
      j <- match(tokens[i], tokens)
      if (tokmod[i]==""){
        types[i] <- types[j]
        #ffmodes[i] <- ffmodes[j]
        bytes[i] <- bytes[j]
      }else{
        types[i] <- "ff"
        v <- tokmod[i]
        #ffmodes[i] <- .ffmode[v]
        bytes[i] <- .rambytes[v]
      }
      lengths[i] <- lengths[j]
    }else{
      if (exists(tokens[i], envir=envir)){
        y <- get(tokens[i], envir=envir)
        if (is.bit(y)){
          types[i] <- "bit"
          #ffmodes[i] <- .ffmode["boolean"]
          bytes[i] <- .rambytes["boolean"]
          lengths[i] <- length(y)
        }else if (is.ffdf(y)){
          types[i] <- "ff"
          v <- tokmod[i]
          #ffmodes[i] <- .ffmode[v]
          bytes[i] <- .rambytes[v]
          lengths[i] <- nrow(y)
        }else if (is.ff(y)){
          types[i] <- "ff"
          v <- vmode(y)
          bytes[i] <- .rambytes[v]
          #ffmodes[i] <- .ffmode[v]
          lengths[i] <- length(y)
        }else{
          types[i] <- "ram"
          v <- vmode(y)
          bytes[i] <- .rambytes[v]
          #ffmodes[i] <- .ffmode[v]
          lengths[i] <- length(y)
        }
      }
    }
  }
  n <- max(lengths)

  if (is.null(chunks)){
    if (is.null(from))
        from <- 1L
    if (is.null(to))
        to <- n
    if (to>=from) {
      if (is.null(by) && is.null(length.out)) {
        if (is.null(RECORDBYTES))
          RECORDBYTES <- sum(bytes)
        b <- BATCHBYTES%/%RECORDBYTES
        if (b == 0L) {
            b <- 1L
            warning("single record does not fit into BATCHBYTES")
        }
        by <- b
      }
      chunks <- chunk(from=from, to=to, by=by, length.out=length.out)
    }else{
      chunks <- NULL
    }
  }
  nchunks <- length(chunks)

  if (nchunks){
    #if (!is.ff(FF_RETURN)){
    #  if (FF_RETURN)
    #    FF_RETURN <- ff(vmode=.vmode[maxffmode(.vmode[ffmodes])], length=n)
    #}
    if (nchunks>1 && (is.null(parallel) || parallel)){

      f <- alist(,)
      f[[2]] <- as.name(loopvar)
      names(f) <- c(loopvar,"")
      f <- as.function(f)
      body(f) <- e
      environment(f) <- parent.frame()

      # sfInit(nostart=TRUE) does not work
      if (!sfIsInit()){
        on.exit(sfStop())
        sfInit(parallel=parallel, cpus=cpus)
      }
      if (any(types=="ff"))
        sfLibrary(ff)
      else if (any(types=="bit"))
        sfLibrary(bit)

      # a little deviation avoiding conflicts with whatever name for the function
      env <- new.env()
      assign(funcvar, f, envir=env)
      eval(substitute(sfExport(x), list(x=funcvar)), envir=env)

      for (i in 1:k){
        if (exists(tokens[i], envir=envir)){
          #fails on letters
          #ex <- substitute(sfExport(x), list(x=tokens[i]))
          #eval(ex, envir=envir)
          sfClusterCall(function(...){assign(...);NULL}, tokens[i], get(tokens[i], envir=envir), env = globalenv(), stopOnError = FALSE)
          if (types[i]=="ff"){
            eval(substitute(sfClusterEval(open(x)), list(x=as.name(tokens[i]))))
          }
        }
      }

      #if (is.ff(FF_RETURN)){
      #  stop("not yet")
      #}else{
        if (method=="ind"){
          ret <- sfLapply(chunks, f)
        }else if (method=="pos"){
          ret <- sfLapply(1:length(chunks), f)
        }else{
          nams <- names(chunks)
          if (is.null(nams))
            stop("chunks have no names")
          ret <- sfLapply(nams, f)
        }
      #}

      sfRemove("funcvar")
      for (i in 1:k){
        if (exists(tokens[i], envir=envir)){
          if (types[i]=="ff"){
            eval(substitute(sfClusterEval(close(x)), list(x=as.name(tokens[i]))))
          }
          sfRemove(tokens[i])
        }
      }
    }else{  # forced sequential
      #we don't use a function in local execution because bit variables would require <<- operator instead <-
      # make sure that f does not find variables in this frame (e.g. using b failed)
      #environment(f) <- parent.frame()
      #ex <- substitute(lapply(x, y), list(x=chunks, y=f))
      #ret <- eval(ex, envir=envir)
      ret <- vector("list", nchunks)
      nams <- names(chunks)
      names(ret) <- nams
      namlist <- list(NULL)
      names(namlist) <- loopvar

      if (method=="ind"){
        for (j in 1:length(chunks)){
          namlist[[1]] <- chunks[[j]]
          ex <- do.call("substitute", list(e, namlist))
          ret[[j]] <- eval(ex, envir=envir)
        }
      }else if (method=="pos"){
        for (j in 1:length(chunks)){
          namlist[[1]] <- j
          ex <- do.call("substitute", list(e, namlist))
          ret[[j]] <- eval(ex, envir=envir)
        }
      }else{
        if (is.null(nams))
          stop("chunks have no names")
        for (j in 1:length(chunks)){
          namlist[[1]] <- nams[[j]]
          ex <- do.call("substitute", list(e, namlist))
          ret[[j]] <- eval(ex, envir=envir)
        }
      }
    }
  }else{
    ret <- NULL
  }

  dif.time <- as.vector(proc.time()[3] - start.time)
  if (VERBOSE)
    cat("TOTAL time=", round(dif.time, 3), "sec\n")
  if (RETURN)
    ret
  else
    invisible()
}
