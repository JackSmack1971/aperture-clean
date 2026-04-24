#!/usr/bin/env bash
echo "=== APERTURE PRE-FLIGHT CHECK ==="
echo "Working directory: $(pwd)"
echo "Git repo: $(git rev-parse --show-toplevel 2>/dev/null || echo 'NOT A GIT REPO - initialize with: git init')"
echo "Bash version: ${BASH_VERSION}"
echo "Required tools:"
for tool in git jq python3; do
  command -v $tool &>/dev/null && echo "  ✅ $tool" || echo "  ❌ $tool MISSING"
done
echo "Existing .claude/: $(ls -d .claude/ 2>/dev/null && echo 'EXISTS' || echo 'ABSENT — will create')"
echo "=== PRE-FLIGHT COMPLETE ==="
