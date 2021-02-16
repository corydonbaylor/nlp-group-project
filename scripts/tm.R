library(tm)
library(getwiki)

europe = get_wiki(c("spain", "portugal", "france", "england", "germany", "poland", "russia", "italy"))

# creating a corpus
names(europe) = c("doc_id", "text")

europe = VCorpus(DataframeSource(europe))

europe

text = c("hey look a string", "i hope i become a document in a corpus one day", "its any string in a vector's dream")

VCorpus(VectorSource(text))

# inspecting corpus
inspect(europe[1:2])
europe[[1]]

# data cleaning
europe_clean = tm_map(europe, removeWords, stopwords("english"))

europe_clean = tm_map(europe_clean, stripWhitespace)
europe_clean = tm_map(europe_clean, stemDocument)

substr(europe_clean[[1]]$content, 1, 500)

glorious_spain = tm_map(europe, content_transformer(tolower))
glorious_spain = tm_map(glorious_spain, content_transformer(gsub), pattern = "spain", replacement = "THE GLORIOUS KINGDOM OF SPAIN")

# using a DTM

dtm = DocumentTermMatrix(europe_clean)

inspect(dtm)

findFreqTerms(dtm, 300)

findAssocs(dtm, "king", .8)

substr(glorious_spain[[1]]$content, 1, 500)