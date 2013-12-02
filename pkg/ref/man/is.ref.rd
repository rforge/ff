\name{is.ref}
\alias{is.ref}
\alias{exists.ref}
\title{ checking (for) references }
\description{
  \code{is.ref} checks whether an object inherits from class "ref". \cr
  \code{exists.ref} checks whether an referenced object exists.
}
\usage{
  is.ref(x)
  exists.ref(ref)
}
\arguments{
  \item{x}{ an object that might be a reference }
  \item{ref}{ a reference as returned from \code{\link{ref}} or \code{\link{as.ref}} }
}
\value{
  logical scalar
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{ref}}, \code{\link[base]{exists}}, \code{\link[base]{inherits}}, \code{\link[base]{class}} }
\examples{
  v <- 1
  good.r <- as.ref(v)
  bad.r <- ref("NonExistingObject")
  is.ref(v)
  is.ref(good.r)
  is.ref(bad.r)
  exists.ref(good.r)
  exists.ref(bad.r)
}
\keyword{ programming }
