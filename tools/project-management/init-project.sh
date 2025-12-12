#!/bin/zsh

# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# Project initialization script with planning-first workflow
# Creates new project directory with PLANNING-MASTER.md and planning phase controls

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}         Project Initialization - Planning-First Workflow         ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get project details
echo "${YELLOW}Project Details:${NC}"
read "PROJECT_NAME?Project name (lowercase-with-dashes): "
echo ""
echo "Project types:"
echo "  1. apps     - Web/mobile applications"
echo "  2. games    - Game projects"
echo "  3. learning - Educational/experimental projects"
read "PROJECT_TYPE?Project type (1-3): "

# Map number to type
case $PROJECT_TYPE in
  1) PROJECT_TYPE="apps" ;;
  2) PROJECT_TYPE="games" ;;
  3) PROJECT_TYPE="learning" ;;
  *) echo "${YELLOW}Invalid type, defaulting to apps${NC}"; PROJECT_TYPE="apps" ;;
esac

# Create project directory
PROJECT_PATH="${DEV_PROJECTS}/${PROJECT_TYPE}/${PROJECT_NAME}"
mkdir -p "$PROJECT_PATH"

echo ""
echo "${GREEN}✓${NC} Created directory: ${PROJECT_PATH}"

# Copy planning template
PLANNING_TEMPLATE="${DEV_TEMPLATES}/planning/PLANNING-MASTER.md"
PLANNING_TARGET="${PROJECT_PATH}/PLANNING-MASTER.md"

if [[ -f "$PLANNING_TEMPLATE" ]]; then
  cp "$PLANNING_TEMPLATE" "$PLANNING_TARGET"
  
  # Replace placeholders with project info
  sed -i.bak \
    -e "s/\[Project Name\]/${PROJECT_NAME}/g" \
    -e "s/\[Date Started\]/$(date +%Y-%m-%d)/g" \
    "$PLANNING_TARGET"
  rm -f "${PLANNING_TARGET}.bak"
  
  echo "${GREEN}✓${NC} Created PLANNING-MASTER.md from template"
else
  echo "${YELLOW}⚠${NC}  Template not found, creating basic planning file"
  cat > "$PLANNING_TARGET" << PLANEOF
# ${PROJECT_NAME} - Planning Master Document

**Project:** ${PROJECT_NAME}
**Date:** $(date +%Y-%m-%d)
**Status:** Planning Phase

## Planning Phase

Complete this planning document before implementation.

PLANEOF
fi

# Create planning phase marker
cat > "${PROJECT_PATH}/.copilot-planning" << 'MARKER'
# Planning Phase Active
# 
# This marker indicates the project is in planning phase.
# During this phase:
# - Use /plan, /ask, or /edit modes (NOT agent mode)
# - Focus on PLANNING-MASTER.md completion
# - No code implementation until planning is complete
#
# To complete planning phase:
# 1. Finish all sections in PLANNING-MASTER.md
# 2. Delete this file: rm .copilot-planning
# 3. Then request agent mode for implementation
MARKER

echo "${GREEN}✓${NC} Created planning phase marker (.copilot-planning)"

# Create .vscode directory for project settings
mkdir -p "${PROJECT_PATH}/.vscode"

# Create VS Code settings for planning phase
cat > "${PROJECT_PATH}/.vscode/settings.json" << 'SETTINGS'
{
  "github.copilot.chat.editorInstructions": [
    {
      "text": "This project is in PLANNING PHASE. Focus on helping complete PLANNING-MASTER.md. Do not implement code unless explicitly requested. Suggest using /plan, /ask, or /edit modes. Only use agent mode when user explicitly requests implementation or when .copilot-planning file is deleted."
    }
  ],
  "files.exclude": {
    ".copilot-planning": false
  }
}
SETTINGS

echo "${GREEN}✓${NC} Configured VS Code settings for planning phase"

# Create README with instructions
cat > "${PROJECT_PATH}/README.md" << 'README'
# Project Planning Phase

## 📋 Current Phase: PLANNING

This project is in the planning phase. Complete the following steps:

### Step 1: Complete Planning
- Open `PLANNING-MASTER.md`
- Fill in all sections marked with `[placeholders]`
- Use AI modes: `/plan`, `/ask`, `/edit` (NOT agent mode)

### Step 2: Mark Planning Complete
When planning is complete:
```bash
rm .copilot-planning
```

### Step 3: Begin Implementation
After deleting `.copilot-planning`, you can:
- Request agent mode for implementation
- Use any AI mode for development
- Begin coding features

## 🤖 AI Mode Guide

**During Planning (current):**
- ✅ `/plan` - Create implementation plans
- ✅ `/ask` - Ask questions about the project
- ✅ `/edit` - Edit planning documents
- ❌ Agent mode - Only on explicit request

**After Planning:**
- ✅ All modes available including agent mode

## 📁 Files

- `PLANNING-MASTER.md` - Main planning document
- `.copilot-planning` - Planning phase marker (delete when done)
- `README.md` - This file
README

echo "${GREEN}✓${NC} Created README.md with planning instructions"

# Summary
echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}✓ Project Initialized Successfully${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Project: ${PROJECT_NAME}"
echo "Type: ${PROJECT_TYPE}"
echo "Location: ${PROJECT_PATH}"
echo ""
echo "${YELLOW}Next Steps:${NC}"
echo "1. Open project: code ${PROJECT_PATH}"
echo "2. Complete PLANNING-MASTER.md (use /plan, /ask, /edit modes)"
echo "3. When planning done: rm ${PROJECT_PATH}/.copilot-planning"
echo "4. Begin implementation with agent mode"
echo ""
