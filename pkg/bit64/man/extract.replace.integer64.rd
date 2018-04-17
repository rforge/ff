\name{extract.replace.integer64}
\alias{[.integer64}
\alias{[[.integer64}
\alias{[[<-.integer64}
\alias{[<-.integer64}
\title{
   Extract or Replace Parts of an integer64 vector
}
\description{
  Methods to extract and replace parts of an integer64 vector.
}
\usage{
 \method{[}{integer64}(x, i, \dots)
 \method{[}{integer64}(x, \dots) <- value 
 \method{[[}{integer64}(x, \dots)
 \method{[[}{integer64}(x, \dots) <- value
}
\arguments{
  \item{x}{ an atomic vector }
  \item{i}{ indices specifying elements to extract }
  \item{value}{ an atomic vector with values to be assigned }
  \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
}
\note{
  You should not subscript non-existing elements and not use \code{NA}s as subscripts.
  The current implementation returns \code{9218868437227407266} instead of \code{NA}.
}
\value{
  A vector or scalar of class 'integer64'
}
\author{
Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
}
\keyword{ classes }
\keyword{ manip }
\seealso{ \code{\link{[}} \code{\link{integer64}}  }
\examples{
  as.integer64(1:12)[1:3]
  x <- as.integer64(1:12)
  dim(x) <- c(3,4)
  x
  x[]
  x[,2:3]
  \dontshow{
    r <- c(runif64(1e3, lim.integer64()[1], lim.integer64()[2]), NA, -2:2)
    stopifnot(identical(r, as.integer64(as.bitstring(r))))
  }
}
