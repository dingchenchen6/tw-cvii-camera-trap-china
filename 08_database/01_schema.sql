-- =============================================================================
-- TW-CVII China 红外相机数据库 Schema
-- 按 camera_trap_database_schema_predicts_divert_twcvii.md §5–6 实现
-- 数据库: DuckDB (v0_raw_ingest / v1_cleaned_core / v2_analysis_ready / v3_manuscript_freeze)
-- 字段等级: M必填 / H高优先 / O可选 / D派生(脚本生成)
-- 缺失码: NR 文献未报告 / NA 不适用 / UNK 无法判断 / PENDING 待核验 /
--         EXTRACTED_UNVERIFIED 已抽取未核验 / RESTRICTED 受数据权限限制
-- ID 规则: SRC/STU/BLK/SITE/DEP/MED/OBS/EVT/SP/MET/HEX/EVD + 6位
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 清理（重建时用）
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS derived_index;
DROP TABLE IF EXISTS protected_area_context;
DROP TABLE IF EXISTS environmental_covariates;
DROP TABLE IF EXISTS reference_baseline_pair;
DROP TABLE IF EXISTS evidence_state;
DROP TABLE IF EXISTS survey_adequacy_detection;
DROP TABLE IF EXISTS historical_expectation;
DROP TABLE IF EXISTS diversity_summary;
DROP TABLE IF EXISTS species_site_measurement;
DROP TABLE IF EXISTS functional_traits;
DROP TABLE IF EXISTS conservation_status;
DROP TABLE IF EXISTS taxonomy;
DROP TABLE IF EXISTS independent_event;
DROP TABLE IF EXISTS observation;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS land_use_management;
DROP TABLE IF EXISTS deployment;
DROP TABLE IF EXISTS site;
DROP TABLE IF EXISTS block;
DROP TABLE IF EXISTS study;
DROP TABLE IF EXISTS source;
DROP TABLE IF EXISTS extraction_audit;
DROP TABLE IF EXISTS issue_log;
DROP VIEW IF EXISTS view_species_site_evidence;
DROP VIEW IF EXISTS view_site_intactness_inputs;
DROP VIEW IF EXISTS view_pa_effectiveness_inputs;
DROP VIEW IF EXISTS view_redlist_mismatch_inputs;

-- -----------------------------------------------------------------------------
-- 1. source 文献/数据源表 (§5.1)
-- -----------------------------------------------------------------------------
CREATE TABLE source (
    source_id                    VARCHAR(12) PRIMARY KEY,
    zotero_item_key              VARCHAR(32) NOT NULL,
    bibtex_key                   VARCHAR(64),
    title_original              VARCHAR(500) NOT NULL,
    title_english               VARCHAR(500),
    authors                     VARCHAR(1000) NOT NULL,
    year                        INTEGER NOT NULL,
    journal_or_source           VARCHAR(200) NOT NULL,
    publication_type            VARCHAR(20) NOT NULL CHECK (publication_type IN ('article','report','thesis','book','chapter','dataset','preprint','other')),
    doi                         VARCHAR(120),
    url                         VARCHAR(500),
    language                    VARCHAR(10) NOT NULL CHECK (language IN ('zh','en','mixed','other')),
    database_source             VARCHAR(20) NOT NULL CHECK (database_source IN ('CNKI','WOS','Wanfang','VIP','GoogleScholar','Zotero','manual','other')),
    search_id_first_found       VARCHAR(20),
    full_text_status            VARCHAR(15) NOT NULL CHECK (full_text_status IN ('available','missing','restricted')),
    supplement_status           VARCHAR(15) NOT NULL CHECK (supplement_status IN ('none','available','missing','unknown')),
    has_appendix_species_list   VARCHAR(10) CHECK (has_appendix_species_list IN ('yes','no','unknown')),
    data_access_status          VARCHAR(30) CHECK (data_access_status IN ('open','by_request','restricted','extracted_from_pdf','unknown')),
    duplicate_group_id          VARCHAR(20),
    extraction_status           VARCHAR(30) NOT NULL DEFAULT 'queued' CHECK (extraction_status IN ('queued','in_progress','extracted','verified','database_ingested','excluded')),
    notes                       VARCHAR(1000)
);

-- -----------------------------------------------------------------------------
-- 2. study 研究表 (§5.2)
-- -----------------------------------------------------------------------------
CREATE TABLE study (
    study_id                     VARCHAR(12) PRIMARY KEY,
    source_id                    VARCHAR(12) NOT NULL REFERENCES source(source_id),
    study_name                   VARCHAR(300),
    study_number_within_source   VARCHAR(10),
    study_objective              VARCHAR(200),
    study_common_taxon           VARCHAR(20) NOT NULL CHECK (study_common_taxon IN ('mammals','birds','reptiles','amphibians','mixed','other')),
    target_taxa                  VARCHAR(200) NOT NULL,
    target_species               VARCHAR(300),
    sampling_method              VARCHAR(40) NOT NULL,
    survey_design                VARCHAR(40) CHECK (survey_design IN ('grid','transect','random','opportunistic','paired','reference-gradient','mixed','unknown')),
    methods_constant_within_study VARCHAR(10) CHECK (methods_constant_within_study IN ('yes','no','unknown')),
    independent_event_threshold  VARCHAR(20),
    sampling_occassion_definition VARCHAR(20),
    study_start_date             DATE,
    study_end_date               DATE,
    sample_date_resolution       VARCHAR(10) CHECK (sample_date_resolution IN ('day','month','year','range','unknown')),
    total_camera_count_reported  INTEGER,
    total_station_count_reported INTEGER,
    total_deployment_count       INTEGER,
    total_camera_days_reported   DOUBLE,
    total_valid_nights_reported  DOUBLE,
    total_area_reported          DOUBLE,
    area_unit_original           VARCHAR(10) CHECK (area_unit_original IN ('km2','ha','mu','m2','unknown')),
    bait_lure_use                VARCHAR(10) CHECK (bait_lure_use IN ('yes','no','mixed','NR')),
    camera_model_reported        VARCHAR(100),
    raw_data_available           VARCHAR(15) CHECK (raw_data_available IN ('yes','no','restricted','unknown')),
    supplementary_data_available VARCHAR(10) CHECK (supplementary_data_available IN ('yes','no','unknown')),
    study_quality_flags          VARCHAR(300)
);

-- -----------------------------------------------------------------------------
-- 3. block 空间区组表 (§5.3)
-- -----------------------------------------------------------------------------
CREATE TABLE block (
    block_id                     VARCHAR(12) PRIMARY KEY,
    study_id                     VARCHAR(12) NOT NULL REFERENCES study(study_id),
    block_name_original          VARCHAR(200),
    block_type                   VARCHAR(30) CHECK (block_type IN ('reserve_zone','mountain','site_cluster','grid_cell','watershed','admin_unit','none','unknown')),
    spatial_clustering_reason    VARCHAR(200),
    block_latitude               DOUBLE,
    block_longitude              DOUBLE,
    coordinate_precision         VARCHAR(15) CHECK (coordinate_precision IN ('exact','centroid','approx','unknown')),
    notes                        VARCHAR(500)
);

-- -----------------------------------------------------------------------------
-- 4. site 调查地点表 (§5.4)
-- -----------------------------------------------------------------------------
CREATE TABLE site (
    site_id                      VARCHAR(12) PRIMARY KEY,
    study_id                     VARCHAR(12) NOT NULL REFERENCES study(study_id),
    block_id                     VARCHAR(12) REFERENCES block(block_id),
    site_number_within_study     VARCHAR(20),
    site_name_original           VARCHAR(300) NOT NULL,
    site_name_standard           VARCHAR(300),
    province                     VARCHAR(30) NOT NULL,
    prefecture                   VARCHAR(40),
    county                       VARCHAR(40),
    township                     VARCHAR(60),
    protected_area_name          VARCHAR(150),
    protected_area_id            VARCHAR(30),
    national_park_status         VARCHAR(15) CHECK (national_park_status IN ('inside','outside','buffer','unknown')),
    latitude                     DOUBLE CHECK (latitude IS NULL OR (latitude BETWEEN -90 AND 90)),
    longitude                    DOUBLE CHECK (longitude IS NULL OR (longitude BETWEEN -180 AND 180)),
    coordinate_precision         VARCHAR(20) NOT NULL DEFAULT 'unknown' CHECK (coordinate_precision IN ('exact','rounded','centroid','county','protected_area','unknown')),
    coordinate_uncertainty_m     DOUBLE,
    elevation_min_m              DOUBLE,
    elevation_max_m              DOUBLE,
    elevation_mean_m             DOUBLE,
    habitat_type_original        VARCHAR(200),
    habitat_type_standard        VARCHAR(100),
    survey_area_km2              DOUBLE,
    protected_area_total_km2     DOUBLE,
    effective_sampling_area_km2  DOUBLE,
    max_linear_extent_m          DOUBLE,
    spatial_unit_for_twcvii      VARCHAR(25) NOT NULL DEFAULT 'site' CHECK (spatial_unit_for_twcvii IN ('site','grid','protected_area','ecoregion','mountain_system')),
    notes                        VARCHAR(500)
);

-- -----------------------------------------------------------------------------
-- 5. land_use_management 土地利用和管理表 (§5.5)
-- -----------------------------------------------------------------------------
CREATE TABLE land_use_management (
    landuse_id                   VARCHAR(12) PRIMARY KEY,
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    habitat_as_described         VARCHAR(500),
    predominant_land_use         VARCHAR(40) CHECK (predominant_land_use IN ('primary_vegetation','secondary_vegetation','cropland','pasture','forestry','agroforestry','urban','mining','other','unknown')),
    source_for_land_use          VARCHAR(30) CHECK (source_for_land_use IN ('original_text','map','remote_sensing','inferred','unknown')),
    use_intensity                VARCHAR(15) CHECK (use_intensity IN ('minimal','light','intense','unknown')),
    prior_land_use               VARCHAR(100),
    time_since_conversion_years  DOUBLE,
    secondary_vegetation_age_class VARCHAR(20) CHECK (secondary_vegetation_age_class IN ('young','intermediate','mature','unknown')),
    crop_type                    VARCHAR(100),
    crop_diversity               VARCHAR(20) CHECK (crop_diversity IN ('monoculture','polyculture','mixed','unknown')),
    logging_type                 VARCHAR(25) CHECK (logging_type IN ('clear_cut','selective','reduced_impact','unknown')),
    grazing_presence             VARCHAR(10) CHECK (grazing_presence IN ('yes','no','unknown')),
    grazing_intensity            VARCHAR(15) CHECK (grazing_intensity IN ('light','moderate','heavy','unknown')),
    natural_margin_presence      VARCHAR(10) CHECK (natural_margin_presence IN ('yes','no','unknown')),
    road_or_trail_presence       VARCHAR(10) CHECK (road_or_trail_presence IN ('yes','no','unknown')),
    hunting_or_poaching_evidence VARCHAR(10) CHECK (hunting_or_poaching_evidence IN ('yes','no','unknown')),
    human_footprint_value        DOUBLE,
    distance_to_road_m           DOUBLE,
    distance_to_settlement_m     DOUBLE,
    land_use_notes               VARCHAR(500)
);

-- -----------------------------------------------------------------------------
-- 6. deployment 相机布设表 (§5.6)
-- -----------------------------------------------------------------------------
CREATE TABLE deployment (
    deployment_id                VARCHAR(12) PRIMARY KEY,
    study_id                     VARCHAR(12) NOT NULL REFERENCES study(study_id),
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    station_id                   VARCHAR(40),
    location_id                  VARCHAR(40),
    camera_id                    VARCHAR(40),
    camera_model                 VARCHAR(60),
    deployment_start             DATE,
    deployment_end               DATE,
    date_precision               VARCHAR(10) CHECK (date_precision IN ('day','month','year','range','unknown')),
    active_days                  DOUBLE,
    camera_days                  DOUBLE,
    trap_nights                  DOUBLE,
    valid_nights                 DOUBLE,
    malfunction_days             DOUBLE,
    camera_delay_seconds         DOUBLE,
    camera_height_cm             DOUBLE,
    camera_heading_deg           DOUBLE,
    camera_tilt_deg              DOUBLE,
    detection_distance_m         DOUBLE,
    camera_spacing_m             DOUBLE,
    grid_size_km                 DOUBLE,
    placement_type               VARCHAR(20) CHECK (placement_type IN ('trail','ridge','valley','water','road','random','animal_path','other','unknown')),
    bait_lure_use                VARCHAR(10) CHECK (bait_lure_use IN ('yes','no','unknown')),
    season                       VARCHAR(15) CHECK (season IN ('spring','summer','autumn','winter','dry','wet','mixed','unknown')),
    timestamp_issues             VARCHAR(10) CHECK (timestamp_issues IN ('yes','no','unknown')),
    deployment_source_resolution VARCHAR(20) NOT NULL DEFAULT 'site_summary' CHECK (deployment_source_resolution IN ('station_level','site_summary','study_summary')),
    extraction_page              VARCHAR(50),
    verification_status          VARCHAR(15) NOT NULL DEFAULT 'unverified' CHECK (verification_status IN ('verified','unverified'))
);

-- -----------------------------------------------------------------------------
-- 7. media 媒体表 (§5.7)
-- -----------------------------------------------------------------------------
CREATE TABLE media (
    media_id                     VARCHAR(12) PRIMARY KEY,
    deployment_id                VARCHAR(12) NOT NULL REFERENCES deployment(deployment_id),
    capture_method               VARCHAR(25) CHECK (capture_method IN ('activityDetection','timeLapse','unknown')),
    timestamp                    TIMESTAMP,
    file_path_or_url             VARCHAR(500),
    file_public                  VARCHAR(10) CHECK (file_public IN ('true','false','unknown')),
    file_name                    VARCHAR(200),
    file_mediatype               VARCHAR(40),
    exif_available               VARCHAR(10) CHECK (exif_available IN ('yes','no')),
    media_quality_flag           VARCHAR(40)
);

-- -----------------------------------------------------------------------------
-- 8. observation 观测表 (§5.8)
-- -----------------------------------------------------------------------------
CREATE TABLE observation (
    observation_id               VARCHAR(12) PRIMARY KEY,
    deployment_id                VARCHAR(12) NOT NULL REFERENCES deployment(deployment_id),
    media_id                     VARCHAR(12) REFERENCES media(media_id),
    event_id                     VARCHAR(12),
    event_start                  TIMESTAMP,
    event_end                    TIMESTAMP,
    observation_level            VARCHAR(10) NOT NULL CHECK (observation_level IN ('media','event')),
    observation_type             VARCHAR(20) NOT NULL CHECK (observation_type IN ('animal','human','vehicle','blank','unknown','unclassified')),
    species_id                   VARCHAR(12),
    scientific_name_original     VARCHAR(200),
    count                        INTEGER,
    life_stage                   VARCHAR(15) CHECK (life_stage IN ('adult','subadult','juvenile','unknown')),
    sex                          VARCHAR(10) CHECK (sex IN ('male','female','unknown')),
    behaviour                    VARCHAR(100),
    individual_id                VARCHAR(40),
    classification_method        VARCHAR(25) CHECK (classification_method IN ('human','AI','mixed','unknown')),
    classification_confidence    DOUBLE,
    timestamp                    TIMESTAMP,
    extraction_page              VARCHAR(50),
    verification_status          VARCHAR(15) NOT NULL DEFAULT 'unverified' CHECK (verification_status IN ('verified','unverified'))
);

-- -----------------------------------------------------------------------------
-- 9. independent_event 独立事件表 (§5.9)
-- -----------------------------------------------------------------------------
CREATE TABLE independent_event (
    event_id                     VARCHAR(12) PRIMARY KEY,
    deployment_id                VARCHAR(12) NOT NULL REFERENCES deployment(deployment_id),
    species_id                   VARCHAR(12),
    event_start                  TIMESTAMP,
    event_end                    TIMESTAMP,
    event_duration_min           DOUBLE,
    event_threshold_min          INTEGER,
    max_count                    INTEGER,
    independent_record_count     INTEGER,
    event_definition_source      VARCHAR(20) CHECK (event_definition_source IN ('original','standardized_30min','standardized_60min','unknown')),
    extraction_page              VARCHAR(50),
    verification_status          VARCHAR(15) NOT NULL DEFAULT 'unverified' CHECK (verification_status IN ('verified','unverified'))
);

-- -----------------------------------------------------------------------------
-- 10. taxonomy 分类表 (§5.10)
-- -----------------------------------------------------------------------------
CREATE TABLE taxonomy (
    species_id                   VARCHAR(12) PRIMARY KEY,
    scientific_name_original     VARCHAR(200),
    scientific_name_accepted     VARCHAR(200) NOT NULL,
    chinese_name_standard        VARCHAR(100),
    name_status                  VARCHAR(15) CHECK (name_status IN ('accepted','synonym','provisional','unresolved')),
    taxon_rank                   VARCHAR(10) NOT NULL CHECK (taxon_rank IN ('species','genus','family','unknown')),
    kingdom                      VARCHAR(30) DEFAULT 'Animalia',
    phylum                       VARCHAR(30) DEFAULT 'Chordata',
    class                        VARCHAR(30),
    "order"                      VARCHAR(40),
    family                       VARCHAR(40),
    genus                        VARCHAR(50),
    species                      VARCHAR(60),
    best_guess_binomial          VARCHAR(120),
    taxonomy_source              VARCHAR(40) CHECK (taxonomy_source IN ('Catalogue of Life','GBIF','中国生物物种名录','IUCN','manual','unknown')),
    taxonomy_notes               VARCHAR(300)
);

-- -----------------------------------------------------------------------------
-- 11. conservation_status 保护状态表 (§5.11)
-- -----------------------------------------------------------------------------
CREATE TABLE conservation_status (
    status_id                    VARCHAR(12) PRIMARY KEY,
    species_id                   VARCHAR(12) NOT NULL REFERENCES taxonomy(species_id),
    china_redlist_category       VARCHAR(5) CHECK (china_redlist_category IN ('CR','EN','VU','NT','LC','DD','NE','unknown')),
    china_redlist_version        VARCHAR(20),
    iucn_category                VARCHAR(5) CHECK (iucn_category IN ('CR','EN','VU','NT','LC','DD','NE','unknown')),
    iucn_version_or_year         VARCHAR(20),
    national_protection_class    VARCHAR(15) CHECK (national_protection_class IN ('Class I','Class II','none','unknown')),
    cites_appendix               VARCHAR(10),
    endemic_status               VARCHAR(25) CHECK (endemic_status IN ('China endemic','near endemic','not endemic','unknown')),
    threat_weight                DOUBLE,
    dd_uncertainty_flag          VARCHAR(10) CHECK (dd_uncertainty_flag IN ('yes','no'))
);

-- -----------------------------------------------------------------------------
-- 12. functional_traits 功能性状表 (§5.12)
-- -----------------------------------------------------------------------------
CREATE TABLE functional_traits (
    trait_id                     VARCHAR(12) PRIMARY KEY,
    species_id                   VARCHAR(12) NOT NULL REFERENCES taxonomy(species_id),
    body_mass_g                  DOUBLE,
    body_size_class              VARCHAR(10) CHECK (body_size_class IN ('small','medium','large','unknown')),
    trophic_level                VARCHAR(20) CHECK (trophic_level IN ('herbivore','omnivore','carnivore','insectivore','scavenger','unknown')),
    diet_breadth                 DOUBLE,
    foraging_stratum             VARCHAR(20) CHECK (foraging_stratum IN ('ground','arboreal','aerial','aquatic','mixed','unknown')),
    activity_pattern             VARCHAR(20) CHECK (activity_pattern IN ('diurnal','nocturnal','cathemeral','crepuscular','unknown')),
    habitat_specialization       VARCHAR(15) CHECK (habitat_specialization IN ('specialist','generalist','unknown')),
    dispersal_ability            VARCHAR(20),
    functional_group             VARCHAR(30) CHECK (functional_group IN ('large_carnivore','large_herbivore','mesocarnivore','seed_disperser','scavenger','ground_bird','unknown')),
    functional_weight            DOUBLE,
    trait_source                 VARCHAR(30) CHECK (trait_source IN ('PanTHERIA','EltonTraits','literature','manual','unknown'))
);

-- -----------------------------------------------------------------------------
-- 13. species_site_measurement 物种-地点指标表 (§5.13) — 汇总数据核心
-- -----------------------------------------------------------------------------
CREATE TABLE species_site_measurement (
    measurement_id               VARCHAR(12) PRIMARY KEY,
    source_id                    VARCHAR(12) NOT NULL REFERENCES source(source_id),
    study_id                     VARCHAR(12) NOT NULL REFERENCES study(study_id),
    block_id                     VARCHAR(12),
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    species_id                   VARCHAR(12) NOT NULL REFERENCES taxonomy(species_id),
    taxon_name_entered           VARCHAR(200) NOT NULL,
    measurement                  VARCHAR(50) NOT NULL,
    diversity_metric_type        VARCHAR(20) NOT NULL CHECK (diversity_metric_type IN ('abundance','occurrence','richness','diversity','RAI','occupancy','density','activity','independent_records','valid_photos','unknown')),
    diversity_metric             VARCHAR(60) NOT NULL,
    diversity_metric_unit        VARCHAR(30) CHECK (diversity_metric_unit IN ('count','per_100_camera_days','proportion','ind_per_km2','unknown')),
    metric_is_effort_sensitive   VARCHAR(5) CHECK (metric_is_effort_sensitive IN ('yes','no')),
    sampling_effort              DOUBLE,
    sampling_effort_unit         VARCHAR(20) CHECK (sampling_effort_unit IN ('camera_days','trap_nights','stations','days','unknown')),
    rescaled_sampling_effort     DOUBLE,
    measurement_value_standard   DOUBLE,
    measurement_unit_standard    VARCHAR(30),
    denominator                  VARCHAR(30),
    formula_reported             VARCHAR(200),
    uncertainty_type             VARCHAR(5) CHECK (uncertainty_type IN ('SE','SD','CI')),
    uncertainty_lower            DOUBLE,
    uncertainty_upper            DOUBLE,
    zero_record_interpretation   VARCHAR(20) CHECK (zero_record_interpretation IN ('true_zero','not_sampled','not_reported','unknown')),
    extraction_page              VARCHAR(50) NOT NULL,
    verification_status          VARCHAR(15) NOT NULL DEFAULT 'unverified' CHECK (verification_status IN ('verified','unverified'))
);

-- -----------------------------------------------------------------------------
-- 14. diversity_summary 样点多样性汇总表 (§5.14)
-- -----------------------------------------------------------------------------
CREATE TABLE diversity_summary (
    diversity_id                 VARCHAR(12) PRIMARY KEY,
    study_id                     VARCHAR(12) NOT NULL REFERENCES study(study_id),
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    taxonomic_scope              VARCHAR(25) NOT NULL CHECK (taxonomic_scope IN ('mammals','birds','all_camera_trappable','other')),
    species_richness_observed    INTEGER,
    shannon_index                DOUBLE,
    simpson_index                DOUBLE,
    total_independent_events     INTEGER,
    total_valid_photos           INTEGER,
    total_camera_days            DOUBLE,
    rarefied_richness            DOUBLE,
    functional_diversity         DOUBLE,
    phylogenetic_diversity       DOUBLE,
    source_metric_name           VARCHAR(100)
);

-- -----------------------------------------------------------------------------
-- 15. historical_expectation 历史预期表 (§5.15)
-- -----------------------------------------------------------------------------
CREATE TABLE historical_expectation (
    expectation_id               VARCHAR(12) PRIMARY KEY,
    species_id                   VARCHAR(12) NOT NULL REFERENCES taxonomy(species_id),
    spatial_unit_id              VARCHAR(20) NOT NULL,
    spatial_unit_type            VARCHAR(20) NOT NULL CHECK (spatial_unit_type IN ('site','grid','protected_area','county','ecoregion','mountain_system')),
    historically_expected        VARCHAR(10) NOT NULL CHECK (historically_expected IN ('yes','no','uncertain')),
    historical_source_id         VARCHAR(12),
    historical_source_type       VARCHAR(30) CHECK (historical_source_type IN ('monograph','museum','literature','map','protected_area_survey','expert','unknown')),
    historical_record_year       INTEGER,
    historical_period            VARCHAR(30),
    historical_locality          VARCHAR(200),
    locality_precision           VARCHAR(20) CHECK (locality_precision IN ('exact','county','protected_area','province','unknown')),
    baseline_scenario            VARCHAR(15) NOT NULL CHECK (baseline_scenario IN ('conservative','intermediate','broad')),
    historical_confidence        VARCHAR(10) NOT NULL CHECK (historical_confidence IN ('high','medium','low')),
    native_status                VARCHAR(15) CHECK (native_status IN ('native','introduced','domestic','uncertain')),
    expectation_notes            VARCHAR(500)
);

-- -----------------------------------------------------------------------------
-- 16. survey_adequacy_detection 调查充分性和探测表 (§5.16)
-- -----------------------------------------------------------------------------
CREATE TABLE survey_adequacy_detection (
    adequacy_id                  VARCHAR(12) PRIMARY KEY,
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    species_id                   VARCHAR(12),
    taxonomic_scope              VARCHAR(25) NOT NULL,
    camera_days                  DOUBLE,
    station_count                INTEGER,
    survey_duration_days         DOUBLE,
    survey_area_km2              DOUBLE,
    season_coverage              VARCHAR(20) CHECK (season_coverage IN ('single','multiple','full_year','unknown')),
    habitat_coverage_score       INTEGER CHECK (habitat_coverage_score BETWEEN 0 AND 3),
    effort_threshold_rule        VARCHAR(100) NOT NULL,
    adequate_for_inventory       VARCHAR(10) NOT NULL CHECK (adequate_for_inventory IN ('yes','no','uncertain')),
    adequate_for_species_group   VARCHAR(10) CHECK (adequate_for_species_group IN ('yes','no','uncertain')),
    detection_probability_estimate DOUBLE,
    detection_model_type         VARCHAR(30) CHECK (detection_model_type IN ('occupancy','hierarchical','community','expert_threshold','none')),
    detection_covariates_used    VARCHAR(100),
    adequacy_confidence          VARCHAR(10) NOT NULL CHECK (adequacy_confidence IN ('high','medium','low')),
    notes                        VARCHAR(500)
);

-- -----------------------------------------------------------------------------
-- 17. evidence_state 物种-地点证据状态表 (§5.17)
-- -----------------------------------------------------------------------------
CREATE TABLE evidence_state (
    evidence_id                  VARCHAR(12) PRIMARY KEY,
    species_id                   VARCHAR(12) NOT NULL REFERENCES taxonomy(species_id),
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    spatial_unit_id              VARCHAR(20) NOT NULL,
    baseline_scenario            VARCHAR(15) NOT NULL CHECK (baseline_scenario IN ('conservative','intermediate','broad')),
    historically_expected        VARCHAR(10) NOT NULL CHECK (historically_expected IN ('yes','no','uncertain')),
    contemporary_detected        VARCHAR(5) NOT NULL CHECK (contemporary_detected IN ('yes','no')),
    contemporary_evidence_type   VARCHAR(30) CHECK (contemporary_evidence_type IN ('camera_trap','complementary_survey','literature','mixed','unknown')),
    latest_detection_year        INTEGER,
    first_detection_year         INTEGER,
    independent_records          INTEGER,
    rai_per_100_camera_days      DOUBLE,
    occupancy_or_detection_corrected_value DOUBLE,
    survey_adequacy_status       VARCHAR(15) NOT NULL CHECK (survey_adequacy_status IN ('adequate','inadequate','uncertain')),
    evidence_state               VARCHAR(30) NOT NULL CHECK (evidence_state IN ('confirmed_persistence','silent_range','monitoring_gap','newly_confirmed_occurrence')),
    evidence_confidence          VARCHAR(10) NOT NULL CHECK (evidence_confidence IN ('high','medium','low')),
    state_reason                 VARCHAR(300),
    state_version                VARCHAR(10) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 18. reference_baseline_pair 参考比较表 (§5.18)
-- -----------------------------------------------------------------------------
CREATE TABLE reference_baseline_pair (
    pair_id                      VARCHAR(12) PRIMARY KEY,
    study_id                     VARCHAR(12) NOT NULL REFERENCES study(study_id),
    focal_site_id                VARCHAR(12) NOT NULL REFERENCES site(site_id),
    reference_site_id            VARCHAR(12) REFERENCES site(site_id),
    reference_type               VARCHAR(30) NOT NULL CHECK (reference_type IN ('primary_vegetation','minimally_disturbed','protected_core','historical_baseline','modelled_baseline')),
    pairing_basis                VARCHAR(40) CHECK (pairing_basis IN ('same_study','same_region','same_habitat','matched_covariates')),
    land_use_contrast            VARCHAR(100),
    management_contrast          VARCHAR(100),
    metric_id_focal              VARCHAR(12),
    metric_id_reference          VARCHAR(12),
    effect_size_type             VARCHAR(25) CHECK (effect_size_type IN ('log_response_ratio','difference','ratio')),
    effect_size_value            DOUBLE,
    zero_handling_rule           VARCHAR(25) CHECK (zero_handling_rule IN ('half_min_positive','offset','excluded','not_needed')),
    pair_confidence              VARCHAR(10) CHECK (pair_confidence IN ('high','medium','low'))
);

-- -----------------------------------------------------------------------------
-- 19. environmental_covariates 环境协变量表 (§5.19)
-- -----------------------------------------------------------------------------
CREATE TABLE environmental_covariates (
    covariate_id                 VARCHAR(12) PRIMARY KEY,
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    grid_id                      VARCHAR(20),
    covariate_name               VARCHAR(60) NOT NULL,
    covariate_value              DOUBLE NOT NULL,
    covariate_unit               VARCHAR(30),
    covariate_source             VARCHAR(40),
    covariate_year               INTEGER,
    spatial_resolution           VARCHAR(20),
    extraction_method            VARCHAR(20) CHECK (extraction_method IN ('point','buffer','overlay','zonal_stats','unknown'))
);

-- -----------------------------------------------------------------------------
-- 20. protected_area_context 保护地背景表 (§5.20)
-- -----------------------------------------------------------------------------
CREATE TABLE protected_area_context (
    pa_context_id                VARCHAR(12) PRIMARY KEY,
    site_id                      VARCHAR(12) NOT NULL REFERENCES site(site_id),
    protected_area_id            VARCHAR(30),
    protected_area_name          VARCHAR(150),
    pa_type                      VARCHAR(30) CHECK (pa_type IN ('nature_reserve','national_park','forest_park','wetland_park','scenic_area','other','unknown')),
    pa_level                     VARCHAR(15) CHECK (pa_level IN ('national','provincial','local','unknown')),
    inside_pa                    VARCHAR(10) NOT NULL DEFAULT 'unknown' CHECK (inside_pa IN ('yes','no','buffer','unknown')),
    distance_to_pa_boundary_m    DOUBLE,
    pa_establishment_year        INTEGER,
    management_zone              VARCHAR(20) CHECK (management_zone IN ('core','buffer','experimental','general','unknown')),
    ecological_redline_status    VARCHAR(15) CHECK (ecological_redline_status IN ('inside','outside','unknown'))
);

-- -----------------------------------------------------------------------------
-- 21. derived_index TW-CVII 派生指数表 (§5.21)
-- -----------------------------------------------------------------------------
CREATE TABLE derived_index (
    index_id                     VARCHAR(12) PRIMARY KEY,
    spatial_unit_id              VARCHAR(20) NOT NULL,
    spatial_unit_type            VARCHAR(20) NOT NULL CHECK (spatial_unit_type IN ('site','grid','protected_area','ecoregion','mountain_system')),
    taxonomic_scope              VARCHAR(25) NOT NULL,
    baseline_scenario            VARCHAR(15) NOT NULL CHECK (baseline_scenario IN ('conservative','intermediate','broad')),
    species_intactness           DOUBLE,
    detection_corrected_intactness DOUBLE,
    threat_weighted_intactness   DOUBLE,
    functional_intactness        DOUBLE,
    abundance_proxy_intactness   DOUBLE,
    silent_range_proportion      DOUBLE,
    monitoring_gap_proportion    DOUBLE,
    newly_confirmed_proportion   DOUBLE,
    expected_species_n           INTEGER,
    confirmed_species_n          INTEGER,
    adequately_surveyed_species_n INTEGER,
    index_rule_version           VARCHAR(15) NOT NULL,
    database_version             VARCHAR(25) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 22. extraction_audit 抽取审计表 (§5.22)
-- -----------------------------------------------------------------------------
CREATE TABLE extraction_audit (
    audit_id                     VARCHAR(12) PRIMARY KEY,
    source_id                    VARCHAR(12) NOT NULL REFERENCES source(source_id),
    file_id                      VARCHAR(20) NOT NULL,
    extraction_batch             VARCHAR(20) NOT NULL,
    extractor                    VARCHAR(15) NOT NULL CHECK (extractor IN ('human','codex','claude','other')),
    extraction_date              DATE NOT NULL,
    pages_checked                VARCHAR(100) NOT NULL,
    tables_checked               VARCHAR(100),
    figures_checked              VARCHAR(100),
    appendix_checked             VARCHAR(5) NOT NULL CHECK (appendix_checked IN ('yes','no')),
    supplement_checked           VARCHAR(5) NOT NULL CHECK (supplement_checked IN ('yes','no')),
    ocr_required                 VARCHAR(5) CHECK (ocr_required IN ('yes','no')),
    ocr_status                   VARCHAR(10) CHECK (ocr_status IN ('not_needed','pending','done','failed')),
    high_impact_fields_verified  VARCHAR(5) NOT NULL CHECK (high_impact_fields_verified IN ('yes','no')),
    unresolved_fields            VARCHAR(300),
    confidence                   VARCHAR(10) NOT NULL CHECK (confidence IN ('high','medium','low')),
    verifier                     VARCHAR(40),
    verification_date            DATE
);

-- -----------------------------------------------------------------------------
-- 23. issue_log 问题表 (§5.23)
-- -----------------------------------------------------------------------------
CREATE TABLE issue_log (
    issue_id                     VARCHAR(12) PRIMARY KEY,
    source_id                    VARCHAR(12),
    table_name                   VARCHAR(40) NOT NULL,
    record_id                    VARCHAR(20),
    issue_type                   VARCHAR(20) NOT NULL CHECK (issue_type IN ('missing','full_text','taxonomy','location','effort','metric','appendix','duplicate','license','other')),
    severity                     VARCHAR(10) NOT NULL CHECK (severity IN ('blocker','high','medium','low')),
    description                  VARCHAR(500) NOT NULL,
    proposed_resolution          VARCHAR(300),
    status                       VARCHAR(15) NOT NULL DEFAULT 'open' CHECK (status IN ('open','resolved','deferred','scoped_out')),
    resolved_by                  VARCHAR(40),
    resolved_date                DATE
);

-- =============================================================================
-- §6 Analysis-ready 视图（4 个）
-- =============================================================================

-- 6.1 view_species_site_evidence — RQ1/RQ2 历史预期与当代证据
CREATE VIEW view_species_site_evidence AS
SELECT
    e.evidence_id, e.species_id, e.site_id, e.spatial_unit_id, e.baseline_scenario,
    e.historically_expected, e.contemporary_detected, e.survey_adequacy_status,
    e.evidence_state, e.evidence_confidence, e.latest_detection_year,
    e.independent_records, e.rai_per_100_camera_days,
    t.chinese_name_standard, t.scientific_name_accepted, t."class", t."order", t.family,
    c.china_redlist_category, c.threat_weight,
    f.functional_group, f.body_size_class
FROM evidence_state e
LEFT JOIN taxonomy t              ON e.species_id = t.species_id
LEFT JOIN conservation_status c   ON e.species_id = c.species_id
LEFT JOIN functional_traits f     ON e.species_id = f.species_id;

-- 6.2 view_site_intactness_inputs — TW-CVII 指数计算输入
CREATE VIEW view_site_intactness_inputs AS
SELECT
    d.spatial_unit_id, d.spatial_unit_type, d.taxonomic_scope, d.baseline_scenario,
    d.species_intactness, d.threat_weighted_intactness, d.functional_intactness,
    d.detection_corrected_intactness, d.abundance_proxy_intactness,
    d.silent_range_proportion, d.monitoring_gap_proportion, d.newly_confirmed_proportion,
    d.expected_species_n, d.confirmed_species_n, d.adequately_surveyed_species_n,
    s.province, s.protected_area_name, s.spatial_unit_for_twcvii
FROM derived_index d
LEFT JOIN site s ON d.spatial_unit_id = s.site_id AND d.spatial_unit_type = 'site';

-- 6.3 view_pa_effectiveness_inputs — 保护区效力
CREATE VIEW view_pa_effectiveness_inputs AS
SELECT
    e.site_id, s.protected_area_name, s.province,
    COUNT(*) FILTER (WHERE e.evidence_state = 'confirmed_persistence') AS n_confirmed,
    COUNT(*) FILTER (WHERE e.evidence_state = 'silent_range')          AS n_silent,
    COUNT(*) FILTER (WHERE e.evidence_state = 'monitoring_gap')        AS n_gap,
    COUNT(*) AS n_total,
    AVG(c.threat_weight) AS mean_threat_weight
FROM evidence_state e
JOIN site s              ON e.site_id = s.site_id
LEFT JOIN conservation_status c ON e.species_id = c.species_id
GROUP BY e.site_id, s.protected_area_name, s.province;

-- 6.4 view_redlist_mismatch_inputs — 受威胁物种缺失优先级
CREATE VIEW view_redlist_mismatch_inputs AS
SELECT
    e.species_id, t.scientific_name_accepted, t.chinese_name_standard,
    c.china_redlist_category, c.threat_weight, f.functional_group,
    e.evidence_state, e.site_id, s.protected_area_name, s.province,
    e.survey_adequacy_status
FROM evidence_state e
JOIN taxonomy t              ON e.species_id = t.species_id
LEFT JOIN conservation_status c ON e.species_id = c.species_id
LEFT JOIN functional_traits f   ON e.species_id = f.species_id
JOIN site s                  ON e.site_id = s.site_id
WHERE e.evidence_state IN ('silent_range','monitoring_gap')
  AND c.china_redlist_category IN ('CR','EN','VU');

-- =============================================================================
-- 索引（加速常用查询）
-- =============================================================================
CREATE INDEX idx_study_source        ON study(source_id);
CREATE INDEX idx_site_study          ON site(study_id);
CREATE INDEX idx_site_province       ON site(province);
CREATE INDEX idx_site_pa             ON site(protected_area_name);
CREATE INDEX idx_deployment_site     ON deployment(site_id);
CREATE INDEX idx_measurement_site    ON species_site_measurement(site_id);
CREATE INDEX idx_measurement_species ON species_site_measurement(species_id);
CREATE INDEX idx_evidence_site       ON evidence_state(site_id);
CREATE INDEX idx_evidence_species    ON evidence_state(species_id);
CREATE INDEX idx_evidence_state      ON evidence_state(evidence_state);
CREATE INDEX idx_audit_source        ON extraction_audit(source_id);
CREATE INDEX idx_issue_status        ON issue_log(status);

-- 完毕。运行验证：
-- SELECT 'tables' AS kind, COUNT(*) FROM duckdb_tables() WHERE schema_name='main'
-- UNION ALL SELECT 'views', COUNT(*) FROM duckdb_views() WHERE schema_name='main';
