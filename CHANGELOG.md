# Changelog

All notable changes to this project are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Maintainer note:** Update the `[Unreleased]` section before every commit.
> Promote `[Unreleased]` to a version tag when cutting a release.
> Never delete old version entries. Append only.

---

## [Unreleased]

### Added
- **Manual Governance (Path A)**: Implemented structural redundancy architecture to replace automated hook injection.
- `QUICK-REF.md`: 18-line high-visibility cheat sheet for active session consultation.
- `IMPLEMENTATION_NOTES.md`: Strategic summary documenting the Path B→A pivot and architecture decisions.
- `docs/framework/`: Comprehensive validation suite including `PATH_A_VALIDATION.md`, `FRAMEWORK_WALKTHROUGH.md`, and `PROMPT_PATTERN_RETROSPECTIVE.md`.

### Changed
- `CLAUDE.md`: Injected manual domain rule index, failure logging protocol, and op-count context heuristics.
- `.claude/templates/HANDOVER.md`: Hardened with `FAILURE_LEDGER.md` pattern cross-references.
- `.claude/templates/SUBAGENT.md`: Injected rule-loading and failure-logging constraints for delegated tasks.

### Fixed
- **SDO-M-03**: Patched `config.md` to eliminate CFV in secret reference convention.
- **SDO-H-04**: Patched `migrations.md` to eliminate CFV in context engineering notes.
- **SDO-H-03 + CWO-F**: Patched `api.md` to fix security invariants and reordered for attention primacy.
- **SDO-H-02 + CWO-F**: Patched `security.md` to fix secrets hygiene invariants and reordered for attention primacy.
- **SDO-H-01 + CWO-F**: Patched `logging.md` to fix PII scrubbing invariants and reordered for attention primacy.
- **SDO-M-04**: Patched `README.md` to eliminate CFVs in rule anatomy definitions and architectural diagrams.
- **SDO-C-01/C-02 + CWO-G**: Patched `CLAUDE.md` to eliminate CFVs, update WISC protocol for corrected thresholds, and add Compression Law + SCOPE routing.
- **CWO-B + SDO-C-04**: Replaced runtime `.claude/templates/HANDOVER.md` with the 150-token Cognitive Compressor schema.
- **SDO-M-05**: Replaced framework source `HANDOVER.md` template with the 150-token Cognitive Compressor schema.
- **CWO-A/D/E + SDO-C-03**: Full replacement of runtime `.claude/settings.json` with corrected thresholds (0.80 hard reset), tiered model routing, and db8 cache mitigations.
- **SDO-H-06**: Updated framework source `settings.json` with corrected context thresholds (0.38/0.432/0.80).
- **SDO-M-06**: Patched `scripts/ads-lint.sh` to remove `NEVER` from positive anchor count and add `RESTRICTED`/`REQUIRED` directives.
- **Framework Portability**: Resolved hook system incompatibility by implementing redundant manual protocols across CLAUDE.md and templates.

---

## [3.1.0] — 2026-04-23

### Added
- **Hook System Infrastructure**: Implemented `.claude/hooks/hooks.json` registry with `SessionEnd` support.
- **Pre-compact Safety Net**: Automated state extraction before session termination/compaction via `.claude/hooks/pre-compact.sh`.
- **Zero-Defect Audit**: Formalized G-001 through G-005 compliance gates for lazy loading, hook registration, and orchestration discipline.

### Fixed
- **Framework Reconciliation**: Standardized all documentation and validation logic to exactly **25 primary files**.
- **Bootstrap Integrity**: Phase 2 and Phase 6 now explicitly validate the 25-file source-of-truth payload.
- **Settings Hygiene**: Removed deprecated `pre_compact` keys from `settings.json` in favor of the new `hooksFile` registry.

### Changed
- `CLAUDE.md`: Updated with lazy loading directives and flat orchestration model callouts.
- `README.md`: Comprehensive overhaul to reflect 25-file architecture, hook system, and v3.x templates.
- `.agents/rules/file-topology.md`: Updated to reflect the 25-file framework map.

---

## [3.0.0] — 2026-04-23

### Added

- `docs/v3-hypergraph-spec.md` — architectural blueprint for semantic hypergraph retrieval layer; formal H=(V,E,w) definition; coverage probability proof; integration API design; implementation prerequisites (sentence-transformers, networkx, Tree-sitter); 4-phase build protocol; A/B validation acceptance criteria
- `docs/v3-hopfield-spec.md` — architectural blueprint for Hopfield attractor session memory; two-layer HANDOVER.md design (prose + .hpf encoding); P_err ≤ e^(-β·ΔE) bound; implementation prerequisites; migration path from prose HANDOVER.md
- `docs/v3-pcac-spec.md` — architectural blueprint for Predictive Coding Admission Controller; ΔF_i free energy scoring for dynamic fragment admission; PCAC/glob/hybrid modes in settings.json; prerequisite: v3-hypergraph-spec.md implementation
- `docs/v3-sheaf-spec.md` — architectural blueprint for sheaf-theoretic consistency constraints; coboundary operator δ for cross-domain contradiction detection; E_glue minimization; coherence_score output; prerequisite: v3-hypergraph + PCAC
- `docs/research-threads.md` — active research thread tracking; RT-1 through RT-4; per-model attention sinks, task class saturation profiles, ledger corpus size, hypergraph benchmark
- `scripts/v3/README.md` — implementation stubs and order of operations for v3.0.0 features

---

## [2.0.0] — 2026-04-23

### Added

- `.agent/workflows/audit-framework.md` — Phase 10: Aperture Score; composite quality metric (SIS, LHS measurable; SDS, MCS scaffolded for v2.0.2); score persisted to .claude/snapshots/aperture-scores.jsonl for session trend tracking
- `scripts/compile-rules.sh` — MVCS Compiler; transforms rule files to model-optimized syntax; Claude (production), Gemini (stub pending RT-1), Universal modes
- `.claude/compiled/` — compiled rule output directory (gitignored, generated)

### Changed

- `GEMINI.md` — task-class compaction threshold table added (SYNTHESIS:40, DEBUGGING:30, REFACTOR:35); dynamic thresholds enforced at session initialization
- `.agent/workflows/add-rule.md` — Step 2.5 ADS Lint Check promoted to hard gate; score <50 blocks commit with specific structural anchor remediation guidance
- `.claude/settings.json` — compilation_model field added for MVCS Compiler targeting
- `.agent/workflows/audit-framework.md` — Phase 5 threshold comment updated for task-class-dependent thresholds
- `scripts/bootstrap-claude-framework.sh` — fixed bash increment bug where `((VAR++))` would return 1 and exit under `set -e` when VAR=0; all counters converted to `VAR=$((VAR + 1))`

---

## [1.3.0] — 2026-04-23

### Added

- `.agent/workflows/audit-framework.md` — Phase 9: Anchor Density Scoring (ADS); bash script computing attention anchor concentration per 50-token units; grounded in RoPE attention sink theory; PASS ≥70, WARN 50-69, FAIL <50
- `.claude/templates/MVCS-SYNTHESIS.md` — Minimum Viable Context template for new feature implementation; 500-800 token budget; 40% compaction threshold; topological skeleton + state-differential oracle + localized variable space
- `.claude/templates/MVCS-DEBUGGING.md` — MVCS for bug investigation; 300-600 tokens; 30% compaction threshold; PMI-maximized: error fingerprint + top-5 stack frames only
- `.claude/templates/MVCS-REFACTOR.md` — MVCS for coupled modification; 800-1500 tokens; 35% compaction threshold; interface contracts of all coupled nodes; excludes implementation logic of unedited adjacent modules
- `.claude/templates/STATE-FREEZE.md` — State Freeze Protocol; antidote to context dead weight accumulation; extract → destroy → reinitialize with minimal pristine state; distinct from /compact; returns 100% token budget
- `.agent/workflows/state-freeze.md` — /state-freeze slash command workflow

### Changed

- `.agent/rules/contribution-protocol.md` — ADS minimum threshold (≥50) added as final validation checklist item; rule files below threshold lack structural anchors for reliable attention capture
- `CLAUDE.md` — MVCS template pointers added; State Freeze reference in Compaction Protocol
- `GEMINI.md` — /state-freeze reference in Commands section
- `scripts/bootstrap-claude-framework.sh` — 4 new MVCS/STATE-FREEZE templates registered

---

## [1.2.0] — 2026-04-23

### Fixed

- `CLAUDE.md` — corrected compaction trigger from 60% to 38%; research establishes sigmoid collapse inflection point at exactly 43.2% saturation with 45.5% reasoning degradation; 38% maintains operation inside the Stability Plateau
- `.claude/templates/COMPACTION.md` — updated trigger window from 55–65% to 30–38%; added sigmoid collapse rationale and empirical grounding; >40% stop condition now references the cliff and State Freeze protocol
- `GEMINI.md` — updated compaction reference to 38% threshold; added mandatory saturation check to Commit Protocol
- `README.md` — updated threshold references and diagrams to 38% with sigmoid cliff annotations
- `docs/setup.md` — updated daily workflow compaction guidance and troubleshooting threshold check

### Changed

- `.claude/templates/FAILURE_LEDGER.md` — added Pareto Curation Protocol; [SYSTEMIC]/[TRANSIENT] entry tagging; Pareto boundary warning (~10-20 entries); supersession format for stale entries; updated examples with tags
- `.agent/rules/changelog-commit.md` — added Quarterly Ledger Curation section; 90-day review cycle; TRANSIENT pruning and SYSTEMIC supersession protocol


---

## [1.1.1] — 2026-04-22

### Fixed

- `scripts/bootstrap-claude-framework.sh` — `FAILURE_LEDGER.md` was absent from both the
  Phase 2 install targets and Phase 6 integrity check array; new environments were not
  receiving the template on bootstrap install
- `CLAUDE.md` — compressed from 148 lines to 70 lines; was over the ≤100 line hard limit
  introduced by cumulative additions from the v1.1.0 upgrade batch; all 7 Context Budget
  Law directives, 13 path-scoped rule entries, and 6 session hygiene items preserved verbatim

### Changed

- `scripts/framework/CLAUDE.md` — synced with compressed live version

---

## [1.1.0] — 2026-04-22

Applied 11 enhancements synthesized from two independent research analyses:

- *Agent Prompt Patterns* — Reflexion/MAR failure ledger, Extrinsic Self-Correction
  principle, State-and-Memory-First Design, KERNEL Protocol, RoCoIns return contracts
- *Prompt Granularity and System Scalability in LLM Architectures* — compaction priority
  ordering, domain bounce cache invalidation protocol, L3 worker size bounds, quantitative
  benchmark validation, pointer target quality gate

### Added

- `.claude/templates/FAILURE_LEDGER.md` — persistent cross-session failure record;
  project-scoped, accumulates across all sessions; append-only one-line format;
  prevents agents from re-attempting approaches that have already failed

### Changed

- `CLAUDE.md` — added Context Budget Law item 6 (extrinsic verification oracle preference),
  item 7 (tool output residue eviction), and Session Hygiene item (domain bounce prevention)
- `GEMINI.md` — added oracle verification directive (Commands section); added domain bounce
  cache invalidation directive (Dogfooding Law section)
- `.claude/templates/HANDOVER.md` — prepended JSON Machine State block for machine-readable
  session state at resume; added FAILURE_LEDGER.md cross-reference to Deprecated Paths section
- `.claude/templates/SUBAGENT.md` — added L3 worker payload target annotation
  (500–2,000 tokens); added Option E typed pseudo-function return contract for
  high-precision orchestrator parsing requirements
- `.claude/templates/COMPACTION.md` — added Compression Priority Order subsection;
  tool outputs compressed first (~80% of context bloat), then exploratory reads,
  then superseded reasoning traces; architectural decisions always preserved intact
- `.agent/rules/contribution-protocol.md` — added KERNEL audit as final validation
  checklist item: K=short, E=explicit imperative verbs, R=repeat critical rules,
  N=numbered where sequential, L=scope limited to this domain only
- `.agent/workflows/audit-framework.md` — added Phase 8: Pointer Target Validation;
  bash script verifies all `Pointer:` doc references resolve to existing files on disk;
  surfaces semantic tissue gaps in stub-only rule files

### Referenced

- README.md — added "By the Numbers" section with independent quantitative benchmarks:
  85% verification pass rate, $0.205/task cost, 185s latency for moderate modularity
  architecture vs. monolithic (45% pass, $0.805) and hyper-atomic (60% pass, $0.302)

---

## [1.0.0] — 2026-04-22

Initial release of Aperture. A path-scoped context engineering framework for AI coding
agents. 25 distributable framework files across 5 architectural layers, plus a full
Antigravity IDE governance layer.

### Added

**Layer 1 — Root (2 files)**

- `CLAUDE.md` — root context engineering directives; always-loaded startup context;
  pointer architecture with ≤100 line hard limit; global law, WISC protocol, cache contract
- `.claudeignore` — hard context filter; blocks node_modules, lockfiles, build output,
  secrets, binaries, coverage, logs, CI artifacts, and monitoring dashboards

**Layer 2 — Workspace Config (2 files)**

- `.claude/settings.json` — project-scope configuration: model selection, tool allowlist,
  permission rules (deny list for destructive operations), hook registration, extended
  thinking budget cap
- `.claude/settings.local.json` — personal override file (git-ignored; template only)

**Layer 3 — Automation (1 file)**

- `.claude/hooks/pre-compact.sh` — pre-compaction state extraction hook; fires before
  memory wipe; captures modified files (git diff), active TODOs, recent commits, staged
  changes; writes timestamped snapshot to `.claude/snapshots/`

**Layer 4 — Templates (3 files)**

- `.claude/templates/HANDOVER.md` — session state artifact; structured protocol capturing
  completed work, architectural state, decisions made, deprecated paths, active blockers,
  ordered next steps, and copy-paste resume prompt
- `.claude/templates/SUBAGENT.md` — subagent briefing template; defines scope boundary,
  tool authorization, return contract format options, and BLOCKED escalation protocol
- `.claude/templates/COMPACTION.md` — pre-compaction checklist; preserve directives by
  category, pre-assembled /compact command, post-compaction verification checklist

**Layer 5 — Domain Rules (13 files)**

- `.claude/rules/api.md` — auth middleware, rate limiting, API contracts (`/api/**`)
- `.claude/rules/ci.md` — pipeline stages, merge gates, artifact retention (`/.github/**`)
- `.claude/rules/config.md` — config architecture, secret reference convention (`*.yaml`)
- `.claude/rules/db.md` — schema constraints, migration rules, query safety (`/db/**`)
- `.claude/rules/dependencies.md` — lockfile law, CVE SLOs (`package.json`, `*.lock`)
- `.claude/rules/docs.md` — ADR protocol, documentation taxonomy (`/docs/**`)
- `.claude/rules/frontend.md` — components, state management, rendering (`/frontend/**`)
- `.claude/rules/infra.md` — IaC, secrets management, blast radius isolation (`/infra/**`)
- `.claude/rules/logging.md` — PII scrubbing invariants, structured JSON log schema
- `.claude/rules/migrations.md` — additive-only law, zero-downtime protocol (`/migrations/**`)
- `.claude/rules/monitoring.md` — SLO definitions, alert standards (`/monitoring/**`)
- `.claude/rules/security.md` — SAST, CVE response, cryptography standards (`/security/**`)
- `.claude/rules/testing.md` — runner config, coverage thresholds, fixture policy

**Bootstrap & Distribution (2 paths)**

- `scripts/bootstrap-claude-framework.sh` — idempotent 6-phase installer: environment
  validation (bash 4+, git, tools), file installation (25 files), permissions (chmod +x
  hooks), .gitignore patching (settings.local.json, snapshots/), git tracking verification
  (.claudeignore), Phase 6 integrity check (all 25 files present)
- `scripts/framework/` — versioned source mirror of all 25 distributable framework files;
  updated via `/sync-framework` workflow; source for `bootstrap --force` installs

**Public Documentation (2 files)**

- `README.md` — project documentation: problem statement (context rot, token economics),
  core principles (5 laws), architecture diagram, quick start, WISC protocol reference,
  domain rules table, anti-patterns table, prompt caching economics
- `docs/setup.md` — human onboarding guide: prerequisites, automated and manual install,
  post-install TODO completion, daily workflow, file reference, troubleshooting

**Antigravity Governance Layer (5 files)**

- `GEMINI.md` — Antigravity agent identity file; ≤400 tokens; always-loaded; absolute
  invariants (5 NEVER directives), development protocol, dogfooding law, commands
- `.agent/rules/file-topology.md` — complete 25-file framework map with mutability ratings
  per file; sync invariant definition; triggered on root/architecture file access
- `.agent/rules/contribution-protocol.md` — rule file canonical schema, validation checklist,
  bootstrap modification protocol (5-step gate), sync protocol, commit message convention
- `.agent/workflows/add-rule.md` — `/add-rule` workflow; 9-step atomic rule file creation:
  draft → validate → line count → CLAUDE.md update → mirror → README update → commit
- `.agent/workflows/sync-framework.md` — `/sync-framework` workflow; rsync + diff
  verification ensuring live .claude/ files and scripts/framework/ remain byte-identical
- `.agent/workflows/audit-framework.md` — `/audit-framework` workflow; 7-phase health check:
  line counts, schema compliance, static content verification, sync check, bootstrap dry-run,
  CLAUDE.md pointer completeness, open TODO inventory

---

[Unreleased]: https://github.com/JackSmack1971/aperture/compare/v3.0.0...HEAD

[3.0.0]: https://github.com/JackSmack1971/aperture/compare/v2.0.0...v3.0.0

[2.0.0]: https://github.com/JackSmack1971/aperture/compare/v1.3.0...v2.0.0

[1.3.0]: https://github.com/JackSmack1971/aperture/compare/v1.2.0...v1.3.0

[1.2.0]: https://github.com/JackSmack1971/aperture/compare/v1.1.1...v1.2.0

[1.1.1]: https://github.com/JackSmack1971/aperture/compare/v1.1.0...v1.1.1

[1.1.0]: https://github.com/JackSmack1971/aperture/compare/v1.0.0...v1.1.0

[1.0.0]: https://github.com/JackSmack1971/aperture/releases/tag/v1.0.0
