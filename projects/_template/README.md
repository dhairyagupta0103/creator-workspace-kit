# {{PROJECT_TITLE}}

{{PROJECT_SUMMARY}}

## Preview
Push this project on a work/<id>/<task> or experiment/<id>/<task> branch. When Cloudflare Pages is connected, the branch receives a hosted preview URL that updates with each push. The project is served at /projects/<id>/ in the preview site. GitHub Actions also creates a diagnostic ZIP, but that is not the creator-facing preview.

## Runtime files
- index.html, styles.css, app.js: browser app.
- assets/: project-owned static assets.
- functions/api/ (optional): Cloudflare Pages Functions for server-side API routes. They are deployed beneath /projects/<id>/api/.
- project.json: structured metadata.
- PROGRESS.md: resume point for the next session.
- CHANGELOG.md: meaningful completed changes.

Browser API calls are supported subject to the API's CORS and access rules. Never put private API keys or credentials in browser code or Git. Configure separate preview and production secrets only in the hosting provider's environment settings, with trusted adult help.
