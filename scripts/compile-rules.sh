#!/usr/bin/env bash
# scripts/compile-rules.sh
# MVCS Compiler — transform rule files to model-optimized syntax
# Usage: ./scripts/compile-rules.sh [model]
# Models: claude (default) | gemini | universal
# Output: .claude/compiled/[model]/*.md

set -euo pipefail

MODEL="${1:-claude}"
SRC=".claude/rules"
DEST=".claude/compiled/${MODEL}"
COMPILED=0
WARNINGS=0

# Validate model
case "$MODEL" in
  claude|gemini|universal) ;;
  *)
    echo "ERROR: Unknown model '$MODEL'. Valid: claude, gemini, universal"
    exit 1 ;;
esac

mkdir -p "$DEST"
echo "=== Aperture Rule Compiler ==="
echo "Model:  $MODEL"
echo "Source: $SRC"
echo "Dest:   $DEST"
echo ""

# ────────────────────────────────────────────
# Claude transformations (production-ready)
# XML anchors, **BOLD**, numbered lists
# ────────────────────────────────────────────
compile_claude() {
  local src="$1" dest="$2"
  # Claude format IS the canonical format — copy verbatim
  cp "$src" "$dest"
}

# ────────────────────────────────────────────
# Gemini transformations (STUB — RT-1 pending)
# Hypothesis: ## headers, > blockquotes, : colon keys
# ────────────────────────────────────────────
compile_gemini() {
  local src="$1" dest="$2"
  echo "# GEMINI-COMPILED: $(basename $src)" > "$dest"
  echo "# WARNING: Gemini attention sink transforms are research stubs (RT-1 pending)" >> "$dest"
  echo "" >> "$dest"
  sed \
    -e 's/\*\*NEVER\*\*/> **NEVER**/g' \
    -e 's/^## /### /g' \
    -e 's/^# /## /g' \
    "$src" >> "$dest"
  echo "  STUB: $( basename $src ) — Gemini transforms pending RT-1 research"
  WARNINGS=$((WARNINGS + 1))
}

# ────────────────────────────────────────────
# Universal transformations (maximum density)
# Model-agnostic maximum structural anchoring
# ────────────────────────────────────────────
compile_universal() {
  local src="$1" dest="$2"
  sed \
    -e 's/^- \[ \] TODO:/- **TODO**:/g' \
    -e 's/^- Pointer:/- **→ POINTER**:/g' \
    "$src" > "$dest"
}

# ────────────────────────────────────────────
# Process all rule files
# ────────────────────────────────────────────
for src_file in "$SRC"/*.md; do
  fname=$(basename "$src_file")
  dest_file="$DEST/$fname"

  case "$MODEL" in
    claude)    compile_claude "$src_file" "$dest_file" ;;
    gemini)    compile_gemini "$src_file" "$dest_file" ;;
    universal) compile_universal "$src_file" "$dest_file" ;;
  esac

  COMPILED=$((COMPILED + 1))
  [ "$MODEL" = "claude" ] && echo "  ✓ $fname"
done

echo ""
echo "Compiled: $COMPILED files → $DEST"
[ "$WARNINGS" -gt 0 ] && echo "Warnings: $WARNINGS (stub transforms — see RT-1 research thread)"
echo "Done."
