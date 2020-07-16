setwd("C:/Users/603281/Desktop/NLP_R_Practice/nlp_github_repo/nlp-group-project/michael")

library(tm)
options(header=FALSE, stringsAsFactors = FALSE, fileEncoding="latin1")

data <- read.csv("spam.csv")

data$combined_text <- with(data, paste0(text, C, D, E))
data[,2:5] <- NULL

dim(data)

# data <- data %>% na.rm=TRUE

corpus <- Corpus(VectorSource(data$combined_text))

cleanset <- tm_map(corpus, removeWords, stopwords("english"))
cleanset <- tm_map(cleanset, stripWhitespace)

# Build the document term matrix

dtm <- DocumentTermMatrix(cleanset)
dim(dtm)

# TF-IDF

dtm_tfxidf <- weightTfIdf(dtm)

# clustering

m <- as.matrix(dtm_tfxidf)
rownames(m) <- 1:nrow(m)

# normalize the matrix with the Euclidean distance

norm_eucl <- function(m)
  m/apply(m, 1, function(x) sum(x^2)^.5)

m_norm <- norm_eucl(m)

results <- kmeans(na.omit(m_norm, 3))

View(m_norm)

clusters <- 1:12
for (i in clusters) {
  cat("Cluster", i, ":", findFreqTerms(dtm_tfxidf[results$cluster==i], 2), "\n\n")
}






