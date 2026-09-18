<!-- APERTURE-CLEAN SUBAGENT CONTRACT v1.0 | Return payload: bounded JSON ONLY -->

## Scope
[single, focused objective — one sentence]

## Authorized Tools
[explicit tool whitelist — names only, comma-separated]

## Return Contract
<!-- assert NOT return_format(Markdown) -->
<!-- assert NOT return_format(Summary) -->
<!-- assert return_format(bounded_JSON) — bounded JSON is easier to parse deterministically than prose; specific speed-gain figures are unverified for this repo -->

**Format:** Bounded JSON schema ONLY.
**Token Limit:** ≤500 tokens total payload.

```json
{
  "schema": "subagent_return_v1",
  "max_tokens": 500,
  "required_fields": {
    "findings": "array | each item: {file: string, issue: string, severity: high|medium|low}",
    "recommendation": "string | max 2 sentences | actionable",
    "blocked": "boolean | true if scope boundary hit before completion"
  },
  "status": "SUCCESS | PARTIAL | FAILED",
  "modified_files": [],
  "errors": [],
  "next_required_action": "",
  "token_count_estimate": 0,
  "schema_version": "SA-v1.0"
}
```

RESTRICTED: return_format NOT matching schema above

## Constraints
<!-- assert NOT read(env_files) -->
<!-- assert NOT write(FAILURE_LEDGER) WITHOUT confirmed_tool_error -->
**Rule Check:** domain rules load automatically on Read of a matching file (`paths:` frontmatter) —
do not manually read them first. Exception: creating the first file in an untouched domain
does not trigger loading; Read a sibling file or the rule file itself before that Write.
**Failure Logging:** On any non-zero exit or permission denial, append to `FAILURE_LEDGER.md`.
**Boundaries:** [prohibited actions — specific to delegation scope]

## Execution Model Routing
<!-- Per subagent: `model:` in .claude/agents/<name>.md (none defined yet). Haiku: classification, log extraction | Sonnet: multi-file reads, patches | Opus: security/architecture review -->
<!-- Descriptions inform delegation: keep terse. Parent+child+return cost is unmeasured (RT-7) -->

## Clean-Slate Retry (RT-6, unvalidated; contextual drag)
IF the same error persists after 2 failed attempts (default): RESTRICTED: a further attempt in the polluted context.
REQUIRED: delegate to a fresh subagent given ONLY goal, constraints, exact error text, file:line pointers.
RESTRICTED: pass prior failed drafts or reasoning to it. Log the signature to FAILURE_LEDGER.md (signature + lesson only).
