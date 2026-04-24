# v3.0.0 Specification: Predictive Coding Admission Controller (PCAC)
<!--
  Status: ARCHITECTURAL BLUEPRINT — not yet implemented
  Research basis: Context Admission as Free-Energy Minimization (Friston, 2010)
  Target version: v3.0.0
  Prerequisites: v3-hypergraph-spec.md implemented; sentence-transformers active
-->

## Problem Statement
.claudeignore and path-glob injection are static heuristics. They cannot adapt
to query-specific relevance. A fragment that is noise for task A may be critical
for task B. Static rules cannot distinguish them.
PCAC makes context admission dynamic: admit fragments that reduce predictive surprise.

## Formal Definition
For each candidate context fragment c_i, compute:
  ΔF_i = F(context without c_i) - F(context with c_i)
where F[q] is the variational free energy of the current query/context state.
Admit fragments where ΔF_i > threshold (they reduce uncertainty).
Reject fragments where ΔF_i ≈ 0 (they add tokens without reducing uncertainty).

## Integration Design
PCAC operates as a middleware layer between .claudeignore (hard exclusions) and
the active context window. It selects from the non-ignored candidate pool.

Pipeline:
  Query → .claudeignore filter → PCAC scoring → ranked candidate set → context injection

Settings integration:
  .claude/settings.json: "context_admission": "pcac" | "glob" | "hybrid"
  "pcac_threshold": 0.15  (minimum ΔF to admit a fragment)
  "hybrid_fallback": true  (fall back to glob if PCAC confidence is low)

## Implementation Prerequisites
  sentence-transformers (query and fragment embeddings for ΔF approximation)
  scipy (KL divergence for free energy approximation)
  The free energy approximation uses embedding cosine distance as a proxy:
    ΔF_i ≈ cos_sim(fragment_embedding, query_embedding) - baseline_noise_floor

## Build Protocol (when ready)
  Phase 1: Fragment scoring function
    scripts/v3/score-fragments.py — compute ΔF for all candidate fragments given query
  Phase 2: Admission controller
    scripts/v3/pcac.py — filter, rank, and truncate to token budget
  Phase 3: Integration hook in settings.json
    Activate "context_admission": "hybrid" for gradual rollout (PCAC + glob fallback)
  Phase 4: Validation
    Compare task completion rate: PCAC selection vs. glob injection baseline

## Acceptance Criteria
PCAC admission must match or exceed glob injection task completion rates while
using fewer tokens (target: ≤80% of glob token budget for equivalent quality).
Validate on 20 tasks across all three MVCS task classes.

## Dependency
Requires v3-hypergraph-spec.md to be implemented first — PCAC scores fragments
from the hypergraph index, not from directory scans.
