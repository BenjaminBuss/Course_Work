
# Benjamin Buss
# Started Feb 4th 2020
# Conglomerate Agent Stats Script


# Important Packages ----------------------------------------------------------------
library(plyr)
library(tidyverse)
library(DBI)
library(RMySQL)
library(xlsx)
library(mailR)
library(rJava)
library(lubridate)
library(scales)

# Import Data -------------------------------------------------------------

con = dbConnect(MySQL(), user = 'benjaminremote', password = 'pronexisbebu', 
                dbname='devcallcenter', host = '54.157.28.212', port = 3306)

call_log.db = dbSendQuery(con, "SELECT `datestamp`,`broadsoft_user`,`callcenter`, `disposition`,`call_id`, `released`, `origin` 
                            FROM `call_log` WHERE DATE(`datestamp`) >= (CURDATE() - INTERVAL 1 DAY) AND DATE(`datestamp`) < CURDATE() 
                            AND `callcenter` <> 'AdvantaCC' AND `callcenter` <> ''")
call_log = fetch(call_log.db, n = -1)
dbClearResult(call_log.db)

brand.db = dbSendQuery(con, "SELECT `brand_id`,`brand_name`,`callcenter` FROM `brands` WHERE 1")
brand = fetch(brand.db, n=-1)
dbClearResult(brand.db)

users.db = dbSendQuery(con, "SELECT `user_id`, `username`, `broadsoft_user` FROM `users` WHERE user_type = 'call center' AND company_admin <> 44 AND 
                       `archived` = 0 AND `user_id` <> 4162 AND `user_id` <> 2795")
users = fetch(users.db, n = -1)
dbClearResult(users.db)

call_dispo.db = dbSendQuery(con, "SELECT disposition, disposition_id FROM `call_dispositions` WHERE 1")
call_disposition = fetch(call_dispo.db, n = -1)
dbClearResult(call_dispo.db)

broadsoft_log.db = dbSendQuery(con, "SELECT log_id, user_id, status, datestamp FROM `broadsoft_log` WHERE DATE(`datestamp`) >= (CURDATE() - INTERVAL 1 DAY)")
broadsoft_log = fetch(broadsoft_log.db, n = -1)
dbClearResult(broadsoft_log.db)

dbDisconnect(con)

rm(con, brand.db, call_log.db, users.db, call_dispo.db)

detach("package:RMySQL", unload = TRUE)
detach("package:DBI", unload = TRUE)

# Base Cleaning and Prep --------------------------------------------------
call_log$origin[call_log$origin %in% c('in')] <- 'inbound'
call_log$origin[call_log$origin %in% c('out')] <- 'outbound'

call_log_joined <- inner_join(call_log, users %>% select(broadsoft_user, username), by = "broadsoft_user")
call_log_joined <- left_join(call_log_joined, brand %>% select(callcenter, brand_name), by = "callcenter")
call_log_joined <- call_log_joined %>% mutate(call_length = as.numeric(difftime(ymd_hms(released), ymd_hms(datestamp), units = c("secs"))))

# Agent_Conversion --------------------------------------------------------
agent_dispo <- call_log_joined %>% group_by(username) %>% count(disposition) %>% ungroup() %>% arrange(desc(disposition), desc(n)) %>% 
    group_by(disposition) %>% slice(1:3)
agent_dispo <- left_join(agent_dispo, call_disposition, by = c("disposition" = "disposition_id"))
agent_dispo <- agent_dispo %>% transmute("Agent" = username, "Calls" = n, "Disposition" = disposition.y)

# Per Brand Conversion ----------------------------------------------------
brand_dispo <- call_log_joined %>% group_by(brand_name, username) %>% count(disposition) %>% ungroup() %>% filter(disposition == 1 | disposition == 3) %>%
    group_by(brand_name, disposition) %>% arrange(desc(n)) %>% slice(1:3) %>% ungroup() %>% spread(key = disposition, value = n, fill = 0)
agent_brand <- call_log_joined %>% group_by(brand_name) %>% count(username) %>% ungroup()
brand_dispo <- inner_join(brand_dispo, agent_brand, by = c("brand_name", "username"))
brand_dispo <- brand_dispo %>% rename(Brand = brand_name, Agent = username, Converted = '1', NotConverted = '3', Total = n) %>% mutate(Conversion = percent((Converted / (Converted + NotConverted)), accuracy = 0.001), Overall_Conversion = percent(Converted / Total, accuracy = 0.001))

# Per Brand Per Agent AHT -------------------------------------------------
brand_aht <- call_log_joined %>% group_by(brand_name, username) %>% summarise(avg = mean(call_length, na.rm = TRUE)) %>% 
    spread(key = username, value = avg, fill = 0) %>% ungroup()

# Agent Gaming ------------------------------------------------------------
agent_aht <- call_log_joined %>% group_by(username) %>% summarise(avg = mean(call_length, na.rm = TRUE)) %>% ungroup()
agent_calls <- call_log_joined %>% group_by(username) %>% count() %>% ungroup()
aht_agent <- inner_join(agent_aht, agent_calls, by = "username")
aht_agent <- aht_agent %>% mutate(Metric = avg/n) %>% rename(Agent = username, AHT = avg, Calls = n)

# Agent Calls -------------------------------------------------------------
agent_broken <- call_log_joined %>% group_by(username, origin) %>% count() %>% ungroup() %>% spread(origin, n, fill = 0) %>% mutate(total = inbound + outbound)


# Agent Availability
bsofty_log <- broadsoft_log %>% arrange(user_id, datestamp)
bsofty_log <- bsofty_log %>% filter(user_id %in% array(users$user_id)) #& status != "Login" & status != "login")

test <- which(bsofty_log$status == "Available")
test2 <- test + 1

test3 <- bsofty_log[test,]
test3 <- test3 %>% rowid_to_column("id")
test4 <- bsofty_log[test2,]

test5 <- bind_rows(test3, test4)

test6 <- test5 %>% arrange(user_id, datestamp) %>% distinct(log_id, .keep_all = T) %>% 
    fill(id) %>% group_by(id) %>% spread(status, datestamp, fill = "") %>% unite(5:10, col = "Other", sep = "") %>% ungroup() %>% 
    group_by(id, user_id) %>% summarise_all(~(paste(., collapse = ""))) %>% filter(Other != "")

test6$Available <- ymd_hms(test6$Available)
test6$Other <- ymd_hms(test6$Other)

test7 <- test6 %>% mutate(x = difftime(Other, Available, units = "secs")) %>% group_by(user_id) %>% 
    summarise(minimun = min(x, na.rm = T), average = round(mean(x, na.rm = T), digits = 2), 
              maximum = max(x, na.rm = T), total_calls = n(), total_time_in_minutes = sum(x, na.rm = T)/60)
test7 <- inner_join(users %>% select(user_id, username), test7, by = "user_id")


# Write it out ------------------------------------------------------------
da <- as.character(as.Date(Sys.time() - days(1)))

setwd("C:/Users/benja/Documents/R_Projects/acs_optimization/results")
write.xlsx(as.data.frame(agent_dispo), file = "Daily_Agent_Reports.xlsx", sheetName = "Agent_Dispositions", row.names = FALSE)
write.xlsx(as.data.frame(brand_dispo), file = "Daily_Agent_Reports.xlsx", sheetName = "Agent_Conversion",   row.names = FALSE, append = T)
write.xlsx(as.data.frame(brand_aht),   file = "Daily_Agent_Reports.xlsx", sheetName = "Per_Brand_AHT",      row.names = FALSE, append = T)
write.xlsx(as.data.frame(aht_agent),   file = "Daily_Agent_Reports.xlsx", sheetName = "AHT-Calls",          row.names = FALSE, append = T)
write.xlsx(as.data.frame(test7),       file = "Daily_Agent_Reports.xlsx", sheetName = "Agent_Availability", row.names = FALSE, append = T)
write.xlsx(as.data.frame(agent_broken),file = "Daily_Agent_Reports.xlsx", sheetName = "Calls_Per_Agent",    row.names = FALSE, append = T)

recipients <- c("benjaminb@pronexis.com", "rpetrulsky@pronexis.com", "rhardy@pronexis.com", "supervisors@pronexis.com")

bode <- paste0("Hey all,

Attached below are the Daily Agent Reports for ", da, ". Let me know if you have any questions or additional requests.

Thanks,
Benjamin Buss")

send.mail(from = "automatedreports@pronexis.com",
          to = recipients,
          subject = "Daily Agent Reports",
          body = bode,
          smtp = list(host.name = "smtp.gmail.com", port = 465 , user.name = "automatedreports@pronexis.com", passwd = "pronexis99", ssl = TRUE),
          attach.files = c("C:/Users/benja/Documents/R_Projects/acs_optimization/results/Daily_Agent_Reports.xlsx"),
          authenticate = TRUE,
          send = TRUE)

