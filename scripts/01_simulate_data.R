######################### 01_simulate_data.R########################

library(tidyverse)
library(MatchIt)
library(cobalt)


set.seed(123)

n <- 500
X1 <- rnorm(n)
X2 <- rbinom(n, 1, 0.5)
propensity <- plogis(0.5 * X1 - 0.25 * X2)
treatment <- rbinom(n, 1, propensity)
Y0 <- 2 + X1 - X2 + rnorm(n)
Y1 <- Y0 + 1.5                  # true treatment effect 
outcome <- ifelse(treatment == 1, Y1, Y0)

df <- tibble(X1, X2, treatment, outcome)

glimpse(df)
summary(df)
