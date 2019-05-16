#' @include dbListTables.R DoordaHostConnection.R
NULL

#' @rdname DoordaHostConnection-class
#' @export
setMethod('dbExistsTable',
          c('DoordaHostConnection', 'character'),
          function(conn, name, ...) {
            return(tolower(name) %in% tolower(dbListTables(conn, pattern=name)))
          }
)
