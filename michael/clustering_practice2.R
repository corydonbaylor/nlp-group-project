library(cluster.datasets)

data(birth.death.rates.1966)

birthdeath <- birth.death.rates.1966

birthdeath = as.data.frame(unclass(birthdeath))
summary(birthdeath)
dim(birthdeath)

birthdeath = na.omit(birthdeath)
dim(birthdeath)
summary(birthdeath)

scaled_data = as.matrix(scale(birthdeath))

kmm = kmeans(animaltrees,3,nstart = 50,iter.max = 15)

head(animaltrees)
