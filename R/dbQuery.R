#'Get results from query
#'
#'@description
#'This function executes the query and returns query results
#'
#'@param conn The connection to the database
#'@param statement The SQL query statement
#'@param ... currently ignored
#'@export
#' @examples
#' \dontrun{
#' require(DBI)
#' conn <- dbConnect(DoordaHost(),
#'                  user='username',
#'                  password='password',
#'                  catalog='doordastats_snapshot',
#'                  schema='doordastats_snapshot')
#'
#' table = dbQuery(conn, "SELECT * FROM table_name")
#' }
dbQuery <- function(conn, statement, ...) {
  result <- .dbSendQuery(conn, statement, ...)
  on.exit(dbClearResult(result))
  df = data.frame()
  progress.bar <- NULL
  while(!dbHasCompleted(result)){
    chunk <- dbFetch(result)
    if (!NROW(df)){
      df <- chunk
    } else if (NROW(chunk)){
      df <- rbind(df, chunk)
    }
    stats <- dbGetInfo(result)[['stats']]
    if (stats[['state']] == 'RUNNING'){
      if (is.null(progress.bar)){
        progress.bar <- utils::txtProgressBar(0, stats[['totalSplits']], style = 3)
      } else {
        utils::setTxtProgressBar(progress.bar, stats[['completedSplits']])
      }
    }
  }
  if (!is.null(progress.bar)){
    utils::setTxtProgressBar(progress.bar, stats[['completedSplits']])
    close(progress.bar)
  }
  return(df)
}
