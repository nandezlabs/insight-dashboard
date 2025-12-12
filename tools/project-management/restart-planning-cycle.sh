#!/bin/zsh

################################################################################
# Restart Planning Cycle
# Restart at planning phase for major version evolution (v2.0, v3.0, etc.)
# For minor changes (bug fixes), stay in current phase - don't use this script
################################################################################

# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}           Restart Planning Cycle (Major Evolution)                ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detect current phase
CURRENT_PHASE=""
FROM_PHASE=""

if [[ -f ".copilot-maintenance" ]]; then
    CURRENT_PHASE="maintenance"
    FROM_PHASE="Maintenance"
elif [[ -f ".copilot-production" ]]; then
    CURRENT_PHASE="production"
    FROM_PHASE="Production"
else
    echo "${RED}✗${NC} This script should be run from a project in production or maintenance phase"
    echo ""
    echo "Current phase markers found:"
    [[ -f ".copilot-planning" ]] && echo "    - Planning phase active"
    [[ -f ".copilot-development" ]] && echo "    - Development phase active"
    [[ ! -f ".copilot-planning" && ! -f ".copilot-development" && ! -f ".copilot-production" && ! -f ".copilot-maintenance" ]] && echo "    - No phase markers found"
    exit 1
fi

# Detect current version
CURRENT_VERSION="1.0"
if [[ -f "PLANNING.md" ]]; then
    VERSION_LINE=$(grep -m 1 "Version:" "PLANNING.md" 2>/dev/null || echo "")
    if [[ -n "$VERSION_LINE" ]]; then
        CURRENT_VERSION=$(echo "$VERSION_LINE" | grep -oE '[0-9]+\.[0-9]+' | head -1)
    fi
elif [[ -f "package.json" ]]; then
    CURRENT_VERSION=$(grep -m 1 '"version"' package.json | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 | cut -d'.' -f1-2)
fi

# Calculate next major version
MAJOR=$(echo "$CURRENT_VERSION" | cut -d'.' -f1)
NEXT_MAJOR=$((MAJOR + 1))
NEXT_VERSION="${NEXT_MAJOR}.0"

echo "${CYAN}📊 Version Information:${NC}"
echo "  Current: ${YELLOW}v$CURRENT_VERSION${NC}"
echo "  Next:    ${GREEN}v$NEXT_VERSION${NC}"
echo ""

# Explain scope
echo "${MAGENTA}⚠️  Use this script for MAJOR evolution:${NC}"
echo "  ${GREEN}✓${NC} Major version releases (v2.0, v3.0)"
echo "  ${GREEN}✓${NC} Architecture overhauls"
echo "  ${GREEN}✓${NC} Platform expansions"
echo "  ${GREEN}✓${NC} Significant feature additions"
echo ""
echo "  ${RED}✗${NC} Do NOT use for:"
echo "    • Bug fixes"
echo "    • Minor patches"
echo "    • Small feature additions"
echo "    ${CYAN}→ For minor changes, stay in current phase${NC}"
echo ""
read "CONFIRM?Continue with major version planning? (y/N) "
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "${YELLOW}Cancelled.${NC}"
    exit 0
fi

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}           Phase Archival                                          ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Archive current phase
ARCHIVE_DIR=".phase-archive"
mkdir -p "$ARCHIVE_DIR"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

for marker in .copilot-*; do
    if [[ -f "$marker" ]]; then
        MARKER_NAME=$(basename "$marker")
        cp "$marker" "$ARCHIVE_DIR/${MARKER_NAME}-v${CURRENT_VERSION}-${TIMESTAMP}"
        echo "${GREEN}✓${NC} Archived: ${CYAN}$MARKER_NAME${NC} (v$CURRENT_VERSION)"
    fi
done

# Archive current planning if exists
if [[ -f "PLANNING.md" ]]; then
    cp "PLANNING.md" "$ARCHIVE_DIR/PLANNING-v${CURRENT_VERSION}-${TIMESTAMP}.md"
    echo "${GREEN}✓${NC} Archived: ${CYAN}PLANNING.md${NC} (v$CURRENT_VERSION)"
fi

# Archive maintenance/production docs
for doc in MAINTENANCE-PROCEDURES.md PRODUCTION-CHECKLIST.md .production-info.json; do
    if [[ -f "$doc" ]]; then
        cp "$doc" "$ARCHIVE_DIR/${doc}-v${CURRENT_VERSION}-${TIMESTAMP}"
        echo "${GREEN}✓${NC} Archived: ${CYAN}$doc${NC}"
    fi
done

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}           Planning Phase Setup                                    ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Remove current phase markers
rm -f .copilot-*
echo "${GREEN}✓${NC} Removed current phase markers"

# Create planning marker
cat > ".copilot-planning" << EOF
# Planning Phase (Major Version)
Started: $(date)
Previous Version: v$CURRENT_VERSION
Target Version: v$NEXT_VERSION
Previous Phase: $FROM_PHASE

Planning the next major version with comprehensive assessment of current state.
This is a circular lifecycle restart for major evolution.
EOF

echo "${GREEN}✓${NC} Created planning phase marker (${GREEN}v$NEXT_VERSION${NC})"

# Copy PLANNING-NEXT-VERSION template
TEMPLATE_DIR="${DEVELOPER_PATH:-/Users/nandez/Developer}/templates/planning"
if [[ -f "$TEMPLATE_DIR/PLANNING-NEXT-VERSION.md" ]]; then
    # Create new planning file with version info
    sed "s/\[VERSION\]/v$NEXT_VERSION/g; s/\[CURRENT_VERSION\]/v$CURRENT_VERSION/g; s/\[DATE\]/$(date +"%B %d, %Y")/g" \
        "$TEMPLATE_DIR/PLANNING-NEXT-VERSION.md" > "PLANNING-v${NEXT_VERSION}.md"
    echo "${GREEN}✓${NC} Created ${CYAN}PLANNING-v${NEXT_VERSION}.md${NC} from template"
else
    echo "${YELLOW}⚠️${NC}  Template not found at $TEMPLATE_DIR/PLANNING-NEXT-VERSION.md"
    echo "  Creating basic planning file..."

    cat > "PLANNING-v${NEXT_VERSION}.md" << EOF
# Planning Document: v$NEXT_VERSION

**Started:** $(date +"%B %d, %Y")
**Previous Version:** v$CURRENT_VERSION
**Status:** Planning

## Current State Assessment

### What's Working Well (v$CURRENT_VERSION)
- [Document successes]

### Pain Points & Limitations
- [Document issues to address]

## Vision for v$NEXT_VERSION
- [Define goals]

## Evolution Strategy
- [What stays, improves, replaces, new]

## Technical Changes
- [Architecture, stack, database, API changes]

## Migration Planning
- [User migration, data migration, deployment strategy]

## Timeline & Roadmap
- [Key milestones]
EOF

    echo "${GREEN}✓${NC} Created basic planning file"
fi

# Log phase transition
echo "$(date '+%Y-%m-%d %H:%M:%S') - Restarted planning cycle: v$CURRENT_VERSION → v$NEXT_VERSION (from $FROM_PHASE)" >> ".phase-history.log"
echo "${GREEN}✓${NC} Logged phase transition"

# Update VS Code settings
VSCODE_DIR=".vscode"
mkdir -p "$VSCODE_DIR"

cat > "$VSCODE_DIR/settings.json" << EOF
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "text": "This project is in PLANNING phase for v$NEXT_VERSION. Focus on strategic planning, architecture decisions, and comprehensive assessment of the current v$CURRENT_VERSION before implementation. This is a major version evolution - consider migration paths, backward compatibility, and learnings from v$CURRENT_VERSION."
    }
  ]
}
EOF

echo "${GREEN}✓${NC} Updated VS Code settings"

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}           Git Workflow Suggestions                                ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  ${CYAN}1.${NC} Keep v$CURRENT_VERSION stable on ${YELLOW}main/production${NC} branch"
echo ""
echo "  ${CYAN}2.${NC} Create planning branch:"
echo "     ${GREEN}git checkout -b v${NEXT_VERSION}-planning${NC}"
echo ""
echo "  ${CYAN}3.${NC} Commit planning document:"
echo "     ${GREEN}git add PLANNING-v${NEXT_VERSION}.md .copilot-planning .phase-archive/${NC}"
echo "     ${GREEN}git commit -m 'Start v$NEXT_VERSION planning'${NC}"
echo ""
echo "  ${CYAN}4.${NC} Parallel maintenance:"
echo "     • Bugs/patches go to ${YELLOW}main${NC} branch (v$CURRENT_VERSION)"
echo "     • Major features go to ${YELLOW}v${NEXT_VERSION}-planning${NC} branch"
echo ""

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}✅ Planning cycle restarted!${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "${MAGENTA}📝 Next Steps:${NC}"
echo ""
echo "  ${CYAN}1.${NC} Fill out ${YELLOW}PLANNING-v${NEXT_VERSION}.md${NC}:"
echo "     • Assess current state (what works, what doesn't)"
echo "     • Define vision for v$NEXT_VERSION"
echo "     • Plan evolution strategy"
echo "     • Identify technical changes"
echo "     • Plan migration approach"
echo "     • Apply learnings from v$CURRENT_VERSION"
echo ""
echo "  ${CYAN}2.${NC} When planning is complete, transition to development:"
echo "     ${GREEN}tools/project-management/complete-planning.sh${NC}"
echo ""
echo "  ${CYAN}3.${NC} Check current phase anytime:"
echo "     ${GREEN}tools/project-management/get-project-phase.sh${NC}"
echo ""
echo "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Current Phase: ${GREEN}PLANNING${NC} (v$NEXT_VERSION)"
echo "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
