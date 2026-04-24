#!/usr/bin/env bash
# APERTURE-CLEAN pre-compact.sh
# Extracts state before /compact to prevent context rot.

echo "### APERTURE STATE EXTRACTION"

# 1. Open TODOs
echo "--- OPEN TODOS ---"
grep -rn "\[ \] TODO" . --exclude-dir=.git --exclude-dir=.claude | head -n 10 || echo "None found."

# 2. Modified Files
echo "--- MODIFIED FILES ---"
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  git status -s
else
  echo "Not a git repository."
fi

# 3. Active Context Summary
echo "--- ACTIVE CONTEXT ---"
echo "Working Directory: $(pwd)"

# 4. Generate Compaction Command
echo ""
PRESERVE="architectural decisions, active file paths, blockers"
echo "/compact preserve: [$PRESERVE]"
