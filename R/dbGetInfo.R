#' @include DoordaHostDriver.R DoordaHostConnection.R DoordaHostResult.R
NULL

#' Metadata about database objects
#' @rdname dbGetInfo
#' @export
setMethod("dbGetInfo",
          "DoordaHostDriver",
          function(dbObj) {
            return()
          }
)


#' @rdname dbGetInfo
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

#' For the \code{\linkS4class{DoordaHostResult}} object, the implementation
#' returns the additional \code{stats} field which can be used to
#' implement things like progress bars. See the examples section.
#' @param dbObj A \code{\linkS4class{DoordaHostDriver}},
#'          \code{\linkS4class{DoordaHostConnection}}
#'          or \code{\linkS4class{DoordaHostResult}} object
#' @return [DoordaHostResult] A \code{\link{list}} with elements
#'   \describe{
#'     \item{statement}{The SQL sent to the database}
#'     \item{row.count}{Number of rows fetched so far}
#'     \item{has.completed}{Whether all data has been fetched}
#'     \item{stats}{Current stats on the query}
#'   }
#' @rdname dbGetInfo
#' @export
#' @examples
#' \dontrun{
#'   conn <- dbConnect(DoordaHost(), 'localhost', 7777, 'onur', 'datascience')
#'   result <- dbSendQuery(conn, 'SELECT * FROM jonchang_iris')
#'   iris <- data.frame()
#'   progress.bar <- NULL
#'   while (!dbHasCompleted(result)) {
#'     chunk <- dbFetch(result)
#'     if (!NROW(iris)) {
#'       iris <- chunk
#'     } else if (NROW(chunk)) {
#'       iris <- rbind(iris, chunk)
#'     }
#'     stats <- dbGetInfo(result)[['stats']]
#'     if (is.null(progress.bar)) {
#'       progress.bar <- txtProgressBar(0, stats[['totalSplits']], style=3)
#'     } else {
#'       setTxtProgressBar(progress.bar, stats[['completedSplits']])
#'     }
#'   }
#'   close(progress.bar)
#' }
setMethod("dbGetInfo", "DoordaHostResult", .dbGetInfo.DoordaHostResult)
