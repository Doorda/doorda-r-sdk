#'Get Table Stats
#'
#'@description
#'This function returns the number of rows in the input table
#'
#'@param conn The connection to the database
#'@param table_name The name of the table in the catalogs-schema
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
#' catalogs = getTableStats(conn)
#' }
getTableStats <- function(conn, table_name, ...) {
  df = dbQuery(conn, sprintf("SHOW STATS FOR %s", table_name))
  df2 = data.frame(table_name, df[which(is.na(df$column_name)), ]$row_count)
  colnames(df2) = c("table_name", "number_of_rows")
  return(df2)
}
