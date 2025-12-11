#!/bin/bash
# Project Status Dashboard - Overview of all projects
# Usage: ./project-status.sh

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          📊 PROJECT STATUS DASHBOARD                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

PROJECTS_DIR="$HOME/Developer/projects"

for PROJECT in "$PROJECTS_DIR"/*; do
    if [ -d "$PROJECT" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        echo -e "${BLUE}━━━ $PROJECT_NAME ━━━${NC}"
        
        cd "$PROJECT"
        
        # Git status
        if [ -d ".git" ]; then
            BRANCH=$(git branch --show-current 2>/dev/null)
            echo -e "  ${BLUE}Branch:${NC} $BRANCH"
            
            # Check for uncommitted changes
            if [[ -n $(git status -s) ]]; then
                CHANGES=$(git status -s | wc -l | xargs)
                echo -e "  ${YELLOW}⚠️  Uncommitted changes: $CHANGES files${NC}"
            else
                echo -e "  ${GREEN}✓ Clean working tree${NC}"
            fi
            
            # Check if ahead/behind remote
            AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
            BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
            
            if [ "$AHEAD" -gt 0 ]; then
                echo -e "  ${YELLOW}↑ Ahead by $AHEAD commits${NC}"
            fi
            if [ "$BEHIND" -gt 0 ]; then
                echo -e "  ${YELLOW}↓ Behind by $BEHIND commits${NC}"
            fi
        fi
        
        # Node.js info
        if [ -f "package.json" ]; then
            VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "unknown")
            echo -e "  ${BLUE}Version:${NC} $VERSION"
            
            # Check for outdated packages
            if command -v npm &> /dev/null; then
                OUTDATED=$(npm outdated --json 2>/dev/null | grep -o '"[^"]*":' | wc -l | xargs)
                if [ "$OUTDATED" -gt 0 ]; then
                    echo -e "  ${YELLOW}📦 $OUTDATED outdated packages${NC}"
                fi
            fi
        fi
        
        # Python info
        if [ -f "requirements.txt" ]; then
            DEPS=$(wc -l < requirements.txt | xargs)
            echo -e "  ${BLUE}Python deps:${NC} $DEPS packages"
        fi
        
        # Last modified
        LAST_COMMIT=$(git log -1 --format="%ar" 2>/dev/null || echo "N/A")
        echo -e "  ${BLUE}Last commit:${NC} $LAST_COMMIT"
        
        echo ""
    fi
done

echo -e "${GREEN}✅ Dashboard complete${NC}"
