# Aperture — Development Roadmap

> **Vision:** Aperture is not a collection of best practices.
> It is a formally grounded context engineering framework whose architectural decisions
> are derivable from first principles in information theory, transformer mathematics,
> and cognitive load dynamics. Every feature on this roadmap is traceable to an
> empirical proof, a formal bound, or a measured failure mode.

This roadmap is organized by release tier. Each item states what it is, why it
matters mathematically, what it changes in the framework, and what success looks like.

**Research foundation:** Five empirical analyses ground this roadmap:
- *Attention Weight Distribution under Structural Formatting* (RoPE/attention sink theory)
- *Performance Degradation Geometry under Context Saturation* (sigmoid collapse / 43.2% threshold)
- *Minimum Viable Context Signatures for SE Tasks* (Information Bottleneck / SWE-bench telemetry)
- *Optimal Failure Ledger Architecture* (Pareto distribution / Patch Note Paradox)
- *Context Engineering Criticality at Scale* (O(1/N) attention decay / RULER benchmark)
- *Information-Theoretic Suboptimality of File Systems* (hypergraph retrieval / sheaf theory)

---

## IMMEDIATE — v1.2.0 (Emergency Corrections)

*These are not features. They are corrections to decisions we made on incomplete data.
The research invalidates two current Aperture defaults. Fix these before building anything else.*

---

### 1.2.1 — Correct the Compaction Threshold: 60% → 38%

**The finding:** Five-method cross-validation on Qwen2.5-7B establishes the sigmoid
collapse inflection point at exactly **43.2% context saturation** (median validation).
At this threshold, softmax entropy dilution triggers a 45.5% reasoning degradation rate
and a 0.302 F1 score drop. Critically, uncertainty bounds are maximized precisely at
this cliff — microscopic variations in token embeddings cause maximum hallucination
variance. Compacting at 60% means the agent has been operating in the collapsed state
for 16.8% of the window before any intervention fires.

**The fix:** The safe compaction trigger is **38%** — 5.2 points below the cliff,
providing a buffer against the uncertainty maximum. This is not conservative; it is
the mathematically correct trigger that keeps the model inside the Stability Plateau.

**Files changed:**
- `CLAUDE.md` — update compaction directive: "Manual compaction at **38%** saturation"
- `GEMINI.md` — update Commit Protocol compaction reference
- `.claude/templates/COMPACTION.md` — update saturation threshold in trigger check
  (currently reads "55–65%"; update to "30–38% proceed / >40% = STOP, immediate action")
- `README.md` — update "How It Works" diagram threshold references
- `docs/setup.md` — update daily workflow compaction guidance

**Success metric:** Agent never enters the High-Saturation Regime (>43.2%) during
a governed session. Compaction fires in the Stability Plateau by design.

---

### 1.2.2 — Pareto-Bounded Failure Ledger Curation

**The finding:** The Pareto distribution of systemic defects demonstrates that ~80% of
agent failures stem from ~20% of root causes. Unbounded ledger growth incurs quadratic
compute penalties without proportional entropy reduction. The mathematical boundary:
beyond the Pareto boundary (~10-20 high-fidelity systemic entries), adding to the ledger
actively dilutes the signal rather than amplifying it. Additionally, the "Patch Note
Paradox" requires temporal grounding — entries must be datestamped so superseding
environmental changes (API updates, library patches) can override stale failure records.

**The fix:** Two changes to `FAILURE_LEDGER.md` protocol:
1. Add a **Pareto Curation Rule** — entries that represent transient anomalies (single
   occurrence, environment-specific) are tagged `[TRANSIENT]` and pruned quarterly.
   Entries representing systemic patterns (recurs across sessions/domains) are tagged
   `[SYSTEMIC]` and never deleted.
2. Enforce the temporal invariant already in the format — the date is not decorative,
   it enables supersession logic. Add explicit note: entries older than 90 days against
   a dependency that has since updated should be reviewed and superseded, not deleted.

**Files changed:**
- `.claude/templates/FAILURE_LEDGER.md` — add Pareto tags, curation protocol, supersession note
- `.agent/rules/changelog-commit.md` — add quarterly ledger curation to maintenance tasks

---

## NEAR-TERM — v1.3.0 (Formally Grounded Features)

*Features derived directly from the empirical research that have clear, buildable
implementations within the existing file-system architecture.*

---

### 1.3.1 — Anchor Density Scoring (ADS) for Rule Files

**The finding:** RoPE-induced attention sinks are not random — structured syntactic
anchors (XML tags, delimiters, brackets, bold operators, NEVER directives) capture
the massive values in Q/K matrices, causing attention probability mass to collapse
onto them with <1.5 bits entropy and >85% Top-3 concentration. Natural language prose
produces >4.0 bits entropy with <30% Top-3 concentration. This means Aperture's rule
file format constraints are not style preferences — they are formally optimal attention
engineering. But we have no tool to score a rule file against these criteria.

**The feature:** An `ads` (Anchor Density Score) metric computed as a bash audit function:
- Counts structural anchors per 50 tokens: XML-style tags, `**BOLD**`, `- NEVER`,
  numbered list items, code blocks, explicit directive verbs (EXTRACT, VERIFY, NEVER)
- Produces a score from 0-100 where >70 = high attention capture, <40 = attention diffuse
- Integrated into Phase 2 of `/audit-framework` as a per-file score
- Rule files scoring <40 trigger a WARN with specific structural improvement suggestions

**Files changed:**
- `.agent/workflows/audit-framework.md` — add ADS scoring to Phase 2 schema compliance
- `.agent/rules/contribution-protocol.md` — add ADS minimum threshold (>60) to validation checklist
- `README.md` — add ADS explanation to Domain Rules Reference section

---

### 1.3.2 — Minimum Viable Context Signatures (MVCS) per Task Class

**The finding:** SWE-bench empirical telemetry proves that maximum performance comes
from minimum context. The Verdent agent achieved 76.1% Pass@1 by restricting to bash
read/write only. The Live-SWE-agent hit 77.4% with PMI-maximized dynamic context.
The MVCS decomposes into three formal structures:
- **Topological Skeletons:** AST signatures and interface contracts for the target path
- **State-Differential Oracles:** Unit tests, error traces, pre/post conditions
- **Localized Variable Spaces:** Type definitions within the topological radius of the edit

**The feature:** Three MVCS templates — one per dominant SE task class — that prescribe
exactly which context elements to inject and which to exclude, replacing the current
"fetch targeted node only" heuristics with task-derived formal bounds.

**New files:**
- `.claude/templates/MVCS-SYNTHESIS.md` — context prescription for new feature implementation
- `.claude/templates/MVCS-DEBUGGING.md` — context prescription for bug investigation tasks
- `.claude/templates/MVCS-REFACTOR.md` — context prescription for coupled modification tasks

Each template contains: required elements (what must be in context), exclusion rules
(what mathematically degrades performance for this task class), and a token budget target
derived from the MVC boundary for that class.

**Files changed:**
- `.claude/templates/SUBAGENT.md` — reference MVCS templates in Context section
- `CLAUDE.md` — add pointer: "For task-specific context composition: `.claude/templates/MVCS-*`"

---

### 1.3.3 — State Freezing Protocol

**The finding:** The research formalizes "State Freezing" as the antidote to Miller's
Law applied to LLMs — just as human working memory is bounded to ~7±2 items, generative
models cannot sustain coherent multi-step analysis without explicit selective attention
mechanisms. The solution: periodically extract negative constraints to the persistent
ledger and aggressively wipe active context, then reinitialize with only the compressed
state in the system prompt. This returns 100% of the token budget while preserving all
non-redundant epistemic content.

**The feature:** State Freezing is the formalized version of what WISC's "Compress" step
currently does informally. The upgrade: make it a named, explicitly-triggered operation
distinct from /compact, with its own protocol.

**New file:**
- `.claude/templates/STATE-FREEZE.md` — the State Freeze protocol:
  1. Extract all `[SYSTEMIC]` failure patterns to FAILURE_LEDGER.md
  2. Write compressed HANDOVER.md (Machine State JSON + Next Step only)
  3. Hard `/clear` — destroy entire context
  4. Initialize fresh session with: system prompt + HANDOVER.md + relevant MVCS template only
  5. Do not re-read session history

**Files changed:**
- `CLAUDE.md` — add State Freeze as a distinct operation in Compaction Protocol section
- `GEMINI.md` — add `/state-freeze` to Commands section
- `.agent/workflows/` — add `state-freeze.md` workflow

---

## MEDIUM-TERM — v2.0.0 (Architecture Evolution)

*These features require new infrastructure but remain within the filesystem paradigm.
They represent the maturation of Aperture from a governance framework into a measured,
scored, adaptive context engineering system.*

---

### 2.0.1 — The Aperture Score

**The vision:** A composite framework health metric combining all formal measures
into a single session-quality indicator. The Aperture Score is computed per session
and per project, giving teams a measurable signal of context engineering discipline.

**Components:**
- **Structural Integrity Score (0-100):** Average ADS across all active rule files
- **Saturation Discipline Score (0-100):** How early compaction was triggered relative
  to the 43.2% cliff. Score = 100 if compacted at ≤38%, decays linearly to 0 at 43.2%
- **MVCS Compliance Score (0-100):** Fraction of task sessions where the injected
  context matched the prescribed MVCS for the task class (measured by token composition)
- **Ledger Health Score (0-100):** SYSTEMIC:TRANSIENT ratio; approaches 100 as
  the ledger converges to Pareto-optimal systemic-only entries

**Composite:** `AS = 0.25*(SIS) + 0.35*(SDS) + 0.25*(MCS) + 0.15*(LHS)`

Saturation Discipline weighted highest (0.35) because the sigmoid collapse is the
highest-variance failure mode — a single session that crosses 43.2% undoes gains
from excellent structural formatting.

**Implementation:** Computed by an enhanced `/audit-framework` that persists scores
to `.claude/snapshots/aperture-scores.json` across sessions, enabling trend tracking.

---

### 2.0.2 — Dynamic Compaction Thresholds by Task Class

**The finding:** The 43.2% cliff is a population median. The research shows that
different task classes have different saturation profiles — debugging tasks with large
stack traces saturate the useful reasoning band faster than synthesis tasks with
clean AST context. A fixed threshold is suboptimal.

**The feature:** Task-class-aware compaction triggers, encoded in the MVCS templates:
- **SYNTHESIS tasks:** compact at 40% (near-cliff; synthesis tasks have high-signal context)
- **DEBUGGING tasks:** compact at 30% (aggressive; stack traces accelerate the cliff)
- **REFACTOR tasks:** compact at 35% (moderate; coupled reads accumulate quickly)

**Implementation:** MVCS templates include a `compaction_threshold` field. GEMINI.md
references the active task class at session start so the agent applies the correct threshold.

---

### 2.0.3 — Attention Anchor Linting in /add-rule Workflow

**The finding:** The `/add-rule` workflow currently validates structure and line count.
It does not validate attention quality — whether the rule file's syntax will actually
capture attention sinks or diffuse them. Given the RoPE/attention sink proof, this is
the highest-leverage quality gate we can add without external tooling.

**The feature:** The ADS scoring function (from v1.3.1) is promoted to a hard gate in
the `/add-rule` workflow. Rule files with ADS < 50 cannot be committed — the workflow
returns a specific lint report with the exact tokens that are diffusing attention.

**Examples of lint feedback:**
```
ATTENTION LINT — api.md
  Line 12: "You should consider avoiding logging PII fields" 
    → Replace with: "**NEVER** log PII fields — credentials, tokens, session IDs"
    → Reason: modal hedging ("should consider") is low-anchor prose; NEVER + bold = attention sink
  Score: 38/100 → Minimum: 50
  Required changes: 3 structural anchors needed in Auth Middleware section
```

---

### 2.0.4 — The MVCS Compiler (Cross-Model Compatibility Layer)

**The finding:** The attention sink research raises a cross-model question. XML tags
capture RoPE sinks in Claude's architecture. Gemini 3 Pro's attention geometry may
respond to different structural anchors. If format effectiveness is model-specific,
Aperture needs a compilation layer — rule files authored in a model-agnostic format,
compiled to model-optimized syntax at deploy time.

**The feature:** A `model` field in `.claude/settings.json` triggers format compilation:
- Claude target → XML anchors, `**NEVER**` bold, numbered lists (current format)
- Gemini target → `##` header anchors, `> blockquote` directives, `:` colon-terminated keys
- Universal fallback → maximum structural density regardless of model

**Implementation:** A `compile-rules.sh` script that reads model from settings.json
and outputs compiled versions of `.claude/rules/*.md` to a `.claude/compiled/` directory.
The agent reads from compiled/ in multi-model deployments.

---

## LONG-TERM — v3.0.0 (The Filesystem Exit)

*The contrarian question was answered definitively: file systems are provably suboptimal
for context engineering. The proof is formal — coverage probability decays as (b/K)^m
with hop count m, creating an insurmountable structural bottleneck for multi-hop reasoning.
These roadmap items represent the architectural migration away from hierarchical file
trees toward the theoretically optimal hybrid architecture. They are not speculative —
the mathematical specification is complete. The work is implementation.*

---

### 3.0.1 — The Semantic Hypergraph Layer (Aperture Hypergraph)

**The theory:** A semantic hypergraph `H = (V, E, w)` where hyperedges capture
multi-way semantic relations between rule fragments, allowing retrieval by relational
reachability rather than directory co-location. Coverage probability for m-hop
reasoning becomes `P(cover) → 1` as traversal depth grows — the inverse of
file-system exponential decay.

**What this replaces:** `.claude/rules/` directory structure for rule selection.
The agent no longer loads rules by path glob — it queries the hypergraph for the
minimal set of rule fragments with maximum PMI against the current task description.

**What this preserves:** The rule file content is unchanged. The hypergraph is a
retrieval index over the existing files, not a replacement for them. Aperture's
governance layer (GEMINI.md, .agent/) remains file-based throughout.

**Implementation path:**
- Phase 1: Build the hypergraph index as a supplemental layer alongside existing globs
- Phase 2: A/B test hypergraph retrieval vs. glob-based injection on real tasks
- Phase 3: Graduate hypergraph to primary retrieval once quality exceeds glob baseline
- Tools: Tree-sitter for AST node extraction, sentence-transformers for hyperedge weights

---

### 3.0.2 — Hopfield Attractor Memory for Session Continuity

**The theory:** Instead of writing HANDOVER.md as structured prose, session state is
encoded as a continuous attractor in a Modern Hopfield Network. Pattern completion
from a partial cue (the resume prompt) converges deterministically to the full session
state via gradient flow. Error probability bounded by `P_err ≤ e^(-β·ΔE)` — exponentially
low retrieval error with sufficient energy gap.

**What this replaces:** The prose sections of HANDOVER.md for machine-consumed state.
Human-readable HANDOVER.md sections are preserved as a parallel representation.

**The practical translation:** An embedding-based session state store where
a fresh session can reconstruct prior state from a minimal "resume cue" — a single
sentence — rather than requiring the agent to read a 60-line structured document.

---

### 3.0.3 — Predictive Coding Context Admission Controller

**The theory:** Context admission is modeled as expected free-energy minimization.
For each candidate context fragment, compute `ΔF_i = F(without i) - F(with i)`.
Admit fragments with largest `ΔF_i` — those that reduce predictive surprise most.
Reject fragments with `ΔF_i ≈ 0` — they add tokens without reducing uncertainty.

**What this replaces:** The heuristic-based `.claudeignore` and path-scoped injection.
The Predictive Coding Admission Controller (PCAC) dynamically selects the context
composition that minimizes free energy for the current query, irrespective of file
location or path patterns.

**What this preserves:** `.claudeignore` remains as a hard exclusion list for security
and token economy. PCAC operates above the ignore layer — it selects from the
non-ignored candidate set.

---

### 3.0.4 — Sheaf-Theoretic Consistency Constraints

**The theory:** When multi-domain reasoning requires overlapping context from several
rule files, file-system retrieval produces inconsistent partial views with no formal
mechanism to detect or resolve contradiction. Sheaf-theoretic gluing constraints mandate
that local representations agree on intersections: `s_i|_(U_i∩U_j) = s_j|_(U_i∩U_j)`.
Minimizing the gluing energy `E_glue = |δs|²` via the coboundary operator enforces
global logical coherence. Hallucination rate bounded as `h_sheaf ∝ e^(-γ|δs|²)`.

**What this solves:** Cross-domain instruction conflicts. When `/api/` rules and
`/security/` rules produce contradictory directives, there is currently no mechanism
to detect or resolve it — the agent makes an arbitrary choice. Sheaf constraints make
cross-domain inconsistency a measurable, minimizable quantity.

**What this produces:** A "coherence score" for any assembled multi-domain context,
flagging combinations that will produce inconsistent agent behavior before execution.

---

## Research Threads Running in Parallel

These are not versioned features — they are ongoing empirical work that will feed
future roadmap items as data accumulates.

**RT-1: Per-model attention sink characterization**
Does Gemini 3 Pro respond to the same structural anchors as Claude? What are the
optimal syntax patterns for each model architecture? Informs v2.0.4.

**RT-2: Task class saturation profiles**
Measure the actual degradation curves for synthesis vs. debugging vs. refactor tasks.
Does the 43.2% cliff vary by task class? Informs v2.0.2.

**RT-3: FAILURE_LEDGER optimal corpus size**
At what ledger size does Bayesian information gain per entry approach zero for the
Aperture framework specifically (context governance, not code generation)? Informs
the Pareto curation threshold in v1.2.2.

**RT-4: Hypergraph retrieval vs. glob injection benchmark**
Does semantic hypergraph retrieval produce better task outcomes than the current
deterministic path-glob injection? On what task classes? Informs v3.0.1 progression.

---

## Version Summary

| Version | Theme | Key Deliverable |
|---|---|---|
| **v1.2.0** | Emergency corrections | Fix 60%→38% threshold; Pareto-bound ledger |
| **v1.3.0** | Formal grounding | ADS scoring; MVCS templates; State Freeze |
| **v2.0.0** | Architecture evolution | Aperture Score; dynamic thresholds; ADS linting; MVCS compiler |
| **v3.0.0** | Filesystem exit | Hypergraph retrieval; Hopfield memory; PCAC; sheaf consistency |

---

## What We Will Never Build

Aperture will not add:
- **Inference-time reasoning patterns** (CoT, ToT, MCTS) — these operate at the wrong
  layer. Aperture governs what enters the window. It does not prescribe how the model
  reasons once it is there. That boundary is architecturally sacred.
- **Model-specific fine-tuning hooks** — Aperture works with frozen, API-accessed models.
  Weight modification is a different problem category.
- **Real-time telemetry or analytics dashboards** — Aperture is a developer-local framework.
  Measurement is through shell oracles and audit workflows, not observability infrastructure.
- **Large Language Model integrations for context selection** — using an LLM to decide
  what context to inject for another LLM is the routing overhead problem the entire
  framework exists to eliminate. The injection mechanism stays deterministic.

---

*The filesystem exit in v3.0 is not a rewrite of Aperture. It is the graduation of
Aperture's retrieval layer from heuristic to optimal. The governance layer, the commit
protocol, the session hygiene checklist, the WISC protocol — these survive into v3.0
unchanged. The shell stays the same. The engine changes.*

*The math has been done. The question is only implementation order.*

---

## Phase 2: Next Steps

Phase 1 (Native Alignment Refactor) is complete. For detailed Phase 2 objectives (ADS Automation, Pareto Ledger Curation), see:

**[Phase 2 Roadmap](.claude/PHASE2-ROADMAP.md)**

---
**Roadmap Version:** 1.0
**Research basis:** 5-questions-answered.md (attached empirical analyses)
**Maintained by:** Aperture core team
**Updated:** per significant release or research finding
