# Project Blueprint: aperture-clean — Critical Findings & CWD Failure Remediation
**Version:** 1.0
**Date:** 2026-04-25
**Prepared For:** AI Agent Swarm (Initial Processing by @orchestrator-project-initialization)
**Human Contact:** Project Lead — JackSmack1971/aperture-clean maintainer

---

## 1. Introduction & Vision

### 1.1. Project Overview

This blueprint defines the complete, sequenced remediation plan for **all 8 CWD (Context Window Degradation) failures** identified by the CWO Audit and **all 4 CRITICAL + 6 HIGH findings** identified by the SDO Audit against the `JackSmack1971/aperture-clean` repository (v1.0). Every fix is mapped to an exact file path, carry a verbatim replacement payload, and is ordered by dependency graph to prevent downstream conflicts. The target state is a fully CWD-compliant, SDO-compliant aperture-clean framework with zero P0/P1 operational failures.

### 1.2. Problem Statement / Opportunity

The aperture-clean v1.0 framework has **2 P0 failures** producing compounding session cost inflation estimated at 50,000+ wasted tokens per recovery cycle: a `hard_reset` threshold set 19 percentage points beyond the mandated boundary (0.95 vs 0.80), and a HANDOVER template with zero token-budget enforcement guaranteeing 60% fact destruction on every session boundary. Five additional P1–P3 CWD gaps and 10 SDO CRITICAL/HIGH violations compound these risks through omission-bias injection, KV-cache drift, unrouted model tiers, and structurally inverted attention placement across all 13 rule files.

### 1.3. Core Vision

Bring `aperture-clean` into full compliance with the CWD mathematics and SDO constraint-framing law, eliminating all P0/P1 operational failures and delivering an estimated **~2,100–3,400 token reduction per session** (recurring) with a 50,000+ token lifecycle saving via accurate state transfer.

---

## 2. Project Goals & Objectives

### 2.1. Strategic Goals

* **Goal 1:** Eliminate all P0 context-saturation failures — prevent model execution inside the 80–95% sigmoid collapse zone.
* **Goal 2:** Eliminate the 60% fact destruction rate on every session handover — enforce the 150-token HANDOVER schema.
* **Goal 3:** Eliminate all Constraint Framing Violations (CFV) — convert all `**NEVER**` negative imperatives to `RESTRICTED/assert NOT` DSL patterns across CLAUDE.md, all 13 rule files, and all templates.

### 2.2. Specific Objectives (V1 / This Release)

* **Objective 1.1:** Patch `.claude/settings.json` and `scripts/framework/.claude/settings.json` — correct all threshold keys and add the full db8 mitigation block, tiered model routing, and KV-cache epoch configuration.
* **Objective 1.2:** Replace both deployed and framework-source `HANDOVER.md` templates with the compliant 150-token Cognitive Compressor schema before the next session boundary event.
* **Objective 1.3:** Apply the 15-step ordered remediation sequence across all files end-to-end, with the `ads-lint.sh` tooling fix applied **first** so the ADS gate does not block subsequent CFV rewrites.

---

## 3. Scope

### 3.1. In Scope (All Fixes — This Blueprint)

* **PATCH SET 1 — P0 Threshold & KV-Cache:** `.claude/settings.json` (CWO-A, CWO-D, CWO-E; SDO-C-03)
* **PATCH SET 2 — P0 HANDOVER Schema:** `.claude/templates/HANDOVER.md` + `scripts/framework/.claude/templates/HANDOVER.md` (CWO-B; SDO-C-04, SDO-M-05)
* **PATCH SET 3 — CFV Elimination:** `CLAUDE.md`, all `.claude/rules/*.md` with `**NEVER**` patterns, `README.md` rule anatomy definition (SDO-C-01, SDO-C-02, SDO-H-01 through H-04, SDO-M-03, SDO-M-04)
* **PATCH SET 4 — Template & Hook Fixes:** `.claude/templates/SUBAGENT.md`, `.claude/templates/COMPACTION.md`, `.claude/hooks/pre-compact.sh` (CWO-C, CWO-H, SDO-H-05, SDO-M-01, SDO-M-02)
* **PATCH SET 5 — Governance Additions:** `CLAUDE.md` Compression Law section + SCOPE routing directive; `.claude/templates/FAILURE_LEDGER.md` SCOPE schema (CWO-G, CWO-H)
* **PATCH SET 6 — Tooling Fix:** `scripts/ads-lint.sh` NEVER anchor removal (SDO-M-06) — **must execute first**
* **PATCH SET 7 — Attention Reordering:** All 13 `.claude/rules/*.md` — move Hard Stop invariants to lines 1–15% (CWO-F)
* **PATCH SET 8 — Framework Source Settings:** `scripts/framework/.claude/settings.json` threshold correction (SDO-H-06)

### 3.2. Out of Scope (This Release)

* Refactoring of existing rule file domain content (only structural reordering and CFV conversions are in scope).
* Changes to CI/CD pipeline or external tooling beyond `ads-lint.sh`.
* Adding new domain rule files not already present in v1.0.
* Modifications to any `.env`, credentials, or secret files (blocked by security invariant by design).

---

## 4. Target Users & Audience

* **Primary User Persona 1: AI Agent (Claude Code / Swarm Orchestrator)**
  * *Needs:* Machine-enforced context thresholds, deterministic return schemas, correctly placed hard-stop invariants at primacy-zone attention depth.
  * *Pain Points:* Operating in sigmoid-collapse zone (80–95%), receiving narrative HANDOVER blobs causing 60% fact loss, ambiguous subagent return formats forcing re-query cycles.

* **Primary User Persona 2: Human Maintainer (JackSmack1971)**
  * *Needs:* A framework that does not silently override its own governance document; clear compression floors to prevent future regression.
  * *Pain Points:* CLAUDE.md documents correct thresholds (38%/43.2%/80%) but `settings.json` at runtime silently enforces 0.95, creating a split-brain between governance doc and machine config.

---

## 5. Core Features & High-Level Requirements

### 5.1. Feature: P0 Threshold + KV-Cache + Tiered Routing Patch (`settings.json`)

* **Description:** Single-file replacement of `.claude/settings.json` that corrects the `hard_reset` value, adds the missing `cliff_halt` key, inserts the complete `model_routing` block for Haiku/Sonnet/Opus tier assignment, and adds the full `cache_epoch_versioning` + `db8_mitigations` block with idempotency guards.
* **High-Level Requirements:**
  * `context_thresholds.hard_reset` MUST be `0.80`; `cliff_halt` MUST be `0.432`; `compaction` remains `0.38`.
  * `model_routing` block MUST assign Haiku 4.5 to `context_saturation_check`, `failure_ledger_extraction`, `binary_path_classification`, `scope_semantic_grouping`; Sonnet 4.6 to multi-file reads, patch generation, codebase exploration; Opus 4.6 to security invariant enforcement, architectural assessment, ODCV neutralization.
  * `cache_epoch_versioning` MUST include `key_dimensions: [prefix_hash, schema_version, cleanup_epoch, tool_state_version]` and `idempotency.session_epoch_token: true`.
* **Priority:** Must-Have (P0)

---

### 5.2. Feature: 150-Token HANDOVER Schema Replacement

* **Description:** Full template replacement of both the deployed `.claude/templates/HANDOVER.md` and the framework-source `scripts/framework/.claude/templates/HANDOVER.md` with the compliant four-partition Cognitive Compressor schema: Core State (40–60t), Context State (30–50t), Episodic State (20–30t), Metadata (5–10t), plus AI-to-AI bounded JSON payload trailer.
* **High-Level Requirements:**
  * Template MUST carry header comment: `<!-- Budget: ≤150 tokens total. RESTRICTED: prose narrative. -->`.
  * All four YAML partitions MUST be present with explicit token-ceiling comments.
  * AI-to-AI JSON block MUST be positioned as the **last** section, not an afterthought among narrative prose.
  * Framework source MUST be fixed **before** deployed template — bootstrap will overwrite deployed with source on next run.
* **Priority:** Must-Have (P0)

---

### 5.3. Feature: CFV Elimination Across All Files

* **Description:** Systematic conversion of all `**NEVER**` negative-imperative constraint patterns to `RESTRICTED: <action> | assert NOT <condition>` DSL form across `CLAUDE.md` (2 locations), `logging.md` (3× PII invariants), `security.md` (3× Secrets Hygiene), `api.md` (2× Security Invariants), `migrations.md` (1× Context Notes), `config.md` (1× Secret Reference), and `README.md` rule anatomy definition.
* **High-Level Requirements:**
  * `ads-lint.sh` MUST be patched first (remove `NEVER` from positive anchor count; add `RESTRICTED`) so SDO-compliant rewrites do not receive artificially low ADS scores.
  * CLAUDE.md line 4 MUST be rewritten to: `REQUIRED: path_scoped_injection_only | assert NOT manual_domain_skill_invocation`.
  * WISC section C-step MUST be split into two distinct threshold actions: `/compact preserve:` at 38% AND `HANDOVER + /clear` at 80%.
* **Priority:** Must-Have (P0 for CLAUDE.md; High for rule files)

---

### 5.4. Feature: Attention Reordering — Hard Stop Primacy (All 13 Rule Files)

* **Description:** Structural reorder of all 13 `.claude/rules/*.md` files to place `<!-- HARD STOPS DSL block -->` at lines 5–9 (0–15% positional depth), satisfying the U-shaped attention curve requirement `A(p) ≈ A_min + κ((2p/L)−1)²`. Currently, security invariants sit at 70–80% depth — the attention minimum.
* **High-Level Requirements:**
  * Required line order for ALL rule files: `[1] # [Domain] Rules title → [2] cache-control comment → [3] static-content note → [4] blank → [5-9] HARD STOPS DSL block → [10+] domain sections → [last-5] Context Engineering Notes → [last-2] Populated By`.
  * `api.md` Security Invariants block MUST move from lines 26–28 (70% depth) to lines 5–9.
  * `security.md` Secrets Hygiene MUST move from lines 38–44 (80% depth) to lines 5–9.
* **Priority:** Must-Have (P1 — affects all 13 files simultaneously)

---

### 5.5. Feature: SCOPE Failure Ledger + Compression Law + Pre-compact Hook

* **Description:** Three governance-layer additions: (1) Replace `.claude/templates/FAILURE_LEDGER.md` with SCOPE semantic schema (SV/TE/CO/CV/SD/RE categories + JSON entry format); (2) Add `## Compression Law` section to `CLAUDE.md` with 80% token floor table for all 13 rule files; (3) Append git state snapshot + preserve-command generation block to `.claude/hooks/pre-compact.sh`.
* **High-Level Requirements:**
  * `FAILURE_LEDGER.md` MUST include extraction routing comment: `assert extraction_model(haiku-4-5) — 4-5x faster; 94.8% SCOPE grouping`.
  * `CLAUDE.md` Compression Law MUST enumerate baseline line counts and 80% floor for all 13 rule files.
  * `pre-compact.sh` MUST output a `.claude/snapshots/pre-compact-[TIMESTAMP].md` with `git status --short`, `git log --oneline -5`, and a generated `/compact preserve: [modified files]` directive.
* **Priority:** Should-Have (P2–P3)

---

## 6. Critical Constraints & Assumptions

### 6.1. Constraints

* **Technical:**
  * The `pre_compact` hook key in `settings.json` MUST be migrated from the deprecated `"pre_compact": ".claude/hooks/pre-compact.sh"` form to `"hooksFile": ".claude/hooks/hooks.json"` per v3.1.0 CHANGELOG.
  * All rule files MUST remain at or above 80% of their v1.0 baseline token count post-reorder (enforced by the new Compression Law).
* **Operational:**
  * `scripts/ads-lint.sh` MUST be patched as **Step 1** in the execution sequence. Failure to do this will cause all subsequent CFV-rewritten rule files to fail the ADS gate (score <50 blocks the `add-rule.md` workflow).
  * `scripts/framework/.claude/templates/HANDOVER.md` MUST be fixed as **Step 4** before the deployed template (Step 5) — the bootstrap script overwrites deployed files from the framework source.
* **Legal/Compliance:**
  * No credential files (`.env`, `.pem`, `.key`) may be read or modified — the settings.json `permissions` deny block enforces this at the tool level.
* **Performance:**
  * Post-patch, every session MUST trigger compaction at 38% (`/compact preserve:`), halt at 43.2% (hard stop), and execute HANDOVER + `/clear` at 80%. No session may reach 95% saturation under the corrected thresholds.

### 6.2. Assumptions

* The repository at `JackSmack1971/aperture-clean` is the live target; all file paths in this blueprint are relative to repo root.
* The swarm executing these patches has `Read`, `Write`, `Edit`, `MultiEdit`, `Bash`, `Glob`, `Grep` tools enabled (as specified in existing `settings.json`).
* Claude Code v3.1.0+ is the runtime — `hooksFile` registry format is available (referenced in CHANGELOG per SDO audit).

---

## 7. Technology Stack

* **Mandatory:**
  * Claude Sonnet 4.6 (`claude-sonnet-4-6`) — default model for multi-file reads, patch generation, codebase exploration.
  * Claude Haiku 4.5 (`claude-haiku-4-5-20251001`) — required for binary classification, saturation detection, SCOPE extraction.
  * Claude Opus 4.6 (`claude-opus-4-6`) — required for security invariant enforcement and ODCV neutralization (ASL-3 floor).
* **Preferred:**
  * Bash (POSIX-compatible) for hook scripts.
  * JSON for all machine-config and AI-to-AI payload contracts.
  * YAML for multi-step orchestration decision trees (COMPACTION.md).
* **To Be Researched by Swarm:**
  * Optimal `hooks.json` registry format for v3.1.0 migration (verify against CHANGELOG before writing).
  * Idempotency key generation strategy for `cache_epoch_versioning.session_epoch_token`.

---

## 8. Success Metrics

* **Metric 1 (P0 Threshold):** `settings.json` `hard_reset` reads exactly `0.80` and `cliff_halt` reads exactly `0.432` — verified by `grep "hard_reset\|cliff_halt" .claude/settings.json`.
* **Metric 2 (HANDOVER Budget):** Populated HANDOVER.md template token count ≤150 — verified by running `wc -w` on a completed handover artifact.
* **Metric 3 (CFV Elimination):** Zero occurrences of `**NEVER**` pattern across `CLAUDE.md` and all `.claude/rules/*.md` — verified by `grep -r "NEVER" CLAUDE.md .claude/rules/`.
* **Metric 4 (Attention Placement):** Security invariants / HARD STOPS appear within the first 10 lines of every rule file — verified by `head -10 .claude/rules/*.md | grep -E "RESTRICTED|assert NOT|HARD STOP"`.
* **Metric 5 (Session Cost):** Estimated recurring token savings of 2,100–3,400 tokens/session achieved; zero cache-miss-on-resume events after db8 mitigation block is active.

---

## 9. Key Stakeholders

* **Project Sponsor:** JackSmack1971 (Repo Owner)
* **Product Owner:** @orchestrator-project-initialization (AI Agent Swarm Lead)
* **Lead Developer/Swarm Overseer:** CWO-Agent v1.0 + SDO-Agent v1.0 (Audit Sources)

---

## 10. Existing Resources & Documentation

* CWO Audit Report — `CWO_AUDIT_REPORT.md` (project knowledge, 663 lines — primary patch source)
* SDO Audit Report — `SDO_AUDIT_REPORT.md` (project knowledge, 502 lines — primary patch source)
* Reference Document — `CONTEXT_WINDOW_DEGRADATION_MATHEMATICS_AND_CAPABILITY_THRESHOLDS.md` (all [VERIFIED] anchors traced here)
* Live Repository — `https://github.com/JackSmack1971/aperture-clean`

---

## 11. Open Questions & Areas for Swarm Research

* **Q1:** Does `claude-code` v3.1.0 `hooksFile` registry support the `pre_compact` event trigger natively, or does the `pre-compact.sh` invocation need to be declared differently in `hooks.json`? (Verify against CHANGELOG before executing the hooks migration in Step 1.)
* **Q2:** What is the correct idempotency-key generation strategy for `cache_epoch_versioning.session_epoch_token`? Should this be a UUID per `bootstrap-claude-framework.sh` run, a git commit hash, or a timestamp? (Determine before finalizing Patch A+D+E.)
* **Q3:** The `scripts/framework/` directory is the canonical bootstrap source — are there additional files in `scripts/framework/.claude/rules/` that also carry `**NEVER**` patterns and need CFV conversion? (Run `grep -r "NEVER" scripts/framework/.claude/rules/` before declaring H-01 through H-04 complete.)
* **Q4:** The `COMPACTION.md` YAML IF-THEN fix introduces a `escalate_to_state_freeze` action (SDO M-01 fix). Is there an existing subagent or hook that handles `STATE_FREEZE` escalation, or does this need to be defined as a new template? (Resolve before committing `COMPACTION.md` patch.)
* **Q5:** After the `ads-lint.sh` fix removes `NEVER` from the anchor count, will existing rule files that have NOT yet undergone CFV conversion drop below the ADS score threshold of 50? If so, the linting gate will block those files until all CFV patches are applied — the remediation sequence must be executed atomically in a single session.

---

## 12. Sequenced Remediation Plan

> Execute in **strict dependency order**. Each step lists: `[Step]` → `[File Path]` → `[Finding IDs]` → `[Action]`

---

### STEP 1 — `scripts/ads-lint.sh` ← SDO-M-06
**Why first:** ADS scoring gate blocks all subsequent rule-file edits if `NEVER` remains a positive anchor. Fix tooling before touching any rule content.

**Exact edit — find and replace in the directive grep line:**
```bash
# BEFORE:
directives=$(grep -oE '\b(NEVER|ALWAYS|EXTRACT|VERIFY|PROHIBIT|ENFORCE|REQUIRE)\b' "$target" 2>/dev/null | wc -l)

# AFTER:
directives=$(grep -oE '\b(ALWAYS|EXTRACT|VERIFY|ENFORCE|REQUIRE|RESTRICTED|REQUIRED)\b' "$target" 2>/dev/null | wc -l)
# Note: NEVER is a CFV (omission bias trigger) — excluded from positive anchor count per SDO §CFV
```

---

### STEP 2 — `scripts/framework/.claude/settings.json` ← SDO-H-06
**Why second:** Framework source is authoritative — deployed settings overwritten on next bootstrap.

**Exact edit — replace the `context` block:**
```json
"context": {
  "compaction_preemptive": 0.38,
  "degradation_cliff_hard_stop": 0.432,
  "hard_reset": 0.80,
  "auto_compact_failsafe": 0.95
}
```
*(Remove deprecated `"auto_compact_threshold": 0.95` and `"preferred_compact_threshold": 0.60` keys.)*

---

### STEP 3 — `.claude/settings.json` ← CWO-A + CWO-D + CWO-E + SDO-C-03
**Why third:** This is the runtime machine-config — operational truth. Three compound failures resolved in one atomic replacement.

**Full replacement content:**
```json
{
  "schema_version": "aperture-clean-v1.0",
  "model": "claude-sonnet-4-6",
  "model_routing": {
    "haiku": {
      "model": "claude-haiku-4-5-20251001",
      "tasks": [
        "context_saturation_check",
        "failure_ledger_extraction",
        "binary_path_classification",
        "scope_semantic_grouping"
      ],
      "rationale": "4-5x faster than Sonnet; mandated for binary classification + SCOPE extraction [VERIFIED: CWD doc]"
    },
    "sonnet": {
      "model": "claude-sonnet-4-6",
      "tasks": [
        "domain_rule_file_reads",
        "multi_file_schema_extraction",
        "patch_generation",
        "context_management",
        "codebase_exploration"
      ],
      "rationale": "70% higher token efficiency on codebase exploration [VERIFIED: CWD doc]"
    },
    "opus": {
      "model": "claude-opus-4-6",
      "tasks": [
        "security_invariant_enforcement",
        "architectural_gap_assessment",
        "odcv_neutralization"
      ],
      "rationale": "ASL-3 floor required for ODCV neutralization; architectural reasoning only [VERIFIED: CWD doc]"
    }
  },
  "permissions": [
    {
      "tool": "Read",
      "pattern": ".*\\.(env|pem|key)$|.*credentials\\..*",
      "action": "deny",
      "message": "Security policy: Credential files are immutable (CLAUDE.md Security Invariants)"
    },
    {
      "tool": "Write",
      "pattern": ".*\\.(env|pem|key)$|.*credentials\\..*",
      "action": "deny",
      "message": "Security policy: Credential files are immutable (CLAUDE.md Security Invariants)"
    },
    {
      "tool": "Edit",
      "pattern": ".*\\.(env|pem|key)$|.*credentials\\..*",
      "action": "deny",
      "message": "Security policy: Credential files are immutable (CLAUDE.md Security Invariants)"
    },
    {
      "tool": "MultiEdit",
      "pattern": ".*\\.(env|pem|key)$|.*credentials\\..*",
      "action": "deny",
      "message": "Security policy: Credential files are immutable (CLAUDE.md Security Invariants)"
    },
    {
      "tool": "Bash",
      "pattern": "\\bsudo\\b|\\brm\\s+-r[fF]\\s+/",
      "action": "deny",
      "message": "Security policy: Destructive system commands blocked (CLAUDE.md Security Invariants)"
    }
  ],
  "tools": {
    "enabled": ["Read", "Write", "Edit", "MultiEdit", "Bash", "Glob", "Grep"]
  },
  "hooks": {
    "hooksFile": ".claude/hooks/hooks.json"
  },
  "context_thresholds": {
    "compaction": 0.38,
    "cliff_halt": 0.432,
    "handover_clear": 0.80,
    "auto_compact_failsafe": 0.95
  },
  "system_prompt": {
    "exclude_dynamic_sections": true,
    "version_tag": "APERTURE-CLEAN v1.0"
  },
  "db8_mitigations": {
    "idempotent_cleanup": {
      "guard": "session_resume_epoch_token",
      "key": "idempotency_key",
      "transitions": "monotonic",
      "assertion": "block_repeated_retention_shrinkage"
    },
    "canonical_prompts": {
      "enforce_deterministic_json_ordering": true,
      "enforce_fixed_role_sequencing": true,
      "enforce_normalized_unicode_whitespace": true,
      "enforce_explicit_system_prompt_versioning": true
    },
    "cache_epoch_key_tuple": [
      "prefix_hash",
      "schema_version",
      "cleanup_epoch",
      "tool_state_version"
    ],
    "payload_isolation": {
      "defer_loading": true
    }
  },
  "cache_epoch_versioning": {
    "enabled": true,
    "key_dimensions": [
      "prefix_hash",
      "schema_version",
      "cleanup_epoch",
      "tool_state_version"
    ],
    "idempotency": {
      "session_epoch_token": true,
      "monotonic_state_transitions": true
    },
    "rationale": "Prevents 100% cache miss on resume via db8 protocol [VERIFIED: CWD doc]"
  }
}
```

---

### STEP 4 — `scripts/framework/.claude/templates/HANDOVER.md` ← SDO-M-05
**Why fourth:** Framework source MUST be fixed before the deployed template or bootstrap overwrites the fix.

**Full replacement content:**
```markdown
<!-- APERTURE-CLEAN HANDOVER v1.0 | 150-token budget ENFORCED | RESTRICTED: prose narrative -->
<!-- SCHEMA: Core(40-60t) + Context(30-50t) + Episodic(20-30t) + Meta(5-10t) = ≤150 tokens total -->

## Core State [target: 40–60 tokens]
```yaml
intention: ""          # Active goal — 1 imperative sentence
active_blockers: []    # Unresolved impediments — terse noun phrases only
decisions_made: []     # Settled choices — verb + rationale ≤10 words each
```

## Context State [target: 30–50 tokens]
```yaml
modified_files: []     # Exact paths only
git_state: ""          # git rev-parse --short HEAD
key_deps: []           # Architectural dependencies added this session
```

## Episodic State [target: 20–30 tokens]
```yaml
next_steps:            # Ordered — copy-paste executable imperative verbs
  - ""
  - ""
```

## Metadata [target: 5–10 tokens]
```yaml
timestamp: ""          # ISO 8601 UTC
schema_version: "aperture-clean-v1.0"
context_pct: ""
```

---
<!-- AI-TO-AI PAYLOAD — bounded JSON — required for subagent resume -->
```json
{
  "goal": "",
  "blockers": [],
  "decisions": [],
  "modified_files": [],
  "git_branch": "",
  "git_hash": "",
  "next_steps": [],
  "schema_version": "HO-v1.0",
  "timestamp": "",
  "context_saturation_pct": 0
}
```
```

---

### STEP 5 — `.claude/templates/HANDOVER.md` ← CWO-B + SDO-C-04
**Why fifth:** Deployed operational template. Identical content to Step 4 (see above). Apply same full replacement.

> ⚠️ **Critical:** The existing template's `## Deprecated Paths` section must be **removed entirely** — this data belongs in `FAILURE_LEDGER.md`, not in the HANDOVER budget.

---

### STEP 6 — `CLAUDE.md` ← SDO-C-01 + SDO-C-02 + CWO-G (Compression Law addition)

**Fix C-01 — Line 4 verbatim replacement:**
```diff
- ⚠️ **CRITICAL: NEVER** invoke Domain Skills manually. Use path-scoped injection ONLY.
+ REQUIRED: path_scoped_injection_only | assert NOT manual_domain_skill_invocation
```

**Fix C-02 — Replace entire WISC Operational Protocol section:**
```markdown
## WISC Operational Protocol
- **W**rite: persist progress/decisions to disk every 3–5 turns.
- **I**solate: delegate heavy reads to subagents via `.claude/templates/SUBAGENT.md`.
- **S**elect: read targeted line ranges only; RESTRICTED: full-directory ingestion.
- **C**ompress: `/compact preserve:` at 38% | HANDOVER + `/clear` at 80%.
```

**Fix CWO-G — Append after `## Context & Attention Discipline` section:**
```markdown
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
```

**Add to `CLAUDE.md` under `## Manual Failure Logging`:**
```markdown
**Extraction Routing:** Route all SCOPE failure extraction calls to `claude-haiku-4-5-20251001`.
Haiku executes semantic grouping 4–5× faster than Sonnet with 94.8% SCOPE category accuracy [VERIFIED: CWD doc].

**SCOPE Categories:** SV (Security Violation) | TE (Tool Error) | CO (Context Overflow) |
CV (Constraint Violation) | SD (Schema Divergence) | RE (Routing Error)
```

---

### STEP 7 — `README.md` ← SDO-M-04
**Why here:** Fixes the root canonical definition that generated H-01 through H-04 and M-03. Must precede rule file edits.

**Exact edit — replace the rule file anatomy `**NEVER**` line:**
```diff
- - **NEVER** Hard-stop security invariant
+ - RESTRICTED: <prohibited_action> | assert NOT <prohibited_action_invoked>
+   validation_key: <compliance_assertion>
```

---

### STEP 8 — `.claude/rules/logging.md` ← SDO-H-01 (Highest blast-radius CFV — PII credentials)

**Replace entire `## PII Scrubbing Invariants` section:**
```markdown
## PII Scrubbing Invariants
<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: log_pii | assert NOT log_field IN [passwords, tokens, api_keys, session_ids, raw_auth_headers]
RESTRICTED: log_financial_id | assert NOT log_field IN [credit_card_full, ssn, government_id]
RESTRICTED: log_auth_body | assert NOT log_source == auth_endpoint_raw_body
validation_key: pii_absent
<!-- ══════════════════════════════════════════════════════════ -->
```

**Apply CWO-F attention reorder** — move the above HARD STOPS block to lines 5–9 of the file (immediately after cache-control comment and blank line). All domain sections follow line 10+.

---

### STEP 9 — `.claude/rules/security.md` ← SDO-H-02 (Second-highest blast-radius CFV)

**Replace entire `## Secrets Hygiene (Hard Stops)` section:**
```markdown
## Secrets Hygiene
<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: env_file_read | assert NOT read_path MATCHES [".env*", "secrets/**", "credentials/**"]
RESTRICTED: credential_output | assert NOT output_contains_credential
  validation_key: placeholder_only | expected_format: "{{SECRET_NAME}}"
RESTRICTED: secret_commit | assert NOT git_stage_contains_credential
  required: pre_commit_hook_active == true
<!-- ══════════════════════════════════════════════════════════ -->
```

**Apply CWO-F attention reorder** — move block to lines 5–9 (currently at 80% positional depth — lines 38–44 of 49).

---

### STEP 10 — `.claude/rules/api.md` ← SDO-H-03 + CWO-F (Pattern Representative)

**Replace entire `## Security Invariants` section AND reorder to primacy position:**
```markdown
# API Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /api/** -->
<!-- Static content only. No secrets, no tokens, no env values. Cache-compatible. -->

<!-- ═══════════════ HARD STOPS — READ FIRST ═══════════════ -->
<!-- assert NOT read(env_files) — credentials via OS keychain / secret manager ONLY -->
RESTRICTED: env_file_read | assert NOT read_path MATCHES ".env*"
  REQUIRED: credential_source IN [os_keychain, secret_manager, placeholder_convention]
RESTRICTED: auth_body_log | assert NOT log_contains(request_body) WHERE path MATCHES auth_endpoints
  validation_key: pii_absent_from_logs
<!-- assert NOT reorder(middleware_chain) — CLAUDE.md Security Invariants §API -->
<!-- ═══════════════════════════════════════════════════════ -->

## Auth Middleware
[... remainder of domain content unchanged ...]
```

---

### STEP 11 — `.claude/rules/migrations.md` ← SDO-H-04

**Replace the offending line in `## Context Engineering Notes`:**
```diff
- - **NEVER** read the full migration history directory — can contain hundreds of files / 100K+ tokens
+ - RESTRICTED: full_migration_dir_read | REQUIRED: read named migration file by timestamp only
```

---

### STEP 12 — `.claude/rules/config.md` ← SDO-M-03

**Replace the offending line in the `Secret Reference Convention` section:**
```diff
- - **NEVER** read config files that contain resolved secret values into context
+ - RESTRICTED: resolved_secret_in_context | assert NOT context_contains_resolved_secret_value
+   validation_key: placeholder_pattern_only | expected: "{{SECRET_NAME}}"
```

---

### STEP 13 — `.claude/templates/COMPACTION.md` ← SDO-M-01

**Full replacement content:**
```yaml
# COMPACTION.md — Pre-Compaction Decision Tree
compaction_protocol:
  trigger_check:
    IF saturation < 0.38:
      action: CONTINUE
    IF saturation >= 0.38 AND saturation < 0.432:
      action: EXECUTE_COMPACT
      steps:
        - run: .claude/hooks/pre-compact.sh
        - copy_output: /compact preserve: [paste generated list]
        - verify: context_pct < 0.20 post-compact
    IF saturation >= 0.432 AND saturation < 0.80:
      action: CRITICAL_COMPACT
      steps:
        - HARD STOP — reasoning cliff entered
        - run: .claude/hooks/pre-compact.sh
        - execute: /compact preserve: [all active files + decisions]
        - IF compact_result > 0.50: escalate_to_state_freeze
    IF saturation >= 0.80:
      action: STATE_FREEZE
      steps:
        - write: HANDOVER.md (150-token schema only)
        - execute: /clear
        - resume: "Read HANDOVER.md. Task: {next_step}."

  post_compact_validation:
    assert: context_pct < 0.20
    assert: preserved_items_accessible == true
    assert: no_critical_decisions_lost == true
```

---

### STEP 14 — `.claude/templates/SUBAGENT.md` ← CWO-C + SDO-M-02

**Full replacement content:**
```markdown
<!-- APERTURE-CLEAN SUBAGENT CONTRACT v1.0 | Return payload: bounded JSON ONLY -->

## Scope
[single, focused objective — one sentence]

## Authorized Tools
[explicit tool whitelist — names only, comma-separated]

## Return Contract
<!-- assert NOT return_format(Markdown) -->
<!-- assert NOT return_format(Summary) -->
<!-- assert return_format(bounded_JSON) — 50% speed gain [VERIFIED: CWD doc] -->

**Format:** Bounded JSON schema ONLY.
**Token Limit:** ≤500 tokens total payload.

```json
{
  "schema": "subagent_return_v1",
  "max_tokens": 500,
  "required_fields": {
    "findings": "array | each item: {file: string, issue: string, severity: high|medium|low}",
    "recommendation": "string | max 2 sentences | actionable",
    "blocked": "boolean | true if scope boundary hit before completion"
  },
  "status": "SUCCESS | PARTIAL | FAILED",
  "modified_files": [],
  "errors": [],
  "next_required_action": "",
  "token_count_estimate": 0,
  "schema_version": "SA-v1.0"
}
```

RESTRICTED: return_format NOT matching schema above

## Constraints
<!-- assert NOT read(env_files) -->
<!-- assert NOT write(FAILURE_LEDGER) WITHOUT confirmed_tool_error -->
**Rule Check:** Read domain rule in `.claude/rules/[domain].md` BEFORE any file edit.
**Failure Logging:** On any non-zero exit or permission denial, append to `FAILURE_LEDGER.md`.
**Boundaries:** [prohibited actions — specific to delegation scope]

## Execution Model Routing
<!-- Route to Haiku 4.5 for: binary classification, saturation check, log extraction -->
<!-- Route to Sonnet 4.6 for: multi-file reads, schema extraction, patch generation -->
<!-- Route to Opus 4.6 for: security invariant review, architectural decisions -->
```

---

### STEP 15 — `.claude/hooks/pre-compact.sh` ← SDO-H-05 (Last — depends on corrected snapshot path from Step 3)

**Append to the end of existing script (after existing failure extraction block):**
```bash
# ─────────────────────────────────────────────────────────────────────────────
# SECTION A: GIT STATE SNAPSHOT
# Tiered routing: binary classification → Haiku 4.5 (SDO §TIERED ROUTING)
# ─────────────────────────────────────────────────────────────────────────────
SNAPSHOT_DIR=".claude/snapshots"
TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
SNAPSHOT_FILE="${SNAPSHOT_DIR}/pre-compact-${TIMESTAMP}.md"
mkdir -p "${SNAPSHOT_DIR}"

echo "## Modified Files" >> "${SNAPSHOT_FILE}"
git status --short 2>/dev/null >> "${SNAPSHOT_FILE}" || echo "(git unavailable)" >> "${SNAPSHOT_FILE}"

echo "## Recent Commits" >> "${SNAPSHOT_FILE}"
git log --oneline -5 2>/dev/null >> "${SNAPSHOT_FILE}" || echo "(git unavailable)" >> "${SNAPSHOT_FILE}"

echo "## Current Branch" >> "${SNAPSHOT_FILE}"
git branch --show-current 2>/dev/null >> "${SNAPSHOT_FILE}" || echo "(unavailable)" >> "${SNAPSHOT_FILE}"

# ─────────────────────────────────────────────────────────────────────────────
# SECTION B: PRESERVE COMMAND GENERATION
# Outputs /compact preserve: directive for agent to copy-paste
# ─────────────────────────────────────────────────────────────────────────────
MODIFIED_FILES=$(git status --short 2>/dev/null | awk '{print $2}' | head -10 | tr '\n' ', ' | sed 's/,$//')

echo ""
echo "### APERTURE PRE-COMPACT DIRECTIVE"
echo "/compact preserve: ${MODIFIED_FILES:-(no modified files detected)}"
echo "✓ Snapshot saved → ${SNAPSHOT_FILE}"
echo "  Tiered routing: saturation classification → REQUIRED: claude-haiku-4-5-20251001 (94.8% grouping accuracy)"
```

**Also remove the non-deterministic `mktemp` usage** from the existing failure extraction block and replace with a deterministic epoch-stamped path:
```bash
# BEFORE:
TEMP_FAILURES=$(mktemp)

# AFTER:
TEMP_FAILURES="${SNAPSHOT_DIR}/failures-${TIMESTAMP}.tmp"
```

---

### STEP 16 — `.claude/templates/FAILURE_LEDGER.md` ← CWO-H (SCOPE Schema)

**Full replacement content:**
```markdown
<!-- APERTURE-CLEAN FAILURE_LEDGER v1.0 | SCOPE semantic schema | Haiku 4.5 extraction -->
<!-- assert extraction_model(haiku-4-5) — 4-5x faster; 94.8% SCOPE grouping [VERIFIED: CWD doc] -->

# Persistent Failure Ledger — SCOPE Schema

**Extraction Model:** claude-haiku-4-5-20251001 (binary classification + semantic grouping)
**Schema Version:** FL-v1.0

---

## SCOPE CATEGORY INDEX

| Category           | Code | Description                                        |
|:-------------------|:-----|:---------------------------------------------------|
| Security Violation | SV   | RESTRICTED invariant breach, credential exposure   |
| Tool Error         | TE   | Non-zero exit, file not found, permission denial   |
| Context Overflow   | CO   | Threshold exceeded, compaction failure             |
| Constraint Violation | CV | Settings.json block, rule file violation           |
| Schema Divergence  | SD   | Template mismatch, format contract failure         |
| Routing Error      | RE   | Wrong model tier, subagent delegation failure      |

---

## Entry Schema

```json
{
  "id": "FL-[YYYYMMDD]-[NNN]",
  "scope_category": "SV | TE | CO | CV | SD | RE",
  "timestamp": "[ISO-8601]",
  "pattern": "[≤100 chars — exact error signature]",
  "context": "[file path or operation]",
  "severity": "CRITICAL | MAJOR | MINOR",
  "recurrence": 0,
  "resolved": false,
  "resolution": ""
}
```

## Entries
<!-- Append JSON objects below. One object per entry. Haiku extraction writes here. -->
<!-- Deduplication: check pattern field before append — reject exact duplicates -->
```

---

### STEP 17 — Remaining 9 Rule Files ← CWO-F (Attention Reorder — Apply Pattern from Step 10)

Apply the structural reorder to all remaining rule files that have not yet been touched:
`ci.md`, `config.md`, `db.md`, `dependencies.md`, `docs.md`, `frontend.md`, `infra.md`, `monitoring.md`, `testing.md`.

**Reorder template for ALL remaining rule files:**
```
[Line 1]    # [Domain] Rules — Path-Scoped Context
[Line 2]    <!-- APERTURE-CLEAN v1.0 | cache-control metadata -->
[Line 3]    <!-- Static content only. Cache-compatible. Target: ≤50 lines. -->
[Line 4]    (blank)
[Lines 5-9] <!-- HARD STOPS DSL block (RESTRICTED / assert NOT) -->
[Lines 10+] ## Domain sections (pointers, constraints, TODOs)
[Last 5]    ## Context Engineering Notes
[Last 2]    ## Populated By
```

---

## 13. Aggregate Token Economics

| File | Current Tokens (est) | Post-Fix Tokens (est) | Delta | Notes |
|:-----|---------------------:|----------------------:|------:|:------|
| `CLAUDE.md` | ~320 | ~315 | −5 | CFV word-swaps + Compression Law addition |
| `.claude/templates/HANDOVER.md` | ~220 blank / ~650 filled | ≤150 | −70 to −500/session | **CRITICAL: recurring cost per session boundary** |
| `scripts/framework/.claude/templates/HANDOVER.md` | ~380 blank / ~800 filled | ≤150 | −230 to −650 | Prevents regression on next bootstrap |
| `.claude/settings.json` | ~95 | ~185 | +90 | db8 mitigations prevent 100% cache miss |
| `scripts/framework/.claude/settings.json` | ~210 | ~210 | ~0 | Threshold value change only |
| `.claude/rules/logging.md` | ~280 | ~285 | +5 | DSL syntax slightly longer, compliance gain |
| `.claude/rules/security.md` | ~270 | ~275 | +5 | DSL conversion |
| `.claude/rules/api.md` | ~230 | ~235 | +5 | DSL conversion |
| `.claude/rules/migrations.md` | ~270 | ~272 | +2 | Single CFV swap |
| `.claude/rules/config.md` | ~255 | ~257 | +2 | Single CFV swap |
| `.claude/templates/COMPACTION.md` | ~50 | ~55 | +5 | YAML overhead justified |
| `.claude/templates/SUBAGENT.md` | ~85 | ~95 | +10 | JSON schema overhead |
| `scripts/ads-lint.sh` | — | — | 0 | Behavioral fix, no token impact |
| `.claude/hooks/pre-compact.sh` | — | — | 0 direct | Prevents ~20K–60K lossy compaction waste/session |
| `README.md` | — | — | +5 | Schema definition line |
| `.claude/templates/FAILURE_LEDGER.md` | ~60 | ~120 | +60 | SCOPE schema adds structure |
| **Session-level recurring savings** | — | — | **~2,100–3,400 tokens/session** | Dominated by HANDOVER fix + cache hit recovery |
| **Lifecycle savings (20-session project)** | — | — | **~50,000+ tokens** | Via accurate state transfer eliminating re-reads |

---

## 14. Finding–Patch Cross-Reference

| Finding ID | Source | Severity | Step(s) | File(s) |
|:-----------|:-------|:---------|:--------|:--------|
| CWD-1 / A  | CWO    | P0       | 3       | `.claude/settings.json` |
| CWD-2 / B  | CWO    | P0       | 4, 5    | Both HANDOVER.md files |
| CWD-3 / C  | CWO    | P1       | 14      | `.claude/templates/SUBAGENT.md` |
| CWD-4 / D  | CWO    | P1       | 3       | `.claude/settings.json` |
| CWD-5 / E  | CWO    | P1       | 3, 15   | `settings.json` + `pre-compact.sh` |
| CWD-6 / F  | CWO    | P2       | 8–12, 17| All `.claude/rules/*.md` |
| CWD-7 / G  | CWO    | P3       | 6       | `CLAUDE.md` |
| CWD-8 / H  | CWO    | P3       | 16      | `.claude/templates/FAILURE_LEDGER.md` |
| C-01       | SDO    | CRITICAL | 6       | `CLAUDE.md` line 4 |
| C-02       | SDO    | CRITICAL | 6       | `CLAUDE.md` WISC section |
| C-03       | SDO    | CRITICAL | 3       | `.claude/settings.json` |
| C-04       | SDO    | CRITICAL | 5       | `.claude/templates/HANDOVER.md` |
| H-01       | SDO    | HIGH     | 8       | `.claude/rules/logging.md` |
| H-02       | SDO    | HIGH     | 9       | `.claude/rules/security.md` |
| H-03       | SDO    | HIGH     | 10      | `.claude/rules/api.md` |
| H-04       | SDO    | HIGH     | 11      | `.claude/rules/migrations.md` |
| H-05       | SDO    | HIGH     | 15      | `.claude/hooks/pre-compact.sh` |
| H-06       | SDO    | HIGH     | 2       | `scripts/framework/.claude/settings.json` |
| M-01       | SDO    | MEDIUM   | 13      | `.claude/templates/COMPACTION.md` |
| M-02       | SDO    | MEDIUM   | 14      | `.claude/templates/SUBAGENT.md` |
| M-03       | SDO    | MEDIUM   | 12      | `.claude/rules/config.md` |
| M-04       | SDO    | MEDIUM   | 7       | `README.md` |
| M-05       | SDO    | MEDIUM   | 4       | `scripts/framework/.claude/templates/HANDOVER.md` |
| M-06       | SDO    | MEDIUM   | 1       | `scripts/ads-lint.sh` |

---

*The LLM is a stateless, ephemeral compute engine. The filesystem is the source of truth. Every token is a recurring operational cost.*
**— Blueprint synthesized from CWO-Agent v1.0 + SDO-Agent v1.0 audit outputs**
