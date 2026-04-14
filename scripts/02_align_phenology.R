# ============================================================
# 02_align_phenology.R
# Expand phenology windows and align with satellite observations
# ============================================================

library(tidyverse)
library(lubridate)

# ------------------------------------------------------------
# 1. Load cleaned RDS files
# ------------------------------------------------------------

gee_all   <- readRDS("data_clean/gee_all_raw.rds")
pheno_ref <- readRDS("data_clean/pheno_ref_raw.rds")

# ------------------------------------------------------------
# 2. Expand phenology windows to daily dates
#    (keeps farms with missing start/end dates)
# ------------------------------------------------------------

pheno_daily <- pheno_ref %>%
  mutate(
    date = map2(start_date, end_date, ~ {
      if (is.na(.x) | is.na(.y)) return(as.Date(NA))
      seq(.x, .y, by = "day")
    })
  ) %>%
  unnest(date) %>%
  mutate(month = month(date))

# ------------------------------------------------------------
# 3. Align satellite data with phenology stages
# ------------------------------------------------------------

sat_pheno_aligned <- gee_all %>%
  left_join(pheno_daily, by = c("farm_id", "county", "month"))

# ------------------------------------------------------------
# 4. Save output
# ------------------------------------------------------------

saveRDS(sat_pheno_aligned, "data_clean/sat_pheno_aligned.rds")
