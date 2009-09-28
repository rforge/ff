\name{chunk.ffdf}
\Rdversion{1.1}
\alias{chunk.ffdf}
\title{
   Chunk ffdf
}
\description{
   Row-wise chunking method for ffdf objects automatically considering RAM requirements from recordsize as calculated from \code{\link{sum}(\link{.rambytes}[\link[=vmode.ffdf]{vmode}])}
}
\usage{
\method{chunk}{ffdf}(x, \dots, BATCHBYTES = getOption("ffbatchbytes"))
}
\arguments{
  \item{x}{\code{\link{ffdf}}}
  \item{\dots}{further arguments passed to \code{\link[bit]{chunk}}}
  \item{BATCHBYTES}{ integer scalar limiting the number of bytes to be processed in one chunk, default from \code{getOption("ffbatchbytes")}, see also \code{\link{.rambytes}} }
}
\value{
  A list with \code{\link[bit]{ri}} indexes each representing one chunk
}
\author{
  Jens Oehlschlägel
}
\seealso{ \code{\link[bit]{chunk}}, \code{\link{ffdf}} }
\examples{
  x <- data.frame(x=as.double(1:26), y=factor(letters), z=ordered(LETTERS))
  a <- as.ffdf(x)
  ceiling(26 / (300 \%/\% sum(.rambytes[vmode(a)])))
  chunk(a, BATCHBYTES=300)
  ceiling(13 / (100 \%/\% sum(.rambytes[vmode(a)])))
  chunk(a, from=1, to = 13, BATCHBYTES=100)
  rm(a); gc()
}
\keyword{ IO }
\keyword{ data }
