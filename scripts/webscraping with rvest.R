

# ADD YOUR TWITTER KEYS HERE
twitter_api_key = "sample_api_key"
twitter_api_secret_key = "sample_secret_key"
twitter_access_token = "sample_token"
twitter_access_token_secret = "sample_secret_token"

# YOU CAN PLACE THESE IN A SEPERATE FOLD OR JUST ADD THEM ABOVE
# IN OUR VIDEOS WE PLACED THEM IN A FILE CALLED KEYS.R

library(rtweet)
source("../keys.R")

twitter_token <- create_token(
  app = twitter_app,
  consumer_key = twitter_api_key,
  consumer_secret = twitter_api_secret_key,
  access_token = twitter_access_token,
  access_secret = twitter_access_token_secret
)

library(dplyr)

search_tweets(q = "datascience", n = 1)%>%
  select(screen_name, text)

search_tweets(q = "datascience filter:verified", n = 1)%>%
  select(screen_name, text)

search_tweets(q = "datascience -filter:verified", n = 1)%>%
  select(screen_name, text)

get_timeline("therock", n = 3)%>%
  select(screen_name, text)

# EXAMPLE 1

rock = get_timeline("therock", n =100)

library(scales)
library(ggplot2)

ggplot(data = rock)+
  geom_point(aes(x = favorite_count, # how many favorited 
                 y = retweet_count,  # how many retweeted
                 color = is_quote    # is the rock quoting?
  )
  )+ 
  theme_minimal()+
  theme(legend.position = "bottom")+
  # adding the right title and legend label
  labs(title = "What's the Rock Cooking?", 
       color = "Is the Rock Quoting?")+
  # using comma from the scales package for the axis labels
  scale_y_continuous("Retweets", labels = comma)+ 
  scale_x_continuous("Favorites", labels = comma)

# EXAMPLE 2

data = search_tweets("#rstats", # include the topic you are searching for 
                     type  = "popular", # lets return the 'popular' tweets
                     include_rts = F) # no retweets pls.
data$text

text = gsub("(?:\\s*#\\w+)*", "", data$text) # remove all the hashtags at the end
text = gsub("\n|—", "", text) # remove all the line breaks
text = gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", text) # remove urls

text