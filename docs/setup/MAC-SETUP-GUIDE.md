# Mac Developer Environment - Quick Reference

**Created**: December 8, 2025  
**For**: Mac upgrades and fresh installs

---

## 🚀 Quick Setup (After Mac Upgrade)

### One-Command Setup:

```bash
bash ~/Developer/setup-mac-dev.sh
```

This installs everything you need:

- Homebrew
- Git & GitHub CLI
- Node.js & npm
- VS Code
- All your extensions
- Development tools
- Shell configuration

---

## 📦 VS Code Backup & Restore

### Backup Current Setup:

```bash
~/Developer/manage-vscode.sh
# Choose option 1: Backup current setup
```

### Restore on New Mac:

```bash
~/Developer/manage-vscode.sh
# Choose option 2: Restore from backup
```

### What Gets Backed Up:

- ✅ All extensions (with one-click install)
- ✅ settings.json
- ✅ keybindings.json
- ✅ Code snippets
- ✅ Auto-install script

**Backup Location**: `~/Developer/vscode-backup/`

---

## 🔧 Essential Scripts

### 1. `setup-mac-dev.sh`

**Purpose**: Full Mac developer environment setup  
**Use when**: Fresh install or major upgrade  
**What it does**:

- Installs Homebrew, Git, Node.js, VS Code
- Installs all development tools
- Configures shell aliases
- Sets up workspace structure

```bash
bash ~/Developer/setup-mac-dev.sh
```

### 2. `manage-vscode.sh`

**Purpose**: Backup and restore VS Code  
**Use when**: Before upgrade or on new machine  
**Options**:

1. Backup current setup
2. Restore from backup
3. List installed extensions
4. Export extensions only
5. Install extensions from list
6. Sync to GitHub

```bash
~/Developer/manage-vscode.sh
```

### 3. `create-project.sh`

**Purpose**: Create new projects with conventions  
**Use when**: Starting any new project  
**What it does**:

- Prompts for project details
- Creates repo: `{status}-{platform}-{name}`
- Initializes Git with auto-push
- Creates GitHub repo
- Sets up documentation

```bash
~/Developer/create-project.sh
```

---

## 🗂️ Workspace Organization

```
~/Developer/
├── production/          # Production projects
├── learning/            # Learning projects
├── personal/            # Personal projects
├── exploring/           # Experimental projects
├── vscode-backup/       # VS Code settings backup
├── setup-mac-dev.sh     # Full environment setup
├── manage-vscode.sh     # VS Code manager
└── create-project.sh    # Project creator
```

---

## ⚡ Shell Aliases (Auto-configured)

After running `setup-mac-dev.sh`, you'll have:

### File Navigation:

```bash
workspace        # cd ~/Developer
insight          # cd ~/Developer/Insight
ll               # Better ls with icons (exa)
```

### Git Shortcuts:

```bash
gs               # git status
ga               # git add
gc "message"     # git commit -m "message"
gp               # git push
gl               # git log (pretty graph)
```

### Development Tools:

```bash
code-backup      # Run VS Code backup
new-project      # Create new project
cat              # bat (better cat with syntax highlighting)
grep             # ripgrep (faster grep)
```

---

## 📋 Pre-Upgrade Checklist

Before upgrading macOS:

- [ ] Run `~/Developer/manage-vscode.sh` → Backup
- [ ] Commit all Git changes
- [ ] Push all repos to GitHub
- [ ] Export browser bookmarks
- [ ] Backup `~/Developer/` folder
- [ ] List installed apps: `ls /Applications > ~/Desktop/apps-list.txt`
- [ ] Screenshot: Dock, Menu Bar, Desktop
- [ ] Backup `~/.zshrc` and `~/.gitconfig`

---

## 🔄 Post-Upgrade Steps

After macOS upgrade:

1. **Restore workspace folder**

   ```bash
   # Copy from backup or download from cloud
   cp -r /path/to/backup/workspace ~/Desktop/
   ```

2. **Run full setup**

   ```bash
   bash ~/Developer/setup-mac-dev.sh
   ```

3. **Restore VS Code**

   ```bash
   ~/Developer/manage-vscode.sh
   # Choose: Restore from backup
   ```

4. **Authenticate GitHub**

   ```bash
   gh auth login
   ```

5. **Verify Git setup**

   ```bash
   git config --global --list
   ```

6. **Test project creation**
   ```bash
   new-project
   ```

---

## 🎯 What's Already Installed

Your current setup includes:

### VS Code Extensions (16):

- Thunder Client (API testing)
- GitLens (Git superpowers)
- Live Preview (browser preview)
- Error Lens (inline errors)
- Prettier (code formatting)
- ESLint (linting)
- Tailwind CSS IntelliSense
- Auto Rename Tag
- Path Intellisense
- Import Cost
- Project Manager
- Todo Tree
- Git Graph
- Docker
- SQLTools
- REST Client

### Development Tools:

- Git & GitHub CLI
- Node.js & npm
- Homebrew
- wget, tree, jq, fzf
- ripgrep, bat, exa

### Shell Configuration:

- Custom aliases in `~/.zshrc`
- Git shortcuts
- Workspace navigation

---

## 🆘 Troubleshooting

### VS Code 'code' command not found:

```bash
# Open VS Code
# Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
```

### Extensions not installing:

```bash
# Run manually:
bash ~/Developer/vscode-backup/install-extensions.sh
```

### Git authentication issues:

```bash
# Re-authenticate
gh auth login

# Check status
gh auth status
```

### Homebrew path issues:

```bash
# Add to ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

---

## 📱 Sync to GitHub (Optional)

Keep your VS Code settings backed up on GitHub:

```bash
~/Developer/manage-vscode.sh
# Choose option 6: Sync to GitHub
# Then create GitHub repo and push
```

---

## 🎁 Bonus: VS Code Settings Sync (Built-in)

VS Code has built-in Settings Sync:

1. Click gear icon → "Turn on Settings Sync"
2. Sign in with GitHub
3. Select what to sync (Settings, Extensions, Keybindings)
4. Automatically syncs across all machines

**Recommended**: Use both (built-in sync + script backup)

---

## 📝 Quick Commands Reference

```bash
# Full environment setup
bash ~/Developer/setup-mac-dev.sh

# VS Code backup/restore
~/Developer/manage-vscode.sh

# Create new project
new-project

# Git shortcuts
gs                    # status
ga .                  # add all
gc "commit message"   # commit
gp                    # push
gl                    # log

# Navigation
workspace             # go to workspace
insight               # go to Insight project
ll                    # list files (pretty)
```

---

## 🔐 Security Notes

- GitHub authentication uses secure token storage
- VS Code settings don't contain sensitive data
- Always review backup files before syncing to GitHub
- Keep `.env` files excluded from Git

---

**Last Updated**: December 8, 2025  
**Maintained by**: nandezlabs
