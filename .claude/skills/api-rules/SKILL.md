# API Rules Skill
<!-- Trigger: Invoke when reading/editing files under /api/** -->

## Quick Reference
- Auth middleware: `api/middleware/auth.ts`
- Rate limiting: `api/middleware/ratelimit.ts`
- Routes: `api/routes/`

## Key Constraints
- **NEVER** log PII (email, tokens, passwords)
- **NEVER** dump full route registries
- All response bodies MUST follow JSON:API spec

## Full Rules
See: `.claude/rules/api.md`
