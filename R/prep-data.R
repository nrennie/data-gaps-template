library(tidyverse)

raw_data <- read_csv("_raw_data/sheet1.csv")

sources_data <- raw_data |>
  select(Name = `Data Source`) |>
  distinct() |>
  mutate(Icon = "")
write_csv(sources_data, "_raw_data/sources_data.csv", colnames = FALSE)
