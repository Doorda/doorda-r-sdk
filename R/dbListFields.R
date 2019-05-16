#' @include dbGetQuery.R DoordaHostConnection.R DoordaHostResult.R utility_functions.R
NULL

#' @rdname DoordaHostConnection-class
#' @export
setMethod('dbListFields',
          c('DoordaHostConnection', 'character'),
          function(conn, name, ...) {
            quoted.name <- dbQuoteIdentifier(conn, name)
            names(dbQuery(conn, paste('SELECT * FROM', quoted.name, 'LIMIT 0')))
          }
)

#' @rdname DoordaHostResult-class
#' @export
setMethod('dbListFields',
          signature(conn='DoordaHostResult', name='missing'),
          function(conn, name) {
            if (!dbIsValid(conn)) {
              stop('The result object is not valid')
            }
            # We cannot use the result object without advancing the cursor.
            # Sometimes doordahost does not return the full column information, e.g.
            # for the PLANNING state. So we have to kick off a new query.
            new_query <- sprintf("SELECT * FROM (%s) WHERE 1 = 0", conn@statement)
            output <- dbQuery(conn@connection, new_query)
            return(colnames(output))
          }
)
