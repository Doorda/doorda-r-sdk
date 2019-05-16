# Doorda R SDK

This package interacts with Doorda Hosted service on Presto for query execution.

## Features
- Simplified Functions
- Progress Bar when executing queries

## Installation

```r
install.packages("devtools")
require("devtools")
devtools::install_github("doorda/doorda-r-sdk", dependencies=TRUE)
```

## Usage

### Create Connection

```r
library('DBI')
library("DoordaHostSDK")
conn <- dbConnect(DoordaHost(),
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

### Get Schema Names

```r
schema_names = showSchemas(conn)
```

### Get Table Names

```r
table_names = showTables(conn)
```


### Get Table Stats (Currently only number of rows supported)

```r
table_stats = getTableStats(conn, "table_name")

```

### Get Column Names of Tables

```r
column_names = dbListFields(conn, "table_name")

```
