library(lubridate)
library(magrittr)
library(tidyverse)

stack_files <- function(path){
  # 1. read all files in path and row bind them
  files <- list.files(path=path, pattern="*.txt", full.names=TRUE)
  full_df <- read.csv(files[1])
  for (i in 2:length(files)){
    temp_df <- read.csv(files[i])
    full_df <- bind_rows(full_df, temp_df)
  }
  return(full_df)
}

clean_df <- function(full_df, pass_scores, rotation){
  # 1. mutate & select student_id, date, score, & fail
  full_df %<>%
    mutate(student_id=ID, date=mdy(Test.Date.s.), score=Total.Test.Equated.Percent.Correct.Score, fail=NA) %>%
    select(student_id, date, score, fail) %>%
    arrange(student_id, date)
  # 2. within each academic year's date range, mutate fail, given pass_scores dictionary
  min_ay <- interval(ymd("2017-08-16"), min(full_df$date)) %/% years(1)
  max_ay <- interval(ymd("2017-08-16"), max(full_df$date)) %/% years(1)
  for (i in min_ay:max_ay){
    full_df[full_df$date>=(ymd("2017-08-16")+years(i)) & full_df$date<=(ymd("2018-08-15")+years(i)), ] %<>%
      mutate(fail=ifelse(score<as.numeric(pass_scores[paste(2017+i, 2018+i, sep="-")]), 1, 0))
  }
  # 3. group by student_id and filter 1st attempt rows only, add prefix to date, score, & fail
  full_df %<>%
    group_by(student_id) %>%
    mutate(attempt=row_number()) %>%
    ungroup() %>%
    filter(attempt==1) %>%
    select(-attempt) %>%
    rename_with(~paste(rotation, .x, sep="_"), -student_id)
  return(full_df)
}

wh_pass_scores <- c("2017-2018"=58, "2018-2019"=63, "2019-2020"=64, "2020-2021"=64, "2021-2022"=64, "2022-2023"=64)
wh_df <- stack_files(path="../data/wh") %>% clean_df(pass_scores=wh_pass_scores, rotation="wh")

peds_pass_scores <- c("2017-2018"=59, "2018-2019"=59, "2019-2020"=59, "2020-2021"=59, "2021-2022"=59, "2022-2023"=59)
peds_df <- stack_files(path="../data/peds") %>% clean_df(pass_scores=peds_pass_scores, rotation="peds")

rotation_df <- full_join(wh_df, peds_df, by="student_id")