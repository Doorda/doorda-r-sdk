#' @include DoordaHostResult.R
NULL

.dbGetRowCount <- function(res, ...) {
  return(res@cursor$fetchedRowCount())
}

#' @rdname DoordaHostResult-class
#' @export
setMethod('dbGetRowCount', 'DoordaHostResult', .dbGetRowCount)
