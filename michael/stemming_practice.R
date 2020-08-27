#Stemming and Lemmatization

#Inflection is the modification of words to express different grammatical categories. Most languages,
#including English, have inflection.

#Stemming: the process of reducing inflection in words to their 'root' forms
#such as mapping a group of words to the same stem.

#In NLP, stemming occurs after tokenization.

#There are english and non-english stemmers
#Different english language stemmers include the 'porter' stemmer and 'lancaster' stemmer.
#'Porter' is the most common stemming algorithm.
#Multi-language stemmers include 'snowball', 'isri', and 'rslps'.

#Lemmatization reduces the inflected words properly ensuring that the root word belongs
#to the language. Lemmatization is the base form of the word, or the reverse of inflection. Groups together
#different inflected forms of the word called lemma. A Lemmatizer should map 'gone', 'going',
#and 'went' into 'go'.

#Both stemming and lemmatization are part of the text preparation process that precedes analysis.
#Both stemming and lemmatization generate the root form of the inflected words.
#The difference is that stemming might not result in an actual language word, whereas 
#lemmatization results in an actual language word.
#Stemming follows an algorithm with steps to perform on the words, making it faster. Lemmatization
#uses WordNet Corpus and a corpus for stopwords as well to produce lemma, which makes it slower
#than stemming. You also need to define the correct parts of speech.

#More information on the differences between and applications of stemming and lemmatization can
#be found here: https://nlp.stanford.edu/IR-book/html/htmledition/stemming-and-lemmatization-1.html

#Other potential topics: POS Tags, Named Entity Recognition, Chunking


#Snowball Stemmer

library(corpus)

text_love <- "love loving lovingly loved lover lovely love"
text_love <- text_tokens(text_love, stemmer = "en") 
text_love

text_fish <- "fish fisher fishing fished fishery"
text_fish <- text_tokens(text_fish, stemmer = "en") 
text_fish

text_talk <- "talk talkshow talking talked talkathon"
text_talk <- text_tokens(text_talk, stemmer = "en") 
text_talk



