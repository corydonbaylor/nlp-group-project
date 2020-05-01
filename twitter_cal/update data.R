
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

# load in any dataset that you want to update
setwd("/Users/corydonbaylor/Documents/github/nlp-group-project/twitter_cal/")
load("data/WSJ.Rdata")
news = WSJ

# how far back do we go?
print(range(news$created_at))

# double check the screenname 
screen_name = news$screen_name[1]

# find id of the latest tweet in that dataset
var = max(news$status_id)

# using the "since_id" parameter pull back the new tweets
new = get_timeline(screen_name, n= 3000, since_id = var)

# bind this to the old tweets
wsj = rbind(new, news)

# update the file
save(wsj, file = paste0("data/", screen_name, ".Rdata"))
