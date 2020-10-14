### Intro to regex

Data analysis starts with data cleaning and when it comes to analyzing text data, you will start with regex and stringr. Stringr is a package in R that its tidyverse compatible, meaning that it will work well with tidy text and dplyr. Its main functions allow you to do things like look for a pattern of strings or replace a pattern of strings. 

Regex defines what a pattern of strings is. Instead of writing what you are literally looking for, Regex lets you write shorthand for different patterns, which in the long run is much easier than only being able to write what you are looking for. The obvious example being when you a pattern needs to match two different things-- like if you are looking for words that end in "ing".

Keep in mind that regex is kind of difficult. It is dense and hard to read. When working through this tutorial focus on getting a understanding of what a regex pattern is and how you could apply it with your own data, rather than trying to memorize everything. You can refer back to this guide later if you would like. 

That said, the more you memorize, the less you will need to refer back and the easier working in regex will be. 

### Pattern matching with stringr 

 Stringr is tidy verse's way of working with strings. That means it will plug in well with tidy text, dplyr and tidyr. Stringr has many different functions that you can use but there are three different functions that make up most of the grammar of working with strings in R: 

1. Str_detect which detects if a pattern is in some string
2. Str_extract or str_match which will return a matched pattern from a string
3. Str_replace which will replace a matched pattern from a string

Lets take the following code to create some sample data to work with:

```
library(dplyr)
library(stringr)
library(kableExtra)

sample = data.frame(text = c("this is some sample text",
                    "it is comprised of ample text",
                    "I hope it will help",
                    "if not, than 'oh welp.'",
                    "text only and we in heaven,",
                    "but life is hard so 567."
                    ))

kable(sample)%>%
  kable_styling("striped")
```

Next we are going to create three variables, one for each of our main functions. We are going to be using the pattern "if" for each function. First, we will see if we can detect if in the text, then if we can extract it, and finally if we can replace it with "IF"

```
sample%>%
  mutate(detect = str_detect(text, "if"),
         extract = str_extract(text, "if"),
         replace = str_replace(text, "if", "IF"))%>%
  kable()%>%
  kable_styling("striped")
```

- You can see that the detect returned a TRUE or FALSE based on the pattern
- The extract returned the pattern itself
- And the replace replaced the pattern. Including inside of the word life, we could have gotten around that if we had put spaces around the if. 

There is one more aspect of stringr we are gonna go over in this tutorial and that is the _all suffix. Lets say your pattern turns up twice in a string. If you are just using str_extract it will only extract the first instance. However, if you add "all" to the end it will return both as a list. 

You can add _all to the three functions we have gone over thus far. If you add it to str_replace then it won't return a list, it will just return the string with all instances of the matched pattern replaced. 

### Metacharacters in Regex

The power of regex comes from being able to generate flexible patterns. Metacharacters are special characters that serve as something different than their literal meaning. Take the period for example. In normal language, it signifies the end of the a sentence but in regex, it is a placeholder for any character. Check out four metacharacters and remember the str_extract will return the first character that matches the pattern. If we wanted to return all matched patterns, we would add the all suffix. 

- . Stands for anything
- \\w stands for any letter in the alphabet
- \d stands for any digit
- \s stands for any white space. 

```
sample%>%
  mutate(period = str_extract(text, "."), # . stands for anything. It will return the first character
         character = str_extract(text, "\\w"), # \\w stands for any character
         digit = str_extract(text, "\\d"), # \\d stands for any digit
         white_space = str_extract(text, "\\s"))%>% # \\s stands for any whitespace
  kable()%>%
  kable_styling("striped")
```

Now lets say that the pattern you want to return is a period. How would you specify that you want a period? You can't just use a period right because that could return anything. In regex, you can escape a metacharacter using a \ and in R you have to double escape using two \\\\. Lets look at an example:

```
sample%>%
  mutate(detect = str_detect(text, "\\."),
         extract = str_extract(text, "\\."),
         replace = str_replace(text, "\\.", " :D"))%>%
  kable()%>%
  kable_styling("striped")
```

### Anchors and Optional Qualifiers

Sometimes you only want to return a pattern if certain parameters are met. For example, if it starts a string or ends a string. 

Where a pattern is located is called an anchor. If you want to return a some text from a string that ends with a certain pattern than use $ and if it must begin with a certain pattern than use ^. Lets see this in action. 

So I am creating two variables here, one where the pattern must begin with the word text and one where it must end with the word text. 

```
sample%>%
  mutate(start = str_replace(text, "^text", "----"),
         end = str_replace(text, "text$", "----"))%>%
  kable()%>%
  kable_styling("striped")
```

You can see that the first two rows did in fact match the "end" variable because they ended with the word text. The second to last row matched the "start" variable because it started with the pattern.

*optional characters*

Now moving on to optional qualifiers. Any character or group of characters that is followed by a ? Is considered optional for the pattern. For example, lets say we are deciding how to address Mr. Regex. Sometimes he is feeling fancy and wants to be called Mr. and sometimes he isnt and just regex is fine. 

We can either make each character (including the whitespace) optional by following it with a question mark or we can put Mr. in a parenthesis to indicate that the question mark will apply to that group of characters. Lets try and extract both Mr. Regex and Regex out of some text with one pattern. 

```
df = data.frame(
  text = c("Mr. Regex is proud of you",
           "Regex is an imaginary character in this example.")
)

df%>%
  mutate(
    optional = str_extract(text, "M?r?\\.?\\s?Regex"),
    optional_group = str_extract(text, "(Mr\\.\\s)?Regex")
  )%>%
  kable()%>%
  kable_styling("striped")
```



### Groups

We saw above how you can use groups to make a group of characters optional without having to denote each individual character as optional. 

Another use of groups can be to extract part of a pattern of text without extracting the whole thing. Lets say for example that you want to extract just the file name but not the extension for some pdfs in a folder. 

You could use the following pattern to pull this out. Remember, because we are using groups, we will only return what is between the parenthesis. 

`"(.*?)\\.pdf$"` So breaking this down, the period is a wild card meaning that any character would work here. The asterisk means that it repeats 0 or many times giving us that the length can vary and the question mark makes the repeating optional. 

Outside the parenthesis we have the .pdf and a ending anchor to indicate that the text pattern must end with .pdf. 

So easy enough right? We can now pull out what we want. Not so fast. 

We will use `str_match_all` to pull out a list of both the full pattern and the extracted group (ie the file name) from the text. This will return a list

Next we will unlist it and pull out just the second element in the list 

Now if we stopped here than we would always be pulling out the second matched group which would be "file_record_transcript" so we will need to group by the text variable so that we are performing this operation on each value of text independently.

That in turn will give us what we are looking for. 

If this is confusing that is ok. I will admit that this is the most confusing part in what is probably the most confusing lecture series in this tutorial. Remember regex is more about knowing what to reference rather than needing to memorize everything. 

### Ranges and Repeating Patterns

Ranges allow for you to have multiple possible patterns to match against and are called using brackets. For example, if you put [abc] in brackets then the pattern will match against a b or c. 

By putting a carrot at the beginning of the range you can make it neither a nor b nor c

Instead of writing out all the options, you can also use a dash to indicate through. 

Because regex interprets numbers as characters, the same rules applies for numbers. 

**repeating patterns**

If the pattern you are looking for repeats itself, you don't actually need to write the pattern each time. For example, if you were looking to find a phone number, you wouldn't want to write out \\d repeatedly, you would likely prefer to say that the pattern you are searching for repeats itself. 

To give a more realistic example, let’s say you are talking to a cute girl or guy and they want to give you their number. At this point, you are very eyes-on-the-prize and are not interested in what they have to say but just need those digits. You can use regex to get just the information you need and filter out the unimportant stuff.

The pattern you would use is \\d{3}-\\d{4} because the \d stands for digits and it repeats 3 times, followed by a dash and then \d another 4 times. 

### Example 

Lets build off the repeating pattern example of searching for phone numbers. Lets say you are tasked with detecting fraudulent phone numbers on a dataset of texts. Amazingly, the texts are already marked as fraud or not fraud, so its just up to you to pull out the phones.

Run the following code to get your data. 

```
dataset = data.frame(
  fraud = c("yes", "no", "no", "yes"),
  message = c(
      "Want to make $35,000 working from home? Call (804) 675-9999",
      "Hey its your crush. I know I am texting you but in case you dont have my number its (888) 646-8888",
      "Its your mom, doing mom things",
      "This is microsoft support, you have very bad virus call us at 888-999-1000"
      )
)
```

Heres a few hints before you get started:

- Filter out the good texts
- Use repeating patterns and metacharacters for the numbers
- The phone numbers will come in different formats, you can use optionality to handle this



We will pause here for a while to give you a chance to do the problem.

The first step is of course to filter down to just the rows with fraud using the filter argument. Next, we will create a new variable with just the extracted numbers. As with all regex, the pattern is feels kind of complex so lets break it down. 

First we are going to create a pattern that pulls out repeating numbers that match the typical 10 digit number format. Something like `\\d{3}-\\d{3}-\\d{4}`, which would match the 888-999-1000 phone number

Obviously the other phones are in a different format. We need to write a pattern where the parenthesis and the first dash are optional, something like `"\\(?\\d{3}(\\)\\s)?-?\\d{3}-\\d{4}"`. 

- You can see that the first parenthesis is both escaped and optional. Its escaped because it is a metacharacter that denotes the start of a group whereas we are looking for an actual parenthesis. 
- The \\d denotes a digit that is repeated three times. 
- Then the \\( and \\s is put in a group and set to optional
- The - is then set to optional
- Then the rest of the pattern is pretty simple. Just repeating digits and a dash