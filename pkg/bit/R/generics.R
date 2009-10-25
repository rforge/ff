# 1-bit boolean vectors for R
# (c) 2008-2009 Jens Oehlschägel
# Licence: GPL2
# Provided 'as is', use at your own risk

# source("D:/mwp/eanalysis/bit/R/generics.R")

as.bit <- function(x, ...)
  UseMethod("as.bit", x)

as.which <- function (x, ...)
  UseMethod("as.which")

as.bitwhich <- function(x, ...)
  UseMethod("as.bitwhich")


xor <- function(x, y)
  UseMethod("xor", x)



physical <- function(x)UseMethod("physical")

"physical<-" <- function(x, value)UseMethod("physical<-")

virtual <- function(x)UseMethod("virtual")

"virtual<-" <- function(x, value)UseMethod("virtual<-")

