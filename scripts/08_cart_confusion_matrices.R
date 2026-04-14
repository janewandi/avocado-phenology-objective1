# ============================================================
# 08_cart_confusion_matrices.R
# Compute confusion matrices for CART models
# ============================================================

library(tidyverse)
library(caret)
library(rpart)

# ------------------------------------------------------------
# 1. Load data + models
# ------------------------------------------------------------

dat <- readRDS("data_clean/modelling_dataset.rds")

cart_combined <- readRDS("data_clean/cart_model_combined.rds")
cart_embu     <- readRDS("data_clean/cart_model_embu.rds")
cart_elgeyo   <- readRDS("data_clean/cart_model_elgeyo.rds")

# ------------------------------------------------------------
# 2. Helper function to compute confusion matrix
# ------------------------------------------------------------

compute_cm <- function(model, data) {
  preds <- predict(model, data, type = "class")
  caret::confusionMatrix(preds, data$stage)
}

# ------------------------------------------------------------
# 3. Compute confusion matrices
# ------------------------------------------------------------

cm_combined <- compute_cm(cart_combined, dat)
cm_embu     <- compute_cm(cart_embu,     dat %>% filter(county == "Embu"))
cm_elgeyo   <- compute_cm(cart_elgeyo,   dat %>% filter(county == "Elgeyo Marakwet"))

# ------------------------------------------------------------
# 4. Print results
# ------------------------------------------------------------

cat("\n==================== Combined Model ====================\n")
print(cm_combined)

cat("\n==================== Embu Model ====================\n")
print(cm_embu)

cat("\n==================== Elgeyo Marakwet Model ====================\n")
print(cm_elgeyo)
