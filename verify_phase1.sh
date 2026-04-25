#!/usr/bin/env bash
echo "=== PHASE 1 VERIFICATION ==="
REQUIRED_FILES=(
  "CLAUDE.md"
  ".claudeignore"
  "FAILURE_LEDGER.md"
  ".claude/settings.json"
  ".claude/hooks/hooks.json"
  ".claude/snapshots/.gitkeep"
)

PASS=0; FAIL=0
for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$f" ] || [ -d "${f%/*}" ]; then
    echo "  ✅ $f"
    ((PASS++))
  else
    echo "  ❌ $f MISSING"
    ((FAIL++))
  fi
done

echo ""
echo "Phase 1: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "🟢 PHASE 1 COMPLETE" || echo "🔴 INCOMPLETE"

# Line count check
LINE_COUNT=$(wc -l < CLAUDE.md)
echo "CLAUDE.md: $LINE_COUNT lines (limit: 100)"
[ "$LINE_COUNT" -le 100 ] && echo "✅ Compliant" || echo "❌ EXCEEDS LIMIT"
