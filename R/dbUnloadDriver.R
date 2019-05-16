#' @include DoordaHostDriver.R
NULL

#' @rdname DoordaHostDriver-class
#' @export
setMethod('dbUnloadDriver',
          'DoordaHostDriver',
          function(drv, ...) {
            return(TRUE)
          }
)
