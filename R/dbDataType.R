#' @include DoordaHostDriver.R
NULL

.doordahost.to.R <- as.data.frame(matrix(c(
  'boolean', 'logical',
  'bigint', 'integer',
  'integer', 'integer',
  'smallint', 'integer',
  'tinyint', 'integer',
  'decimal', 'character',
  'real', 'numeric',
  'double', 'numeric',
  'varchar', 'character',
  'char', 'character',
  'varbinary', 'raw',
  'json', 'character',
  'date', 'Date',
  'time', 'character',
  'time with time zone', 'character',
  'timestamp', 'POSIXct_no_time_zone',
  'timestamp with time zone', 'POSIXct_with_time_zone',
  'interval year to month', 'character',
  'interval day to second', 'character',
  'array', 'list_unnamed',
  'map', 'list_named',
  'unknown', 'unknown'
), byrow=TRUE, ncol=2), stringsAsFactors=FALSE)
colnames(.doordahost.to.R) <- c('doordahost.type', 'R.type')



.R.to.doordahost <- as.data.frame(matrix(c(
  'boolean', 'logical',
  'bigint', 'integer',
  'double', 'double',
  'varchar', 'character',
  'varbinary', 'raw',
  'date', 'Date',
  'json', NA,
  'time', NA,
  'time with time zone', NA,
  'timestamp', 'POSIXct_no_time_zone',
  'timestamp with time zone', 'POSIXct_with_time_zone',
  'interval year to month', NA,
  'interval day to second', NA,
  'array', 'list_unnamed',
  'map', 'list_named',
  'varchar', 'factor',
  'varchar', 'ordered',
  'varchar', 'NULL'
), byrow=TRUE, ncol=2), stringsAsFactors=FALSE)
colnames(.R.to.doordahost) <- c('doordahost.type', 'R.type')

.R.to.doordahost.env <- new.env(hash=TRUE, size=NROW(.R.to.doordahost))
for (i in 1:NROW(.R.to.doordahost)) {
  if (is.na(.R.to.doordahost[i, 'R.type'])) {
    next
  }
  assign(
    .R.to.doordahost[i, 'R.type'],
    value=.R.to.doordahost[i, 'doordahost.type'],
    envir=.R.to.doordahost.env
  )
}

.non.complex.types <- c(
  'logical',
  'character',
  'raw',
  'Date',
  'factor',
  'ordered',
  'NULL'
)
.non.complex.types.env <- new.env(hash=TRUE, size=length(.non.complex.types))
for (i in seq_along(.non.complex.types)) {
  assign(.non.complex.types[i], TRUE, envir=.non.complex.types.env)
}


.dbDataType <- function(dbObj, obj, ...) {
  rs.class <- data.class(obj)
  rs.mode <- storage.mode(obj)

  if (!is.null(.non.complex.types.env[[rs.class]])) {
    rv <- .R.to.doordahost.env[[rs.class]]
  } else if (rs.class == 'numeric') {
    rv <- .R.to.doordahost.env[[rs.mode]]
  } else if (rs.class == 'POSIXct') {
    tzone <- attr(obj, 'tzone')
    if (is.null(tzone) || tzone == '') {
      index <- 'POSIXct_no_time_zone'
    } else {
      index <- 'POSIXct_with_time_zone'
    }
    rv <- .R.to.doordahost.env[[index]]
  } else if (rs.class == 'list') {
    if (length(obj) == 0) {
      inner.type <- .dbDataType(dbObj, NULL)
    } else {
      inner.types <- vapply(
        obj,
        function(x) .dbDataType(dbObj, x),
        ''
      )
      inner.type <- inner.types[1]
      if (!all(inner.types == inner.type)) {
        inner.type <- NA
      }
    }
    if (is.na(inner.type)) {
      rv <- 'varchar'
    } else {
      if (!is.null(names(obj))) {
        rv <- paste('map<varchar, ', inner.type, '>', sep='')
      } else {
        rv <- paste('array<', inner.type, '>', sep='')
      }
    }
  } else {
    rv <- 'varchar'
  }

  if (is.na(rv)) {
    rv <- 'varchar'
  }
  # We need to explicitly specify the locale for the upper transformation.
  # For certain locales like tr_TR, the uppercase for 'i' is 'İ'
  # so toupper('bigint') does not give the expected result
  return(stringi::stri_trans_toupper(rv, 'en_US.UTF-8'))
}

#' @export
setMethod('dbDataType', 'DoordaHostDriver', .dbDataType)
