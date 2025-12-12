#!/bin/bash
# VS Code Settings Backup & Restore Script
# Backs up extensions, settings, keybindings, and snippets
# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true


set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BACKUP_DIR="$HOME/Developer/vscode-backup"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

show_menu() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  VS Code Environment Manager${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    echo "1) Backup current setup"
    echo "2) Restore from backup"
    echo "3) List installed extensions"
    echo "4) Export extensions list only"
    echo "5) Install extensions from list"
    echo "6) Sync to GitHub"
    echo "7) Exit"
    echo ""
}

backup_settings() {
    echo -e "\n${YELLOW}📦 Backing up VS Code settings...${NC}\n"
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Backup settings.json
    if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
        cp "$VSCODE_USER_DIR/settings.json" "$BACKUP_DIR/settings.json"
        echo -e "${GREEN}✅ Settings backed up${NC}"
    fi
    
    # Backup keybindings.json
    if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
        cp "$VSCODE_USER_DIR/keybindings.json" "$BACKUP_DIR/keybindings.json"
        echo -e "${GREEN}✅ Keybindings backed up${NC}"
    fi
    
    # Backup snippets
    if [ -d "$VSCODE_USER_DIR/snippets" ]; then
        mkdir -p "$BACKUP_DIR/snippets"
        cp -r "$VSCODE_USER_DIR/snippets/"* "$BACKUP_DIR/snippets/" 2>/dev/null || true
        echo -e "${GREEN}✅ Snippets backed up${NC}"
    fi
    
    # Export extensions list
    code --list-extensions > "$BACKUP_DIR/extensions.txt"
    echo -e "${GREEN}✅ Extensions list exported ($(wc -l < "$BACKUP_DIR/extensions.txt") extensions)${NC}"
    
    # Create installation script
    cat > "$BACKUP_DIR/install-extensions.sh" << 'EOF'
#!/bin/bash
# Auto-generated extension installer
while IFS= read -r extension; do
    echo "Installing: $extension"
    code --install-extension "$extension" --force
done < extensions.txt
echo "✅ All extensions installed!"
EOF
    chmod +x "$BACKUP_DIR/install-extensions.sh"
    
    # Backup workspace data
    if [ -d "$VSCODE_USER_DIR/workspaceStorage" ]; then
        echo -e "${YELLOW}⚠️  Workspace storage is large. Skipping...${NC}"
    fi
    
    echo -e "\n${GREEN}✅ Backup complete!${NC}"
    echo -e "${BLUE}Location: $BACKUP_DIR${NC}\n"
}

restore_settings() {
    echo -e "\n${YELLOW}📥 Restoring VS Code settings...${NC}\n"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}❌ No backup found at: $BACKUP_DIR${NC}"
        return 1
    fi
    
    # Restore settings.json
    if [ -f "$BACKUP_DIR/settings.json" ]; then
        cp "$BACKUP_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
        echo -e "${GREEN}✅ Settings restored${NC}"
    fi
    
    # Restore keybindings.json
    if [ -f "$BACKUP_DIR/keybindings.json" ]; then
        cp "$BACKUP_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
        echo -e "${GREEN}✅ Keybindings restored${NC}"
    fi
    
    # Restore snippets
    if [ -d "$BACKUP_DIR/snippets" ]; then
        mkdir -p "$VSCODE_USER_DIR/snippets"
        cp -r "$BACKUP_DIR/snippets/"* "$VSCODE_USER_DIR/snippets/"
        echo -e "${GREEN}✅ Snippets restored${NC}"
    fi
    
    # Install extensions
    if [ -f "$BACKUP_DIR/extensions.txt" ]; then
        echo -e "\n${YELLOW}📦 Installing extensions...${NC}"
        while IFS= read -r extension; do
            echo "Installing: $extension"
            code --install-extension "$extension" --force
        done < "$BACKUP_DIR/extensions.txt"
        echo -e "${GREEN}✅ Extensions installed${NC}"
    fi
    
    echo -e "\n${GREEN}✅ Restore complete!${NC}\n"
}

list_extensions() {
    echo -e "\n${BLUE}📦 Installed Extensions:${NC}\n"
    code --list-extensions | while read ext; do
        echo "  • $ext"
    done
    echo ""
}

export_extensions() {
    code --list-extensions > "$BACKUP_DIR/extensions.txt"
    echo -e "\n${GREEN}✅ Extensions exported to: $BACKUP_DIR/extensions.txt${NC}\n"
}

install_from_list() {
    if [ ! -f "$BACKUP_DIR/extensions.txt" ]; then
        echo -e "${RED}❌ No extensions.txt found${NC}"
        return 1
    fi
    
    echo -e "\n${YELLOW}📦 Installing extensions from list...${NC}\n"
    bash "$BACKUP_DIR/install-extensions.sh"
}

sync_to_github() {
    echo -e "\n${YELLOW}🔄 Syncing to GitHub...${NC}\n"
    
    # Create Git repo in backup directory
    cd "$BACKUP_DIR"
    
    if [ ! -d ".git" ]; then
        git init
        echo -e "${GREEN}✅ Git initialized${NC}"
    fi
    
    # Create README
    cat > README.md << EOF
# VS Code Settings Backup

**Last Updated**: $(date)
**Extensions**: $(wc -l < extensions.txt)

## Quick Restore

\`\`\`bash
# Clone this repo
git clone <your-repo-url> ~/Developer/vscode-backup

# Run restore
cd ~/Developer
./manage-vscode.sh
# Choose option 2 (Restore from backup)
\`\`\`

## Manual Restore

\`\`\`bash
# Install extensions
bash install-extensions.sh

# Copy settings
cp settings.json ~/Library/Application\\ Support/Code/User/
cp keybindings.json ~/Library/Application\\ Support/Code/User/
cp -r snippets/* ~/Library/Application\\ Support/Code/User/snippets/
\`\`\`
EOF
    
    git add .
    git commit -m "Update VS Code settings - $(date +%Y-%m-%d)" || true
    
    echo -e "\n${GREEN}✅ Changes committed locally${NC}"
    echo -e "${YELLOW}To push to GitHub:${NC}"
    echo "  1. Create repo: https://github.com/new"
    echo "  2. Run: cd $BACKUP_DIR"
    echo "  3. Run: git remote add origin <your-repo-url>"
    echo "  4. Run: git push -u origin main"
    echo ""
}

# Main loop
while true; do
    show_menu
    read -p "Select option (1-7): " choice
    
    case $choice in
        1) backup_settings ;;
        2) restore_settings ;;
        3) list_extensions ;;
        4) export_extensions ;;
        5) install_from_list ;;
        6) sync_to_github ;;
        7) echo -e "\n${GREEN}👋 Goodbye!${NC}\n"; exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
    
    read -p "Press Enter to continue..."
done
