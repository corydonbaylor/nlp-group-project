## load udpipe
library(udpipe)
library(kableExtra)
library(dplyr)

## download the "english" model
udmodel <- udpipe_download_model(language = "english")

##let's load the "english' model
udmodel <- udpipe_load_model(file = udmodel$file_model)

library(getwiki)
text = get_wiki("Berkshire Hathaway") 

pos <- udpipe_annotate(udmodel, 
                       x = text)

pos <- as.data.frame(pos)

## how can get a count of words by parts of speech using the following data.
table(pos$upos)

pos <- cbind_dependencies(pos, type = "parent")
nominalsubject <- subset(pos, dep_rel %in% c("nsubj"))
nominalsubject <- nominalsubject[, c("dep_rel", "token", "token_parent")]