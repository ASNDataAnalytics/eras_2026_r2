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

# 04 Push to stdout ----

cat(
  format_csv(df_total)
)


# df_total |> 
#   write_csv(stdout())

# iris |> 
#   write_csv(stdout())

# cat(
#   format_csv(iris)
# )
