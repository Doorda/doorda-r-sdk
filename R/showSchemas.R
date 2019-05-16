#'List all Schemas in Catalog
#'
#'@description
#'This function returns a list of all Schemas in defined Catalog
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
#' catalogs = showSchemas(conn)
#' }
showSchemas <- function(conn, ...) {
  statement <- 'SHOW SCHEMAS'
  rv <- dbQuery(conn, statement)
  if (nrow(rv)) {
    char_vector = rv[['Schema']]
    return(char_vector[!char_vector=="information_schema"])
  } else {
    return(character(0))
  }
}
