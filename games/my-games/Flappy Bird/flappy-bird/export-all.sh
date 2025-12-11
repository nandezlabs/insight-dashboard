#!/bin/bash
# Godot Multi-Platform Export Script
# Exports game for all configured platforms

set -e  # Exit on error

PROJECT_NAME="Flappy Bird"
BUILD_DIR="builds"
PROJECT_FILE="project.godot"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Godot is installed
if ! command -v godot &> /dev/null; then
    echo -e "${RED}❌ Godot is not installed or not in PATH${NC}"
    echo "Install with: brew install --cask godot"
    exit 1
fi

echo -e "${BLUE}🎮 Exporting $PROJECT_NAME for all platforms...${NC}\n"

# Create build directories
mkdir -p "$BUILD_DIR"/{windows,macos,linux,ios,android,web}

# Export counter
SUCCESS_COUNT=0
FAIL_COUNT=0

# Function to export platform
export_platform() {
    local platform_name=$1
    local export_name=$2
    local output_path=$3
    
    echo -e "${YELLOW}📦 Exporting ${platform_name}...${NC}"
    
    if godot --headless --export-release "$export_name" "$output_path" 2>&1 | grep -q "ERROR"; then
        echo -e "${RED}❌ Failed to export ${platform_name}${NC}"
        ((FAIL_COUNT++))
        return 1
    else
        echo -e "${GREEN}✅ ${platform_name} exported successfully${NC}"
        ((SUCCESS_COUNT++))
        return 0
    fi
}

# Windows Export
export_platform "Windows" "Windows Desktop" "$BUILD_DIR/windows/$PROJECT_NAME.exe"

# macOS Export
export_platform "macOS" "macOS" "$BUILD_DIR/macos/$PROJECT_NAME.zip"

# Linux Export
export_platform "Linux" "Linux/X11" "$BUILD_DIR/linux/$PROJECT_NAME.x86_64"

# iOS Export (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export_platform "iOS" "iOS" "$BUILD_DIR/ios/$PROJECT_NAME.ipa"
else
    echo -e "${YELLOW}⚠️  Skipping iOS export (macOS required)${NC}"
fi

# Android Export
export_platform "Android" "Android" "$BUILD_DIR/android/$PROJECT_NAME.apk"

# Web Export
export_platform "Web" "HTML5" "$BUILD_DIR/web/index.html"

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Successful exports: $SUCCESS_COUNT${NC}"
if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "${RED}❌ Failed exports: $FAIL_COUNT${NC}"
fi
echo -e "${BLUE}════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Builds available in: $BUILD_DIR/${NC}"

# Show build sizes
echo -e "\n${BLUE}Build sizes:${NC}"
du -sh "$BUILD_DIR"/* 2>/dev/null | sed 's/^/  /'

exit 0
