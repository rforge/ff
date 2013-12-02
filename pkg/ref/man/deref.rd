\name{deref}
\alias{deref}
\alias{deref<-}
\title{ dereferencing references }
\description{
  This functions allow to access a referenced object. \code{deref(ref)} returns the object, and \code{deref(ref) <- value} assigns to the referenced object.
}
\usage{
deref(ref)
deref(ref) <- value
#the following does not pass R CMD CHECK
#deref<-(ref, value)
#deref(ref)[1] <- value  # subsetted assignment appears to be inefficent in S+.
}
\arguments{
  \item{ref}{ a reference as returned by \code{\link{ref}} or \code{\link{as.ref}} }
  \item{value}{ a value to be assigned to the reference }
}
\details{
  \code{deref} and \code{deref<-} provide convenient access to objects in other environments/frames.
  In fact they are wrappers to \code{\link{get}} and \code{\link{assign}}.
  However, convenient does not neccessarily means efficient.
  If performance is an issue, the direct use of \code{\link{new.env}}, \code{\link{substitute}} and \code{\link{eval}} may give better results.
  See the examples below.
}
\value{
  \code{deref} returns the referenced object.
  \cr \code{"deref<-"} returns a reference to the modified object, see \code{\link{ref}}.
}
\references{ Writing R Extensions }
\author{ Jens Oehlschlägel }
\note{ Subsetted assignment appears to be inefficent in S+. Note the use of \code{\link{substitute}} in the examples. }
\seealso{ \code{\link{ref}}, \code{\link{as.ref}},  \code{\link[base]{get}},  \code{\link[base]{assign}},  \code{\link[base]{substitute}},  \code{\link[base]{eval}} }
\examples{
  # Simple usage example
  x <- cbind(1:5, 1:5)          # take some object
  rx <- as.ref(x)               # wrap it into a reference
  deref(rx)                     # read it through the reference
  deref(rx) <- rbind(1:5, 1:5)  # replace the object in the reference by another one
  deref(rx)[1, ]                # read part of the object
  deref(rx)[1, ] <- 5:1         # replace part of the object
  deref(rx)                     # see the change
  cat("For performance test examples see ?deref\n")

 \dontrun{
  ## Performance test examples showing actually passing by reference
  # define test matrix size of nmatrix by nmatrix
  nmatrix <- 1000
  # you might want to use less loops in S+
  # you might want more in R versions before 1.8
  nloop   <- 10     

  # Performance test using ref
  t1 <- function(){ # outer function
    m <- matrix(nrow=nmatrix, ncol=nmatrix)
    a <- as.ref(m)
      t2(a)
    m[1,1]
  }
  # subsetting deref is slower (by factor 75 slower since R 1.8 compared to previous versions
  # , and much, much slower in S+) ...
  t2 <- function(ref){
    cat("timing", timing.wrapper(
      for(i in 1:nloop)
        deref(ref)[1,1] <- i
    ), "\n")
  }
  if (is.R())gc()
  t1()
  # ... than using substitute
  t2 <- function(ref){
    obj <- as.name(ref$name)
    loc <- ref$loc
    cat("timing", timing.wrapper(
      for(i in 1:nloop)
        eval(substitute(x[1,1] <- i, list(x=obj, i=i)), loc)
    ), "\n")
  }
  if (is.R())gc()
  t1()


  # Performance test using Object (R only)
  # see Henrik Bengtsson package(oo)
  Object <- function(){
    this <- list(env.=new.env());
    class(this) <- "Object";
    this;
  }
  "$.Object" <- function(this, name){
    get(name, envir=unclass(this)$env.);
  }
  "$<-.Object" <- function(this, name, value){
    assign(name, value, envir=unclass(this)$env.);
    this;
  }
  # outer function
  t1 <- function(){
    o <- Object()
    o$m <- matrix(nrow=nmatrix, ncol=nmatrix)
      t2(o)
    o$m[1,1]
  }
  # subsetting o$m is slower ...
  t2 <- function(o){
    cat("timing", timing.wrapper(
      for(i in 1:nloop)
        o$m[1,1] <- i
    ), "\n")
  }
  if (is.R())gc()
  t1()
  # ... than using substitute
  t2 <- function(o){
    env <- unclass(o)$env.
    cat("timing", timing.wrapper(
      for(i in 1:nloop)
        eval(substitute(m[1,1] <- i, list(i=i)), env)
    ), "\n")
  }
  if (is.R())gc()
  t1()

  }
}
\keyword{ programming }
