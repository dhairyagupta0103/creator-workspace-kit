# Versions and portfolio

Use `MAJOR.MINOR.PATCH`:
- PATCH: fix or correction.
- MINOR: compatible feature or meaningful improvement.
- MAJOR: substantial redesign or breaking change.

Do not version every commit. A version is a completed milestone.

## Release
1. Complete work on its branch.
2. Update `project.json` and `CHANGELOG.md`.
3. Add a new request file named `releases/requests/<id>-v<version>.json`, containing the project ID and version.
4. Open the PR. After review, the owner merges it.
5. The `Create release tags` workflow creates immutable tag `project/<id>/v<version>` on the merge commit. It refuses to overwrite an existing tag.
6. Verify the tag exists before using it. If the workflow fails, fix the request or repository permissions; do not create a replacement tag by moving an existing one.

The request file is a durable release record. Never edit or delete a request after it has been merged. A correction requires a new patch version and a new request file.

## Portfolio
`portfolio/portfolio.json` selects exact project tags. Change it only when public publication is explicitly requested, through a normal branch and PR after the tag exists. A portfolio rollback changes the selected tag; it does not reset `main` or rewrite project files.
