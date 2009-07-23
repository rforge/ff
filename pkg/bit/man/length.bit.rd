\name{length.bit}
\alias{length.bit}
\alias{length.bitwhich}
\alias{length.ri}
\alias{length<-.bit}
\alias{length<-.bitwhich}
\title{ Getting and setting length of a bit vector }
\description{
  Query the number of bits in a bit vector or change the number of bits in a bit vector.
}
\usage{
\method{length}{ri}(x)
\method{length}{bit}(x)
\method{length}{bitwhich}(x)
\method{length}{bit}(x) <- value
\method{length}{bitwhich}(x) <- value  # not allowed
}
\arguments{
  \item{x}{ a bit vector }
  \item{value}{ the new number of bits }
}
\details{
  Note that no explicit initialization is done.
  As a consequence, when you first decrease and then increase length you might find that some 'new' bits are already \code{TRUE}.
  Note that assigning a new length to a \code{\link{bitwhich}} is not allowed.
}
\value{
  A bit vector with the new length
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{length}}, \code{\link{bit}}, \code{\link{bitwhich}}  }
\examples{
  x <- bit(32)
  length(x)
  x[c(1, 32)] <- TRUE
  length(x) <- 16
  x
  length(x) <- 32
  x
}
\keyword{ classes }
\keyword{ logic }
