\name{seq.integer64}
\alias{seq.integer64}
\title{
   integer64: Sequence Generation
}
\description{
  Generating sequence of integer64 values
}
\usage{
\method{seq}{integer64}(from = NULL, to = NULL, by = NULL, length.out = NULL, along.with = NULL, \dots)
}
\arguments{
  \item{from}{ integer64 scalar (in order to dispatch the integer64 method of \code{\link{seq}} }
  \item{to}{ scalar }
  \item{by}{ scalar }
  \item{length.out}{ scalar }
  \item{along.with}{ scalar }
  \item{\dots}{ ignored }
}
\value{
  an integer64 vector with the generated sequence
}
\note{
  In base R \code{\link{:}} currently is not generic and does not dispatch, therefor we make it generic.
}
\author{
Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
}
\keyword{ classes }
\keyword{ manip }
\seealso{ \code{\link{c.integer64}} \code{\link{rep.integer64}} 
          \code{\link{as.data.frame.integer64}} \code{\link{integer64}}  
}
\examples{
  #as.integer64(1):12
  seq(as.integer64(1), 12, 2)
  seq(as.integer64(1), by=2, length.out=6)
}
