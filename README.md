# R-CausalKit

Causal Inference & Experimental Design in R

---

## 📖 Overview

R-CausalKit applies modern causal inference techniques in R to estimate treatment effects in both observational and experimental settings. The project demonstrates:

- Data simulation for A/B testing scenarios
- Naïve Average Treatment Effect (ATE) estimation
- Propensity Score Matching (PSM) with `MatchIt`
- Inverse Probability Weighting (IPW) using `survey`
- Doubly Robust estimation via TMLE with `drtmle`
- Visual diagnostics: covariate balance plots & love plots
- Reproducible environment management via `renv`

---

## 🚀 Quick Start

### Prerequisites

- R (≥ 4.5.0)
- RStudio (recommended)
- Git

### Clone the Repository

```bash
git clone https://github.com/yourusername/r-causalkit.git
cd r-causalkit
```

### Install Dependencies

```r
install.packages("renv")
renv::restore()
```

---

## 🗂️ Project Structure

```
r-causalkit/
├── scripts/
│   ├── 01_simulate_data.R
│   ├── 02_eda_balance.R
│   ├── 03_matchit_psm.R
│   ├── 04_ipw.R
│   ├── 05_drtmle_dr.R
│   └── 05_drtmle_dr_fn.R
├── notebooks/
│   └── causal_analysis.Rmd
├── results/
│   ├── causal_analysis.html
│   ├── ipw_results.csv
│   ├── drtmle_results.csv
│   └── loveplot_pre_post.png
├── renv.lock
└── README.md
```

---

## 🛠️ Usage

1. **Simulate Data**  
   ```r
   source("scripts/01_simulate_data.R")
   ```

2. **Exploratory Data Analysis**  
   ```r
   source("scripts/02_eda_balance.R")
   ```

3. **Propensity Score Matching**  
   ```r
   source("scripts/03_matchit_psm.R")
   ```

4. **Inverse Probability Weighting**  
   ```r
   source("scripts/04_ipw.R")
   ```

5. **Doubly Robust TMLE**  
   ```r
   source("scripts/05_drtmle_dr.R")
   ```

6. **Render the Final Report**  
   ```bash
   Rscript -e "rmarkdown::render('notebooks/causal_analysis.Rmd')"
   ```

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request to propose enhancements or bug fixes.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
