# ------------------------------------------------------------
# G02_radar_sensitivity.R (FIXED)
# ------------------------------------------------------------

library(fmsb)
library(dplyr)

# Load effect-size table
effect_table <- read.csv("results/effectsize_ranking.csv")

# Prepare data for radar chart
max_val <- max(effect_table$Eta2) * 1.1
min_val <- 0

# Build proper fmsb radar data frame
radar_data <- rbind(
  max_val,
  min_val,
  t(effect_table$Eta2)
)

# Convert to data frame
radar_data <- as.data.frame(radar_data)

# Assign column names
colnames(radar_data) <- effect_table$Index

# Save radar chart
png("figures/effectsize_radar.png", width = 800, height = 800)

radarchart(
  radar_data,
  axistype = 1,
  pcol = "darkgreen",
  pfcol = scales::alpha("darkgreen", 0.3),
  plwd = 3,
  cglcol = "grey",
  cglty = 1,
  axislabcol = "grey30",
  caxislabels = round(seq(0, max_val, length.out = 5), 2),
  vlcex = 1.2,
  title = "Sensitivity of Vegetation Indices (η²)"
)

dev.off()

print("Radar chart saved to figures/effectsize_radar.png")
