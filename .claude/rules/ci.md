# CI Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /.github or /ci files -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: pipeline_secret | assert NOT yaml_contains_raw_secret
  REQUIRED: platform_secret_reference_only | expected: "${{ secrets.NAME }}"
RESTRICTED: status_check_bypass | assert NOT git_stage_contains(continue_on_error: true)
  target: [security, tests, build]
<!-- ══════════════════════════════════════════════════════════ -->

## Pipeline Architecture
- Pointer: `ci/docs/pipeline-map.md` — stage DAG, job dependencies, trigger conditions
- Pointer: `ci/docs/runner-inventory.md` — runner tags, hardware profiles, concurrency limits
- [ ] TODO: Define CI platform (GitHub Actions / GitLab CI / CircleCI / Buildkite / Jenkins)
- [ ] TODO: Define pipeline config entry point: `.github/workflows/` / `.gitlab-ci.yml`
- [ ] TODO: Define branch protection rules: required checks before merge to `main`

## Required Checks (Merge Gates)
- [ ] TODO: List ALL required status checks — incomplete list = security gap:
  - [ ] Lint
  - [ ] Unit tests (coverage threshold enforced)
  - [ ] Integration tests
  - [ ] Security scan (SAST / dependency audit)
  - [ ] Build artifact validation
- [ ] TODO: Define test parallelization strategy (matrix / shard count)

## Artifact Management
- [ ] TODO: Define artifact output paths and naming convention
- [ ] TODO: Define artifact retention policy per environment
- [ ] TODO: Define artifact signing / attestation requirement (SLSA level target)

## Secret Policy
- [ ] TODO: Define secret reference syntax: `${{ secrets.NAME }}` / `$SECRET_NAME`
- [ ] TODO: Define secret rotation trigger: rotation must auto-invalidate cached pipeline runs
- [ ] TODO: Enforce: secrets masked in all log output (platform setting — verify it is ON)

## Failure Triage Protocol
- [ ] TODO: Define flaky test policy: tag `@flaky`, quarantine to non-blocking suite within 24h
- [ ] TODO: Define pipeline failure notification target (Slack channel / PagerDuty / email)
- [ ] TODO: Define max pipeline duration SLO

## Context Engineering Notes
- Do NOT read full CI run logs into context — they are in `.claudeignore`
- For failure diagnosis: extract job name + last 20 lines of failing step ONLY
- Do NOT read artifact binaries — inspect manifest/metadata files only
- Pipeline YAML reads for refactoring → subagent parses full config, returns job dependency graph only
- Stack traces from CI → apply logging.md rule: type + message + top 3 frames only

## Populated By
- Platform / DevOps lead on project onboarding
- Last reviewed: [ TODO: date ]
