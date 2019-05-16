#' @include dbFetch.R DoordaHostResult.R
NULL

.defer.to.dbFetch <- function(res, n, ...) {
  return(dbFetch(res, n, ...))
}
#' @rdname DoordaHostResult-class
#' @export
setMethod('fetch', c('DoordaHostResult', 'integer'), .defer.to.dbFetch)

#' @rdname DoordaHostResult-class
#' @export
setMethod('fetch', c('DoordaHostResult', 'numeric'), .defer.to.dbFetch)

# due to the way generics are set, if we do not do this override the default
# value from the generic n=-1 gets set which could give wrong results
#' @rdname DoordaHostResult-class
#' @export
setMethod(
  'fetch',
  c('DoordaHostResult', 'missing'),
  function(res) {
    return(dbFetch(res))
  }
)
