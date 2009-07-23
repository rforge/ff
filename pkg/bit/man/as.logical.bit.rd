\name{as.logical.bit}
\alias{as.logical.bit}
\alias{as.integer.bit}
\alias{as.double.bit}
\alias{as.which.bit}
\title{ Coercion from bit }
\description{
  Coercing from bit to logical, integer, which.
}
\usage{
\method{as.logical}{bit}(x, \dots)
\method{as.integer}{bit}(x, \dots)
\method{as.double}{bit}(x, \dots)
\method{as.which}{bit}(x, range = NULL, \dots)
}
\arguments{
  \item{x}{ an object of class bit }
  \item{range}{ integer vector of length==2 giving a range restriction for chunked processing }
  \item{\dots}{ further arguments (passed to \code{\link{which}} for the default method, ignored otherwise) }
}
\details{
  \code{as.logical.bit} and \code{as.integer.bit} return a vector of \code{FALSE, TRUE} resp. \code{0,1}.
  \code{as.which.bit} returns a vector of subscripts with class 'which'
  Coercion from bit is quite fast because we use a double loop that fixes each word in a processor register.
}
\value{
  a vector of class 'logical' or 'integer'
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{bit}}, \code{\link{as.bit}}, \code{\link{as.logical}}, \code{\link{as.integer}}, \code{\link{as.which}}, \code{\link{as.bitwhich}}, \code{\link[ff]{as.ff}}, \code{\link[ff]{as.hi}} }
\examples{
  x <- as.bit(c(FALSE, NA, TRUE, rep(TRUE, 9)))
  as.logical(x)
  as.integer(x)
  as.which.bit(x)
}
\keyword{ classes }
\keyword{ logic }
