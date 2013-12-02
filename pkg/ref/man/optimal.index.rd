\name{optimal.index}
\alias{optimal.index}
\alias{need.index}
\alias{posi.index}
\title{ creating standardized, memory optimized index for subsetting }
\description{
  Function \code{optimal.index} converts an index specification of type \{logical, integer, -integer, character\} into one of \{integer, -integer\} whatever is smaller.
  Function \code{need.index} returns TRUE if the index does represent a subset (and thus indexing is needed).
  Function \code{posi.index} returns positive integers representing the (sub)set.
}
\usage{
optimal.index(i, n=length(i.names), i.names = names(i), i.previous = NULL, strict = TRUE)
need.index(oi)
posi.index(oi)
}
\arguments{
  \item{i}{ the original one-dimensional index }
  \item{n}{ length of the indexed dimension  (potential iMax if i where integer), not necessary if names= is given }
  \item{i.names}{ if i is character then names= represents the names of the indexed dimension }
  \item{i.previous}{ if i.previous= is given, the returned index represents \code{x[i.previous][i] == x[optimal.index]} rather than \code{x[i] == x[optimal.index]} }
  \item{strict}{ set to FALSE to allow for NAs and duplicated index values, but see details }
  \item{oi}{ a return value of \code{optimal.index} }
}
\details{
  When strict=TRUE it is expected that i does not contain NAs and no duplicated index values. Then \code{ identical(x[i], x[optimal.index(i, n=length(x), i.names=names(x))$i]) == TRUE } . \cr
  When strict=FALSE i may contain NAs and/or duplicated index values. In this case length optimisation is not performed and optimal.index always returns positive integers.
}
\note{
  \code{need.index(NULL)} is defined and returns FALSE. This allows a function to have an optional parameter oi=NULL and to determine the need of subsetting in one reqest.
}
\value{
  \code{optimal.index} returns the index oi with attributes n=n and ni=length(x[optimal.index]) (which is n-length(i) when i is negative).
  \code{need.index} returns a logical scalar
  \code{posi.index}  returns a vector of positive integers (or integer(0))
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{refdata}}
          \cr please ignore the following unpublished links: ids2index, shift.index, startstop2index
}
\examples{
  l <- letters
  names(l) <- letters
  stopifnot({i <- 1:3 ; identical(l[i], l[optimal.index(i, n=length(l))])})
  stopifnot({i <- -(4:26) ; identical(l[i], l[optimal.index(i, n=length(l))])})
  stopifnot({i <- c(rep(TRUE, 3), rep(FALSE, 23)) 
    identical(l[i], l[optimal.index(i, n=length(l))])})
  stopifnot({i <- c("a", "b", "c")
    identical(l[i], l[optimal.index(i, i.names=names(l))])})
  old.options <- options(show.error.messages=FALSE)
    stopifnot(inherits(try(optimal.index(c(1:3, 3), n=length(l))), "try-error"))
  options(old.options)
  stopifnot({i <- c(1:3, 3, NA)
    identical(l[i], l[optimal.index(i, n=length(l), strict=FALSE)])})
  stopifnot({i <- c(-(4:26), -26)
    identical(l[i], l[optimal.index(i, n=length(l), strict=FALSE)])})
  stopifnot({i <- c(rep(TRUE, 3), rep(FALSE, 23), TRUE, FALSE, NA)
    identical(l[i], l[optimal.index(i, n=length(l), strict=FALSE)])})
  stopifnot({i <- c("a", "b", "c", "a", NA)
    identical(l[i], l[optimal.index(i, i.names=names(l), strict=FALSE)])})
  rm(l)
}
\keyword{ utilities }
\keyword{ manip }
