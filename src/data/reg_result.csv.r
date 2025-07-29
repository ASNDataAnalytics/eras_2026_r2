# 01 Packages ----

require(jsonify)
require(readr)
require(dplyr)

# 02 Data ----

df <- jsonify::from_json('[
  {"Year":2014,"July":303,"Matched":306},
  {"Year":2015,"July":274,"Matched":254},
  {"Year":2016,"July":236,"Matched":276},
  {"Year":2017,"July":235,"Matched":284},
  {"Year":2018,"July":252,"Matched":285},
  {"Year":2019,"July":286,"Matched":291},
  {"Year":2020,"July":273,"Matched":291},
  {"Year":2021,"July":375,"Matched":345},
  {"Year":2022,"July":349,"Matched":335},
  {"Year":2023,"July":368,"Matched":359},
  {"Year":2024,"July":313,"Matched":321},
  {"Year":2025,"July":360,"Matched":362}
  ]')

# 03 Build Model ----

eras_model <-
  lm(Matched ~ July, data = df)

eras_model

eras_2026 <-
  data.frame(
    July = 340 # PLACEHOLDER VALUE ONLY!!! REPLACE WITH REAL JULY VALUE
  )

eras_prediction <-
  data.frame(
    July = 360,
    Matched = predict(eras_model, eras_2026) |> round(0)
  )

# 04 Send to stdout() ----

cat(
  format_csv(eras_prediction)
)
