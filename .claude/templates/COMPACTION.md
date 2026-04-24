# COMPACTION.md — Pre-Compaction Preservation Checklist
<!--
  INSTRUCTIONS:
  Execute this checklist BEFORE running /compact.
  Optimal compaction window: 30–38% context saturation.
  Research-validated: the sigmoid collapse inflection point is 43.2%. Compacting at 38% keeps the model inside the Stability Plateau with full reasoning capacity.
  NEVER wait for auto-compaction (95%) — model is in degraded state at that threshold.

  Usage:
    1. Fill the "Preserve Directives" section
    2. Run: /compact preserve: [paste directives below]
    3. Verify the post-compaction summary against this checklist
-->

## Compaction Trigger Check
- [ ] Current context saturation: ___% (check Claude Code token counter)
- [ ] Saturation is between 30–38% → **proceed**
- [ ] Saturation is >40% → **STOP — approaching sigmoid collapse cliff (43.2%). Execute State Freeze: FAILURE_LEDGER → HANDOVER.md → /clear**
- [ ] Pre-compact hook has run → snapshot saved to `.claude/snapshots/`

---

## Preserve Directives
<!--
  FILL: List everything the compaction summary MUST retain.
  Be explicit — the model will omit anything not listed.
  Paste this list into the /compact command after "preserve:".
-->

### Compression Priority Order (execute in sequence)
Compress in this order — highest token yield first:
1. **Raw tool outputs** (bash stdout, grep results, file read dumps) — evict immediately
   after insight is absorbed; these are ~80% of context bloat
2. **Repeated exploratory reads** — collapse to conclusion only; discard the raw content
3. **Superseded reasoning traces** — paths that were evaluated and abandoned
4. **PRESERVE INTACT:** architectural decisions, active file paths with line numbers,
   exact error messages, unresolved blockers

### Architecture & Schema
- [ ] <!-- FILL: e.g. "the updated UserAuth struct schema with session_token field" -->
- [ ] <!-- FILL: e.g. "the database migration sequence for the payments table" -->

### Active File Paths
- [ ] <!-- FILL: e.g. "src/auth/token-vault.ts — currently being refactored" -->
- [ ] <!-- FILL: e.g. "api/routes/checkout.ts — has uncommitted changes" -->

### Decisions (must survive compaction)
- [ ] <!-- FILL: e.g. "Decision to use PKCE over implicit flow — do not revisit" -->
- [ ] <!-- FILL: e.g. "Rejected passport.js — incompatible with session store" -->

### Active Blockers
- [ ] <!-- FILL: e.g. "TokenVault.rotate() has unresolved race condition — see line 142" -->

### Current Task State
- [ ] <!-- FILL: e.g. "Step 3 of 5 in auth refactor — middleware done, routes pending" -->

---

## /compact Command (copy-paste ready)
<!--
  FILL: Assemble the command from the directives above.
  Format: /compact preserve: [comma-separated list of directives]
-->

```
/compact preserve: [
  FILL from directives above
]
```

---

## Post-Compaction Verification
<!--
  After /compact completes, verify the generated summary contains each item.
  A missing item = compaction failed to preserve it → manually re-inject into next message.
-->

- [ ] Architecture changes present in summary
- [ ] All active file paths mentioned
- [ ] Decisions and rejected paths retained
- [ ] Active blockers listed
- [ ] Current task step is accurate
- [ ] Summary does NOT contain hallucinated details (verify against actual state)

### If summary is inaccurate:
Re-inject missing context manually in the next user message:
```
[POST-COMPACT CORRECTION] The following was omitted from the summary:
- <item 1>
- <item 2>
Treat this as ground truth.
```

---
_Template: .claude/templates/COMPACTION.md_
_Pair with: .claude/hooks/pre-compact.sh (runs automatically before compaction)_
