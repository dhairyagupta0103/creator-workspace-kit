# Release requests

Add one new JSON file per release request, named <project-id>-v<version>.json.

Example for a tagged release that is not yet public:

    {
      "project_id": "sample-project",
      "version": "1.0.0"
    }

Example for a release that should also be selected on the public portfolio:

    {
      "project_id": "sample-project",
      "version": "1.0.0",
      "publish": true
    }

Include the request in the completed project PR alongside the matching project.json version update. When merged to main, GitHub Actions creates immutable tag project/<project-id>/v<version>. If and only if publish is true, the same workflow updates portfolio/portfolio.json to select the new tag. A follow-up Pages workflow publishes that selection.

Requests are append-only. Never edit, rename or delete a merged request, and never reuse a version tag. The workflow refuses to overwrite an existing tag. Public publication should be explicitly requested and reviewed before the PR is merged.
