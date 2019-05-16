.request_headers <- function(conn) {
  headers <- httr::add_headers(
    "X-Presto-User"= conn@user,
    "X-Presto-Catalog"= conn@catalog,
    "X-Presto-Schema"= conn@schema,
    "X-Presto-Source"= "doorda-r-client 309.1.0",
    "User-Agent"= getPackageName()
  )
  return(c(headers, httr::authenticate(user=conn@user,password=conn@password)))
}
