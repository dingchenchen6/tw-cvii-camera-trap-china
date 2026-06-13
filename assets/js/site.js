(function () {
  const content = window.TWCVII_CONTENT;
  const validModes = ["research", "workflow", "database", "analysis"];
  const app = document.getElementById("app");
  const footerText = document.getElementById("footerText");
  const languageToggle = document.getElementById("languageToggle");
  const tabs = Array.from(document.querySelectorAll(".mode-tab"));

  const state = {
    language: localStorage.getItem("twcvii-language") || "zh",
    mode: getInitialMode()
  };

  function getInitialMode() {
    const hash = window.location.hash.replace("#", "");
    return validModes.includes(hash) ? hash : "research";
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function setLanguage(language) {
    state.language = language;
    localStorage.setItem("twcvii-language", language);
    render();
  }

  function setMode(mode, updateHash = true) {
    if (!validModes.includes(mode)) return;
    state.mode = mode;
    if (updateHash && window.location.hash !== `#${mode}`) {
      history.pushState(null, "", `#${mode}`);
    }
    render();
  }

  function statCard(item) {
    return `
      <article class="stat-card">
        <strong>${escapeHtml(item.value)}</strong>
        <span>${escapeHtml(item.label)}</span>
        <p>${escapeHtml(item.detail)}</p>
      </article>
    `;
  }

  function sectionCard(item) {
    return `
      <article class="detail-card">
        <h3>${escapeHtml(item.title)}</h3>
        <p>${escapeHtml(item.text)}</p>
      </article>
    `;
  }

  function renderMatrix(mode) {
    if (!mode.matrix) return "";
    return `
      <section class="module-panel">
        <div class="section-heading">
          <p>${escapeHtml(mode.eyebrow)}</p>
          <h2>${escapeHtml(mode.diagramTitle)}</h2>
        </div>
        <div class="evidence-matrix">
          ${mode.matrix.map((row) => `
            <article class="evidence-row tone-${escapeHtml(row.tone)}">
              <div>
                <span class="state-pill">${escapeHtml(row.state)}</span>
                <h3>${escapeHtml(row.interpretation)}</h3>
              </div>
              <dl>
                <div><dt>Historical</dt><dd>${escapeHtml(row.historical)}</dd></div>
                <div><dt>Contemporary</dt><dd>${escapeHtml(row.contemporary)}</dd></div>
                <div><dt>Adequacy</dt><dd>${escapeHtml(row.adequacy)}</dd></div>
              </dl>
            </article>
          `).join("")}
        </div>
      </section>
    `;
  }

  function renderTimeline(mode) {
    if (!mode.timeline) return "";
    return `
      <section class="module-panel">
        <div class="section-heading">
          <p>${escapeHtml(mode.eyebrow)}</p>
          <h2>${escapeHtml(mode.diagramTitle)}</h2>
        </div>
        <div class="timeline">
          ${mode.timeline.map((item) => `
            <article class="timeline-item">
              <span>${escapeHtml(item.step)}</span>
              <h3>${escapeHtml(item.title)}</h3>
              <p>${escapeHtml(item.text)}</p>
            </article>
          `).join("")}
        </div>
        <div class="qa-strip">
          ${(mode.qa || []).map((item) => `<span>${escapeHtml(item)}</span>`).join("")}
        </div>
      </section>
    `;
  }

  function renderSchema(mode) {
    if (!mode.schemaGroups) return "";
    return `
      <section class="module-panel">
        <div class="section-heading">
          <p>${escapeHtml(mode.eyebrow)}</p>
          <h2>${escapeHtml(mode.diagramTitle)}</h2>
        </div>
        <div class="schema-grid">
          ${mode.schemaGroups.map((group) => `
            <article class="schema-card">
              <h3>${escapeHtml(group.layer)}</h3>
              <p>${escapeHtml(group.text)}</p>
              <div class="table-tags">
                ${group.tables.map((table) => `<code>${escapeHtml(table)}</code>`).join("")}
              </div>
            </article>
          `).join("")}
        </div>
      </section>
    `;
  }

  function renderAnalysis(mode) {
    if (!mode.analysisCards) return "";
    return `
      <section class="module-panel">
        <div class="section-heading">
          <p>${escapeHtml(mode.eyebrow)}</p>
          <h2>${escapeHtml(mode.diagramTitle)}</h2>
        </div>
        <div class="analysis-grid">
          ${mode.analysisCards.map((card) => `
            <article class="analysis-card">
              <span>${escapeHtml(card.metric)}</span>
              <h3>${escapeHtml(card.title)}</h3>
              <p>${escapeHtml(card.text)}</p>
            </article>
          `).join("")}
        </div>
        <div class="view-list">
          ${(mode.views || []).map((view) => `<code>${escapeHtml(view)}</code>`).join("")}
        </div>
      </section>
    `;
  }

  function renderModeVisual(mode) {
    return renderMatrix(mode) || renderTimeline(mode) || renderSchema(mode) || renderAnalysis(mode);
  }

  function renderSources(page, mode) {
    return `
      <section class="sources-panel">
        <div>
          <h2>${escapeHtml(page.sourcesTitle)}</h2>
          <p>${escapeHtml(page.dataBoundary)}</p>
        </div>
        <div class="source-tags">
          ${mode.sources.map((source) => `<span>${escapeHtml(source)}</span>`).join("")}
        </div>
      </section>
    `;
  }

  function render() {
    const page = content[state.language];
    const mode = page.modes[state.mode];
    document.documentElement.lang = state.language === "zh" ? "zh-CN" : "en";
    document.querySelector('[data-i18n="brandSub"]').textContent = page.brandSub;
    languageToggle.textContent = page.languageLabel;
    languageToggle.setAttribute("aria-pressed", state.language === "en" ? "true" : "false");
    footerText.textContent = page.footer;

    tabs.forEach((tab) => {
      const active = tab.dataset.mode === state.mode;
      tab.classList.toggle("active", active);
      tab.setAttribute("aria-selected", active ? "true" : "false");
      tab.setAttribute("tabindex", active ? "0" : "-1");
      tab.textContent = page.modes[tab.dataset.mode].label;
      if (active) app.setAttribute("aria-labelledby", tab.id);
    });

    app.innerHTML = `
      <section class="hero hero-${escapeHtml(state.mode)}">
        <div class="hero-copy">
          <p class="eyebrow">${escapeHtml(mode.eyebrow)}</p>
          <h1>${escapeHtml(mode.title)}</h1>
          <p class="hero-subtitle">${escapeHtml(mode.subtitle)}</p>
          <div class="hero-actions">
            <a href="#${escapeHtml(state.mode)}-primary" class="primary-action">${escapeHtml(mode.actionPrimary)}</a>
            <button class="secondary-action" type="button" data-next-mode="${escapeHtml(nextMode(state.mode))}">${escapeHtml(mode.actionSecondary)}</button>
          </div>
        </div>
        <div class="hero-visual" aria-hidden="true">
          <div class="map-frame">
            <span class="station station-a"></span>
            <span class="station station-b"></span>
            <span class="station station-c"></span>
            <span class="station station-d"></span>
            <div class="camera-card">
              <strong>TW-CVII</strong>
              <small>${escapeHtml(mode.label)}</small>
            </div>
          </div>
        </div>
      </section>
      <section class="stats-grid" id="${escapeHtml(state.mode)}-primary">
        ${mode.stats.map(statCard).join("")}
      </section>
      ${renderModeVisual(mode)}
      <section class="detail-grid">
        ${mode.sections.map(sectionCard).join("")}
      </section>
      ${renderSources(page, mode)}
    `;

    const secondaryAction = app.querySelector(".secondary-action");
    if (secondaryAction) {
      secondaryAction.addEventListener("click", () => setMode(secondaryAction.dataset.nextMode));
    }
  }

  function nextMode(mode) {
    const index = validModes.indexOf(mode);
    return validModes[(index + 1) % validModes.length];
  }

  languageToggle.addEventListener("click", () => {
    setLanguage(state.language === "zh" ? "en" : "zh");
  });

  tabs.forEach((tab) => {
    tab.addEventListener("click", () => setMode(tab.dataset.mode));
  });

  window.addEventListener("hashchange", () => {
    const mode = getInitialMode();
    setMode(mode, false);
  });

  render();
})();
