# File Topology — Aperture Framework v3.2.0
<!-- Injected when agent needs architectural awareness of the framework boundaries -->

## The 26-File Framework Core

### Layer 1 — Root (2 files)
| File | Purpose | Mutability |
|---|---|---|
| `CLAUDE.md` | Global law, cache contract, WISC protocol, path-scoped index | Low |
| `.claudeignore` | Hard context filter — blocks high-token paths | **Requires human approval** |

### Layer 2 — Workspace Config (1 file)
| File | Purpose | Mutability |
|---|---|---|
| `.claude/settings.json` | Tools, tiered model routing, db8 mitigations | Medium |

### Layer 3 — Automation (2 files)
| File | Purpose | Mutability |
|---|---|---|
| `.claude/hooks/hooks.json` | Central hook registry (SessionEnd, pre-compact) | Low |
| `.claude/hooks/pre-compact.sh` | Extracts git state and generates preserve directives | Low |

### Layer 4 — Templates (8 files)
| File | Purpose |
|---|---|
| `.claude/templates/HANDOVER.md` | 150-token Cognitive Compressor schema |
| `.claude/templates/SUBAGENT.md` | Bounded JSON return contract (SA-v1.0) |
| `.claude/templates/COMPACTION.md` | YAML-based decision tree |
| `.claude/templates/FAILURE_LEDGER.md` | SCOPE failure categorization schema |
| `.claude/templates/MVCS-SYNTHESIS.md` | MVCS for new feature implementation |
| `.claude/templates/MVCS-DEBUGGING.md` | MVCS for bug root-cause isolation |
| `.claude/templates/MVCS-REFACTOR.md` | MVCS for coupled module modifications |
| `.claude/templates/STATE-FREEZE.md` | Hard reset protocol |

### Layer 5 — Domain Rules (13 files)
| File | Domain | Trigger |
|---|---|---|
| `api.md` | API / Auth | `/api/**` |
| `ci.md` | CI/CD | `/.github/**` |
| `config.md` | Configuration | `/config/**` |
| `db.md` | Database | `/db/**` |
| `dependencies.md` | Dependencies | `package.json` |
| `docs.md` | Documentation | `/docs/**` |
| `frontend.md` | Frontend | `/frontend/**` |
| `infra.md` | Infrastructure | `/infra/**` |
| `logging.md` | Observability | `/logging/**` |
| `migrations.md` | Migrations | `/migrations/**` |
| `monitoring.md` | Monitoring | `/monitoring/**` |
| `security.md` | Security | `/security/**` |
| `testing.md` | Testing | `/tests/**` |

---
## Distribution
- `scripts/bootstrap-claude-framework.sh` — 6-phase idempotent installer.
- `scripts/framework/` — Byte-for-byte mirror of all 26 framework files.
