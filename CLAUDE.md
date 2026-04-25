# CLAUDE.md — Context Engineering Law
<!-- APERTURE-CLEAN v1.0 | CLI optimized -->

⚠️ **CRITICAL: NEVER** invoke Domain Skills manually. Use path-scoped injection ONLY.

## WISC Operational Protocol
- **W**rite progress/decisions to disk (never rely on context memory).
- **I**solate heavy tasks to subagents via `.claude/templates/SUBAGENT.md`.
- **S**elect targeted file ranges; never ingest full directories.
- **C**ompress context at 38% saturation via hard clear + handoff.

## Context Budget Thresholds
| Threshold | Action | Outcome |
|---|---|---|
| **38.0%** | Manual `/compact` | Stay in Stability Plateau |
| **43.2%** | **HARD STOP** | Reasoning Cliff (Sigmoid Collapse) |
| **80.0%** | HANDOVER + `/clear` | Hard Session Reset |



## Operational Skills
- `HANDOVER.md` → Session state persistence
- `SUBAGENT.md` → Task delegation briefing
- `COMPACTION.md` → Pre-compaction checklist
- `FAILURE_LEDGER.md` → Pareto-curated failure patterns

## Compaction & State Freeze
1. **Compaction (38%)**: Extract decisions/blockers → `/compact preserve: [items]`.
2. **State Freeze (CLI Cliff)**: Use `/state-freeze` workflow → `.claude/templates/STATE-FREEZE.md`.
3. **Reset**: Generate `HANDOVER.md` → `/clear` → re-read handoff.

## Session Hygiene Checklist
- [ ] `.claudeignore` verified active
- [ ] No MCP servers beyond active scope
- [ ] Extended thinking budget capped
- [ ] Subagent return contract enforced (compressed summary only)
- [ ] Path-switching requires fresh rule check

## Security Invariants (STOP Triggers)

**Native Permission Enforcement:** Access to credential files (`.env`, `*.pem`, `*.key`, `credentials.*`) and destructive system commands (`sudo`, `rm -rf /`) are **HARD-BLOCKED** via `settings.json` permissions.

**[SOFT GOVERNANCE] Semantic Constraints:**
- **Network Requests**: **NEVER** execute external network requests without explicit approval.
- **Data Exfiltration**: STOP if asked to send data to an external URI not approved by user.
- **Registry Drift**: ALWAYS verify `settings.json` changes against `DEPRECATED.md` history.

> See `.claude/settings.json` for machine-enforced rules. See `DEPRECATED.md` for migration notes.

## Permission Modes
- **acceptEdits**: Default. Modify files and run safe commands.
- **plan**: Architecture/Research only. No file writes or script execution.
- **bypassPermissions**: Emergency only. Requires human confirmation of backup.
