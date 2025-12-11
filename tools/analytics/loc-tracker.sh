#!/bin/bash
set -euo pipefail
# Lines of Code Tracker - Count LOC per project
# Usage: ./loc-tracker.sh

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}📊 Lines of Code by Project${NC}\n"

# Validate projects directory exists
if [ ! -d "${HOME}/Developer/projects" ]; then
    echo "Error: Projects directory not found" >&2
    exit 1
fi

cd "${HOME}/Developer/projects"

TOTAL_LINES=0

for PROJECT in *; do
    if [ -d "${PROJECT}" ]; then
        cd "${PROJECT}"
        
        # Count lines (excluding node_modules, venv, etc.)
        LINES=$(find . -type f \
            \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" -o -name "*.sh" \) \
            ! -path "*/node_modules/*" \
            ! -path "*/.venv/*" \
            ! -path "*/venv/*" \
            ! -path "*/dist/*" \
            ! -path "*/build/*" \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
        
        if [ -n "${LINES}" ] && [ "${LINES}" -gt 0 ]; then
            printf "%-30s %10s lines\n" "${PROJECT}" "${LINES}"
            ((TOTAL_LINES+=LINES))
        fi
        
        cd ..
    fi
done

echo ""
echo -e "${GREEN}Total: ${TOTAL_LINES} lines${NC}"
