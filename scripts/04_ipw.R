########################### 04_ipw.R###############################


library(tidyverse)
library(survey)
library(cobalt)

source("scripts/01_simulate_data.R")   


ps_mod <- glm(treatment ~ X1 + X2, family = binomial(), data = df)
df$pscore <- predict(ps_mod, type = "response")


df <- df %>%
  mutate(ipw = if_else(treatment == 1, 1/pscore, 1/(1 - pscore)))


bal_wt <- bal.tab(
  x       = treatment ~ X1 + X2,
  data    = df,
  weights = df$ipw,
  un      = TRUE
)
print(bal_wt)
love.plot(
  bal_wt,
  stats     = "mean.diffs",
  threshold = 0.1,
  title     = "Love Plot: IPW-Adjusted SMDs"
)


design <- svydesign(ids = ~1, weights = ~ipw, data = df)
ate_ipw <- svyglm(outcome ~ treatment, design = design)
summary(ate_ipw)


coef_est <- coef(ate_ipw)["treatment"]
ci       <- confint(ate_ipw)["treatment", ]
cat("IPW ATE estimate:", round(coef_est, 3), "\n")
cat("95% CI:", round(ci, 3), "\n")

ipw_results <- tibble(
  method    = "IPW",
  ate       = round(coef_est, 3),
  se        = round((ci[2] - ci[1]) / (2 * qnorm(0.975)), 3),
  ci_lower  = round(ci[1], 3),
  ci_upper  = round(ci[2], 3)
)

if (!dir.exists("results")) dir.create("results")


write_csv(ipw_results, "results/ipw_results.csv")
