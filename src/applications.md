---
theme: midnight
title: Nephrology Applications
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

.observablehq {
  font-family: 'Roboto', sans-serif;
  font-size: 3em;
}

svg {
  font-family: 'Roboto', sans-serif;
  font-size: 14px;
}

</style>

<!-- 01 Data -->

```js
const eras_edu = FileAttachment("./data/eras_edu.csv").csv({ typed: true });
const eras_total = FileAttachment("./data/eras_total.csv").csv({ typed: true });
const app_year_cur_month = FileAttachment("./data/app_year_cur_month.csv").csv({ typed: true});  
const avg_apps = FileAttachment("./data/avg_apps_edu.csv").csv({ typed: true});
const app_pct_change = FileAttachment("./data/app_pct_change.csv").csv({ typed: true });
const cum_apps_year = FileAttachment("./data/cum_apps_year.csv").csv({ typed: true });
const monthly_totals = FileAttachment("./data/monthly_totals.csv").csv({ typed: true });
```

<!-- 01.01 Current ERAS Year and Application Month -->

```js
const current_month = eras_edu[eras_edu.length -1].month_name
const eras_year = eras_edu[eras_edu.length -1].ERAS
const calendar_year = eras_edu[eras_edu.length -1].ERAS - 1
```

###### ERAS 2026—Nephrology Applications

<!-- 02 Cards Showing Top-Line Application Numbers -->

<div class="grid grid-cols-4">
  <div class="card">
    <h2>Data Through</h2>
    <span class="big">${current_month}, ${calendar_year}
    </span>
  </div>
  <div class="card">
    <h2>IMG Applications</h2>
    <span class="big">${monthly_totals
      .filter((d) => d.edu_status === "IMG")
      .map((d) => d.tots_application).toLocaleString("en-US")}</span>
  </div>
  <div class="card">
    <h2>US MD Applications</h2>
    <span class="big">${monthly_totals
      .filter((d) => d.edu_status === "US MD")
      .map((d) => d.tots_application).toLocaleString("en-US")}</span>
  </div>
  <div class="card">
    <h2>Osteopathic Applications</h2>
    <span class="big">${monthly_totals
      .filter((d) => d.edu_status === "US DO")
      .map((d) => d.tots_application).toLocaleString("en-US")}</span>
  </div>
</div>

---

<!-- 03 Visualizations Row 1 -->

<div class="grid grid-cols-2">
  <div class="card">
  <h2><b>Cumulative Applications Through ${
      eras_total[eras_total.length - 1]["month_name"]
      }</b>
  </h2>
  ${
    resize((width) => Plot.plot({
      width,
      marginBottom: 50,
      marginLeft: 60,
      caption: "Source: ERAS",
       x: { tickFormat: "", label: "ERAS", labelOffset: 35 },
       y: {label: "Applications"},
       marginTop: 30,
      marks: [
        Plot.ruleY([0]),
        Plot.barY(app_year_cur_month, {
          x: "ERAS", 
          y: "num_application",
          tip: true,
          fill: "fill", 
          insetLeft: 10, 
          insetRight: 10,
          title: (d) => `ERAS: ${d.ERAS}\nApplications: ${d.num_application.toLocaleString("en-US")}`
          })
        ]
      })
    )
  }
</div>

  <div class="card">
  <h2>
    <b>Mean Applications/Candidate by Medical School Through ${
      eras_total[eras_total.length - 1]["month_name"]
      }
    </b>
  </h2>
  ${
    resize((width) => Plot.plot({
      width,
      x: {label: "Mean Applications"},
      y: {label: " "},
      marginBottom: 50,
      marginTop: 150,
      marginLeft: 60,
      caption: "Source: ERAS",
      marks: [
        Plot.barX(
          avg_apps,
          {
            x: "avg_apps_edu_status",
            y: "edu_status",
            fill: "color",
            tip: true,
            title: (d) => `${d.edu_status}: ${d.avg_apps_edu_status}`,
            insetTop: 5,
            insetBottom: 5
          }
        ),
        Plot.ruleX([0])  
      ]
      })
    )
  }

</div>
</div>

---

<!-- 04 Visualizations Row 2 -->

<div class="grid grid-cols-2">
  <div class="card">
  <h2>
    <b>
    Percent Change YOY Through ${
      eras_total[eras_total.length - 1]["month_name"]
      }
    </b>
  </h2>
  ${
    resize((width) => Plot.plot({
      width,
      x: { tickFormat: "", label: "ERAS", labelOffset: 35 },
      y: { label: "%", labelOffset: 35 },
      caption: "Source: ERAS",
      marks: [
        Plot.ruleY([0]),
        Plot.barY(app_pct_change, {
          x: "ERAS", 
          y: "pct_c",
          tip: true,
          fill: "color", 
          insetLeft: 10, 
          insetRight: 10,
          title: (d) => `ERAS: ${d.ERAS}\nChange: ${d.pct_c_text}`
        })
      ],
      marginBottom: 60
    })
  )
}

</div>

  <div class="card">
  <h2>
    <b>
    Cumulative Applications by ERAS Year  
    </b>
  </h2>
  ${
    resize((width) => Plot.plot({
      width,
      marginTop: 40,
      x: { tickFormat: "", label: "Month", labelOffset: 35, domain: [7, 8, 9, 10, 11]},
      y: {label: "Applications", domain: [4000, 14000]},
      caption: "Source: ERAS",
      marks: [
        Plot.ruleY([0]),
        Plot.lineY(cum_apps_year, {
          x: "month", 
          y: "tots_applications",
          tip: true,
          title: (d) => `ERAS: ${d.ERAS}\nMonth: ${d.month_label}\nApplications: ${d.tots_applications.toLocaleString("en-US")}`,
          stroke: "color", 
          insetLeft: 10, 
          insetRight: 10
        })
      ]
    })
  )
}

</div>
</div>

