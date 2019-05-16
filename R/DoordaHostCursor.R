#' @include utility_functions.R
NULL

DoordaHostCursor <- setRefClass('DoordaHostCursor',
                            fields=c(
                              '.uri'='character',
                              '.info.uri'='character',
                              '.state'='character',
                              '.fetched.row.count'='integer',
                              '.stats'='list',
                              '.post.response'='ANY',
                              '.post.data.parsed'='logical'
                            ),
                            methods=list(
                              initialize=function(post.response, ...) {
                                initFields(
                                  .fetched.row.count=as.integer(0),
                                  .post.data.parsed=FALSE,
                                  .post.response=post.response
                                )
                                post.content <- response.to.content(post.response)
                                if (is.null(post.content[['data']])) {
                                  .post.data.parsed <<- TRUE
                                }
                                updateCursor(post.content, 0)
                              },
                              # A cleaner design would be to pass the response
                              # directly as an argument, but that would mean parsing
                              # the content multiple times.
                              updateCursor=function(response.content, row.count) {

                                if (is.null(response.content[['nextUri']])) {
                                  .uri <<- ""
                                } else {
                                  .uri <<- response.content[['nextUri']]
                                }

                                if (is.null(response.content[['infoUri']])) {
                                  .info.uri <<- ""
                                } else {
                                  .info.uri <<- response.content[['infoUri']]
                                }

                                state(get.state(response.content))

                                stats(response.content[['stats']])

                                .fetched.row.count <<- .fetched.row.count + as.integer(row.count)
                              },
                              infoUri=function() {
                                return(.info.uri)
                              },
                              nextUri=function() {
                                return(.uri)
                              },
                              fetchedRowCount=function() {
                                return(.fetched.row.count)
                              },
                              postResponse=function() {
                                return(.post.response)
                              },
                              state=function(new.state) {
                                old.state <- .state
                                if (!missing(new.state)) {
                                  if (is.null(new.state)) {
                                    .state <<- ""
                                  } else {
                                    .state <<- new.state
                                  }
                                }
                                return(old.state)
                              },
                              stats=function(new.stats) {
                                old.stats <- .stats
                                if (!missing(new.stats)) {
                                  .stats <<- new.stats
                                }
                                return(old.stats)
                              },
                              hasCompleted=function() {
                                return(
                                  .uri == ''
                                  && postDataParsed()
                                )
                              },
                              postDataParsed=function(value) {
                                old.value <- .post.data.parsed
                                if (!missing(value)) {
                                  .post.data.parsed <<- value
                                }
                                return(old.value)
                              }
                            )
)
