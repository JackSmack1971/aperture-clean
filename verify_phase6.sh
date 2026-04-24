#!/usr/bin/env bash
echo "=== PHASE 6: COMPLETE FRAMEWORK VERIFICATION ==="
echo ""

# File count inventory
echo "## FILE INVENTORY"
echo "Root files: $(ls -1 CLAUDE.md .claudeignore FAILURE_LEDGER.md 2>/dev/null | wc -l)/3"
echo "Skill files: $(find .claude/skills -name 'SKILL.md' 2>/dev/null | wc -l)/18"
echo "Hook files: $(find .claude/hooks -type f 2>/dev/null | wc -l)/2"
echo "Templates: $(find .claude/templates -name '*.md' 2>/dev/null | wc -l)/4"
echo "Docs: $(ls -1 docs/setup.md .claude/QUICK-REF.md 2>/dev/null | wc -l)/2"
echo ""

# Line count audit
echo "## LINE COUNT AUDIT"
CLAUDE_LINES=$(wc -l < CLAUDE.md)
QUICKREF_LINES=$(wc -l < .claude/QUICK-REF.md)
echo "CLAUDE.md: $CLAUDE_LINES/100 lines $([ "$CLAUDE_LINES" -le 100 ] && echo '✅' || echo '❌')"
echo "QUICK-REF.md: $QUICKREF_LINES/50 lines $([ "$QUICKREF_LINES" -le 50 ] && echo '✅' || echo '⚠️')"
echo ""

# JSON validation
echo "## JSON VALIDATION"
jq . .claude/settings.json > /dev/null 2>&1 && echo "✅ settings.json" || echo "❌ settings.json"
jq . .claude/hooks/hooks.json > /dev/null 2>&1 && echo "✅ hooks.json" || echo "❌ hooks.json"
echo ""

# Executable permissions
echo "## EXECUTABLE PERMISSIONS"
[ -x .claude/hooks/pre-compact.sh ] && echo "✅ pre-compact.sh" || echo "❌ pre-compact.sh"
echo ""

# Framework size
echo "## FRAMEWORK SIZE"
du -sh .claude/ 2>/dev/null || echo "N/A"
echo ""

# Final status
TOTAL_FILES=$(find .claude -type f 2>/dev/null | wc -l)
echo "## FINAL STATUS"
echo "Total framework files: $TOTAL_FILES"
echo "Expected minimum: 24 (.claude files only)"
echo ""
[ "$TOTAL_FILES" -ge 24 ] && echo "🟢 FRAMEWORK DEPLOYMENT COMPLETE" || echo "🔴 INCOMPLETE DEPLOYMENT"
