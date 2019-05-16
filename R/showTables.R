#'List Tables in Catalog/Schema
#'
#'@description
#'This function returns a list of all tables in defined Catalog/Schema
#'
#'@param conn The connection to the database
#'@param pattern optional SQL pattern for filtering table names,
#'                e.g. \sQuote{\%test\%}
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
#' table = showTables(conn, "eng_%")
#' }
showTables <- function(conn, pattern, ...) {
  if (!missing(pattern)) {
    statement <- paste('SHOW TABLES LIKE', dbQuoteString(conn, pattern))
  } else {
    statement <- 'SHOW TABLES'
  }
  rv <- dbQuery(conn, statement)
  if (nrow(rv)) {
    return(rv[['Table']])
  } else {
    return(character(0))
  }
}
