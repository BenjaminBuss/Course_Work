
# Benjamin Buss
# STAT 4000 
# 2/11/2020
# In Class Notes


# --- SO FAR ---
# 1st assignment: Multiple Linear Regression
# 2nd assignmtnt: Theory of ^
# 3rd assignment: Theory and Practice of Logistic Regression
# 4rd Kernel Based Averages

# --- Looking Ahead ---
# Exam
# 1/3 programming
# 1/3 theory
# 1/3 data analytics


# Math Knowledge > Programming Skills
# Anyone can code
# Anyone can not do all the maths

# Theory -----------------

# What is principle of maximum likelyhood

#-Estimating the parameters of a statistical model to maximize the probability

# Least squares

#- minimizing the sum of squares of the resudials of euclidian distance

# Multiple Regression

#- 

# Multiple Logistic Regression

#- 

# Weighted Average

#- 

# How can they be used from Prediction

#- 

#Least squares only works when residual normal

#If binomial then weighted average

#If 


# R Skills --------------

# Matricies(transpose, invert, multiply, etc)

# for loops

# functions

# apply command



x = runif(100)
y = 2 + 1*x+runif(100, 0, 0.1)

M = matrix(c(rep(1,100),x), byrow=F, ncol = 2)

N = matrix(y, byrow = F, ncol = 1)

B = solve(t(M) %*% M) %*% (t(M) %*% N)

plot(x, y)
abline(2.03870, 1.01742)
































