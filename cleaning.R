library('tidyverse')
library('janitor')
library('lubridate')

fy2019 <- read_csv('input/FY19 Salary and OT Data.csv') %>% 
  clean_names() %>% mutate(date = mdy(check_date)) 

# convert overtime amount paid to numeric
fy2019$amount <- str_replace(
  fy2019$gl_pay_amount, # column we want to search
  pattern = '\\$', # what to find
  replacement = '' # what to replace it with
)

fy2019$amount <- as.numeric(str_replace(
  fy2019$amount, # column we want to search
  pattern = ',', # what to find
  replacement = '' # what to replace it with
))

# names - since some names (e.g., married names change over the course of the fiscal year)
overtime.names.2019 <- fy2019 %>% 
  arrange(desc(date)) %>% 
  distinct(emplid, name) %>% 
  group_by(emplid) %>% 
  mutate(n = row_number()) %>% 
  filter(n == 1) %>% select(-n)

fy2019 <- fy2019 %>% merge(overtime.names.2019 %>% select(emplid, name.standardized = name), by = 'emplid', all = T)

write_csv(fy2019, 'output/overtime_fy2019.csv')

# fy 2018
fy2018 <- read_csv('input/FY 2018 - All GF Overtime after 26 Pay Periods.csv') %>% 
  clean_names() %>% mutate(date = mdy(check_date)) 

# convert overtime amount paid to numeric
fy2018$amount <- str_replace(
  fy2018$gl_pay_amount, # column we want to search
  pattern = '\\$', # what to find
  replacement = '' # what to replace it with
)

fy2018$amount <- as.numeric(str_replace(
  fy2018$amount, # column we want to search
  pattern = ',', # what to find
  replacement = '' # what to replace it with
))

# names
overtime.names.2018 <- fy2018 %>% 
  arrange(desc(date)) %>% 
  distinct(emplid, name) %>% 
  group_by(emplid) %>% 
  mutate(n = row_number()) %>% 
  filter(n == 1) %>% select(-n)

fy2018 <- fy2018 %>% merge(overtime.names.2018 %>% select(emplid, name.standardized = name), by = 'emplid', all = T)

write_csv(fy2018, 'output/overtime_fy2018.csv')

