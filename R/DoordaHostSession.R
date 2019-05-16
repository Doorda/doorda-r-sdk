#' @include utility_functions.R
NULL

DoordaHostSession <- setRefClass('DoordaHostSession',
                             fields=c(
                               '.parameters'='list'
                             ),
                             methods=list(
                               initialize=function(parameters, ...) {
                                 initFields(.parameters = parameters)
                               },
                               setParameter=function(key, value) {
                                 .parameters[[key]] <<- value
                               },
                               unsetParameter=function(key) {
                                 .parameters[[key]] <<- NULL
                               },
                               parameters=function() {
                                 return(.parameters)
                               },
                               parameterString=function() {
                                 return(paste(
                                   names(.parameters),
                                   .parameters,
                                   sep='=',
                                   collapse=','
                                 ))
                               }
                             )
)
