
# Stats 4000 1/9/2020
library(tidyverse)

Data <- read.csv("C:/Users/benja/Documents/Misc/CholData-1.csv")

names <- c("country", "chol", "hdi", "meat", "milk", "eggs", "fish", "animals")
colnames(Data) = names

attach(Data)
# Question Number 1
base_model <- lm(chol ~ hdi + meat + milk + eggs + fish + animals, Data)

preds <- data.frame(hdi = .5, meat = 100, milk = 200, eggs = 13, fish = 40, animals = 18)

Y <- predict(base_model, preds)

Y

#Test is residuals normally distributed
qqnorm(base_model$residuals)


pairs(Data)

# Is there a reason to assume it's linear


# *** KEY TAKE AWAYS ***
# Multiple Regression
# Cauasal infrence and interpretation

# Investigate plays on reression




# Residual = yi - yhat
# yhat = E(y/x)



# Shoutout To https://daviddalpiaz.github.io/appliedstats/multiple --------
set.seed(4000)
n = 100 # Sample size
p = 7 # # predictors + 1

# Assuming betas are fixed values pulled from original model
beta_0 = 5  # ** UNKNOWN ** INTERCEPT
beta_1 = 1.371004 # hdi
beta_2 = 0.001430  # meat
beta_3 = 0.000357  # milk
beta_4 = 0.010355  # eggs
beta_5 = 0.001648  # fish
beta_6 = 0.007664  # animals
sigma  = 4  # 

x0 = rep(1, n)
x1 = runif(n, 0.289, .95) #hdi
x2 = runif(n, 3.1, 142.5) #meat
x3 = runif(n, 3.5, 367.6) #milk
x4 = runif(n, 0.2, 20.2) #eggs
x5 = runif(n, 0.2, 139) #fish
x6 = runif(n, 0, 26.6) #animals
X = cbind(x0, x1, x2, x3, x4, x5, x6)
C = solve(t(X) %*% X)

eps = rnorm(n, mean = 0, sd = sigma)
y   = beta_0 + beta_1 * x1 + beta_2 * x2 + beta_3 * x3 + beta_4 * x4 + beta_5 * x5 + beta_6 * x6 + eps 
sim_data = data.frame(x1, x2, x3, x4, x5, x6, y)

num_sims = 1000
beta_hat_2 = rep(0, num_sims)
for(i in 1:num_sims) {
    eps = rnorm(n, mean = 0, sd = sigma)
    sim_data$y = beta_0 * x0 + beta_1 * x1 + beta_2 * x2 + beta_3 * x3 + beta_4 * x4 + beta_5 * x5 + beta_6 * x6 + eps
    fit = lm(y ~ x1 + x2 + x3 + x4 + x5 + x6, data = sim_data)
    beta_hat_2[i] = coef(fit)[3]
}

mean(beta_hat_2)



(beta_hat = C %*% t(X) %*% y)
 


# Vector
# MAtrix
# Dot product
# Matrix multi
# Matrix inverse
# xxMatrix transpose
