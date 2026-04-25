# Aperture QUICK-REF
<!-- Manual Governance Cheat Sheet -->

## Rule Loading
- `/api` → `api.md` | `/db` → `db.md` | `/infra` → `infra.md`
- `package.json` → `dependencies.md` | `*.spec.ts` → `testing.md`
- **MANDATORY:** Read rules **BEFORE** editing.

## Failure Protocol
- Tool Error / Permission Deny? → **Log to FAILURE_LEDGER.md**
- Check for duplicates first.

## Context Monitoring
- **50 Ops:** Snapshot to `DECISIONS.md`.
- **80 Ops:** Handover to `HANDOVER.md` + Session Reset.
- **Tagging:** Include `[Op X/80]` in all Write tool descriptions.

## Subagents
- Budget: 500-2,000 tokens per worker.
- Return: Compressed summary + file paths only.
