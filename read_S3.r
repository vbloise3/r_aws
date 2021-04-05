data <- 
    aws.s3::s3read_using(read.csv, object = "s3://endpoint-test-bucket-99/bank-full.csv")
    data