#!/bin/bash
set -euo pipefail
# =====================================================================
# Copilot Permission Manager
# Toggle between different permission modes for GitHub Copilot
# =====================================================================

SETTINGS_FILE="${HOME}/Library/Application Support/Code/User/settings.json"
BACKUP_FILE="${HOME}/Library/Application Support/Code/User/settings.json.backup"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Copilot Permission Manager${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

get_current_mode() {
    if [ ! -f "${SETTINGS_FILE}" ]; then
        echo "unknown"
        return 1
    fi

    python3 -c "
import json
import sys

try:
    with open('${SETTINGS_FILE}', 'r', encoding='utf-8') as f:
        settings = json.load(f)
    mode = settings.get('chat.agent.permissions', {}).get('request', 'unknown')
    print(mode)
except (FileNotFoundError, json.JSONDecodeError, KeyError) as e:
    print('unknown', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null || echo "unknown"
}

set_permission_mode() {
    local mode="$1"

    # Validate settings file exists
    if [ ! -f "${SETTINGS_FILE}" ]; then
        echo "Error: Settings file not found at ${SETTINGS_FILE}" >&2
        return 1
    fi

    # Validate mode
    case "${mode}" in
        always|oncePerWorkspace|eachTime|never)
            ;;
        *)
            echo "Error: Invalid mode '${mode}'" >&2
            return 1
            ;;
    esac

    # Backup current settings
    if ! cp "${SETTINGS_FILE}" "${BACKUP_FILE}" 2>/dev/null; then
        echo "Warning: Could not create backup" >&2
    fi

    # Update settings with error handling
    if python3 -c "
import json
import sys
import os

try:
    with open('${SETTINGS_FILE}', 'r', encoding='utf-8') as f:
        settings = json.load(f)

    if 'chat.agent.permissions' not in settings:
        settings['chat.agent.permissions'] = {}

    settings['chat.agent.permissions']['request'] = '${mode}'

    # Write atomically using temp file
    temp_file = '${SETTINGS_FILE}.tmp'
    with open(temp_file, 'w', encoding='utf-8') as f:
        json.dump(settings, f, indent=2, ensure_ascii=False)
        f.write('\n')  # Add final newline

    os.replace(temp_file, '${SETTINGS_FILE}')
    print('✓ Permission mode set to: ${mode}')
    sys.exit(0)

except (FileNotFoundError, json.JSONDecodeError, PermissionError, OSError) as e:
    print(f'Error: {str(e)}', file=sys.stderr)
    sys.exit(1)
"; then
        return 0
    else
        echo "Error: Failed to update settings" >&2
        return 1
    fi
}

show_current_status() {
    local current_mode=$(get_current_mode)
    echo -e "${YELLOW}Current Mode:${NC} $current_mode"
    echo ""
    echo "Available modes:"
    echo "  1) always           - Never ask, always approve"
    echo "  2) oncePerWorkspace - Ask once per workspace (recommended)"
    echo "  3) eachTime         - Ask every time"
    echo "  4) never            - Never approve automatically"
    echo ""
}

interactive_mode() {
    print_header
    show_current_status

    read -p "Select mode (1-4) or 'q' to quit: " choice

    case $choice in
        1)
            set_permission_mode "always"
            echo -e "${GREEN}✓ Copilot will now always approve without asking${NC}"
            ;;
        2)
            set_permission_mode "oncePerWorkspace"
            echo -e "${GREEN}✓ Copilot will ask once per workspace${NC}"
            ;;
        3)
            set_permission_mode "eachTime"
            echo -e "${GREEN}✓ Copilot will ask every time${NC}"
            ;;
        4)
            set_permission_mode "never"
            echo -e "${GREEN}✓ Copilot auto-approval disabled${NC}"
            ;;
        q|Q)
            echo "Cancelled"
            exit 0
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac
}

# Parse command line arguments
case "$1" in
    always|oncePerWorkspace|eachTime|never)
        set_permission_mode "$1"
        ;;
    status)
        print_header
        show_current_status
        ;;
    "")
        interactive_mode
        ;;
    *)
        echo "Usage: $0 [always|oncePerWorkspace|eachTime|never|status]"
        echo ""
        echo "Examples:"
        echo "  $0              - Interactive mode"
        echo "  $0 always       - Set to always approve"
        echo "  $0 status       - Show current mode"
        exit 1
        ;;
esac
