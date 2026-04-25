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



## Domain Rule Index (Manual Load)
⚠️ **MANDATORY:** Read the corresponding rule file **BEFORE** editing files in these paths. If a task spans multiple domains, read **ALL** applicable rules.

| Target Path | Rule File | Primary Constraints |
|:---|:---|:---|
| `/api/**` | `api.md` | Auth, rate limits, contracts |
| `/.github/**`, `/ci/**` | `ci.md` | Pipeline, merge gates, artifacts |
| `*.yaml`, `/config/**` | `config.md` | Arch, secret references |
| `/db/**` | `db.md` | Schema, migrations, query safety |
| `package.json`, `*.lock`| `dependencies.md`| Lockfile law, CVE SLOs |
| `/docs/**` | `docs.md` | ADR protocol, taxonomy |
| `/frontend/**` | `frontend.md` | Components, state, rendering |
| `/infra/**` | `infra.md` | IaC, secrets, blast radius |
| `/logging/**` | `logging.md` | PII scrubbing, JSON schema |
| `/migrations/**` | `migrations.md` | Additive-only, zero-downtime |
| `/monitoring/**` | `monitoring.md` | SLOs, alert standards |
| `/security/**` | `security.md` | SAST, CVE response, crypto |
| `/tests/**`, `*.spec.*`| `testing.md` | Runner config, coverage, fixtures |

## Manual Failure Logging
After any tool error, permission denial, or user correction, you **MUST** record the failure in `FAILURE_LEDGER.md` immediately.
- **Trigger:** Any non-zero exit code or `settings.json` block.
- **Workflow:** `Read(FAILURE_LEDGER.md)` (check for duplicates) → `Write(append new entry)`.

## Context & Attention Discipline
Manual monitoring is required as `/tokens` and hooks are unavailable.
- **Snapshot (50 ops):** Write current decisions to `DECISIONS.md`.
- **Handover (80 ops):** Generate `HANDOVER.md` and request session reset.
- **Hard Enforcement:** State current operation count in every `Write` tool description (e.g., `[Op 42/80] Updating routes`).

## Operational Skills
- `QUICK-REF.md` → Active session cheat sheet (Read frequently)
- `HANDOVER.md` → Session state persistence
- `SUBAGENT.md` → Task delegation briefing (Includes logging/context reminders)
- `FAILURE_LEDGER.md` → Record of failed approaches

> See `.claude/settings.json` for machine-enforced rules.
