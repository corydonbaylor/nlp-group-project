library(gutenbergr)
library(wordcloud)
library(ggplot2)
library(tidytext)
library(dplyr)
library(kableExtra)

meta = gutenberg_download("5200") 

tokens = meta %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

# top words
word_count = tokens%>%
  group_by(word)%>%
  summarise(count = n())%>%
  arrange(desc(count))%>%
  slice(1:10)

ggplot(data = word_count)+
  geom_bar(aes(x = word, y = count), stat = "identity",  fill = "#6699cc")+
  theme_classic()

# word cloud
wordcloud(tokens$word, max.words = 75, colors=brewer.pal(6, "Dark2"))


# example 1:
library(gutenbergr)
library(wordcloud)
library(ggplot2)
library(tidytext)
library(dplyr)
library(kableExtra)

hamlet = gutenberg_download("1787") 

tokens = hamlet %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) 

word_count = tokens%>%
  group_by(word)%>%
  summarise(count = n())%>%
  arrange(desc(count))%>%
  slice(1:10)

ggplot(data = word_count)+
  geom_bar(aes(x = word, y = count), stat = "identity",  fill = "#6699cc")+
  theme_classic()

# example 2
wordcloud(tokens$word, max.words = 75, colors=brewer.pal(6, "Dark2"))
