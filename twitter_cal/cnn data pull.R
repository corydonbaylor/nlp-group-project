
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




fox_first = get_timelines("realdonaldtrump", n = 100)
load("cnn.Rdata")
# initiate cnn df with a small data pull (you need this to get the starting status_id)
first = get_timelines("realdonaldtrump", n = 100)

temp = first[1,]
news = first

while(nrow(temp) > 0){
    print(nrow(news))
    temp = get_timelines("realdonaldtrump", n = 150, max_id = min(news$status_id)) # pull 900 tweets
    news = rbind(news, temp) # bind those to cnn df
    print(nrow(news))
    
    #Sys.sleep(900) # pause r for 900 seconds
    
    # do it again
}

get_timeline("cnn", n = 150)

breitbart = news
save(news, file = "breitbart.Rdata")
