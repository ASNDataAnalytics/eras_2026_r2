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

app_year_cur_month <- 
  df_total |>
  ## NB: There was no July Data Reported for ERAS 2021
    filter(month <= cur_mon) |>
    group_by(ERAS) |>
    reframe(
      across(where(is.numeric), \(x) sum(x, na.rm = FALSE))
    ) |>
    ungroup() |>
    mutate(
      fill = if_else(ERAS == max(ERAS), "#0077c8", "#cccccc")
    )

# 05 Push to stdout ----

cat(
  format_csv(app_year_cur_month)
)
