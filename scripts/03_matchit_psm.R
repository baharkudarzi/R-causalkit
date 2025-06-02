############################03_matchit_psm.R###################################


library(MatchIt)
library(cobalt)
library(tidyverse)


source("scripts/01_simulate_data.R")  


m.out <- matchit(
  formula = treatment ~ X1 + X2,
  data    = df,
  method  = "nearest",    
  ratio   = 1,
  replace = FALSE
)


summary(m.out)


df_matched <- match.data(m.out)

bal <- bal.tab(m.out, un = TRUE)
print(bal)


love.plot(
  bal,
  stats     = "mean.diffs",
  drop.order= TRUE,
  threshold = 0.1,
  shapes    = c("circle", "triangle"),
  colors    = c("grey", "black"),
  title     = "Love Plot: Pre- vs Post-Matching SMD"
)


cat("Original N:", nrow(df), "\nMatched N:", nrow(df_matched), "\n")
