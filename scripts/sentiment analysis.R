library(wordcloud)
library(RColorBrewer)
library(rtweet)


# LINK TO YOUR TWITTER KEYS!!!
source("../../keys.R")

twitter_token <- create_token(
  app = twitter_app,
  consumer_key = twitter_api_key,
  consumer_secret = twitter_api_secret_key,
  access_token = twitter_access_token,
  access_secret = twitter_access_token_secret
)

tomcruise = get_timeline("@TomCruise", n =500)

text = tomcruise %>% select(text)%>%
  mutate(text = gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", tomcruise$text),
         linenumber = row_number())

sentiment = text%>% #this allows us to retain the row number/the tweet
  unnest_tokens(word, text)%>% # this unnests the tweets into words
  anti_join(stop_words)%>% #removes common words (stop words)
  left_join(get_sentiments("bing"))

# word cloud
positive_sentiment = sentiment%>% filter(!is.na(sentiment),
                                         sentiment == 'positive') # gets sentiment score based on bing dictionary

wordcloud(positive_sentiment$word, random.order = FALSE, colors=brewer.pal(6, "Dark2"))

negative_sentiment = sentiment%>% filter(!is.na(sentiment),
                                         sentiment == 'negative') # gets sentiment score based on bing dictionary

wordcloud(negative_sentiment$word, random.order = FALSE, colors=brewer.pal(6, "Dark2"))

#### sentiment radar chart

library(fmsb)
library(tidyr)

nrc_sentiment = text%>% #this allows us to retain the row number/the tweet
  unnest_tokens(word, text)%>% # this unnests the tweets into words
  anti_join(stop_words)%>% #removes common words (stop words)
  left_join(get_sentiments("nrc"))%>%
  filter(!is.na(sentiment))

nrc_sentiment = nrc_sentiment%>%
  group_by(sentiment)%>%
  summarise(count = n())%>%
  spread(sentiment, count)

# create rows with the min and max to be plotted
nrc_sentiment <- rbind(rep(400,10) , rep(0,10), nrc_sentiment)

radarchart(nrc_sentiment, axistype=1 , 
           pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 , 
           cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
           vlcex=0.8 )

#### sentiment over time

library(gutenbergr)
library(tidyr)
library(ggplot2)

meta = gutenberg_download("5200")

book_words <- meta%>%
  mutate(linenumber = row_number())%>%
  unnest_tokens(word, text)

sentbars = book_words %>%
  inner_join(get_sentiments("bing"))%>%
  # %/% performs integer divison, rounding down to the nearest whole number
  mutate(index = linenumber %/% 25)%>% 
  group_by(index, sentiment)%>%
  summarise(count = n())%>%
  spread(sentiment, count, fill = 0) %>%
  mutate(sentiment = positive - negative,
         sentiment_group = ifelse(sentiment > 0, "pos", "neg"))%>%
  ungroup()

# the plot itself
ggplot(data = sentbars) +
  geom_bar(aes(x = index, y = sentiment, fill = sentiment_group), stat = "identity")+
  theme_classic()+
  theme(
    legend.position = "none",
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank(),
    axis.text.x = element_blank()
  )+
  scale_fill_manual(values = c("darkred", "darkgreen"))+
  labs(title = "The Metamorphosis of Sentiment",
       x = "Change over Time (Each Bar is 25 Lines of Text)",
       y = "Sentiment Score")

###### PROBLEM 1
library(gutenbergr)
library(tidyr)
library(ggplot2)

wuther = gutenberg_download("768")

book_words <- wuther%>%
  mutate(linenumber = row_number())%>%
  unnest_tokens(word, text)

sentbars = book_words %>%
  inner_join(get_sentiments("bing"))%>%
  # %/% performs integer divison, rounding down to the nearest whole number
  mutate(index = linenumber %/% 50)%>% 
  group_by(index, sentiment)%>%
  summarise(count = n())%>%
  spread(sentiment, count, fill = 0) %>%
  mutate(sentiment = positive - negative,
         sentiment_group = ifelse(sentiment > 0, "pos", "neg"))%>%
  ungroup()

ggplot(data = sentbars) +
  geom_bar(aes(x = index, y = sentiment, fill = sentiment_group), stat = "identity")+
  theme_classic()+
  theme(
    legend.position = "none",
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank(),
    axis.text.x = element_blank()
  )+
  scale_fill_manual(values = c("darkred", "darkgreen"))+
  labs(title = "How Wuthered Are These Heights",
       x = "Change over Time",
       y = "Sentiment Score")