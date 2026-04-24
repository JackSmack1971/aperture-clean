# Security Rules Skill
<!-- Trigger: Invoke when reading/editing files under /security/** or *.sarif -->

## Quick Reference
- SAST Results: `security/scans/`
- Audit log: `security/audit.log`
- Secrets policy: `docs/security.md`

## Key Constraints
- **NEVER** commit plain-text secrets
- **NEVER** bypass CORS headers in development
- All external API calls MUST use HTTPS/TLS 1.3

## Full Rules
See: `.claude/rules/security.md`
