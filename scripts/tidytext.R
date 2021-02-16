library(dplyr)
library(tidytext)
library(gutenbergr)
library(tidyr)

# downloading metamorphasis
meta = gutenberg_download("5200")

# tokenizing
unigrams = meta %>% unnest_tokens(word, text, token = "ngrams", n = 1)
bigrams = meta %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)

# no stop words
unigrams_cleaned = unigrams %>%
  filter(!word %in% stop_words$word)

# stemming
library(SnowballC)

wordStem(c("love", "loving", "lovingly", "loved", "lover", "lovely", "love"))
wordStem(c("fish", "fisher", "fishing", "fished", "fishery"))

unigrams_cleaned = unigrams %>%
  filter(!word %in% stop_words$word)%>%
  mutate(word = wordStem(word))

# lemmatization
library(textstem)
lemmatize_words(c("eat", "ate", "eaten", "eating", "eaten"))

unigrams_cleaned = unigrams %>%
  filter(!word %in% stop_words$word)%>%
  mutate(word = lemmatize_words(word))

library(tm)

example = c('Jog', 'jogging', 'jogged', 'ran', 'run', 'running', 'am', 'is', 'are', 'was',
            'were', 'be', 'being', 'been') 
df = as.data.frame(example) 
corpus = Corpus(VectorSource(df$example))  
corpus <- tm_map(corpus, lemmatize_strings)
inspect(corpus)

# cleaning n-grams
df = data.frame(
  example_num = c(1, 2),
  text = c("Here are two examples. I wrote them down for you. In each example you will find a lot of stop words", 
           "Another thing you might find is inflected words or words that could be stemmed")
)

clean = df%>%
  unnest_tokens(word, text, token = "ngrams", n = 1)%>%
  filter(!word %in% stop_words$word)%>% # removing stop words
  mutate(word = lemmatize_words(word))

back_again = clean%>%
  group_by(example_num)%>%
  summarise(text = paste(word, collapse = " "))

df2 = back_again %>% unnest_tokens(word, text, token = "ngrams", n = 2)

# Heart of Darkness
darkness = gutenberg_download("219")

darkness %>%
  unnest_tokens(word, text, token = "ngrams", n = 1)%>%
  filter(!word %in% stop_words$word)%>% # removing stop words
  mutate(word = lemmatize_words(word))%>% 
  group_by(gutenberg_id)%>%
  summarise(text = paste(word, collapse = " "))%>%
  unnest_tokens(word, text, token = "ngrams", n = 3)