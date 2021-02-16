library(getwiki)
library(tidytext)
library(dplyr)
library(topicmodels)
library(ggplot2)
library(kableExtra)

data = get_wiki(c("virginia", "utah", "regression", "statistics", "latent dirichlet allocation", "claude monet", "Pierre-Auguste Renoir"))

data_tokenized = data %>% 
  unnest_tokens(word, content)%>%
  anti_join(stop_words)%>%
  count(titles,word,sort=TRUE) %>%
  ungroup()

data_dtm = data_tokenized %>%
  cast_dtm(titles, word ,n)

data_dtm

data_lda = LDA(data_dtm, k = 3, control = list(seed = 1234))


# word topic distro

word_topics <- tidy(data_lda, matrix = "beta")

top_terms <- word_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms%>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot()+
  geom_col(aes(term, beta, fill=topic), show.legend = FALSE)+
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~topic, ncol = 2, scales = "free") +
  coord_flip()+
  scale_x_reordered() +
  theme_classic()

# document topic distro

doc_topics <- tidy(data_lda, matrix = "gamma")

doc_topics %>%
  arrange(desc(gamma))%>%
  slice(1:7)%>%
  arrange(topic)