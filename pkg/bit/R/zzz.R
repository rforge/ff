.onLoad <- function(lib, pkg) {
  ##library.dynam("bit", pkg, lib) use useDynLib(bit) in NAMESPACE instead
  cat("Loading package bit", installed.packages()["bit","Version"], "\n")
  bit_init()
  cat("package:bit (c) 2008/2009 Jens Oehlschlaegel (GPL-2)\n")
  cat("creators: bit bitwhich\n")
  cat("coercion: as.logical as.integer as.bit as.bitwhich which\n")
  cat("operator: ! & | xor != == \n")
  cat("querying: print length any all min max range sum summary\n")
  cat("bit access: length<- [ [<- [[ [[<-\n")
  cat("for more help type ?bit\n")
}

.onUnload <- function(libpath){
   cat("Unloading package bit\n")
   bit_done()
   library.dynam.unload("bit", libpath)
}
