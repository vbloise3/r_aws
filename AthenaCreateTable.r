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

dbSendQuery(con, 
"
CREATE EXTERNAL TABLE IF NOT EXISTS default.gdeltmaster2 (
GLOBALEVENTID BIGINT,
SQLDATE INT,
MonthYear INT,
Year INT,
FractionDate DOUBLE,
Actor1Code STRING,
Actor1Name STRING,
Actor1CountryCode STRING,
Actor1KnownGroupCode STRING,
Actor1EthnicCode STRING,
Actor1Religion1Code STRING,
Actor1Religion2Code STRING,
Actor1Type1Code STRING,
Actor1Type2Code STRING,
Actor1Type3Code STRING,
Actor2Code STRING,
Actor2Name STRING,
Actor2CountryCode STRING,
Actor2KnownGroupCode STRING,
Actor2EthnicCode STRING,
Actor2Religion1Code STRING,
Actor2Religion2Code STRING,
Actor2Type1Code STRING,
Actor2Type2Code STRING,
Actor2Type3Code STRING,
IsRootEvent INT,
EventCode STRING,
EventBaseCode STRING,
EventRootCode STRING,
QuadClass INT,
GoldsteinScale DOUBLE,
NumMentions INT,
NumSources INT,
NumArticles INT,
AvgTone DOUBLE,
Actor1Geo_Type INT,
Actor1Geo_FullName STRING,
Actor1Geo_CountryCode STRING,
Actor1Geo_ADM1Code STRING,
Actor1Geo_Lat FLOAT,
Actor1Geo_Long FLOAT,
Actor1Geo_FeatureID INT,
Actor2Geo_Type INT,
Actor2Geo_FullName STRING,
Actor2Geo_CountryCode STRING,
Actor2Geo_ADM1Code STRING,
Actor2Geo_Lat FLOAT,
Actor2Geo_Long FLOAT,
Actor2Geo_FeatureID INT,
ActionGeo_Type INT,
ActionGeo_FullName STRING,
ActionGeo_CountryCode STRING,
ActionGeo_ADM1Code STRING,
ActionGeo_Lat FLOAT,
ActionGeo_Long FLOAT,
ActionGeo_FeatureID INT,
DATEADDED INT,
SOURCEURL STRING )
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION 's3://gdelt-open-data/'
;
"
)
dbListTables(con)

#--get count of all CAMEO events that took place in US in year 2015 
#--save results in R dataframe
dfg<-dbGetQuery(con,"SELECT eventcode,count(*) as count
FROM default.gdeltmaster2
where year = 2015 and ActionGeo_CountryCode IN ('US')
group by eventcode
order by eventcode desc"
)
str(dfg)
head(dfg,2)
#--get list of top 5 most frequently occurring events in US in 2015
dfs=head(arrange(dfg,desc(count)),5)
dfs

#--get a list of latitude and longitude associated with event “042” 
#--save results in R dataframe
dfgeo<-dbGetQuery(con,"SELECT actiongeo_lat,actiongeo_long
FROM default.gdeltmaster2
where year = 2015 and ActionGeo_CountryCode IN ('US')
and eventcode = '042' limit 100
"
)
#--duration of above query will depend on factors like size of chosen EC2 instance
#--now rename columns in dataframe for brevity
names(dfgeo)[names(dfgeo)=="actiongeo_lat"]="lat"
names(dfgeo)[names(dfgeo)=="actiongeo_long"]="long"
names(dfgeo)
#let us inspect this R dataframe
str(dfgeo)
head(dfgeo,5)

#--generate map for the US using the ggmap package
#map=qmap('USA',zoom=3)
#map
