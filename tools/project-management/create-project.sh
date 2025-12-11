#!/bin/bash
# Automated New Project Setup Script
# Creates a new project following nandezlabs conventions

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 nandezlabs Project Creator${NC}\n"

# Step 1: Get project details
echo -e "${YELLOW}Project Details:${NC}"
read -p "Project name (lowercase, use hyphens): " PROJECT_NAME
read -p "Project description: " PROJECT_DESC

echo -e "\n${YELLOW}Project Status:${NC}"
echo "1) prod - Production (external release)"
echo "2) learn - Learning/Exploring"
echo "3) personal - Personal use"
echo "4) explore - Experimental"
read -p "Select status (1-4): " STATUS_NUM

case $STATUS_NUM in
    1) STATUS="prod" ;;
    2) STATUS="learn" ;;
    3) STATUS="personal" ;;
    4) STATUS="explore" ;;
    *) echo "Invalid selection"; exit 1 ;;
esac

echo -e "\n${YELLOW}Platform Type:${NC}"
echo "1) web - Web Application"
echo "2) ios - iOS Application"
echo "3) game - Game"
echo "4) mobile - Mobile App"
echo "5) api - API/Backend"
echo "6) cli - Command Line Tool"
read -p "Select platform (1-6): " PLATFORM_NUM

case $PLATFORM_NUM in
    1) PLATFORM="web" ;;
    2) PLATFORM="ios" ;;
    3) PLATFORM="game" ;;
    4) PLATFORM="mobile" ;;
    5) PLATFORM="api" ;;
    6) PLATFORM="cli" ;;
    *) echo "Invalid selection"; exit 1 ;;
esac

# Generate repo name
REPO_NAME="${STATUS}-${PLATFORM}-${PROJECT_NAME}"

echo -e "\n${GREEN}Repository will be created as:${NC} $REPO_NAME"
read -p "Continue? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

# Step 2: Create directory
PROJECT_DIR="$HOME/Developer/$REPO_NAME"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo -e "\n${BLUE}📁 Created project directory${NC}"

# Step 3: Initialize Git with main + develop branches
git init
git config core.hooksPath .git-hooks

# Create hooks directory
mkdir -p .git-hooks

# Copy auto-push hooks
cat > .git-hooks/post-commit << 'EOF'
#!/bin/bash
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
if [ "$CURRENT_BRANCH" = "main" ]; then
    echo "🚀 Auto-pushing to GitHub..."
    git push origin main --tags 2>/dev/null || echo "⚠️  No remote configured yet"
fi
exit 0
EOF

cat > .git-hooks/pre-commit << 'EOF'
#!/bin/bash
VERSION_CHANGED=$(git diff --cached --name-only | grep -E 'package\.json$')
if [ -n "$VERSION_CHANGED" ]; then
    echo "🔖 Version bump detected"
fi
exit 0
EOF

chmod +x .git-hooks/*

echo -e "${BLUE}✅ Git hooks configured${NC}"

# Step 4: Create README
cat > README.md << EOF
# $REPO_NAME

$PROJECT_DESC

## Status
- **Type**: $STATUS
- **Platform**: $PLATFORM
- **Created**: $(date +%Y-%m-%d)

## Quick Start

\`\`\`bash
# Install dependencies
npm install

# Run development server
npm run dev
\`\`\`

## Tech Stack

- [ ] Add your tech stack here

## Features

- [ ] List features here

## Development

### Branch Strategy
- \`main\` - Production-ready code (auto-pushes to GitHub)
- \`develop\` - Daily development work (local only)
- \`feature/*\` - Feature branches

### Commit Convention
\`\`\`
feat: Add new feature
fix: Bug fix
docs: Documentation
style: Formatting
refactor: Code restructuring
test: Tests
chore: Maintenance
\`\`\`

## License

MIT
EOF

# Step 5: Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Environment
.env
.env.local
.env.*.local

# Build
dist/
build/
.next/
out/

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
.idea/
.DS_Store

# Logs
*.log
npm-debug.log*

# Cache
.cache/
.eslintcache
*.tsbuildinfo

# OS
Thumbs.db
EOF

# Step 6: Create package.json based on platform
if [ "$PLATFORM" = "web" ] || [ "$PLATFORM" = "mobile" ]; then
cat > package.json << EOF
{
  "name": "$REPO_NAME",
  "version": "0.1.0",
  "description": "$PROJECT_DESC",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest"
  },
  "keywords": ["$STATUS", "$PLATFORM"],
  "author": "nandezlabs",
  "license": "MIT"
}
EOF
fi

# Step 7: Initial commit on main branch
git add .
git commit -m "Initial commit: $REPO_NAME

- Project structure initialized
- README and .gitignore configured
- Git hooks for auto-push set up
- Type: $STATUS
- Platform: $PLATFORM"

# Step 8: Create develop branch
git checkout -b develop

echo -e "\n${GREEN}✅ Local repository initialized${NC}"

# Step 9: Create GitHub repo
echo -e "\n${YELLOW}Creating GitHub repository...${NC}"

gh repo create "nandezlabs/$REPO_NAME" \
    --description "$PROJECT_DESC" \
    --public \
    --source=. \
    --remote=origin

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ GitHub repository created${NC}"
    
    # Step 10: Set topics
    TOPICS="$STATUS,$PLATFORM"
    gh repo edit "nandezlabs/$REPO_NAME" --add-topic "$TOPICS"
    
    # Step 11: Push main branch
    git checkout main
    git push -u origin main
    git checkout develop
    
    echo -e "\n${GREEN}🎉 Project setup complete!${NC}"
    echo -e "${BLUE}Repository: https://github.com/nandezlabs/$REPO_NAME${NC}"
    echo -e "${BLUE}Local path: $PROJECT_DIR${NC}"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo "1. cd $PROJECT_DIR"
    echo "2. Start coding on 'develop' branch"
    echo "3. Merge to 'main' when ready to push to GitHub"
else
    echo -e "${YELLOW}⚠️  GitHub CLI not found or authentication needed${NC}"
    echo -e "Manual steps:"
    echo "1. Go to https://github.com/new"
    echo "2. Create repo: $REPO_NAME"
    echo "3. Run: git remote add origin git@github.com:nandezlabs/$REPO_NAME.git"
    echo "4. Run: git push -u origin main"
fi

# Open in VS Code
if command -v code &> /dev/null; then
    read -p "Open in VS Code? (y/n): " OPEN_VSCODE
    if [ "$OPEN_VSCODE" = "y" ]; then
        code "$PROJECT_DIR"
    fi
fi
