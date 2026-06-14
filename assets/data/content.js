window.TWCVII_CONTENT = {
  zh: {
    brandSub: "红外相机脊椎动物完整性",
    languageLabel: "中文 | EN",
    footer: "TW-CVII China 是一个公开学术项目站。原始全文、Zotero 本地数据和敏感坐标不在网站发布。",
    dataBoundary: "公开内容仅包括研究框架、工作流、字段规范、非敏感示例和分析计划；受限全文、原始相机文件、精确敏感点位和私人笔记不进入 GitHub Pages。",
    sourcesTitle: "参考框架",
    caseStudiesTitle: "执行案例与参考研究",
    caseStudiesSubtitle: "已进入本地候选数据库的 4 个种子案例用于验证字段和脚本；两篇 2026 全国尺度研究作为宏观参考和下一轮抽取目标，受限图件不公开复用。",
    caseStudies: [
      {
        tag: "已执行",
        title: "黄山九龙峰：物种照片、点位与活动节律",
        metrics: ["32 台相机", "7,964 相机日", "15 种哺乳动物"],
        text: "BDJ CC-BY 数据论文，已用于网站真实红外相机图像、点位图和活动节律图，并进入标准化数据库。",
        url: "https://doi.org/10.3897/BDJ.14.e184017"
      },
      {
        tag: "已执行",
        title: "雅鲁藏布大峡谷：人为干扰与物种关联",
        metrics: ["322 位点", "43,163 相机日", "17 个重点物种"],
        text: "eLife CC-BY 研究，提供高海拔大型/中型兽类、干扰梯度和充分调查样例。",
        url: "https://elifesciences.org/articles/92457"
      },
      {
        tag: "已执行",
        title: "海南尖峰岭：热带雨林哺乳动物编目",
        metrics: ["123 台相机", "41,571 相机日", "15 种哺乳动物"],
        text: "预印本记录中国穿山甲、海南麂、黑巨松鼠等关键物种，并突出人类活动与家犬干扰字段。",
        url: "https://doi.org/10.21203/rs.3.rs-6436787/v1"
      },
      {
        tag: "已执行",
        title: "秦岭佛坪：大熊猫核心栖息地鸟兽调查",
        metrics: ["130 台相机", "101,220 相机日", "29 种哺乳动物"],
        text: "中文 Biodiversity Science 案例，用于检验中文表格、附录物种清单和保护地字段抽取。",
        url: "https://www.biodiversity-science.net/EN/10.17520/biods.2019240"
      },
      {
        tag: "下一轮",
        title: "全国哺乳动物多样性格局与驱动因子",
        metrics: ["281 篇文献", "212 地点", "210 种哺乳动物"],
        text: "Liu et al. 2026 Biodiversity and Conservation，为分类、功能和系统发育多样性层提供全国尺度参照。",
        url: "https://doi.org/10.1007/s10531-025-03248-x"
      },
      {
        tag: "下一轮",
        title: "中国保护区食肉动物广泛分布收缩",
        metrics: ["85 个保护区", ">180 万相机日", "82 种哺乳动物"],
        text: "He et al. 2026 Nature Sustainability，用于校准历史基线、保护地绩效和 silent range 判读逻辑。",
        url: "https://www.nature.com/articles/s41893-026-01855-2"
      }
    ],
    modes: {
      research: {
        label: "Research",
        eyebrow: "研究框架",
        title: "威胁加权红外相机脊椎动物完整性指数",
        subtitle: "整合历史分布、当代红外相机证据、调查充分性、红色名录和功能性状，评估中国陆生脊椎动物群落是否仍保持可探测、可解释的生态完整性。",
        actionPrimary: "查看证据状态",
        actionSecondary: "进入数据库设计",
        heroImage: {
          src: "assets/media/huangshan-camera-trap-species.jpg",
          alt: "黄山九龙峰红外相机拍摄的九种哺乳动物拼图",
          caption: "真实红外相机物种影像 | Zhao et al. 2026 CC BY 4.0"
        },
        stats: [
          { value: "4", label: "证据状态", detail: "确认持续存在、沉默分布区、监测缺口、新确认分布" },
          { value: "5", label: "完整性维度", detail: "物种、探测校正、威胁加权、功能、丰度代理" },
          { value: "CN", label: "研究范围", detail: "中国红外相机文献、保护地和国家公园监测证据" }
        ],
        figuresTitle: "概念框架与真实影像",
        figuresSubtitle: "用原创框架图说明 TW-CVII 逻辑，用开放许可红外相机图像展示数据库需要捕捉的真实证据类型。",
        figures: [
          {
            kind: "Concept figure",
            title: "TW-CVII 概念框架图",
            src: "assets/media/twcvii-concept-framework.svg",
            alt: "TW-CVII 概念框架：历史基线、当代证据、调查充分性、权重层进入证据状态和完整性输出",
            text: "把历史预期、当代探测、调查充分性和威胁/功能权重分层，避免把未探测直接等同于消失。",
            credit: "本项目原创图"
          },
          {
            kind: "Camera-trap plate",
            title: "真实红外相机物种照片",
            src: "assets/media/huangshan-camera-trap-species.jpg",
            alt: "黄山九龙峰红外相机拍摄的鬣羚、麂、猪獾、果子狸、黑麂、藏酋猴、豪猪、食蟹獴和猕猴",
            text: "展示物种识别、图像证据、独立记录和 RAI 字段之间的连接。",
            credit: "Zhao et al. 2026, BDJ, CC BY 4.0"
          }
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
        subtitle: "多库检索、Zotero 知识库、OneFind 本地检索、AI 候选抽取、人工核验、清洗标准化、数据库冻结和论文写作审计，形成可复现的数据生产线；当前已落地 CSV 模板、验证脚本和第一篇候选抽取样例。",
        actionPrimary: "查看流程",
        actionSecondary: "查看质量门槛",
        heroImage: {
          src: "assets/media/huangshan-camera-network.jpg",
          alt: "黄山九龙峰保护区红外相机点位图",
          caption: "相机点位与空间单元 | Zhao et al. 2026 CC BY 4.0"
        },
        stats: [
          { value: "7+", label: "检索轮次", detail: "关键词、类群、RAI、努力量、保护地、干扰和追踪检索" },
          { value: "6", label: "质量门槛", detail: "从检索完整性到 analysis-ready 冻结" },
          { value: "Zotero", label: "知识库主入口", detail: "题录、全文、附件、标签和引用键统一管理" }
        ],
        figuresTitle: "技术流程与空间证据",
        figuresSubtitle: "从浏览器检索、题录导入、全文/附录下载到 Zotero/OneFind 知识库，再到 AI 候选抽取、人工核验和数据库冻结。",
        figures: [
          {
            kind: "Workflow figure",
            title: "文献到数据库技术流程图",
            src: "assets/media/twcvii-technical-workflow.svg",
            alt: "红外相机文献到数据库的技术流程图",
            text: "将 Web of Science/CNKI 导出、Zotero、OneFind、Codex/Claude 候选抽取、人工核验和 DuckDB/SQLite 发布串成可执行管线。",
            credit: "本项目原创图"
          },
          {
            kind: "Spatial evidence",
            title: "相机点位图与地点字段",
            src: "assets/media/huangshan-camera-network.jpg",
            alt: "黄山九龙峰自然保护区红外相机监测点位地图",
            text: "提醒抽取时必须记录地名、经纬度、坐标精度、保护地名称、面积、海拔和空间单元。",
            credit: "Zhao et al. 2026, BDJ, CC BY 4.0"
          }
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
          { title: "跨表必保字段", text: "经纬度（WGS84+精度码）、文献溯源信息（标题/作者/年/DOI/语言/检索批次）、精确时间（起止日期/相机工作日/时间戳/活动节律）属跨表高优先字段，即便文献只给汇总值也要尽量还原或显式标注精度，缺失必须用缺失码记录。" },
          { title: "审计链", text: "每个最终字段都保留 source_id、PDF/CAJ/附录文件、页码或表号、抽取批次、抽取工具、核验人和数据库版本。" },
          { title: "可执行底座", text: "仓库已包含标准 CSV 表头、关键字段字典、AI 抽取 prompt、workflow 验证器、SQLite 构建脚本和清凉峰文章 candidate 级样例，并保留远程 R/DuckDB 主流程。" }
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
        heroImage: {
          src: "assets/media/twcvii-field-architecture.svg",
          alt: "红外相机数据库字段架构图",
          caption: "Source-Study-Site-Measurement + Camtrap DP + TW-CVII"
        },
        stats: [
          { value: "26", label: "核心表", detail: "从来源、研究、地点、相机布设到证据状态和指数输出" },
          { value: "4", label: "字段等级", detail: "Mandatory、High priority、Optional、Derived" },
          { value: "52", label: "种子物种记录", detail: "4 篇种子文献已进入 analysis-ready 候选库，仍保留核验标记" }
        ],
        figuresTitle: "字段架构与标准化骨架",
        figuresSubtitle: "把文献信息、地点、时间、相机努力量、物种记录、保护状态、历史基线和证据状态拆成可审计的关系表。",
        figures: [
          {
            kind: "Schema figure",
            title: "红外相机字段架构图",
            src: "assets/media/twcvii-field-architecture.svg",
            alt: "TW-CVII 数据库标准字段架构图",
            text: "经纬度、地名、时间、文献信息、相机日、相机数量、物种名录和 RAI 均作为跨表关键字段保留。",
            credit: "本项目原创图"
          }
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
          { title: "关键字段族", text: "每条记录必须尽量连接文献信息、地名、经纬度、坐标精度、监测起止时间、相机数量、相机工作日、监测面积、物种清单、独立记录、RAI/多度指标和字段级证据来源。" },
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
        heroImage: {
          src: "assets/media/huangshan-nocturnal-index.jpg",
          alt: "黄山九龙峰七种重点物种夜行相对多度指数图",
          caption: "活动节律与指数示例 | Zhao et al. 2026 CC BY 4.0"
        },
        stats: [
          { value: "4", label: "分析视图", detail: "species-site evidence、intactness inputs、PA effectiveness、Red List mismatch" },
          { value: "3", label: "基线情景", detail: "conservative、intermediate、broad historical baselines" },
          { value: "QA", label: "可复核输出", detail: "每个图表连接数据库版本、脚本版本和证据来源" }
        ],
        figuresTitle: "分析图表与顶刊案例参照",
        figuresSubtitle: "将单篇文献中的活动节律、RAI 和调查充分性扩展到全国尺度的 evidence-state 与保护区绩效分析。",
        figures: [
          {
            kind: "Analysis example",
            title: "活动节律与 NRAI 示例",
            src: "assets/media/huangshan-nocturnal-index.jpg",
            alt: "七种重点物种夜行指数柱状图",
            text: "活动节律图提示数据库需要保留时间戳、昼夜判定、月份/季节和物种功能类群字段。",
            credit: "Zhao et al. 2026, BDJ, CC BY 4.0"
          },
          {
            kind: "National reference",
            title: "全国保护区分布收缩案例",
            src: "assets/media/twcvii-concept-framework.svg",
            alt: "TW-CVII 概念框架用于解释全国保护区分布收缩案例",
            text: "He et al. 2026 的历史-当代比较为 silent range、保护地绩效和大型食肉动物恢复困境提供方法参照。",
            credit: "本项目原创图；He et al. 2026 仅作引用参照"
          }
        ],
        diagramTitle: "分析框架",
        analysisCards: [
          { title: "物种-地点证据矩阵", metric: "H_ij, C_ij, E_j", text: "连接历史预期、当代探测、调查充分性和证据状态。" },
          { title: "完整性指数", metric: "TW-CVII", text: "计算物种、探测校正、威胁加权、功能和丰度代理完整性。" },
          { title: "保护区绩效", metric: "PA comparison", text: "比较保护区内外或不同管理强度下的完整性差异。" },
          { title: "监测优先级", metric: "Gap ranking", text: "识别 silent range、monitoring gap 和红色名录不一致物种。" }
        ],
        sections: [
          { title: "调查充分性量化阈值", text: "区分 silent range 与 monitoring gap 的临时最低标准：中型食肉动物 ≥1000 相机日且 ≥15 位点、大型食肉动物 ≥5000 相机日且 ≥30 位点跨 12 个月、中型有蹄类与地栖鸟类 ≥600–800 相机日且 ≥10–12 位点；阈值基于累计探测概率曲线并做敏感性分析。" },
          { title: "红色名录权重与 DD 物种", text: "主权重序列采用几何级数 LC=1、NT=2、VU=4、EN=8、CR=16；DD（数据缺乏）物种不进入主分母，而作为独立的知识赤字覆盖指数分析层。" },
          { title: "气候位移过滤分类器", text: "用 1950s–2020s 气候常态判断空间单元气候包络是否移出物种历史热生态位；若 silent range 落在气候已显著漂移的单元，标记为 climate_explainable，与人为去动物化区分。" }
        ],
        views: ["view_species_site_evidence", "view_site_intactness_inputs", "view_pa_effectiveness_inputs", "view_redlist_mismatch_inputs"],
        sources: ["TW-CVII proposal", "Occupancy modelling", "Protected-area matching", "Red List sensitivity", "He et al. 2026", "Liu et al. 2026"]
      }
    }
  },
  en: {
    brandSub: "Camera-trap vertebrate intactness",
    languageLabel: "中文 | EN",
    footer: "TW-CVII China is a public academic project website. Raw full texts, local Zotero data, and sensitive coordinates are not published here.",
    dataBoundary: "Public content includes the research framework, workflow, schema, non-sensitive examples, and analysis plan only; restricted full texts, raw camera files, exact sensitive locations, and private notes are not published on GitHub Pages.",
    sourcesTitle: "Reference frameworks",
    caseStudiesTitle: "Executed Cases and Reference Studies",
    caseStudiesSubtitle: "Four seed papers are already represented in the local candidate database for field and script testing; two 2026 national-scale studies are registered as macro-reference and next-round extraction targets.",
    caseStudies: [
      {
        tag: "Executed",
        title: "Huangshan Jiulongfeng: species images, sites, activity",
        metrics: ["32 cameras", "7,964 camera-days", "15 mammal species"],
        text: "A CC-BY Biodiversity Data Journal data paper used for the website camera-trap image plate, site map, activity plot, and standardized database seed.",
        url: "https://doi.org/10.3897/BDJ.14.e184017"
      },
      {
        tag: "Executed",
        title: "Yarlung Zangbo Grand Canyon: disturbance associations",
        metrics: ["322 stations", "43,163 camera-days", "17 focus species"],
        text: "An eLife CC-BY study providing a high-effort mountain mammal and disturbance-covariate example.",
        url: "https://elifesciences.org/articles/92457"
      },
      {
        tag: "Executed",
        title: "Jianfengling: tropical-rainforest mammal inventory",
        metrics: ["123 cameras", "41,571 camera-days", "15 mammal species"],
        text: "A preprint documenting Chinese pangolin, Hainan muntjac, black giant squirrel, and human/dog disturbance fields.",
        url: "https://doi.org/10.21203/rs.3.rs-6436787/v1"
      },
      {
        tag: "Executed",
        title: "Foping Qinling: bird and mammal survey in panda habitat",
        metrics: ["130 cameras", "101,220 camera-days", "29 mammals"],
        text: "A Chinese Biodiversity Science case for testing Chinese tables, appendix species lists, and protected-area fields.",
        url: "https://www.biodiversity-science.net/EN/10.17520/biods.2019240"
      },
      {
        tag: "Next round",
        title: "Mainland China mammal diversity patterns and drivers",
        metrics: ["281 articles", "212 sites", "210 mammal species"],
        text: "Liu et al. 2026 in Biodiversity and Conservation provides national-scale taxonomic, functional, and phylogenetic diversity reference logic.",
        url: "https://doi.org/10.1007/s10531-025-03248-x"
      },
      {
        tag: "Next round",
        title: "Carnivore range contraction in Chinese protected areas",
        metrics: ["85 protected areas", ">1.8 million camera-days", "82 mammal species"],
        text: "He et al. 2026 in Nature Sustainability informs historical baselines, protected-area effectiveness, and silent-range interpretation.",
        url: "https://www.nature.com/articles/s41893-026-01855-2"
      }
    ],
    modes: {
      research: {
        label: "Research",
        eyebrow: "Research framework",
        title: "Threat-weighted Camera-trap Vertebrate Intactness Index",
        subtitle: "Integrating historical distributions, contemporary camera-trap evidence, survey adequacy, Red List status, and functional traits to evaluate evidence-based vertebrate intactness in China.",
        actionPrimary: "View evidence states",
        actionSecondary: "Open database design",
        heroImage: {
          src: "assets/media/huangshan-camera-trap-species.jpg",
          alt: "Nine mammal species photographed by camera traps in Huangshan Jiulongfeng",
          caption: "Camera-trap species imagery | Zhao et al. 2026 CC BY 4.0"
        },
        stats: [
          { value: "4", label: "Evidence states", detail: "Confirmed persistence, silent range, monitoring gap, newly confirmed occurrence" },
          { value: "5", label: "Intactness dimensions", detail: "Species, detection-corrected, threat-weighted, functional, abundance-proxy" },
          { value: "CN", label: "Study system", detail: "Chinese camera-trap literature, protected areas, and national park monitoring evidence" }
        ],
        figuresTitle: "Concept Framework and Camera-trap Evidence",
        figuresSubtitle: "Original project diagrams explain the TW-CVII logic, while open-licensed camera-trap images show the evidence types the database must preserve.",
        figures: [
          {
            kind: "Concept figure",
            title: "TW-CVII concept framework",
            src: "assets/media/twcvii-concept-framework.svg",
            alt: "TW-CVII concept framework linking historical baselines, contemporary evidence, survey adequacy, weighting layers, evidence states, and intactness outputs",
            text: "The framework separates historical expectation, contemporary detection, survey adequacy, and threat/functional weighting before classifying evidence states.",
            credit: "Original TW-CVII project diagram"
          },
          {
            kind: "Camera-trap plate",
            title: "Real camera-trap species photographs",
            src: "assets/media/huangshan-camera-trap-species.jpg",
            alt: "Camera-trap photographs of serow, muntjac, hog badger, masked palm civet, black muntjac, Tibetan macaque, Malayan porcupine, crab-eating mongoose, and rhesus macaque",
            text: "The image plate illustrates why species ID, image evidence, independent events, and RAI fields need linked provenance.",
            credit: "Zhao et al. 2026, BDJ, CC BY 4.0"
          }
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
        subtitle: "Multi-database search, Zotero knowledge base, OneFind retrieval, AI-assisted candidate extraction, human verification, cleaning, database freeze, and manuscript audit. CSV templates, validation scripts, and the first candidate extraction seed are now implemented.",
        actionPrimary: "View pipeline",
        actionSecondary: "View QA gates",
        heroImage: {
          src: "assets/media/huangshan-camera-network.jpg",
          alt: "Camera-trap station map for Huangshan Jiulongfeng Nature Reserve",
          caption: "Camera stations and spatial units | Zhao et al. 2026 CC BY 4.0"
        },
        stats: [
          { value: "7+", label: "Search rounds", detail: "Keywords, taxa, RAI, effort, protected areas, disturbance, and citation chasing" },
          { value: "6", label: "Quality gates", detail: "From search completeness to analysis-ready database freeze" },
          { value: "Zotero", label: "Knowledge hub", detail: "Metadata, full text, supplements, tags, and citation keys in one system" }
        ],
        figuresTitle: "Technical Workflow and Spatial Evidence",
        figuresSubtitle: "The executable workflow links browser search, citation exports, full-text and appendix intake, Zotero/OneFind, AI extraction, human verification, and database release.",
        figures: [
          {
            kind: "Workflow figure",
            title: "Literature-to-database technical workflow",
            src: "assets/media/twcvii-technical-workflow.svg",
            alt: "Technical workflow from camera-trap literature search to database and manuscript audit",
            text: "The workflow turns CNKI/WoS exports, Zotero, OneFind, Codex/Claude extraction, human verification, and DuckDB/SQLite release into one auditable pipeline.",
            credit: "Original TW-CVII project diagram"
          },
          {
            kind: "Spatial evidence",
            title: "Camera-station map and locality fields",
            src: "assets/media/huangshan-camera-network.jpg",
            alt: "Map of infrared camera-trap stations in Huangshan Jiulongfeng Nature Reserve",
            text: "The map highlights the need to extract locality names, coordinates, coordinate precision, protected-area name, area, elevation, and spatial unit.",
            credit: "Zhao et al. 2026, BDJ, CC BY 4.0"
          }
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
          { title: "Cross-table must-keep fields", text: "Coordinates (WGS84 with precision code), citation provenance (title/authors/year/DOI/language/search batch), and precise time (start/end dates, camera-days, timestamps, activity patterns) are cross-table high-priority fields; even when a paper reports only summary values they must be recovered or explicitly precision-flagged, and any gap recorded with a missing code." },
          { title: "Audit chain", text: "Every final field keeps source_id, PDF/CAJ/appendix file, page or table number, extraction batch, extraction tool, verifier, and database version." },
          { title: "Executable base", text: "The repository now includes standardized CSV headers, a critical field dictionary, AI extraction prompt, workflow validator, SQLite builder, a Qingliangfeng candidate seed, and the remote R/DuckDB main pipeline." }
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
        heroImage: {
          src: "assets/media/twcvii-field-architecture.svg",
          alt: "Camera-trap database field architecture diagram",
          caption: "Source-Study-Site-Measurement + Camtrap DP + TW-CVII"
        },
        stats: [
          { value: "26", label: "Core tables", detail: "From sources, studies, sites, and deployments to evidence states and derived indices" },
          { value: "4", label: "Field tiers", detail: "Mandatory, high priority, optional, and derived fields" },
          { value: "52", label: "Seed species records", detail: "Four seed sources are represented in the analysis-ready candidate database with verification flags" }
        ],
        figuresTitle: "Field Architecture and Standardization Spine",
        figuresSubtitle: "Citation metadata, locality, time, camera effort, species records, protection status, historical baselines, and evidence states are stored in auditable relational tables.",
        figures: [
          {
            kind: "Schema figure",
            title: "Camera-trap field architecture",
            src: "assets/media/twcvii-field-architecture.svg",
            alt: "TW-CVII standardized camera-trap field architecture",
            text: "Coordinates, place names, dates, citation metadata, camera-days, camera counts, species inventories, and RAI are kept as cross-table priority fields.",
            credit: "Original TW-CVII project diagram"
          }
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
          { title: "Critical field families", text: "Each record should connect citation metadata, place name, coordinates, coordinate precision, monitoring start/end dates, camera counts, camera-days, survey area, species inventory, independent events, RAI/abundance metrics, and field-level provenance." },
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
        heroImage: {
          src: "assets/media/huangshan-nocturnal-index.jpg",
          alt: "Nocturnal relative abundance index chart for seven focal species in Huangshan Jiulongfeng",
          caption: "Activity and index example | Zhao et al. 2026 CC BY 4.0"
        },
        stats: [
          { value: "4", label: "Analysis views", detail: "Species-site evidence, intactness inputs, PA effectiveness, Red List mismatch" },
          { value: "3", label: "Baseline scenarios", detail: "Conservative, intermediate, and broad historical baselines" },
          { value: "QA", label: "Auditable outputs", detail: "Each figure links to database version, script version, and evidence source" }
        ],
        figuresTitle: "Analysis Examples and High-impact References",
        figuresSubtitle: "Single-paper activity, RAI, and survey-adequacy fields scale into national evidence-state, intactness, and protected-area performance analyses.",
        figures: [
          {
            kind: "Analysis example",
            title: "Activity rhythm and NRAI example",
            src: "assets/media/huangshan-nocturnal-index.jpg",
            alt: "Bar chart of nocturnal relative abundance index values for seven focal species",
            text: "Activity-rhythm plots show why timestamps, day/night classification, month/season, and functional guild fields must be preserved.",
            credit: "Zhao et al. 2026, BDJ, CC BY 4.0"
          },
          {
            kind: "National reference",
            title: "National protected-area range-contraction reference",
            src: "assets/media/twcvii-concept-framework.svg",
            alt: "TW-CVII framework used to interpret national protected-area range-contraction studies",
            text: "He et al. 2026 informs the logic for historical baselines, protected-area effectiveness, and silent-range interpretation.",
            credit: "Original TW-CVII diagram; He et al. 2026 cited as reference only"
          }
        ],
        diagramTitle: "Analysis framework",
        analysisCards: [
          { title: "Species-site evidence matrix", metric: "H_ij, C_ij, E_j", text: "Connect historical expectation, contemporary detection, survey adequacy, and evidence state." },
          { title: "Intactness indices", metric: "TW-CVII", text: "Calculate species, detection-corrected, threat-weighted, functional, and abundance-proxy intactness." },
          { title: "Protected-area performance", metric: "PA comparison", text: "Compare intactness inside and outside protected areas or across management intensities." },
          { title: "Monitoring priorities", metric: "Gap ranking", text: "Identify silent ranges, monitoring gaps, and Red List mismatch species." }
        ],
        sections: [
          { title: "Quantified survey-adequacy thresholds", text: "Provisional minima for separating silent range from monitoring gap: mesocarnivores ≥1,000 camera-days and ≥15 stations; large carnivores ≥5,000 camera-days and ≥30 stations across ≥12 months; medium ungulates and ground-dwelling birds ≥600–800 camera-days and ≥10–12 stations; thresholds derived from cumulative detection-probability curves with sensitivity analysis." },
          { title: "Red List weights and DD species", text: "The primary weighting scheme is geometric (LC=1, NT=2, VU=4, EN=8, CR=16); Data Deficient species are excluded from the main denominator and analysed as a separate Data-Deficiency Coverage Index." },
          { title: "Climate-shift filter", text: "Using 1950s–2020s climate normals, silent ranges in spatial units whose climate envelope has shifted beyond a species' historical thermal niche are flagged as climate-explainable, separating climate-driven repositioning from anthropogenic defaunation." }
        ],
        views: ["view_species_site_evidence", "view_site_intactness_inputs", "view_pa_effectiveness_inputs", "view_redlist_mismatch_inputs"],
        sources: ["TW-CVII proposal", "Occupancy modelling", "Protected-area matching", "Red List sensitivity", "He et al. 2026", "Liu et al. 2026"]
      }
    }
  }
};
