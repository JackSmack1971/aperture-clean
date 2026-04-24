# Contribution Protocol — Aperture Framework
<!-- Injected when agent creates or modifies any .claude/ framework file -->

## Rule File Schema (MANDATORY — all 13 must conform)
Every `.claude/rules/*.md` file must contain exactly these sections in this order:

```
# [Domain] Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /[path] -->
<!-- Static content only. [Optional: CRITICAL note]. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## [Section 1]
## [Section 2]
## [Section 3 — optional]
## [Section 4 — optional]

## Context Engineering Notes
- Token-saving directives specific to this domain
- Do NOT [read/dump/ingest] [specific pattern] — [reason]
- [Heavy operation] → subagent only; return [compressed output] to orchestrator

## Populated By
- [Role] on project onboarding
- Last reviewed: [ TODO: date ]
```

**Validation checklist before committing a new rule file:**
- [ ] Header comment block present with correct injection trigger path
- [ ] `Static content only` assertion in header
- [ ] `Cache-compatible` declaration in header
- [ ] Line target stated (≤50 or ≤55)
- [ ] At least one `- Pointer:` reference per section
- [ ] `[ ] TODO:` items for all human-completion slots
- [ ] `**NEVER**` directives bold-formatted for all hard stops
- [ ] `## Context Engineering Notes` section present
- [ ] `## Populated By` footer present
- [ ] Actual line count verified: `wc -l .claude/rules/[filename].md`
- [ ] File added to CLAUDE.md path-scoped rules table
- [ ] File mirrored to `scripts/framework/.claude/rules/[filename].md`
- [ ] README.md domain rules table updated
- [ ] KERNEL audit passed: K=short (no filler prose), E=explicit imperative verbs,
      R=critical rules repeated where needed, N=numbered where sequential,
      L=scope limited to this domain only — no cross-domain leakage
- [ ] ADS score ≥50: run Phase 9 of `/audit-framework` on the new file;
      score <50 means insufficient structural anchors for reliable attention capture;
      add **NEVER** directives, numbered steps, or explicit Pointer: lines to raise score


## Adding a New Rule File — Use `/add-rule` Workflow
Do not manually create rule files. Use the workflow: `.agent/workflows/add-rule.md`
The workflow enforces the schema, line count, and sync steps atomically.

## Modifying Existing Rule Files
Permitted changes (no approval needed):
- Filling `[ ] TODO:` items with correct values
- Adding new `- Pointer:` references
- Adding new `**NEVER**` directives
- Tightening `## Context Engineering Notes` directives

Changes requiring human approval before commit:
- Removing any existing `**NEVER**` directive
- Changing the injection trigger path in the header comment
- Adding sections beyond the schema
- Any change that increases line count beyond the stated target

## Bootstrap Script Modification Protocol
`scripts/bootstrap-claude-framework.sh` is critical infrastructure.
Before modifying:
1. Read the full script to understand all 6 phases
2. Run `--dry-run` to baseline the current behavior
3. Make the targeted change only — no opportunistic refactors
4. Run `--dry-run` again and diff the output
5. Test with `--force` on a clean temp directory
6. Get explicit human approval before merging

## Sync Protocol — Live Files ↔ scripts/framework/
After any change to a live framework file:
```bash
# Manual sync — or use /sync-framework workflow
cp .claude/rules/[file].md scripts/framework/.claude/rules/[file].md
# Then verify
diff .claude/rules/[file].md scripts/framework/.claude/rules/[file].md
```
The diff must return empty. Any delta = broken framework distribution.

## README.md Update Rules
- Token economics table: verify pricing against official Anthropic API docs before updating
- File count badges in header: update when files are added/removed
- Architecture tree: must match actual directory structure exactly
- Anti-patterns table: add entries only when empirically validated, not theoretical

## Commit Message Convention
```
feat: add [domain].md rule file for [trigger path]
fix: correct line count in [filename].md
docs: update README domain rules table
chore: sync scripts/framework/ with live rule files
refactor: tighten Context Engineering Notes in [filename].md
```
