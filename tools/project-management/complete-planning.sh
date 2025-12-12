#!/bin/zsh

# Script to mark planning phase complete and transition to implementation
# Now integrates with apply-planning.sh to automatically set up project

# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}           Complete Planning Phase & Begin Implementation          ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if .copilot-planning exists
if [[ ! -f ".copilot-planning" ]]; then
  echo "${RED}✗${NC} No .copilot-planning file found in current directory"
  echo "  Run this script from a project root in planning phase"
  exit 1
fi

# Check if PLANNING-MASTER.md exists
if [[ ! -f "PLANNING-MASTER.md" ]]; then
  echo "${RED}✗${NC} No PLANNING-MASTER.md found"
  exit 1
fi

# Confirm planning is complete
echo "${YELLOW}Planning phase completion checklist:${NC}"
echo ""
echo "Have you completed:"
echo "  ✓ Project vision and goals"
echo "  ✓ System architecture"
echo "  ✓ Technology stack selection"
echo "  ✓ User personas and workflows"
echo "  ✓ Phase 1 MVP features defined"
echo ""
read "CONFIRM?Is planning complete? (y/N): "

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "${YELLOW}Continue working on PLANNING-MASTER.md${NC}"
  exit 0
fi

echo ""
echo "${YELLOW}Transition options:${NC}"
echo "  1. Apply planning config (auto-setup from PLANNING-MASTER.md)"
echo "  2. Skip auto-setup (manual implementation)"
echo ""
read "SETUP_TYPE?Choose option (1-2): "

# Remove planning marker
rm .copilot-planning
echo "${GREEN}✓${NC} Removed .copilot-planning marker"

# Create development phase marker
DEVELOPMENT_TIME=$(date +%Y-%m-%d\ %H:%M:%S)
cat > ".copilot-development" << 'DEVMARKER'
# Development Phase Active
#
# This project is in ACTIVE DEVELOPMENT.
# - All AI modes available including agent mode
# - Reference PLANNING-MASTER.md for architecture and roadmap
# - Implement features from Phase 1 MVP
# - Maintain tests and documentation as you develop
#
DEVMARKER
echo "# Phase Started: ${DEVELOPMENT_TIME}" >> .copilot-development
echo "${GREEN}✓${NC} Created .copilot-development marker"

# Log phase transition
echo "${DEVELOPMENT_TIME} | Planning → Development | Transitioned via complete-planning.sh" >> .phase-history.log
echo "${GREEN}✓${NC} Logged phase transition"

# Update VS Code settings
if [[ -f ".vscode/settings.json" ]]; then
  cat > ".vscode/settings.json" << 'SETTINGS'
{
  "github.copilot.chat.editorInstructions": [
    {
      "text": "This project is in ACTIVE DEVELOPMENT. All AI modes available. Reference PLANNING-MASTER.md for project architecture, tech stack, and roadmap. Keep project-specific details in PLANNING-MASTER.md, link to global references only."
    }
  ]
}
SETTINGS
  echo "${GREEN}✓${NC} Updated VS Code settings for development phase"
fi

# Update PLANNING-MASTER.md if it exists
if [[ -f "PLANNING-MASTER.md" ]]; then
  DEVELOPMENT_DATE=$(date +%Y-%m-%d)

  # Try to update phase status (best effort)
  if grep -q "**Current Phase:**" PLANNING-MASTER.md; then
    sed -i.bak "s/\*\*Current Phase:\*\*.*/\*\*Current Phase:\*\* Development/" PLANNING-MASTER.md
    sed -i.bak "s/\*\*Phase Started:\*\*.*/\*\*Phase Started:\*\* ${DEVELOPMENT_DATE}/" PLANNING-MASTER.md
    rm -f PLANNING-MASTER.md.bak
    echo "${GREEN}✓${NC} Updated phase status in PLANNING-MASTER.md"
  fi
fi

# Update README
if [[ -f "README.md" ]]; then
  mv README.md README-PLANNING.md
  echo "${GREEN}✓${NC} Archived planning README"

  PROJECT_NAME=$(basename "$PWD")
  cat > README.md << README
# ${PROJECT_NAME}

## 🚀 Status: Active Development

See [PLANNING-MASTER.md](PLANNING-MASTER.md) for complete project plan, architecture, and roadmap.

## Quick Start

\`\`\`bash
# Install dependencies
npm install

# Start development server
npm run dev
\`\`\`

## Project Structure

See [PLANNING-MASTER.md](PLANNING-MASTER.md) for architecture details.

## Documentation

- **[PLANNING-MASTER.md](PLANNING-MASTER.md)** - Project plan, architecture, tech stack, roadmap
- **[README-PLANNING.md](README-PLANNING.md)** - Planning phase workflow (archived)

## Development Workflow

See Phase 1 MVP tasks in [PLANNING-MASTER.md](PLANNING-MASTER.md).
README

  echo "${GREEN}✓${NC} Created development README"
fi

# Apply planning configuration if requested
if [[ "$SETUP_TYPE" == "1" ]]; then
  echo ""
  echo "${BLUE}Applying planning configuration...${NC}"

  SCRIPT_DIR="${DEV_TOOLS}/project-management"
  if [[ -x "${SCRIPT_DIR}/apply-planning.sh" ]]; then
    "${SCRIPT_DIR}/apply-planning.sh"
  else
    echo "${RED}✗${NC} apply-planning.sh not found"
  fi
fi

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}✓ Planning Phase Complete!${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "${GREEN}✓${NC} Agent mode now available"
echo "${GREEN}✓${NC} All workflows configured based on PLANNING-MASTER.md"
echo ""
echo "${YELLOW}Next Steps:${NC}"
echo "1. Reload VS Code window (Cmd+Shift+P → Reload Window)"
echo "2. Install dependencies if auto-setup was applied"
echo "3. Begin Phase 1 MVP implementation"
echo "4. Reference PLANNING-MASTER.md throughout development"
echo ""
