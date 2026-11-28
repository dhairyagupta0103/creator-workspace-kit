-- Creator Workspace Kit: shared identity and app-scoped user data.
-- Auth credentials remain in Supabase Auth; this migration never stores passwords.

create table if not exists public.workspace_apps (
  id text primary key check (id ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name text not null,
  description text not null default '',
  is_enabled boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.workspace_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.app_memberships (
  app_id text not null references public.workspace_apps(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'admin', 'member')),
  created_at timestamptz not null default now(),
  primary key (app_id, user_id)
);

create table if not exists public.app_records (
  id uuid primary key default gen_random_uuid(),
  app_id text not null references public.workspace_apps(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  record_key text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (app_id, owner_id, record_key)
);

create index if not exists app_records_owner_app_idx
  on public.app_records (owner_id, app_id);

-- Every table in the exposed public schema is protected by RLS.
alter table public.workspace_apps enable row level security;
alter table public.profiles enable row level security;
alter table public.workspace_admins enable row level security;
alter table public.app_memberships enable row level security;
alter table public.app_records enable row level security;

-- Remove broad default access; grant only what browser clients need.
revoke all on public.workspace_apps, public.profiles, public.workspace_admins,
  public.app_memberships, public.app_records from anon, authenticated;

grant select on public.workspace_apps to authenticated;
grant select, insert, update on public.profiles to authenticated;
grant select on public.workspace_admins to authenticated;
grant select on public.app_memberships to authenticated;
grant select, insert, update, delete on public.app_records to authenticated;

-- App registry is readable to signed-in users; only trusted server-side
-- administration (service role) should create or change registry entries.
create policy "signed-in users can read enabled apps"
  on public.workspace_apps for select to authenticated
  using (is_enabled = true);

-- A user can see only their own profile and cannot change its identity.
create policy "users can read own profile"
  on public.profiles for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "users can create own profile"
  on public.profiles for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "users can update own profile"
  on public.profiles for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Admin membership is provisioned only by a trusted administrator through
-- the dashboard initially, then by a server-side admin function.
create policy "admins can read own admin marker"
  on public.workspace_admins for select to authenticated
  using ((select auth.uid()) = user_id);

-- Users can discover only their own app memberships. Client-side writes are
-- intentionally not granted; a trusted admin workflow manages memberships.
create policy "users can read own app memberships"
  on public.app_memberships for select to authenticated
  using ((select auth.uid()) = user_id);

-- Every app record is isolated by both app ID and authenticated owner.
create policy "members can read own app records"
  on public.app_records for select to authenticated
  using (
    owner_id = (select auth.uid())
    and exists (
      select 1 from public.app_memberships m
      where m.app_id = app_records.app_id
        and m.user_id = (select auth.uid())
    )
  );

create policy "members can create own app records"
  on public.app_records for insert to authenticated
  with check (
    owner_id = (select auth.uid())
    and exists (
      select 1 from public.app_memberships m
      where m.app_id = app_records.app_id
        and m.user_id = (select auth.uid())
    )
  );

create policy "members can update own app records"
  on public.app_records for update to authenticated
  using (
    owner_id = (select auth.uid())
    and exists (
      select 1 from public.app_memberships m
      where m.app_id = app_records.app_id
        and m.user_id = (select auth.uid())
    )
  )
  with check (
    owner_id = (select auth.uid())
    and exists (
      select 1 from public.app_memberships m
      where m.app_id = app_records.app_id
        and m.user_id = (select auth.uid())
    )
  );

create policy "members can delete own app records"
  on public.app_records for delete to authenticated
  using (
    owner_id = (select auth.uid())
    and exists (
      select 1 from public.app_memberships m
      where m.app_id = app_records.app_id
        and m.user_id = (select auth.uid())
    )
  );

-- No policy or grant permits anon access. Service-role administration is
-- performed only from trusted server-side tooling, never a browser client.
