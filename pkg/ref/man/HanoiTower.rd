\name{HanoiTower}
\alias{HanoiTower}
\alias{move.HanoiTower}
\alias{print.HanoiTower}
\alias{plot.HanoiTower}
\title{ application example for references }
\description{
  This is an example for using references in S (R/S+) with package \code{ref}.
  \code{HanoiTower} implements a recursive algorithm solving the Hanoi tower problem.
  It is implemented such that the recursion can be done either by passing the HanoiTower \emph{by reference} or \emph{by value} to the workhorse function \code{move.HanoiTower}.
  Furthermore you can choose whether recursion should use \code{\link{Recall}} or should directly call \code{move.HanoiTower}.
  As the HanoiTower object is not too big, it can be extended by some garbage MBytes, that will demonstrate the advantage of passing references instead of values.
  The deeper we recurse, the more memory we waist by passing values (and the more memory we save by passing references).
  Functions \code{move.HanoiTower} and \code{print.HanoiTower} are internal (not intended to be called by the user directly).
}
\usage{
  HanoiTower(n = 5
  , parameter.mode = c("reference", "value")[1]
  , recursion.mode = c("recall", "direct")[1]
  , garbage = 0
  , print = FALSE
  , plot = TRUE
  , sleep = 0
  )
}
\arguments{
  \item{n}{ number of slices }
  \item{parameter.mode}{ one of "reference" or "value" deciding how to pass the HanoiTower object }
  \item{recursion.mode}{ one of "recall" or "direct" deciding how to call recursively }
  \item{garbage}{ no. of bytes to add to the HanoiTower size }
  \item{print}{ TRUE print the HanoiTower changes }
  \item{plot}{ FALSE not to plot the HanoiTower changes }
  \item{sleep}{ no. of seconds to wait between HanoiTower changes for better monitoring of progress }
}
\details{
  The Hanoi Tower problem can be described as follows: you have n slices of increasing size placed on one of three locations a,b,c such that the biggest slice is at the bottom, the next biggest slice on top of it and so forth with the smallest slice as the top of the tower.
  Your task is to move all slices from one stick to the other, but you are only allowed to move one slice at a time and you may never put a bigger slice on top of a smaller one.
  The recursive solution is: to move n slices from a to c you just need to do three steps: move n-1 slices to b, move the biggest slice to c and move n-1 slices from b to c. If n equals 1, just move from a to c.
}
\value{
  invisible()
}
\author{ Jens Oehlschlägel }
\seealso{ \code{\link{ref}}, \code{\link[base]{Recall}} }

\examples{
    HanoiTower(n=2)

 \dontrun{
    # small memory examples
    HanoiTowerDemoBytes <- 0
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "reference"
    , recursion.mode  = "direct"
    , garbage = HanoiTowerDemoBytes
    )
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "reference"
    , recursion.mode  = "recall"
    , garbage = HanoiTowerDemoBytes
    )
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "value"
    , recursion.mode  = "direct"
    , garbage = HanoiTowerDemoBytes
    )
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "value"
    , recursion.mode  = "recall"
    , garbage = HanoiTowerDemoBytes
    )
    rm(HanoiTowerDemoBytes)

    # big memory examples
    HanoiTowerDemoBytes <- 100000
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "reference"
    , recursion.mode  = "direct"
    , garbage = HanoiTowerDemoBytes
    )
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "reference"
    , recursion.mode  = "recall"
    , garbage = HanoiTowerDemoBytes
    )
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "value"
    , recursion.mode  = "direct"
    , garbage = HanoiTowerDemoBytes
    )
    if (is.R())
      gc()
    HanoiTower(
      parameter.mode  = "value"
    , recursion.mode  = "recall"
    , garbage = HanoiTowerDemoBytes
    )
    rm(HanoiTowerDemoBytes)
  }
}
\keyword{ programming }
