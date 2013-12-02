\name{ref}
\alias{ref}
\alias{print.ref}
\title{ creating references }
\description{
  Package \code{ref} implements references for S (R/S+).
  Function \code{ref} creates references.
  For a memory efficient wrapper to matrixes and data.frames which allows nested subsetting see \code{\link{refdata}}
}
\usage{
ref(name, loc = parent.frame())
}
\arguments{
  \item{name}{ name of an (existing) object to be referenced }
  \item{loc}{ location of the referenced object, i.e. an environment in R or a frame in S+ }
}
\details{
  In S (R/S+) paramters are passed by value and not by reference.
  When passing big objects, e.g. in recursive algorithms, this can quickly eat up memory.
  The functions of package \code{ref} allow to pass references in function calls.
  The implementation is purely S and should work in R and S+.
  Existence of the referenced object is not checked by function \code{ref}.
  Usually \code{\link{as.ref}} is more convenient and secure to use.
  There is also a print method for references.
}
\value{
  a list with
  \item{ name }{  name of the referenced object }
  \item{ loc }{ location of the referenced object, i.e. an environment in R or a frame in S+ }
  and class "ref"
}
\note{
 Using this type of references is fine for prototyping in a non-objectoriented programming style.
 For bigger projects and safer programming you should consider the approach suggested by Henrik Bengtsson
 at \url{http://www.maths.lth.se/help/R/ImplementingReferences} (announced to be released as package "oo" or "classes")
}
\section{WARNING}{
 Usually functions in S have no side-effects except for the main effect of returning something.
 Working with references circumvents this programming style and can have considerable side-effects.
 You are using it at your own risk.
}
\section{R 1.8 WARNING}{
 Changing parts of referenced objects has been slowed down by order of magnitudes since R version 1.8, see performance test examples on the help page for \code{\link{deref}}.
 Hopefully the old performance can be restored in future versions.
}
\section{S+ WARNING}{
 Package ref should generally work under R and S+. However, when changing very small parts of referenced objects, using references under S+ might be inefficient (very slow with high temporary memory requirements).
}
\section{Historical remarks}{
  This package goes back to an idea submitted April 9th 1997 and code offered on August 17th 1997 on s-news.
  The idea of implementing references in S triggered an intense discussion on s-news. The status reached in 1997 can be summarized as follows:\cr
  \enumerate{
    \item{\bold{advantage}}{passing by reference can save memory compared to passing by value}
    \item{\bold{disadvantage}}{passing by reference is more dangerous than passing by value}
    \item{\bold{however}}{the implementation is purely in S, thus rather channels existing danger than adding new danger}
    \item{\bold{restriction}}{assigning to a subsetted part of a referenced object was inefficient in S+ (was S+ version 3)}
  }
  Due to the last restriction the code was never submitted as a mature library.
  Now in 2003 we have a stable version of R and astonishingly assigning to a subsetted part of a referenced object \emph{can} be implemented efficient.
  This shows what a great job the R core developers have done. In the current version the set of functions for references was dramatically simplified, the main differences to 1997 beeing the following:
  \enumerate{
    \item{\bold{no idempotence}}{ \code{\link{deref}} and  \code{\link{deref<-}} now are a simple function and no longer are methods. This decision was made due top performance reasons. As a consequence, \code{deref()} no longer is idempotent: one has to know whether an object is a reference. Function \code{\link{is.ref}} provides a test. }
    \item{\bold{no write protection}}{ The 1997 suggestion included a write protection attribute of references, allowing for read only references and allowing for references that could only be changed by functions that know the access code. Reasons for this: there is no need for readonly references (due to copy on modify) and oop provides better mechanisms for security. }
    \item{\bold{no static variables}}{ The suggestion made in 1997 did include an implementation of static variables realized as special cases of references with a naming convention which reduced the risc of name collisions in the 1997 practice of assigning to frame 0. Now R has namespaces and the oop approach of Henrik Bengtsson using environments is to be prefered over relatively global static objects. }
  }
}
\author{ Jens Oehlschlägel }
\seealso{
 \code{\link{as.ref}}, \code{\link{deref}}, \code{\link{deref<-}}, \code{\link{exists.ref}}, \code{\link{is.ref}}, \code{\link{print.ref}}, \code{\link{HanoiTower}}
}
\examples{
  v <- 1
  r <- ref("v")
  r
  deref(r)
  cat("For more examples see ?deref\n")
}
\keyword{ programming }
