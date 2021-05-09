con <- file("stdin", open = "r")
dataset <- readLines(con, n=6)

vector1 <- as.integer(unlist(strsplit(dataset[[1]], " ")))
vector2 <- as.integer(unlist(strsplit(dataset[[2]], " ")))
vector3 <- as.integer(unlist(strsplit(dataset[[3]], " ")))
vector4 <- as.integer(unlist(strsplit(dataset[[4]], " ")))
vector5 <- as.integer(unlist(strsplit(dataset[[5]], " ")))
vector6 <- as.integer(unlist(strsplit(dataset[[6]], " ")))

rnames <- c("1", "2", "3")
cnames <- c("V1", "V2", "V3")
matrix1 <- matrix(c(as.numeric(vector1), as.numeric(vector2), as.numeric(vector3)), nrow=3, ncol=3, byrow=TRUE, dimnames=list(rnames, cnames))
matrix2 <- matrix(c(as.numeric(vector4), as.numeric(vector5), as.numeric(vector6)), nrow=3, ncol=3, byrow=TRUE, dimnames=list(rnames, cnames))
matrix1 * matrix2
matrix1 / matrix2