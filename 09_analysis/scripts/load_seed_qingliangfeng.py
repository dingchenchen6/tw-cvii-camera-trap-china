#!/usr/bin/env python3
"""Load the first open PDF seed extraction into workflow CSV templates.

The values loaded here are candidate extractions from Guo et al. 2022 and
must be human-verified before analysis-ready release.
"""

from __future__ import annotations

import csv
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TEMPLATE_DIR = ROOT / "08_database" / "templates"


SOURCE_ID = "SRC000001"
STUDY_ID = "STU000001"
OVERALL_SITE_ID = "SITE000001"


SPECIES = [
    ("SP000001", "东北刺猬", "Erinaceus amurensis", "Mammalia", "劳亚食虫目", "猬科", "", "LC", "", 18, 30, "0.10"),
    ("SP000002", "猕猴", "Macaca mulatta", "Mammalia", "灵长目", "猴科", "II", "LC", "LC", 14, 78, "0.25"),
    ("SP000003", "穿山甲", "Manis pentadactyla", "Mammalia", "鳞甲目", "鲮鲤科", "I", "CR", "CR", 1, 1, "0.003"),
    ("SP000004", "黄腹鼬", "Mustela kathiah", "Mammalia", "食肉目", "鼬科", "", "LC", "NT", 16, 45, "0.15"),
    ("SP000005", "黄鼬", "Mustela sibirica", "Mammalia", "食肉目", "鼬科", "", "LC", "LC", 22, 43, "0.14"),
    ("SP000006", "鼬獾", "Melogale moschata", "Mammalia", "食肉目", "鼬科", "", "LC", "NT", 14, 125, "0.40"),
    ("SP000007", "猪獾", "Arctonyx albogularis", "Mammalia", "食肉目", "鼬科", "", "LC", "NT", 104, 1211, "3.91"),
    ("SP000008", "果子狸", "Paguma larvata", "Mammalia", "食肉目", "灵猫科", "", "LC", "NT", 85, 755, "2.44"),
    ("SP000009", "豹猫", "Prionailurus bengalensis", "Mammalia", "食肉目", "猫科", "II", "LC", "VU", 1, 1, "0.003"),
    ("SP000010", "野猪", "Sus scrofa", "Mammalia", "鲸偶蹄目", "猪科", "", "LC", "LC", 101, 2283, "7.37"),
    ("SP000011", "小麂", "Muntiacus reevesi", "Mammalia", "鲸偶蹄目", "鹿科", "", "LC", "VU", 115, 7802, "25.17"),
    ("SP000012", "梅花鹿", "Cervus nippon", "Mammalia", "鲸偶蹄目", "鹿科", "I", "LC", "CR", 52, 1819, "5.87"),
    ("SP000013", "黑麂", "Muntiacus crinifrons", "Mammalia", "鲸偶蹄目", "鹿科", "I", "VU", "EN", 44, 367, "1.18"),
    ("SP000014", "中华鬣羚", "Capricornis milneedwardsii", "Mammalia", "鲸偶蹄目", "牛科", "II", "NT", "VU", 33, 98, "0.32"),
    ("SP000015", "赤腹松鼠", "Callosciurus erythraeus", "Mammalia", "啮齿目", "松鼠科", "", "", "", 18, 33, "0.11"),
    ("SP000016", "珀氏长吻松鼠", "Dremomys pernyi", "Mammalia", "啮齿目", "松鼠科", "", "LC", "LC", 6, 7, "0.02"),
    ("SP000017", "马来豪猪", "Hystrix brachyura", "Mammalia", "啮齿目", "豪猪科", "", "LC", "LC", 2, 3, "0.01"),
    ("SP000018", "华南兔", "Lepus sinensis", "Mammalia", "兔形目", "兔科", "", "LC", "LC", 60, 691, "2.23"),
    ("SP000019", "灰胸竹鸡", "Bambusicola thoracicus", "Aves", "鸡形目", "雉科", "", "LC", "LC", 9, 20, "0.06"),
    ("SP000020", "勺鸡", "Pucrasia macrolopha", "Aves", "鸡形目", "雉科", "II", "LC", "LC", 65, 254, "0.82"),
    ("SP000021", "白鹇", "Lophura nycthemera", "Aves", "鸡形目", "雉科", "II", "LC", "LC", 107, 1769, "5.71"),
    ("SP000022", "白颈长尾雉", "Syrmaticus ellioti", "Aves", "鸡形目", "雉科", "I", "NT", "VU", 32, 101, "0.33"),
    ("SP000023", "山斑鸠", "Streptopelia orientalis", "Aves", "鸽形目", "鸠鸽科", "", "LC", "LC", 13, 30, "0.10"),
    ("SP000024", "珠颈斑鸠", "Streptopelia chinensis", "Aves", "鸽形目", "鸠鸽科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000025", "红翅凤头鹃", "Clamator coromandus", "Aves", "鹃形目", "杜鹃科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000026", "四声杜鹃", "Cuculus micropterus", "Aves", "鹃形目", "杜鹃科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000027", "丘鹬", "Scolopax rusticola", "Aves", "鸻形目", "鹬科", "", "LC", "LC", 2, 2, "0.01"),
    ("SP000028", "蛇雕", "Spilornis cheela", "Aves", "鹰形目", "鹰科", "II", "LC", "NT", 1, 1, "0.003"),
    ("SP000029", "凤头鹰", "Accipiter trivirgatus", "Aves", "鹰形目", "鹰科", "II", "LC", "NT", 1, 1, "0.003"),
    ("SP000030", "苍鹰", "Accipiter gentilis", "Aves", "鹰形目", "鹰科", "II", "LC", "NT", 1, 1, "0.003"),
    ("SP000031", "斑头鸺鹠", "Glaucidium cuculoides", "Aves", "鸮形目", "鸱鸮科", "II", "LC", "LC", 1, 1, "0.003"),
    ("SP000032", "灰头绿啄木鸟", "Picus canus", "Aves", "啄木鸟目", "啄木鸟科", "", "LC", "LC", 15, 21, "0.07"),
    ("SP000033", "松鸦", "Garrulus glandarius", "Aves", "雀形目", "鸦科", "", "LC", "LC", 31, 54, "0.17"),
    ("SP000034", "红嘴蓝鹊", "Urocissa erythrorhyncha", "Aves", "雀形目", "鸦科", "", "LC", "LC", 32, 61, "0.20"),
    ("SP000035", "灰树鹊", "Dendrocitta formosae", "Aves", "雀形目", "鸦科", "", "LC", "LC", 12, 16, "0.05"),
    ("SP000036", "大山雀", "Parus cinereus", "Aves", "雀形目", "山雀科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000037", "发冠卷尾", "Dicrurus hottentottus", "Aves", "雀形目", "卷尾科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000038", "绿翅短脚鹎", "Ixos mcclellandii", "Aves", "雀形目", "鹎科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000039", "画眉", "Garrulax canorus", "Aves", "雀形目", "噪鹛科", "II", "LC", "NT", 7, 11, "0.04"),
    ("SP000040", "黑领噪鹛", "Garrulax pectoralis", "Aves", "雀形目", "噪鹛科", "", "LC", "LC", 35, 83, "0.27"),
    ("SP000041", "小黑领噪鹛", "Garrulax monileger", "Aves", "雀形目", "噪鹛科", "", "LC", "LC", 1, 2, "0.01"),
    ("SP000042", "棕噪鹛", "Garrulax berthemyi", "Aves", "雀形目", "噪鹛科", "II", "LC", "LC", 44, 168, "0.54"),
    ("SP000043", "红嘴相思鸟", "Leiothrix lutea", "Aves", "雀形目", "噪鹛科", "II", "LC", "LC", 2, 6, "0.02"),
    ("SP000044", "橙头地鸫", "Geokichla citina", "Aves", "雀形目", "鸫科", "", "LC", "LC", 2, 2, "0.01"),
    ("SP000045", "虎斑地鸫", "Zoothera aurea", "Aves", "雀形目", "鸫科", "", "LC", "LC", 15, 25, "0.08"),
    ("SP000046", "乌鸫", "Turdus mandarinus", "Aves", "雀形目", "鸫科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000047", "白腹鸫", "Turdus pallidus", "Aves", "雀形目", "鸫科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000048", "斑鸫", "Turdus eunomus", "Aves", "雀形目", "鸫科", "", "LC", "LC", 3, 4, "0.01"),
    ("SP000049", "红尾鸫", "Turdus naumanni", "Aves", "雀形目", "鸫科", "", "LC", "LC", 1, 6, "0.02"),
    ("SP000050", "紫啸鸫", "Myophonus caeruleus", "Aves", "雀形目", "鹟科", "", "LC", "LC", 30, 115, "0.37"),
    ("SP000051", "山麻雀", "Passer cinnamomeus", "Aves", "雀形目", "雀科", "", "LC", "LC", 1, 1, "0.003"),
    ("SP000052", "燕雀", "Fringilla montifringilla", "Aves", "雀形目", "燕雀科", "", "LC", "LC", 4, 8, "0.03"),
    ("SP000053", "三道眉草鹀", "Emberiza cioides", "Aves", "雀形目", "鹀科", "", "LC", "LC", 1, 2, "0.01"),
    ("SP000054", "黄眉鹀", "Emberiza chrysophrys", "Aves", "雀形目", "鹀科", "", "LC", "LC", 1, 1, "0.003"),
]


def write_rows(rel_path: str, rows: list[dict[str, object]]) -> None:
    path = ROOT / rel_path
    with path.open(newline="", encoding="utf-8-sig") as handle:
        header = list(csv.DictReader(handle).fieldnames or [])
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=header, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in header})


def template(name: str) -> str:
    return f"08_database/templates/{name}.csv"


def species_rows() -> tuple[list[dict[str, object]], list[dict[str, object]], list[dict[str, object]]]:
    taxonomy = []
    inventory = []
    measurements = []
    for idx, (species_id, chinese, scientific, taxon_class, order, family, protection, iucn, china_red, sites, records, rai) in enumerate(SPECIES, start=1):
        inventory_id = f"INV{idx:06d}"
        measurement_id = f"METSP{idx:06d}"
        taxonomy.append({
            "species_id": species_id,
            "taxon_name_entered": f"{chinese} {scientific}",
            "taxon_name_parsed": scientific,
            "scientific_name_accepted": scientific,
            "chinese_name_standard": chinese,
            "name_status": "accepted_candidate",
            "taxon_rank": "species",
            "kingdom": "Animalia",
            "phylum": "Chordata",
            "class": taxon_class,
            "order": order,
            "family": family,
            "genus": scientific.split()[0],
            "species": scientific.split()[1] if len(scientific.split()) > 1 else "",
            "best_guess_binomial": scientific,
            "taxonomy_source": "Guo et al. 2022 Table 2; taxonomy requires external checklist verification",
            "verification_status": "candidate"
        })
        inventory.append({
            "inventory_id": inventory_id,
            "source_id": SOURCE_ID,
            "study_id": STUDY_ID,
            "site_id": OVERALL_SITE_ID,
            "species_id": species_id,
            "species_original": f"{chinese} {scientific}",
            "chinese_name": chinese,
            "scientific_name_original": scientific,
            "scientific_name_accepted": scientific,
            "taxon_rank": "species",
            "class": taxon_class,
            "order": order,
            "family": family,
            "detection_confirmed": "yes",
            "independent_records": records,
            "valid_photos": records,
            "rai_original": rai,
            "rai_per_100_camera_days": rai,
            "china_redlist_category": china_red or "NR",
            "iucn_category": iucn or "NR",
            "national_protection_class": protection or "NA",
            "extraction_page": "PDF p.5-7; Table 2",
            "verification_status": "candidate"
        })
        measurements.append({
            "measurement_id": measurement_id,
            "source_id": SOURCE_ID,
            "study_id": STUDY_ID,
            "site_id": OVERALL_SITE_ID,
            "species_id": species_id,
            "taxon_name_entered": f"{chinese} {scientific}",
            "measurement": "relative_abundance_index",
            "metric_is_effort_sensitive": "yes",
            "sampling_effort": 30993,
            "sampling_effort_unit": "camera_days",
            "measurement_value_standard": rai,
            "measurement_unit_standard": "independent_records_per_100_camera_days",
            "denominator": "30993 camera-days",
            "formula_reported": "RAI = independent valid photos / all camera-days * 100",
            "extraction_page": "PDF p.4-7; Table 2",
            "verification_status": "candidate"
        })
    return taxonomy, inventory, measurements


def main() -> int:
    write_rows("01_search/search_log.csv", [
        {
            "search_id": "SEARCH000001",
            "date": "2026-06-14",
            "database_or_source": "journal website / web seed",
            "platform_access": "open web",
            "query_round": "R1 broad recall seed",
            "query": "浙江清凉峰 红外相机 鸟兽多样性 DOI PDF",
            "query_language": "zh",
            "result_count_observed": "PENDING",
            "records_exported": 1,
            "export_file": "manual seed; no RIS/BibTeX export yet",
            "deduplicated_count": 1,
            "status": "seed_completed",
            "notes": "Seed record used to test the executable workflow. Full CNKI/WoS/Wanfang/VIP searches remain pending."
        }
    ])
    write_rows("01_search/seed_records.csv", [
        {
            "seed_id": "SEED000001",
            "source_id": SOURCE_ID,
            "title": "利用红外相机技术调查浙江清凉峰国家级自然保护区的鸟兽多样性",
            "year": 2022,
            "language": "zh",
            "source": "浙江林业科技",
            "doi": "10.3969/j.issn.1001-3776.2022.06.010",
            "url": "https://zjlykj.xml-journal.net/cn/article/doi/10.3969/j.issn.1001-3776.2022.06.010",
            "why_seed": "Open PDF with camera count, camera-days, site areas, species inventory, RAI, disturbance and temporal coverage.",
            "full_text_status": "available",
            "supplement_status": "appendix_referenced_needs_check",
            "next_action": "Verify Table 2 species rows and inspect journal page for Appendix 1.",
            "provenance": "PDF downloaded and rendered locally; candidate extraction only."
        }
    ])
    write_rows("03_full_text/pdf_manifest.csv", [
        {
            "file_id": "FILE000001",
            "source_id": SOURCE_ID,
            "file_name": "SRC000001_qingliangfeng_2022.pdf",
            "file_path": "03_full_text/pdf/SRC000001_qingliangfeng_2022.pdf",
            "url": "https://zjlykj.xml-journal.net/cn/article/pdf/preview/10.3969/j.issn.1001-3776.2022.06.010.pdf",
            "download_date": "2026-06-14",
            "sha256": "8970e1773226dd89383516a64544a23ae8db99ac1810293a4c1d81f2b5be42e0",
            "file_type": "pdf",
            "full_text_status": "available",
            "ocr_status": "text_extracted_with_poppler",
            "text_extract_path": "03_full_text/text/SRC000001_qingliangfeng_2022.txt",
            "license_or_access_note": "Open journal PDF used for workflow seed; do not redistribute copyrighted text beyond project needs.",
            "notes": "10 pages; visual pages 2-4 checked."
        }
    ])
    write_rows("03_full_text/supplementary_manifest.csv", [
        {
            "supplement_id": "SUPP000001",
            "source_id": SOURCE_ID,
            "file_name": "Appendix 1 referenced in text",
            "file_path": "PENDING",
            "url": "PENDING",
            "download_date": "PENDING",
            "file_type": "appendix",
            "supplement_type": "species_list",
            "contains_species_list": "yes",
            "contains_deployment_data": "unknown",
            "contains_metrics": "unknown",
            "extraction_status": "needs_check",
            "notes": "PDF text references 附录 1 but appendix content was not found by text search."
        }
    ])
    write_rows("04_screening/screening_decisions.csv", [
        {
            "source_id": SOURCE_ID,
            "screening_stage": "full_text",
            "decision": "include_candidate",
            "decision_date": "2026-06-14",
            "reviewer": "Codex",
            "exclusion_reason": "NA",
            "include_for": "species_inventory; camera_days; RAI; disturbance; protected_area_case",
            "notes": "Candidate only; high-impact fields require human verification."
        }
    ])
    write_rows("05_extraction_raw/extraction_batch_manifest.csv", [
        {
            "batch_id": "BATCH000001",
            "date": "2026-06-14",
            "input_file_id": "FILE000001",
            "source_id": SOURCE_ID,
            "extractor": "Codex",
            "tool_or_model": "pdftotext + manual visual check",
            "prompt_version": "seed_v0",
            "output_folder": "08_database/templates",
            "status": "candidate_extracted",
            "notes": "Values extracted from PDF text and rendered pages; not human-verified."
        }
    ])

    write_rows(template("source"), [
        {
            "source_id": SOURCE_ID,
            "zotero_item_key": "PENDING_ZOTERO",
            "bibtex_key": "guo_diversity_2022_candidate",
            "title_original": "利用红外相机技术调查浙江清凉峰国家级自然保护区的鸟兽多样性",
            "title_english": "Diversity of Mammalia and Aves by Infrared Cameras in Zhejiang Qingliangfeng National Nature Reserve",
            "authors": "郭瑞; 雷福民; 王军旺; 许丽娟; 王旭池; 马天午; 徐爱春",
            "corresponding_author": "徐爱春",
            "affiliations": "浙江清凉峰国家级自然保护区管理局; 南京师范大学地理科学学院; 中国计量大学生命科学学院",
            "year": 2022,
            "publication_date": "2022",
            "journal_or_source": "浙江林业科技 / Journal of Zhejiang Forestry Science and Technology",
            "journal_volume": "42",
            "journal_issue": "6",
            "pages": "63-72",
            "issn": "1001-3776",
            "publication_type": "article",
            "doi": "10.3969/j.issn.1001-3776.2022.06.010",
            "url": "https://zjlykj.xml-journal.net/cn/article/doi/10.3969/j.issn.1001-3776.2022.06.010",
            "pdf_file_id": "FILE000001",
            "abstract": "2017年12月至2019年11月在浙江清凉峰国家级自然保护区布设115个相机位点监测鸟兽多样性。",
            "keywords": "红外相机; 兽类; 鸟类; 相对多度指数; 清凉峰国家级自然保护区",
            "language": "zh",
            "database_source": "journal_website_seed",
            "search_id_first_found": "SEARCH000001",
            "open_access_status": "open_pdf",
            "full_text_status": "available",
            "supplement_status": "appendix_referenced_needs_check",
            "has_appendix_species_list": "yes",
            "data_access_status": "extracted_from_pdf",
            "citation_text": "郭瑞等. 2022. 利用红外相机技术调查浙江清凉峰国家级自然保护区的鸟兽多样性. 浙江林业科技 42(6):63-72.",
            "reference_list_checked": "no",
            "screening_status": "included_candidate",
            "extraction_status": "ai_candidate",
            "source_quality_score": 2,
            "notes": "Zotero import pending because Zotero Desktop API is not currently running."
        }
    ])
    write_rows(template("study"), [
        {
            "study_id": STUDY_ID,
            "source_id": SOURCE_ID,
            "study_name": "浙江清凉峰国家级自然保护区鸟兽红外相机监测",
            "study_number_within_source": 1,
            "study_objective": "调查鸟兽多样性、重点保护动物分布和活动节律",
            "study_common_taxon": "Mammalia and Aves",
            "target_taxa": "Mammalia; Aves",
            "sampling_method": "camera_trap",
            "survey_design": "1 km x 1 km grid; one camera per grid where feasible",
            "methods_constant_within_study": "yes",
            "study_start_date_original": "2017年12月",
            "study_end_date_original": "2019年11月",
            "study_start_date": "2017-12",
            "study_end_date": "2019-11",
            "survey_years": "2017-2019",
            "survey_months": 24,
            "survey_duration_days": "NR",
            "sample_date_resolution": "month",
            "survey_season_scope": "multi-season",
            "total_camera_count_reported": 115,
            "total_station_count_reported": 115,
            "total_deployment_count": 115,
            "total_camera_days_reported": 30993,
            "total_area_reported": 11252,
            "area_unit_original": "hm2",
            "independent_event_threshold": "30 minutes for same species at same camera",
            "bait_lure_use": "NR",
            "extraction_page": "PDF p.3-4; sections 1.2.1-2.1; Table 1",
            "verification_status": "candidate"
        }
    ])

    blocks = [
        ("BLK000001", "千顷塘片区", "5690", "51", "13203", "10291", "15", "16", "31"),
        ("BLK000002", "龙塘山片区", "4482", "52", "15539", "7212", "16", "33", "49"),
        ("BLK000003", "顺溪坞片区", "1080", "12", "2251", "860", "12", "13", "25"),
    ]
    write_rows(template("block"), [
        {
            "block_id": block_id,
            "study_id": STUDY_ID,
            "block_name_original": name,
            "block_name_standard": name,
            "block_type": "protected_area_section",
            "spatial_clustering_reason": "Three disconnected sections of Zhejiang Qingliangfeng National Nature Reserve",
            "country": "China",
            "province": "Zhejiang",
            "prefecture": "Hangzhou",
            "county": "Lin'an District",
            "protected_area_name": "Zhejiang Qingliangfeng National Nature Reserve",
            "coordinate_precision": "range_reported_for_whole_reserve",
            "coordinate_source": "PDF p.2 section 1.1",
            "coordinate_datum": "NR",
            "location_source": "paper text",
            "extraction_page": "PDF p.2-4; Figure 1; Table 1",
            "verification_status": "candidate"
        } for block_id, name, *_ in blocks
    ])
    site_rows = [
        {
            "site_id": OVERALL_SITE_ID,
            "study_id": STUDY_ID,
            "site_name_original": "浙江清凉峰国家级自然保护区",
            "site_name_standard": "Zhejiang Qingliangfeng National Nature Reserve",
            "locality_original": "浙江省杭州市临安区; 千顷塘、龙塘山、顺溪坞三个片区",
            "protected_area_name": "Zhejiang Qingliangfeng National Nature Reserve",
            "country": "China",
            "province": "Zhejiang",
            "prefecture": "Hangzhou",
            "county": "Lin'an District",
            "latitude_original": "30°00′42″-30°19′33″N",
            "longitude_original": "118°50′57″-119°13′23″E",
            "latitude": "NR",
            "longitude": "NR",
            "coordinate_precision": "range_reported",
            "coordinate_source": "PDF p.2 section 1.1",
            "coordinate_datum": "NR",
            "geometry_type": "range",
            "location_source": "paper text",
            "coordinate_sensitive_flag": "yes",
            "coordinate_access_level": "protected_area_range_public; exact camera coordinates not published",
            "elevation_min_m": "399",
            "elevation_max_m": "1787.4",
            "habitat_type_original": "multiple forest vegetation types",
            "habitat_type_standard": "forest_mosaic",
            "survey_area_km2": "112.52",
            "protected_area_total_km2": "112.52",
            "protection_status": "national_nature_reserve",
            "management_zone": "NR",
            "spatial_unit_for_twcvii": "protected_area",
            "extraction_page": "PDF p.2-4; section 1.1; Table 1",
            "verification_status": "candidate"
        }
    ]
    for index, (block_id, name, area_hm2, cameras, camera_days, photos, mammals, birds, total_species) in enumerate(blocks, start=2):
        site_rows.append({
            "site_id": f"SITE{index:06d}",
            "study_id": STUDY_ID,
            "block_id": block_id,
            "site_name_original": name,
            "site_name_standard": name,
            "locality_original": name,
            "protected_area_section": name,
            "protected_area_name": "Zhejiang Qingliangfeng National Nature Reserve",
            "country": "China",
            "province": "Zhejiang",
            "prefecture": "Hangzhou",
            "county": "Lin'an District",
            "latitude": "NR",
            "longitude": "NR",
            "coordinate_precision": "section_only",
            "coordinate_source": "PDF Figure 1 map; no exact station coordinates",
            "coordinate_datum": "NR",
            "geometry_type": "section",
            "location_source": "paper text and Figure 1",
            "coordinate_sensitive_flag": "yes",
            "coordinate_access_level": "section_public; station_coordinates_not_published",
            "survey_area_km2": float(area_hm2) / 100,
            "protected_area_total_km2": "112.52",
            "protection_status": "national_nature_reserve",
            "spatial_unit_for_twcvii": "protected_area_section",
            "extraction_page": "PDF p.4; Table 1",
            "verification_status": "candidate"
        })
    write_rows(template("site"), site_rows)

    deployment_rows = [
        {
            "deployment_id": "DEP000001",
            "study_id": STUDY_ID,
            "site_id": OVERALL_SITE_ID,
            "station_id": "aggregate_115_stations",
            "station_name_original": "115 grid camera stations",
            "camera_model": "EREAGLE-E1B",
            "station_coordinate_precision": "not_published",
            "station_coordinate_source": "NR",
            "station_coordinate_datum": "NR",
            "sensitive_coordinate_flag": "yes",
            "deployment_start_original": "2017年12月",
            "deployment_end_original": "2019年11月",
            "deployment_start": "2017-12",
            "deployment_end": "2019-11",
            "deployment_date_resolution": "month",
            "camera_days": 30993,
            "grid_size_km": 1,
            "placement_type": "grid; trail/forest gap/water-pit low-interference locations",
            "microhabitat_original": "林木空旷处、兽道、水坑等人为干扰小的地方",
            "bait_lure_use": "NR",
            "season": "multi-season",
            "extraction_page": "PDF p.3-4; Table 1",
            "verification_status": "candidate"
        }
    ]
    for index, (block_id, name, _area_hm2, cameras, camera_days, _photos, *_rest) in enumerate(blocks, start=2):
        deployment_rows.append({
            "deployment_id": f"DEP{index:06d}",
            "study_id": STUDY_ID,
            "site_id": f"SITE{index:06d}",
            "station_id": f"aggregate_{name}",
            "station_name_original": f"{name} aggregate camera stations",
            "camera_model": "EREAGLE-E1B",
            "station_coordinate_precision": "not_published",
            "sensitive_coordinate_flag": "yes",
            "deployment_start_original": "2017年12月",
            "deployment_end_original": "2019年11月",
            "deployment_start": "2017-12",
            "deployment_end": "2019-11",
            "deployment_date_resolution": "month",
            "camera_days": camera_days,
            "grid_size_km": 1,
            "placement_type": "grid aggregate",
            "bait_lure_use": "NR",
            "season": "multi-season",
            "extraction_page": "PDF p.4; Table 1",
            "verification_status": "candidate"
        })
    write_rows(template("deployment"), deployment_rows)

    write_rows(template("diversity_summary"), [
        {"diversity_id": "DIV000001", "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "taxonomic_scope": "Mammalia", "species_richness_observed": 18, "total_independent_events": 18363, "total_valid_photos": 18363, "total_camera_days": 30993, "source_metric_name": "recorded mammal species total", "extraction_page": "PDF p.4; Table 1", "verification_status": "candidate"},
        {"diversity_id": "DIV000002", "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "taxonomic_scope": "Aves", "species_richness_observed": 36, "total_independent_events": 18363, "total_valid_photos": 18363, "total_camera_days": 30993, "source_metric_name": "recorded bird species total", "extraction_page": "PDF p.4; Table 1", "verification_status": "candidate"},
        {"diversity_id": "DIV000003", "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "taxonomic_scope": "Mammalia+Aves", "species_richness_observed": 54, "total_independent_events": 18363, "total_valid_photos": 18363, "total_camera_days": 30993, "source_metric_name": "recorded species total", "extraction_page": "PDF p.4; Table 1", "verification_status": "candidate"}
    ])
    write_rows(template("metrics"), [
        {"metric_id": "MET000001", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "metric_name_original": "相机工作日", "metric_name_standard": "camera_days", "metric_value_original": 30993, "metric_unit_original": "d", "metric_value_standard": 30993, "metric_unit_standard": "camera_days", "extraction_page": "PDF p.4; Table 1", "verification_status": "candidate"},
        {"metric_id": "MET000002", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "metric_name_original": "独立有效照片数", "metric_name_standard": "independent_valid_photos", "metric_value_original": 18363, "metric_unit_original": "photos", "metric_value_standard": 18363, "metric_unit_standard": "records", "extraction_page": "PDF p.4; Table 1", "verification_status": "candidate"},
        {"metric_id": "MET000003", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "metric_name_original": "相对多度指数公式", "metric_name_standard": "rai_formula", "metric_value_original": "RAI = 独立有效照片数 / 所有相机工作日 * 100", "metric_unit_original": "formula", "metric_value_standard": "NA", "metric_unit_standard": "formula", "denominator": "all camera-days", "formula_reported": "RAI = independent valid photos / all camera-days * 100", "extraction_page": "PDF p.4; section 1.2.3", "verification_status": "candidate"}
    ])
    write_rows(template("disturbance"), [
        {"disturbance_id": "DIS000001", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "disturbance_type_original": "牛 Bos taurus", "disturbance_type_standard": "livestock_cattle", "independent_records": 37, "valid_photos": 37, "rai_per_100_camera_days": "0.12", "extraction_page": "PDF p.7; Table 2", "verification_status": "candidate"},
        {"disturbance_id": "DIS000002", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "disturbance_type_original": "羊 Capra hircus", "disturbance_type_standard": "livestock_goat", "independent_records": 12, "valid_photos": 12, "rai_per_100_camera_days": "0.04", "extraction_page": "PDF p.7; Table 2", "verification_status": "candidate"},
        {"disturbance_id": "DIS000003", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "disturbance_type_original": "猫 Felis catus", "disturbance_type_standard": "domestic_cat", "independent_records": 3, "valid_photos": 3, "rai_per_100_camera_days": "0.01", "extraction_page": "PDF p.7; Table 2", "verification_status": "candidate"},
        {"disturbance_id": "DIS000004", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "disturbance_type_original": "狗 Canis lupus familiaris", "disturbance_type_standard": "domestic_dog", "independent_records": 13, "valid_photos": 13, "rai_per_100_camera_days": "0.04", "extraction_page": "PDF p.7; Table 2", "verification_status": "candidate"},
        {"disturbance_id": "DIS000005", "source_id": SOURCE_ID, "study_id": STUDY_ID, "site_id": OVERALL_SITE_ID, "disturbance_type_original": "人 Home species", "disturbance_type_standard": "human_activity", "independent_records": 36, "valid_photos": 36, "rai_per_100_camera_days": "0.12", "extraction_page": "PDF p.7; Table 2", "verification_status": "candidate"}
    ])
    write_rows(template("extraction_audit"), [
        {
            "audit_id": "AUD000001",
            "source_id": SOURCE_ID,
            "file_id": "FILE000001",
            "extraction_batch": "BATCH000001",
            "extractor": "Codex",
            "extraction_date": "2026-06-14",
            "pages_checked": "1-10 text; rendered pages 2-4",
            "tables_checked": "Table 1; Table 2 candidate",
            "figures_checked": "Figure 1 rendered",
            "appendix_checked": "no",
            "supplement_checked": "no",
            "high_impact_fields_verified": "no",
            "unresolved_fields": "Appendix 1; exact station coordinates; Zotero item key; external taxonomy validation",
            "confidence": "medium",
            "verifier": "PENDING",
            "verification_date": "PENDING"
        }
    ])
    write_rows(template("issue_log"), [
        {
            "issue_id": "ISSUE000001",
            "source_id": SOURCE_ID,
            "table_name": "source",
            "record_id": SOURCE_ID,
            "issue_type": "appendix_missing",
            "severity": "high",
            "description": "Paper references Appendix 1, but current PDF text extraction did not include appendix content.",
            "proposed_resolution": "Inspect journal HTML and supplementary links; download appendix if available.",
            "status": "open",
            "created_date": "2026-06-14",
            "owner": "project"
        },
        {
            "issue_id": "ISSUE000002",
            "source_id": SOURCE_ID,
            "table_name": "source",
            "record_id": SOURCE_ID,
            "issue_type": "zotero_pending",
            "severity": "medium",
            "description": "Zotero Desktop API was enabled but not running, so Zotero item key could not be assigned.",
            "proposed_resolution": "Start Zotero Desktop, import source, attach PDF, export BibTeX key.",
            "status": "open",
            "created_date": "2026-06-14",
            "owner": "project"
        },
        {
            "issue_id": "ISSUE000003",
            "source_id": SOURCE_ID,
            "table_name": "site",
            "record_id": OVERALL_SITE_ID,
            "issue_type": "coordinate_precision",
            "severity": "medium",
            "description": "Paper reports reserve coordinate range and station map but not exact camera station coordinates.",
            "proposed_resolution": "Keep exact station coordinates as NR unless supplementary data or author-provided data are available.",
            "status": "open",
            "created_date": "2026-06-14",
            "owner": "project"
        }
    ])

    taxonomy, inventory, measurements = species_rows()
    write_rows(template("taxonomy"), taxonomy)
    write_rows(template("species_inventory"), inventory)
    write_rows(template("species_site_measurement"), measurements)

    print(f"Loaded seed extraction for {SOURCE_ID}: {len(SPECIES)} species, 5 disturbance rows.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
