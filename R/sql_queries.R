#'List all Catalogs
#'
#'@description
#'This function returns a list of all catalogs
#'
#'@param connection The connection to the database
#'
#'@export
#' @examples
#' \dontrun{
#' require(DBI)
#' conn <- dbConnect(DoordaHostClient::DoordaHost(),
#'                  user='username',
#'                  password='password',
#'                  catalog='catalog_name',
#'                  schema='schema_name')
#'
#' catalog_list = showCatalogs(conn)
#' }
showCatalogs <- function(connection) {
  if (connection@identifier.quote == "doordahost") {
    results = dbQuery(connection, "SHOW CATALOGS")
    return(subset(results, results$Catalog != "system"))
  }
}


#'Get results from query
#'
#'@description
#'This function executes the query and returns query results
#'
#'@param connection The connection to the database
#'@param query Query statement
#'
#'@export
#' @examples
#' \dontrun{
#' require(DBI)
#' conn <- dbConnect(DoordaHostClient::DoordaHost(),
#'                  user='username',
#'                  password='password',
#'                  catalog='catalog_name',
#'                  schema='schema_name')
#'
#' catalog_list = dbQuery(conn, "SELECT * FROM table_name")
#' }
dbQuery <- function(connection, query){
  if (connection@identifier.quote == "doordahost") {
    return(dbGetQuery(connection, query))
  }
}


#'Get table stats
#'
#'@description
#'This function executes the query and returns query results
#'
#'@param connection The connection to the database
#'@param catalog Name of Catalog
#'@param schema Name of Schema (Usually the same as catalog)
#'@param table Name of Table
#'@export
#' @examples
#' \dontrun{
#' require(DBI)
#' conn <- dbConnect(DoordaHostClient::DoordaHost(),
#'                  user='username',
#'                  password='password',
#'                  catalog='doordastats_snapshot',
#'                  schema='doordastats_snapshot')
#'
#' catalog_list = getTableStats(conn, 
#'                              catalog="doordastats_snapshot", 
#'                              schema="doordastats_snapshot", 
#'                              table="eng_area_household_car_van")
#' }
getTableStats <- function(connection, catalog="", schema="", table=""){
  if (connection@identifier.quote == "doordahost") {
    df = dbQuery(connection, sprintf("SHOW STATS FOR %s.%s.%s", catalog, schema, table))
    df2 = data.frame(table, df[which(is.na(df$column_name)), ]$row_count)
    colnames(df2) = c("table_name", "number_of_rows")
    return(df2)
  }
  stop("Catalog/Schema not found")
}

#'Check DoordaHost connection
#'
#'@description
#'This function sends a ping to DoordaHost to check if connection is successful
#'
#'@param connection The connection to the database
#'@export
#' @examples
#' \dontrun{
#' require(DBI)
#' conn <- dbConnect(DoordaHostClient::DoordaHost(),
#'                  user='username',
#'                  password='password',
#'                  catalog='doordastats_snapshot',
#'                  schema='doordastats_snapshot')
#'
#'isConnected(conn)
#' }
isConnected <- function(connection){
  if (connection@identifier.quote == "doordahost") {
    TRY = attempt(dbQuery(connection, "SELECT 1"), verbose=FALSE, msg = "Unable to connect. Authentication Failed")
    if (is_try_error(TRY)){
      return(FALSE)
    }
    return(TRUE)
  }
  stop("Catalog/Schema not found")
}

