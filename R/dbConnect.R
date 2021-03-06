#' @include DoordaHostDriver.R DoordaHostConnection.R
NULL

#' @param drv A driver object generated by \code{\link{DoordaHost}}
#' @param catalog The catalog to be used
#' @param schema The schema to be used
#' @param user The current user
#' @param password The current users password
#' @param ... currently ignored
#' @return [dbConnect] A \code{\linkS4class{DoordaHostConnection}} object
#' @export
#' @rdname DoordaHost
#' @examples
#' \dontrun{
#'   conn <- dbConnect(DoordaHost(), catalog = 'hive', schema = 'default',
#'                     user = 'onur', password = 'pwd')
#'   dbListTables(conn, '%_iris')
#'   dbDisconnect(conn)
#' }
setMethod('dbConnect',
          'DoordaHostDriver',
          function(
            drv,
            catalog,
            schema,
            user,
            password,
            ...
          ) {

            if (password==""){
              stop("Password Needed")
            }

            conn <- new('DoordaHostConnection',
                        catalog=catalog,
                        schema=schema,
                        user=user,
                        password=password
            )
            return(conn)
          }
)
