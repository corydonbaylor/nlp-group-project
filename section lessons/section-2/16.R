########## Cleaning Tables Extracted from Webpages

library(rvest)
library(stringr)
library(tidyr)

##Access the webpage with the tabular data

url = 'http://espn.go.com/nfl/superbowl/history/winners'
webpage =read_html(url)

sb_table = html_nodes(webpage, 'table')
sb = html_table(sb_table)[[1]] ##acces the first table on the page
head(sb)

## preliminary processing:remove the first two rows, and set the column names

sb = sb[-(1:2), ]#row,column
names(sb) = c("number", "date", "site", "result")
head(sb)

#divide between winner and losers
sb = separate(sb, result, c('winner', 'loser'), sep=', ', remove=TRUE)
head(sb)

## we split off the scores from the winner and loser columns.
##The function str_extract from the stringr package finds a 
##substring matching a pattern

pattern =" \\d+$"
sb$winnerScore = as.numeric(str_extract(sb$winner, pattern))
sb$loserScore =as.numeric(str_extract(sb$loser, pattern))
sb$winner = gsub(pattern, "", sb$winner)
sb$loser =gsub(pattern, "", sb$loser)
head(sb)