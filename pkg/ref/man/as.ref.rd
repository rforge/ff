\name{as.ref}
\alias{as.ref}
\title{ coercing to reference }
\description{
  This function RETURNs a reference to its argument.
}
\usage{
as.ref(obj)
}
\arguments{
  \item{obj}{ an object existing in the current environment/frame }
}
\value{
  an object of class "ref"
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{ref}}, \code{\link{deref}} }
\examples{
  v <- 1
  r <- as.ref(v)
  r
  deref(r)
}
\keyword{ programming }
