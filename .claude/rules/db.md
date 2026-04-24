# DB Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /db -->
<!-- Static content only. No dynamic values. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## Schema Constraints
- Pointer: `db/docs/schema.md` — canonical table definitions, column types, nullability contracts
- Pointer: `db/docs/indexes.md` — index strategy, composite key rationale
- [ ] TODO: Define primary key convention (UUID v4 / ULID / serial)
- [ ] TODO: Define soft-delete pattern (deleted_at timestamp / status enum)
- [ ] TODO: Define audit column standard (created_at, updated_at — auto-managed?)

## Migration Rules
- Pointer: `db/docs/migration-runbook.md` — rollback procedure, zero-downtime protocol
- [ ] TODO: Define migration tool (Flyway / Liquibase / Alembic / custom)
- [ ] TODO: Enforce: migrations are ADDITIVE only — no destructive column drops in a single step
- [ ] TODO: Define naming convention: `YYYYMMDDHHMMSS_<verb>_<table>.sql`
- [ ] TODO: Confirm: all migrations must include a compensating `down` migration

## Query Safety
- [ ] TODO: Define ORM / query builder (raw SQL / SQLAlchemy / Prisma / Drizzle)
- [ ] TODO: Parameterized queries ONLY — no string interpolation into SQL
- [ ] TODO: Define max query result size / pagination contract
- [ ] TODO: Define transaction isolation level standard

## Context Engineering Notes
- Do NOT read full migration history into context — fetch targeted file by timestamp only
- Do NOT dump entire schema.sql — request specific table node via AST or grep exact CREATE TABLE
- Heavy schema reads → delegate to subagent; return compressed summary to orchestrator

## Populated By
- DBA / lead engineer on project onboarding
- Last reviewed: [ TODO: date ]
