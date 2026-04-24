# v3.0.0 Specification: Semantic Hypergraph Retrieval Layer
<!--
  Status: ARCHITECTURAL BLUEPRINT — not yet implemented
  Research basis: Information-Theoretic Suboptimality of File Systems
  Target version: v3.0.0
  Prerequisites: Python 3.10+, sentence-transformers, networkx, Tree-sitter
-->

## Problem Statement
File systems partition by co-location, not semantic relevance. For multi-hop reasoning
requiring m independent supports across separate partitions:
  P(cover, filesystem) ≤ (b/K)^m
Coverage decays exponentially with hop count. The hypergraph eliminates this bound.

## Formal Definition
Semantic hypergraph H = (V, E, w) where:
  V = atomic rule fragments (50-300 token chunks from .claude/rules/*.md)
  E = hyperedges capturing multi-way semantic relations between fragments
  w = edge weights (cosine similarity of sentence embeddings)

Retrieval via higher-order message passing:
  a_v(t+1) = σ(α·a_v(t) + Σ_{e∋v} (w_e/|e|) · ψ_e({a_u(t): u∈e\{v}}, u_q))

Coverage for m-hop reasoning approaches 1 as traversal depth grows.

## Integration API
The hypergraph layer replaces path-glob injection in .claude/settings.json.
Interface (planned):
  aperture query --model claude --task "add RBAC to auth middleware" --top-k 5
Returns: ranked list of rule fragments with highest semantic relevance to the task.
Falls back to glob injection if hypergraph index is unavailable.

## Implementation Prerequisites
  sentence-transformers: fragment embedding generation
    pip install sentence-transformers
    Recommended model: all-MiniLM-L6-v2 (384-dim, fast, high quality)
  networkx: hypergraph construction and traversal
    pip install networkx
  Tree-sitter: AST-based fragment extraction
    pip install tree-sitter tree-sitter-python tree-sitter-javascript
  scipy: Wasserstein distance for edge weight validation

## Build Protocol (when ready to implement)
  Phase 1: Fragment extraction
    scripts/v3/extract-fragments.py — parse rule files into atomic chunks with metadata
  Phase 2: Embedding generation
    scripts/v3/embed-fragments.py — generate sentence embeddings for all fragments
  Phase 3: Hyperedge construction
    scripts/v3/build-hypergraph.py — construct hyperedges via cosine similarity threshold
  Phase 4: Integration stub activation
    Modify .claude/settings.json: "retrieval_mode": "hypergraph"
  Phase 5: A/B validation
    Run /audit-framework with both glob and hypergraph; compare Phase 9 ADS scores

## Index Storage
  .claude/hypergraph/index.json — fragment registry
  .claude/hypergraph/embeddings.npy — numpy embedding matrix
  .claude/hypergraph/edges.json — hyperedge adjacency
  (all gitignored — generated artifacts)

## Migration Path
Current: .claude/rules/*.md loaded by path glob patterns
v3.0.0:  hypergraph queries replace glob for rule selection;
         glob remains as fallback and for GEMINI.md (always-loaded, bypasses retrieval)

## Acceptance Criteria
  A/B test threshold: hypergraph retrieval must exceed glob injection by ≥10 percentage
  points on Phase 9 ADS average across 10 test tasks before graduation to primary.
  Glob injection remains available via settings.json toggle indefinitely.

## Research Thread
RT-4: Hypergraph retrieval vs. glob injection benchmark
See: docs/research-threads.md
