# 01 Packages ----

require(readr)
require(dplyr)
require(lubridate)
require(stringr)
require(readxl)

# 02 Data ----

df_total <-
  read_excel(
    "src/data/00_eras.xlsx",
    sheet = "00_Monthly",
    na = "UK"
  )

# 03 Clean ----

df_total <- 
  df_total |> 
  mutate(
    month = lubridate::month(month_year),
    month_name = lubridate::month(
      month_year, 
      label = TRUE, 
      abbr = FALSE
    )
  ) |>
  filter(
    between(month, left = 7, right = 11)
  ) |>
  mutate(
    ERAS = as.numeric(ERAS)
  )

# 04 Create Summarized Dataset ----

cur_mon <-
  df_total |>
    slice(
      df_total |> (\(.) nrow(.))()
    ) |>
    pull(month_year) |>
    lubridate::month()

cur_mon_lab <- 
  lubridate::month(
    cur_mon,
    label = TRUE,
    abbr = FALSE
  )

cum_apps_year <- 
  df_total |>
  group_by(ERAS) |>
  mutate(
    tots_applications = cumsum(num_application)
  ) |>
  ungroup() |>
  mutate(
    color = if_else(ERAS == max(ERAS), "#0077c8", "#cccccc")
  ) |>
  mutate(month_label = lubridate::month(month_year, label = TRUE)) |> 
  select(month, month_label, tots_applications, ERAS, color)

# 05 Push to stdout ----

cat(
  format_csv(cum_apps_year)
)
