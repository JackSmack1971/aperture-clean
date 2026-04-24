# MVCS-SYNTHESIS.md — Minimum Viable Context: New Feature Implementation
<!--
  Grounding: SWE-bench Verdent agent achieved 76.1% Pass@1 with minimal context.
  Token budget: 500–800 tokens total.
  Compaction threshold: 40% (synthesis tasks have high-signal context; compact near cliff)
  MDL directive: every token beyond this template degrades performance.
-->

## Required Context (inject these — nothing else)

### 1. Topological Skeleton
- Function signatures of the target implementation site (NOT full function bodies)
- Interface contracts (type definitions, parameter types, return types) for:
  - The target module
  - Up to 3 directly adjacent callers or dependencies
- Example: `interface AuthService { login(creds: Credentials): Promise<Token> }`

### 2. State-Differential Oracle
- The acceptance test that will verify the feature is complete (write it first)
- Pre-condition: system state before this feature exists
- Post-condition: measurable state after feature is implemented
- If no test exists: define one in ≤5 lines before beginning implementation

### 3. Localized Variable Space
- Type/schema definitions for data structures the feature will create or consume
- Strictly limited to types within the topological radius of the target file
- Do NOT include types for unrelated modules even if they share a namespace

## Exclusion Rules (mathematically degrade performance — never inject)
- Full file contents of any module (read AST node only)
- Unrelated API signatures from adjacent modules
- Full test suites for other features
- Implementation logic of callers that you are not modifying
- Database schemas beyond the tables directly touched by this feature

## Token Budget
Target: 500–800 tokens for the assembled context.
If budget exceeded: audit what was injected against exclusion rules.
The excess is almost always an excluded item that slipped in.

## Compaction Threshold for This Task
**40%** — near the 43.2% cliff; synthesis tasks have dense high-signal context.
`/compact preserve: [target interface contracts, acceptance test, type definitions]`

## Session Initialization
```
Task: SYNTHESIS — [brief feature description]
MVCS loaded: .claude/templates/MVCS-SYNTHESIS.md
Context budget: 500–800 tokens
Compaction threshold: 40%
State-Differential Oracle: [paste acceptance test here]
```
