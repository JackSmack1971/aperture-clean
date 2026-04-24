# SUBAGENT.md — Subagent Briefing Template
<!--
  INSTRUCTIONS FOR ORCHESTRATOR:
  Copy this template when spawning an isolated subagent for a read-heavy task.
  Fill all sections. The subagent operates in a FRESH context — assume zero shared memory.
  Enforce the return contract strictly. Raw output NEVER returns to orchestrator context.
  Token law: subagent reads everything; orchestrator receives compressed summary only.
-->

## Mission
<!--
  FILL: Single, tightly scoped objective. One task per subagent.
  If the task has two independent parts → spawn two subagents.
  Format: imperative verb + target + acceptance criterion
  Example: "Analyze the /api/middleware/ directory and identify all functions
            that access req.headers directly, returning a function-name list only."
-->

**Objective:**

**Scope boundary:** Only read files under `<!-- FILL: path -->`. 

Do not navigate outside this boundary.

**Time/token budget:** Complete within a single focused pass. Do not iterate speculatively.

---

## Context (What Orchestrator Knows)
<!--
  FILL: Minimal background. Only what the subagent cannot derive itself.
  Do NOT paste large file contents here — defeat the purpose of isolation.
  Provide: relevant module names, the architectural question being answered, any known constraints.
-->

-

**Payload target:** 500–2,000 tokens total (this briefing + injected domain context).
Under 500 = insufficient relational context for complex reasoning.
Over 2,000 = orchestrator overhead zone; split into two subagents instead.

---

## Tools Authorized
<!--
  FILL: Explicitly list permitted tool calls. Unlisted tools = not authorized.
  Principle of least privilege — only what the task requires.
-->

- [ ] `read` — read files within scoped path
- [ ] `grep` — pattern search within scoped path
- [ ] `glob` — file discovery within scoped path
- [ ] `bash` — ONLY if required: <!-- FILL: specify exact commands permitted -->
- [ ] `write` — ONLY if task requires output file: <!-- FILL: target path -->

**PROHIBITED:** Do not call `web_search`, read `.env` files, or access paths outside scope boundary.

---

## Return Contract (STRICTLY ENFORCED)
<!--
  FILL: Define the exact format and maximum size of the return payload.
  The orchestrator's context window is precious. Enforce compression.
  Raw file contents, full stack traces, and verbose output are NEVER valid return formats.
-->

**Return format:**
```
<!-- CHOOSE ONE and delete the rest: -->

<!-- Option A: Structured list -->
Return a markdown list. Max 20 items. Each item: `<file>:<line> — <finding>`.

<!-- Option B: Decision answer -->
Return a single sentence: "[YES/NO] — <one-sentence rationale>."

<!-- Option C: Compressed summary -->
Return a max 10-line summary covering: [what was found], [files affected], [recommended action].

<!-- Option D: JSON payload -->
Return only valid JSON matching this schema:
{
  "findings": [{ "file": "", "issue": "", "severity": "high|medium|low" }],
  "recommendation": ""
}

<!-- Option E: Typed pseudo-function — use for highest-precision return cases
     where the orchestrator needs unambiguous programmatic parsing -->
```python
def return_findings() -> dict:
    """
    Typed return contract. Replace field names/types to match your task.
    findings: list[dict] — keys: file (str), issue (str), severity ("high"|"medium"|"low")
    recommendation: str — max 2 sentences, actionable
    confidence: "high" | "medium" | "low"
    blocked: bool — True if scope boundary was hit before task completed
    """
```
```

**Maximum return length:** <!-- FILL: e.g. 20 lines / 500 tokens -->

**Do NOT return:** raw file contents, full function bodies, verbose error logs, explanatory prose beyond the contract above.

---

## Failure Protocol
<!--
  If the task cannot be completed within scope:
  Return: "BLOCKED: <one-sentence reason>. Needs: <what the orchestrator must provide>."
  Do not expand scope. Do not make assumptions. Surface the blocker immediately.
-->

---
_Template: .claude/templates/SUBAGENT.md_
_Usage: Copy → fill → prepend to subagent initialization prompt_
