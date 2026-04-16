# ------------------------------------------------------------
# G03_stagepair_heatmap_fixed.R
# Robust heatmap of stage-pair separability from Tukey HSD
# ------------------------------------------------------------

library(dplyr)
library(tidyr)
library(ggplot2)

index_vars <- c("NDVI", "EVI", "NDRE", "NDWI")

extract_tukey <- function(idx) {
  
  file <- paste0("results/ANOVA_", idx, ".txt")
  lines <- readLines(file)
  
  # Find the start of the Tukey section
  tukey_start <- grep("Tukey multiple comparisons", lines)
  if (length(tukey_start) == 0) return(NULL)
  
  # Extract everything after the Tukey header
  tukey_lines <- lines[(tukey_start + 1):length(lines)]
  
  # Keep only lines that look like comparisons (contain a hyphen)
  tukey_lines <- tukey_lines[grepl("-", tukey_lines)]
  
  # Extract comparison and p-value using regex
  df <- data.frame(
    raw = tukey_lines,
    stringsAsFactors = FALSE
  ) %>%
    mutate(
      Comparison = sub("\\s+.*", "", raw),
      p_adj = as.numeric(sub(".*\\s([0-9\\.eE-]+)$", "\\1", raw)),
      Index = idx
    ) %>%
    select(Comparison, p_adj, Index)
  
  return(df)
}

# Apply extractor to all indices
tukey_all <- do.call(rbind, lapply(index_vars, extract_tukey))

# Split stage pairs
tukey_all <- tukey_all %>%
  separate(Comparison, into = c("Stage1", "Stage2"), sep = "-") %>%
  mutate(Significant = ifelse(p_adj < 0.05, "Yes", "No"))

# Heatmap
p <- ggplot(tukey_all, aes(x = Stage1, y = Stage2, fill = Significant)) +
  geom_tile(color = "white") +
  facet_wrap(~ Index) +
  scale_fill_manual(values = c("Yes" = "#1b9e77", "No" = "#d95f02")) +
  labs(
    title = "Stage-Pair Separability (Tukey HSD)",
    x = "Stage 1",
    y = "Stage 2",
    fill = "Significant?"
  ) +
  theme_bw(base_size = 14) +
  theme(strip.text = element_text(face = "bold"))

if (!dir.exists("figures")) dir.create("figures")

ggsave("figures/stagepair_heatmap.png", p, width = 10, height = 8, dpi = 300)

print("Stage-pair heatmap saved to figures/stagepair_heatmap.png")
