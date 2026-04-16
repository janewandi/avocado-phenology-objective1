# ------------------------------------------------------------
# G01_effectsize_barplot.R
# Barplot of effect sizes (eta squared) for each vegetation index
# ------------------------------------------------------------

library(ggplot2)
library(dplyr)

# Load effect-size table
effect_table <- read.csv("results/effectsize_ranking.csv")

# Order factors by effect size
effect_table$Index <- factor(effect_table$Index,
                             levels = effect_table$Index[order(effect_table$Eta2)])

p <- ggplot(effect_table, aes(x = Index, y = Eta2, fill = Index)) +
  geom_col(width = 0.7) +
  coord_flip() +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Effect Size (η²) by Vegetation Index",
    x = "Vegetation Index",
    y = "Effect Size (η²)"
  ) +
  theme_bw(base_size = 14) +
  theme(legend.position = "none")

if (!dir.exists("figures")) dir.create("figures")

ggsave("figures/effectsize_barplot.png", p, width = 8, height = 5, dpi = 300)

print("Effect-size barplot saved to figures/effectsize_barplot.png")
