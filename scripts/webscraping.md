### What is web scrapping?

Web scrapping is pulling down data from a website and cleaning it so that it can be used for analysis. In R, rvest is the primary tool for doing this in R. How does this apply to NLP you may be wondering?

Well, oftentimes really useful text data will be found on the web instead of a format easily digestible by R. For example, you may be interested in transcripts of conversations or collections of news articles from a particular publication. Web scrapping will allow us to access this text data and use it in R. 

Lets start by taking a look at what a webpage is made up of. Lets open up the following wikipedia page in chrome. When you right click and click inspect it opens up the inspector and we can see the HTML that makes up a webpage. 

This HTML is what we will typically be scrapping. 

While this course isn't focused on web development it is helpful to have a basic sense of what we are looking at. HTML is made up of nested sections called tags. For example, the body tag represents the section of the HTML that is visible to the user. Within that body tag is things like headers and content. 

For R, the process of webscaping is about taking the data contained within these tags and transforming it into something easy to work with, typically a data frame. 

Next we are going to get into using the rvest package to import HTML into R.

### Web Scraping Basics in rvest

In this lesson, we are going to go over how to use the basic functions of rvest. 

The first function should come as no surprise. We need html to get from the web to our computers and will use the `read_html` function to do just that. 

Just copy paste the following from the tutorial into an r script. 

```
library(rvest)
read_html("https://en.wikipedia.org/wiki/2016_Summer_Olympics_medal_table")
```

This will read in all the html from that webpage. But that isnt that helpful is it?

We need to find individual elements of a webpage not the whole page. Lets say that we want to get the table from this page. How would we find it?

Well, back to the inspector in chrome. 

You can either pull back a single element (ie tag) in rvest or multiple elements. Lets keep it simple and say we want to pull back one thing for this example. We will need to find this elements xpath in order to do this. An xpath is a stable identifier for a particular element of a webpage. 

To find an xpath, we will right click on what we want. Then we will find its tag in the html console. Right click that tag, go to copy then copy xpath. 

Ok so we have the xpath. How is this helpful? Well now we know what part of the html we just pulled that we need. 

Lets return to our R script. We are going to pipe the results of read_html() into a `html_node()` and provide `html_node()` with our xpath. `html_node` is looking for a single node or element from an html object and returning that. 

Finally, we are going to pipe that result into the `html_table()` function. This will transform our result into a data.frame! And with that, you have taken a web table, found its xpath, brought it into R and converted it to an R data frame

```
library(rvest)
medal_tally = read_html("https://en.wikipedia.org/wiki/2016_Summer_Olympics_medal_table")%>%
html_node(xpath='//*[@id="mw-content-text"]/div/table[2]') %>%
  # if that node is a table, you can pull it out with html_table
  html_table(fill=TRUE)
```

