# 05_drtmle_dr_fn.R
# Purpose: wrap the DRTMLE steps in a function that returns all key results

library(drtmle)
library(SuperLearner)
library(cobalt)
library(tidyverse)

run_drtmle <- function(df) {
  # df must have columns: X1, X2, treatment, outcome
  
  # 1) Prepare inputs
  Y <- df$outcome
  A <- df$treatment
  W <- df %>% select(X1, X2)
  
  # 2) Fit DRTMLE
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
  
  # 3) Extract marginals and covariance matrix
  est_vec <- dr_fit$drtmle$est    # length=2: E[Y|A=1], E[Y|A=0]
  cov_mat <- dr_fit$drtmle$cov    # 2×2 covariance
  
  # 4) Compute ATE and its SE
  ate   <- est_vec[1] - est_vec[2]
  var1  <- cov_mat[1, 1]
  var0  <- cov_mat[2, 2]
  cov01 <- cov_mat[1, 2]
  se_ate <- sqrt(var1 + var0 - 2 * cov01)
  
  # 5) Compute 95% CI
  ci_lower <- ate + qnorm(0.025) * se_ate
  ci_upper <- ate + qnorm(0.975) * se_ate
  
  # 6) Return everything as a named list
  return(list(
    dr_fit    = dr_fit,
    psi       = set_names(est_vec, c("E[Y|A=1]", "E[Y|A=0]")),
    covariance= cov_mat,
    ate       = ate,
    se_ate    = se_ate,
    ci_lower  = ci_lower,
    ci_upper  = ci_upper
  ))
}
