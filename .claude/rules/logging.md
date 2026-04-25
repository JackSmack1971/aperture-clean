# Logging Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits logging/observability files -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: log_pii | assert NOT log_field IN [passwords, tokens, api_keys, session_ids, raw_auth_headers]
RESTRICTED: log_financial_id | assert NOT log_field IN [credit_card_full, ssn, government_id]
RESTRICTED: log_auth_body | assert NOT log_source == auth_endpoint_raw_body
validation_key: pii_absent
<!-- ══════════════════════════════════════════════════════════ -->

## Log Level Taxonomy
- Pointer: `docs/observability.md` — alerting thresholds, SLO targets, dashboard locations
- Pointer: `infra/docs/log-pipeline.md` — transport (stdout / file / remote sink), retention policy
- [ ] TODO: Define logging library (Winston / Pino / structlog / zap / slog)
- [ ] TODO: Enforce level semantics:
  - `ERROR`  → requires human action; always triggers alert
  - `WARN`   → degraded state; does not page
  - `INFO`   → normal operational events; low cardinality
  - `DEBUG`  → disabled in production; enabled per-service via env flag only
  - `TRACE`  → never enabled in production under any circumstance

## Structured JSON Schema
- [ ] TODO: Define mandatory fields for every log line:
  - `timestamp` — ISO 8601 UTC
  - `level` — normalized string
  - `service` — service/module name
  - `trace_id` — correlation ID (must propagate across service boundaries)
  - `message` — human-readable, static string (NO dynamic interpolation into message field)
- [ ] TODO: Dynamic data goes in structured `context` / `fields` object — never in `message`
- [ ] TODO: Define log schema location: `docs/log-schema.json`

## PII Policy
- [ ] TODO: Define PII field allowlist (fields permitted in logs): `docs/pii-policy.md`
- [ ] TODO: Define scrubber middleware location and test coverage requirement (100% on scrubber)
- [ ] TODO: Define masking pattern for partial values: `user_email: "j***@example.com"`

## Correlation & Tracing
- [ ] TODO: Define trace ID propagation header: `X-Trace-Id` / `traceparent` (W3C)
- [ ] TODO: Define sampling rate for distributed traces in production
- [ ] TODO: Enforce: trace ID must be present on ALL error-level log lines

## Context Engineering Notes
- Do NOT read raw log files into context — they are in `.claudeignore` for this reason
- Do NOT paste stack traces verbatim — extract error type, message, and top 3 frames only
- Log pipeline config reads → subagent; return transport config summary to orchestrator
- If agent encounters a credential or PII value in a log sample: STOP, redact before continuing

## Populated By
- Platform / observability lead on project onboarding
- Last reviewed: [ TODO: date ]
