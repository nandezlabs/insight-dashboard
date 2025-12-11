#!/bin/bash
# Clean Dependencies - Remove and reinstall dependencies
# Usage: ./clean-deps.sh [project-name]

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

clean_project() {
    local PROJECT_PATH=$1
    local PROJECT_NAME=$(basename "$PROJECT_PATH")
    
    echo -e "${BLUE}🧹 Cleaning $PROJECT_NAME...${NC}"
    cd "$PROJECT_PATH"
    
    # Clean Node.js project
    if [ -f "package.json" ]; then
        echo "  Removing node_modules..."
        rm -rf node_modules
        rm -f package-lock.json
        
        echo "  Reinstalling..."
        npm install
        echo -e "  ${GREEN}✓ Node.js deps cleaned${NC}"
    fi
    
    # Clean Python project
    if [ -f "requirements.txt" ]; then
        echo "  Removing virtual environment..."
        rm -rf venv .venv env
        
        echo "  Creating new venv..."
        python3 -m venv venv
        source venv/bin/activate
        pip install -r requirements.txt
        deactivate
        echo -e "  ${GREEN}✓ Python deps cleaned${NC}"
    fi
    
    echo ""
}

if [ -n "$1" ]; then
    # Clean specific project
    PROJECT_PATH="$HOME/Developer/projects/$1"
    if [ -d "$PROJECT_PATH" ]; then
        clean_project "$PROJECT_PATH"
    else
        echo -e "${RED}❌ Project not found: $1${NC}"
        exit 1
    fi
else
    # Clean all projects
    echo -e "${YELLOW}⚠️  This will clean ALL projects. Continue? (y/N)${NC}"
    read -r CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        for PROJECT in "$HOME/Developer/projects"/*; do
            if [ -d "$PROJECT" ]; then
                clean_project "$PROJECT"
            fi
        done
        echo -e "${GREEN}✅ All projects cleaned!${NC}"
    else
        echo "Cancelled."
    fi
fi
