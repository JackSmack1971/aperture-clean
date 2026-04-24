# /audit-framework — Full Framework Health Check
<!-- Workflow: triggered via /audit-framework in Antigravity agent chat -->
<!-- Run before any PR, release tag, or when something feels broken -->

## When to Use
- Before cutting a release or version tag
- After a large batch of changes across multiple files
- When the bootstrap script produces unexpected behavior
- When a user reports that a rule file isn't loading correctly

## Execution Steps

### Phase 1 — Line Count Audit
```bash
echo "=== CLAUDE.md line count ==="
wc -l CLAUDE.md
echo "Must be ≤100"

echo ""
echo "=== Rule file line counts ==="
wc -l .claude/rules/*.md | sort -n
echo "All must be ≤55. Flag any over 50 for review."

echo ""
echo "=== Template file line counts ==="
wc -l .claude/templates/*.md | sort -n
```
**PASS criteria**: CLAUDE.md ≤100 lines. All rule files ≤55 lines.

### Phase 2 — Schema Compliance Spot Check
For each rule file, verify presence of required sections:
```bash
for f in .claude/rules/*.md; do
  echo "--- $f ---"
  grep -c "## Context Engineering Notes" "$f" | \
    awk '{print ($1==1)?"✓ Context Engineering Notes":"✗ MISSING Context Engineering Notes"}'
  grep -c "## Populated By" "$f" | \
    awk '{print ($1==1)?"✓ Populated By":"✗ MISSING Populated By"}'
  grep -c "Cache-compatible" "$f" | \
    awk '{print ($1>=1)?"✓ Cache-compatible":"✗ MISSING Cache-compatible declaration"}'
done
```
**PASS criteria**: All three checks return ✓ for every rule file.

### Phase 3 — Static Content Verification
```bash
# Check for dynamic content that would break caching
echo "=== Scanning for dynamic content violations ==="
grep -rn "$(date" .claude/rules/ && echo "FAIL: timestamp found" || echo "✓ No timestamps"
grep -rn "\$(" .claude/rules/ && echo "FAIL: shell substitution found" || echo "✓ No shell substitution"
grep -rn "{{.*}}" .claude/rules/ | grep -v "SECRET_NAME\|SERVICE_API_KEY\|TOKEN" \
  && echo "WARN: check placeholder syntax" || echo "✓ Placeholder syntax valid"
```

### Phase 4 — Framework Sync Verification
```bash
echo "=== Live vs framework source diff ==="
diff -rq .claude/ scripts/framework/.claude/
diff CLAUDE.md scripts/framework/CLAUDE.md
diff .claudeignore scripts/framework/.claudeignore
echo "(empty output = in sync)"
```
**PASS criteria**: All diffs return empty.

### Phase 5 — Bootstrap Dry-Run
<!-- Note: compaction threshold is task-class-dependent (SYNTHESIS:40, DEBUG:30, REFACTOR:35) -->
<!-- Default/universal safety margin: 38% (sigmoid collapse cliff: 43.2%) -->
```bash
bash scripts/bootstrap-claude-framework.sh --dry-run --quiet
echo "Exit code: $?"
```
**PASS criteria**: Exit code 0, Phase 6 integrity check passes.

### Phase 6 — CLAUDE.md Pointer Completeness
```bash
echo "=== Rule files in .claude/rules/ ==="
ls .claude/rules/*.md | sed 's|.claude/rules/||'

echo ""
echo "=== Rules listed in CLAUDE.md ==="
grep "\.claude/rules/" CLAUDE.md
```
Manually verify every file in `ls` output has a corresponding entry in CLAUDE.md.
**PASS criteria**: No rule file is undocumented in CLAUDE.md.

### Phase 7 — Open TODO Inventory
```bash
echo "=== Open TODO items across all rule files ==="
grep -rn '\[ \] TODO' .claude/rules/ | wc -l
echo "total open items"
grep -rn '\[ \] TODO' .claude/rules/ | head -20
```
This is informational — open TODOs are expected in placeholder files.
Flag if count is 0 (may indicate TODOs were incorrectly filled with placeholder text).

### Phase 8 — Pointer Target Validation
```bash
echo "=== Checking pointer doc targets exist ==="
MISSING=0
grep -rh "Pointer:" .claude/rules/ | grep -o '\`[^\`]*\`' | sed 's/\`//g' | while read f; do
  if [ -f "$f" ]; then
    echo "  ✓ $f"
  else
    echo "  ✗ MISSING: $f"
    MISSING=$((MISSING + 1))
  fi
done
echo ""
echo "Rule files with zero pointer targets (self-contained, no pointer docs):"
grep -rL "Pointer:" .claude/rules/ | sed 's|.claude/rules/||'
```
**PASS criteria**: All pointer targets exist on disk.
**WARN criteria**: Rule files with zero Pointer: entries — flag for review.
A rule file without pointer targets is self-contained but may lack semantic tissue
for complex domains. Not a failure, but a quality signal.

### Phase 9 — Anchor Density Scoring (ADS)
```bash
echo "=== Phase 9: Anchor Density Scoring ==="
echo "Grounding: RoPE attention sinks — structured anchors produce <1.5 bits entropy"
echo "vs >4.0 bits for plain prose. Score = (anchors per 50 tokens) * 10, max 100."
echo ""
for f in .claude/rules/*.md; do
  fname=$(basename $f)
  words=$(wc -w < "$f")
  tokens=$(echo "$words * 3 / 4" | bc)
  units=$(echo "$tokens / 50" | bc)
  [ "$units" -eq 0 ] && units=1
  bold=$(grep -o '\*\*' "$f" | wc -l)
  bold=$((bold / 2))
  directives=$(grep -cE '\b(NEVER|ALWAYS|EXTRACT|VERIFY|PROHIBIT|ENFORCE|REQUIRE)\b' "$f" 2>/dev/null || echo 0)
  numbered=$(grep -cE '^[0-9]+\.' "$f" 2>/dev/null || echo 0)
  codeblocks=$(grep -c '```' "$f" 2>/dev/null || echo 0)
  pointers=$(grep -c '- Pointer:' "$f" 2>/dev/null || echo 0)
  total=$((bold + directives + numbered + codeblocks + pointers))
  score=$(echo "$total * 10 / $units" | bc)
  [ "$score" -gt 100 ] && score=100
  if [ "$score" -ge 70 ]; then
    rating="HIGH ✓"
  elif [ "$score" -ge 50 ]; then
    rating="MEDIUM ⚠"
  else
    rating="LOW ✗ — add structural anchors (bold directives, numbered steps, NEVER blocks)"
  fi
  echo "  $fname: $score/100 — $rating"
done
```
**PASS**: All rule files score ≥50 (MEDIUM or above)
**WARN**: Any file scoring <50 — specific improvement guidance printed inline
**TARGET**: All files ≥70 (HIGH) for maximum attention capture

### Phase 10 — Aperture Score
```bash
echo "=== Phase 10: Aperture Score ==="
echo "Composite metric: AS = 0.25*SIS + 0.35*SDS + 0.25*MCS + 0.15*LHS"
echo ""

# SIS — Structural Integrity Score (average ADS from Phase 9)
total_ads=0; count=0
for f in .claude/rules/*.md; do
  words=$(wc -w < "$f"); tokens=$((words * 3 / 4)); units=$((tokens / 50))
  [ "$units" -eq 0 ] && units=1
  bold=$(grep -o '\*\*' "$f" | wc -l); bold=$((bold / 2))
  directives=$(grep -cE '\b(NEVER|ALWAYS|EXTRACT|VERIFY|PROHIBIT|ENFORCE)\b' "$f" 2>/dev/null || echo 0)
  numbered=$(grep -cE '^[0-9]+\.' "$f" 2>/dev/null || echo 0)
  codeblocks=$(grep -c '```' "$f" 2>/dev/null || echo 0)
  pointers=$(grep -c '- Pointer:' "$f" 2>/dev/null || echo 0)
  anchors=$((bold + directives + numbered + codeblocks + pointers))
  score=$((anchors * 10 / units)); [ "$score" -gt 100 ] && score=100
  total_ads=$((total_ads + score)); count=$((count + 1))
done
SIS=$((total_ads / count))
echo "  SIS (Structural Integrity): $SIS/100"

# LHS — Ledger Health Score
if [ -f "FAILURE_LEDGER.md" ]; then
  systemic=$(grep -c '\[SYSTEMIC\]' FAILURE_LEDGER.md 2>/dev/null || echo 0)
  total_entries=$(grep -cE '^\[20[0-9]{2}' FAILURE_LEDGER.md 2>/dev/null || echo 0)
  if [ "$total_entries" -gt 0 ]; then
    LHS=$((systemic * 100 / total_entries))
  else
    LHS=100
    echo "  LHS: 100 (ledger empty — no failures recorded yet)"
  fi
else
  LHS=0
  echo "  LHS: 0 (FAILURE_LEDGER.md not found at project root)"
fi
echo "  LHS (Ledger Health): $LHS/100"

# SDS — placeholder (requires session telemetry, available in v2.0.2)
SDS=0
echo "  SDS (Saturation Discipline): PENDING — requires session telemetry (v2.0.2)"

# MCS — placeholder (requires HANDOVER.md session tracking, available v2.0.2)
MCS=0
echo "  MCS (MVCS Compliance): PENDING — requires session tracking (v2.0.2)"

# Composite (weighted for available components)
AS=$(( (SIS * 25 + LHS * 15) / 40 ))
echo ""
echo "  Aperture Score (partial — SDS/MCS pending): $AS/100"
echo "  Full score formula (when complete): 0.25*SIS + 0.35*SDS + 0.25*MCS + 0.15*LHS"

# Persist to snapshots
mkdir -p .claude/snapshots
DATE=$(date +%Y-%m-%d)
echo "{\"date\":\"$DATE\",\"SIS\":$SIS,\"LHS\":$LHS,\"SDS\":\"pending\",\"MCS\":\"pending\",\"partial_AS\":$AS}" \
  >> .claude/snapshots/aperture-scores.jsonl
echo "  Score persisted to .claude/snapshots/aperture-scores.jsonl"
```
**Interpret:** AS >70 = well-governed | 50-70 = improving | <50 = needs attention


## Audit Report Summary

After all phases, output:

```
APERTURE FRAMEWORK AUDIT — [date]
─────────────────────────────────
Phase 1 Line Count:    [PASS/FAIL] — CLAUDE.md: X lines | Max rule file: X lines
Phase 2 Schema:        [PASS/FAIL] — [N]/13 rule files fully compliant
Phase 3 Static:        [PASS/FAIL] — Dynamic content: [none/list issues]
Phase 4 Sync:          [PASS/FAIL] — Framework source: [in sync/N files diverged]
Phase 5 Bootstrap:     [PASS/FAIL] — Exit code: [0/1]
Phase 6 CLAUDE.md:     [PASS/FAIL] — [N]/13 rules documented
Phase 7 TODOs:         [INFO]      — [N] open items across rule files
Phase 8 Pointers:      [PASS/WARN] — [N] missing pointer targets | [N] self-contained rules
Phase 9 ADS:           [PASS/WARN] — lowest scoring file: [name] [score]/100
Phase 10 Aperture Score: [score]/100 (partial) — SIS: [x] | LHS: [x] | SDS: pending


Overall: [PASS — ready for release / FAIL — address issues above]
```
