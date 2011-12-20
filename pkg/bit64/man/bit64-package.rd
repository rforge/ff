\name{bit64-package}
\alias{bit64-package}
\alias{bit64}
\alias{integer64}
\alias{is.integer64}
\alias{is.vector.integer64}
\alias{as.vector.integer64}
\alias{length<-.integer64}
\alias{print.integer64}
\docType{package}
\title{
   A S3 class for vectors of 64bit integers
}
\description{
Package 'bit64' provides S3 atomic 64bit (signed) integers, coercion from and 
to logicals, integers, doubles, characters and the usual vector and summary 
functions. \cr

With 'integer64' vectors you can store very large integers at the expense
of 64 bits only, which is by factor 7 better than 'int64' from package 'int64'.
Due to the smaller memory footprint, the usual vector architecture and avoidance 
of S4 classes, most operations are one to three orders of magnitude faster while 
being more compatible: it only requires the more basic S3 class system. Example 
speedups are: 4x for serialization, 100x for adding, 300x for coercion, 2000x 
for object creation. \cr
}
\usage{
 integer64(length)
 \method{is}{integer64}(x)
 \method{length}{integer64}(x) <- value
 \method{print}{integer64}(x, quote=FALSE, \dots)
}
\arguments{
  \item{length}{ length of vector using \code{\link{integer}} }
  \item{x}{ an integer64 vector }
  \item{value}{ an integer64 vector of values to be assigned }
  \item{quote}{ logical, indicating whether or not strings should be printed with surrounding quotes. }
  \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
}
\details{
\tabular{ll}{
   Package: \tab bit64\cr
   Type: \tab Package\cr
   Version: \tab 0.5.0\cr
   Date: \tab 2011-12-12\cr
   License: \tab GPL-2\cr
   LazyLoad: \tab yes\cr
   Encoding: \tab latin1\cr
}

Index:
\tabular{rrl}{
   \bold{creating,testing,printing} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{integer64}} \tab \code{\link{integer}} \tab create zero atomic vector \cr
   \code{\link{rep.integer64}} \tab \code{\link{rep}} \tab  \cr
   \code{\link{seq.integer64}} \tab \code{\link{seq}} \tab  \cr
   \code{\link{is.integer64}} \tab \code{\link{is}} \tab  \cr
   \code{\link{is.vector.integer64}} \tab \code{\link{is.vector}} \tab  \cr
   \code{\link{length<-.integer64}} \tab \code{\link{length<-}} \tab  \cr
   \code{\link{print.integer64}} \tab \code{\link{print}} \tab  \cr
 \cr
   \bold{coercing to integer64} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{as.integer64}} \tab   \tab generic \cr
   \code{\link{as.integer64.character}} \tab \code{\link{character}} \tab  \cr
   \code{\link{as.integer64.double}} \tab \code{\link{double}} \tab  \cr
   \code{\link{as.integer64.integer}} \tab \code{\link{integer}} \tab  \cr
   \code{\link{as.integer64.integer64}} \tab \code{\link{integer64}} \tab  \cr
   \code{\link{as.integer64.logical}} \tab \code{\link{logical}} \tab  \cr
   \code{\link{as.integer64.NULL}} \tab \code{\link{NULL}} \tab  \cr
 \cr
   \bold{coercing from integer64} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{as.bitstring}} \tab \code{\link{as.bitstring}} \tab generic \cr
   \code{\link{as.bitstring.integer64}} \tab  \tab  \cr
   \code{\link{as.character.integer64}} \tab \code{\link{as.character}} \tab  \cr
   \code{\link{as.double.integer64}} \tab \code{\link{as.double}} \tab  \cr
   \code{\link{as.integer.integer64}} \tab \code{\link{as.integer}} \tab  \cr
   \code{\link{as.logical.integer64}} \tab \code{\link{as.logical}} \tab  \cr
   \code{\link{as.vector.integer64}} \tab \code{\link{as.vector}} \tab  \cr
 \cr
   \bold{data structures} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{c.integer64}} \tab \code{\link{c}} \tab concatenate \cr
   \code{\link{cbind.integer64}} \tab \code{\link{cbind}} \tab column bind \cr
   \code{\link{rbind.integer64}} \tab \code{\link{rbind}} \tab row bind \cr
   \code{\link{as.data.frame.integer64}} \tab \code{\link{data.frame}} \tab coerce vector to column \cr
 \cr
   \bold{subscripting} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{[.integer64}} \tab \code{\link{[}} \tab vector and array extract \cr
   \code{\link{[<-.integer64}} \tab \code{\link{[<-}} \tab vector and array assign \cr
   \code{\link{[[.integer64}} \tab \code{\link{[[}} \tab scalar extract \cr
   \code{\link{[[<-.integer64}} \tab \code{\link{[[<-}} \tab scalar assign \cr
 \cr
   \bold{binary operators} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{+.integer64}} \tab \code{\link{+}} \tab returns integer64 \cr
   \code{\link{-.integer64}} \tab \code{\link{-}} \tab returns integer64 \cr
   \code{\link{*.integer64}} \tab \code{\link{*}} \tab returns integer64 \cr
   \code{\link{^.integer64}} \tab \code{\link{^}} \tab returns double \cr
   \code{\link{/.integer64}} \tab \code{\link{/}} \tab returns double \cr
   \code{\link{\%/\%.integer64}} \tab \code{\link{\%/\%}} \tab returns integer64 \cr
   \code{\link{\%\%.integer64}} \tab \code{\link{\%\%}} \tab returns integer64 \cr
 \cr
   \bold{comparison operators} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{==.integer64}} \tab \code{\link{==}} \tab  \cr
   \code{\link{!=.integer64}} \tab \code{\link{!=}} \tab  \cr
   \code{\link{<.integer64}} \tab \code{\link{<}} \tab  \cr
   \code{\link{<=.integer64}} \tab \code{\link{<=}} \tab  \cr
   \code{\link{>.integer64}} \tab \code{\link{>}} \tab  \cr
   \code{\link{>=.integer64}} \tab \code{\link{>=}} \tab  \cr
 \cr
   \bold{logical operators} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{!.integer64}} \tab \code{\link{!}} \tab  \cr
   \code{\link{&.integer64}} \tab \code{\link{&}} \tab  \cr
   \code{\link{|.integer64}} \tab \code{\link{|}} \tab  \cr
   \code{\link{xor.integer64}} \tab \code{\link{xor}} \tab  \cr
 \cr
   \bold{math functions} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{is.na.integer64}} \tab \code{\link{is.na}} \tab returns logical \cr
   \code{\link{format.integer64}} \tab \code{\link{format}} \tab returns character \cr
   \code{\link{abs.integer64}} \tab \code{\link{abs}} \tab returns integer64 \cr
   \code{\link{sign.integer64}} \tab \code{\link{sign}} \tab returns integer64 \cr
   \code{\link{log.integer64}} \tab \code{\link{log}} \tab returns double \cr
   \code{\link{log10.integer64}} \tab \code{\link{log10}} \tab  returns double \cr
   \code{\link{log2.integer64}} \tab \code{\link{log2}} \tab  returns double \cr
   \code{\link{sqrt.integer64}} \tab \code{\link{sqrt}} \tab  returns double \cr
   \code{\link{ceiling.integer64}} \tab \code{\link{ceiling}} \tab returns integer64 \cr
   \code{\link{floor.integer64}} \tab \code{\link{floor}} \tab returns integer64 \cr
   \code{\link{trunc.integer64}} \tab \code{\link{trunc}} \tab returns integer64 \cr
   \code{\link{round.integer64}} \tab \code{\link{round}} \tab returns integer64 \cr
   \code{\link{signif.integer64}} \tab \code{\link{signif}} \tab NOT IMPLEMENTED \cr
 \cr
   \bold{cumulative functions} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{cummin.integer64}} \tab \code{\link{cummin}} \tab x \cr
   \code{\link{cummax.integer64}} \tab \code{\link{cummax}} \tab x \cr
   \code{\link{cumsum.integer64}} \tab \code{\link{cumsum}} \tab x \cr
   \code{\link{cumprod.integer64}} \tab \code{\link{cumprod}} \tab x \cr
   \code{\link{diff.integer64}} \tab \code{\link{diff}} \tab x \cr
 \cr
   \bold{summary functions} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{range.integer64}} \tab \code{\link{range}} \tab also returns valid range \cr
   \code{\link{min.integer64}} \tab \code{\link{min}} \tab  \cr
   \code{\link{max.integer64}} \tab \code{\link{max}} \tab  \cr
   \code{\link{sum.integer64}} \tab \code{\link{sum}} \tab  \cr
   \code{\link{prod.integer64}} \tab \code{\link{prod}} \tab  \cr
   \code{\link{all.integer64}} \tab \code{\link{all}} \tab  \cr
   \code{\link{any.integer64}} \tab \code{\link{any}} \tab  \cr
   \bold{helper functions} \tab \bold{see also}          \tab \bold{description} \cr
   \code{\link{minusclass}} \tab \code{\link{minusclass}} \tab removing class attritbute \cr
   \code{\link{plusclass}} \tab \code{\link{plusclass}} \tab inserting class attribute \cr
   \code{\link{binattr}} \tab \code{\link{binattr}} \tab define binary op behaviour \cr
}
}
\value{
  \code{integer64} returns a vector of 'integer64', 
   i.e. a vector of \code{\link{double}} decorated with class 'integer64'.
}
\author{
Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
Maintainer: Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
}
\note{
  xx
}
\keyword{ package }
\keyword{ classes }
\keyword{ manip }
\seealso{ \code{\link{integer}} in base R and \code{\link[int64]{int64}} in package 'int64' }
\examples{
  x <- integer64(12)                           # create integer64 vector

  \dontrun{
    message("\nEven for a single boolean operation transforming logical to bit pays off")

  }
}
