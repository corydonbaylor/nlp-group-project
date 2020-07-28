library(dplyr)
library(lubridate)
library(ggplot2)
library(tidytext)

setwd("/Users/corydonbaylor/Documents/github/nlp-group-project/twitter_cal/data")
# create a list of files to pull in
files = list.files()
# initiate a vector of data frame names
names = c()

# load all the files in and create a vector of their names
for(i in 1:length(files)){
  load(files[i])
  temp = load(files[i])
  names = append(names, temp)
}

# lets remove trump as a news agency
names = names[names != "trump"]

# create a monthly df for each df loaded in

all = data.frame()

for(i in 1:length(names)){
  df = get(names[i])
  
  text = df%>%select(text, created_at, followers_count, screen_name)%>%
    mutate(
      text = gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", df$text),
      linenumber = row_number())
  
  sent = text%>% #this allows us to retain the row number/the tweet
    unnest_tokens(word, text)%>% # this unnests the tweets into words
    anti_join(stop_words)%>% #removes common words (stop words)
    left_join(get_sentiments("afinn")) %>% # gets sentiment score based on afinn dictionary
    mutate(value = ifelse(is.na(value), 0 , value))%>%
    group_by(linenumber) %>% 
    summarise(sentiment = sum(value, na.rm = T)) %>% # sums up the sentment to the tweet level 
    right_join(., text, by = "linenumber")%>% # joins back to the original dataset with the sentiment score
    mutate(date = substr(created_at, 1,10)) # cleans up created_at var
  
  month = sent%>%group_by(date)%>%
    summarise(sentiment = mean(sentiment, na.rm =T))%>%
    # to create the plot we need to be able to organzie with days as the columns and week number as the rows
    mutate(followers_count = text$followers_count[1],
           screen_name = text$screen_name[1]
    )
  
  all = rbind(all, month)
}

final = all%>%
  mutate(date = ymd(date))%>%
  filter(date >= "2020-04-01", 
         date <= "2020-04-30")%>%
  group_by(date)%>%
  summarise(weighted = weighted.mean(sentiment, followers_count))%>%
  mutate(weekday =  
           
           factor(wday(date), labels = c("Sun", "Mon", "Tues", "Wed", "Thu", "Fri", "Sat"))
  )%>% # this gives us an order factor variable for days
  mutate(day = day(date))%>% # we will use this to write in the date on the squares
  mutate(weeknum = isoweek(date))%>% # what number week it is--allows us to group days into weeks
  mutate(weeknum = ifelse(weekday == "Sun", weeknum +1, weeknum))%>% # iso says that monday is the first day of the week but we want sunday to be the first day
  mutate(weeknum = factor(weeknum, rev(unique(weeknum)), ordered = T))


ggplot(final, aes(x= weekday, y =weeknum, fill = weighted))+ 
  geom_tile(color = "#323232")+ # makes the lines a bit more muted
  geom_text(label = final$day, size =4, color = "black")+ # days
  # positive days should be green and negative ones should be red
  scale_fill_gradient2(midpoint = 0, low = "#d2222d", mid = "white", high = "#238823")+ 
  # we are going to remove the majority of the plot 
  theme(axis.title = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y = element_blank(),
        legend.text = element_blank(),
        legend.position = "none",
        plot.title = element_text(face = "bold"),
        plot.caption = element_text(color = "#323232")
  )+
  labs(title = "This April in Tweets", 
       subtitle = "A Sentiment Analysis of News Tweets",
       caption = "Darker Green = More Positive\nDarker Red = More Negative")


ggsave("all_news.png")
# proof of concept --------------------------------------------------------

# lets create two seperate dfs that will match what we are doing
foo = data.frame( 
  org = "fox",
  val = runif(30, min = 1, max =100),
  weight = 20,
  date = seq.Date(as.Date("2020-04-01"), as.Date("2020-04-30"), by = "days")
       )

foo2 = data.frame(
  org = "cnn",
  val = runif(30, min = 1, max = 30),
  weight = 100,
  date = seq.Date(as.Date("2020-04-01"), as.Date("2020-04-30"), by = "days")
)

# bind them togehter
test = rbind(foo, foo2)

# using group by we can find the weighted mean of an abritrary number of organizations 
test%>%
  group_by(date)%>%
  summarise(weighted = weighted.mean(val, weight))

# double check and make sure that the first number matches (and it does!)
(foo$val[1]*foo$weight[1] + foo2$val[1] * foo2$weight[1])/ 120