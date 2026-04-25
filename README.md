<div align="center">

```
╔═══════════════════════════════════════════╗
║          ▲  A P E R T U R E               ║
║  Control what enters the context window.  ║
╚═══════════════════════════════════════════╝
```

**A path-scoped context engineering framework for AI coding agents.**  
Inject only what the agent needs. Exactly when it needs it. Never at startup.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Framework Files](https://img.shields.io/badge/framework_files-26-blue)](#framework-architecture)
[![Domain Rules](https://img.shields.io/badge/domain_rules-13-green)](#domain-rules)
[![Bootstrap](https://img.shields.io/badge/install-one_command-brightgreen)](#quick-start)

</div>

---

## The Problem

Your AI coding agent is burning tokens before you type a single character.

A typical agentic session loads its entire startup payload — system prompt, tool schemas, project memory, MCP server definitions — silently, automatically, on every turn. On a 200K-token model, that's **45,000–50,000 tokens consumed before you've asked a question.** Nearly 25% of your working memory, gone at initialization.

Then the session runs. The agent reads files to understand your codebase. It explores directories. It executes tools and gets results. Every one of those outputs is re-transmitted and re-processed on every subsequent turn. By turn 20, that first file read has been paid for 20 times.

This is **context rot** — the compounding degradation of reasoning quality and budget as the finite context window saturates with irrelevant, stale, or redundant information. The model starts forgetting early instructions. It loses topological awareness. It hallucinates. And you've spent a significant amount of money to get there.

The standard response is to write a big `CLAUDE.md` with all your project rules. This makes it worse. Every line of that file is a permanent, recurring token tax on every single turn of every session.

---

## The Solution

Aperture treats the context window as a **precision optical instrument** — you control exactly what light enters the lens.

The framework is built on one architectural insight from the Anthropic context engineering research: **path-scoped injection**. Rules activate only when the agent enters the relevant directory or file type. They cost zero tokens at startup. A database rule file doesn't exist to the agent until the agent opens a file under `/db`. A CI rule file doesn't exist until the agent touches a pipeline config.

The result: a lean startup payload, domain-specific governance that appears exactly when needed, and an operational protocol (WISC) that prevents context rot at the architectural level rather than fighting it session-by-session.

---

## Core Principles

> **I. The context window is not a chat buffer. It is a finite, expensive compute resource.**  
> Every token is a recurring cost. Maximize signal-to-noise ratio on every turn.

> **II. Static content must precede dynamic content. Always.**  
> Prefix caching only works if the cacheable prefix never changes. A single dynamic byte invalidates every downstream cache hit.

> **III. The filesystem is the source of truth. The LLM is an ephemeral processor.**  
> Never rely on the model's in-context memory for state that must survive a session boundary. Write it to disk. Read it back fresh.

> **IV. Rules activate on path entry. They never load globally.**  
> A domain rule that loads at startup is a tax on every operation, most of which have nothing to do with that domain.

> **V. Manual compaction at 38%. RESTRICTED: auto-compaction at 95%.**  
> At 38% saturation, the model remains in the Stability Plateau. Research establishes a sigmoid collapse at exactly 43.2% saturation. Compact early, compact deliberately.

> **VI. Tiered routing maximizes the reasoning-to-cost ratio.**  
> Direct low-latency tasks (classification, log extraction) to Haiku 4.5. Use Sonnet 4.6 for implementation and Opus 4.6 for architectural validation. Routing is managed via `.claude/settings.json`.

> **VII. Compression follows the SCOPE Law of Priority.**  
> Tool output residue is evicted first (~80% of bloat), followed by exploratory reads. Architectural decisions and active blockers must be preserved across session boundaries.

---

## How It Works

```
Session Start
     │
     ▼
┌─────────────────────────────────────────────────┐
│  STARTUP PAYLOAD (static, fully cacheable)      │
│  ┌─────────────────────────────────────────┐    │
│  │  CLAUDE.md root (~100 lines max)        │    │
│  │  Tool schemas (lean — deferred loading) │    │
│  │  .claude/settings.json                  │    │
│  └─────────────────────────────────────────┘    │
│  Cost: minimal. Cache hit on turn 2+: 0.1x.     │
└─────────────────────────────────────────────────┘
     │
     ▼
Agent navigates to /api/routes/auth.ts
     │
     ▼  ← PATH ENTRY TRIGGER
┌─────────────────────────────────────────────────┐
│  .claude/rules/api.md INJECTED                  │
│  Auth middleware rules                          │
│  Rate limiting contracts                        │
│  Security invariants (RESTRICTED log PII)      │
│  Context engineering notes for this domain      │
└─────────────────────────────────────────────────┘
     │
     ▼
Agent navigates to /db/migrations/
     │
     ▼  ← PATH ENTRY TRIGGER
┌─────────────────────────────────────────────────┐
│  .claude/rules/db.md INJECTED                   │
│  Schema constraints                             │
│  Migration rules (additive-only law)            │
│  Query safety invariants                        │
│  Context notes: never dump schema.sql           │
└─────────────────────────────────────────────────┘
     │
     ▼
Context at 38%? → /compact preserve: [decisions] (cliff: 43.2%)
Context reset?  → HANDOVER.md → /clear → fresh session
```

---

## Quick Start

```bash
# Clone into your project root
git clone https://github.com/your-org/aperture .aperture-tmp
cp -r .aperture-tmp/scripts .
rm -rf .aperture-tmp

# Bootstrap the full framework (idempotent — safe to re-run)
chmod +x scripts/bootstrap-claude-framework.sh
./scripts/bootstrap-claude-framework.sh

# Preview all actions without writing anything
./scripts/bootstrap-claude-framework.sh --dry-run

# Overwrite existing files with latest framework version
./scripts/bootstrap-claude-framework.sh --force
```

That's it. The bootstrap script runs 6 phases automatically:

| Phase | Action |
|---|---|
| 1 — Validation | Bash 4+, git repo, required tools |
| 2 — Installation | All 26 framework files |
| 3 — Permissions | `chmod +x` on hook scripts |
| 4 — `.gitignore` | Adds `settings.local.json`, `snapshots/` |
| 5 — Tracking | Verifies `.claudeignore` is git-committed |
| 6 — Integrity | Confirms all 26 files present |

**After install**, complete your project-specific configuration:

```bash
# See all open TODO items across all rule files
grep -rn '\[ \] TODO' .claude/rules/ | sed 's|.claude/rules/||'
```

Full setup guide: [`docs/setup.md`](docs/setup.md)

---

## Framework Architecture

```
project-root/
│
├── CLAUDE.md                           # Root law: global constraints, cache contract,
│                                       # WISC protocol, path-scoped rule index
│                                       # Hard limit: ≤100 lines. Pointers only.
│
├── .claudeignore                       # Hard context filter. Blocks: node_modules/,
│                                       # dist/, build/, *.lock, logs/, coverage/,
│                                       # *.env, *.pem, Terraform state, raw binaries
│
├── .claude/
│   │
│   ├── settings.json                   # Project-scope: model, tools, permissions,
│   │                                   # hook registration, extended thinking budget
│   │
│   ├── settings.local.json             # Personal overrides — git-ignored, never commit
│   │
│   ├── hooks/
│   │   ├── hooks.json                  # Central hook registry (SessionEnd, pre-compact)
│   │   └── pre-compact.sh              # v1.1: fires before /compact. Extracts git
│   │                                   # state, TODOs, and generates preserve list.
│   │
│   ├── snapshots/                      # Pre-compact state dumps — git-ignored
│   │   └── pre-compact-{timestamp}.md  # Auto-generated by hook
│   │
│   ├── templates/
│   │   ├── HANDOVER.md                 # Session handoff template: objectives,
│   │   │                               # decisions, deprecated paths, next steps,
│   │   │                               # and a copy-paste resume prompt
│   │   ├── SUBAGENT.md                 # Subagent briefing: scope boundary, tool
│   │   │                               # authorization, return contract
│   │   ├── COMPACTION.md               # Pre-Compaction Decision Tree (YAML-based)
│   │   ├── FAILURE_LEDGER.md           # Tersely extracted record (SCOPE schema)
│   │   ├── MVCS-SYNTHESIS.md           # Minimum Viable Context for new features
│   │   ├── MVCS-DEBUGGING.md           # MVCS for rapid bug root-cause isolation
│   │   ├── MVCS-REFACTOR.md            # MVCS for coupled module modifications
│   │   └── STATE-FREEZE.md             # Hard reset protocol for context saturation
│   │
│   └── rules/                          # ← PATH-SCOPED INJECTION ENGINE
│       ├── api.md          # /api/**                  Auth, rate limiting, contracts
│       ├── ci.md           # /.github/**, /ci/**      Pipeline, merge gates, artifacts
│       ├── config.md       # *.yaml, *.toml, /config/ Config arch, secret references
│       ├── db.md           # /db/**                   Schema, migrations, query safety
│       ├── dependencies.md # package.json, *.lock     Lockfile law, CVE SLOs
│       ├── docs.md         # /docs/**, *.md (non-root) ADR protocol, doc taxonomy
│       ├── frontend.md     # /frontend/**             Components, state, performance
│       ├── infra.md        # /infra/**                IaC, secrets, blast radius
│       ├── logging.md      # Logging/telemetry files  PII scrubbing, JSON schema
│       ├── migrations.md   # /migrations/**           Additive-only law, zero-downtime
│       ├── monitoring.md   # /monitoring/**, *.dashboard.json  SLOs, alert standards
│       ├── security.md     # /security/**, *.sarif    SAST, CVE response, crypto
│       └── testing.md      # *.test.*, *.spec.*, /tests/** Coverage, fixtures, naming
│
├── docs/
│   └── setup.md                        # Human onboarding guide — full configuration
│                                       # reference, daily workflow, troubleshooting
│
└── scripts/
    ├── bootstrap-claude-framework.sh   # Idempotent installer: 6-phase validation,
    │                                   # file install, permissions, .gitignore patch,
    │                                   # git tracking check, integrity verification (26 files)
    └── framework/                      # Versioned source copy of all framework files.
                                        # Update framework by pulling here, then re-run
                                        # bootstrap --force.
```

---

## The WISC Protocol

WISC is the operational discipline that prevents context rot at the workflow level. Every session follows it.

```
W — WRITE     Write progress, decisions, and blockers to disk continuously.
              Never rely on in-context memory for state that must survive.

I — ISOLATE   Delegate read-heavy tasks to subagents with fresh context windows.
              The orchestrator's window stays clean. Subagents return compressed
              summaries only. Raw file contents never return to the orchestrator.

S — SELECT    Navigate the codebase via AST repo-maps and targeted file reads.
              Never dump full files. Never ingest full directories.
              Use the path-scoped rules as your selection guide.

C — COMPRESS  At 38% context saturation: /compact with explicit preserve directives (cliff: 43.2%).
              At a session boundary: generate HANDOVER.md, execute /clear,
              resume fresh with a single read instruction.
```

---

## Lazy Loading & Flat Orchestration

Aperture enforces two critical agentic disciplines to maintain context purity:

**1. Lazy Loading Discipline (Path-Scoped Injection)**
Rules do not load at startup. They load only when the agent enters a specific file path or domain. This ensures the startup payload remains lean and the agent's reasoning is only constrained by relevant governance.

**2. Flat Orchestration Model**
Heavy read/exploratory tasks are delegated to isolated subagents. The primary orchestrator maintains only the high-level architectural state and decisions. Subagents return compressed summaries, preventing the orchestrator's context from being polluted by raw file contents or verbose tool outputs.

---


**Session lifecycle:**

```
New session
    │
    ▼
[Read HANDOVER.md if resuming]
    │
    ▼
Execute scoped task
    │
    ├── Context reaches 38% ──→ /compact preserve: [decisions, file paths, blockers] (cliff: 43.2%)
    │                               │
    │                               └──→ Verify summary → continue
    │
    └── Task complete / context approaching 80%
            │
            ▼
        Generate HANDOVER.md (template: .claude/templates/HANDOVER.md)
            │
            ▼
        /clear
            │
            ▼
        Fresh session: "Read HANDOVER.md and resume from Next Steps."
```

---

## Domain Rules Reference

Each rule file follows a strict schema: injection trigger, section headers, `[ ] TODO:` placeholder items for human completion, `RESTRICTED` hard-stop security invariants, `## Context Engineering Notes` with agent-specific token-saving directives, and a `## Populated By` footer.

| Rule File | Injection Trigger | Primary Token Threat Blocked |
|---|---|---|
| `api.md` | `/api/**` | Full route registry dumps |
| `ci.md` | `/.github/**`, `/ci/**` | Full pipeline run logs |
| `config.md` | `*.yaml`, `*.toml`, `/config/**` | Wholesale config directory dumps |
| `db.md` | `/db/**` | Full `schema.sql` dumps |
| `dependencies.md` | `package.json`, `*.lock` | Lockfiles — `package-lock.json` can exceed 80K tokens alone |
| `docs.md` | `/docs/**`, `*.md` (non-root) | Full documentation tree ingestion |
| `frontend.md` | `/frontend/**` | Full component + Tailwind config dumps |
| `infra.md` | `/infra/**` | Terraform state file reads |
| `logging.md` | Logging/telemetry files | Raw log ingestion + PII exposure |
| `migrations.md` | `/migrations/**` | Full migration history reads |
| `monitoring.md` | `/monitoring/**`, `*.dashboard.json` | Grafana dashboard JSON (enormous) |
| `security.md` | `/security/**`, `*.sarif` | Full SARIF vulnerability scan results |
| `testing.md` | `*.test.*`, `*.spec.*`, `/tests/**` | Full coverage reports + test suite dumps |

**Rule file anatomy:**

```markdown
# [Domain] Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /[domain] -->
<!-- Static content only. Cache-compatible. -->

## [Section]
- Pointer: `path/to/deep-doc.md` — description
- [ ] TODO: Human-completion placeholder
- RESTRICTED: <prohibited_action> | assert NOT <prohibited_action_invoked>
  validation_key: <compliance_assertion>

## Context Engineering Notes
- Agent-specific token-saving directives for this domain

## Populated By
- Role responsible for filling TODO items
- Last reviewed: [ TODO: date ]
```

---

## Prompt Caching Architecture

Aperture is designed around a strict payload ordering contract that maximizes prefix cache hits.

```
REQUEST PAYLOAD ORDER (immutable — any deviation = full cache miss)
┌────────────────────────────────────────┐
│ 1. Tool schemas                        │  ← Most static. Never changes.
│ 2. System prompt / CLAUDE.md           │  ← Static. --exclude-dynamic-sections
│ 3. Path-scoped rule files (injected)   │  ← Semi-static. Changes on path entry.
│ 4. Pointer docs (fetched on demand)    │  ← Fetched by agent as needed.
│ 5. Conversation history               │  ← Dynamic. Always at the end.
│ 6. Current turn                        │  ← Most dynamic. Always last.
└────────────────────────────────────────┘
```

**Cache economics** (Anthropic API pricing, April 2026):

| Operation | Cost Multiplier | Notes |
|---|---|---|
| Standard input | 1.0× baseline | No caching |
| Cache write (5-min TTL) | 1.25× | Refreshed free on every hit |
| Cache write (1-hr TTL) | 2.0× | For long batch/CI workflows |
| **Cache read (hit)** | **0.1×** | **90% cost reduction** |

Break-even: achieved on the **second API call**. Every subsequent call in a session is 10× cheaper for the cached prefix. At 10+ calls per session, prompt caching alone reduces input token costs by 60–85%.

**Critical**: inject intermediate `cache_control: ephemeral` breakpoints every 10–15 tool-use blocks during dense agentic loops. The API's 20-block lookback window will miss the cache breakpoint if a single turn generates more than 20 content blocks.

---

## Operational Templates

### HANDOVER.md — Session State Artifact

Generated before every `/clear` or session boundary. Contains:
- Completed work with exact file paths
- Architectural state (schema changes, new dependencies, config changes)
- Decisions made + **deprecated paths that failed** (prevents next agent from repeating mistakes)
- Active blockers with explicit unblock requirements
- Ordered next steps with acceptance criteria
- Copy-paste resume prompt for the fresh session

Template: [`.claude/templates/HANDOVER.md`](.claude/templates/HANDOVER.md)

### SUBAGENT.md — Subagent Briefing

Used when delegating read-heavy tasks to an isolated agent. Defines:
- Single scoped objective (one task per subagent)
- Explicit scope boundary (path limit)
- Tool authorization (principle of least privilege)
- **Return contract** — Bounded JSON schema ONLY (SA-v1.0)

The return contract is strictly enforced. Subagents return structured findings and next-step recommendations via the bounded JSON schema, ensuring 100% orchestrator parsing accuracy.

Template: [`.claude/templates/SUBAGENT.md`](.claude/templates/SUBAGENT.md)

### COMPACTION.md — Pre-Compaction Decision Tree

Executed at 38% context saturation (cliff: 43.2%) before `/compact`. Uses a YAML-based decision logic to determine:
- **Decision Path**: /compact vs. /clear vs. STATE_FREEZE
- **Preserve Logic**: Automated generation of `preserve: [...]` lists from git state
- **Saturation Audit**: Verification of Stability Plateau (38%) vs. Reasoning Cliff (43.2%)

Template: [`.claude/templates/COMPACTION.md`](.claude/templates/COMPACTION.md)

### FAILURE_LEDGER.md — SCOPE Curation

A terse, machine-optimized record of systemic failures categorized by the SCOPE schema:
- **SV** (Security) | **TE** (Tool) | **CO** (Context)
- **CV** (Constraint) | **SD** (Schema) | **RE** (Routing)

Entries are appended automatically by the `pre-compact.sh` hook to prevent the agent from re-attempting failed approaches across session boundaries.

Template: [`.claude/templates/FAILURE_LEDGER.md`](.claude/templates/FAILURE_LEDGER.md)

---

## Configuration Reference

### `.claudeignore` — Hard Context Filter

Pre-populated exclusions cover the highest-token, lowest-signal paths:

- **Dependency trees**: `node_modules/`, `vendor/`, `.venv/`, `Pods/`
- **Lockfiles**: `package-lock.json`, `yarn.lock`, `poetry.lock`, `go.sum`, `*.lock`
- **Build output**: `dist/`, `build/`, `.next/`, `__pycache__/`, `*.pyc`
- **Coverage**: `coverage/`, `.nyc_output/`, `htmlcov/`
- **Logs**: `logs/`, `*.log`
- **Secrets**: `.env`, `.env.*`, `*.pem`, `*.key`, `secrets/`
- **Binaries**: `*.bin`, `*.db`, `*.sqlite`, `*.wasm`
- **Generated assets**: `*.min.js`, `*.min.css`, `*.map`
- **CI artifacts**: `*.sarif`, `security-scan-results/`, `sbom/`
- **Monitoring**: `*.dashboard.json`, `grafana-export/`

The agent can still be explicitly directed to read any ignored file. `.claudeignore` prevents autonomous ingestion, not explicit instruction.

### `.claude/settings.json` — Project-Scope Configuration

```json
{
  "schema_version": "aperture-clean-v3.2.0",
  "model_routing": {
    "haiku": { "model": "claude-haiku-4-5-...", "tasks": ["log_extraction", "classification"] },
    "sonnet": { "model": "claude-sonnet-4-6", "tasks": ["implementation", "multi_file_reads"] }
  },
  "hooks": {
    "hooksFile": ".claude/hooks/hooks.json"
  },
  "context_thresholds": {
    "compaction": 0.38,
    "cliff_halt": 0.432,
    "handover_clear": 0.80
  },
  "permissions": [
    { "tool": "Bash", "pattern": "\\bsudo\\b", "action": "deny" }
  ]
}
```

Personal overrides go in `.claude/settings.local.json` (git-ignored, never committed).

---

## ADS Integrity Audit

All Aperture rule files are audited via the **Anchor Density Score (ADS)** protocol. This ensures that rules contain sufficient structural anchors (bolding, directives, code blocks) to maintain model attention across deep context windows.

| Rating | Score | Description |
|---|---|---|
| **EXCEPTIONAL** | 9.0–10.0 | Maximum attention capture; optimized for deep context |
| **EXCELLENT** | 7.0–8.9 | High structural density; reliable directive adherence |
| **FAILING** | <5.0 | Insufficient anchors; high risk of model "skimming" |

Run the audit locally: `bash scripts/ads-lint.sh .claude/rules/`

---

## V3 Architectural Blueprints

Aperture v3.0 introduces high-level specifications for future-state context engineering. These blueprints serve as the research foundation for the transition from path-glob injection to semantic retrieval.

- [`v3-hypergraph-spec.md`](docs/v3-hypergraph-spec.md) — Semantic hypergraph retrieval layer.
- [`v3-hopfield-spec.md`](docs/v3-hopfield-spec.md) — Associative session memory (attractor states).
- [`v3-pcac-spec.md`](docs/v3-pcac-spec.md) — Predictive Coding Admission Controller (free energy scoring).
- [`v3-sheaf-spec.md`](docs/v3-sheaf-spec.md) — Consistency constraints via sheaf cohomology.

---

## Anti-Patterns This Framework Prevents

| Anti-Pattern | Why It Damages Sessions | Aperture's Counter |
|---|---|---|
| Encyclopedic `CLAUDE.md` | Every line is a permanent recurring token tax | Root file hard-limited to ≤100 lines; all detail is pointers |
| Global rule loading | Domain rules loaded even when irrelevant | Path-scoped injection — zero cost until path entry |
| Full file dumps | 1,500-line file to fix 2-line bug | Context Engineering Notes in each rule: fetch targeted node only |
| Raw `git diff` | Human-readable, machine-wasteful, scope-blind | AST/semantic diffs via Tree-sitter — up to 90% token reduction |
| Waiting for auto-compaction | Model is at 95% saturation = degraded summaries | WISC protocol: manual `/compact` at 38% (cliff: 43.2%) |
| Monolithic sessions | Context accumulates dead-end exploration paths | Session Handoff Protocol: HANDOVER.md + hard `/clear` |
| `.env` in context | Raw credentials embedded permanently | `.claudeignore` blocks all `.env*`; security rules enforce placeholders |
| Uncontrolled subagents | Orchestrator context polluted with raw reads | SUBAGENT.md return contract: compressed summary only |
| Dynamic system prompt | Cache invalidated every turn | `--exclude-dynamic-system-prompt-sections` enforced in settings |
| MCP server overloading | Each schema = startup token cost | Load only required servers; deferred on-demand loading |

---

## Why "Aperture"?

A camera aperture controls exactly how much light enters the lens. Open it too wide — overexposed, signal lost in noise. Close it too tight — dark, missing context.

Aperture keeps the context window precisely calibrated: enough light to see clearly, no more than the shot requires.

---

## Contributing

Aperture is a framework, not a library — it evolves with real-world usage patterns. Contributions welcome in three areas:

**New domain rules** — if your project has a domain not covered by the existing 13 rule files (e.g., `graphql.md`, `workers.md`, `i18n.md`), open a PR following the rule file schema documented above.

**Framework improvements** — if you identify a better compaction threshold, a missing `.claudeignore` pattern, or a more effective handoff template structure, open an issue with the empirical rationale.

**Token economics data** — if you have measured cache hit rates, token reduction percentages, or session cost comparisons using this framework vs. without, share them. The case for context engineering is best made with real numbers.

See the project documentation for contribution guidelines.

---

## License

MIT — see [LICENSE](LICENSE).

---

<div align="center">

*The LLM is a stateless, ephemeral compute engine.*  
*The filesystem is the source of truth.*  
*Treat every token as a recurring operational cost.*

**— Aperture**

</div>
