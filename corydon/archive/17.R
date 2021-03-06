####### More on rvest

#### Read in and glean info from text data

library(rvest)
library(stringr)

# The original washington post article is now behind a paywall so I am subbing it out for a transcript
# of the debate itself.

# I am also going to change the end goal of this. Lets try and get this into a format that can
# be used by tidytext. IE a dataframe.

# new transcript source
url="https://www.debates.org/voter-education/debate-transcripts/september-26-2016-debate-transcript/"

# once again we read the url
t_link=read_html(url)

# use the xpath to the container for the entire debate!
transcript = t_link %>% html_nodes(xpath= '//*[@id="content-sm"]') %>% html_text()

##unstructured text
transcript

# We have 3 different patterns/speakers to search for 
# which will include in our expression using the or operator '|'
# str_locate_all of stringr will give the index (start and end position) of all the matches
markers <- str_locate_all(transcript, pattern = "CLINTON|TRUMP|HOLT")[[1]]%>%as.data.frame()

head(markers)

# I am sure there is a more efficient way of doing this but lets start with this:

# initiate data frame outside of loop
answers = data.frame()

substr(transcript, markers$end[1]+1, markers$start[2]-1)

# for each element in the loop, get the name of the speaker and the content 
for(i in 1:nrow(markers)){
  temp = data.frame(
            name = substr(transcript, markers$start[i], markers$end[i]),
            comment = substr(transcript, markers$end[i]+1, markers$start[i+1]-1)
            )
  answers = rbind(answers, temp) # my guess is that this is the inefficient part
  }

rm(temp)

# lets get rid of the : after the speakers name as it is the first character at the 
# beginning of each response

answers$comment = gsub(": ", "", answers$comment)

# Ok now we have the answers to the questions and the name of the respondent 
# I think this is a more familiar way of working with data for R users... perhaps there is some
# use to having it as a blob, but i prefer this
head(answers)


######## IMDB WEBSITE

url="http://www.imdb.com/search/title?year=2017&title_type=feature&"

#Reading the HTML code from the website
webpage = read_html(url)

#CSS selectors to scrap the rankings section
rank_data_html = html_nodes(webpage,'.text-primary')%>%
  html_text()

class(rank_data_html)

# create a movies dataframe
movies = data.frame(
  rank = html_nodes(webpage, '.text-primary')%>%html_text()%>%extract_numeric(),
  title = html_nodes(webpage,'.lister-item-header a')%>%html_text(),
  run_time = html_nodes(webpage,' .runtime')%>%html_text()%>%extract_numeric(),
  genre = gsub("\n", "", html_nodes(webpage,'.genre')%>%html_text()),
  primary_genre = gsub(",.*", "", gsub("\n", "", html_nodes(webpage,'.genre')%>%html_text()))
)


barplot(table(movies_df$Genre))

