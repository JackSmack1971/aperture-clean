# API Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /api/** -->
<!-- Static content only. No secrets, no tokens, no env values. Cache-compatible. -->

<!-- ═══════════════ HARD STOPS — READ FIRST ═══════════════ -->
<!-- assert NOT read(env_files) — credentials via OS keychain / secret manager ONLY -->
RESTRICTED: env_file_read | assert NOT read_path MATCHES ".env*"
  REQUIRED: credential_source IN [os_keychain, secret_manager, placeholder_convention]
RESTRICTED: auth_body_log | assert NOT log_contains(request_body) WHERE path MATCHES auth_endpoints
  validation_key: pii_absent_from_logs
<!-- assert NOT reorder(middleware_chain) — CLAUDE.md Security Invariants §API -->
<!-- ═══════════════════════════════════════════════════════ -->

## Auth Middleware
- Pointer: `docs/auth-flow.md` — full JWT/session lifecycle, token refresh logic, revocation strategy
- Pointer: `api/middleware/README.md` — middleware chain order (REQUIRED: assert NOT reordered)
- [ ] TODO: Define auth mechanism (JWT / OAuth2 / API Key / mTLS)
- [ ] TODO: Define token storage contract (httpOnly cookie / Authorization header)
- [ ] TODO: Define privilege escalation path and RBAC role taxonomy

## Rate Limiting
- Pointer: `docs/rate-limit-policy.md` — per-route limits, burst allowances, backoff contract
- [ ] TODO: Define rate limit implementation (Redis token bucket / leaky bucket / fixed window)
- [ ] TODO: Define 429 response schema: must include `Retry-After` header
- [ ] TODO: Define exemption policy (internal service tokens / admin keys)

## API Contract Standards
- [ ] TODO: Define versioning strategy (`/v1/` prefix / header-based / semver)
- [ ] TODO: Define error envelope schema: `{ error: { code, message, details[] } }`
- [ ] TODO: Define pagination contract (cursor / offset — pick ONE, enforce globally)
- [ ] TODO: OpenAPI spec location: `api/docs/openapi.yaml` — agent must check before adding routes

## Secrets & Logging
- [ ] TODO: Define secret placeholder convention: `{{SERVICE_API_KEY}}`

## Context Engineering Notes
- Do NOT read full route registry to answer a single endpoint question — grep target route file only
- Middleware chain reads → subagent only; return compressed dependency order to orchestrator
- Auth logic is high-criticality: fetch full function node, not just signature

## Populated By
- Security lead / API architect on project onboarding
- Last reviewed: [ TODO: date ]
