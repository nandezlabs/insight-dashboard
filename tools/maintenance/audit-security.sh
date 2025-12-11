#!/bin/bash
# Audit Security - Check for vulnerabilities across all projects
# Usage: ./audit-security.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔒 Running security audits...${NC}\n"

TOTAL_VULNS=0

# Audit Node.js projects
for PROJECT in "$HOME/Developer/projects"/*; do
    if [ -f "$PROJECT/package.json" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        echo -e "${BLUE}📂 $PROJECT_NAME${NC}"
        cd "$PROJECT"
        
        # Run npm audit
        AUDIT_OUTPUT=$(npm audit --json 2>/dev/null || true)
        
        if echo "$AUDIT_OUTPUT" | grep -q '"vulnerabilities"'; then
            VULNS=$(echo "$AUDIT_OUTPUT" | grep -oP '"total":\s*\K\d+' | head -1)
            if [ "$VULNS" -gt 0 ]; then
                echo -e "  ${RED}⚠️  $VULNS vulnerabilities found${NC}"
                ((TOTAL_VULNS+=VULNS))
                npm audit fix --dry-run
            else
                echo -e "  ${GREEN}✓ No vulnerabilities${NC}"
            fi
        else
            echo -e "  ${GREEN}✓ No vulnerabilities${NC}"
        fi
        echo ""
    fi
done

# Audit Python projects (if using pip)
for PROJECT in "$HOME/Developer/projects"/*; do
    if [ -f "$PROJECT/requirements.txt" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        echo -e "${BLUE}📂 $PROJECT_NAME (Python)${NC}"
        cd "$PROJECT"
        
        # Check with pip (if safety is installed)
        if command -v safety &> /dev/null; then
            safety check -r requirements.txt || echo -e "  ${YELLOW}⚠️  Safety check failed${NC}"
        else
            echo -e "  ${YELLOW}ℹ️  Install 'safety' for Python security checks${NC}"
        fi
        echo ""
    fi
done

if [ $TOTAL_VULNS -gt 0 ]; then
    echo -e "${RED}⚠️  Total vulnerabilities: $TOTAL_VULNS${NC}"
    echo -e "${YELLOW}Run 'npm audit fix' in affected projects${NC}"
else
    echo -e "${GREEN}✅ No vulnerabilities found!${NC}"
fi
