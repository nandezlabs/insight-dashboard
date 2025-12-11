#!/bin/bash
set -euo pipefail
# =====================================================================
# Daily Copilot Reset Script
# Resets Copilot permissions to 'oncePerWorkspace' at the start of day
# and prompts user if they want to set to 'always' for the day
# =====================================================================

SETTINGS_FILE="${HOME}/Library/Application Support/Code/User/settings.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_SCRIPT="${SCRIPT_DIR}/copilot-permissions.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🤖 Daily Copilot Permission Check${NC}"
echo ""

# Validate settings file exists
if [ ! -f "${SETTINGS_FILE}" ]; then
    echo -e "${RED}Error: VS Code settings file not found${NC}" >&2
    echo "Expected at: ${SETTINGS_FILE}" >&2
    exit 1
fi

# Validate copilot script exists
if [ ! -f "${COPILOT_SCRIPT}" ]; then
    echo -e "${RED}Error: Copilot permissions script not found${NC}" >&2
    exit 1
fi

# Reset to oncePerWorkspace with error handling
if ! python3 -c "
import json
import sys
import os

try:
    with open('${SETTINGS_FILE}', 'r', encoding='utf-8') as f:
        settings = json.load(f)

    if 'chat.agent.permissions' not in settings:
        settings['chat.agent.permissions'] = {}

    settings['chat.agent.permissions']['request'] = 'oncePerWorkspace'

    # Atomic write
    temp_file = '${SETTINGS_FILE}.tmp'
    with open(temp_file, 'w', encoding='utf-8') as f:
        json.dump(settings, f, indent=2, ensure_ascii=False)
        f.write('\n')

    os.replace(temp_file, '${SETTINGS_FILE}')
    sys.exit(0)

except (FileNotFoundError, json.JSONDecodeError, PermissionError, OSError) as e:
    print(f'Error: {str(e)}', file=sys.stderr)
    sys.exit(1)
"; then
    echo -e "${RED}Error: Failed to reset permissions${NC}" >&2
    exit 1
fi

echo -e "${GREEN}✓ Copilot permissions reset to 'oncePerWorkspace'${NC}"
echo ""
echo "This means Copilot will ask for permission once per workspace today."
echo ""
read -p "Do you want to set to 'always' for the entire day? (y/N): " response

case "${response}" in
    [yY][eE][sS]|[yY])
        if bash "${COPILOT_SCRIPT}" always; then
            echo ""
            echo -e "${GREEN}✓ Copilot set to 'always' for today${NC}"
            echo "You can change this anytime by running: copilot-permissions"
        else
            echo -e "${RED}Error: Failed to set 'always' mode${NC}" >&2
            exit 1
        fi
        ;;
    *)
        echo ""
        echo -e "${YELLOW}Keeping 'oncePerWorkspace' mode${NC}"
        echo "Copilot will ask once per workspace."
        ;;
esac

echo ""
echo "Tip: Run 'copilot-permissions' anytime to change modes"
