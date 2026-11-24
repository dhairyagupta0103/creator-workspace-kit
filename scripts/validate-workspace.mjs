#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import path from "node:path";

const readJson = file => JSON.parse(readFileSync(file, "utf8"));
const fail = message => { console.error("Validation failed: " + message); process.exit(1); };
const validId = value => typeof value === "string" && /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(value);
const validVersion = value => typeof value === "string" && /^\d+\.\d+\.\d+$/.test(value);
const registry = readJson("projects/index.json");
const portfolio = readJson("portfolio/portfolio.json");
const preferences = readJson("creator/preferences.json");
if (registry.schema_version !== 1 || !Array.isArray(registry.projects)) fail("Invalid projects/index.json.");
if (portfolio.schema_version !== 1 || !Array.isArray(portfolio.projects)) fail("Invalid portfolio/portfolio.json.");
if (preferences.schema_version !== 1 || !preferences.preferences || typeof preferences.preferences !== "object") fail("Invalid creator/preferences.json.");

const seen = new Set();
for (const entry of registry.projects) {
  if (!validId(entry.id) || seen.has(entry.id)) fail("Invalid or duplicate project ID: " + entry.id);
  seen.add(entry.id);
  const dir = path.join("projects", entry.id);
  for (const file of ["project.json", "README.md", "PROGRESS.md", "CHANGELOG.md", "index.html", "styles.css", "app.js"]) {
    if (!existsSync(path.join(dir, file))) fail(dir + " is missing " + file);
  }
  const project = readJson(path.join(dir, "project.json"));
  if (project.id !== entry.id || !validVersion(project.current_version)) fail("Invalid metadata: " + entry.id);
  if (!["idea", "experiment", "building", "paused", "released"].includes(project.status)) fail("Invalid status: " + entry.id);
  if (entry.title !== project.title || entry.current_version !== project.current_version) fail("Catalogue is out of sync: " + entry.id);
}
const selected = new Set();
for (const item of portfolio.projects) {
  if (!validId(item.project_id) || !seen.has(item.project_id)) fail("Portfolio references an unknown project: " + item.project_id);
  if (selected.has(item.project_id)) fail("Portfolio has duplicate selection: " + item.project_id);
  selected.add(item.project_id);
  if (!validVersion(item.version)) fail("Invalid portfolio version: " + item.project_id);
  const tag = "project/" + item.project_id + "/v" + item.version;
  if (item.tag !== tag) fail("Expected portfolio tag " + tag);
  if (!item.title || !item.summary || !item.category) fail("Portfolio entry needs title, summary and category.");
  try { execFileSync("git", ["cat-file", "-e", tag + ":projects/" + item.project_id + "/index.html"], { stdio: "ignore" }); }
  catch { fail("Tag does not contain project files: " + tag); }
}
for (const entry of readdirSync("projects", { withFileTypes: true }).filter(item => item.isDirectory() && item.name !== "_template")) {
  if (!seen.has(entry.name)) fail("Unregistered project folder: " + entry.name);
}
console.log("Workspace valid: " + registry.projects.length + " project(s), " + portfolio.projects.length + " release(s).");
