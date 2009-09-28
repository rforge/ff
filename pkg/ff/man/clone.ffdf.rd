\name{clone.ffdf}
\Rdversion{1.1}
\alias{clone.ffdf}
\title{
Cloning ffdf objects
}
\description{
clone physically duplicates ffdf objects
}
\usage{
clone.ffdf(x, ...)
}
\arguments{
  \item{x}{an \code{\link{ffdf}} }
  \item{\dots}{ further arguments passed to \code{\link{clone}} (usually not usefull) }
}
\details{
  Creates a deep copy of an ffdf object by cloning all \code{\link[=physical.ffdf]{physical}} components including the \code{\link[=row.names.ffdf]{row.names}}
}
\value{
  An object of type \code{\link{ffdf}}
}
\author{
  Jens Oehlschlägel
}
\seealso{
  \code{\link{clone}}, \code{\link{ffdf}}
}
\examples{
  x <- as.ffdf(data.frame(a=1:26, b=letters))

  cat("Here we change the content of both x and y by reference\n")
  y <- x
  x$a[1] <- -1
  y$a[1]

  cat("Here we change the content only of x because y is a deep copy\n")
  y <- clone(x)
  x$a[2] <- -2
  y$a[2]
  rm(x, y); gc()
}
\keyword{ IO }
\keyword{ data }
