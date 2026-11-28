#!/usr/bin/env bash
set -euo pipefail

before="${GITHUB_EVENT_BEFORE:?GITHUB_EVENT_BEFORE is required}"
after="${GITHUB_SHA:?GITHUB_SHA is required}"
portfolio_changed=false

if [[ "$before" =~ ^0+$ ]]; then
  mapfile -t requests < <(git diff-tree --root --no-commit-id --name-only -r "$after" -- releases/requests | grep -E '^releases/requests/[^/]+\.json$' || true)
else
  mapfile -t requests < <(git diff --diff-filter=A --name-only "$before" "$after" -- releases/requests | grep -E '^releases/requests/[^/]+\.json$' || true)
fi

if [ "${#requests[@]}" -eq 0 ]; then
  echo "No new release requests in this push."
  exit 0
fi

for request in "${requests[@]}"; do
  project_id="$(jq -r '.project_id // empty' "$request")"
  version="$(jq -r '.version // empty' "$request")"
  publish="$(jq -r 'if has("publish") then .publish else false end' "$request")"
  filename="$(basename "$request")"

  [[ "$project_id" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Invalid project ID in $request"; exit 1; }
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid version in $request"; exit 1; }
  [ "$filename" = "$project_id-v$version.json" ] || { echo "Request filename must be $project_id-v$version.json"; exit 1; }
  [ "$publish" = "true" ] || [ "$publish" = "false" ] || { echo "publish must be a boolean in $request"; exit 1; }

  project_file="projects/$project_id/project.json"
  [ -f "$project_file" ] || { echo "Missing $project_file"; exit 1; }
  jq -e --arg version "$version" '.current_version == $version' "$project_file" >/dev/null || {
    echo "Project version does not match request $request"
    exit 1
  }

  tag="project/$project_id/v$version"
  if git show-ref --verify --quiet "refs/tags/$tag"; then
    existing_sha="$(git rev-list -n 1 "$tag")"
    [ "$existing_sha" = "$after" ] || {
      echo "Refusing to move existing immutable tag $tag"
      exit 1
    }
    echo "Release tag $tag already exists at this commit; continuing idempotently."
  else
    git tag -a "$tag" "$after" -m "Release $project_id v$version"
    git push origin "refs/tags/$tag"
    echo "Created immutable release tag $tag at $after"
  fi

  if [ "$publish" = "true" ]; then
    jq -e '
      (.title | type == "string" and length > 0) and
      (.summary | type == "string" and length > 0) and
      (.category | type == "string" and length > 0)
    ' "$project_file" >/dev/null || {
      echo "Published project metadata requires non-empty title, summary and category."
      exit 1
    }
    entry="$(jq -n \
      --arg project_id "$project_id" \
      --arg version "$version" \
      --arg tag "$tag" \
      --arg title "$(jq -r '.title' "$project_file")" \
      --arg summary "$(jq -r '.summary' "$project_file")" \
      --arg category "$(jq -r '.category' "$project_file")" \
      '{project_id:$project_id, version:$version, tag:$tag, title:$title, summary:$summary, category:$category, featured:false}')"
    tmp="$(mktemp)"
    jq --argjson entry "$entry" '.projects = ((.projects // []) | map(select(.project_id != $entry.project_id)) + [$entry])' portfolio/portfolio.json > "$tmp"
    mv "$tmp" portfolio/portfolio.json
    portfolio_changed=true
    echo "Selected $tag in the public portfolio."
  fi
done

if [ "$portfolio_changed" = "true" ]; then
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  git add portfolio/portfolio.json
  if ! git diff --cached --quiet; then
    git commit -m "chore: publish selected project releases"
    git push origin HEAD:main
    echo "Portfolio update pushed. The Pages deployment workflow will run after this workflow completes."
  fi
fi
