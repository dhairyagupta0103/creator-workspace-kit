# Versions and portfolio

Use MAJOR.MINOR.PATCH:
- PATCH: fix or correction.
- MINOR: compatible feature or meaningful improvement.
- MAJOR: substantial redesign or breaking change.

Do not version every commit. A version is a completed milestone.

## Release
1. Complete work on its branch.
2. Update project.json and CHANGELOG.md.
3. Add a new request file named releases/requests/<id>-v<version>.json.
4. Include publish: true only if this release should appear on the public portfolio. Omit it or set false for a tagged release that is not selected publicly.
5. Open one PR. After review, the owner merges it.
6. The release workflow creates immutable tag project/<id>/v<version> on the merge commit.
7. If publish is true, the workflow updates portfolio/portfolio.json to select this tag and triggers a follow-up Pages deployment. This portfolio-only update is an automation exception; it does not alter project source or rewrite history.
8. Verify the tag, portfolio selection and deployment before claiming publication.

Requests are append-only. Never edit, rename or delete a merged request, and never reuse a version tag. The workflow refuses to overwrite an existing tag. A correction requires a new patch version and request file.

## Portfolio
portfolio/portfolio.json selects exact project tags. Normal release requests with publish true update the selected tag automatically. For a manual portfolio correction or rollback, use a normal branch and PR; do not reset main or rewrite project files.
