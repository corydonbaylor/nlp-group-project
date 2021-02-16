library(jsonlite)

# this will return a list with information about ditto
ditto = fromJSON("https://pokeapi.co/api/v2/pokemon/ditto")

ditto$species$name

### PROBLEM 1
library(jsonlite)
library(kableExtra)
library(dplyr)

pokemon = c("pikachu", "ditto", "eevee", "charizard")

# initialize outside of for loop
names = c()
height = c()
weight = c()
base_experience = c()
primary_type = c()

# loop through different pokemon
for(i in 1:length(pokemon)){
  
  # this will return a list with information about ditto
  data = fromJSON(paste0("https://pokeapi.co/api/v2/pokemon/", pokemon[i]))
  
  # append will add the result to the end of the vector
  names = append(names, data$species$name)
  height = append(height, data$height)
  weight = append(weight, data$weight)
  base_experience = append(base_experience, data$base_experience)
  primary_type = append(primary_type, data$types$type$name[1])
}

# data will compile the vectors into a dataframe
pokemon_df = data.frame(
  names,
  height,
  weight,
  base_experience,
  primary_type
)

head(pokemon_df)

### PROBLEM 2
library(jsonlite)
library(kableExtra)
library(dplyr)

films = c("Batman+Begins", "The+Incredibles", "The+Godfather", "Parasite")

titles = c()
years = c()
ratings = c()
runtimes = c()
genres = c()
actors = c()

# PLEASE NOTE: you will need to save your key as omdbkey for this to work
for(i in 1:length(films)){
  
  data = fromJSON(paste0("http://omdbapi.com/?apikey=", omdbkey,"&t=", films[i]))
  
  titles = append(titles, data$Title)
  years = append(years, data$Year)
  ratings = append(ratings, data$Rated)
  runtimes = append(runtimes, data$Runtime)
  genres = append(genres, data$Genre)
  actors = append(actors, data$Actors)
}

film_df = data.frame(
  titles,
  years,
  ratings,
  runtimes,
  genres,
  actors
)

head(film_df)