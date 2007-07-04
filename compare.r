library(ggplot2)
write.table(movies, "movies-2005.tab", col=T, row=F, sep="\t")

old <- movies
new <- read.table("movies-2007.tab", sep="\t", header=TRUE, comment="")


old <- old[, c("title","year", "rating", "votes")]
names(old)[3:4] <- c("rating2005", "votes2005")

both <- merge(new, old, all.x=TRUE)

# This requires futher investigation - why do some movies have fewer votes?
subset(both, votes < votes2005)
