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

# cnbc_first = get_timelines("cnbc", n = 100)
# cnbc_second = get_timelines("cnbc", n = 100, max_id = min(cnn_first$status_id)-1)
# 
# cnbc_clean = cnbc_first%>%
#   select(text, created_at)%>%
#   mutate(text = gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", cnbc_first$text),
#          linenumber = row_number())
# 
# cnbc_final = cnbc_clean%>% #this allows us to retain the row number/the tweet
#   unnest_tokens(word, text)%>%
#   anti_join(stop_words)%>%
#   left_join(get_sentiments("afinn"))%>%
#   group_by(linenumber) %>% 
#   summarise(sentiment = sum(value, na.rm = T)) %>% # sums up the sentment to the tweet level 
#   right_join(., cnbc_clean, by = "linenumber")%>% # joins back to the original dataset with the sentiment score
#   mutate(date = substr(created_at, 1,10))


# initiate cnn df with a small data pull (you need this to get the starting status_id)
cnbc_first = get_timelines("cnbc", n = 100)
cnbc = cnbc_first

while(nrow(cnbc) < 100001){
  print(nrow(cnbc))
  temp = get_timelines("cnbc", n = 1500, max_id = min(cnbc$status_id)) # pull 900 tweets
  cnbc = rbind(cnbc, temp) # bind those to cnbc df
  print(nrow(cnbc))
  
  Sys.sleep(900) # pause r for 900 seconds
  
  # do it again
}

save(cnbc, file = "cnbc.Rdata")
