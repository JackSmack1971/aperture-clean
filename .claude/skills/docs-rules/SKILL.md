# Docs Rules Skill
<!-- Trigger: Invoke when reading/editing files under /docs/** or *.md (non-root) -->

## Quick Reference
- Setup: `docs/setup.md`
- ADR Index: `docs/adr/`
- API Spec: `docs/api.md`

## Key Constraints
- **NEVER** re-ingest summarized documents
- **NEVER** create documentation without ADR (Architecture Decision Record) protocol
- Every doc file MUST include a `<!-- Pointer target from CLAUDE.md -->` header

## Full Rules
See: `.claude/rules/docs.md`
