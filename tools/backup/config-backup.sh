#!/bin/bash
set -euo pipefail
# Config Backup - Backup shell configs and VS Code settings
# Usage: ./config-backup.sh

BACKUP_DIR="${HOME}/Developer/archive/config-backups"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
BACKUP_PATH="${BACKUP_DIR}/config_${TIMESTAMP}"

mkdir -p "${BACKUP_PATH}"

echo "⚙️  Backing up configurations..."

# Backup shell configs
echo "  → Shell configs..."
cp ~/.zshrc "${BACKUP_PATH}/zshrc.backup" 2>/dev/null || true
cp ~/.bashrc "${BACKUP_PATH}/bashrc.backup" 2>/dev/null || true
cp ~/.bash_profile "${BACKUP_PATH}/bash_profile.backup" 2>/dev/null || true

# Backup git config
echo "  → Git config..."
cp ~/.gitconfig "${BACKUP_PATH}/gitconfig.backup" 2>/dev/null || true
cp ~/.gitignore_global "${BACKUP_PATH}/gitignore_global.backup" 2>/dev/null || true

# Backup VS Code settings
echo "  → VS Code settings..."
if [ -d "${HOME}/Library/Application Support/Code/User" ]; then
    cp "${HOME}/Library/Application Support/Code/User/settings.json" "${BACKUP_PATH}/vscode_settings.json" 2>/dev/null || true
    cp "${HOME}/Library/Application Support/Code/User/keybindings.json" "${BACKUP_PATH}/vscode_keybindings.json" 2>/dev/null || true
fi

# Backup SSH config
echo "  → SSH config..."
cp ~/.ssh/config "${BACKUP_PATH}/ssh_config.backup" 2>/dev/null || true

# Create list of installed brew packages
echo "  → Homebrew packages..."
brew list > "${BACKUP_PATH}/brew_packages.txt" 2>/dev/null || true

# Create list of global npm packages
echo "  → npm packages..."
npm list -g --depth=0 > "${BACKUP_PATH}/npm_global_packages.txt" 2>/dev/null || true

echo "✓ Config backup complete: ${BACKUP_PATH}"
