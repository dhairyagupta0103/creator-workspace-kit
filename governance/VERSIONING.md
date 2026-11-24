# Versions and portfolio

Use `MAJOR.MINOR.PATCH`:
- PATCH: fix or correction.
- MINOR: compatible feature or meaningful improvement.
- MAJOR: substantial redesign or breaking change.

Do not version every commit. A version is a completed milestone.

## Release
1. Complete work on its branch.
2. Update `project.json` and `CHANGELOG.md`.
3. Open and merge the PR after review.
4. Create immutable tag `project/<id>/v<version>` on the merged commit.
5. Never move or overwrite a tag. Correct mistakes with a new patch version.

## Portfolio
`portfolio/portfolio.json` selects exact project tags. Change it only when explicitly requested, through a normal branch and PR. A portfolio rollback changes the selected tag; it does not reset `main` or rewrite project files.
