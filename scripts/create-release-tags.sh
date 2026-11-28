#!/usr/bin/env bash
set -euo pipefail

before="${GITHUB_EVENT_BEFORE:?GITHUB_EVENT_BEFORE is required}"
after="${GITHUB_SHA:?GITHUB_SHA is required}"

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
  filename="$(basename "$request")"

  [[ "$project_id" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Invalid project ID in $request"; exit 1; }
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid version in $request"; exit 1; }
  [ "$filename" = "$project_id-v$version.json" ] || { echo "Request filename must be $project_id-v$version.json"; exit 1; }

  project_file="projects/$project_id/project.json"
  [ -f "$project_file" ] || { echo "Missing $project_file"; exit 1; }
  jq -e --arg version "$version" '.current_version == $version' "$project_file" >/dev/null || {
    echo "Project version does not match request $request"
    exit 1
  }

  tag="project/$project_id/v$version"
  if git show-ref --verify --quiet "refs/tags/$tag"; then
    echo "Refusing to overwrite existing tag $tag"
    exit 1
  fi

  git tag -a "$tag" "$after" -m "Release $project_id v$version"
  git push origin "refs/tags/$tag"
  echo "Created immutable release tag $tag at $after"
done
