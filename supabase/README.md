# Supabase workspace backend

This directory contains the versioned database contract for the Creator Workspace Kit.

- `migrations/`: schema changes applied to each workspace's Supabase project.
- `tests/`: pgTAP checks for the shared schema and RLS enablement.

Read [Workspace Backend Standard](../governance/BACKEND_STANDARD.md) before provisioning or connecting an app.

## Current provisioning status

The repository defines the backend but does not contain a project URL, key, password or project reference. Create a development project through the Supabase dashboard with trusted-adult oversight, then apply the migration. Do not commit `.env` files or credentials.

## Initial setup

1. Create one development project in the workspace owner's Supabase organization.
2. Apply the SQL migration in `migrations/` using the Supabase SQL editor or Supabase CLI migration workflow.
3. Invite the initial user through **Authentication → Users**; public sign-up remains disabled.
4. Add that user's Auth UUID to `public.workspace_admins` in the SQL editor.
5. Register app IDs in `public.workspace_apps` and grant user access in `public.app_memberships`.
6. Run the pgTAP tests in `tests/` against development.
7. Configure Cloudflare preview environment variables with the development project URL and publishable key only.

Example app registration (run as a trusted project administrator):

```sql
insert into public.workspace_apps (id, name, description)
values ('planet-quiz', 'Planet Quiz', 'A sample learning app')
on conflict (id) do update
set name = excluded.name, description = excluded.description, is_enabled = true;

insert into public.app_memberships (app_id, user_id, role)
values ('planet-quiz', '<AUTH_USER_UUID>', 'member')
on conflict (app_id, user_id) do update set role = excluded.role;
```

## Client configuration

Browser applications may use only the Supabase project URL and publishable key. RLS is the security boundary. Never expose a secret/service-role key, database password or management token in frontend code, GitHub, a preview build or a chat.

Use the app's stable project ID as `app_id`. The authenticated user's ID must come from the verified Supabase session (`auth.uid()`), not from a client-supplied owner field.

## Limits and cost notes

The Supabase Free plan currently allows up to two active projects per organization, 500 MB database size per project, 5 GB egress, 1 GB file storage, 50,000 monthly active users and 500,000 Edge Function invocations. Free projects may pause after seven days of inactivity. Limits and pricing can change; check the dashboard before provisioning. A second production project is a separate resource and must be checked for cost before creation.

Supabase development branches can incur compute charges. Do not create them for routine previews without checking the cost first.
