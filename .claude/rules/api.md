# API Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /api -->
<!-- Static content only. No secrets, no tokens, no env values. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## Auth Middleware
- Pointer: `docs/auth-flow.md` — full JWT/session lifecycle, token refresh logic, revocation strategy
- Pointer: `api/middleware/README.md` — middleware chain order (MUST NOT be reordered)
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

## Security Invariants
- **NEVER** read `.env` files — credentials use OS keychain / secret manager placeholders only
- **NEVER** log request bodies containing auth tokens or PII fields
- [ ] TODO: Define secret placeholder convention: `{{SERVICE_API_KEY}}`

## Context Engineering Notes
- Do NOT read full route registry to answer a single endpoint question — grep target route file only
- Middleware chain reads → subagent only; return compressed dependency order to orchestrator
- Auth logic is high-criticality: fetch full function node, not just signature

## Populated By
- Security lead / API architect on project onboarding
- Last reviewed: [ TODO: date ]
