library(lattice); trellis.par.set(col.whitebg())
setwd("~/documents/movies")

m <- read.csv("movies.csv")

xyplot(length ~ year, m)
xyplot(budget ~ year, m)
xyplot(log(budget) ~ year, m)