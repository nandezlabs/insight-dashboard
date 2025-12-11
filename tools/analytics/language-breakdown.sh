#!/bin/bash
set -euo pipefail
# Language Breakdown - Show language distribution
# Usage: ./language-breakdown.sh

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔤 Language Breakdown${NC}\n"

# Validate projects directory exists
if [ ! -d "${HOME}/Developer/projects" ]; then
    echo "Error: Projects directory not found" >&2
    exit 1
fi

cd "${HOME}/Developer/projects"

declare -A LANG_LINES

# Count lines by language
for PROJECT in *; do
    if [ -d "${PROJECT}" ]; then
        cd "${PROJECT}"

        # JavaScript/TypeScript
        JS_LINES=$(find . -type f \( -name "*.js" -o -name "*.jsx" \) \
            ! -path "*/node_modules/*" ! -path "*/dist/*" \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
        [ -n "${JS_LINES}" ] && [ "${JS_LINES}" != "0" ] && ((LANG_LINES[JavaScript]+=${JS_LINES}))

        TS_LINES=$(find . -type f \( -name "*.ts" -o -name "*.tsx" \) \
            ! -path "*/node_modules/*" ! -path "*/dist/*" \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
        [ -n "${TS_LINES}" ] && [ "${TS_LINES}" != "0" ] && ((LANG_LINES[TypeScript]+=${TS_LINES}))

        # Python
        PY_LINES=$(find . -type f -name "*.py" \
            ! -path "*/.venv/*" ! -path "*/venv/*" \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
        [ -n "${PY_LINES}" ] && [ "${PY_LINES}" != "0" ] && ((LANG_LINES[Python]+=${PY_LINES}))

        # Shell
        SH_LINES=$(find . -type f -name "*.sh" \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
        [ -n "${SH_LINES}" ] && [ "${SH_LINES}" != "0" ] && ((LANG_LINES[Shell]+=${SH_LINES}))

        cd ..
    fi
done

# Display results
TOTAL=0
for LANG in "${!LANG_LINES[@]}"; do
    LINES=${LANG_LINES[$LANG]}
    ((TOTAL+=LINES))
done

if [ "${TOTAL}" -gt 0 ]; then
    for LANG in "${!LANG_LINES[@]}"; do
        LINES=${LANG_LINES[$LANG]}
        PERCENT=$((LINES * 100 / TOTAL))
        printf "%-15s %10s lines (%2s%%)\n" "${LANG}" "${LINES}" "${PERCENT}"
    done
fi

echo ""
echo -e "${GREEN}Total: ${TOTAL} lines${NC}"
