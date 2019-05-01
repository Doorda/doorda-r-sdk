#' @importFrom utils packageVersion download.file
#' @importFrom rJava .jpackage
.onLoad <- function(libname, pkgname) {
  
  version <- packageVersion(pkgname)[1,1] # drop internal releases eg 1.1.0-1 -> 1.1.0
  
  ## path to the JDBC driver
  path <- file.path(system.file('', package = pkgname), 'java')
  if (!file.exists(path)) {
    dir.create(path)
  }
  
  file <- sprintf('DoordaHostJDBC_%sd.jar', version)
  path <- file.path(path, file)
  
  ## check if the jar is available and install if needed (on first load)
  if (!file.exists(path)) {
    
    url <- paste0('https://github.com/Doorda/drivers-cli/raw/master/doordahost/jdbc/', file)
    
    ## download the jar file from DoordaPortal
    try(download.file(url = url, destfile = path, mode = 'wb'),
        silent = TRUE)
  }

  ## add the RJDBC driver and the log4j properties file to classpath
  rJava::.jpackage(pkgname, lib.loc = libname)
  
}

.onAttach <- function(libname, pkgname) {
  
  ## let the user know if the automatic JDBC driver installation failed
  path <- system.file('java', package = pkgname)
  if (length(list.files(path, '^DoordaHostJDBC_[0-9d.]*jar$')) == 0) {
    packageStartupMessage(
      'The automatic installation of the DoordaHost JDBC driver seems to have failed.\n',
      'Please check your Internet connection and if the current user can write to ', path, '\n',
      'If still having issues, install the jar file manually from:\n',
      'https://github.com/Doorda/drivers-cli/tree/master/doordahost/jdbc\n',
      'and take a look at our guide at:',
      'https://github.com/Doorda/Getting-Started/blob/master/tools/jdbc.md#jdbc-driver\n')
  }
}

