library(gutenbergr)
library(ggplot2)
library(tidytext)
library(dplyr)

meta = gutenberg_download("5200") 

# dividing into chapters

meta$chapter = NA
meta$chapter[1:639] = 1
meta$chapter[640:1295] = 2
meta$chapter[1296:nrow(meta)] = 3

meta <- meta[,2:3]

# term frequency
book_words <- meta%>%
  unnest_tokens(word, text) %>%
  group_by(chapter, word)%>%
  summarise(n = n())%>%
  arrange(desc(n))

meta%>%
  unnest_tokens(word, text) %>%
  group_by(word)%>%
  summarise(book_count = n())%>%
  arrange(desc(book_count))%>%
  right_join(book_words, by = "word")%>%
  select(word, chapter, chapter_count = n, book_count)%>%
  ungroup()

# tf idf
book_words.2 <- book_words %>%
  bind_tf_idf(word, chapter, n)

book_words.2 %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>% 
  group_by(chapter) %>% 
  slice(1:10) %>% 
  ungroup() %>%
  ggplot(aes(word, tf_idf, fill = chapter)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~chapter, ncol = 2, scales = "free") +
  coord_flip()+
  theme_classic()

# example 1
library(getwiki)

euro = get_wiki(c("France", "Germany", "England", "Russia"))%>%
  unnest_tokens(word, content) 

euro = euro %>%
  group_by(titles, word)%>%
  summarise(n = n())%>%
  arrange(desc(n))

final = euro %>%
  bind_tf_idf(word, titles, n)

final %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>% 
  group_by(titles) %>% 
  slice(1:10) %>% 
  ungroup() %>%
  ggplot(aes(word, tf_idf, fill = titles)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~titles, ncol = 2, scales = "free") +
  coord_flip()+
  theme_classic()