#!/usr/bin/env bash
# scripts/ads-lint.sh
# Anchor Density Score (ADS) Linting Tool

set -uo pipefail # Removed -e to handle grep non-matches manually

# Dependencies check
for cmd in bc grep wc awk sed; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Missing required dependency: $cmd" >&2
    exit 1
  fi
done

ADS_FILE_VERSION="1.0.0"

calculate_ads() {
  local target="$1"

  if [[ ! -f "$target" ]]; then
    echo "Error: File not found: $target" >&2
    return 1
  fi

  if [[ ! "$target" =~ \.md$ ]]; then
    return 0
  fi

  if [[ ! -s "$target" ]]; then
    return 2
  fi

  local words
  words=$(wc -w < "$target" | tr -d '[:space:]')
  if [[ "$words" -eq 0 ]]; then return 2; fi

  local tokens
  tokens=$(awk "BEGIN {print int($words * 0.75)}")
  
  local units
  units=$(awk "BEGIN {u = $tokens / 50; print (u < 1 ? 1 : u)}")

  # Use grep | wc -l to avoid exit code 1 on no match
  local bolding
  bolding=$(grep -o '\*\*' "$target" | wc -l | tr -d '[:space:]')
  bolding=$((bolding / 2))

  local directives
  directives=$(grep -oE '\b(ALWAYS|EXTRACT|VERIFY|ENFORCE|REQUIRE|RESTRICTED|REQUIRED)\b' "$target" 2>/dev/null | wc -l | tr -d '[:space:]')
  # Note: NEVER is a CFV (omission bias trigger) — excluded from positive anchor count per SDO §CFV

  local numbered
  numbered=$(grep -E '^[0-9]+\.' "$target" 2>/dev/null | wc -l | tr -d '[:space:]')

  local codeblocks
  codeblocks=$(grep '```' "$target" 2>/dev/null | wc -l | tr -d '[:space:]')
  codeblocks=$((codeblocks / 2)) # each block has two markers

  local pointers
  pointers=$(grep '- Pointer:' "$target" 2>/dev/null | wc -l | tr -d '[:space:]')

  local total_anchors=$((bolding + directives + numbered + codeblocks + pointers))
  
  local score
  score=$(awk "BEGIN {s = ($total_anchors * 10) / $units; if (s > 10) s = 10; printf \"%.1f\", s}")

  local bold_den
  bold_den=$(awk "BEGIN {printf \"%.1f\", $bolding / $units}")
  local dir_den
  dir_den=$(awk "BEGIN {printf \"%.1f\", $directives / $units}")
  local code_den
  code_den=$(awk "BEGIN {printf \"%.1f\", $codeblocks / $units}")

  local rating
  local is_exceptional; is_exceptional=$(echo "$score >= 9.0" | bc -l | tr -d '[:space:]')
  local is_excellent; is_excellent=$(echo "$score >= 7.0" | bc -l | tr -d '[:space:]')
  local is_adequate; is_adequate=$(echo "$score >= 5.0" | bc -l | tr -d '[:space:]')
  local is_weak; is_weak=$(echo "$score >= 3.0" | bc -l | tr -d '[:space:]')

  if [[ "$is_exceptional" == "1" ]]; then rating="EXCEPTIONAL";
  elif [[ "$is_excellent" == "1" ]]; then rating="EXCELLENT";
  elif [[ "$is_adequate" == "1" ]]; then rating="ADEQUATE";
  elif [[ "$is_weak" == "1" ]]; then rating="WEAK";
  else rating="FAILING"; fi

  local recs=()
  local is_low; is_low=$(echo "$score < 6.0" | bc -l | tr -d '[:space:]')
  if [[ "$is_low" == "1" ]]; then
    if (( $(echo "$bolding < $units" | bc -l | tr -d '[:space:]') )); then recs+=("\"Add more bolded anchors for key constraints\""); fi
    if (( $(echo "$directives < $units" | bc -l | tr -d '[:space:]') )); then recs+=("\"Increase ALWAYS/RESTRICTED directive count\""); fi
    if [[ "$codeblocks" -lt 1 ]]; then recs+=("\"Include code examples for complex patterns\""); fi
  fi

  echo "{"
  echo "  \"file\": \"$target\","
  echo "  \"score\": $score,"
  echo "  \"breakdown\": {"
  echo "    \"bolding_density\": $bold_den,"
  echo "    \"directive_density\": $dir_den,"
  echo "    \"code_density\": $code_den"
  echo "  },"
  echo "  \"rating\": \"$rating\","
  echo -n "  \"recommendations\": ["
  local first=true
  for r in "${recs[@]:-}"; do
    if [[ -n "$r" ]]; then
        if [ "$first" = true ]; then first=false; else echo -n ", "; fi
        echo -n "$r"
    fi
  done
  echo "]"
  echo "}"
}

TARGET="${1:-.}"

if [[ -d "$TARGET" ]]; then
  echo "["
  FIRST_FILE=true
  while IFS= read -r f; do
    if [ "$FIRST_FILE" = true ]; then FIRST_FILE=false; else echo ","; fi
    calculate_ads "$f" || true
  done < <(find "$TARGET" -name "*.md" -not -path '*/.*' -type f)
  echo "]"
elif [[ -f "$TARGET" ]]; then
  calculate_ads "$TARGET"
else
  echo "Error: Invalid target $TARGET" >&2
  exit 1
fi
