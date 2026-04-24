# CI Rules Skill
<!-- Trigger: Invoke when reading/editing files under /.github/** or /ci/** -->

## Quick Reference
- Workflows: `.github/workflows/`
- Dockerfiles: `ci/docker/`
- Build scripts: `scripts/build.sh`

## Key Constraints
- **NEVER** modify CI secrets without authorization
- **NEVER** push to `main` without successful local build
- All PRs REQUIRE passing CI check before merge

## Full Rules
See: `.claude/rules/ci.md`
