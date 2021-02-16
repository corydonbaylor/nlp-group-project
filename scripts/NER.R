options(java.parameters = "- Xmx1024m")
library(rJava)
library(NLP)
library(openNLP)
gc()

# install.packages("openNLPmodels.en", dependencies=TRUE, repos = "http://datacube.wu.ac.at/")
package <- "openNLPmodels.en"
model <- system.file("models/en-parser-chunking.bin",
                     package = package)

library(rvest)
page = read_html('https://en.wikipedia.org/wiki/Berkshire_Hathaway') 
text = html_text(html_nodes(page,'p'))
text = text[text != ""]
text = gsub("\\[[0-9]]|\\[[0-9][0-9]]|\\[[0-9][0-9][0-9]]","",text) # removing refrences [101] type
text = paste(text,collapse = " ") 
text = as.String(text)




sent_annot = Maxent_Sent_Token_Annotator()
word_annot = Maxent_Word_Token_Annotator()
loc_annot = Maxent_Entity_Annotator(kind = "location") #annotate location
people_annot = Maxent_Entity_Annotator(kind = "person") #annotate person
organization_annot = Maxent_Entity_Annotator(kind = "organization")
date_annot = Maxent_Entity_Annotator(kind = "date")

annot.l1 = NLP::annotate(text, list(sent_annot,word_annot,loc_annot,people_annot, organization_annot, date_annot ))

k <- sapply(annot.l1$features, `[[`, "kind")
berk_locations = text[annot.l1[k == "location"]]
berk_people = text[annot.l1[k == "person"]]
berk_org = text[annot.l1[k == "organization"]]
berk_date = text[annot.l1[k == "date"]]


foo = as.data.frame(annotations)

foo$features 
  
for (i in 1:nrow(foo)){
  foo$features[i] = substr(text, foo$start[i], foo$end[i])
}
  substr(text, foo$start, foo$end)

plot(table(berk_org))

