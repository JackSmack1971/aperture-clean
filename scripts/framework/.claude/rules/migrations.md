# Migrations Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected when agent reads /migrations/** or /db/migrations/** -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: destructive_migration | assert NOT git_stage_contains(DROP COLUMN|TABLE)
  REQUIRED: additive_only_first_phase | justification: zero_downtime
RESTRICTED: migration_override | assert NOT git_stage_contains(EDIT) WHERE status == applied
  REQUIRED: new_migration_file_only
<!-- ══════════════════════════════════════════════════════════ -->

## Migration Tooling
- Pointer: `db/docs/migration-runbook.md` — full rollback procedures, zero-downtime protocol
- Pointer: `db/docs/schema.md` — current canonical schema state
- [ ] TODO: Define migration tool (Flyway / Liquibase / Alembic / golang-migrate)
- [ ] TODO: Define migration file naming: `V{YYYYMMDDHHMMSS}__{description}.sql`
- [ ] TODO: Define migration state table name and location

## Authoring Rules
- **Migrations are ADDITIVE only.** No destructive column/table drops in a single step.
- **Every migration MUST have a `down` counterpart.** No exceptions.
- [ ] TODO: Enforce: migrations must be idempotent where tooling supports it
- [ ] TODO: Enforce: no data transformations in schema migrations

## Zero-Downtime Protocol
- [ ] TODO: Define deploy order: migrate → deploy app → cleanup migration
- [ ] TODO: Define column rename procedure (4 deploys)
- [ ] TODO: Define index creation strategy: `CREATE INDEX CONCURRENTLY`
- [ ] TODO: Enforce: long-running migrations run during low-traffic window

## Versioning & History
- [ ] TODO: Define squash policy: squash migrations at major version boundaries only
- [ ] TODO: Baseline migration exists for onboarding new environments: `V0__baseline.sql`
- [ ] TODO: Migration history table is read-only to application

## Context Engineering Notes
- RESTRICTED: full_migration_dir_read | REQUIRED: read named migration file by timestamp only
- To understand current schema: read `db/docs/schema.md` — NOT the migration chain
- For migration conflict resolution → subagent reads conflicting files; returns version ordering only
- Large squashed migrations → subagent reads and returns table-level change summary only

## Populated By
- DBA / backend lead on project onboarding
- Last reviewed: [ TODO: date ]
