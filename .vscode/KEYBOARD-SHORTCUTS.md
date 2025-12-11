# ⌨️ Custom Keyboard Shortcuts

**Quick Reference Guide for Developer Workspace**

## 🎯 Quick Tasks (Cmd+K prefix)

All custom tasks use `Cmd+K` followed by another key to avoid conflicts with VS Code defaults.

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+K` `Cmd+N` | 🚀 New Project | Launch project creation script |
| `Cmd+K` `Cmd+S` | 📊 Code Stats | View code statistics |
| `Cmd+K` `Cmd+B` | 💾 Backup Config | Backup VS Code configuration |
| `Cmd+K` `Cmd+C` | 🧹 Clean Caches | Remove all cache files |
| `Cmd+K` `Cmd+T` | 🔍 Find TODOs | Search for TODO comments |

## 🐍 Python Workflow

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+Shift+R` | ▶️ Run Python File | Execute current Python file |
| `Cmd+K` `Cmd+V` | 📦 Create Venv | Create virtual environment |
| `Cmd+K` `Cmd+I` | 📥 Install Requirements | Install requirements.txt |

## 🎮 Godot Workflow

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+Shift+G` | 🎨 Open in Godot | Open project in Godot editor |
| `Cmd+Shift+F5` | ▶️ Run Game | Launch game from VS Code |

*These work when editing .gd or .tscn files*

## 🌐 Web Development

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+K` `Cmd+D` | 🚀 Dev Server | Start NPM dev server |

## 💻 Terminal

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+J` | 🔄 Toggle Terminal | Show/hide terminal panel |
| `Ctrl+Shift+T` | ➕ New Terminal | Create new terminal |
| `Ctrl+Shift+K` | ❌ Kill Terminal | Close active terminal |
| `Ctrl+Shift+C` | 🧹 Clear Terminal | Clear terminal output |

## 📁 Sidebar Navigation

Quick access to VS Code views:

| Shortcut | View | Icon |
|----------|------|------|
| `Cmd+1` | Explorer | 📁 |
| `Cmd+2` | Search | 🔍 |
| `Cmd+3` | Source Control | 🔀 |
| `Cmd+4` | Debug | 🐛 |
| `Cmd+5` | Extensions | 🧩 |
| `Cmd+0` | Focus Sidebar | 👈 |

## 🔀 Git Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+K` `Cmd+G` | 📊 Open SCM | Open source control view |
| `Cmd+K` `Cmd+P` | ⬆️ Git Push | Push to remote |
| `Cmd+K` `Cmd+L` | ⬇️ Git Pull | Pull from remote |

## 🤖 GitHub Copilot

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Alt+\` | ✨ Generate | Trigger Copilot suggestion |
| `Alt+[` | ⬅️ Previous | Show previous suggestion |
| `Alt+]` | ➡️ Next | Show next suggestion |
| `Tab` | ✅ Accept | Accept Copilot suggestion |

## ✏️ Editor Enhancements

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+K` `Cmd+F` | 🎨 Format | Format document |
| `Cmd+Shift+L` | 🎯 Select All | Select all occurrences |
| `Cmd+D` | ➕ Add Selection | Add next match to selection |
| `Alt+Up` | ⬆️ Move Line Up | Move line/selection up |
| `Alt+Down` | ⬇️ Move Line Down | Move line/selection down |
| `Alt+Cmd+Left` | ⬅️ Previous Editor | Navigate to previous tab |
| `Alt+Cmd+Right` | ➡️ Next Editor | Navigate to next tab |

## 🪟 Split Editor

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+\` | ➗ Split Editor | Split editor vertically |
| `Cmd+K` `Left` | ⬅️ Focus Left | Focus left editor group |
| `Cmd+K` `Right` | ➡️ Focus Right | Focus right editor group |

## 🎯 Workspace Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+K` `Cmd+W` | 📂 Open Folder | Open folder in workspace |
| `Cmd+K` `Cmd+R` | 🔄 Reload Window | Reload VS Code window |
| `Cmd+K` `Cmd+X` | ❌ Close All | Close all open editors |
| `Cmd+K` `Cmd+Z` | 🧘 Zen Mode | Toggle distraction-free mode |

## 🔍 File Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Cmd+P` | 🔍 Quick Open | Open file by name |
| `Cmd+Shift+O` | 📋 Go to Symbol | Navigate to symbol in file |
| `Cmd+T` | 🔍 Go to Symbol | Navigate to symbol in workspace |

## 📝 Built-in VS Code Shortcuts (Reminders)

### Essential Default Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+S` | 💾 Save |
| `Cmd+W` | ❌ Close Tab |
| `Cmd+Shift+P` | 🎮 Command Palette |
| `Cmd+,` | ⚙️ Settings |
| `Cmd+B` | 👈 Toggle Sidebar |
| `F5` | ▶️ Start Debugging |
| `Shift+F5` | ⏹️ Stop Debugging |

## 💡 Pro Tips

### Multi-Key Shortcuts
Many custom shortcuts use `Cmd+K` as a prefix. Press `Cmd+K`, release, then press the second combination.

Example: `Cmd+K` `Cmd+N` means:
1. Press and release `Cmd+K`
2. Then press `Cmd+N`

### Context-Aware
Some shortcuts only work in specific contexts:
- Godot shortcuts: Only in `.gd` or `.tscn` files
- Python shortcuts: Only in Python files
- Terminal shortcuts: Some require terminal focus

### Cheatsheet
Print this file or keep it open in a tab for quick reference while learning the shortcuts.

### Customization
Edit [.vscode/keybindings.json](keybindings.json) to customize these shortcuts to your preference.

---

**🎯 Most Used Shortcuts to Learn First:**
1. `Cmd+K` `Cmd+N` - New Project
2. `Cmd+J` - Toggle Terminal
3. `Cmd+P` - Quick Open
4. `Cmd+1-5` - Sidebar Views
5. `Cmd+Shift+R` - Run Python File
