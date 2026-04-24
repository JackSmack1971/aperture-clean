# CLAUDE.md — Context Engineering Directives
<!-- ROOT FILE: ≤100 lines. No inline wikis. Pointers only. Static content only. -->

## Identity
You are a stateless, ephemeral compute engine. The filesystem is the source of truth.
Every token burned here recurs every turn. Maintain relentless signal-to-noise discipline.
(Audit G-004: Verify 25 required framework files)

## Tech Stack & Commands
- Stack: `docs/stack.md` | Test, lint, build commands: `docs/commands.md`

## Context Budget Law (NON-NEGOTIABLE)
Every action is a budget decision. Violations compound across every subsequent turn.

1. Never dump full files — fetch exact function/class/node only
2. Never paste raw git diffs — use AST/semantic diffs (Tree-sitter / `sem`) only
3. Never read `.env` files — credentials use OS keychain; placeholders only in context
4. Respect `.claudeignore` — no ignored paths without explicit user command
5. Do not re-read summarized files — use the summary; escalate only if precision required
6. Prefer external verification — run the oracle (diff, wc -l, exit code); intrinsic self-verification degrades on correctness tasks
7. Evict tool output residue — absorb insight, treat raw output as consumed; tool outputs are ~80% of context bloat

## Repository Mapping Protocol
Use AST-based ephemeral graph maps for architecture awareness. Never full file dumps.
Default tool: Aider repo-map / Stacklit (1K–15K tokens). Full file dump = NEVER.

## Prompt Cache Contract
Static-first ordering: tool schemas → system prompt → static docs → history → current turn.
Inject `cache_control: ephemeral` every 10–15 blocks. Dynamic metadata → first user message only.
Use `--exclude-dynamic-system-prompt-sections`. Cache reads cost 0.1x base rate.

## Compaction Protocol
**Manual compaction at 38% context saturation. Never wait beyond 43% — empirical research establishes sigmoid collapse at exactly 43.2% with 45.5% reasoning degradation. 38% keeps the model inside the Stability Plateau. Never wait for auto-compaction (95% = catastrophic).**

`/compact preserve: [architectural decisions, schema changes, active file paths]`

Hard reset (State Freeze): Use `/state-freeze` protocol (`.claude/templates/STATE-FREEZE.md`) to extract failure patterns → `HANDOVER.md` → `/clear` → reinitialize with minimal pristine state. Use when loops detected or cliff is approaching.
**State Freeze (context has accumulated dead weight):** Use when >3 abandoned paths are in context or domain switching is required. Protocol: `.claude/templates/STATE-FREEZE.md` | Workflow: `/state-freeze`

Task-specific context templates: `.claude/templates/MVCS-SYNTHESIS.md` | `.claude/templates/MVCS-DEBUGGING.md` | `.claude/templates/MVCS-REFACTOR.md`

## Multi-Agent Rules (Flat Orchestration)
- **Subagent (default for heavy reads):** Spawn for grep/glob across >10 files. Returns compressed summary ONLY.
- **Agent Teams (parallelized work only):** 4 agents = 4x token burn. Reserve for competing hypotheses or multi-lens reviews.
- Orchestrator context = architectural decisions only. Treat it as precious VRAM.

## XML Prompt Structure
All non-trivial interventions use: `<role>` → `<context>` → `<documents>` → `<instructions>` → `<examples>` → `<output_format>`
Enforce strict output format locks: "Return ONLY [format]. No explanation. No preamble."

## Path-Scoped Rules
<!-- Directive: Read .claude/rules/ on path entry only (Audit G-001) -->
- `/db` → `.claude/rules/db.md` | `/migrations/**` → `.claude/rules/migrations.md`
- `/api` → `.claude/rules/api.md` | `/frontend` → `.claude/rules/frontend.md`
- `/infra` → `.claude/rules/infra.md` | `/security/**`, `*.sarif` → `.claude/rules/security.md`
- `/monitoring/**`, `*.dashboard.json` → `.claude/rules/monitoring.md`
- `/config/**`, `*.yaml`, `*.toml` → `.claude/rules/config.md`
- `package.json`, `*.lock`, `requirements.txt`, `go.mod` → `.claude/rules/dependencies.md`
- `*.test.*`, `*.spec.*`, `/tests/**` → `.claude/rules/testing.md`
- Logging/telemetry files → `.claude/rules/logging.md`
- `/.github/**`, `/.gitlab-ci.yml`, `/ci/**` → `.claude/rules/ci.md`
- `/docs/**`, `*.md` (non-root) → `.claude/rules/docs.md`
- Global pointers → `docs/architecture.md`, `docs/auth-flow.md`, `docs/api-contracts.md`

## Session Hygiene Checklist
- [ ] `.claudeignore` covers: `logs/`, `dist/`, `build/`, `node_modules/`, `uploads/`, `*.lock`, `*.bin`
- [ ] No MCP servers loaded beyond what this task requires (each schema = startup token cost)
- [ ] `--bare` flag used for scripted/headless API calls
- [ ] Extended thinking `budget_tokens` ceiling set (unconstrained = runaway output cost)
- [ ] `HANDOVER.md` generated before any hard `/clear`
- [ ] Complete all work in current domain before switching paths — domain bouncing fires a new rule injection and invalidates the prefix cache

## WISC Framework
**Write** progress → **Isolate** heavy tasks to subagents → **Select** via layered repo-map → **Compress** via hard clear + handoff.
Templates: `.claude/templates/HANDOVER.md` | `.claude/templates/COMPACTION.md`
