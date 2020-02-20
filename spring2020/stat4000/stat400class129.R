
# STAT 4000
# Benjamin Buss
# Class work 1/29/2020

rpm <- read.csv("~/class_work/rpm.csv", header = T)

set.seed(4100)
trts = rep(1:5, c(5, 3, 5, 2, 5))
trt_ass <- sample(trts, 20, r = F)

sample.mean = tapply(rpm$liters.minute, rpm$rpm, mean)
s.mean.2 = aggregate(rpm$liters.minute, list(rpm$rpm), mean)

difference = s.mean.2$x[1] - s.mean.2$x[5]
variance = var()





