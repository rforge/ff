\name{sum.integer64}
\alias{all.integer64}
\alias{any.integer64}
\alias{min.integer64}
\alias{max.integer64}
\alias{range.integer64}
\alias{sum.integer64}
\alias{prod.integer64}
\title{
   Summary functions for integer64 vectors
}
\description{
  Summary functions for integer64 vectors. 
  Function 'range' without arguments returns the smallest and largest value of the 'integer64' class.
}
\usage{
\method{all}{integer64}(\dots, na.rm = FALSE)
\method{any}{integer64}(\dots, na.rm = FALSE)
\method{min}{integer64}(\dots, na.rm = FALSE)
\method{max}{integer64}(\dots, na.rm = FALSE)
\method{range}{integer64}(\dots, na.rm = FALSE)
\method{sum}{integer64}(\dots, na.rm = FALSE)
\method{prod}{integer64}(\dots, na.rm = FALSE)
}
\arguments{
  \item{\dots}{ atomic vectors of class 'integer64'}
  \item{na.rm}{ logical scalar indicating whether to ignore NAs }
}
\value{
  \code{\link{all}} and \code{\link{any}} return a logical scalar\cr
  \code{\link{range}} returns a integer64 vector with two elements\cr
  \code{\link{min}}, \code{\link{max}}, \code{\link{sum}} and \code{\link{prod}} return a integer64 scalar
}
\author{
Jens Oehlschl�gel <Jens.Oehlschlaegel@truecluster.com>
}
\keyword{ classes }
\keyword{ manip }
\seealso{ \code{\link{cumsum.integer64}} \code{\link{integer64}}  }
\examples{
  range.integer64()
  range(as.integer64(1:12))
}