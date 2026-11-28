# Creator Workspace Kit

A GitHub template for a small, single-creator workspace. Use it with an AI coding session to build static websites, browser games and learning projects.

## Start here
1. Use **Use this template** to create a repository. Keep it private during setup if unfinished work should not be public.
2. Connect an AI tool that is allowed to read and write the repository. Have it verify its actual permissions before planning work.
3. Ask the agent to create a project. It should use the local creation script only when it has a shell; otherwise it can create the same files through GitHub's repository API.
4. Describe the project in ordinary language. The agent works on a branch and opens a PR when the work is ready.
5. Review and merge the PR. GitHub Actions validates the workspace and prepares a downloadable preview ZIP.
6. For a release, the agent adds a release request in the project PR. After merge, GitHub Actions creates the immutable version tag. The portfolio is updated separately only when publication is requested.

## Included
- Agent instructions for shell-enabled and GitHub-API-only sessions
- Project templates, metadata, creation and validation scripts
- A public portfolio launcher assembled from immutable project tags
- GitHub Actions for validation, downloadable preview artifacts, release-tag creation and Pages publishing

## Preview and publishing
- The branch-preview workflow packages project files and shared utilities as a downloadable ZIP. It is **not** a hosted browser preview.
- The public portfolio is deployed by GitHub Pages after pushes to `main`, using only the exact release tags selected in `portfolio/portfolio.json`.
- GitHub Pages is public. A hidden portfolio entry does **not** hide source files in a public repository.
- The Pages workflow requires the repository's Pages publishing source to be set to **GitHub Actions**. An AI integration may not have access to inspect or change this account-level setting.

## Rules
- `main` is approved history. Never work or commit directly on it.
- A PR is for completed work, not an unfinished experiment.
- Portfolio entries point to immutable release tags, never branches.
- Keep credentials, personal details and private material out of Git.
- Do not assume an AI integration can run shell commands, dispatch workflows, create tags, administer Pages settings or open a browser. Verify each capability.

## Scope
This kit is static and free to host on GitHub Pages. It does not provide accounts, a database, private previews, a backend or paid AI access. Follow GitHub and AI-provider age requirements; never bypass them or share account credentials.
