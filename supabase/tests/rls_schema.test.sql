begin;

select plan(10);

select has_table('public', 'workspace_apps', 'workspace app registry exists');
select has_table('public', 'profiles', 'profile table exists');
select has_table('public', 'workspace_admins', 'workspace admin table exists');
select has_table('public', 'app_memberships', 'app membership table exists');
select has_table('public', 'app_records', 'app records table exists');

select ok((select relrowsecurity from pg_class where oid = 'public.workspace_apps'::regclass), 'workspace_apps has RLS enabled');
select ok((select relrowsecurity from pg_class where oid = 'public.profiles'::regclass), 'profiles has RLS enabled');
select ok((select relrowsecurity from pg_class where oid = 'public.workspace_admins'::regclass), 'workspace_admins has RLS enabled');
select ok((select relrowsecurity from pg_class where oid = 'public.app_memberships'::regclass), 'app_memberships has RLS enabled');
select ok((select relrowsecurity from pg_class where oid = 'public.app_records'::regclass), 'app_records has RLS enabled');

select * from finish();
rollback;
