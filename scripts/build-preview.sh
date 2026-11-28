#!/usr/bin/env bash
set -euo pipefail
node scripts/validate-workspace.mjs
rm -rf _preview
mkdir -p _preview/projects _preview/shared _preview/functions
cp -R shared/. _preview/shared/

for project_dir in projects/*; do
  [ -d "$project_dir" ] || continue
  project_id="$(basename "$project_dir")"
  [ "$project_id" = "_template" ] && continue
  mkdir -p "_preview/projects/$project_id"
  cp -R "$project_dir/." "_preview/projects/$project_id/"
  if [ -d "$project_dir/functions" ]; then
    outside_api="$(find "$project_dir/functions" -type f ! -path "$project_dir/functions/api/*" -print -quit)"
    if [ -n "$outside_api" ]; then
      echo "Pages Functions must be placed under $project_dir/functions/api/ (found $outside_api)"
      exit 1
    fi
    mkdir -p "_preview/functions/projects/$project_id"
    cp -R "$project_dir/functions/." "_preview/functions/projects/$project_id/"
  fi
done

if find _preview/functions -type f -print -quit | grep -q .; then
  cat > _preview/_routes.json <<'JSON'
{"version":1,"include":["/projects/*/api","/projects/*/api/*"],"exclude":[]}
JSON
fi

python3 - <<'PY'
from html import escape
from pathlib import Path
import json
import re

cards = []
for metadata_path in sorted(Path("_preview/projects").glob("*/project.json")):
    project = json.loads(metadata_path.read_text(encoding="utf-8"))
    project_id = metadata_path.parent.name
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", project_id):
        raise SystemExit(f"Invalid project ID: {project_id}")
    title = escape(str(project.get("title", project_id)))
    summary = escape(str(project.get("summary", "")))
    href = f"projects/{project_id}/index.html"
    cards.append(f'<li><a href="{escape(href, quote=True)}">{title}</a><p>{summary}</p></li>')

page = """<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Workspace Preview</title><style>
body{font:16px system-ui,sans-serif;max-width:800px;margin:48px auto;padding:0 20px;color:#202938;background:#f4f6fa}
main{background:white;padding:32px;border-radius:18px}li{margin:18px 0}a{color:#24548a;font-weight:700}p{color:#596579}
</style></head><body><main><h1>Workspace Preview</h1><p>Unreleased branch preview. Changes here are not part of the public portfolio.</p><ul>""" + "".join(cards) + """</ul></main></body></html>"""
Path("_preview/index.html").write_text(page, encoding="utf-8")
PY
