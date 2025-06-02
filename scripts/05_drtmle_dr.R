# scripts/05_drtmle_dr.R
# Purpose: estimate ATE via doubly-robust TMLE, inspect result, and compute CI

# 1) load libraries
library(drtmle)
library(SuperLearner)
library(cobalt)
library(tidyverse)

# 2) recreate the simulated data
source("scripts/01_simulate_data.R")   # defines `df`

# 3) prepare variables
Y <- df$outcome
A <- df$treatment
W <- df %>% select(X1, X2)

# 4) fit DRTMLE
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

# 5) inspect the drtmle sub-object
cat("\n--- dr_fit$drtmle structure ---\n")
str(dr_fit$drtmle)

# 6) extract marginal-mean estimates and covariance matrix
est_vec <- dr_fit$drtmle$est    # vector length 2: E[Y|A=1], E[Y|A=0]
cov_mat <- dr_fit$drtmle$cov    # 2×2 covariance matrix

# 7) name the estimates
names(est_vec) <- c("E[Y|A=1]", "E[Y|A=0]")

# 8) print marginal means
cat("\nMarginal means:\n")
print(est_vec)

# 9) compute ATE and its standard error
# Var(ATE) = Var(ψ1) + Var(ψ0) - 2 * Cov(ψ1, ψ0)
var1   <- cov_mat[1, 1]
var0   <- cov_mat[2, 2]
cov01  <- cov_mat[1, 2]
se_ate <- sqrt(var1 + var0 - 2 * cov01)
ate     <- est_vec["E[Y|A=1]"] - est_vec["E[Y|A=0]"]

# 10) compute 95% CI
ci_lower <- ate + qnorm(0.025) * se_ate
ci_upper <- ate + qnorm(0.975) * se_ate

# 11) display ATE
cat("\nATE (E[Y|1] - E[Y|0]):", round(ate, 3), "\n")
cat("95% CI: [", round(ci_lower, 3), ", ", round(ci_upper, 3), "]\n")
