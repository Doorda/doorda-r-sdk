#' @include DoordaHostSession.R
NULL

#' S4 implementation of \code{DBIConnection} for DoordaHost
#'
#' @keywords internal
#' @export
setClass('DoordaHostConnection',
         contains='DBIConnection',
         slots=c(
           'catalog'='character',
           'schema'='character',
           'user'='character',
           'password'='character'
         )
)

#' @rdname DoordaHostConnection-class
#' @export
setMethod('show',
          'DoordaHostConnection',
          function(object) {
            cat(
              '<DoordaHostConnection: https://host.doorda.com:443>\n',
              'Catalog: ', object@catalog, '\n',
              'Schema: ', object@schema, '\n',
              'User: ', object@user, '\n',
              'Source: doorda-r-sdk \n',
              sep=''
            )
            parameters <- NULL
            if (!is.null(parameters) && length(parameters)) {
              cat(
                'Parameters:\n',
                paste(
                  '\t', names(parameters), ': ', unlist(parameters), '\n',
                  sep='',
                  collapse=''
                ),
                sep=''
              )
            }
          }
)
