# scripts/05_drtmle_dr.R



library(drtmle)
library(SuperLearner)
library(cobalt)
library(tidyverse)


source("scripts/01_simulate_data.R")   # defines `df`


Y <- df$outcome
A <- df$treatment
W <- df %>% select(X1, X2)


dr_fit <- drtmle(
  Y        = Y,
  A        = A,
  W        = W,
  a_0      = c(1, 0),         # marginal means at A=1 and A=0
  family   = gaussian(),      # continuous outcome
  SL_Q     = c("SL.glm"),     # outcome regressions
  SL_g     = c("SL.glm"),     # propensity scores
  SL_Qr    = c("SL.glm"),     # reduced-dimension outcome
  SL_gr    = c("SL.glm"),     # reduced-dimension propensity
  stratify = FALSE
)

cat("\n--- dr_fit$drtmle structure ---\n")
str(dr_fit$drtmle)


est_vec <- dr_fit$drtmle$est    
cov_mat <- dr_fit$drtmle$cov   


names(est_vec) <- c("E[Y|A=1]", "E[Y|A=0]")


cat("\nMarginal means:\n")
print(est_vec)


# Var(ATE) = Var(ψ1) + Var(ψ0) - 2 * Cov(ψ1, ψ0)
var1   <- cov_mat[1, 1]
var0   <- cov_mat[2, 2]
cov01  <- cov_mat[1, 2]
se_ate <- sqrt(var1 + var0 - 2 * cov01)
ate     <- est_vec["E[Y|A=1]"] - est_vec["E[Y|A=0]"]


ci_lower <- ate + qnorm(0.025) * se_ate
ci_upper <- ate + qnorm(0.975) * se_ate


cat("\nATE (E[Y|1] - E[Y|0]):", round(ate, 3), "\n")
cat("95% CI: [", round(ci_lower, 3), ", ", round(ci_upper, 3), "]\n")


if (!dir.exists("results")) dir.create("results")

write_csv(drtmle_results, "results/drtmle_results.csv")
