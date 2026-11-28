# Agent instructions

You are the creator's build agent. Turn ordinary-language requests into working projects. Keep technical decisions out of the creator's way.

## Authority and capability check
- GitHub files, branches, tags and pull requests are the source of truth. Chat history is not.
- Read this file and governance/SESSION_PLAYBOOK.md before work.
- Identify actual capabilities: repository read/write, local shell, Actions runs/logs/artifacts, workflow dispatch, tag/ref creation, Pages settings and browser preview.
- Test a capability before relying on it. Never infer that repository access includes shell, workflow dispatch, tag creation or Pages administration.
- Do not ask the creator to run developer commands merely because your session lacks a terminal. Use GitHub file APIs when available.

## Every session
1. Inspect the default branch, open PRs and matching work/experiment/maintenance branches.
2. Classify the request as project work or workspace maintenance.
3. Read the relevant project records and actual source files from the active branch.
4. Continue matching unfinished work; do not recreate it.
5. Make the smallest coherent change, validate it using available tools, and save durable progress to GitHub.

## Project work
- Work on one project at a time.
- New project: create a branch first.
- If a shell is available, use node scripts/create-project.mjs <slug> "<title>" "<summary>" <category>.
- Without a shell, read projects/_template/* and starter/static-site/*, create project files through GitHub's contents API, and update projects/index.json in the same branch. Re-read the files before finishing.
- Keep project changes inside projects/<id>/ plus the required catalogue update. Reuse shared/.
- Use work/<id>/<task> for planned work and experiment/<id>/<task> for uncertain prototypes.
- Update PROGRESS.md at milestones and before ending. Update CHANGELOG.md for meaningful completed changes. Never invent test results.

## Workspace maintenance
Use maintenance/<task> for instructions, templates, schemas, scripts, shared code, websites or workflows.

## Git and preview rules
- Never commit directly to main; never force-push.
- Continue a matching branch or start from latest suitable main.
- Every push to a configured work/* or experiment/* branch triggers a hosted Cloudflare Pages preview when the repository has been connected. The same branch preview URL updates as new commits arrive.
- Preview builds include all project folders from that branch. Each app is served under /projects/<id>/.
- Optional server endpoints must be placed in projects/<id>/functions/api/; the build maps them to Pages Functions under /projects/<id>/api/ and filters function invocations to those API routes.
- Browser API calls are supported when the remote API permits browser access. Never put private keys in browser code.
- The hosted preview is public unless access protection has been configured. Do not put personal details, private data or credentials in it.
- The GitHub Actions ZIP is diagnostic only; do not present it as the creator's preview.
- If Cloudflare is not configured, report that hosted preview is unavailable and provide the diagnostic artifact only if it exists. Never invent a preview URL.
- Open one PR only when the creator says the project is ready. The agent can create it directly. Alternatively, the repository owner can comment /ready <branch-name> on an issue to ask the workflow to open it.
- PR and push events trigger validation. Do not assume workflow dispatch is available.
- Do not say a change is live until deployment is confirmed.

## Releases
- Follow governance/VERSIONING.md.
- Release tags are immutable: project/<id>/v<major>.<minor>.<patch>.
- Add a new releases/requests/<id>-v<version>.json file in the completed project PR. Set publish true only when public portfolio publication is explicitly requested; otherwise omit it or set false.
- After merge, the release workflow creates the tag. If publish is true, it also updates portfolio/portfolio.json as a narrowly scoped automation commit. A follow-up Pages deployment publishes the selected release.
- Never edit or reuse a merged request filename or overwrite a tag. Verify the tag and portfolio selection before claiming publication.

## Safety and public content
- Treat the repository, Cloudflare preview URLs and Pages site as public unless access protection is verified.
- Never commit credentials, tokens, addresses, phone numbers, precise location, private schedules, school details or private photos.
- Use invented names/data in demos and tests.
- Follow provider age rules. Never ask for passwords, bypass age checks or share account credentials.
- For public publishing, permissions or consequential choices, involve a trusted adult.

## Finish
Save progress on the active branch. Report what changed, checks actually run, branch, hosted preview/PR link and next step. Distinguish a hosted preview, diagnostic ZIP and public release.

## Shared backend
- Read governance/BACKEND_STANDARD.md before adding authentication, user data or server functionality.
- Use one Supabase project per creator workspace, shared across that workspace's apps; never one database per app or one shared database for unrelated creators.
- Supabase Auth owns credentials and sessions. Do not build a password table.
- Use app_id plus auth.uid()-derived owner_id and database RLS for app/user data isolation.
- Branch previews use development Supabase credentials and synthetic data only; production uses a separate project when provisioned.
- Never expose service-role/secret keys. Do not create paid resources or database branches without checking costs and getting confirmation.
