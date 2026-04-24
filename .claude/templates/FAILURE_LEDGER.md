# FAILURE_LEDGER.md — Persistent Cross-Session Failure Record
<!--
  PURPOSE: Record approaches that were attempted and failed — permanently.
  This file lives at the PROJECT ROOT and accumulates across all sessions.
  It is NEVER cleared. It is NEVER summarized away.
  Every future agent reads this before proposing solutions.

  APPEND ONLY. Never delete entries.
  Format: [YYYY-MM-DD] [domain] [approach] → [why it failed]
-->

## Usage
- Initialize this file at project root on first session: cp .claude/templates/FAILURE_LEDGER.md FAILURE_LEDGER.md
- Append one line per failed approach BEFORE abandoning it
- Reference from HANDOVER.md: "New deprecated paths this session — see FAILURE_LEDGER.md"
- Agent reads this at session start: "Read FAILURE_LEDGER.md before proposing any solution"

## Append Format

[YYYY-MM-DD] [tag] [domain] [approach attempted] → [exact reason it failed / conflict encountered]

## Pareto Curation Protocol
**The Pareto boundary:** ~80% of agent failures stem from ~20% of root causes.
The optimal ledger contains 10–20 high-fidelity SYSTEMIC entries.
Beyond this boundary, additional entries dilute signal without reducing uncertainty.

Tag every entry at append time:
- `[SYSTEMIC]` — recurs across sessions or domains; represents a root-cause pattern
- `[TRANSIENT]` — single occurrence; environment-specific anomaly

**Pareto rules:**
- SYSTEMIC entries: **NEVER DELETE.** They represent structural knowledge.
- TRANSIENT entries: Review quarterly. Prune if the environment has changed.
- Entries >90 days old against a dependency that has since updated:
  supersede with a new entry rather than deleting. Format:
  `[YYYY-MM-DD] [domain] SUPERSEDES [original-date]: [new finding]`

**Pareto Boundary Warning:** If ledger exceeds 20 entries, audit TRANSIENT tags
before adding new entries. Ledger bloat degrades retrieval signal.

## Example Entries

[2026-04-22] [SYSTEMIC] auth      JWT with httpOnly cookies → incompatible with existing SPA routing; CORS preflight failures on refresh
[2026-04-22] [TRANSIENT] db       Prisma migrate deploy in CI → schema drift on staging; requires prisma migrate reset first
[2026-04-22] [SYSTEMIC] frontend  Zustand global store for form state → re-render cascade on large forms; reverted to local useState

## Active Ledger
<!-- ENTRIES BEGIN BELOW THIS LINE — newest at bottom -->
