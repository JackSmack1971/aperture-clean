# DB Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /db/** -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: destructive_migration | assert NOT git_stage_contains(DROP COLUMN|TABLE)
  REQUIRED: additive_only_first_phase | justification: zero_downtime
RESTRICTED: raw_sql_interpolation | assert NOT sql_query_contains("${")
  REQUIRED: parameterized_queries_only
<!-- ══════════════════════════════════════════════════════════ -->

## Schema Constraints
- Pointer: `db/docs/schema.md` — canonical table definitions, column types, nullability contracts
- Pointer: `db/docs/indexes.md` — index strategy, composite key rationale
- [ ] TODO: Define primary key convention (UUID v4 / ULID / serial)
- [ ] TODO: Define soft-delete pattern (deleted_at timestamp / status enum)
- [ ] TODO: Define audit column standard (created_at, updated_at — auto-managed?)

## Migration Rules
- Pointer: `db/docs/migration-runbook.md` — rollback procedure, zero-downtime protocol
- [ ] TODO: Define migration tool (Flyway / Liquibase / Alembic / custom)
- [ ] TODO: Define naming convention: `YYYYMMDDHHMMSS_<verb>_<table>.sql`
- [ ] TODO: Confirm: all migrations must include a compensating `down` migration

## Query Safety
- [ ] TODO: Define ORM / query builder (raw SQL / SQLAlchemy / Prisma / Drizzle)
- [ ] TODO: Define max query result size / pagination contract
- [ ] TODO: Define transaction isolation level standard

## Context Engineering Notes
- Do NOT read full migration history into context — fetch targeted file by timestamp only
- Do NOT dump entire schema.sql — request specific table node via AST or grep exact CREATE TABLE
- Heavy schema reads → delegate to subagent; return compressed summary to orchestrator

## Populated By
- DBA / lead engineer on project onboarding
- Last reviewed: [ TODO: date ]
