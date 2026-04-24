# Logging Rules Skill
<!-- Trigger: Invoke when reading/editing logging/telemetry files or *.log -->

## Quick Reference
- Logger config: `src/utils/logger.ts`
- Telemetry: `src/utils/telemetry.ts`
- Log schema: `docs/logging-schema.json`

## Key Constraints
- **NEVER** log PII or raw secrets
- **NEVER** ingest raw log files (>10MB); use `grep` or `tail` for context
- All logs MUST be in structured JSON format

## Full Rules
See: `.claude/rules/logging.md`
