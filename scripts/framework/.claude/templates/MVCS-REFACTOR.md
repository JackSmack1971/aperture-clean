# MVCS-REFACTOR.md — Minimum Viable Context: Coupled Modification
<!--
  Grounding: Ben-David H-divergence bound — context minimization enables cross-domain
  transfer. Refactoring fails when full implementation details of adjacent nodes are loaded.
  Token budget: 800–1500 tokens total.
  Compaction threshold: 35% (coupled reads accumulate interface chains quickly)
  MDL directive: discard internal implementation of unedited adjacent nodes.
-->

## Required Context (inject these — nothing else)

### 1. Topological Skeleton
- Interface contracts for ALL nodes directly coupled to the modification
  (signatures + type definitions — never implementation bodies of callers)
- The dependency graph edges touching the modified interface:
  who calls it, who does it call
- If renaming or changing signatures: the complete list of call sites (file:line only)

### 2. State-Differential Oracle
- The existing tests that cover the interface being modified (read them — they define the contract)
- Pre-condition: current interface signature
- Post-condition: new interface signature
- Breaking change checklist: which callers must be updated as a result

### 3. Localized Variable Space
- Type definitions for ALL data structures whose shape changes in this refactor
- Migration mapping if types are renamed: `OldType → NewType`
- Do NOT include types for modules that do not touch the changed interface

## Exclusion Rules (mathematically degrade performance — never inject)
- Internal implementation logic of callers you are NOT modifying
- Test files for modules unaffected by the interface change
- Full file contents — read interface contracts only
- Database schemas unless the refactor touches persistence layer
- Documentation files (read after implementation to update, not before)

## Token Budget
Target: 800–1500 tokens. Refactoring requires broader interface awareness.
If budget exceeded: you are reading implementation logic you should be excluding.
Return to signatures and contracts only.

## Compaction Threshold for This Task
**35%** — coupled reads of multiple interface files accumulate faster than synthesis.
`/compact preserve: [modified interface signature, call sites affected, breaking changes]`

## Session Initialization
```
Task: REFACTOR — [describe the interface change in one sentence]
MVCS loaded: .claude/templates/MVCS-REFACTOR.md
Context budget: 800–1500 tokens
Compaction threshold: 35%
Scope: [list files whose interfaces are changing]
```
