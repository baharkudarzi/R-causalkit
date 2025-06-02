############################02_eda_balance.R############################


library(tidyverse)
library(cobalt)


source("scripts/01_simulate_data.R")  


ggplot(df, aes(x = X1, fill = factor(treatment))) +
  geom_density(alpha = 0.5) +
  labs(fill = "Treatment",
       title = "Density of X1: Treatment vs Control")


df %>% 
  count(X2, treatment) %>% 
  ggplot(aes(x = factor(X2), y = n, fill = factor(treatment))) +
  geom_col(position = "dodge") +
  labs(x = "X2 value", fill = "Treatment",
       title = "Count of X2 Levels by Group")


bal <- bal.tab(treatment ~ X1 + X2, data = df, un = TRUE)
print(bal)


love.plot(bal, stats = "mean.diffs", threshold = 0.1,
          title = "Love Plot: Pre-Matching Standardized Mean Differences")
