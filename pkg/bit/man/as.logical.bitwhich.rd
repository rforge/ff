\name{as.logical.bitwhich}
\alias{as.logical.bitwhich}
\alias{as.integer.bitwhich}
\alias{as.double.bitwhich}
\alias{as.which}
\alias{as.which.default}
\alias{as.which.bitwhich}
\title{ Coercing from bitwhich }
\description{
  Functions for coercing from class \code{\link{bitwhich}}
}
\usage{
\method{as.logical}{bitwhich}(x, \dots)
\method{as.integer}{bitwhich}(x, \dots)
\method{as.double}{bitwhich}(x, \dots)
as.which(x, \dots)
\method{as.which}{default}(x, \dots)
\method{as.which}{bitwhich}(x, \dots)
}
\arguments{
  \item{x}{ an object of class \code{\link{bitwhich}} }
  \item{\dots}{ further arguments }
}
\details{
  Function 'as.integer' converts to positive integers.
}
\value{
  A vector of the desired mode.
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{as.bit.bitwhich}}, \code{\link{as.integer.bit}} }
\examples{
 as.integer(as.bitwhich(c(FALSE, FALSE, TRUE)))
 as.integer(as.bit(c(FALSE, FALSE, TRUE)))
 as.logical(as.bitwhich(c(FALSE, FALSE, TRUE)))
 as.logical(as.bit(c(FALSE, FALSE, TRUE)))
}
\keyword{ classes }
\keyword{ logic }
