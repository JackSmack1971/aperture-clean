# Config Rules Skill
<!-- Trigger: Invoke when reading/editing *.yaml, *.toml, or files under /config/** -->

## Quick Reference
- Env template: `.env.example`
- Feature flags: `config/features.yaml`
- App config: `config/app.toml`

## Key Constraints
- **NEVER** write raw secrets to YAML files; use `${VAR}` syntax
- **NEVER** ingest full config directories; read targeted keys only
- Configuration changes REQUIRE validation against schema

## Full Rules
See: `.claude/rules/config.md`
