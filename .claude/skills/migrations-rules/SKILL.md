# Migrations Rules Skill
<!-- Trigger: Invoke when reading/editing files under /migrations/** -->

## Quick Reference
- DB Migrations: `migrations/db/`
- Data Migrations: `migrations/data/`
- Migration runner: `scripts/migrate.sh`

## Key Constraints
- **NEVER** modify existing migrations; create new ones instead
- **NEVER** run migrations in production without backup verification
- Zero-downtime (additive-only) is the default requirement

## Full Rules
See: `.claude/rules/migrations.md`
