
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
load("data/AP.Rdata")
news = AP

# find id of the latest tweet in that dataset
var = max(news$status_id)

# using the "since_id" parameter pull back the new tweets
new = get_timeline("AP", n= 3000, since_id = var)

# bind this to the old tweets
AP = rbind(new, news)

# update the file
save(AP, file = "data/AP.Rdata")
