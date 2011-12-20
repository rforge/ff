# /*
# R-Code
# S3 atomic 64bit integers for R
# (c) 2011 Jens Oehlschägel
# Licence: GPL2
# Provided 'as is', use at your own risk
# Created: 2011-12-11
# Last changed:  2011-12-11
#*/

if (FALSE){

message("== Differences to packages int64 ==\n")
require(bit64)
require(int64)

message("-- integer64 is atomic --\n")
is.atomic(integer64())
is.atomic(int64())
str(integer64(3))
str(int64(3))

message("-- integer64 needs 7x less RAM than int64 (and twice the RAM of integer as it should be) --\n")
as.vector(object.size(int64(1e6))/object.size(integer64(1e6)))

message("-- the following timings are rather conservative since timings of integer64 include garbage collection -- due to looped calls\n")
message("-- integer64 creates 2000x faster (and 3x the time of integer) --\n")
system.time(int64(1e7))*10/system.time(for(i in 1:10)integer64(1e7))
system.time(for(i in 1:10)integer64(1e7))/system.time(for(i in 1:10)integer(1e7))

i32 <- sample(1e6)
d64 <- as.double(i32)

message("-- integer64 coerces 300x faster (and 2x the time of coercing to integer) --\n")
system.time(I64 <- as.int64(d64))*1000/system.time(for(i in 1:1000)i64 <- as.integer64(d64))
system.time(for(i in 1:1000)i64 <- as.integer64(d64))/system.time(for(i in 1:1000)i32 <- as.integer(d64))

message("-- integer64 serializes 4x faster than int64 (and less than 2x the time of integer or double) --\n")
system.time(for(i in 1:10)serialize(I64, NULL))/system.time(for(i in 1:10)serialize(i64, NULL))
system.time(for(i in 1:10)serialize(i64, NULL))/system.time(for(i in 1:10)serialize(i32, NULL))
system.time(for(i in 1:10)serialize(i64, NULL))/system.time(for(i in 1:10)serialize(d64, NULL))

message("-- integer64 adds 100x faster than int64 (and less than 2x the time of integer or double) --\n")
system.time(for(i in 1:10)I64+I64)*10/system.time(for(i in 1:100)i64+i64)
system.time(for(i in 1:100)i64+i64)/system.time(for(i in 1:100)i32+i32)
system.time(for(i in 1:100)i64+i64)/system.time(for(i in 1:100)d64+d64)

message("-- integer64 sums 10x faster than int64 (and at about the same speed as integer and double) --\n")
system.time(for(i in 1:100)sum(I64))/system.time(for(i in 1:100)sum(i64))
system.time(for(i in 1:100)sum(i64))/system.time(for(i in 1:100)sum(i32))
system.time(for(i in 1:100)sum(i64))/system.time(for(i in 1:100)sum(d64))

message("-- integer64 diffs 5x faster than integer and double (int64 version 1.0 does not support diff) --\n")
system.time(for(i in 1:10)diff(i64, lag=2L, differences=2L))/system.time(for(i in 1:10)diff(i32, lag=2L, differences=2L))
system.time(for(i in 1:10)diff(i64, lag=2L, differences=2L))/system.time(for(i in 1:10)diff(d64, lag=2L, differences=2L))

message("-- integer64 subscripts 50x faster than int64 (and at the same speed as integer) --\n")
system.time(for(i in 1:100)I64[sample(1e6, 1e3)])/system.time(for(i in 1:100)i64[sample(1e6, 1e3)])
system.time(for(i in 1:100)i64[sample(1e6, 1e3)])/system.time(for(i in 1:100)i32[sample(1e6, 1e3)])

message("-- integer64 assigns 100x faster than int64 (and 6x slower than integer) --\n")
system.time(for(i in 1:100)I64[sample(1e6, 1e3)] <- 1:1e3)/system.time(for(i in 1:100)i64[sample(1e6, 1e3)] <- 1:1e3)
system.time(for(i in 1:100)i64[sample(1e6, 1e3)] <- 1:1e3)/system.time(for(i in 1:100)i32[sample(1e6, 1e3)] <- 1:1e3)

message("-- integer64 coerces 4x faster to data.frame than int64(and factor 65 slower than integer) --\n")
system.time(dfI64<-data.frame(a=I64, b=I64, c=I64))/system.time(dfi64<-data.frame(a=i64, b=i64, c=i64))
system.time(dfi64<-data.frame(a=i64, b=i64, c=i64))/system.time(dfi32<-data.frame(a=i32, b=i32, c=i32))

message("-- integer64 subscripts from data.frame 7x faster than int64 (and 4x slower than integer) --\n")
system.time(dfI64[1e6:1,])/system.time(dfi64[1e6:1,])
system.time(dfi64[1e6:1,])/system.time(dfi32[1e6:1,])

message("-- integer64 csv writes and reads about 2x faster than int64 (and about 2x slower than integer) --\n")
f1 <- tempfile()
f2 <- tempfile()
system.time(write.csv(dfI64, file=f1, row.names=FALSE))/system.time(write.csv(dfi64, file=f2, row.names=FALSE))
system.time(read.csv(f1, colClasses=rep("int64", k)))/system.time(read.csv(f2, colClasses=rep("integer64", k)))
unlink(c(f1,f2))

f1 <- tempfile()
f2 <- tempfile()
system.time(write.csv(dfi64, file=f1, row.names=FALSE))/system.time(write.csv(dfi32, file=f2, row.names=FALSE))
system.time(read.csv(f1, colClasses=rep("integer64", k)))/system.time(read.csv(f2, colClasses=rep("integer", k)))
unlink(c(f1,f2))

rm(i32, d64, i64, I64, dfi32, dfd64, dfi64, dfI64)










d64 <- diffinv(rep(1, 10), lag=2, differences=2)
i32 <- as.integer(d64)
i64 <- as.integer64(d64)
identical(diff(i32, lag=2, differences=2), as.integer(diff(i64, lag=2, differences=2)))
identical(diff(d64, lag=2, differences=2), as.double(diff(i64, lag=2, differences=2)))

x <- i32[]
n <- length(x)


}



#! \name{bit64-package}
#! \alias{bit64-package}
#! \alias{bit64}
#! \alias{integer64}
#! \alias{is.integer64}
#! \alias{is.vector.integer64}
#! \alias{as.vector.integer64}
#! \alias{length<-.integer64}
#! \alias{print.integer64}
#! \docType{package}
#! \title{
#!    A S3 class for vectors of 64bit integers
#! }
#! \description{
#! Package 'bit64' provides S3 atomic 64bit (signed) integers, coercion from and 
#! to logicals, integers, doubles, characters and the usual vector and summary 
#! functions. \cr
#!
#! With 'integer64' vectors you can store very large integers at the expense
#! of 64 bits only, which is by factor 7 better than 'int64' from package 'int64'.
#! Due to the smaller memory footprint, the usual vector architecture and avoidance 
#! of S4 classes, most operations are one to three orders of magnitude faster while 
#! being more compatible: it only requires the more basic S3 class system. Example 
#! speedups are: 4x for serialization, 100x for adding, 300x for coercion, 2000x 
#! for object creation. \cr
#! }
#! \usage{
#!  integer64(length)
#!  \method{is}{integer64}(x)
#!  \method{length}{integer64}(x) <- value
#!  \method{print}{integer64}(x, quote=FALSE, \dots)
#! }
#! \arguments{
#!   \item{length}{ length of vector using \code{\link{integer}} }
#!   \item{x}{ an integer64 vector }
#!   \item{value}{ an integer64 vector of values to be assigned }
#!   \item{quote}{ logical, indicating whether or not strings should be printed with surrounding quotes. }
#!   \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
#! }
#! \details{
#! \tabular{ll}{
#!    Package: \tab bit64\cr
#!    Type: \tab Package\cr
#!    Version: \tab 0.5.0\cr
#!    Date: \tab 2011-12-12\cr
#!    License: \tab GPL-2\cr
#!    LazyLoad: \tab yes\cr
#!    Encoding: \tab latin1\cr
#! }
#!
#! Index:
#! \tabular{rrl}{
#!    \bold{creating,testing,printing} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{integer64}} \tab \code{\link{integer}} \tab create zero atomic vector \cr
#!    \code{\link{rep.integer64}} \tab \code{\link{rep}} \tab  \cr
#!    \code{\link{seq.integer64}} \tab \code{\link{seq}} \tab  \cr
#!    \code{\link{is.integer64}} \tab \code{\link{is}} \tab  \cr
#!    \code{\link{is.vector.integer64}} \tab \code{\link{is.vector}} \tab  \cr
#!    \code{\link{length<-.integer64}} \tab \code{\link{length<-}} \tab  \cr
#!    \code{\link{print.integer64}} \tab \code{\link{print}} \tab  \cr
#!  \cr
#!    \bold{coercing to integer64} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{as.integer64}} \tab   \tab generic \cr
#!    \code{\link{as.integer64.character}} \tab \code{\link{character}} \tab  \cr
#!    \code{\link{as.integer64.double}} \tab \code{\link{double}} \tab  \cr
#!    \code{\link{as.integer64.integer}} \tab \code{\link{integer}} \tab  \cr
#!    \code{\link{as.integer64.integer64}} \tab \code{\link{integer64}} \tab  \cr
#!    \code{\link{as.integer64.logical}} \tab \code{\link{logical}} \tab  \cr
#!    \code{\link{as.integer64.NULL}} \tab \code{\link{NULL}} \tab  \cr
#!  \cr
#!    \bold{coercing from integer64} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{as.bitstring}} \tab \code{\link{as.bitstring}} \tab generic \cr
#!    \code{\link{as.bitstring.integer64}} \tab  \tab  \cr
#!    \code{\link{as.character.integer64}} \tab \code{\link{as.character}} \tab  \cr
#!    \code{\link{as.double.integer64}} \tab \code{\link{as.double}} \tab  \cr
#!    \code{\link{as.integer.integer64}} \tab \code{\link{as.integer}} \tab  \cr
#!    \code{\link{as.logical.integer64}} \tab \code{\link{as.logical}} \tab  \cr
#!    \code{\link{as.vector.integer64}} \tab \code{\link{as.vector}} \tab  \cr
#!  \cr
#!    \bold{data structures} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{c.integer64}} \tab \code{\link{c}} \tab concatenate \cr
#!    \code{\link{cbind.integer64}} \tab \code{\link{cbind}} \tab column bind \cr
#!    \code{\link{rbind.integer64}} \tab \code{\link{rbind}} \tab row bind \cr
#!    \code{\link{as.data.frame.integer64}} \tab \code{\link{data.frame}} \tab coerce vector to column \cr
#!  \cr
#!    \bold{subscripting} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{[.integer64}} \tab \code{\link{[}} \tab vector and array extract \cr
#!    \code{\link{[<-.integer64}} \tab \code{\link{[<-}} \tab vector and array assign \cr
#!    \code{\link{[[.integer64}} \tab \code{\link{[[}} \tab scalar extract \cr
#!    \code{\link{[[<-.integer64}} \tab \code{\link{[[<-}} \tab scalar assign \cr
#!  \cr
#!    \bold{binary operators} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{+.integer64}} \tab \code{\link{+}} \tab returns integer64 \cr
#!    \code{\link{-.integer64}} \tab \code{\link{-}} \tab returns integer64 \cr
#!    \code{\link{*.integer64}} \tab \code{\link{*}} \tab returns integer64 \cr
#!    \code{\link{^.integer64}} \tab \code{\link{^}} \tab returns double \cr
#!    \code{\link{/.integer64}} \tab \code{\link{/}} \tab returns double \cr
#!    \code{\link{\%/\%.integer64}} \tab \code{\link{\%/\%}} \tab returns integer64 \cr
#!    \code{\link{\%\%.integer64}} \tab \code{\link{\%\%}} \tab returns integer64 \cr
#!  \cr
#!    \bold{comparison operators} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{==.integer64}} \tab \code{\link{==}} \tab  \cr
#!    \code{\link{!=.integer64}} \tab \code{\link{!=}} \tab  \cr
#!    \code{\link{<.integer64}} \tab \code{\link{<}} \tab  \cr
#!    \code{\link{<=.integer64}} \tab \code{\link{<=}} \tab  \cr
#!    \code{\link{>.integer64}} \tab \code{\link{>}} \tab  \cr
#!    \code{\link{>=.integer64}} \tab \code{\link{>=}} \tab  \cr
#!  \cr
#!    \bold{logical operators} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{!.integer64}} \tab \code{\link{!}} \tab  \cr
#!    \code{\link{&.integer64}} \tab \code{\link{&}} \tab  \cr
#!    \code{\link{|.integer64}} \tab \code{\link{|}} \tab  \cr
#!    \code{\link{xor.integer64}} \tab \code{\link{xor}} \tab  \cr
#!  \cr
#!    \bold{math functions} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{is.na.integer64}} \tab \code{\link{is.na}} \tab returns logical \cr
#!    \code{\link{format.integer64}} \tab \code{\link{format}} \tab returns character \cr
#!    \code{\link{abs.integer64}} \tab \code{\link{abs}} \tab returns integer64 \cr
#!    \code{\link{sign.integer64}} \tab \code{\link{sign}} \tab returns integer64 \cr
#!    \code{\link{log.integer64}} \tab \code{\link{log}} \tab returns double \cr
#!    \code{\link{log10.integer64}} \tab \code{\link{log10}} \tab  returns double \cr
#!    \code{\link{log2.integer64}} \tab \code{\link{log2}} \tab  returns double \cr
#!    \code{\link{sqrt.integer64}} \tab \code{\link{sqrt}} \tab  returns double \cr
#!    \code{\link{ceiling.integer64}} \tab \code{\link{ceiling}} \tab returns integer64 \cr
#!    \code{\link{floor.integer64}} \tab \code{\link{floor}} \tab returns integer64 \cr
#!    \code{\link{trunc.integer64}} \tab \code{\link{trunc}} \tab returns integer64 \cr
#!    \code{\link{round.integer64}} \tab \code{\link{round}} \tab returns integer64 \cr
#!    \code{\link{signif.integer64}} \tab \code{\link{signif}} \tab NOT IMPLEMENTED \cr
#!  \cr
#!    \bold{cumulative functions} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{cummin.integer64}} \tab \code{\link{cummin}} \tab x \cr
#!    \code{\link{cummax.integer64}} \tab \code{\link{cummax}} \tab x \cr
#!    \code{\link{cumsum.integer64}} \tab \code{\link{cumsum}} \tab x \cr
#!    \code{\link{cumprod.integer64}} \tab \code{\link{cumprod}} \tab x \cr
#!    \code{\link{diff.integer64}} \tab \code{\link{diff}} \tab x \cr
#!  \cr
#!    \bold{summary functions} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{range.integer64}} \tab \code{\link{range}} \tab also returns valid range \cr
#!    \code{\link{min.integer64}} \tab \code{\link{min}} \tab  \cr
#!    \code{\link{max.integer64}} \tab \code{\link{max}} \tab  \cr
#!    \code{\link{sum.integer64}} \tab \code{\link{sum}} \tab  \cr
#!    \code{\link{prod.integer64}} \tab \code{\link{prod}} \tab  \cr
#!    \code{\link{all.integer64}} \tab \code{\link{all}} \tab  \cr
#!    \code{\link{any.integer64}} \tab \code{\link{any}} \tab  \cr
#!    \bold{helper functions} \tab \bold{see also}          \tab \bold{description} \cr
#!    \code{\link{minusclass}} \tab \code{\link{minusclass}} \tab removing class attritbute \cr
#!    \code{\link{plusclass}} \tab \code{\link{plusclass}} \tab inserting class attribute \cr
#!    \code{\link{binattr}} \tab \code{\link{binattr}} \tab define binary op behaviour \cr
#! }
#! }
#! \value{
#!   \code{integer64} returns a vector of 'integer64', 
#!    i.e. a vector of \code{\link{double}} decorated with class 'integer64'.
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! Maintainer: Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \note{
#!   xx
#! }
#! \keyword{ package }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{integer}} in base R and \code{\link[int64]{int64}} in package 'int64' }
#! \examples{
#!   x <- integer64(12)                           # create integer64 vector
#!
#!   \dontrun{
#!     message("\nEven for a single boolean operation transforming logical to bit pays off")
#!
#!   }
#! }

#! \name{as.character.integer64}
#! \alias{as.character.integer64}
#! \alias{as.double.integer64}
#! \alias{as.integer.integer64}
#! \alias{as.logical.integer64}
#! \alias{as.bitstring}
#! \alias{as.bitstring.integer64}
#! \title{
#!    Coerce from integer64
#! }
#! \description{
#!   Methods to coerce integer64 to other atomic types. 
#!   'as.bitstring' coerces to a human-readable bit representation (strings of zeroes and ones). 
#!   The methods \code{\link{format}}, \code{\link{as.character}}, \code{\link{as.double}},
#!   \code{\link{as.logical}}, \code{\link{as.integer}} do what you would expect.
#! }
#! \usage{
#!  as.bitstring(x, \dots)
#!  \method{as.bitstring}{integer64}(x, \dots)
#!  \method{as.character}{integer64}(x, \dots)
#!  \method{as.double}{integer64}(x, \dots)
#!  \method{as.integer}{integer64}(x, \dots)
#!  \method{as.logical}{integer64}(x, \dots)
#! }
#! \arguments{
#!   \item{x}{ an integer64 vector }
#!   \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
#! }
#! \value{
#!   \code{as.bitstring} returns a string of . \cr
#!   The other methods return atomic vectors of the expected types
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{as.integer64.character}} \code{\link{integer64}}  }
#! \examples{
#!   as.character(range.integer64())
#!   as.bitstring(range.integer64())
#! }

#! \name{as.integer64.character}
#! \alias{as.integer64}
#! \alias{as.integer64.integer64}
#! \alias{as.integer64.NULL}
#! \alias{as.integer64.character}
#! \alias{as.integer64.double}
#! \alias{as.integer64.integer}
#! \alias{as.integer64.logical}
#! \title{
#!    Coerce to integer64
#! }
#! \description{
#!   Methods to coerce from other atomic types to integer64. 
#! }
#! \usage{
#!  as.integer64(x, \dots)
#!  \method{as.integer64}{integer64}(x, \dots)
#!  \method{as.integer64}{NULL}(x, \dots)
#!  \method{as.integer64}{character}(x, \dots)
#!  \method{as.integer64}{double}(x, \dots)
#!  \method{as.integer64}{integer}(x, \dots)
#!  \method{as.integer64}{logical}(x, \dots)
#! }
#! \arguments{
#!   \item{x}{ an atomic vector }
#!   \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
#! }
#! \value{
#!   The other methods return atomic vectors of the expected types
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{as.character.integer64}} \code{\link{integer64}}  }
#! \examples{
#!   as.integer64(as.character(range.integer64()))
#! }


#! \name{extract.replace.integer64}
#! \alias{[.integer64}
#! \alias{[[.integer64}
#! \alias{[[<-.integer64}
#! \alias{[<-.integer64}
#! \title{
#!    Extract or Replace Parts of an integer64 vector
#! }
#! \description{
#!   Methods to extract and replace parts of an integer64 vector.
#! }
#! \usage{
#!  \method{[}{integer64}(x, \dots)
#!  \method{[}{integer64}(x, \dots) <- value 
#!  \method{[[}{integer64}(x, \dots)
#!  \method{[[}{integer64}(x, \dots) <- value
#! }
#! \arguments{
#!   \item{x}{ an atomic vector }
#!   \item{value}{ an atomic vector with values to be assigned }
#!   \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
#! }
#! \value{
#!   A vector or scalar of class 'integer64'
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{[}} \code{\link{integer64}}  }
#! \examples{
#!   as.integer64(1:12)[1:3]
#!   x <- as.integer64(1:12)
#!   dim(x) <- c(3,4)
#!   x
#!   x[]
#!   x[,2:3]
#! }

#! \name{format.integer64}
#! \alias{format.integer64}
#! \alias{is.na.integer64}
#! \alias{!.integer64}
#! \alias{sign.integer64}
#! \alias{abs.integer64}
#! \alias{sqrt.integer64}
#! \alias{log.integer64}
#! \alias{log2.integer64}
#! \alias{log10.integer64}
#! \alias{floor.integer64}
#! \alias{ceiling.integer64}
#! \alias{trunc.integer64}
#! \alias{round.integer64}
#! \alias{signif.integer64}
#! \title{
#!    Unary operators and functions for integer64 vectors
#! }
#! \description{
#!   Unary operators and functions for integer64 vectors.
#! }
#! \usage{
#! \method{format}{integer64}(x, \dots)
#! \method{is.na}{integer64}(x)
#! \method{!}{integer64}(x)
#! \method{sign}{integer64}(x)
#! \method{abs}{integer64}(x)
#! \method{sqrt}{integer64}(x)
#! \method{log}{integer64}(x, base)
#! \method{log2}{integer64}(x)
#! \method{log10}{integer64}(x)
#! \method{floor}{integer64}(x)
#! \method{ceiling}{integer64}(x)
#! \method{trunc}{integer64}(x, \dots)
#! \method{round}{integer64}(x, digits=0)
#! \method{signif}{integer64}(x, digits=6)
#! }
#! \arguments{
#!   \item{x}{ an atomic vector of class 'integer64'}
#!   \item{base}{ an atomic scalar (we save 50\% log-calls by not allowing a vector base) }
#!   \item{digits}{ integer indicating the number of decimal places (round) or significant digits (signif) to be used. #!                  Negative values are allowed (see \code{\link{round}}) }
#!   \item{\dots}{ further arguments to the \code{\link{NextMethod}} }
#! }
#! \value{
#!   \code{\link{format}} returns a character vector \cr
#!   \code{\link{is.na}} and \code{\link{!}} return a logical vector \cr
#!   \code{\link{sqrt}}, \code{\link{log}}, \code{\link{log2}} and \code{\link{log10}} return a double vector \cr
#!   \code{\link{sign}}, \code{\link{abs}}, \code{\link{floor}}, \code{\link{ceiling}}, \code{\link{trunc}} and 
#!   \code{\link{round}} return a vector of class 'integer64' \cr
#!   \code{\link{signif}} is not implemented 
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{xor.integer64}} \code{\link{integer64}}  }
#! \examples{
#!   sqrt(as.integer64(1:12))
#! }


#! \name{xor.integer64}
#! \alias{&.integer64}
#! \alias{|.integer64}
#! \alias{xor.integer64}
#! \alias{!=.integer64}
#! \alias{==.integer64}
#! \alias{<.integer64}
#! \alias{<=.integer64}
#! \alias{>.integer64}
#! \alias{>=.integer64}
#! \alias{+.integer64}
#! \alias{-.integer64}
#! \alias{*.integer64}
#! \alias{^.integer64}
#! \alias{/.integer64}
#! \alias{\%/\%.integer64}
#! \alias{\%\%.integer64}
#! \alias{binattr}
#! \title{
#!    Binary operators for integer64 vectors
#! }
#! \description{
#!   Binary operators for integer64 vectors.
#! }
#! \usage{
#! \method{&}{integer64}(e1,e2)
#! \method{|}{integer64}(e1,e2)
#! \method{xor}{integer64}(x,y)
#! \method{!=}{integer64}(e1,e2)
#! \method{==}{integer64}(e1,e2)
#! \method{<}{integer64}(e1,e2)
#! \method{<=}{integer64}(e1,e2)
#! \method{>}{integer64}(e1,e2)
#! \method{>=}{integer64}(e1,e2)
#! \method{+}{integer64}(e1,e2)
#! \method{-}{integer64}(e1,e2)
#! \method{*}{integer64}(e1,e2)
#! \method{^}{integer64}(e1,e2)
#! \method{/}{integer64}(e1,e2)
#! \method{\%/\%}{integer64}(e1,e2)
#! \method{\%\%}{integer64}(e1,e2)
#! binattr(e1,e2) # for internal use only
#! }
#! \arguments{
#!   \item{e1}{ an atomic vector of class 'integer64'}
#!   \item{e2}{ an atomic vector of class 'integer64'}
#!   \item{x}{ an atomic vector of class 'integer64'}
#!   \item{y}{ an atomic vector of class 'integer64'}
#! }
#! \value{
#!   \code{\link{&}}, \code{\link{|}}, \code{\link{xor}}, \code{\link{!=}}, \code{\link{==}}, 
#!   \code{\link{<}}, \code{\link{<=}}, \code{\link{>}}, \code{\link{>=}} return a logical vector \cr
#!   \code{\link{^}} and \code{\link{/}} return a double vector\cr
#!   \code{\link{+}}, \code{\link{-}}, \code{\link{*}}, \code{\link{\%/\%}}, \code{\link{\%\%}}
#!    return a vector of class 'integer64'
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{format.integer64}} \code{\link{integer64}}  }
#! \examples{
#!   as.integer64(1:12) - 1
#! }


#! \name{sum.integer64}
#! \alias{all.integer64}
#! \alias{any.integer64}
#! \alias{min.integer64}
#! \alias{max.integer64}
#! \alias{range.integer64}
#! \alias{sum.integer64}
#! \alias{prod.integer64}
#! \title{
#!    Summary functions for integer64 vectors
#! }
#! \description{
#!   Summary functions for integer64 vectors. 
#!   Function 'range' without returns the smallest and largest value of the 'integer64' class.
#! }
#! \usage{
#! \method{all}{integer64}(\dots, na.rm = FALSE)
#! \method{any}{integer64}(\dots, na.rm = FALSE)
#! \method{min}{integer64}(\dots, na.rm = FALSE)
#! \method{max}{integer64}(\dots, na.rm = FALSE)
#! \method{range}{integer64}(\dots, na.rm = FALSE)
#! \method{sum}{integer64}(\dots, na.rm = FALSE)
#! \method{prod}{integer64}(\dots, na.rm = FALSE)
#! }
#! \arguments{
#!   \item{\dots}{ atomic vectors of class 'integer64'}
#!   \item{na.rm}{ logical scalar indicating whether to ignore NAs }
#! }
#! \value{
#!   \code{\link{all}} and \code{\link{any}} return a logical scalar\cr
#!   \code{\link{range}} returns a integer64 vector with two elements\cr
#!   \code{\link{min}}, \code{\link{max}}, \code{\link{sum}} and \code{\link{prod}} return a integer64 scalar
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{cumsum.integer64}} \code{\link{integer64}}  }
#! \examples{
#!   range.integer64()
#!   range(as.integer64(1:12))
#! }


#! \name{cumsum.integer64}
#! \alias{cummin.integer64}
#! \alias{cummax.integer64}
#! \alias{cumsum.integer64}
#! \alias{cumprod.integer64}
#! \alias{diff.integer64}
#! \title{
#!    Cumulative Sums, Products, Extremes and lagged differences
#! }
#! \description{
#!   Cumulative Sums, Products, Extremes and lagged differences
#! }
#! \usage{
#! \method{cummin}{integer64}(x)
#! \method{cummax}{integer64}(x)
#! \method{cumsum}{integer64}(x)
#! \method{cumprod}{integer64}(x)
#! \method{diff}{integer64}(x, lag = 1L, differences = 1L, \dots)
#! }
#! \arguments{
#!   \item{x}{ an atomic vector of class 'integer64'}
#!   \item{lag}{ see \code{\link{diff}} }
#!   \item{differences}{ see \code{\link{diff}} }
#!   \item{\dots}{ ignored }
#! }
#! \value{
#!   \code{\link{cummin}}, \code{\link{cummax}} , \code{\link{cumsum}} and \code{\link{cumprod}} 
#!      return a integer64 vector of the same length as their input\cr
#!   \code{\link{diff}} returns a integer64 vector shorter by \code{lag*differences} elements \cr
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{sum.integer64}} \code{\link{integer64}}  }
#! \examples{
#!   cumsum(rep(as.integer64(1), 12))
#!   diff(as.integer64(c(0,1:12)))
#!   cumsum(as.integer64(c(0, 1:12)))
#!   diff(cumsum(as.integer64(c(0,0,1:12))), differences=2)
#! }


#! \name{c.integer64}
#! \alias{c.integer64}
#! \alias{cbind.integer64}
#! \alias{rbind.integer64}
#! \title{
#!    Concatenating integer64 vectors
#! }
#! \description{
#!   The ususal functions 'c', 'cbind' and 'rbind'
#! }
#! \usage{
#! \method{c}{integer64}(\dots)
#! \method{cbind}{integer64}(\dots)
#! \method{rbind}{integer64}(\dots)
#! }
#! \arguments{
#!   \item{\dots}{ two or more arguments coerced to 'integer64' and passed to \code{\link{NextMethod}} }
#! }
#! \value{
#!   \code{\link{c}} returns a integer64 vector of the total length of the input \cr
#!   \code{\link{cbind}} and \code{\link{rbind}} return a integer64 matrix
#! }
#! \note{
#!   R currently only dispatches generic 'c' to method 'c.integer64' if the first argument is 'integer64'
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{rep.integer64}} \code{\link{seq.integer64}} 
#!           \code{\link{as.data.frame.integer64}} \code{\link{integer64}}  
#! }
#! \examples{
#!   c(as.integer64(1), 2:6)
#!   cbind(1:6, as.integer(1:6))
#!   rbind(1:6, as.integer(1:6))
#! }


#! \name{rep.integer64}
#! \alias{rep.integer64}
#! \title{
#!    Replicate elements of integer64 vectors
#! }
#! \description{
#!   Replicate elements of integer64 vectors
#! }
#! \usage{
#! \method{rep}{integer64}(x, \dots)
#! }
#! \arguments{
#!   \item{x}{ a vector of 'integer64' to be replicated }
#!   \item{\dots}{ further arguments passed to \code{\link{NextMethod}} }
#! }
#! \value{
#!   \code{\link{rep}} returns a integer64 vector
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{c.integer64}} \code{\link{rep.integer64}} 
#!           \code{\link{as.data.frame.integer64}} \code{\link{integer64}}  
#! }
#! \examples{
#!   rep(as.integer64(1:2), 6)
#!   rep(as.integer64(1:2), c(6,6))
#!   rep(as.integer64(1:2), length.out=6)
#! }


#! \name{seq.integer64}
#! \alias{seq.integer64}
#! \title{
#!    integer64: Sequence Generation
#! }
#! \description{
#!   Generating sequence of integer64 values
#! }
#! \usage{
#! \method{seq}{integer64}(from = NULL, to = NULL, by = NULL, length.out = NULL, along.with = NULL, \dots)
#! }
#! \arguments{
#!   \item{from}{ integer64 scalar (in order to dispatch the integer64 method of \code{\link{seq}} }
#!   \item{to}{ scalar }
#!   \item{by}{ scalar }
#!   \item{length.out}{ scalar }
#!   \item{along.with}{ scalar }
#!   \item{\dots}{ ignored }
#! }
#! \value{
#!   an integer64 vector with the generated sequence
#! }
#! \note{
#!   In base R \code{\link{:}} currently is not generic and does not dispatch, therefor we make it generic.
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ \code{\link{c.integer64}} \code{\link{rep.integer64}} 
#!           \code{\link{as.data.frame.integer64}} \code{\link{integer64}}  
#! }
#! \examples{
#!   #as.integer64(1):12
#!   seq(as.integer64(1), 12, 2)
#!   seq(as.integer64(1), by=2, length.out=6)
#! }


#! \name{as.data.frame.integer64}
#! \alias{as.data.frame.integer64}
#! \title{
#!    integer64: Coercing to data.frame column
#! }
#! \description{
#!   Coercing integer64 vector to data.frame.
#! }
#! \usage{
#!   \method{as.data.frame}{integer64}(x, row.names = NULL, \dots)
#! }
#! \arguments{
#!   \item{x}{ an integer64 vector }
#!   \item{row.names}{ NULL or character vector }
#!   \item{\dots}{ ignored }
#! }
#! \value{
#!   a one-column data.frame containing an integer64 vector
#! }
#! \details{
#!   'as.data.frame.integer64' is rather not intended to be called directly,
#!   but it is required to allow integer64 as data.frame columns.
#! }
#! \note{
#!   This is currently very slow -- any ideas for improvement?
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \seealso{ 
#!   \code{\link{cbind.integer64}} \code{\link{as.vector.integer64}} \code{\link{integer64}}  
#! }
#! \examples{
#!   as.data.frame.integer64(as.integer64(1:12))
#!   data.frame(a=1:12, b=as.integer64(1:12))
#! }



#! \name{plusclass}
#! \alias{plusclass}
#! \alias{minusclass}
#! \title{
#!    integer64: Maintaining S3 class attribute
#! }
#! \description{
#!   Maintaining integer64 S3 class attribute.
#! }
#! \usage{
#!   plusclass(class, whichclass)
#!   minusclass(class, whichclass)
#! }
#! \arguments{
#!   \item{class}{ NULL or a character vector of class attributes }
#!   \item{whichclass}{ the (single) class name to add or remove from the class vector  }
#! }
#! \value{
#!   NULL or a character vector of class attributes
#! }
#! \author{
#! Jens Oehlschlägel <Jens.Oehlschlaegel@truecluster.com>
#! }
#! \keyword{ classes }
#! \keyword{ manip }
#! \keyword{ internal }
#! \seealso{ 
#!   \code{\link{oldClass}} \code{\link{integer64}}  
#! }
#! \examples{
#!   plusclass("inheritingclass","integer64")
#!   minusclass(c("inheritingclass","integer64"), "integer64")
#! }


# if (!exists(":.default")){
	# ":.default" <- get(":")
	# ":" <- function(from,to)UseMethod(":")
# }

as.integer64 <- function (x, ...) 
UseMethod("as.integer64")

as.bitstring <- function(x, ...)
UseMethod("as.bitstring")



minusclass <- function(class, whichclass){
  if (length(class)){
	  i <- whichclass==class
	  if (any(i))
		class[!i]
	  else
		class
  }else
    class
}

plusclass <- function(class, whichclass){
  if (length(class)){
	  i <- whichclass==class
	  if (any(i))
		class
	  else
		c(class, whichclass)
  }else
    whichclass
}

binattr <- function(e1,e2){
  d1 <- dim(e1)
  d2 <- dim(e2)
  n1 <- length(e1)
  n2 <- length(e2)
  if (length(d1)){
    if (length(d2)){
	  if (!identical(dim(e1),dim(e2)))
		stop("non-conformable arrays")
	}else{
	  if (n2>n1)
	    stop("length(e2) does not match dim(e1)")
	  if (n1%%n2)
		warning("length(e1) not a multiple length(e2)")
	}
	attributes(e1)
  }else{
    if (length(d2)){
	  if (n1>n2)
	    stop("length(e1) does not match dim(n2)")
	  if (n2%%n1)
		warning("length(e2) not a multiple length(e1)")
	  attributes(e2)
	}else{
	  if (n1<n2){
		if (n2%%n1)
			warning("length(e2) not a multiple length(e1)")
	  }else{
		if (n1%%n2)
			warning("length(e1) not a multiple length(e2)")
	  }
	  attributes(e1)
	}
  }
}


integer64 <- function(length=0){
  ret <- double(length)
  setattr(ret, "class", "integer64")
  ret
}

is.integer64 <- function(x)inherits(x, "integer64")

as.integer64.NULL <- function (x, ...){
  ret <- double()
  setattr(ret, "class", "integer64")
  ret
}

as.integer64.integer64 <- function(x, ...)x

as.integer64.double <- function(x, ...){
  ret <- double(length(x))
  .Call("as_integer64_double", x, ret)
  setattr(ret, "class", "integer64")
  ret
}

as.integer64.logical <- as.integer64.integer <- function(x, ...){
  ret <- double(length(x))
  .Call("as_integer64_integer", x, ret)
  setattr(ret, "class", "integer64")
  ret
}

as.integer64.character <- function(x, ...){
  n <- length(x)
  ret <- rep(as.double(NA), n)
  .Call("as_integer64_character", x, ret)
  setattr(ret, "class", "integer64")
  ret
}

as.double.integer64 <- function(x, ...){
  ret <- double(length(x))
  .Call("as_double_integer64", x, ret)
  ret
}

as.integer.integer64 <- function(x, ...){
  ret <- integer(length(x))
  .Call("as_integer_integer64", x, ret)
  ret
}

as.logical.integer64 <- function(x, ...){
  ret <- logical(length(x))
  .Call("as_integer_integer64", x, ret)
  ret
}

as.character.integer64 <- function(x, ...){
  n <- length(x)
  ret <- rep(as.character(NA), n)
  .Call("as_character_integer64", x, ret)
  ret
}

as.bitstring.integer64 <- function(x, ...){
  n <- length(x)
  ret <- rep(as.character(NA), n)
  .Call("as_bitstring_integer64", x, ret)
  ret
}

# read.table expects S4 as() 
setAs("character","integer64",function(from)as.integer64.character(from))
setAs("integer64","character",function(from)as.character.integer64(from))

"length<-.integer64" <- function(x, value){
  cl <- oldClass(x)
  n <- length(x)
  x <- NextMethod()
  setattr(x, "class", cl)
  if (value>n)
    x[(n+1):value] <- 0L
  x
}


format.integer64 <- function(x, ...){
  a <- attributes(x)
  x <- as.character(x)
  ret <- NextMethod()
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

print.integer64 <- function(x, quote=FALSE, ...){
  cat("integer64\n")
  a <- attributes(x)
  ret <- as.character(x)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  print(ret, quote=quote, ...)
  invisible(x)
}

"[.integer64" <- function(x,...){
  cl <- oldClass(x)
  ret <- NextMethod()
  setattr(ret, "class", cl)
  ret
}

"[<-.integer64" <- function(x,...,value){
  cl <- oldClass(x)
  value <- as.integer64(value)
  ret <- NextMethod()
  setattr(ret, "class", cl)
  ret
}

"[[.integer64" <- function(x,...){
  cl <- oldClass(x)
  ret <- NextMethod()
  setattr(ret, "class", cl)
  ret
}

"[[<-.integer64" <- function(x,...,value){
  cl <- oldClass(x)
  value <- as.integer64(value)
  ret <- NextMethod()
  setattr(ret, "class", cl)
  ret
}

c.integer64 <- function(...){
	l <- list(...)
	n <- sapply(l, length)
	N <- sum(n)
	K <- length(l)
	for (k in 1:K){
	  if (!is.integer64(l[[k]])){
	    nam <- names(l[[k]])
	    l[[k]] <- as.integer64(l[[k]])
		names(l[[k]]) <- nam
	  }
	  setattr(l[[k]], "class", NULL)
	}
	ret <- do.call("c", l)
	setattr(ret, "class", "integer64")
	ret
}

cbind.integer64 <- function(...){
  l <- list(...)
  for (k in 1:length(l)){
    if (!is.integer64(l[[k]])){
	  nam <- names(l[[k]])
      l[[k]] <- as.integer64(l[[k]])
	  names(l[[k]]) <- nam
	}
    setattr(l[[k]], "class", NULL)
  }
  ret <- do.call("cbind", l)
  setattr(ret, "class", "integer64")
  ret
}

rbind.integer64 <- function(...){
  l <- list(...)
  for (k in 1:length(l)){
    if (!is.integer64(l[[k]])){
	  nam <- names(l[[k]])
      l[[k]] <- as.integer64(l[[k]])
	  names(l[[k]]) <- nam
	}
    setattr(l[[k]], "class", NULL)
  }
  ret <- do.call("rbind", l)
  setattr(ret, "class", "integer64")
  ret
}

as.data.frame.integer64 <- function(x, row.names = NULL, ...){  #optional = TRUE
  if (is.null(row.names)){
    if (is.null(colnames(x))){
		if (is.null(names(x)))
		  row.names <- as.character(1:length(x))
		else
		  row.names <- names(x)
	}else{
	  row.names <- colnames(x)
	}
  }
  ret <- list(x)
  setattributes(ret, list(names=colnames(x), row.names=row.names, class="data.frame"))
  ret
}


"rep.integer64" <- function(x, ...){
	cl <- oldClass(x)
	ret <- NextMethod()
	setattr(ret, "class", cl)
	ret
}

# FIXME no method dispatch for :
# ":.integer64" <- function(from, to){
  # from <- as.integer64(from)
  # to <- as.integer64(to)
  # ret <- double(as.integer(to-from+1L))
  # .Call("seq_integer64", from, as.integer64(1L), ret)
  # setattr(ret, "class", "integer64")
  # ret
# }

"seq.integer64" <- function(from=NULL, to=NULL, by=NULL, length.out=NULL, along.with=NULL, ...){
    if (is.null(from)){
      if (is.null(to))
        stop("need 'from' or 'to'")
      else
        to <- as.integer64(to)
      if (is.null(by))
        by <- as.integer64(1L)
      else
        by <- as.integer64(by)
    }else{
      from <- as.integer64(from)
      if (is.null(to)){
        if (is.null(by))
          by <- as.integer64(1L)
        else
          by <- as.integer64(by)
      }else{
        to <- as.integer64(to)
        n <- to - from
        if (is.null(by)){
          if (to<from)
            by = as.integer64(-1L)
          else
            by = as.integer64(1L)
        }else{
          by <- as.integer64(by)
          if (n){
            if (sign(n) != sign(by))
              stop("wrong sign of by")
          }else
            return(as.integer64(from))  # to == from
        }
      }
    }
    if (is.null(length.out)){
      if (is.null(along.with)){
        if (is.null(to) || is.null(from))
          stop("not enough info to guess the length.out")
        else{
          length.out <- n %/% by + 1L
        }
      }else{
        length.out <- length(along.with)
      }
    }else{
      length.out <- as.integer64(length.out)
    }
    if (length.out){
      if (length.out==1L)
        return(from)
      else{
        #return(cumsum(c(from, rep(by, length.out-1L))))
		ret <- double(as.integer(length.out))
		.Call("seq_integer64", from, by, ret)
		setattr(ret, "class", "integer64")
		return(ret)
	  }
    }else
      return(integer64())
}


"+.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- double(max(length(e1),length(e2)))
  .Call("plus_integer64", e1, e2, ret)
  a$class <- plusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"-.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- double(max(length(e1),length(e2)))
  .Call("minus_integer64", e1, e2, ret)
  a$class <- plusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"*.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- double(max(length(e1),length(e2)))
  .Call("times_integer64", e1, e2, ret)
  a$class <- plusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"^.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  ret <- as.double(e1)^as.double(e2)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"/.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  ret <- as.double(e1)/as.double(e2)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
}

"%/%.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- double(max(length(e1), length(e2)))
  .Call("intdiv_integer64", e1, e2, ret)
  a$class <- plusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"%%.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- double(max(length(e1), length(e2)))
  .Call("mod_integer64", e1, e2, ret)
  a$class <- plusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}


"sign.integer64" <- function(x){
  a <- attributes(x)
  ret <- double(length(x))
  .Call("sign_integer64", x,ret)
  setattributes(ret, a)
  ret
}

"abs.integer64" <- function(x){
  a <- attributes(x)
  ret <- double(length(x))
  .Call("abs_integer64", x,ret)
  setattributes(ret, a)
  ret
}

"sqrt.integer64" <- function(x){
  a <- attributes(x)
  ret <- double(length(x))
  .Call("sqrt_integer64", x,ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"log.integer64" <- function(x, base=NULL){
  a <- attributes(x)
  ret <- double(length(x))
  if (is.null(base))
	log_integer64(x,ret)
  else{
	if (length(base)!=1)
	  stop("base must be scalar, this saves 50% log calls in vector processing")
    .Call("logbase_integer64", x, as.double(base),ret)
  }
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"log10.integer64" <- function(x){
  a <- attributes(x)
  ret <- double(length(x))
  .Call("log10_integer64", x,ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"log2.integer64" <- function(x){
  a <- attributes(x)
  ret <- double(length(x))
  .Call("log2_integer64", x,ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"trunc.integer64" <- function(x, ...)x
"floor.integer64" <- "ceiling.integer64" <- function(x)x

"round.integer64" <- function(x, digits=0){
  if (digits<0){
    a <- attributes(x)
	base <- 10^floor(-digits)
	ret <- (x%/%base) * base
    a$class <- minusclass(a$class, "integer64")
    setattributes(ret, a)
	ret
  }else
	x
}

"signif.integer64" <- function(x, digits=6)stop("not implemented")


"any.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- logical(1)
  if (length(l)==1){
		  .Call("any_integer64", e, na.rm, ret)
		  ret
  }else{
	  any(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("any_integer64", e, na.rm, ret)
		  ret
		}else{
		  any(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
}

"all.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- logical(1)
  if (length(l)==1){
		  .Call("all_integer64", l[[1]], na.rm, ret)
		  ret
  }else{
	  all(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("all_integer64", e, na.rm, ret)
		  ret
		}else{
		  all(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
}

"sum.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- double(1)
  if (length(l)==1){
		  .Call("sum_integer64", l[[1]], na.rm, ret)
		  ret
  }else{
	  sum(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("sum_integer64", e, na.rm, ret)
		  ret
		}else{
		  sum(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
}


"prod.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- double(1)
  if (length(l)==1){
		  .Call("prod_integer64", l[[1]], na.rm, ret)
		  ret
  }else{
	  prod(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("prod_integer64", e, na.rm, ret)
		  ret
		}else{
		  prod(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
}


"min.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- double(1)
  if (length(l)==1){
		  .Call("min_integer64", l[[1]], na.rm, ret)
	      setattr(ret, "class", "integer64")
  }else{
	  ret <- min(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("min_integer64", e, na.rm, ret)
	      setattr(ret, "class", "integer64")
		  ret
		}else{
		  min(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
  if (na.rm && is.na(ret)){
	warning("no non-NA value, returning Inf")
	Inf
  }else 
    ret
}


"max.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- double(1)
  if (length(l)==1){
		  .Call("max_integer64", l[[1]], na.rm, ret)
	      setattr(ret, "class", "integer64")
		  ret
  }else{
	  max(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("max_integer64", e, na.rm, ret)
		  setattr(ret, "class", "integer64")
		  ret
		}else{
		  max(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
  if (na.rm && is.na(ret)){
	warning("no non-NA value, returning -Inf")
	Inf
  }else 
    ret
}

"range.integer64" <- function(..., na.rm = FALSE){
  l <- list(...)
  ret <- double(2)
  if (length(l)<2){
    if (length(l)<1){
		.Call("lim_integer64", ret)
		setattr(ret, "class", "integer64")
		return(ret)
	}else{
		.Call("range_integer64", l[[1]], na.rm, ret)
		setattr(ret, "class", "integer64")
		ret
	}
  }else{
	  range(sapply(l, function(e){
		if (is.integer64(e)){
		  .Call("range_integer64", e, na.rm, ret)
		  setattr(ret, "class", "integer64")
		  ret
		}else{
		  range(e, na.rm = na.rm)
		}
	  }), na.rm = na.rm)
  }
  if (na.rm && all(is.na(ret))){
	warning("no non-NA value, returning -Inf,Inf")
	c(-Inf,Inf)
  }else 
    ret
}



"diff.integer64" <- function(x, lag=1L, differences=1L, ...){
  lag <- as.integer(lag)
  n <- length(x)
  d <- differences <- as.integer(differences)
  while(d>0L){
	n <- n - lag
    if (n<=0L){
	  ret <- double()
	  break
	}
	if (d==differences){
	  ret <- double(n)
      .Call("diff_integer64", x, as.integer64(lag), as.integer64(n), ret)
	}else{
	  .Call("diff_integer64", ret, as.integer64(lag), as.integer64(n), ret)
	}
	d <- d - 1L
  }
  length(ret) <- n
  setattr(ret, "class", "integer64")
  ret
}


"cummin.integer64" <- function(x){
  ret <- double(length(x))
  .Call("cummin_integer64", x,ret)
  setattr(ret, "class", "integer64")
  ret
}
"cummax.integer64" <- function(x){

  ret <- double(length(x))
  .Call("cummax_integer64", x,ret)
  setattr(ret, "class", "integer64")
  ret
}

"cumsum.integer64" <- function(x){
  ret <- double(length(x))
  .Call("cumsum_integer64", x,ret)
  setattr(ret, "class", "integer64")
  ret
}

"cumprod.integer64" <- function(x){
  ret <- double(length(x))
  .Call("cumprod_integer64", x,ret)
  setattr(ret, "class", "integer64")
  ret
}



"is.na.integer64" <- function(x){
  a <- attributes(x)
  ret <- logical(length(x))
  .Call("isna_integer64", x, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"==.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- logical(max(length(e1), length(e2)))
  .Call("EQ_integer64", e1, e2, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"!=.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- logical(max(length(e1), length(e2)))
  .Call("NE_integer64", e1, e2, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"<.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- logical(max(length(e1), length(e2)))
  .Call("LT_integer64", e1, e2, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"<=.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- logical(max(length(e1), length(e2)))
  .Call("LE_integer64", e1, e2, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

">.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- logical(max(length(e1), length(e2)))
  .Call("GT_integer64", e1, e2, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

">=.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  e1 <- as.integer64(e1)
  e2 <- as.integer64(e2)
  ret <- logical(max(length(e1), length(e2)))
  .Call("GE_integer64", e1, e2, ret)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"&.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  ret <- as.logical(e1) & as.logical(e2)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

"|.integer64" <- function(e1, e2){
  a <- binattr(e1,e2)
  ret <- as.logical(e1) | as.logical(e2)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}

xor.integer64 <- function(x, y){
  a <- binattr(x,y)
  ret <- as.logical(x) != as.logical(y)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}


"!.integer64" <- function(x){
  a <- attributes(x)
  ret <- !as.logical(x)
  a$class <- minusclass(a$class, "integer64")
  setattributes(ret, a)
  ret
}


as.vector.integer64 <- function(x, mode="any"){
  ret <- NextMethod()
  if (mode=="any")
	setattr(ret, "class", "integer64")
  ret
}

# bug in R does not dispatch
is.vector.integer64 <- function(x, mode="any"){
  if (mode=="any")
	.Class <- NULL
  NextMethod()
}



if (FALSE){
	library(bit)
	library(inline)
	source("c:/Users/Jens/Desktop/ff/integer64.R")
	library(int64)

	x <- data.frame(a=1:10, b=as.integer64(1:10), c=as.int64(1:10))
	write.csv(x, file = "foo.csv")
	y <- read.csv("foo.csv", row.names = 1, colClasses=c(b="integer64", c="int64"))
	
	is.atomic(int64(10))
	is.atomic(integer64(10))

	
as.bitstring(range.integer64())
as.bitstring(as.integer64(0:9))


	
	
x <- as.integer(1:1e7)
y <- as.integer(4:1e7)
system.time(z <- c(x, y))
x <- as.integer64(1:1e7)
y <- as.integer64(4:1e7)
system.time(z <- c(x, y))

x <- as.integer64(1:3)
y <- as.integer64(4:6)
as.integer(c(x, y))

	

	y <- c(NA,-1,0,1,2,3,4,10, 100, 2^55, 2^55+1)
	x <- as.integer64(y)
	x[10]<- as.integer64(2^52)*(2^3)
	x[11]<- as.integer64(2^52)*(2^3)+1
	is.atomic(x)
	log(y)
	log(x)
	log(y,10)
	log(x,10)
	log10(y)
	log10(x)
	log(y,2)
	log(x,2)
	log2(y)
	log2(x)
	sqrt(y)
	sqrt(x)
	
	n <- 1e7
	x <- round(runif(n, 1, n))
	y <- as.integer(x)
	z <- as.integer64(x)
	system.time(lx <- log(x, 3))
	system.time(ly <- log(y, 3))
	system.time(lz <- log(z, 3))
	all.equal(lx, ly)
	all.equal(lx, lz)
	
	system.time(x <- rep(1:3, 1e7))
	system.time(y <- rep.integer64(1:3, 1e7))
	identical(x, as.integer(y))
	system.time(x <- rep(1:1e4, 1:1e4))
	system.time(y <- rep.integer64(1:1e4, 1:1e4))
	identical(x, as.integer(y))
	
	# [ #inherited from double
	# [<- #next method
	# names #inherited from double
	# names<- #inherited from double
	# summary
		# min
		# max
		# range
		# prod
		# sum
		# any #
		# all #
	# arith
		# +
		# -
		# *
		# /
		# ^ #
		# %/%
		# %%
	# is.na
	# comp
		# ==
		# !=
		# <
		# >
		# >=
		# <=
	# Math
		# abs
		# sign
		# trunc #
		# floor #
		# cummax
		# cummin
		# cumprod
		# cumsum
	# Math2
	# as.character
	# print 
	# numeric_limits
	# as.data.frame
	# as.int64.character
	# binary
	# unique #inherited from double
	# sort 
	# c 
	# as.int64.character
	# as.int64.integer
	# as.int64.logical
	# as.int64.numeric
	#rep
	#seq
	#:



x <- 2 ^ 60
y <- as.integer(x)
z <- as.integer64(x)
as.character(x)
as.character(y)
as.character(z)

as.character(range.integer64())

x <- 1:1e6
y <- as.integer64(x)
system.time(as.character(x))
system.time(as.character(y))


as.character(as.integer64(as.character(range.integer64())))
as.integer(as.integer64(as.character(-100:100)))
as.character(as.integer64(as.character(as.integer64(c(.Machine$integer.max, .Machine$integer.max))+0:1)))
as.integer(as.integer64(c("  123", "1NA")))

	.Machine$integer.max + .Machine$integer.max
	x <- .Machine$integer.max

	for (e in 32:54){
	  if (2^e == 2^e + 1) print(e)
	}
	for (e in 32:54){
	  if (-(2^e) == -(2^e) - 1) print(e)
	}


	x <- as.integer64(2^30)
	y <- x*x*3
	as.integer(y%%3)
	as.integer((y+1)%%3)
	as.integer((y+2)%%3)
	as.integer((y+3)%%3)

	library(int64)

	n <- 2^4
	str(integer( n ))  # is of course a vector
	str(integer64( n ))  # is a vector = OK
	str(int64( n ))  # is a list, not a vector = expensive

	as.integer(integer64( n )) # OK
	as.integer(int64( n )) # not mature, as.integer method fails

	n <- 2^28
	t32 <- system.time(x32 <- integer( n ))
	t64 <- system.time(x64 <- integer64( n )) # OK
	n <- 2^22
	T64 <- system.time(X64 <- int64( n )) # much too slow
	t32
	t64
	T64
	t64/t32 # x 2 == OK
	T64/t32*2^6 # x 4000 == much too slow

	# bring down to 2^20
	n <- 2^20
	t32 <- system.time(x32 <- integer( n ))
	t64 <- system.time(x64 <- integer64( n )) # OK
	T64 <- system.time(X64 <- int64( n )) # much too slow


	object.size(x64)/object.size(x32) # x 2 = OK
	object.size(X64)/object.size(x32) # x 14 = too big
	length(serialize(x64, connection=NULL)) / length(serialize(x32, connection=NULL)) # x 2 = OK
	length(serialize(X64, connection=NULL)) / length(serialize(x32, connection=NULL)) # x 4 = too big

	t32 <- system.time(serialize(x32, connection=NULL))
	t64 <- system.time(serialize(x64, connection=NULL))
	T64 <- system.time(serialize(X64, connection=NULL))
	t64/t32 # x 1.6 == OK
	T64/t32 # x 5.7 == too slow


	x <- runif(n, 0, n)
	tdbl <- system.time(xdbl <- x[])
	t32 <- system.time(x32 <- as.integer(x))
	t64 <- system.time(x64 <- as.integer64(x)) # OK
	T64 <- system.time(X64 <- as.int64(x)) # too slow
	tdbl/t32 # x 0
	t64/t32  # x 1
	T64/t32  # x 1000 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK

	tdbl <- system.time(xdbl + xdbl)
	t32 <- system.time(x32 + x32)
	t64 <- system.time(x64 + x64) # OK
	T64 <- system.time(X64 + X64) # too slow
	tdbl/t32 # x 0.5
	t64/t32  # x 1
	T64/t32  # x 500 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK

	tdbl <- system.time(xdbl - xdbl)
	t32 <- system.time(x32 - x32)
	t64 <- system.time(x64 - x64) # OK
	T64 <- system.time(X64 - X64) # too slow
	tdbl/t32 # x 0.5
	t64/t32  # x 1
	T64/t32  # x 500 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK

	tdbl <- system.time(xdbl * xdbl)
	t32 <- system.time(x32 * x32)
	t64 <- system.time(x64 * x64) # OK
	T64 <- system.time(X64 * X64) # too slow
	tdbl/t32 # x 0.5
	t64/t32  # x 1
	T64/t32  # x 500 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK

	tdbl <- system.time(xdbl / xdbl)
	t32 <- system.time(x32 / x32)
	t64 <- system.time(x64 / x64) # OK
	T64 <- system.time(X64 / X64) # too slow
	tdbl/t32 # x 0.5
	t64/t32  # x 1
	T64/t32  # x 500 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK

	tdbl <- system.time(xdbl %/% xdbl)
	t32 <- system.time(x32 %/% x32)
	t64 <- system.time(x64 %/% x64) # OK
	T64 <- system.time(X64 %/% X64) # too slow
	tdbl/t32 # x 0.5
	t64/t32  # x 1
	T64/t32  # x 500 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK

	tdbl <- system.time(xdbl %% xdbl)
	t32 <- system.time(x32 %% x32)
	t64 <- system.time(x64 %% x64) # OK
	T64 <- system.time(X64 %% X64) # too slow
	tdbl/t32 # x 0.5
	t64/t32  # x 1
	T64/t32  # x 500 = much too slow
	identical(as.integer64(x32), x64) # OK
	identical(as.int64(x32), X64) # OK



	tdbl <- system.time(sdbl <- sort(xdbl))
	t32 <- system.time(s32 <- sort(x32))
	T64 <- system.time(S64 <- sort(X64)) # too slow
	tdbl/t32 # x 1.2
	#t64/t32  #
	T64/t32  # x 10 = too slow



	identical(as.int64(s32), S64) # OK

	system.time(s32 <- sort(r32,  method = "quick"))
	system.time(s64 <- sort(r64,  method = "quick")) # too slow
	identical(as.int64(s32), s64) # OK





	n <- 1e6
	i64 <- integer64(n)
	I64 <- int64(n)

	length(serialize(int64(n), connection=NULL))
	object.size(i64)
	object.size(I64)


library(ff)
library(inline)
}