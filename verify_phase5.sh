#!/usr/bin/env bash
echo "=== PHASE 5 VERIFICATION ==="

# Check existence
[ -f "docs/setup.md" ] && echo "✅ docs/setup.md" || echo "❌ docs/setup.md MISSING"
[ -f ".claude/QUICK-REF.md" ] && echo "✅ QUICK-REF.md" || echo "❌ QUICK-REF.md MISSING"

# Line count for QUICK-REF
if [ -f ".claude/QUICK-REF.md" ]; then
  LINES=$(wc -l < .claude/QUICK-REF.md)
  echo "QUICK-REF.md: $LINES lines (target: ≤50)"
  [ "$LINES" -le 50 ] && echo "✅ Fits on one page" || echo "⚠️ May need trimming"
fi

echo ""
[ -f "docs/setup.md" ] && [ -f ".claude/QUICK-REF.md" ] \
  && echo "🟢 PHASE 5 COMPLETE" \
  || echo "🔴 INCOMPLETE"
