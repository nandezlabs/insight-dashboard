#!/bin/bash

# =============================================================================
# Launch Cleanup Report Viewer - GUI Application Launcher
# =============================================================================
# Launches the Python GUI for viewing cleanup reports
# Ensures proper Python environment with tkinter support
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIEWER_SCRIPT="$SCRIPT_DIR/cleanup-report-viewer.py"

# Check if viewer exists
if [ ! -f "$VIEWER_SCRIPT" ]; then
    echo -e "${RED}✗${NC} Viewer script not found: $VIEWER_SCRIPT"
    exit 1
fi

# Try conda Python first (has tkinter)
if [ -x "/opt/anaconda3/bin/python" ]; then
    echo -e "${GREEN}✓${NC} Launching Cleanup Report Viewer with Anaconda Python..."
    /opt/anaconda3/bin/python "$VIEWER_SCRIPT"
    exit 0
fi

# Try system Python with tkinter check
if command -v python3 &> /dev/null; then
    if python3 -m tkinter &> /dev/null; then
        echo -e "${GREEN}✓${NC} Launching Cleanup Report Viewer with system Python..."
        python3 "$VIEWER_SCRIPT"
        exit 0
    else
        echo -e "${YELLOW}⚠${NC} System Python doesn't have tkinter support"
    fi
fi

# Try venv Python
VENV_PYTHON="$(dirname "$SCRIPT_DIR")/../.venv/bin/python"
if [ -x "$VENV_PYTHON" ]; then
    if $VENV_PYTHON -m tkinter &> /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Launching Cleanup Report Viewer with venv Python..."
        $VENV_PYTHON "$VIEWER_SCRIPT"
        exit 0
    fi
fi

# No suitable Python found
echo -e "${RED}✗${NC} No Python installation with tkinter support found"
echo ""
echo "Please install Python with tkinter:"
echo "  • Install Anaconda: https://www.anaconda.com/download"
echo "  • Or install tkinter: brew install python-tk@3.12"
exit 1
