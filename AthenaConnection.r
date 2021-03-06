library(rJava)
library(RJDBC)
library(plyr)
library(dplyr)
library(png)
library(RgoogleMaps)
library(ggmap)
URL <- 'https://s3.amazonaws.com/athena-downloads/drivers/JDBC/AthenaJDBC_1.1.0/AthenaJDBC41-1.1.0.jar'
fil <- basename(URL)
if (!file.exists(fil)) download.file(URL, fil)
drv <- JDBC(driverClass="com.amazonaws.athena.jdbc.AthenaDriver", fil, identifier.quote="'")
con <- jdbcConnection <- dbConnect(drv, 'jdbc:awsathena://athena.us-east-1.amazonaws.com:443/',
    s3_staging_dir="s3://endpoint-test-bucket-99",
    user=Sys.getenv("ATHENA_USER"),
    password=Sys.getenv("ATHENA_PASSWORD"))
dbListTables(con)
dfelb=dbGetQuery(con, "SELECT * FROM bank_csv_data where age > 40 limit 50")
head(dfelb,20)
