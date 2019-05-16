#' @include DoordaHostConnection.R DoordaHostCursor.R request_headers.R utility_functions.R
NULL

.dbSendQuery <- function(conn, statement, ...) {
  url <- paste0('https://host.doorda.com:443/v1/statement')
  status <- 503L
  retries <- 3
  headers <- .request_headers(conn)
  while (status == 503L || (retries > 0 && status >= 400L)) {
    wait()
    post.response <- httr::POST(
      url,
      body=enc2utf8(statement),
      config=headers
    )
    status <- as.integer(httr::status_code(post.response))
    if (status >= 400L && status != 503L) {
      retries <- retries - 1
    }
  }
  check.status.code(post.response)
  content <- response.to.content(post.response)
  if (status == 200) {
    if (get.state(content) == 'FAILED') {
      stop.with.error.message(content)
    } else {
      cursor <- DoordaHostCursor$new(post.response)
      rv <- new('DoordaHostResult',
                statement=statement,
                connection=conn,
                cursor=cursor
      )
    }
  } else {
    stop('Unknown error, status code:', status, ', response: ', content)
  }
  return(rv)
}

# #' @rdname DoordaHostConnection-class
# #' @export
# setMethod('dbSendQuery', c('DoordaHostConnection', 'character'), .dbSendQuery)
