#!/usr/bin/env node
import { existsSync, readFileSync } from "node:fs";

const fail = message => {
  console.error("Backend validation failed: " + message);
  process.exit(1);
};

const migrationPath = "supabase/migrations/20261128130000_workspace_backend_v1.sql";
const testPath = "supabase/tests/rls_schema.test.sql";
const readmePath = "governance/BACKEND_STANDARD.md";
for (const file of [migrationPath, testPath, readmePath]) {
  if (!existsSync(file)) fail("Missing " + file);
}

const sql = readFileSync(migrationPath, "utf8").toLowerCase();
const expectedTables = ["workspace_apps", "profiles", "workspace_admins", "app_memberships", "app_records"];
for (const table of expectedTables) {
  if (!sql.includes("create table if not exists public." + table)) fail("Missing table " + table);
  if (!sql.includes("alter table public." + table + " enable row level security")) fail("RLS is not explicitly enabled for " + table);
}
if (!sql.includes("owner_id = (select auth.uid())")) fail("App records must be scoped to auth.uid().");
if (!sql.includes("m.app_id = app_records.app_id")) fail("App records must be scoped to app_id membership.");
if (!sql.includes("with check (") || !sql.includes("for update")) fail("Update policies must include WITH CHECK.");
if (/password|encrypted_password|service_role_key|service_role\s*[:=]/i.test(sql)) fail("Credentials or privileged keys must never be stored in this migration.");
const tests = readFileSync(testPath, "utf8").toLowerCase();
if (!tests.includes("select plan(10)") || !tests.includes("select * from finish()")) fail("pgTAP schema test is incomplete.");
console.log("Backend contract valid: 5 tables, RLS enabled, owner/app scope and pgTAP schema checks present.");
