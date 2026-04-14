# ============================================================
# 01_load_data.R
# Load raw satellite and phenology data for Objective 1
# ============================================================

library(tidyverse)
library(lubridate)

# ------------------------------------------------------------
# 1. Load Embu dataset
# ------------------------------------------------------------

embu <- read_csv("data_raw/HLS_MultiIndex_Embu_2024_2025.csv") %>%
  select(-County) %>%                     # remove duplicate county column
  rename(farm_id = `Farm ID`) %>%         # standardize farm ID
  mutate(
    date  = as_date(date),
    month = month(date)
  )

# ------------------------------------------------------------
# 2. Load Elgeyo dataset
# ------------------------------------------------------------

elgeyo <- read_csv("data_raw/HLS_MultiIndex_Elgeyo_2024_2025.csv") %>%
  select(-County) %>%                     # remove duplicate county column
  rename(farm_id = `Farmer ID`) %>%       # standardize farm ID
  mutate(
    date  = as_date(date),
    month = month(date)
  )

# ------------------------------------------------------------
# 3. Load phenology reference (all 8 farms)
# ------------------------------------------------------------

pheno_ref <- read_csv("data_raw/phenology_reference_2024_2025.csv") %>%
  mutate(
    start_date = as_date(start_date),
    end_date   = as_date(end_date)
  )

# ------------------------------------------------------------
# 4. Combine satellite data
# ------------------------------------------------------------

gee_all <- bind_rows(embu, elgeyo)

# ------------------------------------------------------------
# 5. Save outputs
# ------------------------------------------------------------

saveRDS(gee_all,   "data_clean/gee_all_raw.rds")
saveRDS(pheno_ref, "data_clean/pheno_ref_raw.rds")
