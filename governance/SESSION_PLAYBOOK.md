# Session playbook

## 1. Verify tools
Identify whether this session can read/write repository files, run a shell, inspect Actions runs/logs/artifacts, dispatch workflows, create tags/refs, change Pages settings and open a browser. Test only relevant capabilities. Do not design around unverified access.

## 2. Recover state
- Inspect the default branch, open PRs and matching branches.
- Search work/<id>/, experiment/<id>/ and maintenance/ before creating a branch.
- Read project.json, PROGRESS.md, CHANGELOG.md and source files from the active branch.
- Branches and files outrank chat history.

## 3. Choose mode and branch
- Project mode: create, resume, prototype or improve one project.
- Maintenance mode: change workspace rules, templates, schemas, scripts, shared code, website or workflows.
- Project branches: work/<id>/<task> or experiment/<id>/<task>.
- Maintenance branches: maintenance/<task>.
- Continue matching unfinished work; otherwise branch from latest suitable main.
- Never work on main.

## 4. Work without assuming a terminal
- With a shell, use the provided scripts and run local checks.
- With GitHub file-write APIs only, create/update files directly on the branch. For a new project, copy the template and starter files through the API, substitute metadata, and update projects/index.json.
- Re-read changed files and compare the registry to project metadata.
- Do not ask the creator to install developer tools to compensate for a missing agent capability.

## 5. Hosted preview and validation
- Configure Cloudflare Pages Git integration once per workspace repository; see governance/PREVIEW_HOSTING.md.
- Pushes to configured work/* and experiment/* branches automatically create/update hosted preview deployments. No PR is needed to try a project.
- The preview build uses scripts/build-preview.sh and publishes all projects in that branch beneath /projects/<id>/.
- Optional Pages Functions belong under projects/<id>/functions/api/ and are routed beneath /projects/<id>/api/. The generated route filter keeps static files outside Functions execution.
- Browser API calls work when the remote API permits them. Secrets belong only in separate preview/production hosting-provider settings.
- Preview URLs are public unless access protection is configured. Never use real personal data or secrets.
- GitHub Actions' ZIP is diagnostic only, not the creator-facing preview.
- PR and push events run workspace validation. Inspect Actions runs/logs when available; never infer success from an empty response.
- If hosting is not connected, clearly say hosted preview is not configured.

## 6. PR and release
- Keep work on the branch while the creator tests and requests changes.
- When the creator approves the preview, open one PR. The agent may create it, or the repository owner can comment /ready <branch-name> on a GitHub issue.
- Add one new release request file in the completed project PR. Use publish true only when the creator explicitly requests public portfolio publication.
- After merge, Actions creates the immutable tag. If publish is true, the same automation updates the portfolio selection; a follow-up Pages deployment publishes it. No separate portfolio PR is needed for this normal release path.

## 7. Save and report
- Update PROGRESS.md at milestones and before ending; update CHANGELOG.md for meaningful changes.
- State only checks actually run.
- Report branch, preview URL, check status and next step. Distinguish hosted previews, ZIP artifacts and public releases.
- Do not merge a PR without explicit approval.

## 5a. Shared backend
- Read governance/BACKEND_STANDARD.md before backend work.
- Supabase Auth owns identities; PostgreSQL RLS enforces app and owner isolation.
- Preview builds use the development backend with synthetic data only. Production uses a separate backend project and secrets.
- Never put service-role keys or database passwords in Git, browser code or chat.
- Validate migrations with pgTAP and Supabase advisors against development before production rollout.
