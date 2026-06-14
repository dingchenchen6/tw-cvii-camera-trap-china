#!/usr/bin/env Rscript
# =============================================================================
# 02_seed_reference.R — 填充参考表：taxonomy / conservation_status / functional_traits
# 数据源: 07_cleaning/seed_taxonomy.csv (30 种中国红外相机常见鸟兽，硬编码初始值)
#   权威全量名录(中国生物物种名录/IUCN)待后续从 GBIF API 补充。
# 用法: Rscript 09_analysis/scripts/02_seed_reference.R [db_path]
# =============================================================================
source("09_analysis/scripts/01_helpers.R")

db_path <- if (length(commandArgs(trailingOnly = TRUE)) >= 1) {
  commandArgs(trailingOnly = TRUE)[1]
} else DB_V0

stopifnot(file.exists(db_path))
con <- dbConnect(duckdb(), dbdir = db_path, read_only = FALSE)
on.exit(dbDisconnect(con), add = TRUE)

seed <- read_csv(file.path(ROOT, "07_cleaning", "seed_taxonomy.csv"),
                 show_col_types = FALSE)

# Red List 几何权重序列 (cleaning_rules.md §8)
threat_map <- c(LC = 1, NT = 2, VU = 4, EN = 8, CR = 16, DD = NA_real_, NE = NA_real_)

# 1) taxonomy
tax <- tibble::tibble(
  species_id               = NA_character_,   # 稍后分配
  scientific_name_original = seed$scientific_name_accepted,
  scientific_name_accepted = seed$scientific_name_accepted,
  chinese_name_standard    = seed$chinese_name_standard,
  name_status              = "accepted",
  taxon_rank               = "species",
  kingdom                  = "Animalia",
  phylum                   = "Chordata",
  class                    = seed$class,
  order                    = seed$order,
  family                   = seed$family,
  genus                    = seed$genus,
  species                  = seed$species,
  best_guess_binomial      = seed$scientific_name_accepted,
  taxonomy_source          = "manual",
  taxonomy_notes           = "seed v1; authoritative checklist pending"
)
tax <- assign_and_insert(con, "SP", "taxonomy", "species_id", tax)

# 2) conservation_status
cons <- tibble::tibble(
  status_id                = NA_character_,
  species_id               = tax$species_id,
  china_redlist_category   = seed$china_redlist_category,
  china_redlist_version    = "2021 assessment (provisional)",
  iucn_category            = seed$china_redlist_category,
  iucn_version_or_year     = "2023 (provisional)",
  national_protection_class = seed$national_protection_class,
  cites_appendix           = NA_character_,
  endemic_status           = seed$endemic_status,
  threat_weight            = unname(threat_map[seed$china_redlist_category]),
  dd_uncertainty_flag      = ifelse(seed$china_redlist_category == "DD", "yes", "no")
)
cons <- assign_and_insert(con, "CS", "conservation_status", "status_id", cons)

# 3) functional_traits
ft <- tibble::tibble(
  trait_id                = NA_character_,
  species_id              = tax$species_id,
  body_mass_g             = NA_real_,
  body_size_class         = seed$body_size_class,
  trophic_level           = seed$trophic_level,
  diet_breadth            = NA_real_,
  foraging_stratum        = seed$foraging_stratum,
  activity_pattern        = seed$activity_pattern,
  habitat_specialization  = "unknown",
  dispersal_ability       = NA_character_,
  functional_group        = seed$functional_group,
  functional_weight       = NA_real_,   # 派生阶段填
  trait_source            = "manual"
)
ft <- assign_and_insert(con, "FT", "functional_traits", "trait_id", ft)

# 汇总
n_tax <- dbGetQuery(con, "SELECT COUNT(*) n FROM taxonomy")$n
n_cons <- dbGetQuery(con, "SELECT COUNT(*) n FROM conservation_status")$n
n_ft <- dbGetQuery(con, "SELECT COUNT(*) n FROM functional_traits")$n
message(sprintf("\n✓ 参考表已填充: taxonomy=%d, conservation_status=%d, functional_traits=%d",
                n_tax, n_cons, n_ft))
message("  threat_weight 几何序列: LC=1, NT=2, VU=4, EN=8, CR=16")
message("  注: 全量权威名录(中国生物物种名录/IUCN/GBIF)待后续补充。")
