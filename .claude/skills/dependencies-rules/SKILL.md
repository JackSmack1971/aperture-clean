# Dependencies Rules Skill
<!-- Trigger: Invoke when reading/editing package.json, *.lock, or requirements.txt -->

## Quick Reference
- Package manifest: `package.json`
- Lockfile: `package-lock.json`
- CVE scanner: `scripts/audit.sh`

## Key Constraints
- **NEVER** ingest lockfiles (can exceed 80K tokens); use `grep` for specific versions
- **NEVER** add new dependencies without checking CVE status
- Version pinning is MANDATORY for production stability

## Full Rules
See: `.claude/rules/dependencies.md`
