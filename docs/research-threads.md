# Research Threads — Active Investigations

Active empirical research threads informing Aperture's roadmap.
Each thread has a status, hypothesis, and target roadmap item.

## RT-1: Per-Model Attention Sink Characterization
**Status:** OPEN
**Hypothesis:** Different model architectures respond to different structural anchor
syntax. Claude responds to XML/bold/NEVER; Gemini 3 Pro may respond to ## headers
and > blockquotes. If true, the MVCS Compiler (v2.0.4) requires model-specific
transforms validated by attention weight measurement.
**Method:** TransformerLens hook extraction on identical content with varied syntax,
measuring per-token attention entropy and Top-3 concentration per model architecture.
**Target:** v2.0.4 (MVCS Compiler Gemini transforms graduation from STUB to production)
**Blocked by:** Access to Gemini 3 Pro activation internals for interpretability hooks

## RT-2: Task Class Saturation Profiles
**Status:** OPEN
**Hypothesis:** The 43.2% sigmoid collapse threshold varies by task class.
Debugging tasks (with stack traces) may hit the cliff at 35%; synthesis tasks at 45%.
If validated, the per-class thresholds in MVCS templates (30/35/40%) need calibration.
**Method:** Measure F1 score degradation curves for 50 tasks per class as saturation
increases from 0% to 100%. Apply five-method cross-validation per class.
**Target:** v2.0.2 (dynamic SDS component of Aperture Score)
**Blocked by:** Requires access to model internal activation states during task execution

## RT-3: FAILURE_LEDGER Optimal Corpus Size for Context Governance
**Status:** OPEN
**Hypothesis:** The Pareto boundary of ~10-20 entries (derived from code generation
research) may differ for context governance tasks. Context governance failures are
structural (wrong format, wrong file touched) rather than logical. The boundary may
be lower (5-10 systemic entries).
**Method:** Measure agent repeat-failure rate as ledger size grows from 0 to 30 entries
across 100 context governance tasks. Identify inflection point where adding entries
stops reducing repeat failures.
**Target:** Refine FAILURE_LEDGER.md Pareto boundary note in v1.2.0
**Blocked by:** Requires extended session data from real Aperture deployments

## RT-4: Hypergraph Retrieval vs. Glob Injection Benchmark
**Status:** OPEN (depends on v3-hypergraph-spec.md implementation)
**Hypothesis:** Semantic hypergraph retrieval produces higher task completion rates
than path-glob injection while using fewer tokens. Specifically: multi-domain tasks
(requiring both /api/ and /security/ rules) should see the largest improvement.
**Method:** A/B test: 20 tasks per task class, half with glob injection, half with
hypergraph retrieval. Measure: ADS scores, task completion, token consumption.
**Target:** v3.0.0 Phase 5 (graduation gate for hypergraph to primary retrieval)
**Blocked by:** v3-hypergraph-spec.md implementation complete

## RT-5: Staged Compaction (Rule-Based Elision Before LLM Summary)
**Status:** OPEN
**Hypothesis:** Removing bulk tool output by deterministic rules before an LLM summary
(`/compact preserve:`) retains more task-relevant evidence per token than summary alone.
Source: harness-design study and action-preserving compression work in
`docs/research/LLM_Agent_Context_Management.md` (results are from other harnesses,
not Aperture).
**Method:** A/B on matched tasks: summary-only vs elision+summary. Measure input/cache
tokens, task success, and retention of exact error lines and file:line pointers.
**Target:** COMPACTION.md staging order (v3.2.x)
**Blocked by:** Baseline `/context` and `/usage` measurements at a pinned Claude Code version

## RT-6: Clean-Slate Retry vs Same-Context Retry (Contextual Drag)
**Status:** OPEN
**Hypothesis:** After repeated failures on one error, a retry in a fresh subagent that
receives only goal, constraints, exact error, and file pointers (no failed drafts)
succeeds more often than continuing in the polluted context. Source: contextual-drag
study cited in the research document (structural anchoring to earlier erroneous drafts).
**Method:** Seeded failing tasks; compare success after 3rd attempt: continue vs fresh
subagent. Count parent + child tokens.
**Target:** SUBAGENT.md clean-slate retry rule (v3.2.x)
**Blocked by:** Task suite and parent+child token accounting

## RT-7: Subagent Isolation Economics
**Status:** OPEN
**Hypothesis:** Delegating noisy exploration keeps the parent window leaner, but aggregate
(parent + child + return) usage may be higher; net benefit depends on task shape.
The research document asserts the parent-side benefit; aggregate accounting is not
established for Aperture.
**Method:** Matched exploration tasks inline vs delegated; record parent, child, and
return-payload tokens separately plus task success.
**Target:** SUBAGENT.md return-contract sizing (currently <=500 tokens, unvalidated)
**Blocked by:** Token accounting at pinned version

## RT-8: Handover Brevity vs Context Collapse
**Status:** OPEN
**Hypothesis:** A 150-token HANDOVER may lose details that itemized delta-entry
playbooks retain (brevity bias / context collapse, per the ACE work in the research
document). The CHANGELOG 3.2.0 claim of eliminating a "60% fact destruction rate" has no
reproducible measurement in this repo.
**Method:** Seed sessions with N known facts; resume from 150-token HANDOVER vs a
pointer-based handover; score fact retention and resume success.
**Target:** HANDOVER.md schema (HO-v1.0) review
**Blocked by:** Session corpus with known ground-truth facts

## Adding a Research Thread
When new empirical evidence requires investigation:
1. Add RT-N entry above with: Status, Hypothesis, Method, Target, Blocked by
2. Commit: `docs: add RT-N [brief description]`
3. When resolved: update Status to CLOSED, add Finding summary, update target roadmap item
