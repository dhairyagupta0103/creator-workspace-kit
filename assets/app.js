const root = document.querySelector("#project-grid");
const empty = document.querySelector("#empty-state");
const escapeHTML = value => String(value ?? "").replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
async function load() {
  try {
    const response = await fetch("./portfolio/portfolio.json", { cache: "no-store" });
    if (!response.ok) throw new Error("Portfolio unavailable");
    const data = await response.json();
    if (data.schema_version !== 1 || !Array.isArray(data.projects)) throw new Error("Invalid portfolio");
    root.innerHTML = data.projects.map(project =>
      '<article><p class="eyebrow">' + escapeHTML(project.category) + ' · v' + escapeHTML(project.version) + '</p><h3>' +
      escapeHTML(project.title) + '</h3><p>' + escapeHTML(project.summary) + '</p><a href="./projects/' +
      encodeURIComponent(project.project_id) + '/">Open project ↗</a></article>'
    ).join("");
    empty.hidden = data.projects.length > 0;
  } catch (error) {
    empty.textContent = "The project list could not load. Refresh to try again.";
    console.error(error);
  }
}
load();
