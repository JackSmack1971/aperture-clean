# Migrations Rules — Path-Scoped Context
<!-- Injected when agent reads: /migrations/**, /db/migrations/**, *.migration.*, schema_migrations -->
<!-- Standalone from db.md — activated specifically on migration file access. -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

## Migration Tooling
- Pointer: `db/docs/migration-runbook.md` — full rollback procedures, zero-downtime protocol
- Pointer: `db/docs/schema.md` — current canonical schema state (do not derive from migration history)
- [ ] TODO: Define migration tool (Flyway / Liquibase / Alembic / golang-migrate / Knex / Prisma)
- [ ] TODO: Define migration file naming: `V{YYYYMMDDHHMMSS}__{description}.sql`
- [ ] TODO: Define migration state table name and location

## Authoring Rules (Hard Stops)
- **Migrations are ADDITIVE only.** Never drop a column, table, or constraint in the same migration that removes its application usage. Two-phase deploy required.
- **Every migration MUST have a `down` counterpart.** No exceptions for production migrations.
- [ ] TODO: Enforce: migrations must be idempotent where tooling supports it
- [ ] TODO: Enforce: no data transformations in schema migrations — use separate data migration scripts
- [ ] TODO: Enforce: migrations reviewed by DBA before merge to main

## Zero-Downtime Protocol
- [ ] TODO: Define deploy order for breaking changes: migrate → deploy app → cleanup migration
- [ ] TODO: Define column rename procedure: add new → dual-write → backfill → remove old (4 deploys)
- [ ] TODO: Define index creation strategy: `CREATE INDEX CONCURRENTLY` (Postgres) or equivalent
- [ ] TODO: Enforce: long-running migrations run during low-traffic window with explicit lock timeout

## Versioning & History
- [ ] TODO: Define squash policy: squash migrations at major version boundaries only
- [ ] TODO: Enforce: never modify a migration that has been applied to any non-local environment
- [ ] TODO: Baseline migration exists for onboarding new environments: `V0__baseline.sql`
- [ ] TODO: Migration history table is read-only to application — no app-level writes

## Context Engineering Notes
- RESTRICTED: full_migration_dir_read | REQUIRED: read named migration file by timestamp only
- To understand current schema: read `db/docs/schema.md` — NOT the migration chain
- To debug a specific migration: read ONLY the named migration file by timestamp
- For migration conflict resolution → subagent reads conflicting files; returns version ordering only
- Large squashed migrations → subagent reads and returns table-level change summary only

## Populated By
- DBA / backend lead on project onboarding
- Last reviewed: [ TODO: date ]
