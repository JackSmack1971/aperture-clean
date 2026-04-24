# docs/setup.md — Claude Context Engineering Framework
<!-- Pointer target from CLAUDE.md. Read this on first install and after major framework updates. -->

## What This Framework Is

A zero-overhead context engineering system for Claude Code. It enforces the discipline that
the LLM's context window is a finite, expensive resource — not a chat buffer. Every file in
`.claude/` has a defined token cost profile and activation condition.

**Token economics enforced by this framework:**
- Startup context tax: minimized via `--bare`, lean `settings.json`, and deferred tool loading
- Domain context: injected only on path entry (never global)
- Dead context: pruned at 38% saturation via `/compact` (before the 43.2% sigmoid collapse cliff), not at 95% (catastrophic state)
- Session state: persisted to filesystem via `HANDOVER.md`, not the LLM's volatile memory

---

## Prerequisites

| Tool | Minimum Version | Check |
|---|---|---|
| Bash | 4.0+ | `bash --version` |
| Git | 2.x | `git --version` |
| Claude Code CLI | Latest | `claude --version` |
| Node.js (optional) | 18+ | `node --version` |

**macOS note:** Default system bash is 3.x. Install via Homebrew: `brew install bash`

---

## Installation

### Automated (recommended)

```bash
# From project root
chmod +x scripts/bootstrap-claude-framework.sh
./scripts/bootstrap-claude-framework.sh
```

**Options:**

```bash
# Preview all actions without writing anything
./scripts/bootstrap-claude-framework.sh --dry-run

# Overwrite existing framework files with latest versions
./scripts/bootstrap-claude-framework.sh --force

# Re-run silently (CI/CD usage)
./scripts/bootstrap-claude-framework.sh --quiet
```

The bootstrap script runs 6 phases:
1. Environment validation (bash version, git repo, required tools)
2. File installation (all 20 framework files)
3. Permissions (`chmod +x` on hook scripts)
4. `.gitignore` patching (adds `settings.local.json`, `snapshots/`)
5. `.claudeignore` git-tracking verification
6. Integrity check (all 25 files present)

### Manual (if automated install fails)

```bash
# Minimum viable manual install
cp -r scripts/framework/.claude .
cp scripts/framework/.claudeignore .
cp scripts/framework/CLAUDE.md .
chmod +x .claude/hooks/pre-compact.sh
echo ".claude/settings.local.json" >> .gitignore
echo ".claude/snapshots/" >> .gitignore
mkdir -p .claude/snapshots
```

---

## Post-Install Configuration (Required)

### 1. Populate Rule Files

Every `.claude/rules/*.md` file contains `[ ] TODO:` items that must be filled for your project.
Run this to see all open items:

```bash
grep -rn '\[ \] TODO' .claude/rules/ | sed 's|.claude/rules/||'
```

Priority order: `db.md` → `api.md` → `security.md` → `ci.md` → the rest.

### 2. Fill CLAUDE.md Pointer Targets

`CLAUDE.md` references these files — create them before your first Claude Code session:

```bash
touch docs/stack.md        # Tech stack: language, framework, runtime versions
touch docs/commands.md     # Test, lint, build commands
touch docs/architecture.md # High-level system architecture
touch docs/auth-flow.md    # Authentication lifecycle
touch docs/api-contracts.md # API schema and versioning contract
```

Minimal `docs/commands.md` template:
```markdown
## Commands
- Test:  `npm test` / `pytest` / `go test ./...`
- Lint:  `npm run lint` / `ruff check .` / `golangci-lint run`
- Build: `npm run build` / `python -m build` / `go build ./...`
- Typecheck: `npm run typecheck` / `mypy .`
```

### 3. Configure `.claude/settings.json`

Edit three sections for your project:

```json
{
  "model": { "default": "claude-sonnet-4-6" },
  "tools": {
    "allowed": ["bash", "read", "write", "edit", "glob", "grep"]
  },
  "extended_thinking": {
    "budget_tokens": 10000,
    "effort": "medium"
  }
}
```

**MCP servers:** Add only what this project requires. Each registered MCP schema costs
startup tokens. Remove servers not in active use.

### 4. Personal Overrides (not committed)

Create `.claude/settings.local.json` for machine-specific configuration:

```json
{
  "_note": "Personal overrides. This file is git-ignored. Never commit it.",
  "model": { "default": "claude-opus-4-6" },
  "extended_thinking": { "effort": "high" }
}
```

---

## Daily Workflow

### Starting a Session

```bash
# Standard session
claude

# Headless / scripted (skips auto-discovery, minimizes startup tokens)
claude --bare

# Verify context window after startup
# In Claude Code: /tokens
```

### During a Session

| Condition | Action |
|---|---|
| Context at ~38% | `/compact preserve: [list key decisions, active files, blockers]` (cliff: 43.2%) |
| Context at >80% | Generate `HANDOVER.md`, then `/clear` |
| Delegating heavy read task | Use `.claude/templates/SUBAGENT.md` briefing |
| Pre-compaction state save | `.claude/hooks/pre-compact.sh` (runs automatically if registered) |

### Ending a Session / Context Reset

```bash
# 1. In Claude Code: instruct the model to fill the handoff template
#    "Generate HANDOVER.md following the template at .claude/templates/HANDOVER.md"

# 2. Hard reset
/clear

# 3. Resume in fresh session
#    "Read HANDOVER.md and resume from Next Steps."
```

---

## Framework File Reference

```
project-root/
├── CLAUDE.md                          # Root context: global law, cache contract, WISC
├── .claudeignore                      # Hard context filter: all high-token noise excluded
│
├── .claude/
│   ├── settings.json                  # Project-scope: tools, model, permissions, hooks
│   ├── settings.local.json            # Personal overrides — git-ignored, never commit
│   │
│   ├── hooks/
│   │   └── pre-compact.sh             # Auto-extracts state before memory wipe
│   │
│   ├── snapshots/                     # Pre-compact snapshots output — git-ignored
│   │   └── .gitkeep
│   │
│   ├── templates/
│   │   ├── HANDOVER.md               # Session handoff: state, decisions, next steps
│   │   ├── SUBAGENT.md               # Subagent briefing: scope, tools, return contract
│   │   └── COMPACTION.md             # Pre-compaction checklist and /compact command builder
│   │
│   └── rules/                        # Path-scoped: injected ONLY on directory entry
│       ├── api.md                    # Auth middleware, rate limiting, API contracts
│       ├── ci.md                     # Pipeline stages, merge gates, artifact retention
│       ├── config.md                 # Config architecture, secret references, feature flags
│       ├── db.md                     # Schema constraints, query safety
│       ├── dependencies.md           # Package management, lockfile law, CVE SLOs
│       ├── docs.md                   # Documentation taxonomy, ADR protocol
│       ├── frontend.md               # Component conventions, state management, styling
│       ├── infra.md                  # IaC standards, secrets management, change gates
│       ├── logging.md                # Structured JSON schema, PII scrubbing invariants
│       ├── migrations.md             # Additive-only law, zero-downtime protocol
│       ├── monitoring.md             # SLO definitions, alert standards, dashboard governance
│       ├── security.md               # SAST, CVE response, cryptography standards
│       └── testing.md                # Runner config, coverage thresholds, fixture policy
│
└── scripts/
    ├── bootstrap-claude-framework.sh  # This installer
    └── framework/                     # Framework source files (copy of above structure)
```

---

## Updating the Framework

When new rule files or templates are added to `scripts/framework/`:

```bash
# Preview what would change
./scripts/bootstrap-claude-framework.sh --dry-run

# Install new files only (existing files untouched)
./scripts/bootstrap-claude-framework.sh

# Overwrite all files with latest versions
./scripts/bootstrap-claude-framework.sh --force
```

---

## Troubleshooting

**Hook not executing on compaction:**
```bash
# Verify registration in settings.json
cat .claude/settings.json | grep pre_compact

# Verify executable bit
ls -la .claude/hooks/pre-compact.sh
chmod +x .claude/hooks/pre-compact.sh
```

**Cache misses despite static CLAUDE.md:**
```bash
# Check for dynamic content in system prompt
# Verify --exclude-dynamic-system-prompt-sections is in settings.json:
grep "exclude_dynamic" .claude/settings.json
```

**Auto-compaction triggering too early (before 95%):**
```bash
# Check threshold in settings.json
grep "auto_compact_threshold" .claude/settings.json
# Should be 0.95 — if lower, raise it and rely on manual /compact at 0.38 (cliff: 43.2%)
```

**Agent reading ignored files:**
```bash
# Verify .claudeignore is git-tracked
git ls-files .claudeignore

# Verify pattern coverage
# Test a specific path:
cat .claudeignore | grep "node_modules"
```

---

## Core Principle

> The LLM is a stateless, ephemeral compute engine. The filesystem is the source of truth.
> Treat every token as a recurring operational cost. Manage context like memory, not like chat.

— Derived from: Anthropic context engineering documentation
