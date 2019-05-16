#' @include dbHasCompleted.R DoordaHostResult.R request_headers.R
NULL

#' @rdname DoordaHostResult-class
#' @export
setMethod('dbClearResult',
          c('DoordaHostResult'),
          function(res, ...) {
            if (dbHasCompleted(res)) {
              return(TRUE)
            }

            uri <- res@cursor$nextUri()
            if (uri == '') {
              return(TRUE)
            }

            if (res@cursor$state() == '__KILLED') {
              return(TRUE)
            }

            headers <- .request_headers(res@connection)
            delete.result <- httr::DELETE(uri, config=headers)
            s <- httr::status_code(delete.result)
            if (s >= 200 && s < 300) {
              res@cursor$state('__KILLED')
              rv <- TRUE
            } else {
              rv <- FALSE
            }
            return(rv)
          }
)
