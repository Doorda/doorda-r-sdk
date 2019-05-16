#'Check DoordaHost connection
#'
#'@description
#'This function sends a ping to DoordaHost to check if connection is successful
#'
#'@param conn The connection to the database
#'@param ... currently ignored
#'@import attempt
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
#' isConnected(conn)
#' }
isConnected <- function(conn, ...) {
  TRY = attempt(dbQuery(conn, "SELECT 1"), verbose=TRUE, msg = "Unable to connect. Authentication Failed")
  if (is_try_error(TRY)){
    return(FALSE)
  }
  return(TRUE)
}
