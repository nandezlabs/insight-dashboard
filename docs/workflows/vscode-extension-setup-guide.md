# VS Code Extensions Setup Guide

**Created:** December 10, 2025  
**Purpose:** Configure all installed extensions for optimal workflow

---

## 🎯 Quick Setup Commands

### 1. Apply Recommended Settings

Copy this to your VS Code settings (Cmd+Shift+P → "Preferences: Open User Settings (JSON)"):

```json
{
  // === EXISTING SETTINGS (Keep these) ===
  "workbench.iconTheme": "material-icon-theme",
  "editor.bracketPairColorization.enabled": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,

  // === GODOT SETTINGS ===
  "godot_tools.editor_path": "/Applications/Godot.app/Contents/MacOS/Godot",
  "godot_tools.gdscript_lsp_server_port": 6005,

  // === FILE ASSOCIATIONS ===
  "files.associations": {
    "*.gd": "gdscript",
    "*.tscn": "godot-resource",
    "*.tres": "godot-resource"
  },

  // === EXCLUDE PATTERNS (Performance) ===
  "files.exclude": {
    "**/.git": true,
    "**/.godot": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/.pytest_cache": true,
    "**/dist": true,
    "**/build": true
  },

  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/node_modules/**": true,
    "**/.godot/**": true,
    "**/builds/**": true,
    "**/__pycache__/**": true
  },

  // === EDITOR SETTINGS (8GB Mac Optimization) ===
  "editor.minimap.enabled": false,
  "editor.suggest.localityBonus": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.rulers": [80, 120],
  "editor.wordWrap": "on",
  "editor.lineNumbers": "on",
  "editor.renderWhitespace": "boundary",

  // === PRETTIER SETTINGS ===
  "prettier.semi": true,
  "prettier.singleQuote": true,
  "prettier.tabWidth": 2,
  "prettier.trailingComma": "es5",

  // === ESLINT SETTINGS ===
  "eslint.enable": true,
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],

  // === PYTHON SETTINGS ===
  "python.formatting.provider": "none",
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.insertSpaces": true
  },
  "python.linting.enabled": true,
  "python.linting.flake8Enabled": true,
  "python.analysis.typeCheckingMode": "basic",
  "isort.args": ["--profile", "black"],

  // === GDSCRIPT SETTINGS ===
  "[gdscript]": {
    "editor.insertSpaces": false,
    "editor.tabSize": 4
  },

  // === SWIFT SETTINGS ===
  "[swift]": {
    "editor.defaultFormatter": "vknabel.vscode-apple-swift-format",
    "editor.formatOnSave": true,
    "editor.tabSize": 4
  },

  // === TODO TREE ===
  "todo-tree.general.tags": ["TODO", "FIXME", "BUG", "HACK", "NOTE", "XXX"],
  "todo-tree.highlights.defaultHighlight": {
    "icon": "alert",
    "type": "text"
  },

  // === ERROR LENS ===
  "errorLens.enabledDiagnosticLevels": ["error", "warning", "info"],
  "errorLens.fontSize": "12",

  // === GIT LENS ===
  "gitlens.hovers.currentLine.over": "line",
  "gitlens.currentLine.enabled": true,
  "gitlens.codeLens.enabled": false,

  // === TERMINAL ===
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "MesloLGS NF",

  // === PERFORMANCE ===
  "extensions.autoUpdate": false,
  "telemetry.telemetryLevel": "off",
  "update.mode": "manual"
}
```

---

## 🎮 Godot Integration Setup

### In Godot Editor:

1. Open Godot
2. Go to **Editor → Editor Settings**
3. Navigate to **Text Editor → External**
4. Configure:
   - **Use External Editor:** ✓ (checked)
   - **Exec Path:** `code` or `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`
   - **Exec Flags:** `{project} --goto {file}:{line}:{col}`

### Test It:

1. In Godot, right-click a script
2. Select "Open in External Editor"
3. Should open in VS Code at the correct line

---

## 🌐 Web Development Setup

### Prettier Configuration

Create `.prettierrc` in project root:

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80
}
```

### ESLint Configuration

Create `.eslintrc.json` in project root:

```json
{
  "extends": ["eslint:recommended"],
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  }
}
```

### For React/Next.js Projects:

```bash
npm install -D eslint-config-next
```

Update `.eslintrc.json`:

```json
{
  "extends": ["next/core-web-vitals"]
}
```

---

## 🐍 Python Setup

### Already Configured!

Your Python extensions are ready. Just ensure:

1. **Select Python Interpreter:** Cmd+Shift+P → "Python: Select Interpreter"
2. **Verify formatters work:** Save a Python file to test auto-formatting

### Optional: Create `pyproject.toml`:

```toml
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"

[tool.flake8]
max-line-length = 88
extend-ignore = "E203"
```

---

## 📱 iOS/Swift Setup (SweetPad)

### Prerequisites:

1. **Xcode** must be installed
2. **Command Line Tools:** `xcode-select --install`

### SweetPad Features:

- Open `.xcodeproj` or `.xcworkspace` in VS Code
- Build and run iOS apps from VS Code
- Integrated debugger
- Swift syntax highlighting

### Quick Start:

```bash
# Open iOS project
cd ~/Developer/projects/my-ios-app
code .
```

SweetPad will automatically detect the Xcode project.

---

## 🗄️ Database Extensions

### SQLTools Setup:

1. **Create Connection:**

   - Cmd+Shift+P → "SQLTools: Add New Connection"
   - Choose SQLite or PostgreSQL
   - Configure connection details

2. **Save Connection:**
   - Connections are saved in VS Code settings
   - Can be workspace-specific or global

### Example SQLite Connection:

```json
{
  "sqltools.connections": [
    {
      "name": "Local SQLite",
      "driver": "SQLite",
      "database": "${workspaceFolder}/database.db"
    }
  ]
}
```

---

## ⚡ Keyboard Shortcuts to Know

### Essential Commands:

- **Cmd+Shift+P** - Command palette
- **Cmd+P** - Quick file open
- **Cmd+B** - Toggle sidebar
- **Cmd+`** - Toggle terminal
- **Cmd+Shift+F** - Search across files
- **Cmd+K Cmd+S** - Keyboard shortcuts settings

### Copilot:

- **Tab** - Accept suggestion
- **Opt+]** - Next suggestion
- **Opt+[** - Previous suggestion
- **Cmd+I** - Open Copilot Chat

### TODO Tree:

- **Cmd+Shift+T** - Open TODO tree view

### Git:

- **Ctrl+Shift+G** - Source control panel
- **Cmd+K Cmd+C** - Stage changes
- **Cmd+Enter** - Commit

---

## 🎨 Extension-Specific Tips

### Material Icon Theme (Already Active)

✅ Icons automatically applied to files/folders

### Better Comments

Use special comment tags:

```javascript
// TODO: This needs to be fixed
// FIXME: Critical bug here
// NOTE: Important information
// ! Alert/Warning
// ? Question/Query
// * Highlighted comment
```

### Error Lens

Shows errors inline - no setup needed!

### Path Intellisense

Auto-completes file paths in imports - works automatically!

### Auto Rename Tag

Automatically renames paired HTML/XML tags - works automatically!

### Project Manager

- **Cmd+Shift+P** → "Project Manager: Save Project"
- Quickly switch between saved projects

---

## 🔧 Workspace-Specific Settings

Create `.vscode/settings.json` in each project:

### For Godot Projects:

```json
{
  "files.exclude": {
    ".godot/": true,
    ".import/": true
  }
}
```

### For Web Projects:

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true
}
```

### For Python Projects:

```json
{
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  }
}
```

---

## 🚀 Next Steps

1. **Apply settings above** to your `settings.json`
2. **Configure Godot** to use VS Code
3. **Test each extension** by working on a project
4. **Customize further** based on your preferences

---

## 📚 Extension Documentation

Quick access to docs:

- **Godot Tools:** [GitHub](https://github.com/godotengine/godot-vscode-plugin)
- **Prettier:** [prettier.io](https://prettier.io)
- **ESLint:** [eslint.org](https://eslint.org)
- **SweetPad:** [Marketplace](https://marketplace.visualstudio.com/items?itemName=sweetpad.sweetpad)
- **GitLens:** [gitlens.amod.io](https://gitlens.amod.io)

---

**All set!** Your VS Code is now optimized for game dev, web dev, Python, and iOS development! 🎉
