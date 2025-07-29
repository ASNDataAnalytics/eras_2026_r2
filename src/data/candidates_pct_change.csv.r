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


# 04 Calculate Pct Change ----

pct_chg <- function(x) {
  y <- dplyr::lag(x)
  z <- (function(x) replace(x, is.na(x), 0))(((x - y)/y))
  z
}

candidates_pct_change <-
  df_total |>
  ## NB: There was no July Data Reported for ERAS 2021
  filter(month <= cur_mon) |>
  group_by(ERAS) |>
    summarize(
      across(
        where(is.numeric), 
        \(x) sum(x, na.rm = FALSE)
    )
  ) |>
  ungroup() |>
  mutate(
    pct_c = pct_chg(num_candidate) |> round(digits = 2) * 100,
    pct_c_text = pct_chg(num_candidate) |> scales::percent(accuracy = .1),
    color = if_else(ERAS == max(ERAS), "#0077c8", "#cccccc")
  )
# 05 Push to stdout ----

cat(
  format_csv(candidates_pct_change)
)
