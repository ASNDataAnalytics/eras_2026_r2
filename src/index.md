---
toc: false
theme: midnight
---

<!-- 00 Styling -->

<style>

@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

body {
  font-family: 'Roboto', sans-serif;
}

.observablehq-link-active > a:nth-child(1) {
  color: #0077c8;
}

#observablehq-header {
  background-color: #00468b;
  border-radius: 4px;
}

svg {
  font-family: 'Roboto', sans-serif;
  font-size: 14px;
}

p {
  font-family: 'Roboto', sans-serif;
  font-size: 16px;
}

</style>

<!-- 01 Data -->

```js
const july_regression = [
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
  ];

const cum_apps_year = FileAttachment("src/data/cum_apps_year.csv").csv({ typed: true });
const reg_result = FileAttachment("src/data/reg_result.csv").csv({ typed: true });
```

# ERAS 2026 Nephrology Fellowship Applications

<br>

<!-- 02 Viz -->

<div class="grid grid-cols-2">

  <div class="card">
    <p>Electronic Residency Application System (ERAS) data on the appointment year (AY) 2026 nephrology Match indicate:</p>
      <ul>
        <li style = 'padding: 10px; font-size: 16px;'>Nephrology candidates were [up/down] XX% compared with the ERAS 2025 application cycle. Applications were [flat/up/down] year over year, with average applications per candidate [dropping/rising] to XX.X.</li>
        <li style = 'padding: 10px; font-size: 16px;'>International medical graduate candidates (IMGs) were up [up/down] XX%.</li>
        <li style = 'padding: 10px; font-size: 16px;'>Allopathic candidates were up 14% and osteopathic candidates [up/down] XX%.</li>
        <li style = 'padding: 10px; font-size: 16px;'>A simple least squares model predicts with a total of XXX candidates in July a potential for ~XXX matched nephrology fellows for AY 2026.</li>
    </ul>

  </div>

  <div class="card">    
  ${
    resize((width) => Plot.plot({
      title: "Predicted Nephrology Match Outcome for AY 2026",
      width,
      grid: true,
      x: {label: "July Nephrology Candidates"},
      y: {label: "Matched Nephrology Fellows"},
      color: {legend: true},
      marginBottom: 50,
      caption: "Sources: NRMP and ERAS",
      marginLeft: 60,
      marks: [
        Plot.linearRegressionY(
          july_regression,
          {x: "July", y: "Matched", stroke: '#ff8200'}
        ),
        Plot.dot(
          july_regression,
          {
            x: "July", 
            y: "Matched", 
            tip: true, 
            lineHeight: 1.5, 
            title: (d) => `ERAS: ${d.Year}\nJuly Candidates: ${d.July}\nMatched: ${d.Matched}`
          }
        ),
        Plot.dot(
          [{"Year": 2026, "July": 360, "Matched": 333}], 
          {
            x: "July",
            y: "Matched",
            r: 8,
            fill: "#00468b",
            tip: true,
            title: (d) => `ERAS: ${d.Year}\nJuly Candidates: ${d.July}\nPREDICTED MATCHES: ${d.Matched.toLocaleString("en-US")}`
          })
        ]
      })
    )
  }


  </div>


</div>

---



