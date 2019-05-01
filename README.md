# Doorda R SDK

This package interacts with Doorda Hosted service on Presto for query execution.

## Features
- Automatic installation and loading of jdbc driver from https://github.com/doorda/drivers-cli
- Simplified functions

## Requirements
- Java 8

## Installation

```r
install.packages("devtools")
require("devtools")
devtools::install_github("doorda/doorda-r-sdk")
```

## Usage 

### Create Connection

```r
install.packages("DBI")
require("DBI")
conn <- dbConnect(DoordaHostClient::DoordaHost(),
                  user='username',
                  password='password',
                  catalog='catlog_name',
                  schema='schema_name')
```

### Check Database Connection
```r
isConnected(conn)
```

### Query Database

```r
results_df = dbQuery(conn, "SELECT * FROM table_name")
```

### Get Catalog Names

```r
catalog_names = showCatalogs(conn)
```

### Get Table Stats (Currently only number of rows supported)

```r
table_stats = getTableStats(conn, "catalog_name", "schema_name", "table_name")

```

### Problems

1) `installation of package ‘rJava’ had non-zero exit status`

Solution: 
Check that Java is installed correctly by running `java -version` in terminal
Then, run `sudo R CMD javareconf` to register Java with R. 

