\name{rlepack}
\alias{rlepack}
\alias{rleunpack}
\alias{rev.rlepack}
\alias{unique.rlepack}
\title{ Hybrid Index, rle-pack utilities }
\description{
  Basic utilities for rle packing and unpacking and apropriate methods for \code{\link{rev}} and \code{\link{unique}}.
}
\usage{
rlepack(x, pack = TRUE)
rleunpack(x)
\method{rev}{rlepack}(x)
\method{unique}{rlepack}(x, incomparables = FALSE, \dots)
}
\arguments{
  \item{x}{ an integer vector }
  \item{pack}{ FALSE to suppress packing }
  \item{incomparables}{ just to keep R CMD CHECK quiet (not used) }
  \item{\dots}{ just to keep R CMD CHECK quiet (not used) }
}
\value{
  A list with components
  \item{ first }{ the first element of the packed sequence }
  \item{ dat   }{ either an object of class \code{\link{rle}} or the complete input vector \code{x} if rle-packing is not efficient }
  \item{ last  }{ the last element of the packed sequence }
}
\author{ Jens Oehlschlägel }
\note{
  Only for sorted input \code{unique.rlepack(rlepack(x))} will be the same as \code{rlepack(unique(x))}, furthermore \code{rlepack(unique(x))} is faster.
  Therefore we only use \code{unique.rlepack} only where we have rlepack format from \code{\link[ff]{hi}}
}
\seealso{ \code{\link[ff]{hi}}, \code{\link{intrle}}, \code{\link{rle}}, \code{\link{rev}}, \code{\link{unique}} }
\examples{
  x <- rlepack(rep(0L, 10))
}
\keyword{ IO }
\keyword{ data }
