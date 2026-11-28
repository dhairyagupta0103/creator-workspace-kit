# Creator Workspace Kit

A GitHub template for a small, single-creator workspace. Use it with an AI coding session to build browser apps, games and learning projects.

## Start here
1. Use **Use this template** to create a repository.
2. Have a trusted adult help connect a preview-hosting account once. The recommended setup is Cloudflare Pages branch previews; see governance/PREVIEW_HOSTING.md.
3. Connect an AI tool that is allowed to read and write the repository. Have it verify its actual permissions before planning work.
4. Describe the project in ordinary language. The agent works on a branch and updates it as you give feedback.
5. Open one PR only when the project is ready for review. The agent can do this, or the repository owner can comment /ready <branch-name> on a GitHub issue.
6. For a release, the project PR includes a release request. After merge, GitHub Actions creates the immutable tag and, when explicitly requested, updates the portfolio automatically.

## Included
- Agent instructions for shell-enabled and GitHub-API-only sessions
- Project templates, metadata, creation and validation scripts
- A branch-preview build for Cloudflare Pages, including optional Pages Functions
- A downloadable diagnostic artifact for sessions where hosted previews are not configured
- GitHub Actions for validation, optional issue-comment PR creation, release tags and GitHub Pages publishing

## Preview and publishing
- Creator preview: Cloudflare Pages builds work/* and experiment/* branches into hosted previews. The branch preview updates as commits arrive and uses a separate browser origin from the GitHub Pages site.
- Diagnostic artifact: GitHub Actions also packages a ZIP for inspection. It is a fallback for agents, not the creator-facing preview.
- Public portfolio: GitHub Pages publishes only exact immutable release tags selected by release requests with publish true.
- Branch previews are public URLs unless an adult configures access protection. Never put personal information, private data or credentials in a project or preview.
- GitHub Pages requires its publishing source to be set to GitHub Actions.

## Workflow rules
- main is approved history. Never work or commit directly on it.
- A PR represents a completed project change, not every automation step.
- Preview deployment is automatic on working-branch pushes; no PR is needed to try changes.
- Release automation may update the portfolio on main only when the merged release request explicitly says publish true. This is a narrowly scoped automation exception; it never changes project source files.
- Portfolio entries point to immutable release tags, never branches.
- Do not assume an AI integration can run shell commands, dispatch workflows, create tags, administer Pages settings or open a browser. Verify each capability.

## Scope
The kit has no accounts, database or paid AI access. Static apps and browser API clients work in previews; optional Cloudflare Pages Functions provide a path to server-side endpoints. Follow provider age requirements and use a trusted adult for hosting-account setup and public publishing.
