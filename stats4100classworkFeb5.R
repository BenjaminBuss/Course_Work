
#Benjamin Buss
# STAT 4100
# Feb 5th 2020
# In Class Work

battery <- read.csv("~/class_work/battery.csv")

battery$TYPEBAT.fac=as.factor(battery$TYPEBAT)
plot(battery$TYPEBAT.fac, battery$LPUC)

mean.vector = tapply(battery$LPUC, battery$TYPEBAT.fac, mean)

n = nrow(battery)
v = nlevels(battery$TYPEBAT.fac)

r = 4

variance.vector = tapply(battery$LPUC, battery$TYPEBAT.fac, var)

sse = sum((r-1) * variance.vector)

sigma2.hat = sse/(n-v)
sigma.hat = sqrt(sigma2.hat)

lower.limit = sse/qchisq(.975, df=n-v);lower.limit
upper.limit = sse/qchisq(.025, df=n-v);upper.limit

# Need to understand the formula

sstot <- sum((battery$LPUC- mean(battery$LPUC))^2)
sstot

sst <- sum(r*(mean.vector-mean(battery$LPUC))^2)
sst

sse <- (r-1)*sum(variance.vector)
sse

d <- sstot - sst
mst <- sst/(v-1)
mse <- sse/(r*v-v)

f <- mst/mse
f

pvalue.f = pf(f,df=v-1, df2 = r*v-v, lower.tail = F)
pvalue.f


model = lm(battery$LPUC ~ battery$TYPEBAT.fac, data = battery)
anova(model)

se.yhat.i = sigma.hat / sqrt(r)



