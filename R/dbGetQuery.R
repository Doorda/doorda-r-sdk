#' @include dbFetch.R dbSendQuery.R dbHasCompleted.R DoordaHostConnection.R dbGetInfo.R
NULL

.dbGetQuery <- function(conn, statement, ...) {
  result <- .dbSendQuery(conn, statement, ...)
  on.exit(dbClearResult(result))
  return(.fetch.all(result))
}

#' @rdname DoordaHostConnection-class
#' @export
setMethod('dbGetQuery', c('DoordaHostConnection', 'character'), .dbGetQuery)
