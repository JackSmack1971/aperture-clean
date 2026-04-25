# FAILURE_LEDGER — Pareto-Curated Record
<!-- APERTURE-CLEAN v1.0 | RESTRICTED: narrative prose -->

## Systemic Failures (SCOPE Categorization)
<!-- SV (Security) | TE (Tool) | CO (Context) | CV (Constraint) | SD (Schema) | RE (Routing) -->

| Timestamp | Type | Pattern | Branch | Severity |
|:----------|:-----|:--------|:-------|:---------|
| [ISO-UTC] | [TYP]| [Tersely extracted failure signature] | [branch] | MAJOR |

---
## Root Cause Decoders
<!-- Map extracted patterns to permanent fixes here -->
1. **CV: NEVER_pattern** → migrate to RESTRICTED/assert_NOT DSL.
2. **TE: exit_code_1** → check for uninitialized env vars.
3. **CO: reasoning_cliff** → execute STATE_FREEZE protocol.

## Protocol for Entry
1. Read existing ledger BEFORE adding new entries (assert NOT duplicate).
2. Use Haiku 4.5 for extraction routing to maintain low token latency.
3. Keep patterns <100 characters; focus on the error code/exception name.
