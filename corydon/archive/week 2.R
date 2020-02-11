# adding week 2
library(googlesheets)
library(rvest)
library(stringr)
library(stringi)
library(tidyverse)

# Quick and Easy Medium Post on rvest ---------------------------

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


#### Lesson 14 and 15
##################################################################
### Read in data from Wikipedia HTML tables

#Summer olympics medal tally

url <- "https://en.wikipedia.org/wiki/2016_Summer_Olympics_medal_table"

medal_tally <- url %>% read_html() %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]') %>% html_table(fill=TRUE)
## copy xpath
## //*[@id="mw-content-text"]/div/table[2]
# //*[@id="mw-content-text"]/div/table[2]

medal_tally <- medal_tally[[1]]
head(medal_tally)

#WHS Sites in the UK

url2="https://en.wikipedia.org/wiki/List_of_World_Heritage_Sites_in_the_United_Kingdom_and_the_British_Overseas_Territories"


whsuk <- url2 %>% read_html() %>% 
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[3]') %>% html_table(fill=TRUE)

whsuk <- whsuk[[1]]
head(whsuk)