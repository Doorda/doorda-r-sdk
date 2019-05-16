#' @include DoordaHostResult.R
NULL

.dbIsValid <- function(dbObj, ...) {
  return(!dbObj@cursor$state() %in% c('__KILLED', 'FAILED'))
}

#' @rdname DoordaHostResult-class
#' @export
setMethod('dbIsValid', 'DoordaHostResult', .dbIsValid)
