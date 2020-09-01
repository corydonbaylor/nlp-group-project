In this lesson, we are going to cover APIs. APIs are a very broad topic. For our purposes, we are going to be looking at APIs as they relate to retrieving text data (or really any data) in R

So what is an API? An API stands for an Application Program Interface. Although this sounds complex all it means is that it is a way for different computers to talk to each other. 

We are going to try and keep this tutorial as jargon free as possible but there are some basic concept where it will be helpful to use the official terminology so when you talk to your computer science friend you sound informed. 

First lets go over the client. The client is the program or person using the API. So if you manually created an API call, which we will do later, you are the client. If you wrote a script that did the call, that script is the client. 

Next, lets go over what a resource is. A resource is the information that you are trying to pull back with your API call. 

So an API then is a way for a client to pull a resource from a server

There are many different ways your can interact with an API but we are just interested in getting data. What do you call a API request that handles **getting data**? If you guessed a **get** request, you are starting to **get** it. 

**Manual get request**

Lets do our first get request now!

We are going to go to pokeapi.co which is a website that lets you pull information about Pokemon from the web. 

Now I am going to enter a special url which will create a get request from pokeapi

First I enter the website, pokeapi.co then I add specify that I want to be using their api pokeapi.co/api/v2/pokemon

Then I am going to pass a parameter to this API, in this case the Pokemon ditto so I add 

pokeapi.co/api/v2/pokemon/ditto

You will see a who lot of gobbality gook pulled back. What we have here is a JSON. It is a type of data object that is commonly used in web development. Right now, its a little hard to read so lets do this in R

**API call in R**

As a reminder all the code used here can be pulled from the API page in the lesson book. I am just copy pasting it into a new script so that it is easier to work with. 

First we need to load in the jsonlite package. This package will allow us to transform JSONs into something we are more familiar with in R, namely lists.

So lets create a list that's about ditto.

You can see that we are using the same url from the previous video to pull the JSON and saving it as an object called ditto

Everything that was in that gobbality gook from earlier is now rolled up into this big nested list called ditto. 

If we pulled a different Pokemon it would pull a different list with the SAME format. 

This is a super important concept. The API will pull back the same format but will change the content based on the parameters that you pass to it. This allows you to use the API programmatically. 

Imagine for example as we will do in our practice problems. That we wanted to pull a list of Pokemon and make a data frame from it. 

We could do a for loop where the parameter that we pass to the API is a variable and then clean up the results so that they are a data frame. 

**API tokens**

Some APIs like twitters or Facebook have sensitive personal information on it and instead of pulling back info like pikachu's type advantages, the Facebook API could pull back info like John Smith's address, political beliefs, and list of fears.  We wouldn't want just anyone to be able to pull that info back.

To determine who can access what an API will use a token or key to manage access. Think of it like a password. And like any password, you aren't meant to share it publicly. 

Lets use omdb's api key as an example. Its pretty simple to get one. Just head to their site and put in your email address and short explanation of why you want the key. You can say that its for learning and they will email you a key. We will name a variable omdbkey and use it later in our second practice problem.

**problem 1**

In this problem we are going to use the Pokemon API to build a small dataset around our four favorite Pokemon. If you haven't taken a second to try this problem, pause here and give it a try. Use the hints to work out a potential solution. 

We are going to use a for loop to cycle through each Pokemon and pull back the needed info. 

In case you are unfamiliar, a for loop repeats a set of operations a given number of times. The "I" is a special variable that updates each time the loop is completed. The first run it will be set to 1 and then to 2 and so on and so forth, until it hits 5. 

We are going to create a vector of pokemon. I choose you pikachu, ditto, eevee, and charizard! 

We then will initialize some variable vectors that will population with info on each Pokémon while in the loop. 

We are then going to run the loop, appending information about the Pokémon to the end of the variable vectors.

Outside the loop, we will combine those vectors into a dataframe. 

 Easy right?

Lets take a closer look at that loop. Lets say we are on iteration 1. So i is equal to 1

On line 18, we create the URL we will use to pull the data. We use paste0 here to combine our url with the first element of the Pokemon vector, which will be pikachu. Because the first item in the Pokemon vector is pikachu and Pokemon[I] is the same as Pokemon[1].

At this point, the data object is all about pikachu. 

We will append data$species$name, which is pikachu, to the end of the names vector and overwrite it as names. We do this for each variable vector. 

Next we repeat this process for each Pokemon, each time appending and updating the variable vectors with new info.

As we said before, once the loop is done we put it all in a dataframe and voila, we have a Pokemon data frame.

**problem 2**

Pause here if you haven't finished this problem yet. We will be using the exact same strategy as we did for the first problem here as well. 

We are going to create a vector of films. 

We then will initialize some variable vectors that will population with info on each film in the loop. 

We are then going to run the loop, appending information about the film to the end of the variable vectors.

Outside the loop, we will combine those vectors into a dataframe. 