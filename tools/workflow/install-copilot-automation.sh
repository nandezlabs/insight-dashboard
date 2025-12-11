#!/bin/bash
set -euo pipefail
# =====================================================================
# Install Copilot Daily Reset Automation
# Sets up launchd service for macOS
# =====================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST_FILE="${SCRIPT_DIR}/com.developer.copilot-daily-reset.plist"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
DEST_PLIST="${LAUNCH_AGENTS_DIR}/com.developer.copilot-daily-reset.plist"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🤖 Copilot Daily Reset - Automation Installer${NC}"
echo ""
echo "This will set up automatic daily Copilot permission resets."
echo ""
echo "Options:"
echo "  1) Install launchd service (runs daily at 9 AM)"
echo "  2) Uninstall launchd service"
echo "  3) Check status"
echo "  4) Cancel"
echo ""

read -p "Choose option (1-4): " choice

case "${choice}" in
    1)
        echo ""
        echo "Installing launchd service..."

        # Validate plist file exists
        if [ ! -f "${PLIST_FILE}" ]; then
            echo -e "${RED}Error: Plist file not found at ${PLIST_FILE}${NC}" >&2
            exit 1
        fi

        # Create LaunchAgents directory if it doesn't exist
        if ! mkdir -p "${LAUNCH_AGENTS_DIR}"; then
            echo -e "${RED}Error: Cannot create LaunchAgents directory${NC}" >&2
            exit 1
        fi

        # Copy plist file
        if ! cp "${PLIST_FILE}" "${DEST_PLIST}"; then
            echo -e "${RED}Error: Failed to copy plist file${NC}" >&2
            exit 1
        fi

        # Load the service
        launchctl unload "${DEST_PLIST}" 2>/dev/null || true
        if launchctl load "${DEST_PLIST}"; then
            echo -e "${GREEN}✓ Automation installed successfully!${NC}"
            echo ""
            echo "The script will run daily at 9:00 AM"
            echo "It will:"
            echo "  1. Reset Copilot permissions to 'oncePerWorkspace'"
            echo "  2. Ask if you want to set to 'always' for the day"
            echo ""
            echo "Logs: /tmp/copilot-daily-reset.log"
        else
            echo -e "${RED}✗ Installation failed${NC}" >&2
            rm -f "${DEST_PLIST}"  # Cleanup on failure
            exit 1
        fi
        ;;

    2)
        echo ""
        echo "Uninstalling launchd service..."

        if [ ! -f "${DEST_PLIST}" ]; then
            echo -e "${YELLOW}Service is not installed${NC}"
            exit 0
        fi

        launchctl unload "${DEST_PLIST}" 2>/dev/null || true
        if rm -f "${DEST_PLIST}"; then
            echo -e "${GREEN}✓ Automation uninstalled${NC}"
        else
            echo -e "${RED}Error: Failed to remove plist file${NC}" >&2
            exit 1
        fi
        ;;

    3)
        echo ""
        if [ -f "${DEST_PLIST}" ]; then
            echo -e "${GREEN}✓ Service is installed${NC}"
            echo ""
            echo "Status:"
            if launchctl list | grep -q copilot-daily-reset; then
                echo -e "  ${GREEN}Running${NC}"
            else
                echo -e "  ${YELLOW}Not currently loaded${NC}"
            fi
            echo ""
            echo "Location: ${DEST_PLIST}"
            echo "Schedule: Daily at 9:00 AM"
            echo ""
            echo "Recent logs:"
            if [ -f "/tmp/copilot-daily-reset.log" ]; then
                tail -5 "/tmp/copilot-daily-reset.log" 2>/dev/null || echo "  No logs available"
            else
                echo "  No logs yet"
            fi
        else
            echo -e "${YELLOW}Service is not installed${NC}"
        fi
        ;;

    4)
        echo "Cancelled"
        exit 0
        ;;

    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}Note:${NC} VS Code workspace also auto-checks on startup (once per day)"
