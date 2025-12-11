#!/bin/bash
set -euo pipefail
# Commit Stats - Show commit activity per project
# Usage: ./commit-stats.sh [days]

DAYS=${1:-30}

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}📈 Commit Activity (Last ${DAYS} days)${NC}\n"

# Validate projects directory exists
if [ ! -d "${HOME}/Developer/projects" ]; then
    echo "Error: Projects directory not found" >&2
    exit 1
fi

cd "${HOME}/Developer/projects"

TOTAL_COMMITS=0

for PROJECT in *; do
    if [ -d "${PROJECT}/.git" ]; then
        cd "${PROJECT}"
        
        COMMITS=$(git log --since="${DAYS} days ago" --oneline 2>/dev/null | wc -l | xargs)
        
        if [ "${COMMITS}" -gt 0 ]; then
            printf "%-30s %5s commits\n" "${PROJECT}" "${COMMITS}"
            ((TOTAL_COMMITS+=COMMITS))
        fi
        
        cd ..
    fi
done

echo ""
echo -e "${GREEN}Total: ${TOTAL_COMMITS} commits${NC}"
# Handle division by zero
if [ "${DAYS}" -gt 0 ]; then
    echo -e "${BLUE}Average: $((TOTAL_COMMITS / DAYS)) commits/day${NC}"
fi
