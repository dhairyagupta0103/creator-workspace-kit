# Creator Workspace Kit

A GitHub template for a small, single-creator workspace. Use it with an AI coding session to build static websites, browser games and learning projects.

## Start here
1. Use **Use this template** to create your own repository. Keep it private while setting up if you do not want unfinished work public.
2. Read `AGENTS.md` and follow it in your coding session.
3. Connect your own GitHub repository to an AI tool that is allowed to read and write it. Confirm its permissions; do not assume every ChatGPT connection can commit.
4. Create a project on a new branch: `node scripts/create-project.mjs <slug> "<title>" "<summary>" <category>`.
5. Build, preview and save progress. Open a pull request only when the work is ready.
6. After merging, create a version tag. Add that exact tag to `portfolio/portfolio.json` only when you want to publish it.

## What is included
- Agent/session instructions and project workflow
- Project templates, metadata schemas and creation/validation scripts
- A simple public portfolio launcher
- GitHub Actions for validation, branch previews and Pages publishing

## Rules
- `main` is approved history. Never work or commit directly on it.
- A pull request is for completed work, not an unfinished experiment.
- Portfolio entries point to immutable release tags, never branches.
- GitHub Pages is public. A hidden portfolio entry does **not** hide its source from a public repository.
- Keep credentials, personal details and private material out of Git.

## First setup
In repository Settings → Pages, set the publishing source to **GitHub Actions**. Review workflow permissions and branch protection with a trusted adult/administrator where appropriate. The included site publishes on pushes to `main`.

## Scope
This kit is intentionally static and free to host on GitHub Pages. It does not provide accounts, a database, private previews, a backend or paid AI access. Follow GitHub and AI-provider age requirements; never bypass them or share credentials.
