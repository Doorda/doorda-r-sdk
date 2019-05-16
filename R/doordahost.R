#' @include DoordaHostDriver.R
NULL

#' Connect to a Doorda database
#' @return [DoordaHost] A \code{\linkS4class{DoordaHostDriver}} object
#' @rdname DoordaHost
#' @export
DoordaHost <- function(...) {
  return(new('DoordaHostDriver'))
}