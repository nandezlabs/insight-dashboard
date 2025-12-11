#!/bin/bash
set -euo pipefail
# =====================================================================
# Silent Copilot Daily Check
# Checks if reset has been done today, prompts if not
# =====================================================================

STATE_FILE="${HOME}/.copilot-permission-check"
TODAY=$(date +%Y-%m-%d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESET_SCRIPT="${SCRIPT_DIR}/copilot-daily-reset.sh"

# Validate reset script exists
if [ ! -f "${RESET_SCRIPT}" ]; then
    echo "Error: Reset script not found at ${RESET_SCRIPT}" >&2
    exit 1
fi

# Check if we've already run today
if [ -f "${STATE_FILE}" ]; then
    LAST_RUN=$(cat "${STATE_FILE}" 2>/dev/null || echo "")
    if [ "${LAST_RUN}" = "${TODAY}" ]; then
        # Already ran today, exit silently
        exit 0
    fi
fi

# Run the daily reset
if bash "${RESET_SCRIPT}"; then
    # Mark as done for today only if successful
    echo "${TODAY}" > "${STATE_FILE}"
else
    echo "Warning: Daily reset script failed" >&2
    exit 1
fi
