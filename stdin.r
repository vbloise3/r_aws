con <- file("stdin", open = "r")
dataset <- readLines(con, n=2)
a <- as.integer(unlist(strsplit(dataset[1],",")))
a
