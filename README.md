# Classification of Avocado Phenology Stages Using Fused Sentinel‑2 and Landsat Vegetation Indices in Embu and Elgeyo Marakwet
### Author: Jane Wandi Wanjira Njeru
## PhD Research — Objective 1 (2026)

## Overview
This repository contains all scripts, data products, and reproducible workflows for Objective 1 of a PhD research project on remote‑sensing–based avocado maturity assessment in Kenya. The objective is to classify four phenological stages—Flowering, Vegetative Growth, Fruit Development, and Maturity—using fused Sentinel‑2 and Landsat (HLS) vegetation indices across two contrasting agroecological zones: Embu and Elgeyo Marakwet.

The workflow integrates Google Earth Engine (GEE) for multisensor preprocessing and R for feature engineering, CART modelling, visualization, and reproducible reporting.

## Repository Structure
Code
project_root/
│
├── objective1_assignment.Rmd        # Full reproducible report
├── objective1_assignment.html       # Knitted HTML output
├── objective1_assignment.pdf        # Knitted PDF output
│
├── scripts/
│   ├── 01_load_data.R
│   ├── 02_align_phenology.R
│   ├── 03_feature_engineering.R
│   ├── 06_cart_models.R
│   ├── 08_cart_confusion_matrices.R
│   ├── 09_plot_cart_trees.R
│   └── figures/
│       ├── G01_effectsize_barplot.R
│       ├── G02_radar_sensitivity.R
│       ├── G03_stagepair_heatmap.R
│       └── G03_stagepair_heatmap_fixed.R
│
├── gee_scripts/
│   └── GEE_multiindex_timeseries.js   # HLS preprocessing + index extraction
│
├── data_raw/                          # Raw exported CSVs from GEE
├── data_clean/                        # Cleaned RDS files (aligned + engineered)
├── figures/                           # All PNG figures used in the report
├── results/                           # Model outputs, confusion matrices, etc.
│
├── references.bib                     # Bibliography
└── apa.csl                            # Citation style

## Key Outputs
Multisensor vegetation index time series (NDVI, EVI, NDRE, NDWI)
Effect size analysis and sensitivity ranking
Stage‑pair separability heatmaps
County‑specific and combined CART models
Decision tree visualizations
Confusion matrices and accuracy metrics

## Reproducibility
All analyses are fully reproducible:
GEE preprocessing scripts are in gee_scripts/
R analysis scripts are in scripts/
Figure‑generation scripts (G01–G03) are in scripts/figures/
Figures are stored in figures/
Cleaned datasets are in data_clean/
The computational environment is documented in the Session Info section of the R Markdown report.

## Citation
If using this workflow, please cite:
Njeru, J. W. W. (2026). Classification of Avocado Phenology Stages Using Fused Sentinel‑2 and Landsat Vegetation Indices in Embu and Elgeyo Marakwet. PhD Research Project.