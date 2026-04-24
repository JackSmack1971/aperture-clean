# Monitoring Rules — Path-Scoped Context
<!-- Injected when agent reads: /monitoring/**, *.dashboard.json, alert rules, Prometheus configs -->
<!-- CRITICAL: Dashboard JSON and rule files are in .claudeignore — never read raw. -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

## Observability Stack
- Pointer: `docs/observability.md` — full stack architecture, data flow, retention policies
- Pointer: `monitoring/docs/runbook.md` — alert response procedures, escalation path
- [ ] TODO: Define metrics platform (Prometheus / Datadog / CloudWatch / Grafana Cloud)
- [ ] TODO: Define tracing platform (Jaeger / Zipkin / OpenTelemetry / Datadog APM)
- [ ] TODO: Define log aggregation platform (Loki / ELK / CloudWatch Logs / Splunk)
- [ ] TODO: Define instrumentation library: OpenTelemetry SDK (preferred — vendor-neutral)

## SLO Definitions
- Pointer: `docs/slos.md` — per-service SLO targets, error budget burn rates
- [ ] TODO: Define availability SLO per tier: <!-- e.g. Tier 1: 99.9% / Tier 2: 99.5% -->
- [ ] TODO: Define latency SLO per tier: <!-- e.g. p99 < 500ms for user-facing APIs -->
- [ ] TODO: Define error rate SLO: <!-- e.g. < 0.1% 5xx on critical paths -->
- [ ] TODO: Error budget burn rate alert at: 2% / 5% / 10% (fast-burn / slow-burn thresholds)

## Alert Standards
- [ ] TODO: Every alert must have a corresponding runbook entry in `monitoring/docs/runbook.md`
- [ ] TODO: Enforce: no alert without: severity label + owner label + runbook link
- [ ] TODO: Define severity routing:
  - `critical` → PagerDuty (immediate page)
  - `warning`  → Slack #alerts channel
  - `info`     → Logged only; no notification
- [ ] TODO: Define alert deduplication window to prevent flapping noise

## Dashboard Governance
- [ ] TODO: Dashboard source of truth: version-controlled JSON in `monitoring/dashboards/`
- [ ] TODO: Enforce: no manual dashboard edits in UI — all changes via code + deploy pipeline
- [ ] TODO: Define dashboard naming convention: `<service>-<layer>.json`
- [ ] TODO: Grafana dashboard JSON is in `.claudeignore` — query via Grafana API if inspection needed

## Context Engineering Notes
- **NEVER** read raw dashboard JSON — files are enormous; use Grafana HTTP API for targeted panel data
- **NEVER** read full Prometheus rule files — grep for specific alert name only
- For SLO analysis: fetch burn rate data via metrics API; do NOT read config files as proxy
- Alert rule changes → subagent reads rule file, returns only modified alert names + threshold deltas
- Runbook reads → fetch targeted incident section only, not full document

## Populated By
- Platform / SRE lead on project onboarding
- Last reviewed: [ TODO: date ]
