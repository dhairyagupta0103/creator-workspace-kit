# Release requests

Add one new JSON file per release request, named `<project-id>-v<version>.json`.

Example:

```json
{
  "project_id": "sample-project",
  "version": "1.0.0"
}
```

Include the request in the completed project PR alongside the matching `project.json` version update. When that PR is merged to `main`, the release-tag workflow creates `project/<project-id>/v<version>` on the merge commit.

Requests are append-only. Never edit, rename or delete a merged request, and never reuse a version tag. The workflow refuses to overwrite an existing tag. After the workflow succeeds, verify the tag before selecting it in `portfolio/portfolio.json`.
