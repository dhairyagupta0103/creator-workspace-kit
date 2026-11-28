# Session playbook

## 1. Verify tools
Identify whether this session can read/write repository files, run a shell, inspect Actions runs/logs/artifacts, dispatch workflows, create tags/refs, change Pages settings and open a browser. Test only what is relevant. Do not design around an unverified capability.

## 2. Recover state
- Inspect the default branch, open PRs and matching branches.
- Search `work/<id>/`, `experiment/<id>/` and `maintenance/` before creating a branch.
- Read the relevant `project.json`, `PROGRESS.md`, `CHANGELOG.md` and source files from that branch.
- Compare notes with code. Branches and files outrank chat history.

## 3. Choose mode and branch
- **Project mode:** create, resume, prototype or improve one project.
- **Maintenance mode:** change the workspace itself: rules, templates, schemas, scripts, shared code, website or workflows.
- Project: `work/<id>/<task>` or `experiment/<id>/<task>`.
- Maintenance: `maintenance/<task>`.
- Continue matching unfinished work; otherwise branch from latest suitable `main`.
- Never work on `main`.

## 4. Work without assuming a terminal
- With a shell, use the provided scripts and run local checks.
- With GitHub file-write APIs only, create/update files directly on the branch. For a new project, copy the template and starter file contents through the API, substitute metadata, and update `projects/index.json`.
- Re-read changed files and compare the registry to project metadata.
- Do not ask the creator to install developer tools to compensate for a missing agent capability.

## 5. Preview and validate
- PR and push events trigger the included validation workflow. Do not assume workflow dispatch is available.
- The preview workflow produces a downloadable ZIP artifact, not a hosted browser preview.
- Inspect workflow runs, job steps and logs when the integration exposes them. Download artifacts only when the integration exposes that action.
- If a workflow run cannot be found, say validation is unverified; never infer success from an empty response.

## 6. Release and portfolio
- Update project metadata and changelog in the completed project PR.
- Add a new `releases/requests/<id>-v<version>.json` file in that PR.
- After merge, the release workflow creates the immutable tag. Verify the tag exists before referencing it.
- Change `portfolio/portfolio.json` in a separate PR only when public publication is explicitly requested.

## 7. Save and report
- Update `PROGRESS.md` at milestones and before ending.
- Update `CHANGELOG.md` for meaningful completed changes.
- For maintenance, record outcome and next handoff in the PR description or session log.
- State only checks actually run. Distinguish ZIP artifacts, browser previews and public releases.
- Do not merge a PR without explicit approval.
