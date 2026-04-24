# MVCS-DEBUGGING.md — Minimum Viable Context: Bug Investigation
<!--
  Grounding: PMI-maximized context achieves ~80% bug localization in top 10% files.
  Token budget: 300–600 tokens total.
  Compaction threshold: 30% (stack traces and error outputs saturate context rapidly)
  MDL directive: load only what has maximum PMI with the error trace.
-->

## Required Context (inject these — nothing else)

### 1. Topological Skeleton
- The exact function containing the suspected bug (full function body ONLY for this one)
- Interface contracts of the immediate callers passing bad data (signatures only)
- AST node for any utility function invoked within the failing path

### 2. State-Differential Oracle (the bug's fingerprint)
- **Exact error message** — copy verbatim, do not paraphrase
- **Stack trace** — top 5 frames ONLY; truncate the rest (low PMI)
- **Reproduction case** — minimum input that triggers the bug, ≤10 lines
- **Expected behavior** — one sentence: what should happen instead

### 3. Localized Variable Space
- Type definitions for arguments flowing into the failing function
- The specific enum, constant, or schema value that is incorrect (if applicable)
- Do NOT include types for unrelated flows

## Exclusion Rules (mathematically degrade performance — never inject)
- Passing tests (zero PMI with the failure)
- Full file contents of any module
- Unexecuted conditional branches irrelevant to the failing path
- Historical commit messages or git blame output
- The full stack trace beyond frame 5 (noise)

## Token Budget
Target: 300–600 tokens. Debugging requires precision over breadth.
If budget exceeded: the reproduction case or stack trace is likely too verbose.
Truncate to minimum reproduction.

## Compaction Threshold for This Task
**30%** — aggressive; stack traces and error dumps fill the window rapidly.
Evict all error output immediately after root cause is identified.
`/compact preserve: [root cause statement, fix hypothesis, exact failing line]`

## Session Initialization
```
Task: DEBUGGING — [one-sentence bug description]
MVCS loaded: .claude/templates/MVCS-DEBUGGING.md
Context budget: 300–600 tokens
Compaction threshold: 30%
Error fingerprint: [paste error message first line here]
```
