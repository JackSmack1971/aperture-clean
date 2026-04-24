# STATE-FREEZE.md — State Freeze Protocol
<!--
  Research basis: "State Freezing" — antidote to Miller's Law in LLMs.
  Returns 100% of the token budget while preserving all non-redundant epistemic content.
  Distinct from /compact: /compact summarizes in place.
  State Freeze: extract → destroy → reinitialize with minimal pristine state.

  TRIGGER CONDITIONS (use instead of /compact when):
  - Context saturation approaching 40% on a DEBUGGING task (fast accumulation)
  - Agent has entered reasoning loops (re-examining already-resolved questions)
  - Multiple abandoned paths have accumulated (>3 dead ends in active context)
  - Next task is fundamentally different domain from current work
-->

## Step 1 — Extract Failure Patterns to FAILURE_LEDGER.md
Before clearing anything, extract all failed approaches to the persistent ledger.
For each dead end encountered this session:

echo "[$(date +%Y-%m-%d)] [SYSTEMIC/TRANSIENT] [domain] [approach] → [reason failed]" >> FAILURE_LEDGER.md

Do NOT summarize. One line per failure, exact format.

## Step 2 — Write Minimal HANDOVER.md
Populate ONLY the Machine State JSON block and Next Step. Skip all prose sections.
```json
{
  "session_id": "[YYYY-MM-DD-HH-MM]",
  "phase": "[current task phase]",
  "context_pct_at_freeze": "[current %]",
  "modified_files": ["file1", "file2"],
  "active_blockers": 1,
  "next_step": "[exact imperative: verb + target + constraint]"
}
```

The next_step field is the resume command. It must be copy-paste executable.

## Step 3 — Execute Hard Clear

    /clear

This destroys ALL context. There is no undo. Verify FAILURE_LEDGER.md and HANDOVER.mdare on disk before executing.

## Step 4 — Reinitialize with Minimal State

Fresh session receives ONLY:

* System prompt (CLAUDE.md — always loaded)
* HANDOVER.md (Machine State JSON)
* The correct MVCS template for the resuming task class
* **NOTHING ELSE**

Resume command (copy from Machine State JSON next_step field):

    Read HANDOVER.md Machine State JSON. Task: [next_step value].
    Load MVCS template: .claude/templates/MVCS-[SYNTHESIS|DEBUGGING|REFACTOR].md.
    Do NOT read session history. Begin from next_step only.

## Step 5 — Confirm Pristine State

* [ ] Token counter shows <5% saturation (fresh session)
* [ ] FAILURE_LEDGER.md updated with this session's failures
* [ ] HANDOVER.md on disk with valid Machine State JSON
* [ ] MVCS template loaded (token budget visible)
* [ ] No references to prior session's file reads or reasoning traces

## When to Use State Freeze vs /compact

| Condition | Use |
| --- | --- |
| At 38% saturation, clear context needed | `/compact` |
| Dead ends accumulated (>3 abandoned paths) | State Freeze |
| Domain switch required | State Freeze |
| Debugging task at 30% with large stack traces | State Freeze |
| Session has been running >2 hours | State Freeze |
