# ============================================================
# 03_feature_engineering.R
# Create modelling dataset from aligned phenology + satellite data
# ============================================================

library(tidyverse)
library(lubridate)

# ------------------------------------------------------------
# 1. Load aligned dataset
# ------------------------------------------------------------

sat_pheno <- readRDS("data_clean/sat_pheno_aligned.rds")

# ------------------------------------------------------------
# 2. Remove rows with missing phenology stage
# ------------------------------------------------------------

sat_pheno_clean <- sat_pheno %>%
  filter(!is.na(stage))

# ------------------------------------------------------------
# 3. Feature engineering
# ------------------------------------------------------------

modelling_dataset <- sat_pheno_clean %>%
  mutate(
    month_num = month(start_date),   # numeric month from start_date
    stage = factor(stage)            # ensure stage is a factor
  ) %>%
  select(
    farm_id,
    county,
    stage,
    start_date,
    end_date,
    month_num,
    NDVI, EVI, NDRE, NDWI
  )

# ------------------------------------------------------------
# 4. Save output
# ------------------------------------------------------------

saveRDS(modelling_dataset, "data_clean/modelling_dataset.rds")

cat("Feature engineering complete. modelling_dataset.rds saved.\n")
