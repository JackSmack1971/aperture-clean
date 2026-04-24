# Dependencies Rules — Path-Scoped Context
<!-- Injected when agent reads: package.json, requirements.txt, go.mod, Cargo.toml, *.lock, pyproject.toml -->
<!-- CRITICAL: Lockfiles are in .claudeignore. NEVER read lockfiles directly. -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

## Package Management
- Pointer: `docs/dependency-policy.md` — approved registries, license allowlist, version pinning strategy
- [ ] TODO: Define package manager (npm / pnpm / yarn / pip / poetry / cargo / go modules)
- [ ] TODO: Define version pinning policy: exact pins in production (`"react": "18.3.1"` NOT `"^18"`)
- [ ] TODO: Define private registry configuration and auth mechanism
- [ ] TODO: Enforce: no direct edits to lockfiles — only package manager commands

## Audit & Security
- [ ] TODO: Define vulnerability scan tool (npm audit / pip-audit / cargo audit / Snyk / Dependabot)
- [ ] TODO: Define severity threshold for blocking: CRITICAL and HIGH block merge; MODERATE = tracked
- [ ] TODO: Define CVE remediation SLO: CRITICAL ≤ 24h / HIGH ≤ 7 days / MODERATE ≤ 30 days
- [ ] TODO: SBOM output format and location: `sbom/` (in `.claudeignore` — never read directly)

## Upgrade Protocol
- [ ] TODO: Define dependency update cadence (weekly automated PRs / manual quarterly review)
- [ ] TODO: Define major version upgrade process: requires ADR entry in `docs/decisions/`
- [ ] TODO: Enforce: peer dependency conflicts must be resolved before merge — no `--legacy-peer-deps` in CI

## Forbidden Patterns
- [ ] TODO: No `*` or `latest` version specifiers in any production manifest
- [ ] TODO: No `postinstall` scripts from third-party packages without security review
- [ ] TODO: No packages with zero maintainers or >2 years without update (flag for review)

## Context Engineering Notes
- **NEVER read lockfiles** — they are `.claudeignore`d; `package-lock.json` alone can exceed 80K tokens
- To answer "what version of X is installed": run `npm list X` or `pip show X` via bash — do NOT read lock
- To audit vulnerabilities: run `npm audit --json` and extract only HIGH/CRITICAL entries
- Dependency tree analysis → subagent runs `npm ls --depth=2`; returns compressed dependency list only
- When adding a package: confirm it exists in `docs/dependency-policy.md` approved list first

## Populated By
- Lead engineer / security lead on project onboarding
- Last reviewed: [ TODO: date ]
