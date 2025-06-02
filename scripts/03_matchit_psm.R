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


bal <- bal.tab(m.out, un = TRUE)


love_obj <- love.plot(
  bal,
  stats      = "mean.diffs",
  drop.order = TRUE,
  threshold  = 0.1,
  shapes     = c("circle", "triangle"),
  colors     = c("grey", "black"),
  title      = "Love Plot: Pre- vs Post-Matching SMD"
)


print(love_obj)


if (!dir.exists("results")) dir.create("results")


ggsave(
  filename = "results/loveplot_pre_post.png",
  plot     = love_obj,
  width    = 6,
  height   = 4,
  dpi      = 300
)


cat("\nSaved love-plot to results/loveplot_pre_post.png\n")
