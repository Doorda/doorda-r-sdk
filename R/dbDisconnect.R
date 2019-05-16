#' @include DoordaHostConnection.R
NULL

#' @param conn A \code{\linkS4class{DoordaHostConnection}} object
#' @return [dbDisconnect] A \code{\link{logical}} value indicating success
#' @export
#' @rdname DoordaHost
setMethod('dbDisconnect',
          'DoordaHostConnection',
          function(conn) {
            return(TRUE)
          }
)
