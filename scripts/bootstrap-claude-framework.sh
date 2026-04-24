#!/usr/bin/env bash
# scripts/bootstrap-claude-framework.sh
# ─────────────────────────────────────────────────────────────────────────────
# Claude Code Context Engineering Framework — Bootstrap Installer
#
# PURPOSE:
#   Zero-manual-steps installation of the full .claude/ context engineering
#   framework into any project repository. Idempotent — safe to re-run.
#
# USAGE:
#   chmod +x scripts/bootstrap-claude-framework.sh
#   ./scripts/bootstrap-claude-framework.sh [OPTIONS]
#
# OPTIONS:
#   --dry-run       Print all actions without executing any writes
#   --force         Overwrite existing files (default: skip existing)
#   --no-git-check  Skip git repository validation
#   --quiet         Suppress non-error output
#   --help          Show this message
#
# WHAT IT DOES:
#   1. Validates environment (git repo, bash version, required tools)
#   2. Copies framework files from scripts/framework/ into project root
#   3. Sets correct permissions on hook scripts
#   4. Validates .gitignore contains required entries
#   5. Validates .claudeignore is git-tracked
#   6. Runs post-install integrity check
#   7. Prints onboarding summary with next steps
#
# WHAT IT DOES NOT DO:
#   - Modify any existing source code
#   - Make any network requests
#   - Require root / sudo
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_SRC="${SCRIPT_DIR}/framework"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Flags
DRY_RUN=false
FORCE=false
NO_GIT_CHECK=false
QUIET=false

# Counters
INSTALLED=0
SKIPPED=0
ERRORS=0

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; BLUE=''; CYAN=''; BOLD=''; RESET=''
fi

# ─────────────────────────────────────────────────────────────────────────────
# ARGUMENT PARSING
# ─────────────────────────────────────────────────────────────────────────────

for arg in "$@"; do
  case $arg in
    --dry-run)       DRY_RUN=true ;;
    --force)         FORCE=true ;;
    --no-git-check)  NO_GIT_CHECK=true ;;
    --quiet)         QUIET=true ;;
    --help)
      sed -n '/^# USAGE:/,/^# ─/p' "$0" | grep '^#' | sed 's/^# \?//'
      exit 0 ;;
    *)
      echo -e "${RED}Unknown option: $arg${RESET}" >&2
      exit 1 ;;
  esac
done

# ─────────────────────────────────────────────────────────────────────────────
# LOGGING HELPERS
# ─────────────────────────────────────────────────────────────────────────────

log()     { $QUIET || echo -e "${RESET}$*"; }
info()    { $QUIET || echo -e "${BLUE}  →${RESET} $*"; }
success() { $QUIET || echo -e "${GREEN}  ✓${RESET} $*"; }
warn()    { echo -e "${YELLOW}  ⚠${RESET} $*"; }
error()   { echo -e "${RED}  ✗${RESET} $*" >&2; ERRORS=$((ERRORS + 1)); }
header()  { $QUIET || echo -e "\n${BOLD}${CYAN}$*${RESET}"; }
dry()     { echo -e "${YELLOW}  [DRY-RUN]${RESET} $*"; }

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 1: ENVIRONMENT VALIDATION
# ─────────────────────────────────────────────────────────────────────────────

header "Phase 1 — Environment Validation"

# Bash version check
if (( BASH_VERSINFO[0] < 4 )); then
  error "Bash 4.0+ required (current: $BASH_VERSION). On macOS: brew install bash"
  exit 1
fi
success "Bash version: $BASH_VERSION"

# Git repository check
if ! $NO_GIT_CHECK; then
  if ! git rev-parse --git-dir &>/dev/null; then
    error "Not a git repository. Run from project root or use --no-git-check."
    exit 1
  fi
  success "Git repository detected: ${PROJECT_ROOT}"
else
  warn "Git check skipped — using current directory: $(pwd)"
  PROJECT_ROOT="$(pwd)"
fi

# Framework source check
if [[ ! -d "${FRAMEWORK_SRC}" ]]; then
  error "Framework source directory not found: ${FRAMEWORK_SRC}"
  error "Expected: scripts/framework/ containing .claude/ and .claudeignore"
  error "Clone the framework or run this script from the correct location."
  exit 1
fi
success "Framework source found: ${FRAMEWORK_SRC}"

# Required tools
for tool in cp chmod find grep sed; do
  if ! command -v "$tool" &>/dev/null; then
    error "Required tool not found: $tool"
    exit 1
  fi
done
success "Required tools available"

$DRY_RUN && warn "DRY-RUN mode — no files will be written"

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 2: FILE INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────

header "Phase 2 — File Installation (25 files)"

# install_file <src_relative_to_framework> <dest_relative_to_project_root>
install_file() {
  local src="${FRAMEWORK_SRC}/${1}"
  local dest="${PROJECT_ROOT}/${2:-$1}"
  local dest_dir
  dest_dir="$(dirname "${dest}")"

  if [[ ! -f "${src}" ]]; then
    error "Source file missing: ${src}"
    return
  fi

  if [[ -f "${dest}" ]] && ! $FORCE; then
    info "SKIP (exists) → ${2:-$1}"
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  if $DRY_RUN; then
    dry "INSTALL → ${2:-$1}"
    INSTALLED=$((INSTALLED + 1))
    return
  fi

  mkdir -p "${dest_dir}"
  cp "${src}" "${dest}"
  success "Installed → ${2:-$1}"
  INSTALLED=$((INSTALLED + 1))
}

# Root files
install_file "CLAUDE.md"
install_file ".claudeignore"

# .claude/settings
install_file ".claude/settings.json"

# Hooks
install_file ".claude/hooks/pre-compact.sh"

# Templates
install_file ".claude/templates/HANDOVER.md"
install_file ".claude/templates/SUBAGENT.md"
install_file ".claude/templates/COMPACTION.md"
install_file ".claude/templates/FAILURE_LEDGER.md"
install_file ".claude/templates/MVCS-SYNTHESIS.md"
install_file ".claude/templates/MVCS-DEBUGGING.md"
install_file ".claude/templates/MVCS-REFACTOR.md"
install_file ".claude/templates/STATE-FREEZE.md"


# Rules — all 13
RULES=(
  api.md ci.md config.md db.md dependencies.md
  docs.md frontend.md infra.md logging.md migrations.md
  monitoring.md security.md testing.md
)
for rule in "${RULES[@]}"; do
  install_file ".claude/rules/${rule}"
done

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 3: PERMISSIONS
# ─────────────────────────────────────────────────────────────────────────────

header "Phase 3 — Permissions"

HOOK_PATH="${PROJECT_ROOT}/.claude/hooks/pre-compact.sh"

if $DRY_RUN; then
  dry "chmod +x ${HOOK_PATH}"
elif [[ -f "${HOOK_PATH}" ]]; then
  chmod +x "${HOOK_PATH}"
  success "Executable: .claude/hooks/pre-compact.sh"
else
  warn "Hook script not found — skipping chmod (install may have failed)"
fi

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 4: .gitignore VALIDATION & PATCHING
# ─────────────────────────────────────────────────────────────────────────────

header "Phase 4 — .gitignore Validation"

GITIGNORE="${PROJECT_ROOT}/.gitignore"
REQUIRED_GITIGNORE_ENTRIES=(
  ".claude/settings.local.json"
  ".claude/snapshots/"
)

if [[ ! -f "${GITIGNORE}" ]]; then
  warn ".gitignore not found — creating with required entries"
  $DRY_RUN || touch "${GITIGNORE}"
fi

for entry in "${REQUIRED_GITIGNORE_ENTRIES[@]}"; do
  if grep -qxF "${entry}" "${GITIGNORE}" 2>/dev/null; then
    success ".gitignore contains: ${entry}"
  else
    warn ".gitignore missing: ${entry}"
    if $DRY_RUN; then
      dry "APPEND to .gitignore → ${entry}"
    else
      echo "${entry}" >> "${GITIGNORE}"
      success "Appended to .gitignore → ${entry}"
    fi
  fi
done

# Create snapshots dir with .gitkeep so it exists but contents are ignored
SNAPSHOTS_DIR="${PROJECT_ROOT}/.claude/snapshots"
if $DRY_RUN; then
  dry "mkdir -p ${SNAPSHOTS_DIR} && touch ${SNAPSHOTS_DIR}/.gitkeep"
elif [[ ! -d "${SNAPSHOTS_DIR}" ]]; then
  mkdir -p "${SNAPSHOTS_DIR}"
  touch "${SNAPSHOTS_DIR}/.gitkeep"
  success "Created: .claude/snapshots/ (pre-compact output directory)"
fi

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 5: .claudeignore GIT-TRACKING VALIDATION
# ─────────────────────────────────────────────────────────────────────────────

header "Phase 5 — .claudeignore Git-Tracking Check"

if ! $NO_GIT_CHECK && ! $DRY_RUN; then
  CLAUDEIGNORE="${PROJECT_ROOT}/.claudeignore"
  if [[ -f "${CLAUDEIGNORE}" ]]; then
    if git -C "${PROJECT_ROOT}" ls-files --error-unmatch ".claudeignore" &>/dev/null; then
      success ".claudeignore is already git-tracked"
    else
      warn ".claudeignore is NOT git-tracked — staging it now"
      git -C "${PROJECT_ROOT}" add ".claudeignore"
      success "Staged: .claudeignore (commit this with your framework files)"
    fi
  else
    error ".claudeignore not found after install — check Phase 2 errors"
  fi
else
  $DRY_RUN && dry "git add .claudeignore (would be staged)"
fi

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 6: INTEGRITY CHECK
# ─────────────────────────────────────────────────────────────────────────────

header "Phase 6 — Post-Install Integrity Check (25 files)"

EXPECTED_FILES=(
  "CLAUDE.md"
  ".claudeignore"
  ".claude/settings.json"
  ".claude/hooks/pre-compact.sh"
  ".claude/templates/HANDOVER.md"
  ".claude/templates/SUBAGENT.md"
  ".claude/templates/COMPACTION.md"
  ".claude/templates/FAILURE_LEDGER.md"
  ".claude/templates/MVCS-SYNTHESIS.md"
  ".claude/templates/MVCS-DEBUGGING.md"
  ".claude/templates/MVCS-REFACTOR.md"
  ".claude/templates/STATE-FREEZE.md"

  ".claude/rules/api.md"
  ".claude/rules/ci.md"
  ".claude/rules/config.md"
  ".claude/rules/db.md"
  ".claude/rules/dependencies.md"
  ".claude/rules/docs.md"
  ".claude/rules/frontend.md"
  ".claude/rules/infra.md"
  ".claude/rules/logging.md"
  ".claude/rules/migrations.md"
  ".claude/rules/monitoring.md"
  ".claude/rules/security.md"
  ".claude/rules/testing.md"
)

INTEGRITY_PASS=true
for f in "${EXPECTED_FILES[@]}"; do
  target="${PROJECT_ROOT}/${f}"
  if $DRY_RUN; then
    dry "CHECK (skipped in dry-run) → ${f}"
  elif [[ -f "${target}" ]]; then
    success "Present → ${f}"
  else
    error "MISSING → ${f}"
    INTEGRITY_PASS=false
  fi
done

if ! $INTEGRITY_PASS; then
  error "Integrity check failed — one or more files are missing"
fi

# ─────────────────────────────────────────────────────────────────────────────
# SUMMARY
# ─────────────────────────────────────────────────────────────────────────────

header "Bootstrap Complete"

log ""
log "  ${GREEN}Installed:${RESET}  ${INSTALLED}"
log "  ${YELLOW}Skipped:${RESET}   ${SKIPPED}  (already exist — use --force to overwrite)"
log "  ${RED}Errors:${RESET}    ${ERRORS}"
log ""

if (( ERRORS > 0 )); then
  error "Bootstrap completed with errors. Review output above."
  exit 1
fi

log "${BOLD}Next Steps:${RESET}"
log ""
log "  1. ${CYAN}Populate TODO items${RESET} in each .claude/rules/*.md file:"
log "     grep -rn 'TODO' .claude/rules/ | head -30"
log ""
log "  2. ${CYAN}Fill pointer targets${RESET} in CLAUDE.md:"
log "     docs/stack.md, docs/commands.md, docs/architecture.md"
log ""
log "  3. ${CYAN}Configure .claude/settings.json${RESET}:"
log "     Set model, tools, MCP servers, and permission rules for this project"
log ""
log "  4. ${CYAN}Commit the framework${RESET}:"
log "     git add CLAUDE.md .claudeignore .claude/ .gitignore"
log "     git commit -m 'chore: install claude context engineering framework'"
log ""
log "  5. ${CYAN}Verify hook executes${RESET}:"
log "     ./.claude/hooks/pre-compact.sh"
log ""
log "  6. ${CYAN}Review onboarding doc${RESET}: docs/setup.md"
log ""
$DRY_RUN && warn "DRY-RUN — no changes were written to disk"

exit 0
