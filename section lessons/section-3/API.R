######################################################################
########## extract data from guardian

## https://bonobo.capi.gutools.co.uk/register/developer

library(GuardianR)
library(qdap)

key=""

results <- get_guardian("islamic+state", 
                        section="world",
                        from.date="2014-09-16", 
                        to.date="2014-09-16", 
                        api.key="212d23d3-c7b2-4273-8f1b-289a0803ca4b")
#mary+jane+smith
head(results)

results2 = get_guardian("donald+trump",
                       section="world",
                       from.date="2016-11-09",
                       to.date="2016-11-10",
                       api.key="")

## some data cleaning

#remove all encodings
body=iconv(results$body,"latin1","ASCII",sub="") 
#$body stores the text

body=gsub('http\\S+\\s*','',body) #remove weblinks

##remove HTML tags
body=bracketX(body,bracket="all")

bodytext=data.frame(id=results$id,text=body)

head(bodytext)