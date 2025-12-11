#!/bin/bash
# Environment Checker - Verify development environment setup
# Usage: ./check-env.sh

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🔍 ENVIRONMENT CHECK                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"

check_command() {
    local CMD=$1
    local NAME=$2
    
    if command -v "$CMD" &> /dev/null; then
        VERSION=$($CMD --version 2>&1 | head -1)
        echo -e "${GREEN}✓${NC} $NAME: $VERSION"
    else
        echo -e "${RED}✗${NC} $NAME: Not installed"
    fi
}

# Core tools
echo -e "${BLUE}━━━ Core Tools ━━━${NC}"
check_command "git" "Git"
check_command "node" "Node.js"
check_command "npm" "npm"
check_command "python3" "Python"
check_command "pip3" "pip"
check_command "brew" "Homebrew"
check_command "code" "VS Code"
check_command "docker" "Docker"

echo ""

# Optional tools
echo -e "${BLUE}━━━ Optional Tools ━━━${NC}"
check_command "gh" "GitHub CLI"
check_command "conda" "Conda"
check_command "nvm" "nvm"
check_command "yarn" "Yarn"

echo ""

# Environment variables
echo -e "${BLUE}━━━ Environment ━━━${NC}"
echo -e "${BLUE}SHELL:${NC} $SHELL"
echo -e "${BLUE}PATH:${NC} $(echo $PATH | tr ':' '\n' | head -3 | tr '\n' ':')..."

echo ""

# Workspace check
echo -e "${BLUE}━━━ Workspace ━━━${NC}"
if [ -d "$HOME/Developer" ]; then
    PROJECT_COUNT=$(find "$HOME/Developer/projects" -maxdepth 1 -type d | tail -n +2 | wc -l | xargs)
    echo -e "${GREEN}✓${NC} Developer workspace: $PROJECT_COUNT projects"
else
    echo -e "${RED}✗${NC} Developer workspace: Not found"
fi

echo ""
echo -e "${GREEN}✅ Environment check complete${NC}"
