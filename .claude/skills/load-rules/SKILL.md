# Skill: Load Rules (DEPRECATED)
> **DEPRECATED (Phase 1):** Manual rule-loading superseded by native path-scoped injection. This skill is preserved for historical reference only. See `.claude/DEPRECATED.md`.

<!-- APERTURE-CLEAN Skill | Manual Loader -->

Use this skill whenever you transition to a new domain or directory. This mitigates the lack of automatic path-based rule injection in Claude Code.

## Operational Workflow

### Step 1: Path Analysis
- Check your current working directory and the files targeted by the task.
- Match the path against the **Domain Skills Index** in `CLAUDE.md`.

### Step 2: Rule Loading
- Load the corresponding rule file from `.claude/rules/` (e.g., if working in `/api`, load `api.md`).
- Apply all constraints and invariants defined in that rule file to the current session.

### Step 3: Context Caching
- Summarize the loaded rules.
- Cache the active rule summary in the `TodoWrite` tool (if available) or the session scratchpad to ensure persistence across tool calls.

## Success Criteria
- Domain rules are active and governing all edits.
- Context is optimized by loading only necessary rules for the current path.
