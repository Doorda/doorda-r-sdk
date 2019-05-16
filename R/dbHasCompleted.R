#' @include DoordaHostResult.R
NULL

.dbHasCompleted <- function(res, ...) {
  return(res@cursor$hasCompleted())
}

#' @rdname DoordaHostResult-class
#' @export
setMethod('dbHasCompleted', 'DoordaHostResult', .dbHasCompleted)
