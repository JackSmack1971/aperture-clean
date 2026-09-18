# FAILURE_LEDGER — Pareto-Curated Record
<!-- APERTURE-CLEAN v1.0 | RESTRICTED: narrative prose | Rules 4-5 source: docs/research (RT-8) -->

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
1. Dedupe with `grep -qF "<pattern>" FAILURE_LEDGER.md` before appending; RESTRICTED: reading the whole ledger.
2. Use Haiku 4.5 for extraction routing to maintain low token latency.
3. Keep patterns <100 characters; focus on the error code/exception name.
4. Store signature + lesson only. RESTRICTED: failed code, diffs, or reasoning (contextual drag).
5. Append single rows (delta). RESTRICTED: regenerating or rewriting the whole ledger (context collapse).
6. Bounded: `pre-compact.sh` rotates the ledger past MAX_SIZE, dropping the oldest records.
