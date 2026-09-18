# APERTURE QUICK REFERENCE
<!-- Goal: Keep context < 38% saturation. Consolidated from the former root + .claude/ copies (2026-09-18). -->

## Context Thresholds
| Limit | Action | Outcome |
|:---|:---|:---|
| 38.0% | `/compact preserve: [...]` | Stability Plateau |
| 43.2% | Stop and compact/hand over now | Self-enforced cap (see `CLAUDE.md`) |
| 80.0% | `HANDOVER.md` + `/clear` | Fallback hard reset |

Check saturation with `/context` — there is no `/tokens` command.

## Domain Rule Loading (Native)
Rules load automatically via `paths:` frontmatter when a matching file is **read** —
do not manually read a rule file first. Full table: `CLAUDE.md`. Gap: loading does not
trigger on Write of a brand-new file in an untouched domain (Read a sibling first).

| Domain | Path | Rule File |
|:---|:---|:---|
| API | `api/**` | `api.md` |
| DB | `db/**` | `db.md` |
| Infra | `infra/**` | `infra.md` |
| Security | `security/**` | `security.md` |
| Testing | `tests/**`, `*.spec.*`, `*.test.*` | `testing.md` |

## Failure Protocol
- Tool error / permission deny / user correction → append to `FAILURE_LEDGER.md` via
  `grep -qF "<pattern>" FAILURE_LEDGER.md || cat >> FAILURE_LEDGER.md <<EOF ... EOF`
  (append-only; no full-file Read needed — grep dedupes).

## WISC Protocol
- **Write**: continuous state persistence to disk.
- **Isolate**: delegate heavy tasks to subagents (`.claude/templates/SUBAGENT.md`).
- **Select**: targeted node/range reads only.
- **Compress**: `/compact` at 38% / `HANDOVER.md` + `/clear` at 80%.

## Compaction Protocol
1. `PreCompact` hook runs `.claude/hooks/pre-compact.sh` automatically and prints a
   `/compact preserve: [...]` command from current git state.
2. Execute the generated `/compact preserve:` command.

## State Freeze Protocol
1. Detect the 43.2% cap or a repeated-failure loop.
2. Generate a `HANDOVER.md` state snapshot.
3. Run `/clear` and resume in a fresh session, reading `HANDOVER.md` first.

## CLI Commands
- `/context` : Check current context saturation and category breakdown.
- `/compact` : Manual memory pruning.
- `/clear` : Flush session context.
- `/cost` : Session cost so far.

## Subagents
- Budget: 500–2,000 tokens per worker.
- Return: compressed summary + file paths only (`.claude/templates/SUBAGENT.md`).
