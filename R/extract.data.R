#' @include json.tabular.to.data.frame.R dbDataType.R
NULL

.extract.data <- function(response.content, timezone) {
  data.list <- response.content[['data']]
  if (is.null(data.list)) {
    data.list <- list()
  }
  column.list <- response.content[['columns']]
  if (is.null(column.list)) {
    column.list <- list()
  }
  column.info <- .json.tabular.to.data.frame(
    column.list,
    # name, type, typeSignature
    c(varchar='character', varchar='character', map='list_named')
  )
  # The typeSignature item for each column has a 'rawType' value which
  # corresponds to the DoordaHost data type.
  doordahost.types <- vapply(
    column.info[['typeSignature']],
    function(x) x[['rawType']],
    ''
  )
  r.types <- with(.doordahost.to.R, R.type[match(doordahost.types, doordahost.type)])
  names(r.types) <- doordahost.types
  rv <- .json.tabular.to.data.frame(data.list, r.types, timezone=timezone)
  if (!is.null(column.info[['name']])) {
    colnames(rv) <- column.info[['name']]
  }
  return(rv)
}
