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

## Domain Skills Index (Path-Scoped)
- `/api` → api.md | `/db` → db.md | `/infra` → infra.md | `/sec` → security.md
- `/frontend` → frontend.md | `/config` → config.md | `/ci` → ci.md
- `*.test.*` → testing.md | `package.json` → dependencies.md
- `/migrations` → migrations.md | `/monitoring` → monitoring.md
- `/docs` → docs.md | `*.log` → logging.md

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
