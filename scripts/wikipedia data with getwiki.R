# download from github
devtools::install_github("corydonbaylor/getwiki")
# load into R
library(getwiki)

# will return a character string with the contents of the wikipedia page on France. 
get_wiki("France")

# will return a character string with the contents of the wikipedia page on France. 
get_wiki(c("France", "United States"))

# this will keep the html tags from the API results
get_wiki("France", clean = FALSE)

# this will keep the html tags from the API results
search_wiki("United States")

# this will keep the html tags from the API results
us = search_wiki("United States")

# this will return the full text of the wikipedia articles
big_us = get_wiki(us$titles)

### EXAMPLE 1

# this will keep the html tags from the API results
ussr = search_wiki("Soviet Union")

# this will return the full text of the wikipedia articles
big_ussr = get_wiki(ussr$titles)