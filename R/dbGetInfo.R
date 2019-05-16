#' @include DoordaHostDriver.R DoordaHostConnection.R DoordaHostResult.R
NULL

#' @export
setMethod("dbGetInfo",
          "DoordaHostDriver",
          function(dbObj) {
            return()
          }
)

#' @export
setMethod("dbGetInfo",
          "DoordaHostConnection",
          function(dbObj) {
            return(list(
              user=dbObj@user,
              password=dbObj@password,
              catalog=dbObj@catalog,
              schema=dbObj@schema
            ))
          }
)

.dbGetInfo.DoordaHostResult <- function(dbObj) {
  return(list(
    statement=.dbGetStatement(dbObj),
    row.count=.dbGetRowCount(dbObj),
    has.completed=.dbHasCompleted(dbObj),
    stats=dbObj@cursor$stats()
  ))
}
setMethod("dbGetInfo", "DoordaHostResult", .dbGetInfo.DoordaHostResult)
