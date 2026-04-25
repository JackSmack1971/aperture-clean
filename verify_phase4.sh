#!/usr/bin/env bash
echo "=== PHASE 4 VERIFICATION ==="
TEMPLATES=(
  ".claude/templates/HANDOVER.md"
  ".claude/templates/FAILURE_LEDGER.md"
  ".claude/templates/SUBAGENT.md"
  ".claude/templates/COMPACTION.md"
)

PASS=0; FAIL=0
for template in "${TEMPLATES[@]}"; do
  if [ -f "$template" ]; then
    echo "  ✅ $template"
    ((PASS++))
  else
    echo "  ❌ $template MISSING"
    ((FAIL++))
  fi
done

echo ""
echo "Phase 4: $PASS/4 templates present"
[ "$FAIL" -eq 0 ] && echo "🟢 PHASE 4 COMPLETE" || echo "🔴 INCOMPLETE"
