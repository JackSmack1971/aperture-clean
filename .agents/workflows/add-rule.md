# /add-rule — Add New Domain Rule File
<!-- Workflow: triggered via /add-rule in Antigravity agent chat -->
<!-- Atomic: schema validation + line count + sync + all update steps in one pass -->

## When to Use
Trigger this workflow when a new project domain needs a path-scoped rule file that
does not yet exist in `.claude/rules/`. Do NOT use for editing existing rule files.

## Required Inputs (provide before running)
```
Domain name:        [e.g. "workers", "graphql", "i18n"]
Injection trigger:  [e.g. "/workers/**", "*.graphql", "/locales/**"]
Primary token threat: [what file/pattern would cause the biggest token damage]
Responsible role:   [e.g. "Backend lead / queue engineer"]
```

## Execution Steps

### Step 1 — Draft the rule file
Create `.claude/rules/[domain].md` using EXACTLY this schema:

```markdown
# [Domain] Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under [trigger] -->
<!-- Static content only. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## [Primary Section]
- Pointer: `docs/[domain]-policy.md` — [description]
- [ ] TODO: [first decision point]
- [ ] TODO: [second decision point]
- **NEVER** [primary security invariant for this domain]

## [Secondary Section]
- [ ] TODO: [decision]
- [ ] TODO: [decision]

## [Optional Third Section]
- [ ] TODO: [decision]

## Forbidden Patterns
- [ ] TODO: No [pattern] — [reason]
- [ ] TODO: No [pattern] — [reason]

## Context Engineering Notes
- Do NOT read [high-token file pattern] — [token cost reason]
- Do NOT dump [large directory] — [reason]
- [Heavy read operation] → subagent; return [compressed output] only

## Populated By
- [Role] on project onboarding
- Last reviewed: [ TODO: date ]
```

### Step 2 — Validate line count
```bash
wc -l .claude/rules/[domain].md
# Must be ≤50. If over: cut, do not pad with empty lines.
```

### Step 2.5 — ADS Lint Check (attention quality gate)
```bash
# Run ADS scoring on the new rule file
f=".claude/rules/[domain].md"
words=$(wc -w < "$f"); tokens=$((words * 3 / 4)); units=$((tokens / 50))
[ "$units" -eq 0 ] && units=1
bold=$(grep -o '\*\*' "$f" | wc -l); bold=$((bold / 2))
directives=$(grep -cE '\b(NEVER|ALWAYS|EXTRACT|VERIFY|PROHIBIT|ENFORCE)\b' "$f" 2>/dev/null || echo 0)
numbered=$(grep -cE '^[0-9]+\.' "$f" 2>/dev/null || echo 0)
codeblocks=$(grep -c '```' "$f" 2>/dev/null || echo 0)
pointers=$(grep -c '- Pointer:' "$f" 2>/dev/null || echo 0)
total=$((bold + directives + numbered + codeblocks + pointers))
score=$((total * 10 / units)); [ "$score" -gt 100 ] && score=100
echo "ADS Score: $score/100"
```
**If score <50: DO NOT PROCEED.** Return to the draft and add structural anchors:
- Replace "you should avoid" → "**NEVER** [action]" (NEVER + bold = attention sink)
- Replace prose instructions → numbered list (numbered items = attention anchors)
- Add `- Pointer:` lines for each deep-detail reference
- Replace ambiguous guidance → imperative verbs (EXTRACT, VERIFY, ENFORCE)
- Re-run ADS until score ≥50 before continuing

### Step 3 — Verify schema compliance
Run through contribution-protocol.md validation checklist.
All boxes must check before proceeding.

### Step 4 — Update CLAUDE.md path-scoped rules table
Add one line to the path-scoped rules table in `CLAUDE.md`:
```
- `[trigger path]` → `.claude/rules/[domain].md`
```
Verify CLAUDE.md remains ≤100 lines after addition: `wc -l CLAUDE.md`

### Step 5 — Mirror to framework source
```bash
cp .claude/rules/[domain].md scripts/framework/.claude/rules/[domain].md
diff .claude/rules/[domain].md scripts/framework/.claude/rules/[domain].md
# Diff must be empty
```

### Step 6 — Update README.md domain rules table
Add one row to the Domain Rules Reference table:
```markdown
| `[domain].md` | `[trigger]` | [primary token threat description] |
```

### Step 7 — Update README.md framework architecture tree
Add the new file to the annotated directory tree under `## Framework Architecture`.

### Step 8 — Commit
```bash
git add .claude/rules/[domain].md scripts/framework/.claude/rules/[domain].md \
        CLAUDE.md README.md
git commit -m "feat: add [domain].md rule file for [trigger path]"
```

## Completion Criteria
- [ ] New rule file exists at `.claude/rules/[domain].md`
- [ ] Line count ≤50
- [ ] ADS score ≥50 confirmed via Step 2.5 lint check
- [ ] Schema validation checklist complete
- [ ] CLAUDE.md updated and still ≤100 lines
- [ ] Mirror exists at `scripts/framework/.claude/rules/[domain].md`
- [ ] `diff` between live and mirror is empty
- [ ] README.md domain rules table has new row
- [ ] README.md architecture tree has new entry
- [ ] Commit is clean with correct message format
