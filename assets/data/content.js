window.TWCVII_CONTENT = {
  zh: {
    brandSub: "红外相机脊椎动物完整性",
    languageLabel: "中文 | EN",
    footer: "TW-CVII China 是一个公开学术项目站。原始全文、Zotero 本地数据和敏感坐标不在网站发布。",
    dataBoundary: "公开内容仅包括研究框架、工作流、字段规范、非敏感示例和分析计划；受限全文、原始相机文件、精确敏感点位和私人笔记不进入 GitHub Pages。",
    sourcesTitle: "参考框架",
    modes: {
      research: {
        label: "Research",
        eyebrow: "研究框架",
        title: "威胁加权红外相机脊椎动物完整性指数",
        subtitle: "整合历史分布、当代红外相机证据、调查充分性、红色名录和功能性状，评估中国陆生脊椎动物群落是否仍保持可探测、可解释的生态完整性。",
        actionPrimary: "查看证据状态",
        actionSecondary: "进入数据库设计",
        stats: [
          { value: "4", label: "证据状态", detail: "确认持续存在、沉默分布区、监测缺口、新确认分布" },
          { value: "5", label: "完整性维度", detail: "物种、探测校正、威胁加权、功能、丰度代理" },
          { value: "CN", label: "研究范围", detail: "中国红外相机文献、保护地和国家公园监测证据" }
        ],
        diagramTitle: "物种-地点证据判定",
        matrix: [
          { state: "confirmed persistence", historical: "历史预期存在", contemporary: "当代探测到", adequacy: "任意充分性", interpretation: "物种仍有当代持续存在证据。", tone: "teal" },
          { state: "silent range", historical: "历史预期存在", contemporary: "未探测到", adequacy: "调查充分", interpretation: "可能局地消失、严重衰退或低密度沉默。", tone: "rust" },
          { state: "monitoring gap", historical: "历史预期存在", contemporary: "未探测或未知", adequacy: "调查不足", interpretation: "不能判断是否仍存在，需要加强监测。", tone: "amber" },
          { state: "newly confirmed occurrence", historical: "未预期或不确定", contemporary: "当代探测到", adequacy: "任意充分性", interpretation: "新记录、范围扩张、历史漏记或基线错误。", tone: "moss" }
        ],
        sections: [
          { title: "总体目标", text: "建立一个全国尺度、调查信息化、威胁加权的脊椎动物完整性框架，用当代红外相机记录、补充生态调查、历史分布基线和国家红色名录评估历史预期物种是否仍然存在。" },
          { title: "核心问题", text: "区分真正值得警惕的 silent range 与因调查不足造成的 monitoring gap，避免把未探测直接解释为局地灭绝，也避免把历史分布图上的物种默认视为仍然存在。" },
          { title: "研究输出", text: "生成物种完整性、探测校正完整性、威胁加权完整性、功能完整性和丰度代理完整性，并识别保护地绩效、隐藏去动物化热点和监测优先区域。" }
        ],
        sources: ["Proposal: TW-CVII China", "PREDICTS", "DiVert", "Camtrap DP", "China Red List"]
      },
      workflow: {
        label: "Workflow",
        eyebrow: "标准工作流",
        title: "从文献检索到标准化数据库",
        subtitle: "多库检索、Zotero 知识库、OneFind 本地检索、AI 候选抽取、人工核验、清洗标准化、数据库冻结和论文写作审计，形成可复现的数据生产线。",
        actionPrimary: "查看流程",
        actionSecondary: "查看质量门槛",
        stats: [
          { value: "7+", label: "检索轮次", detail: "关键词、类群、RAI、努力量、保护地、干扰和追踪检索" },
          { value: "6", label: "质量门槛", detail: "从检索完整性到 analysis-ready 冻结" },
          { value: "Zotero", label: "知识库主入口", detail: "题录、全文、附件、标签和引用键统一管理" }
        ],
        diagramTitle: "研究生产线",
        timeline: [
          { step: "01", title: "文献检索", text: "Web of Science、知网、万方、维普、Google Scholar、期刊站点和引文追踪。" },
          { step: "02", title: "下载与入库", text: "授权全文、PDF/CAJ、补充材料和附录统一登记，进入 Zotero collection。" },
          { step: "03", title: "本地知识库", text: "Zotero 与 OneFind 支撑全文检索、证据定位和跨文献问答。" },
          { step: "04", title: "AI 候选抽取", text: "Codex/Claude 从正文、表格、图注和附录生成候选结构化表。" },
          { step: "05", title: "人工核验", text: "相机数、相机工作日、监测时段、地点、面积、物种清单和 RAI 必须核验。" },
          { step: "06", title: "清洗与发布", text: "分类学、日期、坐标、面积、RAI、缺失码和外键标准化，冻结数据库版本。" }
        ],
        sections: [
          { title: "检索策略", text: "中文和英文关键词必须多轮组合，覆盖红外相机、自动相机、相机陷阱、物种编目、相对多度指数、相机工作日、保护区、国家公园、人类干扰和类群关键词。" },
          { title: "附录优先", text: "红外相机文章的物种名录、独立记录、RAI、相机工作日和地点信息常在附录或补充 Excel 中，抽取前必须登记并检查所有附件。" },
          { title: "审计链", text: "每个最终字段都保留 source_id、PDF/CAJ/附录文件、页码或表号、抽取批次、抽取工具、核验人和数据库版本。" }
        ],
        qa: ["检索完整性", "Zotero 入库", "全文和附录", "结构化抽取", "清洗标准化", "分析前冻结"],
        sources: ["Zotero", "OneFind", "Web of Science", "CNKI", "GBIF camera-trap guide"]
      },
      database: {
        label: "Database",
        eyebrow: "标准化数据库",
        title: "PREDICTS / DiVert / Camtrap DP 对齐的红外相机数据库",
        subtitle: "以 Source-Study-Block-Site-Measurement 为生态层级，以 deployment-media-observation 为红外相机技术骨架，并加入 TW-CVII 的历史预期和证据状态表。",
        actionPrimary: "查看表结构",
        actionSecondary: "查看分析视图",
        stats: [
          { value: "20+", label: "核心表", detail: "从来源、研究、地点、相机布设到证据状态和指数输出" },
          { value: "4", label: "字段等级", detail: "Mandatory、High priority、Optional、Derived" },
          { value: "5", label: "缺失码", detail: "NR、NA、UNK、PENDING、EXTRACTED_UNVERIFIED" }
        ],
        diagramTitle: "关系型数据库层级",
        schemaGroups: [
          { layer: "Evidence source", tables: ["source", "search_record", "extraction_audit", "issue_log"], text: "保存文献、检索、附件、抽取批次和审计证据。" },
          { layer: "Study and site", tables: ["study", "block", "site", "land_use_management", "protected_area_context"], text: "对齐 PREDICTS 和 DiVert 的研究、空间区组、土地利用和管理实践。" },
          { layer: "Camera-trap core", tables: ["deployment", "media", "observation", "independent_event"], text: "兼容 Camtrap DP 的部署、媒体、观测和独立事件骨架。" },
          { layer: "Species and traits", tables: ["taxonomy", "conservation_status", "functional_traits", "species_site_measurement"], text: "把物种记录与红色名录、保护等级和功能性状连接。" },
          { layer: "TW-CVII analysis", tables: ["historical_expectation", "survey_adequacy_detection", "evidence_state", "derived_index"], text: "生成 silent range、monitoring gap 和完整性指数。" }
        ],
        sections: [
          { title: "PREDICTS 层级", text: "Source -> Study -> Block -> Site -> Measurement 让不同文献、地点和采样设计能被清楚比较，并支持研究层级随机效应。" },
          { title: "DiVert 兼容", text: "数据库记录主要土地利用、利用强度、放牧、道路、人为干扰、管理实践和参考基线，支持保护区内外或低干扰-高干扰比较。" },
          { title: "TW-CVII 扩展", text: "历史预期、调查充分性、红色名录权重和功能权重不手工塞进物种表，而是作为可审计、可复算的分析层。" }
        ],
        sources: ["camera_trap_database_schema_predicts_divert_twcvii.md", "PREDICTS", "DiVert", "Camtrap DP"]
      },
      analysis: {
        label: "Analysis",
        eyebrow: "统计分析",
        title: "把数据库转化为 TW-CVII 研究输出",
        subtitle: "支持 silent range、monitoring gap、威胁加权完整性、功能完整性、保护区比较和红色名录一致性分析；当前展示为分析框架，不代表最终结果。",
        actionPrimary: "查看分析模块",
        actionSecondary: "查看研究输出",
        stats: [
          { value: "4", label: "分析视图", detail: "species-site evidence、intactness inputs、PA effectiveness、Red List mismatch" },
          { value: "3", label: "基线情景", detail: "conservative、intermediate、broad historical baselines" },
          { value: "QA", label: "可复核输出", detail: "每个图表连接数据库版本、脚本版本和证据来源" }
        ],
        diagramTitle: "分析框架",
        analysisCards: [
          { title: "物种-地点证据矩阵", metric: "H_ij, C_ij, E_j", text: "连接历史预期、当代探测、调查充分性和证据状态。" },
          { title: "完整性指数", metric: "TW-CVII", text: "计算物种、探测校正、威胁加权、功能和丰度代理完整性。" },
          { title: "保护区绩效", metric: "PA comparison", text: "比较保护区内外或不同管理强度下的完整性差异。" },
          { title: "监测优先级", metric: "Gap ranking", text: "识别 silent range、monitoring gap 和红色名录不一致物种。" }
        ],
        sections: [
          { title: "占域和探测校正", text: "在数据允许时使用占域或层级模型处理未探测问题；数据不足时使用透明的调查充分性阈值和敏感性分析。" },
          { title: "保护区比较", text: "结合保护地边界、土地利用、人类足迹、海拔和气候协变量，评估保护区是否维持更高威胁加权和功能完整性。" },
          { title: "论文连接", text: "每篇论文冻结 database_version、analysis_script_version、figure_list、claim_table 和 references snapshot，实现声明-证据审计。" }
        ],
        views: ["view_species_site_evidence", "view_site_intactness_inputs", "view_pa_effectiveness_inputs", "view_redlist_mismatch_inputs"],
        sources: ["TW-CVII proposal", "Occupancy modelling", "Protected-area matching", "Red List sensitivity"]
      }
    }
  },
  en: {
    brandSub: "Camera-trap vertebrate intactness",
    languageLabel: "中文 | EN",
    footer: "TW-CVII China is a public academic project website. Raw full texts, local Zotero data, and sensitive coordinates are not published here.",
    dataBoundary: "Public content includes the research framework, workflow, schema, non-sensitive examples, and analysis plan only; restricted full texts, raw camera files, exact sensitive locations, and private notes are not published on GitHub Pages.",
    sourcesTitle: "Reference frameworks",
    modes: {
      research: {
        label: "Research",
        eyebrow: "Research framework",
        title: "Threat-weighted Camera-trap Vertebrate Intactness Index",
        subtitle: "Integrating historical distributions, contemporary camera-trap evidence, survey adequacy, Red List status, and functional traits to evaluate evidence-based vertebrate intactness in China.",
        actionPrimary: "View evidence states",
        actionSecondary: "Open database design",
        stats: [
          { value: "4", label: "Evidence states", detail: "Confirmed persistence, silent range, monitoring gap, newly confirmed occurrence" },
          { value: "5", label: "Intactness dimensions", detail: "Species, detection-corrected, threat-weighted, functional, abundance-proxy" },
          { value: "CN", label: "Study system", detail: "Chinese camera-trap literature, protected areas, and national park monitoring evidence" }
        ],
        diagramTitle: "Species-by-site evidence classification",
        matrix: [
          { state: "confirmed persistence", historical: "Historically expected", contemporary: "Detected today", adequacy: "Any adequate level", interpretation: "The species has contemporary evidence of persistence.", tone: "teal" },
          { state: "silent range", historical: "Historically expected", contemporary: "Not detected", adequacy: "Adequately surveyed", interpretation: "Possible local extirpation, severe depletion, or low-density silence.", tone: "rust" },
          { state: "monitoring gap", historical: "Historically expected", contemporary: "Not detected or unknown", adequacy: "Inadequate survey", interpretation: "Persistence cannot be inferred; targeted monitoring is needed.", tone: "amber" },
          { state: "newly confirmed occurrence", historical: "Not expected or uncertain", contemporary: "Detected today", adequacy: "Any adequate level", interpretation: "New record, range expansion, historical under-recording, or baseline error.", tone: "moss" }
        ],
        sections: [
          { title: "Overall aim", text: "Develop a national-scale, survey-informed, threat-weighted vertebrate intactness framework using contemporary camera-trap evidence, complementary surveys, historical distributions, and Red List assessments." },
          { title: "Core challenge", text: "Separate silent ranges from monitoring gaps, avoiding both overinterpreting non-detections and assuming that species remain present merely because they appear on historical maps." },
          { title: "Research outputs", text: "Produce species, detection-corrected, threat-weighted, functional, and abundance-proxy intactness profiles while identifying protected-area performance, hidden defaunation hotspots, and monitoring priorities." }
        ],
        sources: ["TW-CVII proposal", "PREDICTS", "DiVert", "Camtrap DP", "China Red List"]
      },
      workflow: {
        label: "Workflow",
        eyebrow: "Standard workflow",
        title: "From literature search to standardized database",
        subtitle: "Multi-database search, Zotero knowledge base, OneFind retrieval, AI-assisted candidate extraction, human verification, cleaning, database freeze, and manuscript audit.",
        actionPrimary: "View pipeline",
        actionSecondary: "View QA gates",
        stats: [
          { value: "7+", label: "Search rounds", detail: "Keywords, taxa, RAI, effort, protected areas, disturbance, and citation chasing" },
          { value: "6", label: "Quality gates", detail: "From search completeness to analysis-ready database freeze" },
          { value: "Zotero", label: "Knowledge hub", detail: "Metadata, full text, supplements, tags, and citation keys in one system" }
        ],
        diagramTitle: "Research production line",
        timeline: [
          { step: "01", title: "Literature search", text: "Web of Science, CNKI, Wanfang, VIP, Google Scholar, journal sites, and citation chasing." },
          { step: "02", title: "Full text intake", text: "Authorized PDFs/CAJ files, supplementary materials, and appendices are registered in Zotero." },
          { step: "03", title: "Local knowledge base", text: "Zotero and OneFind support full-text retrieval, evidence location, and cross-paper search." },
          { step: "04", title: "AI candidate extraction", text: "Codex or Claude generates structured candidate tables from text, tables, captions, and appendices." },
          { step: "05", title: "Human verification", text: "Camera counts, camera-days, survey period, location, area, species lists, and RAI are verified." },
          { step: "06", title: "Clean and release", text: "Taxonomy, dates, coordinates, area, RAI, missing codes, and foreign keys are standardized." }
        ],
        sections: [
          { title: "Search strategy", text: "Chinese and English keywords must cover camera traps, species inventories, relative abundance indices, camera-days, protected areas, national parks, human disturbance, and target taxa." },
          { title: "Appendix-first extraction", text: "Species lists, independent events, RAI, camera-days, and locality details are often in appendices or supplementary Excel files, so all attachments must be registered and inspected." },
          { title: "Audit chain", text: "Every final field keeps source_id, PDF/CAJ/appendix file, page or table number, extraction batch, extraction tool, verifier, and database version." }
        ],
        qa: ["Search completeness", "Zotero integrity", "Full text and appendix", "Structured extraction", "Standardization", "Analysis freeze"],
        sources: ["Zotero", "OneFind", "Web of Science", "CNKI", "GBIF camera-trap guide"]
      },
      database: {
        label: "Database",
        eyebrow: "Standardized database",
        title: "A PREDICTS / DiVert / Camtrap DP-aligned camera-trap database",
        subtitle: "Combining Source-Study-Block-Site-Measurement ecological structure with deployment-media-observation camera-trap structure and TW-CVII evidence-state tables.",
        actionPrimary: "View schema",
        actionSecondary: "View analysis views",
        stats: [
          { value: "20+", label: "Core tables", detail: "From sources, studies, sites, and deployments to evidence states and derived indices" },
          { value: "4", label: "Field tiers", detail: "Mandatory, high priority, optional, and derived fields" },
          { value: "5", label: "Missing codes", detail: "NR, NA, UNK, PENDING, EXTRACTED_UNVERIFIED" }
        ],
        diagramTitle: "Relational database layers",
        schemaGroups: [
          { layer: "Evidence source", tables: ["source", "search_record", "extraction_audit", "issue_log"], text: "Track literature, search, attachments, extraction batches, and audit evidence." },
          { layer: "Study and site", tables: ["study", "block", "site", "land_use_management", "protected_area_context"], text: "Align study design, spatial blocks, land use, and management practices with PREDICTS and DiVert logic." },
          { layer: "Camera-trap core", tables: ["deployment", "media", "observation", "independent_event"], text: "Represent deployments, media, observations, and independent events in a Camtrap DP-compatible structure." },
          { layer: "Species and traits", tables: ["taxonomy", "conservation_status", "functional_traits", "species_site_measurement"], text: "Connect species records to taxonomy, Red List status, protection class, and functional traits." },
          { layer: "TW-CVII analysis", tables: ["historical_expectation", "survey_adequacy_detection", "evidence_state", "derived_index"], text: "Generate silent ranges, monitoring gaps, and intactness indices." }
        ],
        sections: [
          { title: "PREDICTS hierarchy", text: "Source -> Study -> Block -> Site -> Measurement makes heterogeneous literature, localities, and sampling designs comparable while supporting study-level random effects." },
          { title: "DiVert compatibility", text: "The database records land use, use intensity, grazing, roads, human disturbance, management practices, and reference baselines for low- versus high-disturbance comparisons." },
          { title: "TW-CVII extension", text: "Historical expectation, survey adequacy, Red List weights, and functional weights are stored as auditable analytical layers rather than being hidden inside species tables." }
        ],
        sources: ["camera_trap_database_schema_predicts_divert_twcvii.md", "PREDICTS", "DiVert", "Camtrap DP"]
      },
      analysis: {
        label: "Analysis",
        eyebrow: "Statistical analysis",
        title: "Turning the database into TW-CVII research outputs",
        subtitle: "Supporting silent-range, monitoring-gap, threat-weighted intactness, functional intactness, protected-area comparison, and Red List mismatch analyses. This page shows the analysis framework, not final results.",
        actionPrimary: "View analysis modules",
        actionSecondary: "View outputs",
        stats: [
          { value: "4", label: "Analysis views", detail: "Species-site evidence, intactness inputs, PA effectiveness, Red List mismatch" },
          { value: "3", label: "Baseline scenarios", detail: "Conservative, intermediate, and broad historical baselines" },
          { value: "QA", label: "Auditable outputs", detail: "Each figure links to database version, script version, and evidence source" }
        ],
        diagramTitle: "Analysis framework",
        analysisCards: [
          { title: "Species-site evidence matrix", metric: "H_ij, C_ij, E_j", text: "Connect historical expectation, contemporary detection, survey adequacy, and evidence state." },
          { title: "Intactness indices", metric: "TW-CVII", text: "Calculate species, detection-corrected, threat-weighted, functional, and abundance-proxy intactness." },
          { title: "Protected-area performance", metric: "PA comparison", text: "Compare intactness inside and outside protected areas or across management intensities." },
          { title: "Monitoring priorities", metric: "Gap ranking", text: "Identify silent ranges, monitoring gaps, and Red List mismatch species." }
        ],
        sections: [
          { title: "Occupancy and detection correction", text: "When data allow, occupancy or hierarchical models address non-detection; otherwise transparent survey-adequacy thresholds and sensitivity analyses are used." },
          { title: "Protected-area comparison", text: "Protected-area boundaries, land use, human footprint, elevation, and climate covariates support tests of whether protected landscapes maintain higher threat-weighted and functional intactness." },
          { title: "Manuscript connection", text: "Each paper freezes database_version, analysis_script_version, figure_list, claim_table, and reference snapshots to make claims auditable." }
        ],
        views: ["view_species_site_evidence", "view_site_intactness_inputs", "view_pa_effectiveness_inputs", "view_redlist_mismatch_inputs"],
        sources: ["TW-CVII proposal", "Occupancy modelling", "Protected-area matching", "Red List sensitivity"]
      }
    }
  }
};

