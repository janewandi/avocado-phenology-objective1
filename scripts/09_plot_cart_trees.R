# ============================================================
# 09_plot_cart_trees.R
# Export publication-quality CART tree diagrams (PNG + PDF)
# ============================================================

library(tidyverse)
library(rpart)
library(rpart.plot)

# ------------------------------------------------------------
# 1. Load trained CART models
# ------------------------------------------------------------

cart_combined <- readRDS("data_clean/cart_model_combined.rds")
cart_embu     <- readRDS("data_clean/cart_model_embu.rds")
cart_elgeyo   <- readRDS("data_clean/cart_model_elgeyo.rds")

# ------------------------------------------------------------
# 2. Output directory
# ------------------------------------------------------------

outdir <- "figures"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------
# 3. Helper: export CART tree as PNG + PDF
# ------------------------------------------------------------

export_tree <- function(model, filename_base, title_text) {
  
  # ---- PNG (high resolution) ----
  png(
    filename = file.path(outdir, paste0(filename_base, ".png")),
    width = 2000, height = 1600, res = 300
  )
  rpart.plot(
    model,
    main = title_text,
    type = 2,
    extra = 104,
    fallen.leaves = TRUE,
    box.palette = "GnBu",
    shadow.col = "gray",
    branch.lty = 1
  )
  dev.off()
  
  # ---- PDF (vector, thesis-ready) ----
  pdf(
    file = file.path(outdir, paste0(filename_base, ".pdf")),
    width = 11, height = 8.5
  )
  rpart.plot(
    model,
    main = title_text,
    type = 2,
    extra = 104,
    fallen.leaves = TRUE,
    box.palette = "GnBu",
    shadow.col = "gray",
    branch.lty = 1
  )
  dev.off()
}

# ------------------------------------------------------------
# 4. Export all trees
# ------------------------------------------------------------

export_tree(
  model = cart_combined,
  filename_base = "CART_Combined",
  title_text = "CART Decision Tree — Combined Dataset"
)

export_tree(
  model = cart_embu,
  filename_base = "CART_Embu",
  title_text = "CART Decision Tree — Embu"
)

export_tree(
  model = cart_elgeyo,
  filename_base = "CART_Elgeyo",
  title_text = "CART Decision Tree — Elgeyo Marakwet"
)

cat("CART tree figures exported to 'figures/'\n")
