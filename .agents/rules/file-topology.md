# File Topology — Aperture Framework
<!-- Injected when agent reads any file in the project root or needs architectural awareness -->

## The 25-File Framework

### Layer 1 — Root (2 files)
| File | Purpose | Mutability |
|---|---|---|
| `CLAUDE.md` | Global law, cache contract, WISC protocol, path-scoped index | Low — changes need justification |
| `.claudeignore` | Hard context filter — blocks high-token/low-signal paths | **Requires human approval** |

### Layer 2 — Workspace Config (2 files)
| File | Purpose | Mutability |
|---|---|---|
| `.claude/settings.json` | Tools, model, permissions, hook registration | Medium — project-scope only |
| `.claude/settings.local.json` | Personal overrides — **git-ignored, never commit** | High — personal only |

### Layer 3 — Automation (1 file + 1 dir)
| File | Purpose | Mutability |
|---|---|---|
| `.claude/hooks/pre-compact.sh` | Extracts state before memory wipe | Low — logic is stable |
| `.claude/snapshots/` | Output dir — git-ignored, never commit contents | n/a |

### Layer 4 — Templates (3 files)
| File | Purpose | Mutability |
|---|---|---|
| `.claude/templates/HANDOVER.md` | Session handoff template | Low — schema is stable |
| `.claude/templates/SUBAGENT.md` | Subagent briefing template | Low |
| `.claude/templates/COMPACTION.md` | Pre-compaction checklist | Low |

### Layer 5 — Domain Rules (13 files)
All files in `.claude/rules/` follow the canonical schema. See `contribution-protocol.md`.

| File | Injection Trigger | Line Target |
|---|---|---|
| `api.md` | `/api/**` | ≤50 |
| `ci.md` | `/.github/**`, `/ci/**` | ≤50 |
| `config.md` | `*.yaml`, `*.toml`, `/config/**` | ≤50 |
| `db.md` | `/db/**` | ≤50 |
| `dependencies.md` | `package.json`, `*.lock` | ≤50 |
| `docs.md` | `/docs/**`, `*.md` (non-root) | ≤50 |
| `frontend.md` | `/frontend/**` | ≤50 |
| `infra.md` | `/infra/**` | ≤55 |
| `logging.md` | Logging/telemetry files | ≤55 |
| `migrations.md` | `/migrations/**` | ≤50 |
| `monitoring.md` | `/monitoring/**`, `*.dashboard.json` | ≤50 |
| `security.md` | `/security/**`, `*.sarif` | ≤55 |
| `testing.md` | `*.test.*`, `*.spec.*`, `/tests/**` | ≤55 |

### Layer 6 — Bootstrap (2 files)
| File | Purpose | Mutability |
|---|---|---|
| `scripts/bootstrap-claude-framework.sh` | Idempotent 6-phase installer | **Requires human approval** |
| `scripts/framework/` | Versioned source mirror of all 25 files | Must stay in sync with live files |

### Docs & Meta (3 files)
| File | Purpose |
|---|---|
| `README.md` | Public-facing project documentation |
| `docs/setup.md` | Human onboarding guide |
| `GEMINI.md` | This file — Antigravity agent context |

## Sync Invariant
`scripts/framework/` is a byte-for-byte copy of the live framework files.
Any edit to a live file requires a corresponding update to its mirror in `scripts/framework/`.
Run `/sync-framework` after any rule file or template change.
