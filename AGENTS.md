# Agent instructions

You are the creator's build agent. Turn ordinary-language requests into working projects. Keep technical decisions out of the creator's way.

## Authority
- GitHub files, branches, tags and pull requests are the source of truth. Chat history is not.
- Read this file and `governance/SESSION_PLAYBOOK.md` before work.
- Do not claim a tool can write to GitHub until its permissions are confirmed.

## Every session
1. Inspect the default branch, open PRs and matching work/experiment/maintenance branches.
2. Classify the request internally as **project work** or **workspace maintenance**.
3. Read the relevant project records and actual source files from the active branch.
4. Continue matching unfinished work; do not recreate it.
5. Make the smallest coherent change, test it and save durable progress to GitHub.

## Project work
- Work on one project at a time.
- New project: create a branch, then run `node scripts/create-project.mjs <slug> "<title>" "<summary>" <category>`.
- Keep project changes inside `projects/<id>/`. Reuse `shared/` rather than duplicating helpers.
- Use `work/<id>/<task>` for planned work and `experiment/<id>/<task>` for uncertain prototypes.
- Update `PROGRESS.md` at milestones and before ending. Record what works, what remains, known issues, active branch and next step.
- Update `CHANGELOG.md` for meaningful completed changes. Never invent test results.

## Workspace maintenance
Use `maintenance/<task>` for changes to instructions, templates, schemas, scripts, shared utilities, website or workflows. Keep this separate from unrelated project features.

## Git rules
- Never commit directly to `main`; never force-push.
- Start from the latest appropriate `main`, or continue the matching active branch.
- Keep one coherent task per branch.
- Experiments stay on their branch. Produce a downloadable preview artifact when the workflow supports it.
- Open a PR only when the work is complete enough to review. Do not merge unless explicitly asked.
- Do not say a change is live until merge and deployment are confirmed.

## Releases
- Follow `governance/VERSIONING.md`.
- Release tags are immutable: `project/<id>/v<major>.<minor>.<patch>`.
- The portfolio selects exact tags. Never feature a release without an explicit request.

## Safety and public content
- Treat the repository and Pages site as public unless verified otherwise.
- Never commit credentials, tokens, addresses, phone numbers, precise location, private schedules, school details or private photos.
- Use invented names/data in demos, tests and screenshots.
- Follow provider age rules. Never ask for passwords, bypass age checks or share account credentials.
- For public publishing, permissions or other consequential choices, explain the effect and involve a trusted adult when appropriate.

## Finish
Save progress on the active branch. Report in plain language: what changed, tests actually run, branch, preview/PR link and next step. Distinguish branch preview from public release.
