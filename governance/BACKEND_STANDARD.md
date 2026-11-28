# Workspace Backend Standard v1

## Provider responsibilities

- GitHub is the source of truth for application code, SQL migrations, configuration and release history.
- Cloudflare Pages remains the current portfolio and branch-preview host for this kit. Keep the existing Pages deployment while implementing this standard.
- Supabase is the shared backend for one creator workspace: Auth, PostgreSQL, Row Level Security (RLS), and later Edge Functions.
- Each independent creator/workspace owns their own Supabase organization and project. Never point unrelated template users at one shared database.

## Environment model

1. Start with one Supabase development project. Use it for branch previews and synthetic test accounts only.
2. Create a separate production project before publishing apps that handle real user data. The free plan currently allows up to two active projects per organization, subject to provider limits and inactivity pausing.
3. Apply the same committed migrations to both projects. Do not use a Supabase database branch for routine previews; branches may incur compute charges.
4. Store the project URL and publishable key in hosting environment variables. Publishable keys are designed for browser use only when RLS is correctly configured.
5. Never place service-role keys, secret keys, passwords, tokens or real user records in Git, browser code, PR previews or ChatGPT messages.

## Identity and data model

- Supabase Auth owns credentials, password hashes, sessions, email verification and recovery. Do not create a password/credentials table.
- `profiles` stores non-secret profile fields keyed by the Auth user UUID.
- `workspace_apps` is the allowlisted app registry.
- `workspace_admins` identifies trusted workspace administrators.
- `app_memberships` grants a user access to an app.
- `app_records` stores user-owned JSON records with both `app_id` and `owner_id`.

The database enforces both app membership and row ownership with RLS. An app ID is a namespace, not a secret. Hiding UI elements is not authorization.

## Initial onboarding

1. A trusted adult creates the Supabase development project and applies the migrations in `supabase/migrations/`.
2. Invite the first user from Supabase Auth; public sign-up stays disabled.
3. Add the initial administrator's Auth UUID to `public.workspace_admins` using the Supabase SQL editor. Never grant admin status from user-editable metadata.
4. Register each app in `workspace_apps` and grant access by inserting `app_memberships` through the trusted admin workflow.
5. Test with invented users and data. Do not use production identities or personal data in previews.

## Admin workflow

The first milestone uses Supabase Dashboard for trusted-adult account invitations and one-time admin bootstrap. The private in-app admin page is a later UI over server-side Edge Functions. It must verify the caller with Auth, check `workspace_admins` in the database, validate inputs, and perform privileged operations server-side. Never ship a service-role key to the browser.

Public signup is disabled initially. Add it only after email verification, recovery, abuse controls, admin approval policy and RLS tests are in place.

## App integration contract

Every app uses the same Supabase project URL and publishable key, then calls Auth for sign-in/sign-out and accesses only its own `app_id`. Use the authenticated session; never accept an arbitrary `owner_id` from a form as proof of identity. The database derives the effective owner from `auth.uid()`.

Apps should use stable IDs from `projects/<id>/project.json`. Keep app-specific data in `app_records.payload` with a documented JSON shape per app. Prefer dedicated tables and migrations when an app's data becomes relational or needs stronger constraints.

## Preview and production

- Cloudflare branch previews use the development Supabase project and synthetic test accounts only.
- Production apps use the production Supabase project and production secrets.
- Do not copy production data into development.
- Supabase Auth redirect URLs must be explicitly configured for the production origin and any approved preview origins. Avoid broad wildcard redirects.
- A branch preview is public unless hosting access protection is configured; never treat an obscure URL as private.

## Validation and release

- Review every migration before applying it to production.
- Run `supabase test db` (pgTAP) against a development project after migrations are applied.
- Verify RLS on every exposed table and test cross-user and cross-app access denial.
- Use Supabase advisors and inspect function logs before release.
- Keep secrets out of GitHub Actions logs and artifacts.
- A successful repository CI check is not proof that a live Supabase project or Cloudflare deployment is configured.
