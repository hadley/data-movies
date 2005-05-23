library(lattice); lattice.options(default.theme = col.whitebg()) 
setwd("~/documents/movies")

m <- read.csv("movies.csv")

head(m)
cnt.col <- which(sapply(m, is.numeric))
cat.col <- which(sapply(m, is.factor))


cnt.sum <- t(sapply(m[, cnt.col], function(x) c(range(x, na.rm=T), sum(!is.na(unique(x))), sum(is.na(x)))))
colnames(cnt.sum) <- c("Minimum","Maximum","Unique values","Missing values")