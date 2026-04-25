# Codebase Map — Aperture Framework

## Project Overview
**Aperture** is a path-scoped context engineering framework designed to minimize token consumption and prevent context rot in AI coding agent sessions. It treats the context window as a finite resource, injecting governance rules only when the agent enters a relevant directory or file type.

### Core Goals
- **Minimize Startup Payload**: Keep the initial token count low by deferring rule loading.
- **Path-Scoped Injection**: Automatically activate domain-specific rules based on the agent's current path.
- **Context Hygiene**: Enforce manual compaction at 38% saturation (Stability Plateau) to avoid the 43.2% reasoning cliff.
- **WISC Protocol**: Standardize agent operations (Write, Isolate, Select, Compress).

---

## Directory & Module Breakdown

| Directory | Purpose |
|---|---|
| `.agents/` | Internal agent governance: workflows (`add-rule.md`, `sync-framework.md`) and meta-rules (`file-topology.md`). |
| `.claude/` | **Live Framework**: The active configuration, hooks, rules, and templates used by the agent. |
| `.claude/rules/` | **Domain Rules**: 13 files (api, db, ci, etc.) injected based on file paths. |
| `.claude/templates/` | **Operational Templates**: Handover, Subagent briefing, Compaction checklist. |
| `docs/` | Documentation: setup guide, research threads, and v3 experimental specs. |
| `scripts/` | Tooling: `bootstrap-claude-framework.sh` (installer) and `compile-rules.sh` (experimental compiler). |
| `scripts/framework/` | **Source of Truth**: A mirror of the `.claude/` directory used for distribution and updates. |

---

## Key Files (Single Source of Truth)

### [CLAUDE.md](file:///c:/workspaces/aperture-clean/CLAUDE.md)
**Role**: The "Root Law". 
- Defines global constraints, the WISC protocol, and the path-scoped rule index.
- **Invariants**: Must not exceed 100 lines. Static content only.
- [L32-L38](file:///c:/workspaces/aperture-clean/CLAUDE.md#L32-L38): Compaction and State Freeze protocols.
- [L51-L64](file:///c:/workspaces/aperture-clean/CLAUDE.md#L51-L64): Path-scoped injection mapping.

### [GEMINI.md](file:///c:/workspaces/aperture-clean/GEMINI.md)
**Role**: Antigravity agent context.
- Contains absolute invariants and dogfooding laws for the agent currently managing the repo.
- [L9-L21](file:///c:/workspaces/aperture-clean/GEMINI.md#L9-L21): Hard stops for framework integrity.
- [L63-L71](file:///c:/workspaces/aperture-clean/GEMINI.md#L63-L71): Mandatory commit protocols.

### [bootstrap-claude-framework.sh](file:///c:/workspaces/aperture-clean/scripts/bootstrap-claude-framework.sh)
**Role**: Idempotent installer.
- Handles the 6-phase installation and validation of the framework.
- Any modifications require human approval and rigorous dry-run testing.

---

## Patterns & Conventions

### 1. The 38% Rule
Manual compaction must be triggered when context saturation reaches **38%**. Empirical research (referenced in `CLAUDE.md`) identifies a reasoning "cliff" at **43.2%**. Staying in the Stability Plateau (below 38%) preserves model intelligence.

### 2. Path-Scoped Injection
Domain-specific rules (e.g., `db.md`) are NOT loaded at startup. They are "injected" only when the agent interacts with files in the corresponding path (e.g., `/db/**`).

### 3. Mirror Invariant
The files in `scripts/framework/` MUST be byte-for-byte identical to the active files in `.claude/`. Any change to a live rule must be synced to the framework source using the `/sync-framework` workflow.

---

## Important Areas & "Don't Break This"

> [!IMPORTANT]
> **Framework Integrity**: 
> - Never let `CLAUDE.md` exceed 100 lines.
> - Never modify `scripts/bootstrap-claude-framework.sh` without a dry-run and human approval.
> - Always update `CHANGELOG.md` before committing.

> [!WARNING]
> **Context Saturation**:
> - Avoid `ls -R` or `grep` across the whole repo in a single turn. 
> - Use subagents for heavy reads to prevent orchestrator context bloat.

---

## Zombie / Deprecated Code
- **`.claude/compiled/`**: Ignored via `.gitignore`. These are generated artifacts from `scripts/compile-rules.sh`. Never edit them directly.
- **`scripts/v3/` & `docs/v3-*`**: Experimental specifications. While not "zombie", they represent future state and should not be confused with the active Layer 1-5 framework.
- **`.claude/snapshots/`**: Ephemeral state dumps. Ignored and should not be committed.

---

## High-Level Architecture (Mermaid)

```mermaid
graph TD
    A[Root: CLAUDE.md] --> B[.claude/settings.json]
    A --> C[.claude/rules/]
    A --> D[.claude/templates/]
    
    subgraph "Domain Injection"
        C1[api.md] --- P1[/api/**]
        C2[db.md] --- P2[/db/**]
        C3[ci.md] --- P3[/.github/**]
    end
    
    subgraph "Operational Cycle"
        W[WISC Protocol] --> H[HANDOVER.md]
        H --> CL[Clear / Reset]
        CL --> R[Resume]
    end
    
    subgraph "Framework Distribution"
        S[scripts/bootstrap.sh] --> F[scripts/framework/]
        F -.->|Install/Sync| C
        F -.->|Install/Sync| D
    end
```
