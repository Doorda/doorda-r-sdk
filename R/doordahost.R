#' DoordaHost driver class.
#'
#' @keywords internal
#' @export
#' @import RJDBC
#' @import methods
#' @import attempt
#' @importClassesFrom RJDBC JDBCDriver
setClass("DoordaHostDriver", contains = "JDBCDriver")


#' DoordaHost DBI wrapper
#'
#' @export
DoordaHost <- function() {
  new("DoordaHostDriver")
}

#' Constructor of DoordaHostDriver
#' @name DoordaHostDriver
#' @rdname DoordaHostDriver-class
setMethod(initialize, "DoordaHostDriver",
          function(.Object, ...)
          {
            jdbc <- JDBC(driverClass="io.prestosql.jdbc.PrestoDriver",
                         identifier.quote="doordahost")
            .Object@jdrv = jdbc@jdrv
            .Object@identifier.quote = jdbc@identifier.quote
            .Object
          })

#' DoordaHost connection class.
#'
#' Class which represents the DoordaHost connections.
#'
#' @export
#' @importClassesFrom RJDBC JDBCConnection
#' @keywords internal
setClass("DoordaHostConnection",
         contains = "JDBCConnection",
         slots = list(
           user = "character",
           password = "character",
           catalog = "character",
           schema = "character"
         )
)


#'Wrapper to connect to Doorda Hosted platform.
#'
#'
#'
#' @param drv An object created by \code{DoordaHost()}
#' @param user user of account
#' @param password password of account
#' @param catalog catalog to connect to
#' @param schema schema to connect to (optional)
#' @param ... Other options
#' @rdname DoordaHost
#' @seealso \href{https://github.com/Doorda/Getting-Started}{Getting Started Guide} for more connections options and information.
#' @export
#' @examples
#' \dontrun{
#' require(DBI)
#' conn <- dbConnect(DoordaHostClient::DoordaHost(),
#'                  user='username',
#'                  password='password',
#'                  catalog='catalog_name',
#'                  schema='schema_name')
#'
#' dbQuery(conn, "SELECT * FROM table_name")
#' }
setMethod("dbConnect", "DoordaHostDriver",
          function(drv, user, password, catalog="", schema="", ...) {
            host = 'jdbc:doordahost://host.doorda.com:443'
            applicationNamePrefix="doorda-r-client-v1"
            uri_constructor = sprintf('/%s/%s?applicationNamePrefix=%s', catalog, schema, applicationNamePrefix)
            uri_constructor = gsub("//", "/", uri_constructor)
            hostname = paste0(host, uri_constructor, sep="")
            con <- callNextMethod(drv, url=hostname,
                                  user=user,
                                  password=password,...)
            new("DoordaHostConnection", jc = con@jc, identifier.quote = drv@identifier.quote,
                user=user, password=password,
                catalog=catalog, schema=schema)
          })
