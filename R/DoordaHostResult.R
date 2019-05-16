#' @include utility_functions.R DoordaHostCursor.R DoordaHostConnection.R
NULL

#' An S4 class to represent a DoordaHost Result
#' @slot statement The SQL statement sent to the database
#' @slot connection The connection object associated with the result
#' @slot cursor An internal implementation detail for keeping track of
#'  what stage a request is in
#' @keywords internal
#' @export
setClass('DoordaHostResult',
         contains='DBIResult',
         slots=c(
           'statement'='character',
           'connection'='DoordaHostConnection',
           'cursor'='DoordaHostCursor'
         )
)

#' @rdname DoordaHostResult-class
#' @export
setMethod('show',
          'DoordaHostResult',
          function(object) {
            r <- object@cursor$postResponse()
            content <- response.to.content(r)
            stats <- object@cursor$stats()

            cat(
              '<DoordaHostResult: ', content[['id']], '>\n',
              'Status Code: ', httr::status_code(r), '\n',
              'State: ', object@cursor$state(), '\n',
              'Info URI: ', object@cursor$infoUri(), '\n',
              'Next URI: ', object@cursor$nextUri(), '\n',
              'Splits (Queued/Running/Completed/Total): ',
              paste(
                c(
                  stats[['queuedSplits']],
                  stats[['runningSplits']],
                  stats[['completedSplits']],
                  stats[['totalSplits']]
                ),
                collapse=' / '
              ), '\n',
              'Session Time Zone: ', object@connection@session.timezone, '\n',
              sep=''
            )
          }
)
