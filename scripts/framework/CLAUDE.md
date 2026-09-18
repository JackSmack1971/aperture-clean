# CLAUDE.md — Context Engineering Law
<!-- APERTURE-CLEAN v3.3.0 | CLI optimized -->

REQUIRED: path_scoped_injection_only | assert NOT manual_domain_skill_invocation

## WISC Operational Protocol
- **W**rite: persist progress/decisions to disk continuously (HANDOVER.md at session boundaries).
- **I**solate: delegate heavy reads to subagents via `.claude/templates/SUBAGENT.md`.
- **S**elect: read targeted line ranges only; RESTRICTED: full-directory ingestion.
- **C**ompress: `/compact preserve:` at 38% | HANDOVER + `/clear` at 80%.

## Context Budget Thresholds
Run `/context` to check current saturation (there is no `/tokens` command).

| Threshold | Action | Outcome |
|---|---|---|
| **38.0%** | Manual `/compact preserve: [...]` | Stay in the Stability Plateau |
| **43.2%** | Stop new work now; compact or hand over immediately | Self-enforced cap — do not treat this as unreachable once 38% is honored; it is the checkpoint for a turn that grew fast (one large tool result, a long file read) without an intervening `/compact` |
| **80.0%** | `HANDOVER.md` + `/clear` | Fallback hard reset if 43.2% was missed or compaction didn't bring usage back down |

## Domain Rules — Native Path-Scoped Loading
Each `.claude/rules/*.md` file declares a `paths:` frontmatter block and loads automatically
when a matching file is **read**. Do not manually read a rule file "just in case" — that
defeats the point of path-scoped loading. Reference: `.agents/rules/file-topology.md`.

**Known gap:** path-scoped loading triggers on Read, not on Write of a brand-new file
(open upstream issue). Since this harness requires a prior Read before Edit, editing an
*existing* file in a domain will already have triggered its rule. Creating the **first**
file in a previously-untouched domain directory will not — proactively Read an existing
sibling file, or the rule file itself, before writing into a new domain.

| Path | Rule File |
|---|---|
| `api/**` | `api.md` |
| `.github/**`, `ci/**` | `ci.md` |
| `*.yaml`, `*.toml`, `config/**` | `config.md` |
| `db/**` | `db.md` |
| `package.json`, `*.lock` | `dependencies.md` |
| `docs/**` | `docs.md` |
| `frontend/**` | `frontend.md` |
| `infra/**` | `infra.md` |
| `logging/**` | `logging.md` |
| `migrations/**`, `db/migrations/**` | `migrations.md` |
| `monitoring/**`, `*.dashboard.json` | `monitoring.md` |
| `security/**`, `*.sarif` | `security.md` |
| `tests/**`, `*.spec.*`, `*.test.*` | `testing.md` |

Credential-file protection (`.env*`, `secrets/**`, `credentials/**`, `*.pem`, `*.key`) is
enforced deterministically by `.claude/settings.json` → `permissions.deny`, not by rule
text — rule text loads too late to stop a first read of the trigger file itself.

## Manual Failure Logging
After any tool error, permission denial, or user correction, append an entry to
`FAILURE_LEDGER.md` **without reading the whole file**: `grep -qF "<pattern>" FAILURE_LEDGER.md
|| cat >> FAILURE_LEDGER.md <<EOF` (append-only; grep dedupes). `pre-compact.sh` does the
same automatically before compaction and rotates the ledger once it exceeds `MAX_SIZE`.

**SCOPE Categories:** SV (Security Violation) | TE (Tool Error) | CO (Context Overflow) |
CV (Constraint Violation) | SD (Schema Divergence) | RE (Routing Error)

**Extraction Routing:** `.claude/settings.json` → `model_routing` records the *intent* to
route SCOPE extraction to a cheaper/faster model; no agent in this repo currently
implements per-task routing, so treat this as a design note, not an active mechanism.

## Compression Law
RESTRICTED: rule_file_compression | assert NOT token_count(rule_file) < 0.80 * baseline_token_count

The specific reduction/cost figures previously cited here (e.g. "17% reduction / 67% cost
escalation") were tagged `[VERIFIED: CWD doc]` without a reproducible source in this
repository — treat them as unverified external claims, not measured facts, until an
experiment (see `docs/framework/`) reproduces them.

**Baseline line counts (v3.3.0 — 80% floor, recount after any edit):**

| Rule File | Baseline Lines | 80% Floor (lines) |
|:-----------------|---------------:|------------------:|
| api.md            | 46             | 37                |
| ci.md             | 54             | 44                |
| config.md         | 55             | 44                |
| db.md             | 41             | 33                |
| dependencies.md   | 50             | 40                |
| docs.md           | 50             | 40                |
| frontend.md       | 44             | 36                |
| infra.md          | 47             | 38                |
| logging.md        | 52             | 42                |
| migrations.md     | 49             | 40                |
| monitoring.md     | 49             | 40                |
| security.md       | 55             | 44                |
| testing.md        | 55             | 44                |

If compression is required, re-validate all RESTRICTED invariants survive intact before committing.

## Operational Skills
- `QUICK-REF.md` → Active session cheat sheet (Read frequently)
- `HANDOVER.md` → Session state persistence (write at session boundaries, not on an op count)
- `SUBAGENT.md` → Task delegation briefing (Includes logging/context reminders)
- `FAILURE_LEDGER.md` → Record of failed approaches

> See `.claude/settings.json` for machine-enforced rules (`permissions.deny`, `hooks`).
