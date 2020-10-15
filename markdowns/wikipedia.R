test = fromJSON("https://en.wikipedia.org/w/api.php?action=parse&page=ireland&prop=text&format=json")
test$parse$text

title = "ireland"
result = fromJSON(paste0("https://en.wikipedia.org/w/api.php?action=query&titles=", title, "&prop=extracts&redirects=&format=json"))

names(result$query$pages) = "content"

wiki_clean <- function(htmlString) {
  htmlString = gsub("\n", "", htmlString)
  return(gsub("<.*?>", "", htmlString))
}

final = wiki_clean(result$query$pages$content$extract)
