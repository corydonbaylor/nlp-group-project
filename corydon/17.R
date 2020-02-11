####### More on rvest

#### Read in and glean info from text data

library(rvest)
library(stringr)

url="https://www.washingtonpost.com/news/the-fix/wp/2016/09/26/the-first-trump-clinton-presidential-debate-transcript-annotated/?utm_term=.76c25871d72c"

t_link=read_html(url)

#to extract out the relevant html tag for the transcript 
transcript = t_link %>% html_nodes("#main-content") %>% html_text()

##unstructured text

# We have 3 different patterns/speakers to search for 
#which will include in our expression using the or operator '|'
# str_locate_all of stringr will give the index (start and end position) of all the matches
markers <- str_locate_all(transcript, pattern = "CLINTON|TRUMP|HOLT")

head(markers)

# This returns a list with one component - we extract out that component
markers = markers[[1]]

# Now markers is a matrix indicating the start and end positions
#  extract start positions
markers =markers[,1]

#substr pulls out text chunks

##text chunks relating to Trump, clinton and holt

# Initialize a vector to store the results
res = vector(mode = "character", length = length(markers) - 1)
for (i in 1:(length(markers)-1)) {
  res[i] <- substr(transcript,markers[i],markers[i+1]-1)
  
}

#identfiy and store chunks spoken by Trump and Clinton 

clinton = res[sapply(res,function(x) grepl("CLINTON",x))]
trump = res[sapply(res,function(x) grepl("TRUMP",x))]
head(res)

tot_words_t = unlist(sapply(trump, function(x) str_split(x, " ")))

# exclude blank values  
tot_words_t = tot_words_t[tot_words_t != ""]
length(tot_words_t)

#most common words?
library(plyr)

w_freq=count(tot_words_t) %>% arrange(desc(freq))

head(w_freq,n=20)