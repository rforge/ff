.onLoad <- function(lib, pkg) {
  ##library.dynam("bit64", pkg, lib) use useDynLib(bit) in NAMESPACE instead
  packageStartupMessage("Loading package bit64 ", packageDescription("bit64", fields="Version"))
  packageStartupMessage("package:bit64 (c) 2011 Jens Oehlschlaegel (GPL-2)")
  packageStartupMessage("creators: integer64 seq :")
  packageStartupMessage("coercion: as.integer64 as.vector as.logical as.integer as.double as.character as.bin")
  packageStartupMessage("logical operator: ! & | xor != == < <= >= >")
  packageStartupMessage("arithmetic operator: + - * / %/% %% ^")
  packageStartupMessage("math: sign abs sqrt log log2 log10")
  packageStartupMessage("math: floor ceiling trunc round")
  packageStartupMessage("querying: is.integer64 is.vector [is.atomic} [length] is.na format print")
  packageStartupMessage("aggregation: any all min max range sum prod")
  packageStartupMessage("cumulation: diff cummin cummax cumsum cumprod")
  packageStartupMessage("access: length<- [ [<- [[ [[<-")
  packageStartupMessage("combine: c rep cbind rbind as.data.frame")
  packageStartupMessage("for more help type ?bit64")
}

.onUnload <- function(libpath){
   packageStartupMessage("Unloading package bit64")
   library.dynam.unload("bit64", libpath)
}
