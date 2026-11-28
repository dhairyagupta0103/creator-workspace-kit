# Hosted branch previews

## Recommended provider

Use Cloudflare Pages Git integration for hosted previews. It can build custom branches and generate a separate preview URL without changing the production deployment. A branch preview updates when new commits are pushed to that branch.

A trusted adult should own and configure the hosting account and authorize the GitHub repository. Follow the provider's age and account rules; do not share passwords or tokens with an AI agent.

## One-time setup

1. In Cloudflare, create a Pages project and connect this GitHub repository using the Git integration.
2. Set the build command to: bash scripts/build-preview.sh
3. Set the build output directory to: _preview
4. Set the Node.js version environment variable to 22.
5. In branch controls, allow the workspace branches named work/* and experiment/* as preview branches. Keep main as the production branch, or choose a dedicated placeholder branch if the Pages production URL is not wanted.
6. Confirm that a test branch gets a preview URL on the pages.dev domain and that a new commit updates that branch's preview.
7. Keep preview URLs public unless a trusted adult deliberately configures access protection.

Cloudflare Pages preview URLs use a provider-controlled pages.dev hostname, separate from the GitHub Pages production site's origin. Do not replace this with a folder under the same github.io site: different folders on the same hostname are not separate browser origins.

## What gets built

The script assembles all projects from the current branch:
- The workspace launcher is at the preview root.
- Each app is served at /projects/<project-id>/.
- Shared browser utilities are copied to /shared/.
- Optional project server functions from projects/<project-id>/functions/ are copied to the Pages Functions route prefix /projects/<project-id>/.

A preview contains the branch's current code, not a screenshot or a ZIP. Keep personal information, credentials and private data out of the repository and preview. A public repository means its branches and preview deployments may be discoverable.

## Runtime support

- Static: HTML, CSS, JavaScript and assets.
- API client: browser-side calls to APIs that permit browser access. Any key embedded in browser code is public.
- Server endpoints: Pages Functions can provide server-side routes. Configure secrets in the provider's environment settings, never in Git or browser code. Use test data and preview-only credentials.

The diagnostic ZIP produced by GitHub Actions is a fallback for agent inspection. It is not the hosted preview.

## Troubleshooting

If no hosted URL appears, check the Pages Git integration, branch-control allowlist, build output directory and latest deployment log in the provider dashboard. Do not claim a hosted preview exists until its URL is visible and the app has been opened successfully.
