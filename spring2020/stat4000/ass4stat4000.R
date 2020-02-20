
# Benjamin Buss
# Feb 4th 2020
# STAT 4000 
# Assignment 4

library(tidyverse)

Boston1970 <- read.csv("~/class_work/Boston1970.csv")

# 1. Fit a model y = median price ~ all other variables

model <- lm(MedianHomeValue ~ Crime.Rate + LargeLotZoningPercentage + IndustryPercentage + BorderRiverIndicator + NOXairPollutionConcentration + 
                Rooms.dwelling + ProportionBuiltBefore1940 + DistanceToEmploymentCenters + IndexOfHighwayAccessibility + PropertyTaxRate + 
                Pupil.TeacherRatio + EthnicityMeasure + StatusMeasure , data = Boston1970)
plot(model)

model$coefficients

col_means <- colMeans(Boston1970)

SD <- apply(Boston1970, 2, sd)    

weights <- array(rep(1, 13))

weighting <- function(i, p, q) {
    # i = corresponding column
    # x = value
    ret_var = (((weights[i] * ((p - col_means[i]) / SD[i])) ^ 2) - (weights[i] * ((q - col_means[i]) / SD[i])) ^ 2)
    return(ret_var)
}

distance <- function(p, q) {
    # x  = array
    # q = array
    sum = 0
    for (a in 1:13) {
        sum = sum + (weights[a] * weighting(a, p[a], q[a]))
    }
    guess = sqrt(sum)
    return(guess)
}

p <- c(.02731, 0, 7.07, 0, 0.469, 6.421, 78.9, 4.9671, 2, 242, 17.8, 396.90, 9.14, 21.6)
q <- c(0.00632, 18, 2.31, 0, 0.538, 6.575, 65.2, 4.0900, 1, 296, 15.3, 396.90, 4.98)

distances <- rep(1:506)

for (i in 1:506) {
    temp <- Boston1970 %>% slice(i)
    temp <- as.numeric(temp)
    distances[i] = distance(q, temp)

}
# Q = attributes wanted in the X
# X = other row??

# Model with be algorithm not formula

# Get distances
# Make weighted
# Make algorithm
# Distance from hypothetical neighbor hood to each of the known neighborhoods, find one with smallest distance
# Average of 5 closests??



# Not appropriate to do linear or logistic regression, going to do weighted average base on how "far apart" neighborhoods are

# Weighted average, how to assign weights
# Assign weights using distance

# Abstract Distance Metric

# d(p, Q) = sqrt((c1()))

# 2. Use all but the third to fit logit regression to 1. non zero % chance of large lots 2. zero large lots

logit <- glm(x ~ y, data = Boston1970, family = binomial(link = "logit"))


