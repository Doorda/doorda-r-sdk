#' @include DoordaHostConnection.R dbGetQuery.R
NULL

setMethod('dbListTables',
          'DoordaHostConnection',
          function(conn, pattern, ...) {
            if (!missing(pattern)) {
              statement <- paste('SHOW TABLES LIKE', dbQuoteString(conn, pattern))
            } else {
              statement <- 'SHOW TABLES'
            }
            rv <- dbGetQuery(conn, statement)
            if (nrow(rv)) {
              return(rv[['Table']])
            } else {
              return(character(0))
            }
          }
)


