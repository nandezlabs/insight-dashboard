#!/bin/bash
# Update All Dependencies - Update npm, pip, and brew across all projects
# Usage: ./update-all.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔄 Updating all dependencies...${NC}\n"

# Update Homebrew
echo -e "${BLUE}📦 Updating Homebrew...${NC}"
brew update && brew upgrade
brew cleanup
echo -e "${GREEN}✓ Homebrew updated${NC}\n"

# Update global npm packages
echo -e "${BLUE}📦 Updating global npm packages...${NC}"
npm update -g
echo -e "${GREEN}✓ Global npm updated${NC}\n"

# Update all Node.js projects
echo -e "${BLUE}📦 Updating Node.js projects...${NC}"
for PROJECT in "$HOME/Developer/projects"/*; do
    if [ -f "$PROJECT/package.json" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        echo -e "${YELLOW}  → $PROJECT_NAME${NC}"
        cd "$PROJECT"
        npm update 2>/dev/null || echo "    ⚠️  npm update failed"
    fi
done
echo -e "${GREEN}✓ Node.js projects updated${NC}\n"

# Update Python packages (if using conda)
if command -v conda &> /dev/null; then
    echo -e "${BLUE}📦 Updating conda packages...${NC}"
    conda update --all -y
    echo -e "${GREEN}✓ Conda updated${NC}\n"
fi

echo -e "${GREEN}✅ All updates complete!${NC}"
