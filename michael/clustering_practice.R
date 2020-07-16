setwd("C:/Users/603281/Desktop/NLP_R_Practice/nlp_github_repo/nlp-group-project/michael")

library(tm)
library(data.table)
library(dendextend)
library(cluster.datasets)


d=fread("original.csv")

head(d)

data(animal.cluster.trees)

x <- animal.cluster.trees



corpus <- Corpus(VectorSource(d$text))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords('english'))
corpus <- tm_map(corpus, stemDocument)

# Create term document matrix
tdm <- TermDocumentMatrix(corpus,control = list(minWordLength=c(1,Inf)))

t <- removeSparseTerms(tdm, sparse=0.90) #remove superfluous words


m <- as.matrix(t) #create a mtarix of word frequencies
# Plot frequent terms
freq <- rowSums(m)
freq <- subset(freq, freq>=200)

barplot(freq, las=2, col = rainbow(25))

# Hierarchical word/tweet clustering using dendrogram 

distance <- dist(scale(m))

print(distance, digits = 2)

hc <- hclust(distance, method = "ward.D")
#use ward.D for heirarchial clustering

plot(hc, hang=-1)

rect.hclust(hc, k=12)


dend <- hc

dend <- color_branches(dend, k = 3)
dend <- color_labels(dend, k = 3)

#represent the different  clusters with different colours
plot(dend, main = 'Cluster Dendrogram', ylab = 'Height')
