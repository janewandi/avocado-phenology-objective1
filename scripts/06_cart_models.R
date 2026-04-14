# ============================================================
# 06_cart_models.R
# Train CART models for combined, Embu, and Elgeyo datasets
# ============================================================

library(tidyverse)
library(rpart)
library(rpart.plot)

# ------------------------------------------------------------
# 1. Load modelling dataset
# ------------------------------------------------------------

dat <- readRDS("data_clean/modelling_dataset.rds")

# ------------------------------------------------------------
# 2. Split datasets
# ------------------------------------------------------------

dat_combined <- dat
dat_embu     <- dat %>% filter(county == "Embu")
dat_elgeyo   <- dat %>% filter(county == "Elgeyo Marakwet")

# ------------------------------------------------------------
# 3. Train CART models
# ------------------------------------------------------------

cart_combined <- rpart(
  stage ~ NDVI + EVI + NDRE + NDWI + month_num,
  data = dat_combined,
  method = "class"
)

cart_embu <- rpart(
  stage ~ NDVI + EVI + NDRE + NDWI + month_num,
  data = dat_embu,
  method = "class"
)

cart_elgeyo <- rpart(
  stage ~ NDVI + EVI + NDRE + NDWI + month_num,
  data = dat_elgeyo,
  method = "class"
)

# ------------------------------------------------------------
# 4. Save models
# ------------------------------------------------------------

saveRDS(cart_combined, "data_clean/cart_model_combined.rds")
saveRDS(cart_embu,     "data_clean/cart_model_embu.rds")
saveRDS(cart_elgeyo,   "data_clean/cart_model_elgeyo.rds")

cat("CART models trained and saved.\n")
