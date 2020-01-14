
# Stats 4000 1/9/2020
library(tidyverse)

Data <- read.csv("C:/Users/benja/Downloads/CholData-1.csv")

names <- c("country", "chol", "hdi", "meat", "milk", "eggs", "fish", "animals")
colnames(Data) = names

attach(Data)
# Question Number 1
base_model <- lm(chol ~ hdi + meat + milk + eggs + fish + animals, Data)

preds <- data.frame(hdi = .5, meat = 100, milk = 200, eggs = 13, fish = 40, animals = 18)

Y <- predict(base_model, preds)

Y

# Is there a reason to assume it's linear

# Question Number 2
plot(hdi, chol)

cor(chol, hdi)

test <- lm(chol ~ hdi + meat, Data)
preds <- data.frame(hdi = 5, meat = 100)
predict(test, preds)






