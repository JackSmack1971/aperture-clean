# Monitoring Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected when agent reads /monitoring/** or dashboard files -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: dashboard_json_read | assert NOT read_path MATCHES "*.dashboard.json"
  REQUIRED: api_query_only | target: [Grafana_API, Datadog_API]
RESTRICTED: prometheus_rule_read | assert NOT read_path MATCHES "rules/*.yaml"
  REQUIRED: grep_query_only | target: exact_alert_name
<!-- ══════════════════════════════════════════════════════════ -->

## Observability Stack
- Pointer: `docs/observability.md` — full stack architecture, data flow
- Pointer: `monitoring/docs/runbook.md` — alert response procedures
- [ ] TODO: Define metrics platform (Prometheus / Datadog / CloudWatch)
- [ ] TODO: Define tracing platform (Jaeger / Zipkin / OpenTelemetry)
- [ ] TODO: Define log aggregation platform (Loki / ELK / Splunk)

## SLO Definitions
- Pointer: `docs/slos.md` — per-service SLO targets
- [ ] TODO: Define availability SLO per tier
- [ ] TODO: Define latency SLO per tier
- [ ] TODO: Define error rate SLO

## Alert Standards
- [ ] TODO: Every alert must have a corresponding runbook entry
- [ ] TODO: Enforce: no alert without: severity + owner + runbook link
- [ ] TODO: Define severity routing: critical → page; warning → slack

## Dashboard Governance
- [ ] TODO: Dashboard source of truth: version-controlled JSON
- [ ] TODO: Enforce: no manual dashboard edits in UI
- [ ] TODO: Define dashboard naming convention

## Context Engineering Notes
- Do NOT read raw dashboard JSON — use API for targeted panel data
- Do NOT read full Prometheus rule files — grep for specific alert name only
- For SLO analysis: fetch burn rate data via metrics API
- Alert rule changes → subagent returns modified alert names + threshold deltas

## Populated By
- Platform / SRE lead on project onboarding
- Last reviewed: [ TODO: date ]
