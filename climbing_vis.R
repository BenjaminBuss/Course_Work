
# Benjamin Buss
# Started December 27th 2019
# Data obtainted from Kaggle
# Scraped in 2017/09/13


# Package Imports ---------------------------------------------------------

library(tidyverse) # The basis of anything good in R
library(lubridate)


# Data Imports ------------------------------------------------------------

ascent <- read.csv("~/Misc/8a.nu kaggle db/Dataset CSVs/ascent.csv")
grade <- read.csv("~/Misc/8a.nu kaggle db/Dataset CSVs/grade.csv")
method <- read.csv("~/Misc/8a.nu kaggle db/Dataset CSVs/method.csv")
user <- read.csv("~/Misc/8a.nu kaggle db/Dataset CSVs/user.csv")


# Initial Exploration -----------------------------------------------------

ascent_year_cleaned <- ascent %>% filter(year > 1985 & year < 2018)

sample_ascents <-ascent_year_cleaned # %>% sample_n(size = 100000)

# Yearly breakdown
activity_by_year <- count(sample_ascents, year)

year_plot <- ggplot(activity_by_year, aes(x = year, y = n)) + geom_area(fill = "deepskyblue1") +
    labs(x = "Year of Ascent", y = "Number of Ascents", title = "Ascents Per Year",
             caption = "Data Originally Obtained from 8a.nu on 2017/09/13")
year_plot

# Breakdown by send method
ascents_method <- left_join(sample_ascents, method, by = c("method_id" = "id"))

# activity_by_method <- count(ascents_method, shorthand)

method_list <- select(ascents_method, "shorthand")

method_plot <- ggplot(ascents_method, aes(shorthand)) + geom_bar() +
    labs(x = "Ascent Method", y = "Count", title = "Ascents Per Method",
         caption = "Data Originally Obtained from 8a.nu on 2017/09/13")

method_plot

# Breakdown by climb type(sport/boulder)

sport <- sample_ascents %>% filter(climb_type == 0)
sport_grade <- inner_join(sport, grade %>% select(id, fra_routes), by = c("grade_id" = "id"))

boulder <- sample_ascents %>% filter(climb_type == 1)
boulder_grade <- inner_join(boulder, grade %>% select(id, fra_boulders), by = c("grade_id" = "id"))

# Breakdown by grade
sport_grade_plot <- ggplot(sport_grade, aes(fra_routes)) + geom_bar() +
    labs(x = "Grade", y = "Count", title = "Ascents Per Sport Grade",
         caption = "Data Originally Obtained from 8a.nu on 2017/09/13")

sport_grade_plot

boulder_grade_plot <- ggplot(boulder_grade, aes(fra_boulders)) + geom_bar() +
    labs(x = "Grade", y = "Count", title = "Ascents Per Boulder Grade",
         caption = "Data Originally Obtained from 8a.nu on 2017/09/13")

boulder_grade_plot

# Illustrating Change in Popularity

#Chart w 3 lines, sport sends, boulder sends, total sends

act_year <- count(sample_ascents, year)
act_sport <- count(sport, year)
act_bould <- count(boulder, year)

act_overall <- bind_cols(act_year, act_sport, act_bould) %>%
    select(year,"overall" = n, "sport" = n1, "boulder" = n2)

rm(act_year, act_sport, act_bould)

overall_plot <- ggplot(act_overall, aes(x = year)) +
    geom_line(aes(y = overall), color = "black") +
    geom_line(aes(y = sport), color = "red") +
    geom_line(aes(y = boulder), color = "blue") +
    labs(x = "Year", y = "Count", title = "Ascents Per Method",
         caption = "Data Originally Obtained from 8a.nu on 2017/09/13")

overall_plot




# Breakdown by country
sample_ascents_filt <- sample_ascents %>% filter(country != "")
country <- count(sample_ascents_filt, country) 
country <- country %>% arrange(desc(n)) %>% slice(1:20)

sample_ascents_filt <- sample_ascents %>% filter(crag_id != 0)
crag_count <- count(sample_ascents_filt, crag_id) 
top_crag <- crag_count %>% arrange(desc(n)) %>% slice(1:20)

crag_join <- sample_ascents %>% distinct(crag_id, .keep_all = TRUE) %>% select(crag_id, crag, country)

top_crags <- left_join(top_crag, crag_join, by = "crag_id") %>% rename("Ascents" = n, "Crag" =  crag, "Country" = country)

sample_ascents_filt <- sample_ascents %>% filter(sector_id != 0)
sector_count <- count(sample_ascents_filt, sector_id) 
top_sector <- sector_count %>% arrange(desc(n)) %>% slice(1:20)

sector_join <- sample_ascents %>% distinct(sector_id, .keep_all = TRUE) %>% select(sector_id, sector, crag, country)

top_sectors <- left_join(top_sector, sector_join, by = "sector_id") %>% rename("Ascents" = n, "Sector" =  sector,
                                                                               "Country" = country, "Crag" = crag)

# Top Sport Crags

# Top Sport Sectors

# Top Bouldering Crags

# Top Bouldering Sectors



# Select Hardest Bouldering Grade per User
hardest_boulder <- boulder_grade %>% arrange(desc(grade_id, date)) %>% group_by(user_id) %>% slice(1) %>%
    select(id, user_id, grade_id, method_id, climb_type, date, year, rating, fra_boulders)

hardest_boulder_join <- inner_join(hardest_boulder, user %>% select(id, country, sex, height, weight, started, birth), by = c("user_id" = "id")) %>% ungroup() %>%
    mutate(send_date = as.Date.POSIXct(date), birthday = as.Date(hardest_boulder_join$birth)) %>% filter(sex == 0)
# Replace 0 height/weight w/ null
hardest_boulder_join$height[hardest_boulder_join$height == 0] <- NA
hardest_boulder_join$weight[hardest_boulder_join$weight == 0] <- NA

boulder_grades_means <- hardest_boulder_join %>% mutate(age = as.numeric(difftime(send_date, birthday, unit="weeks"))/52.25) %>% 
    group_by(grade_id) %>% mutate(avg_height = mean(height, na.rm = TRUE), avg_weight = mean(weight, na.rm = TRUE), avg_age = mean(age, na.rm = TRUE)) %>%
    slice(1) %>% select(grade_id, fra_boulders, avg_height, avg_weight, avg_age)
# group_by(grade_id) mutate(mean(height,weight, age, na.rm = TRUE))


# Select Hardest Sport Grade per User
hardest_sport <- sport_grade %>% arrange(desc(grade_id, date)) %>% group_by(user_id) %>% slice(1) %>%
    select(id, user_id, grade_id, method_id, climb_type, date, year, rating, fra_routes)

hardest_sport_join <- inner_join(hardest_sport, user %>% select(id, country, sex, height, weight, started, birth), by = c("user_id" = "id")) %>% ungroup() %>%
    mutate(send_date = as.Date.POSIXct(date), birthday = as.Date(hardest_sport_join$birth)) %>% filter(sex == 0)
# Replace 0 height/weight w/ null
hardest_sport_join$height[hardest_sport_join$height == 0] <- NA
hardest_sport_join$weight[hardest_sport_join$weight == 0] <- NA

sport_grades_means <- hardest_sport_join %>% mutate(age = as.numeric(difftime(send_date, birthday, unit="weeks"))/52.25) %>% 
    group_by(grade_id) %>% mutate(avg_height = mean(height, na.rm = TRUE), avg_weight = mean(weight, na.rm = TRUE), avg_age = mean(age, na.rm = TRUE)) %>%
    slice(1) %>% select(grade_id, fra_routes, avg_height, avg_weight, avg_age)



# country_plot <- ggplot(sample_ascents, aes(country)) + geom_bar() +
#     labs(x = "Country", y = "Count", title = "Ascents Per Country",
#          caption = "Data Originally Obtained from 8a.nu on 2017/09/13")
# 
# country_plot
#Method id

#Method id by year


