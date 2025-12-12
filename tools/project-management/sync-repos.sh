#!/bin/bash
# Sync All Repositories - Pull and push all projects
# Usage: ./sync-repos.sh
# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true


set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 Syncing all repositories...${NC}\n"

PROJECTS_DIR="$HOME/Developer/projects"
SYNCED=0
FAILED=0

for PROJECT in "$PROJECTS_DIR"/*; do
    if [ -d "$PROJECT/.git" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        echo -e "${BLUE}📂 $PROJECT_NAME${NC}"
        
        cd "$PROJECT"
        
        # Check for uncommitted changes
        if [[ -n $(git status -s) ]]; then
            echo -e "  ${RED}⚠️  Uncommitted changes - skipping${NC}"
            ((FAILED++))
            continue
        fi
        
        # Pull latest
        if git pull --rebase 2>/dev/null; then
            echo -e "  ${GREEN}✓ Pulled${NC}"
        else
            echo -e "  ${RED}✗ Pull failed${NC}"
            ((FAILED++))
            continue
        fi
        
        # Push if needed
        if [[ -n $(git log @{u}.. 2>/dev/null) ]]; then
            if git push 2>/dev/null; then
                echo -e "  ${GREEN}✓ Pushed${NC}"
            else
                echo -e "  ${RED}✗ Push failed${NC}"
                ((FAILED++))
                continue
            fi
        fi
        
        ((SYNCED++))
        echo ""
    fi
done

echo -e "${GREEN}✓ Synced: $SYNCED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}✗ Failed: $FAILED${NC}"
fi
