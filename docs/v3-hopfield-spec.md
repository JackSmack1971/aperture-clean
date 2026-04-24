# v3.0.0 Specification: Hopfield Attractor Session Memory
<!--
  Status: ARCHITECTURAL BLUEPRINT — not yet implemented
  Research basis: Holographic Storage and Dynamical Attractors (Hopfield energy landscape)
  Target version: v3.0.0
  Prerequisites: Python 3.10+, modern-hopfield-networks or custom implementation
-->

## Problem Statement
HANDOVER.md is prose. Prose requires the resuming agent to re-derive state from language.
A Hopfield attractor encodes session state as a continuous memory pattern. Pattern
completion from a partial cue converges deterministically to the full state.
Error probability: P_err ≤ e^(-β·ΔE) — exponentially low with sufficient energy gap.

## Formal Definition
Memory states ξ encoded as continuous vectors in R^n.
Retrieval dynamics (gradient flow against Hopfield energy landscape):
  ds/dt = -∇E(s) = -s + ∫ ξ F'(β s^T ξ) dμ(ξ)
If a partial cue places state s inside basin of attraction B_μ:
  Pattern completion is deterministic, bounded by energy gap ΔE.

## Integration Design
HANDOVER.md becomes a two-layer artifact:
  Layer 1 (human-readable): existing HANDOVER.md prose sections — unchanged
  Layer 2 (machine-readable): .claude/memory/session-[id].hpf — Hopfield encoding

Resume from Layer 2 (when available):
  "Resume from session [id]" → load .hpf, inject as dense vector cue, complete pattern

Resume from Layer 1 (fallback, current behavior):
  "Read HANDOVER.md Machine State JSON and resume from next_step."

## Implementation Prerequisites
  modern-hopfield-networks or custom torch implementation
    pip install torch
    Reference: "Hopfield Networks is All You Need" (Ramsauer et al. 2020)
  numpy: vector operations
  The stored pattern capacity scales as: C ≈ d/log(d) for dense patterns (d = embedding dim)
  Recommended: d = 512+ for adequate session state encoding

## Build Protocol (when ready to implement)
  Phase 1: Session state vectorization
    scripts/v3/encode-session.py — convert HANDOVER.md Machine State JSON to dense vector
  Phase 2: Hopfield memory write
    scripts/v3/write-hopfield.py — store vector to .claude/memory/session-[id].hpf
  Phase 3: Pattern completion on resume
    scripts/v3/resume-session.py — given partial cue, complete to full session state
  Phase 4: Validation
    Compare resume accuracy (task completion rate) vs. prose HANDOVER.md baseline

## Storage
  .claude/memory/ — Hopfield pattern files (.hpf)
  (gitignored — session-specific artifacts, not framework files)

## Migration Path
Current: HANDOVER.md prose → agent reads and re-derives state
v3.0.0:  HANDOVER.md retained for humans; .hpf files for agent resume
         The two representations are generated simultaneously by STATE-FREEZE.md protocol

## Acceptance Criteria
Resume accuracy from .hpf encoding must match or exceed prose HANDOVER.md accuracy
on 10 paired test sessions before becoming the primary resume mechanism.

## Research Thread
This is not a current active research thread — implementation awaits v3.0 scaffolding
completion. Prerequisites: v3-hypergraph complete, sentence-transformers installed.
