# DB Rules Skill
<!-- Trigger: Invoke when reading/editing files under /db/** or /migrations/** -->

## Quick Reference
- Schema: `db/schema.sql`
- Migrations: `db/migrations/`
- Connection pool: `db/pool.ts`

## Key Constraints
- **NEVER** run `DROP TABLE` without explicit human approval
- **NEVER** dump the entire schema; fetch targeted table definitions only
- All migrations MUST be additive-only

## Full Rules
See: `.claude/rules/db.md`
