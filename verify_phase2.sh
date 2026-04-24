#!/usr/bin/env bash
echo "=== PHASE 2 VERIFICATION ==="
DOMAIN_SKILLS=(
  "api-rules" "db-rules" "security-rules" "ci-rules"
  "config-rules" "dependencies-rules" "docs-rules"
  "frontend-rules" "infra-rules" "logging-rules"
  "migrations-rules" "monitoring-rules" "testing-rules"
)
OPERATIONAL_SKILLS=(
  "pre-compact" "state-freeze" "mvcs-debugging" 
  "mvcs-synthesis" "mvcs-refactor"
)

PASS=0; FAIL=0
for skill in "${DOMAIN_SKILLS[@]}" "${OPERATIONAL_SKILLS[@]}"; do
  if [ -f ".claude/skills/$skill/SKILL.md" ]; then
    echo "  ✅ $skill/SKILL.md"
    ((PASS++))
  else
    echo "  ❌ $skill/SKILL.md MISSING"
    ((FAIL++))
  fi
done

echo ""
echo "Phase 2: $PASS/18 skills present"
[ "$FAIL" -eq 0 ] && echo "🟢 PHASE 2 COMPLETE" || echo "🔴 INCOMPLETE"
