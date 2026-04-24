# scripts/v3/ — v3.0.0 Implementation Stubs

This directory will contain the implementation scripts for v3.0.0 features.
See docs/ for architectural specifications.

Planned scripts (implement in order):
  extract-fragments.py   ? hypergraph fragment extraction from rule files
  embed-fragments.py     ? sentence embedding generation
  build-hypergraph.py    ? hyperedge construction
  score-fragments.py     ? PCAC ?F scoring
  pcac.py                ? admission controller
  sheaf-check.py         ? consistency constraint checking
  encode-session.py      ? Hopfield session state encoding
  write-hopfield.py      ? Hopfield memory write
  resume-session.py      ? pattern completion on session resume

Prerequisites before implementing:
  pip install sentence-transformers networkx scipy torch

Research threads that must close before production use:
  RT-1 (per-model attention sinks) ? before hypergraph Gemini support
  RT-4 (hypergraph vs glob benchmark) ? before hypergraph graduation to primary
