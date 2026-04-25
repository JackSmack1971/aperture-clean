#!/usr/bin/env bash
# .claude/hooks/pre-tool-use.sh
# Debug hook to capture input
echo "--- HOOK FIRED ---" >> hook_debug.log
cat >> hook_debug.log
exit 0
