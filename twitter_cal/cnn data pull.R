
library(rtweet)
library(dplyr)
library(tidytext)

twitter_token <- create_token(
  app = twitter_app,
  consumer_key = twitter_api_key,
  consumer_secret = twitter_api_secret_key,
  access_token = twitter_access_token,
  access_secret = twitter_access_token_secret
)

cnn_first = get_timelines("cnn", n = 100)
cnn_second = get_timelines("cnn", n = 100, max_id = min(cnn_first$status_id)-1)

cnn_clean = cnn_first%>%
  select(text, created_at)%>%
  mutate(text = gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", cnn_first$text),
         linenumber = row_number())

cnn_final = cnn_clean%>% #this allows us to retain the row number/the tweet
  unnest_tokens(word, text)%>%
  anti_join(stop_words)%>%
  left_join(get_sentiments("afinn"))%>%
  group_by(linenumber) %>% 
  summarise(sentiment = sum(value, na.rm = T)) %>% # sums up the sentment to the tweet level 
  right_join(., cnn_clean, by = "linenumber")%>% # joins back to the original dataset with the sentiment score
  mutate(date = substr(created_at, 1,10))


fox_first = get_timelines("foxnews", n = 100)


cnn = cnn_first

while(nrow(cnn) < 100001){
    print(nrow(cnn))
    temp = get_timelines("cnn", n = 900, max_id = min(cnn$status_id)) # pull 900 tweets
    cnn = rbind(cnn, temp) # bind those to cnn df
    
    Sys.sleep(900) # pause r for 900 seconds
    
    # do it again
}
