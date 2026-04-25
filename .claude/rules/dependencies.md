# Dependencies Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected when agent reads package.json, *.lock, etc. -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: lockfile_read | assert NOT read_path MATCHES "*.lock"
  REQUIRED: bash_list_command | example: "npm list <pkg>"
RESTRICTED: latest_version_spec | assert NOT version_specifier MATCHES ["*", "latest"]
  REQUIRED: exact_pins_in_production
<!-- ══════════════════════════════════════════════════════════ -->

## Package Management
- Pointer: `docs/dependency-policy.md` — approved registries, license allowlist, version pinning strategy
- [ ] TODO: Define package manager (npm / pnpm / yarn / pip / poetry / cargo / go modules)
- [ ] TODO: Define version pinning policy: exact pins in production (`"react": "18.3.1"` NOT `"^18"`)
- [ ] TODO: Define private registry configuration and auth mechanism
- [ ] TODO: Enforce: no direct edits to lockfiles — only package manager commands

## Audit & Security
- [ ] TODO: Define vulnerability scan tool (npm audit / pip-audit / cargo audit / Snyk / Dependabot)
- [ ] TODO: Define severity threshold for blocking: CRITICAL and HIGH block merge
- [ ] TODO: Define CVE remediation SLO: CRITICAL ≤ 24h / HIGH ≤ 7 days
- [ ] TODO: SBOM output format and location: `sbom/` (in `.claudeignore`)

## Upgrade Protocol
- [ ] TODO: Define dependency update cadence (weekly automated PRs / manual quarterly review)
- [ ] TODO: Define major version upgrade process: requires ADR entry in `docs/decisions/`
- [ ] TODO: Enforce: peer dependency conflicts must be resolved before merge

## Forbidden Patterns
- [ ] TODO: No `postinstall` scripts from third-party packages without security review
- [ ] TODO: No packages with zero maintainers or >2 years without update (flag for review)

## Context Engineering Notes
- **RESTRICTED: read lockfiles** — they are `.claudeignore`d; `package-lock.json` can exceed 80K tokens
- To answer "what version of X is installed": run `npm list X` or `pip show X` via bash
- To audit vulnerabilities: run `npm audit --json` and extract only HIGH/CRITICAL entries
- Dependency tree analysis → subagent runs `npm ls --depth=2`; returns compressed dependency list only
- When adding a package: confirm it exists in `docs/dependency-policy.md` approved list first

## Populated By
- Lead engineer / security lead on project onboarding
- Last reviewed: [ TODO: date ]
