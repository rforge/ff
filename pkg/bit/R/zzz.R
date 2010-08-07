.onLoad <- function(lib, pkg) {
  ##library.dynam("bit", pkg, lib) use useDynLib(bit) in NAMESPACE instead
  packageStartupMessage("Loading package bit", packageDescription("bit", fields="Version"), "\n")
  bit_init()
  packageStartupMessage("package:bit (c) 2008/2009 Jens Oehlschlaegel (GPL-2)\n")
  packageStartupMessage("creators: bit bitwhich\n")
  packageStartupMessage("coercion: as.logical as.integer as.bit as.bitwhich which\n")
  packageStartupMessage("operator: ! & | xor != == \n")
  packageStartupMessage("querying: print length any all min max range sum summary\n")
  packageStartupMessage("bit access: length<- [ [<- [[ [[<-\n")
  packageStartupMessage("for more help type ?bit\n")
}

.onUnload <- function(libpath){
   packageStartupMessage("Unloading package bit\n")
   bit_done()
   library.dynam.unload("bit", libpath)
}
