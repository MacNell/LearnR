##### topic.R
# example code for how to prepare data for topic modeling

### Run once per computer
install.packages("tm")          # handles text corpus data
install.packages("topicmodels") # topic analysis
install.packages("SnowballC")   # dependency of topicmodels
install.packages("lasso2")      # "

### Load environment (run once per R session)
library(tm)
library(topicmodels)
library(SnowballC)
library(lasso2)
setwd("D:/LearnR/topic")        # point R to data files directory

### Import a .csv file into R (as a data frame)
aug14_1 <- read.csv("csv/aug14_1.csv")
names(aug14_1)                  # inspect variable names
aug14_1 <- aug14_1[,1:12]       # trim off blank variables

### Translate into a corpus object
# tm package uses "corpus" objects to store text.
# "virtual" corpus is stored in memory (okay for small data)
# "permanent" corpus is stored in an external database.
# It's easiest to construct a virtual corpus from a vector:
corpus1 <- VCorpus(VectorSource(aug14_1$TEXT))
# Look at a corpus
inspect(corpus1)                # print out the entire corpus
corpus1[[1]]                    # print the first document from corpus

### Pre-process for analysis
# strip extra whitespace characters
corpus2 <- tm_map(corpus1,stripWhitespace)
corpus2[[1]]  # see part of result
# convert to lowercase
corpus3 <- tm_map(corpus2,content_transformer(tolower))
corpus3[[1]]
# remove stopwords
corpus4 <- tm_map(corpus3, removeWords, stopwords("english"))
corpus4[[1]]
# stemming
corpus5 <- tm_map(corpus4, stemDocument)
corpus5[[1]]

##### Analysis with Topic Models

### How to create a subset
# Build a vector of TRUE/FALSE values
keep <- meta(corpus5,"id") %in% 1:100       # keep first 100 elements
corp <- corpus5[keep]

### create a document-term matrix
# rows/columns are words/docs, cell counts are frequencies
dtm <- DocumentTermMatrix(corp)

### look at words appearing more than 20 times
findFreqTerms(dtm,20)

### look at how many times "prison" and "offend" appears in each
dct <- DocumentTermMatrix(corp,list(dictionary=c("prison","offend")))
inspect(dct)

### look at correlation between "prison" and "offend"
findAssocs(dct,"prison",0)

### build a correlated topic model
dtm <- DocumentTermMatrix(corp) # built doc-term matrix
# let's say we expect 3 topics:
ctm <- CTM(dtm,k=3) # k is the number of topics (uses VEM estimation)

### inspect the model (boring stuff)
logLik(ctm) # log-likelihood
perplexity(ctm) # appropriately named

### inspect the model - cool stuff!
topic <- topics(ctm,1) # topic classification of each document
topic
terms <- terms(ctm,10) # 10 most common terms in each topic
terms






