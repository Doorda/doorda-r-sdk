#' @include DoordaHostResult.R
NULL

.dbGetStatement <- function(res, ...) {
  return(res@statement)
}

#' @rdname DoordaHostResult-class
#' @export
setMethod('dbGetStatement', 'DoordaHostResult', .dbGetStatement)
