# APIs
## extracting data from the Guardian
## https://bonobo.cap.gutools.co.uk/register/developer

library(GuardianR)
library(qdap)

key = "a86d7054-4712-4bcb-b59f-b17276459666"

results.2 = get_guardian("islamic+state",
                       section = "world",
                       from.date = "2016-09-16",
                       to.date = "2016-09-16",
                       api.key = "a86d7054-4712-4bcb-b59f-b17276459666")
head(results)

# removing all encodings
body = iconv(results$body, "latin1", "ASCII", sub = "")

body = gsub('http\\S+\\s*', '', body) # remove weblinks

# remove HTML tags
body = bracketX(body, bracket = "all")
