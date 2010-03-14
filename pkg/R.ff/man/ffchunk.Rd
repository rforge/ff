\name{ffchunk}
\alias{ffchunk}
\title{
  Chunked looping
}
\description{
  Evaluate an indexed expression in a chunked loop, potentially in parallel
}
\usage{
ffchunk(x = NULL
, chunks = NULL
, from = NULL
, to = NULL
, by = NULL
, length.out = NULL
, envir = parent.frame()
, loopvar = "i"
, funcvar = "chunkFUN"
, parallel = NULL
, cpus = NULL
, RETURN = NULL
, RECORDBYTES = NULL
, BATCHBYTES = getOption("ffbatchbytes")
, VERBOSE = FALSE
)
}
\arguments{
  \item{x}{an expression that can be evaluated in chunks identified by an index named according to argument loopvar}
  \item{chunks}{ optionally a list with range indices as created by \code{\link[=chunk.ff_vector]{chunk}}}
  \item{from}{ optionally the position where to start the chunking (ignored if argument chunks is not NULL)}
  \item{to}{ optionally the position where to stop the chunking (ignored if argument chunks is not NULL)}
  \item{by}{ optionally the size of a chunk  (ignored if argument chunks is not NULL)}
  \item{length.out}{ optionally the number of chunks  (ignored if argument chunks is not NULL)}
  \item{envir}{ the environment where to evaluate the expression x }
  \item{loopvar}{ the name of the variable used for the chunk index (must not conflict with other object names) }
  \item{funcvar}{ the name of the function realizing the expression on snowfall slaves }
  \item{parallel}{ set to FALSE to force local sequential evaluation }
  \item{cpus}{ the number of cpus (ignored if snowfall cluster is already initialized) }
  \item{RETURN}{ set to TRUE or FALSE to force/suppress returning from the expression }
  \item{RECORDBYTES}{ the number of bytes required for processing one single element of the loop, used for automatic chunk size determination }
  \item{BATCHBYTES}{ the maximum number of bytes available for processing one chunk }
  \item{VERBOSE}{ set to TRUE for measuring execution time }
}
\details{
\code{ffchunk} automatically estimates the size of the chunks based on RECORDBYTES and BATCHBYTES.
If not parallel=FALSE and if we have more than one chunk then the chunking is done in parallel.
Currently snowfall is used.
If no snowfall cluster is initialized, \code{ffchunk} will call \code{\link[snowfall]{sfInit}} and \code{\link[snowfall]{sfStop}} on.exit.
\code{ffchunk} makes sure that packages \code{bit} and/or \code{ff} are loaded if needed.
\code{ffchunk} also copies all objects used in the expression to the snowfall slaves.
}
\value{
Either invisible() or a list with the returned values per chunk.
Argument RETURN decides whether a list is returned.
If RETURN is NULL then it is determined automatically:
if the expression x contains a call to return then RETURN is set to TRUE,
otherwise if an "<-" assigment is found, RETURN is set to FALSE.
}
\author{
  Jens Oehlschlägel
}
\seealso{
  \code{\link[ff]{ffvecapply}}, \code{\link[ff]{chunk}}
}
\examples{
  n <- 1e3
  a <- ff(vmode="double", length=n)
  b <- ff(vmode="double", length=n)
  d <- ffdf(a,b)
  z <- d$a

  ffchunk({d$a[i] <- d$b[i] + rnorm(sum(i))}, length=10, VERBOSE=TRUE)

  sfInit(cpus=2)
  ffchunk({d$a[i] <- d$b[i] + rnorm(sum(i))}, length=10, VERBOSE=TRUE)
  sfStop()

  ffchunk(summary(d$a[i]), length=10, VERBOSE=TRUE)
}
\keyword{ iteration }
\keyword{ IO }
\keyword{ data }
