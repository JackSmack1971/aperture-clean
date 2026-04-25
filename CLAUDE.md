# CLAUDE.md — Context Engineering Law
<!-- APERTURE-CLEAN v3.2.0 | CLI optimized -->

REQUIRED: path_scoped_injection_only | assert NOT manual_domain_skill_invocation

## WISC Operational Protocol
- **W**rite: persist progress/decisions to disk every 3–5 turns.
- **I**solate: delegate heavy reads to subagents via `.claude/templates/SUBAGENT.md`.
- **S**elect: read targeted line ranges only; RESTRICTED: full-directory ingestion.
- **C**ompress: `/compact preserve:` at 38% | HANDOVER + `/clear` at 80%.

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

**Extraction Routing:** Route all SCOPE failure extraction calls to `claude-haiku-4-5-20251001`.
Haiku executes semantic grouping 4–5× faster than Sonnet with 94.8% SCOPE category accuracy [VERIFIED: CWD doc].

**SCOPE Categories:** SV (Security Violation) | TE (Tool Error) | CO (Context Overflow) |
CV (Constraint Violation) | SD (Schema Divergence) | RE (Routing Error)

## Context & Attention Discipline
Manual monitoring is required as `/tokens` and hooks are unavailable.
- **Snapshot (50 ops):** Write current decisions to `DECISIONS.md`.
- **Handover (80 ops):** Generate `HANDOVER.md` and request session reset.
- **Hard Enforcement:** State current operation count in every `Write` tool description (e.g., `[Op 42/80] Updating routes`).

## Compression Law
<!-- assert NOT compress(rule_files) BELOW 80pct_original_token_count -->

RESTRICTED: rule_file_compression | assert NOT token_count(rule_file) < 0.80 * baseline_token_count

Rationale: Naive syntactic stripping achieves 17% input token reduction but triggers 67% total
session cost escalation due to LLM decompression overhead. Compressing beyond the 10–20% ratio
floor strips syntactic anchors, causing catastrophic constraint violations [VERIFIED: CWD doc].

**Baseline token counts (v1.0 — 80% floor enforcement):**

| Rule File        | Baseline Lines | 80% Floor (lines) |
|:-----------------|---------------:|------------------:|
| api.md           | 37             | 30                |
| ci.md            | 52             | 42                |
| config.md        | 46             | 37                |
| db.md            | 33             | 27                |
| dependencies.md  | 38             | 31                |
| docs.md          | 45             | 36                |
| frontend.md      | 36             | 29                |
| infra.md         | 38             | 31                |
| logging.md       | 48             | 39                |
| migrations.md    | 41             | 33                |
| monitoring.md    | 45             | 36                |
| security.md      | 49             | 40                |
| testing.md       | 45             | 36                |

If compression is required, re-validate all RESTRICTED invariants survive intact before committing.

## Operational Skills
- `QUICK-REF.md` → Active session cheat sheet (Read frequently)
- `HANDOVER.md` → Session state persistence
- `SUBAGENT.md` → Task delegation briefing (Includes logging/context reminders)
- `FAILURE_LEDGER.md` → Record of failed approaches

> See `.claude/settings.json` for machine-enforced rules.
