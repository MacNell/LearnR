##### sna-build.R
# introduction to building data for a social network analysis in R

### adapted from / dataset from / thanks to:
# McFarland, Daniel, Solomon Messing,
# Mike Nowak, and Sean Westwood. 2010. 
# "Social Network Analysis          
# Labs in R." Stanford University.                                       
# more labs: http://sna.stanford.edu/rlabs.php

### set up environment
# install packages(if needed)
install.packages("network")  # basic network objects
install.packages("igraph")   # more plotting options
install.packages("sna")      # analysis functions

# load packages
# you'll get some messages about "objects are masked"
library(network)
library(igraph)
library(sna)

# set the working directory so we know where stuff is
setwd("D:/LearnR/SNA")

### download stanford example data from internet
# web locations work just like file locations
advice <- read.table('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-edgelist-Advice.txt')
friendship <- read.table('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-edgelist-Friendship.txt')
reports <- read.table('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-edgelist-ReportsTo.txt')
attributes <- read.csv('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-Attributes.csv', header=T)

### inspect the data
head(advice)
dim(friendship) 
class(reports)
names(attributes)

### the "link" data are unnamed, let's fix that
# each row is a possible link, and the variables indicate
# who the link is from (ego) 
# who it is to (alter)
# and if it exists (advice/friendship/reports)
names(advice)     <- c('ego', 'alter', 'advice')
names(friendship) <- c('ego', 'alter', 'friendship')
names(reports)    <- c('ego', 'alter', 'reports')

# let's merge these three together by ego and alter
advicefriendship <- merge(advice,friendship,by=c("ego","alter"))
ties.all <- merge(advicefriendship,reports,by=c("ego","alter"))

# trim to non-zero ties
ties <- ties.all[ties.all$advice==1 | 
                 ties.all$friendship==1 | 
                 ties.all$reports==1,]
 
# save the attribute and tie data
save(ties,attributes,file="sna.RData")