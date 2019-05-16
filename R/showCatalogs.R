#'List all Catalogs
#'
#'@description
#'This function returns a list of all Catalogs in defined Catalog/Schema
#'
#'@param conn The connection to the database
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
#' catalogs = showCatalogs(conn)
#' }
showCatalogs <- function(conn, ...) {
  statement <- 'SHOW CATALOGS'
  rv <- dbQuery(conn, statement)
  if (nrow(rv)) {
    char_vector = rv[['Catalog']]
    return(char_vector[!char_vector=="system"])
  } else {
    return(character(0))
  }
}
