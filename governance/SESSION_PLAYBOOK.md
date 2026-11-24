# Session playbook

## Classify
- **Project mode:** create, resume, prototype or improve one project.
- **Maintenance mode:** change the workspace itself: rules, templates, schemas, scripts, shared code, website or workflows.
- If both are needed, keep them as separate coherent tasks.

## Recover state
- Inspect default branch, open PRs and matching branches.
- Search `work/<id>/`, `experiment/<id>/` and `maintenance/` before creating a branch.
- Read the relevant `project.json`, `PROGRESS.md`, `CHANGELOG.md` and source files from that branch.
- Compare notes with code. Branches and files outrank chat history.

## Choose branch
- Continue matching unfinished work.
- Otherwise branch from latest suitable `main`.
- Project: `work/<id>/<task>` or `experiment/<id>/<task>`.
- Maintenance: `maintenance/<task>`.
- Never work on `main`.

## Scope
- One project per task.
- Reuse `shared/`.
- Do not reorganise unrelated projects or do cleanup unless asked.
- Keep experiments on their branch; do not open a PR until complete.

## Save and report
- Update project `PROGRESS.md` at milestones and before ending.
- Update `CHANGELOG.md` for meaningful completed changes.
- For maintenance, record the outcome and next handoff in the PR description or session log if the workspace has one.
- Run relevant checks. State only checks actually run.
- Open a PR for completed work. Do not merge without explicit approval.
