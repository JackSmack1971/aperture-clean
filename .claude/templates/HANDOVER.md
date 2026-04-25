<!-- APERTURE-CLEAN HANDOVER v1.0 | 150-token budget ENFORCED | RESTRICTED: prose narrative -->
<!-- SCHEMA: Core(40-60t) + Context(30-50t) + Episodic(20-30t) + Meta(5-10t) = ≤150 tokens total -->

## Core State [target: 40–60 tokens]
```yaml
intention: ""          # Active goal — 1 imperative sentence
active_blockers: []    # Unresolved impediments — terse noun phrases only
decisions_made: []     # Settled choices — verb + rationale ≤10 words each
```

## Context State [target: 30–50 tokens]
```yaml
modified_files: []     # Exact paths only
git_state: ""          # git rev-parse --short HEAD
key_deps: []           # Architectural dependencies added this session
```

## Episodic State [target: 20–30 tokens]
```yaml
next_steps:            # Ordered — copy-paste executable imperative verbs
  - ""
  - ""
```

## Metadata [target: 5–10 tokens]
```yaml
timestamp: ""          # ISO 8601 UTC
schema_version: "aperture-clean-v1.0"
context_pct: ""
```

---
<!-- AI-TO-AI PAYLOAD — bounded JSON — required for subagent resume -->
```json
{
  "goal": "",
  "blockers": [],
  "decisions": [],
  "modified_files": [],
  "git_branch": "",
  "git_hash": "",
  "next_steps": [],
  "schema_version": "HO-v1.0",
  "timestamp": "",
  "context_saturation_pct": 0
}
```
