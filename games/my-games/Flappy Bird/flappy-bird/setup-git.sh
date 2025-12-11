#!/bin/bash
# Git Setup Script for Flappy Bird Project
# Initializes Git repository with LFS support

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔧 Setting up Git repository for Flappy Bird...${NC}\n"

# Check if already initialized
if [ -d .git ]; then
    echo -e "${YELLOW}⚠️  Git repository already initialized${NC}"
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Initialize Git
if [ ! -d .git ]; then
    echo -e "${GREEN}✓${NC} Initializing Git repository..."
    git init
fi

# Check for Git LFS
if ! command -v git-lfs &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git LFS not installed${NC}"
    echo "Install with: brew install git-lfs"
    read -p "Continue without Git LFS? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC} Installing Git LFS hooks..."
    git lfs install
fi

# Set up initial branch
echo -e "${GREEN}✓${NC} Setting default branch to 'main'..."
git checkout -b main 2>/dev/null || git checkout main 2>/dev/null || true

# Add all files
echo -e "${GREEN}✓${NC} Staging project files..."
git add .

# Create initial commit
echo -e "${GREEN}✓${NC} Creating initial commit..."
git commit -m "Initial commit: Flappy Bird project structure

- Added project directory structure
- Configured .gitignore for Godot
- Added Git LFS configuration
- Created README and export script
- Set up empty asset directories"

echo ""
echo -e "${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Git repository initialized successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Add remote repository:"
echo "     git remote add origin <your-repo-url>"
echo ""
echo "  2. Push to remote:"
echo "     git push -u origin main"
echo ""
echo "  3. Start developing in Godot!"
echo ""
