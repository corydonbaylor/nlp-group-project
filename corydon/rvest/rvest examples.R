# USING WEBSCRAPPING WITH REVEST

library(rvest)
library(stringr)
library(tidyr)


# Pulling in Existing HTML Tables -----------------------------------------------

# Wikipedia has some plain HTML tables that we can scrap for info

## Example 1: Summer olympics medal tally

# Things to know:
# read_html pulls in the entire html for a webpage
# html_table parses an html table into a df (dont forget to set fill = TRUE)

url <- "https://en.wikipedia.org/wiki/2016_Summer_Olympics_medal_table"

medal_tally <- url %>% 
  read_html() %>% # read_html pulls in the entire html for a webpage
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]') %>% html_table(fill=TRUE)

## copy xpath
## //*[@id="mw-content-text"]/div/table[2]
# //*[@id="mw-content-text"]/div/table[2]

# the result will come back as a list. Access the first item to get a df
medal_tally <- medal_tally[[1]]
head(medal_tally)


# Example 2: WHS Sites in the UK

url2="https://en.wikipedia.org/wiki/List_of_World_Heritage_Sites_in_the_United_Kingdom_and_the_British_Overseas_Territories"

whsuk <- url2 %>% read_html() %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[3]') %>% html_table(fill=TRUE)

whsuk <- whsuk[[1]]
head(whsuk)


# Creating a Dataframe from Page Elements ---------------------------------

# Next we are going to use elements from a webpage (a listicle) to build a 
# structured dataframe. Lets start using data from the imdb site

######## IMDB WEBSITE

url = "http://www.imdb.com/search/title?year=2017&title_type=feature&"

#Reading the HTML code from the website
webpage = read_html(url)

#CSS selectors to scrap the rankings section
rank_data_html = html_nodes(webpage,'.text-primary')%>%
  html_text()

# pulling back the text from these css classes, we can see it just the numbers
rank_data_html

# we will repeat this process to build a dataframe. Remember to use inspect to find the 
# the css class names that you need

# create a movies dataframe
movies = data.frame(
  rank = html_nodes(webpage, '.text-primary')%>%html_text()%>%extract_numeric(),
  title = html_nodes(webpage,'.lister-item-header a')%>%html_text(),
  run_time = html_nodes(webpage,' .runtime')%>%html_text()%>%extract_numeric(),
  genre = gsub("\n", "", html_nodes(webpage,'.genre')%>%html_text()),
  primary_genre = gsub(",.*", "", gsub("\n", "", html_nodes(webpage,'.genre')%>%html_text()))
)

# tidyverse detour:

# tidyverse way (ie how everyone uses R)
html_nodes(webpage, '.genre')%>%
  html_text()%>%
  str_replace("\n", "")

# more traditional functional programming way
str_replace(html_text(html_nodes(webpage, '.genre')), "\n", "")

barplot(table(movies$primary_genre)) # neat!


# Building a dataframe from two websites! ---------------------------------

# https://towardsdatascience.com/learn-to-create-your-own-datasets-web-scraping-in-r-f934a31748a5
# The goal here is to rework this tutorial for the updated webpages. Basically the CSS classes
# have changed names. So we have to refind them ---yeet!

# Identify the url from where you want to extract data
base_url <- "https://www.billboard.com/charts/artist-100"
webpage <- read_html(base_url)

# Get the artist name
artist <- html_nodes(webpage, ".chart-list-item__title")
artist <- as.character(html_text(artist))

# Get the artist rank
rank <- html_nodes(webpage, ".chart-list-item__rank")
rank <- as.numeric(html_text(rank))

# Save it to a tibble
top_artists <- tibble('Artist' = gsub("\n", "", artist),   #remove the \n character in the artist's name
                      'Rank' = rank) %>%
  filter(rank <= 10)%>%
  mutate(Artist = gsub(" ", "-", top_artists$Artist))

#Format the link to navigate to the artists genius webpage
genius_urls <- paste0("https://genius.com/artists/",top_artists$Artist)

# you may note that there are spaces in the urls
genius_urls[1] # but when you put them in your web browser it finds them anywho

#Initialize a tibble to store the results
artist_lyrics <- tibble()

# Outer loop to get the song links for each artist 
for (i in 1:10) {
  genius_page <- read_html("https://genius.com/artists/Billie-eilish")
  song_links <- html_nodes(genius_page, ".mini_card_grid-song a") %>%
    html_attr("href") 
  #Inner loop to get the Song Name and Lyrics from the Song Link    
  for (j in 1:3) {
    
    # Get lyrics
    lyrics_scraped <- read_html(song_links[j]) %>%
      html_nodes("div.lyrics p") %>%
      html_text()
    
    # Get song name
    song_name <- read_html(song_links[j]) %>%
      html_nodes("h1.header_with_cover_art-primary_info-title") %>%
      html_text()
    
    # Save the details to a tibble
    artist_lyrics <- rbind(artist_lyrics, tibble(Rank = top_artists$Rank[i],
                                                 Artist = top_artists$Artist[i],
                                                 Song = song_name,
                                                 Lyrics = lyrics_scraped ))
    
    print(i) # so you know where we are
    # Insert a time lag - to prevent me from getting booted from the site :)
    Sys.sleep(10)
    
  }
} 

#Inspect the results
artist_lyrics


# Example 3: Building a dataframe from unstructured data! -----------------


# The original washington post article is now behind a paywall so I am subbing it out for a transcript
# of the debate itself.

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



# how we can locate a name
substr(transcript, markers$start[1], markers$end[1])
substr(transcript, 251, 254)

# how we can locate what they said
substr(transcript, markers$end[1]+1, markers$start[2]-1)
substr(transcript, 255, 1525)


# initiate data frame outside of loop
answers = data.frame()

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




