#!/bin/bash
# PM-OS install script
# Adds PM-OS to an existing project without touching your code or git history.
# Run from your project root: curl -sSL https://raw.githubusercontent.com/yogonwa/pm-os/main/install.sh | bash

set -e

REPO_RAW="https://raw.githubusercontent.com/yogonwa/pm-os/main"
PROJECT_ROOT=$(pwd)

# ── Colors for output ──────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()    { echo -e "${GREEN}✓${NC}  $1"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $1"; }
error()   { echo -e "${RED}✗${NC}  $1"; exit 1; }
section() { echo -e "\n── $1 ──────────────────────────────────────────────────"; }

# ── Pre-flight checks ──────────────────────────────────────────────────────────
section "PM-OS Installer"
echo "Installing into: $PROJECT_ROOT"
echo ""

command -v curl >/dev/null 2>&1 || error "curl is required. Install it and try again."
command -v git  >/dev/null 2>&1 || error "git is required. Install it and try again."

if [ ! -d ".git" ]; then
  warn "No .git directory found. PM-OS works best inside a git repo."
  read -r -p "   Continue anyway? (y/N): " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# ── Create folder structure ────────────────────────────────────────────────────
section "Creating folder structure"

mkdir -p .claude/agents
mkdir -p .claude/commands
mkdir -p .claude/hooks
mkdir -p .claude/skills
mkdir -p .pm/initiatives
mkdir -p .pm/adrs

info "Created .claude/ structure"
info "Created .pm/ structure"

# ── Download core PM files ─────────────────────────────────────────────────────
section "Installing PM-OS files"

# .pm/CLAUDE.md — the document system guide
curl -sSL "$REPO_RAW/templates/pm-CLAUDE.md" -o .pm/CLAUDE.md
info "Installed .pm/CLAUDE.md"

# .pm/state.md — session state tracker
if [ ! -f ".pm/state.md" ]; then
  curl -sSL "$REPO_RAW/templates/state-template.md" -o .pm/state.md
  info "Installed .pm/state.md"
else
  warn ".pm/state.md already exists — skipped"
fi

# .pm/lessons.md — retro log
if [ ! -f ".pm/lessons.md" ]; then
  curl -sSL "$REPO_RAW/templates/lessons-template.md" -o .pm/lessons.md
  info "Installed .pm/lessons.md"
else
  warn ".pm/lessons.md already exists — skipped"
fi

# Skills
curl -sSL "$REPO_RAW/.claude/skills/tdd.md"        -o .claude/skills/tdd.md
curl -sSL "$REPO_RAW/.claude/skills/yagni-dry.md"  -o .claude/skills/yagni-dry.md
curl -sSL "$REPO_RAW/.claude/skills/risk-tiers.md" -o .claude/skills/risk-tiers.md
info "Installed .claude/skills/"

# Agent stubs
curl -sSL "$REPO_RAW/.claude/agents/architect.md"  -o .claude/agents/architect.md
curl -sSL "$REPO_RAW/.claude/agents/designer.md"   -o .claude/agents/designer.md
curl -sSL "$REPO_RAW/.claude/agents/reviewer.md"   -o .claude/agents/reviewer.md
curl -sSL "$REPO_RAW/.claude/agents/pm.md"         -o .claude/agents/pm.md
info "Installed .claude/agents/"

# Hooks
curl -sSL "$REPO_RAW/.claude/hooks/pre-commit"     -o .claude/hooks/pre-commit
chmod +x .claude/hooks/pre-commit
info "Installed .claude/hooks/pre-commit"

# ── Handle CLAUDE.md ───────────────────────────────────────────────────────────
section "Project CLAUDE.md"

if [ -f "CLAUDE.md" ]; then
  warn "CLAUDE.md already exists in this project."
  warn "PM-OS template saved as CLAUDE.pm-os.md"
  warn "Manually copy the sections you need into your existing CLAUDE.md."
  curl -sSL "$REPO_RAW/CLAUDE.md" -o CLAUDE.pm-os.md
else
  curl -sSL "$REPO_RAW/CLAUDE.md" -o CLAUDE.md
  info "Installed CLAUDE.md — open it and fill in the three sections before starting"
fi

# ── Update .gitignore ──────────────────────────────────────────────────────────
section "Updating .gitignore"

GITIGNORE_ENTRIES=(
  "CLAUDE.local.md"
  ".pm/initiatives/*/design-context.md"
)

if [ ! -f ".gitignore" ]; then
  touch .gitignore
fi

for entry in "${GITIGNORE_ENTRIES[@]}"; do
  if ! grep -qF "$entry" .gitignore; then
    echo "$entry" >> .gitignore
    info "Added $entry to .gitignore"
  else
    warn "$entry already in .gitignore — skipped"
  fi
done

# ── Check global CLAUDE.md ─────────────────────────────────────────────────────
section "Global CLAUDE.md check"

if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  info "~/.claude/CLAUDE.md exists — good"
else
  warn "No global CLAUDE.md found at ~/.claude/CLAUDE.md"
  echo "     This file sets your personal working preferences across all projects."
  echo "     Download the template:"
  echo ""
  echo "     mkdir -p ~/.claude"
  echo "     curl -sSL $REPO_RAW/templates/global-CLAUDE.md -o ~/.claude/CLAUDE.md"
  echo ""
  echo "     Then open it and fill in your details."
fi

# ── Done ───────────────────────────────────────────────────────────────────────
section "Done"
echo ""
echo "  PM-OS is installed. Next steps:"
echo ""
echo "  1. Open CLAUDE.md and fill in:"
echo "     - What this project is (one or two sentences)"
echo "     - Tech stack (language, runtime, framework, test command)"
echo "     - Your project-specific non-negotiables"
echo ""
echo "  2. Run Claude Code in this directory:"
echo "     claude"
echo ""
echo "  3. Start your first initiative:"
echo "     /pm:new-initiative"
echo ""
echo "  Full docs: https://github.com/yogonwa/pm-os"
echo ""
