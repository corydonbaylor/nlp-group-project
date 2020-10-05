### What is web scrapping?

Web scrapping is pulling down data from a website and cleaning it so that it can be used for analysis. In R, rvest is the primary tool for doing this in R. But how does this apply to NLP, you may be wondering.

Well, oftentimes really useful text data will be found on the web instead of a format easily digestible by R. For example, you may be interested in transcripts of conversations or collections of news articles from a particular publication. Web scrapping will allow us to access this text data and use it in R. 

Lets start by taking a look at what a webpage is made up of. Lets open up the following wikipedia page in chrome. When you right click and click inspect it opens up the inspector and we can see the HTML that makes up a webpage. 

This HTML is what we will be scrapping. 

While this course isn't focused on web development, it is helpful to have a basic sense of what we are looking at here. HTML is made up of nested sections called tags. For example, the body tag represents the section of the HTML that is visible to the user. Within that body tag is things like headers and content. 

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

You can either pull back a single element (ie tag) or multiple elements in rvest. Lets keep it simple and say we want to pull back one tag for this example. We will need to find this elements xpath in order to do this. An xpath is a stable identifier for a particular element of a webpage. 

To find an xpath, we will right click on what we want. Then we will find its tag in the html console. Right click that tag, go to copy then copy xpath. 

Ok so we have the xpath. How is this helpful?  

Lets return to our R script. We are going to pipe the results of `read_html()` into a `html_node()` and provide `html_node()` with our xpath. `html_node` will be looking for a single node or element from an html object and returning that. 

Finally, we are going to pipe that result into the `html_table()` function. This will transform our result into a data.frame! And with that you have what you need!  You have taken a web table, found its xpath, brought it into R and converted it to an R data frame

```
library(rvest)
medal_tally = read_html("https://en.wikipedia.org/wiki/2016_Summer_Olympics_medal_table")%>%
html_node(xpath='//*[@id="mw-content-text"]/div/table[2]') %>%
  # if that node is a table, you can pull it out with html_table
  html_table(fill=TRUE)
```

### Web Scraping Not So Basics

Using the `html_table` function is all well and good if you are trying to pull data from a web table but often times you are trying to create a data frame from unorganized data. 

Enter `html_text`.  This function will extract text from inside a tag. Lets look at a quick example. Lets head to over to IMDB. 

As you can see we have a list of movies released in 2017 and we want to get that list of movies and save it as a character vector in R. 

Earlier we pulled a single html tag using `html_node`. Now we are going to pull multiple html tags using `html_nodes`. In our case we want to pull the tags that have the titles of the movies inside of them.

Step 1 then will be to get the html into R, using our trusty `read_html` function. Next we want to grab the titles of the movies. So we will right click and open up dev tools.  

Notice how when we hover over the `<h3>` class we see that the title become highlighted? That means that we have the right tag. We are going to use the CSS class instead of the xpath because we want to pull data from this webpage for **every** title not just this one. Using the CSS class will pull data on all tags that are assigned that class, thus giving us all the titles. 

We are going to further refine what we are pulling by specifying that we are looking for `a tags` that use this class rather than any type of tag. Lets see what it pulls back!

```
url = "http://www.imdb.com/search/title?year=2017&title_type=feature&"

# This CSS class contains all the title names for movies.
titles = read_html(url)%>%
  html_nodes(css = '.lister-item-header a')

titles[1:2]
```

The good news is that it does in fact pull back the data that we are looking for. The bad news is that it also pulls back the entire tag instead of just the text within the tag. 

Easy enough, we can use that `html_text` tag we talked about earlier to extract the text. 

```
titles = read_html(url)%>%
  html_nodes(css = '.lister-item-header a')%>%
  html_text()
```

You will end up with a character vector as a result. Combine this with other data and you can build a data frame. Which we will do in our next example!

### Example 1

Next we to use the rvest to try and create a dataframe from web data. We will want to have the rank, title, run_time, genre and primary genre for our data frame. 

A good strategy would be to find the CSS classes that you will need using inspect. Then to extract them using html_text, and then to put them into a dataframe using `data.frame()`. Pause here before we go over the answers

We will pretty much being doing what we covered in the "Web Scrapping Not so Basics" tutorial five different times. 

For each variable that we create, we first use html nodes to pull back multiple nodes based on the CSS class, html_text to extract the text, and then some regex to clean up the results. 

So for example, to pull the rank, we pull all nodes with .text-primary as the css class, then take out the text using `html_text`, then `extract_numeric` to get the numbers. This will result in a numeric vector, which we save as a variable called rank, using our `data.frame()` function. 







  