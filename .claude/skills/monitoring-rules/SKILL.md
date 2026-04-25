# Monitoring Rules Skill
<!-- Trigger: Invoke when reading/editing files under /monitoring/** or *.dashboard.json -->

## Quick Reference
- Grafana: `monitoring/grafana/`
- Prometheus: `monitoring/prometheus/`
- Alertmanager: `monitoring/alertmanager/`

## Key Constraints
- **NEVER** ingest full dashboard JSON files (can be huge); read targeted panels only
- **NEVER** create alerts without defined SLOs (Service Level Objectives)
- Alert thresholds MUST be reviewed quarterly

## Full Rules
See: `.claude/rules/monitoring.md`
