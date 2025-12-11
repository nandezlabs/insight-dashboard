# Multi-Root Workspace Guide

## 🚀 Quick Start

### Open the Workspace
```bash
# Option 1: From terminal
cd ~/Developer
open developer.code-workspace

# Option 2: In VS Code
File → Open Workspace from File → Select developer.code-workspace

# Option 3: From Finder
Double-click developer.code-workspace
```

### Workspace Structure

The workspace includes these folders as separate roots:
- 🏠 **Developer (Root)** - Main workspace folder
- 📦 **Projects** - Active development projects
- 🔧 **Tools** - Development scripts and utilities
- 🎮 **Games** - Game development projects
- 📄 **Docs** - Documentation
- 📋 **Templates** - Project templates
- 💡 **Insight** - Web app project (direct access)
- 🐍 **D280 Python** - Python coursework (direct access)
- 📓 **Python Notebooks** - Jupyter notebooks (direct access)
- 🕹️ **My Games** - Your game projects (direct access)

## ✨ Benefits

### 1. **Multi-Project Navigation**
- All projects visible in one sidebar
- Each folder has its own file tree
- Easy switching between projects

### 2. **Workspace-Level Search**
- Search across all folders at once
- Or search within specific folder
- Find references across projects

### 3. **Unified Settings**
- Consistent configuration across all folders
- Per-folder overrides still work
- Shared extensions and tasks

### 4. **Quick Tasks**
Access workspace tasks with `Cmd+Shift+P` → "Tasks: Run Task":
- 🚀 Quick: New Project
- 📊 Quick: Code Stats
- 💾 Quick: Backup Config
- 🧹 Quick: Clean All Caches
- 🔍 Quick: Search TODO Comments

### 5. **Context Switching**
- Work on web app and game simultaneously
- Edit tools while testing in projects
- Update docs alongside code

## 💡 Usage Tips

### Switch Between Folders
- Click folder name in sidebar to focus
- Use `Cmd+K Cmd+O` to quick open folders
- Terminal automatically uses correct context

### File Nesting Enabled
Related files are grouped:
- `app.ts` → app.js, app.d.ts, app.test.ts
- `package.json` → package-lock.json, yarn.lock
- `pyproject.toml` → poetry.lock, requirements.txt

### Terminal Context
Each terminal opens in the correct folder context based on active file

### Search Scoping
Right-click a folder → "Find in Folder" to limit search scope

## 🎯 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Open File | `Cmd+P` |
| Search in Workspace | `Cmd+Shift+F` |
| Run Task | `Cmd+Shift+P` → Tasks |
| Switch Terminal | `Ctrl+` ` |
| Toggle Sidebar | `Cmd+B` |
| Quick Open Folder | `Cmd+K Cmd+O` |

## 🔧 Customization

### Add More Folders
```json
{
  "folders": [
    {
      "name": "📁 New Project",
      "path": "path/to/project"
    }
  ]
}
```

### Folder-Specific Settings
Each folder can have its own `.vscode/settings.json` that overrides workspace settings.

### Save Workspace State
VS Code remembers:
- Open files
- Editor layout
- Terminal sessions
- Breakpoints

## 📝 Notes

- Settings in `developer.code-workspace` apply to all folders
- Individual `.vscode/settings.json` files still work and override workspace settings
- The workspace file is version-controlled for easy setup on other machines
- You can create multiple workspace files for different contexts (e.g., work, personal, learning)

## 🎨 Alternative Workspace Files

You can create specialized workspaces:

### Game Development Only
```bash
# Create game-dev.code-workspace with only Games folders
```

### Web Development Only
```bash
# Create web-dev.code-workspace with only Insight and web tools
```

Each workspace configuration can have different settings, extensions, and layouts!
