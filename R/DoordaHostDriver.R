#' An S4 class to represent a DoordaHost Driver (and methods)
#' It is used purely for dispatch and \code{dbUnloadDriver} is unnecessary
#'
#' @keywords internal
#' @export
#' @importFrom methods setClass setGeneric setMethod setRefClass
#' @importFrom methods show getPackageName new
#' @import DBI
setClass('DoordaHostDriver',
         contains='DBIDriver'
)

#' @rdname DoordaHostDriver-class
#' @export
setMethod('show',
          'DoordaHostDriver',
          function(object) {
            cat('<DoordaHostDriver>\n')
          }
)
