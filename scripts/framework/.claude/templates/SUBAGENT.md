<!-- APERTURE-CLEAN SUBAGENT CONTRACT v1.0 | Return payload: bounded JSON ONLY -->

## Scope
[single, focused objective — one sentence]

## Authorized Tools
[explicit tool whitelist — names only, comma-separated]

## Return Contract
<!-- assert NOT return_format(Markdown) -->
<!-- assert NOT return_format(Summary) -->
<!-- assert return_format(bounded_JSON) — 50% speed gain [VERIFIED: CWD doc] -->

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
**Rule Check:** Read domain rule in `.claude/rules/[domain].md` BEFORE any file edit.
**Failure Logging:** On any non-zero exit or permission denial, append to `FAILURE_LEDGER.md`.
**Boundaries:** [prohibited actions — specific to delegation scope]

## Execution Model Routing
<!-- Route to Haiku 4.5 for: binary classification, saturation check, log extraction -->
<!-- Route to Sonnet 4.6 for: multi-file reads, schema extraction, patch generation -->
<!-- Route to Opus 4.6 for: security invariant review, architectural decisions -->
