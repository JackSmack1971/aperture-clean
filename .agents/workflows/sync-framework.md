# /sync-framework — Sync Framework Source Tree
<!-- Workflow: triggered via /sync-framework in Antigravity agent chat -->
<!-- Use after ANY modification to live .claude/ files or root framework files -->

## When to Use
Run this workflow after modifying any of the following live files:
- Any `.claude/rules/*.md`
- Any `.claude/templates/*.md`
- `.claude/hooks/pre-compact.sh`
- `.claude/settings.json`
- `CLAUDE.md`
- `.claudeignore`

The `scripts/framework/` directory is the versioned source copy used by the bootstrap
installer. If it drifts from the live files, users who run `bootstrap --force` will
receive stale content.

## Execution Steps

### Step 1 — Identify changed files
```bash
# Show all live framework files that differ from their mirror
diff -rq .claude/ scripts/framework/.claude/ 2>/dev/null
diff CLAUDE.md scripts/framework/CLAUDE.md 2>/dev/null
diff .claudeignore scripts/framework/.claudeignore 2>/dev/null
```
Note every file reported as different. Proceed only if the diff is intentional.

### Step 2 — Sync changed files
```bash
# Sync .claude/ subtree
rsync -av --delete .claude/ scripts/framework/.claude/

# Sync root files
cp CLAUDE.md scripts/framework/CLAUDE.md
cp .claudeignore scripts/framework/.claudeignore
```

### Step 3 — Verify sync is complete
```bash
diff -rq .claude/ scripts/framework/.claude/
diff CLAUDE.md scripts/framework/CLAUDE.md
diff .claudeignore scripts/framework/.claudeignore
# ALL diffs must return empty (no output)
```
If any diff is non-empty: stop, investigate, do not commit.

### Step 4 — Verify framework file count
```bash
find scripts/framework -type f | wc -l
# Expected: 20 (or current canonical count if files were added/removed)
```

### Step 5 — Run bootstrap dry-run validation
```bash
bash scripts/bootstrap-claude-framework.sh --dry-run
# Must complete Phase 6 integrity check with zero FAIL results
```

### Step 6 — Commit sync
```bash
git add scripts/framework/
git commit -m "chore: sync scripts/framework/ with live rule files"
```

## Emergency: Framework Source and Live Files Are Diverged
If you discover the trees have drifted and you're unsure which is canonical:
1. **Live files are always canonical** — `scripts/framework/` is the mirror, not the source
2. Inspect git log to understand when each file was last modified
3. Manually reconcile diff by diff — do not bulk overwrite without review
4. Run bootstrap dry-run after reconciliation
5. Get human review before committing a large divergence fix

## Completion Criteria
- [ ] All diffs between live files and `scripts/framework/` return empty
- [ ] Framework file count matches expected total
- [ ] Bootstrap dry-run passes Phase 6 integrity check with zero failures
- [ ] Sync commit is clean with correct message format
