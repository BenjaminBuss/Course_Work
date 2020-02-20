# Estimate average base salary
# higher for prof > associate > assistant
# ^ not 100% true tho
# 50k-80k for base salary
# Raises of 5k-10k per level
# Pick the ten profs that give you the best chance of guessing the data right
library(tidyverse)
library(readxl)
dataset <- read_excel("C:/Users/benja/Downloads/SamplingStudentViewUpdated.xlsx")

prof <- dataset %>% filter(Rank == "Professor")
assi <- dataset %>% filter(Rank == "Assistant Professor")
asso <- dataset %>% filter(Rank == "Associate Professor")
prof_sam <- sample(prof$Name, 5, replace = FALSE)
assi_sam <- sample(assi$Name, 2, replace = FALSE)
asso_sam <- sample(asso$Name, 3, replace = FALSE)

summary(dataset$`Years since PhD`)
summary(prof$`Years since PhD`)
summary(assi$`Years since PhD`)
summary(asso$`Years since PhD`)
#If high years since phd and not prof think

# Final Picks ---------------
# David Fearnley   $
# Yingxian         $
# Ya Li            $
# Jun Ling         $
# Christine Walker $
# Alan Parry       $
# Mohammad Islam   $
# Erik Heiny       $
# Reinhard Franze  $
# Don Faurot       $
# summary(dataset$Salary, na.rm = TRUE)

# Create fake Years since PhD by randomly generating based off of the the range of each?
prof_mean <- mean(prof$`Years since PhD`, na.rm = TRUE)
assi_mean <- mean(assi$`Years since PhD`, na.rm = TRUE)
asso_mean <- mean(asso$`Years since PhD`, na.rm = TRUE)
prof_sd <- sd(prof$`Years since PhD`, na.rm = TRUE)
assi_sd <- sd(assi$`Years since PhD`, na.rm = TRUE)
asso_sd <- sd(asso$`Years since PhD`, na.rm = TRUE)
# Fill in the blank "Years since PhD", which I didn't end up using.
# data_na <- dataset %>% filter(is.na(`Years since PhD`))
# prof_na <- data_na %>% filter(Rank == "Professor") %>% `Years since PhD` = rnorm(1, mean = prof_mean, sd = prof_sd)
# assi_na <- data_na %>% filter(Rank == "Assistant Professor") %>% `Years since PhD` = rnorm(1, mean = assi_mean, sd = assi_sd)
# asso_na <- data_na %>% filter(Rank == "Associate Professor") %>% `Years since PhD` = rnorm(1, mean = asso_mean, sd = asso_sd)

dataset_final <- dataset %>% filter(!is.na(Salary)) %>% mutate(Probability = 1/`Years since PhD`)# %>% mutate(Salary_new = )
mean(dataset_final$Salary)     # 73000
sd(dataset_final$Salary)       # 8353.309
mean(dataset_final$Salary_new) # 72138.6
sd(dataset_final$Salary_new)   # 3942.848
# Reduce variation by weighing the salary of different Ranks,
# Keeps mean similar and significaly reduced variation
# assistant * something to make it bigger  ~ 1.16
# associate * something to make it bigger  ~ 1.10601
# professor * something to make it smaller ~ 0.874
# ^ ends up being the "Salary_new" column in excel sheet.

# Standard Error ----------------------------------------------------------

# Page 84 "Bound on the error of estimation"
eoe = 2 * sqrt((sd(dataset_final$Salary)/2)*((23-10)/23))  # Estimated variance of y-bar                           # 97.17
evar = (sd(dataset_final$Salary)/2)*((23-10)/23)           # Estimated variance of y-bar                           # 2360.72

eoen = 2 * sqrt((sd(dataset_final$Salary_new)/2)*((23-10)/23))  # Estimated variance of y-bar with adjusted salary # 66.76
evarn = (sd(dataset_final$Salary_new)/2)*((23-10)/23)           # Estimated variance of y-bar with adjusted salary # 114.28

se = sd(dataset_final$Salary)/sqrt(10) # Standard Error of unadjusted salary                                       # 2641.55
sen = sd(dataset_final$Salary_new)/sqrt(10)  # Standard Error of adjusted salary                                   # 1246.84
