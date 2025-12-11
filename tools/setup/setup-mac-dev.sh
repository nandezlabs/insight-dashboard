#!/bin/bash
set -euo pipefail
# Mac Developer Environment - Full Setup Script
# Sets up everything you need after a fresh macOS install or upgrade

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Mac Developer Environment Setup${NC}"
echo -e "${BLUE}  nandezlabs Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check if running on macOS
if [[ "${OSTYPE}" != "darwin"* ]]; then
    echo -e "${RED}❌ This script is for macOS only${NC}" >&2
    exit 1
fi

echo -e "${YELLOW}This will install:${NC}"
echo "  • Homebrew (package manager)"
echo "  • Git & GitHub CLI"
echo "  • Node.js & npm"
echo "  • VS Code"
echo "  • VS Code extensions"
echo "  • Development tools"
echo ""
read -p "Continue? (y/n): " CONFIRM

if [ "${CONFIRM}" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "\n${BLUE}━━━ Step 1: Homebrew ━━━${NC}\n"

if command_exists brew; then
    echo -e "${GREEN}✅ Homebrew already installed${NC}"
    brew update
else
    echo -e "${YELLOW}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo -e "${GREEN}✅ Homebrew installed${NC}"
fi

echo -e "\n${BLUE}━━━ Step 2: Git & GitHub CLI ━━━${NC}\n"

if command_exists git; then
    echo -e "${GREEN}✅ Git already installed ($(git --version))${NC}"
else
    brew install git
    echo -e "${GREEN}✅ Git installed${NC}"
fi

if command_exists gh; then
    echo -e "${GREEN}✅ GitHub CLI already installed${NC}"
else
    brew install gh
    echo -e "${GREEN}✅ GitHub CLI installed${NC}"
fi

echo -e "\n${YELLOW}🔐 Authenticate with GitHub?${NC}"
read -p "Run 'gh auth login' now? (y/n): " AUTH_GH
if [ "$AUTH_GH" = "y" ]; then
    gh auth login
fi

echo -e "\n${BLUE}━━━ Step 3: Node.js & npm ━━━${NC}\n"

if command_exists node; then
    echo -e "${GREEN}✅ Node.js already installed ($(node --version))${NC}"
else
    brew install node
    echo -e "${GREEN}✅ Node.js installed${NC}"
fi

if command_exists npm; then
    echo -e "${GREEN}✅ npm already installed ($(npm --version))${NC}"
else
    echo -e "${RED}❌ npm not found (should come with Node.js)${NC}"
fi

echo -e "\n${BLUE}━━━ Step 4: VS Code ━━━${NC}\n"

if command_exists code; then
    echo -e "${GREEN}✅ VS Code already installed${NC}"
else
    brew install --cask visual-studio-code
    echo -e "${GREEN}✅ VS Code installed${NC}"
fi

echo -e "\n${BLUE}━━━ Step 5: Essential Development Tools ━━━${NC}\n"

TOOLS=(
    "wget"           # Download utility
    "tree"           # Directory tree viewer
    "jq"             # JSON processor
    "fzf"            # Fuzzy finder
    "ripgrep"        # Fast grep alternative
    "bat"            # Better cat
    "exa"            # Better ls
)

for tool in "${TOOLS[@]}"; do
    if command_exists "$tool"; then
        echo -e "${GREEN}✅ $tool already installed${NC}"
    else
        brew install "$tool"
        echo -e "${GREEN}✅ $tool installed${NC}"
    fi
done

echo -e "\n${BLUE}━━━ Step 6: VS Code Extensions ━━━${NC}\n"

# Check if extensions backup exists
BACKUP_DIR="$HOME/Developer/vscode-backup"
if [ -f "$BACKUP_DIR/extensions.txt" ]; then
    echo -e "${YELLOW}📦 Found extensions backup. Install from backup? (y/n):${NC} "
    read INSTALL_BACKUP
    
    if [ "$INSTALL_BACKUP" = "y" ]; then
        while IFS= read -r extension; do
            echo "Installing: $extension"
            code --install-extension "$extension" --force
        done < "$BACKUP_DIR/extensions.txt"
        echo -e "${GREEN}✅ Extensions installed from backup${NC}"
    fi
else
    echo -e "${YELLOW}Installing essential extensions...${NC}"
    
    EXTENSIONS=(
        "rangav.vscode-thunder-client"
        "eamodio.gitlens"
        "ms-vscode.live-server"
        "usernamehw.errorlens"
        "esbenp.prettier-vscode"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
        "formulahendry.auto-rename-tag"
        "christian-kohler.path-intellisense"
        "wix.vscode-import-cost"
        "alefragnani.project-manager"
        "Gruntfuggly.todo-tree"
        "mhutchie.git-graph"
        "ms-azuretools.vscode-docker"
        "mtxr.sqltools"
        "humao.rest-client"
    )
    
    for ext in "${EXTENSIONS[@]}"; do
        echo "Installing: $ext"
        code --install-extension "$ext" --force
    done
    
    echo -e "${GREEN}✅ Essential extensions installed${NC}"
fi

echo -e "\n${BLUE}━━━ Step 7: Git Configuration ━━━${NC}\n"

if [ -z "$(git config --global user.name)" ]; then
    read -p "Git username: " GIT_NAME
    git config --global user.name "$GIT_NAME"
fi

if [ -z "$(git config --global user.email)" ]; then
    read -p "Git email: " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
fi

# Set up helpful git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'

echo -e "${GREEN}✅ Git configured${NC}"
echo -e "   Name: $(git config --global user.name)"
echo -e "   Email: $(git config --global user.email)"

echo -e "\n${BLUE}━━━ Step 8: Shell Enhancements ━━━${NC}\n"

# Add useful aliases to .zshrc
if ! grep -q "# nandezlabs aliases" ~/.zshrc 2>/dev/null; then
    cat >> ~/.zshrc << 'EOF'

# nandezlabs aliases
alias ll='exa -la --icons'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias code-backup='~/Developer/manage-vscode.sh'
alias new-project='~/Developer/create-project.sh'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all'

# Quick navigation
alias workspace='cd ~/Developer'
alias insight='cd ~/Developer/Insight'

EOF
    echo -e "${GREEN}✅ Shell aliases added${NC}"
else
    echo -e "${GREEN}✅ Shell already configured${NC}"
fi

echo -e "\n${BLUE}━━━ Step 9: Create Workspace Structure ━━━${NC}\n"

WORKSPACE_DIR="$HOME/Developer"
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR/production"
mkdir -p "$WORKSPACE_DIR/learning"
mkdir -p "$WORKSPACE_DIR/personal"
mkdir -p "$WORKSPACE_DIR/exploring"

echo -e "${GREEN}✅ Workspace directories created${NC}"

echo -e "\n${BLUE}━━━ Step 10: VS Code Settings Sync ━━━${NC}\n"

if [ -f "$BACKUP_DIR/settings.json" ]; then
    echo -e "${YELLOW}Restore VS Code settings from backup? (y/n):${NC} "
    read RESTORE_SETTINGS
    
    if [ "$RESTORE_SETTINGS" = "y" ]; then
        ~/Developer/manage-vscode.sh
    fi
fi

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ Setup Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BLUE}📋 Summary:${NC}"
echo "  ✅ Homebrew installed"
echo "  ✅ Git & GitHub CLI configured"
echo "  ✅ Node.js & npm installed"
echo "  ✅ VS Code installed"
echo "  ✅ Essential extensions installed"
echo "  ✅ Development tools installed"
echo "  ✅ Shell configured"
echo "  ✅ Workspace structure created"

echo -e "\n${YELLOW}🚀 Next Steps:${NC}"
echo "  1. Restart terminal (or run: source ~/.zshrc)"
echo "  2. Authenticate GitHub: gh auth login"
echo "  3. Create new project: new-project"
echo "  4. Backup VS Code: code-backup"

echo -e "\n${BLUE}📁 Useful Commands:${NC}"
echo "  workspace    - Go to workspace directory"
echo "  new-project  - Create new project"
echo "  code-backup  - Backup VS Code settings"
echo "  ll           - Better ls with icons"
echo "  gs           - Git status"

echo -e "\n${GREEN}Happy coding! 🎉${NC}\n"
