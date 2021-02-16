library(dplyr)
library(stringr)
library(kableExtra)

# pattern matching with Stringr
sample = data.frame(text = c("this is some sample text",
                             "it is comprised of ample text",
                             "I hope it will help",
                             "if not, than 'oh welp.'",
                             "text only and we in heaven,",
                             "but life is hard so 567."
))

sample%>%
  mutate(detect = str_detect(text, "if"),
         extract = str_extract(text, "if"),
         replace = str_replace(text, "if", "IF"))

# the all suffix
all = c("I am repetitive and repetitive")

str_extract_all(all, "repetitive")

all = c("I am repetitive and repetitive")

str_replace_all(all, "repetitive", "very repetitive")

# metacharacters
sample%>%
  mutate(period = str_extract(text, "."), # . stands for anything. It will return the first character
         character = str_extract(text, "\\w"), # \\w stands for any character
         digit = str_extract(text, "\\d"), # \\d stands for any digit
         white_space = str_extract(text, "\\s"))

# escaping special characters
sample%>%
  mutate(detect = str_detect(text, "\\."),
         extract = str_extract(text, "\\."),
         replace = str_replace(text, "\\.", " :D"))

# anchors
sample%>%
  mutate(start = str_replace(text, "^text", "----"),
         end = str_replace(text, "text$", "----"))

# optional characters
df = data.frame(
  text = c("Mr. Regex is proud of you",
           "Regex is an imaginary character in this example.")
)

# groups
df%>%
  mutate(
    optional = str_extract(text, "M?r?\\.?\\s?Regex"),
    optional_group = str_extract(text, "(Mr\\.\\s)?Regex")
  )

characters = data.frame(
  text = c("file_record_transcript.pdf", "file_07241999.pdf", "testfile_fake.pdf.tmp")
)

characters%>%
  group_by(text)%>%
  mutate(match = unlist(str_match_all(text, "(.*?)\\.pdf$"))[2])

text = c("file_record_transcript.pdf", "file_07241999.pdf", "testfile_fake.pdf.tmp")

str_match_all(text, "(.*?)\\.pdf$")

characters%>%
  mutate(match = unlist(str_match_all(text, "(.*?)\\.pdf$"))[2])

match = unlist(str_match_all(text, "(.*?)\\.pdf$"))
match

# character and numeric ranges
characters = data.frame(
  text = c("can", "man", "fan", "ran", "tan")
)

characters %>%
  mutate(match = str_extract(text, "[cmf]an"),
         match = str_match(text, "[^rt]an"),
         match = str_match(text, "[e-r]an")
  )

numbers = data.frame(
  text = c(10, 4, 22, 35, 1, 0, 300, 199)
)

numbers %>%
  mutate(
    one2nine = str_extract(text, "^[1-9]$"),
    ten2fiftynine = str_extract(text, "^[1-5][0-9]$"),
    one2twentynine = str_extract(text, "^[1-9]$|^[1-2][0-9]$"),
  )

# repeating patterns
text = "Anywho, I, who am your very cute crush, think you are very cute yourself and I wanted to give you my number. But I am so embarassed, so I am fumbling over my words because you are so attractive and oh dear, I promise I am not usually like this. Well anywho, the digits! I was supposed to give those to you, but wait just a moment what was my own number again. Ah yes it is 555-6789. You got that? You didn't write it down. Do you need me to text it to you? Oh you will text me first. Good. I am excited."

str_extract(text, "\\d{3}-\\d{4}")

### EXAMPLE 1
dataset = data.frame(
  fraud = c("yes", "no", "no", "yes"),
  message = c(
    "Want to make $35,000 working from home? Call (804) 675-9999",
    "Hey its your crush. I know I am texting you but in case you dont have my number its (888) 646-8888",
    "Its your mom, doing mom things",
    "This is microsoft support, you have very bad virus call us at 888-999-1000"
  ))
  
  dataset = dataset%>%
    filter(fraud == "yes")
  
  dataset%>%
    filter(fraud == "yes")%>%
    mutate(bad_nums = str_extract(message, "\\(?\\d{3}(\\)\\s)?-?\\d{3}-\\d{4}"))
