
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
setwd("C:/Users/cwb2w/OneDrive/Documents/github/nlp-group-project/twitter_cal")
load("data/cnn.Rdata")
data = cnn 

# find id of the latest tweet in that dataset
var = max(data$status_id)

# using the "since_id" parameter pull back the new tweets
new = get_timeline("cnn", n= 3000, since_id = var)

# bind this to the old tweets
cnn_final = rbind(cnn, cnn_new)

# update the file
save(cnn_final , file = "data/cnn.Rdata")
