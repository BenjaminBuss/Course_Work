#Benjamin Buss
#STAT 4200
#2019/09/29

set.seed(100)
ind = 1:20000 #index
#h = rnorm(20000, 64, 3) #height
age = runif(20000,17,24) #age
x = 54+ .5*age +rnorm(20000) #real height
relative_probability = 10/((age-17)*1.5)
m = matrix(c(ind,age,relative_probability),ncol=3,byrow=F)
head(m, n=100)

#The problem: estimate the average height, assess the uncertainty in your estimate
#1. how to assign the probabilities
#2. how to (w/simulations or a FOR loop) assess uncertainty
#Basis: oversample old, undersample young
#big denominator when old, small when young, so on paper everyone is the same height

a = sample(x, 1000, replace = FALSE) 
sd(a) #lowest SE wins

g = 1
i = 1
b = 1
c = 1
d = 1
e = 1
f = 1
g = 1
q = 1

# best = 1
z = 1
while(sd(a) > .9) {
  g = 1
  i = 1
  z = z -.001
  while(sd(a) > z) {
    a = sample(x, 1000, replace = FALSE, prob = relative_probability)
    b = runif(1, min=-30, max = 30)
    c = runif(1, min=0, max = 30)
    d = runif(1, min=0, max = 30)
    e = runif(1, min=0, max = 17)
    f = runif(1, min=0, max = 30)
    relative_probability = (c/(d/((age-e)^b)))*f
    i=i+1
    q=q+1
    # if(sd(a) < best) {
    #   best = sd(a)
    # }
  }
  print(paste0("SE:", z, "   Total Tries:", q, "   Below:", g, "   Rate:", (g/i), "   Num:", sd(a)))
  print(paste0("B:", b, "   C:", c, "   D:", d, "   E:", e, "   F:", f))
}

#relative_probability = c/(d/((age-17)^b)) for 1.05 with c=1.61768409074284, d=1.1361458315514, b=4.7136531281285
#.9865888 with b = 10.6165657269303, c=1.45140942069702, d=11.6504042199813
#0.9752399 with b=7.108305,          c=10.05642,         d=14.95221
#0.9666739 with 9.900395,              3.697091,           17.00452
#0.9613975 with 2.298969,              12.77561,           14.56916

# "SE:0.957   Tries:1   Below:1   Rate:1   Num:0.956979199964534"
# "B:3.32733120303601   C:2.65619918704033   D:9.60348683875054   E:16.5976735115983   F:1"
# "SE:0.958   Tries:1   Below:1   Rate:1   Num:0.957661934436367"
# "B:6.1161004146561   C:25.3220430831425   D:13.8902312633581   E:5.96059890743345   F:15.2078089001589"
# "SE:0.957   Tries:1   Below:1   Rate:1   Num:0.956855114818098"
# "B:-34.4477545237169   C:17.2658041119576   D:45.7491920213215   E:0.792973448522389   F:5.15442125033587"
# "SE:0.948   Tries:1   Below:1   Rate:1   Num:0.947949670402343"
# "B:-16.5321423998103   C:27.8997571533546   D:7.56016950588673   E:1.1378566538915   F:20.9808355034329"
# "SE:0.945   Tries:1   Below:1   Rate:1   Num:0.944111495452392"
# "B:24.003479629755   C:3.64189954474568   D:15.3062045574188   E:9.32534153270535   F:5.73254402261227"
# "SE:0.942   Tries:1   Below:1   Rate:1   Num:0.941327606767004"
# "B:23.8622518116608   C:24.4190299557522   D:17.5499470392242   E:4.15552669065073   F:15.8223225991242"
# "SE:0.94   Tries:1   Below:1   Rate:1   Num:0.939807067826474"
# "B:-29.8777874512598   C:29.9454751680605   D:7.95429044170305   E:9.51620828732848   F:2.55061083706096"
# "SE:0.934   Tries:1   Below:1   Rate:1   Num:0.933801679483302"
# "B:2.23560463171452   C:9.95420662919059   D:18.5454311664216   E:7.62221013498493   F:26.7831447604112"
# "SE:0.934   Total Tries:4197   Below:1   Rate:1   Num:0.933701647279744"
# "B:-27.0857559610158   C:22.3438722803257   D:14.108622148633   E:12.6510289353319   F:0.103189945220947"
# "SE:0.929   Total Tries:764106   Below:1   Rate:1   Num:0.928901807731468"  Seen @7pm 9/29
# "B:-8.01081854850054   C:12.1789230778813   D:27.3284461023286   E:4.3468705532141   F:24.6175642311573"
# "SE:0.928   Total Tries:1278744   Below:43355   Rate:0.0842435182720315   Num:0.92755643535237" Seen @ 7am 9/30
# "B:19.6758358832449   C:0.124512033071369   D:4.27297461312264   E:11.5276464489289   F:16.7498763673939"
# "SE:0.921   Total Tries:7199741   Below:1   Rate:1   Num:0.920176113551661"  Seen @ 2pm 10/1
# "B:10.0532033666968   C:23.6118650366552   D:9.13625508081168   E:6.48440993577242   F:26.0457830736414"


print(i)
m = matrix(c(ind,age,relative_probability),ncol=3,byrow=F)
head(m, n=100)
print(sd(a))
print(b)
print(c)
print(d)
