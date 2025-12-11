# VS Code Workspace Configuration

**Last Updated:** December 11, 2025

This directory contains VS Code workspace-level configurations optimized for the Developer workflow.

## 📁 Files Overview

### `settings.json`
Workspace-specific settings that override user settings. Includes:
- Multi-language formatting preferences (Python, JS/TS, GDScript)
- Performance optimizations for 8GB Mac
- File associations and exclusion patterns
- Language-specific configurations

### `extensions.json`
Recommended extensions for this workspace:
- **Essential**: Copilot, GitLens, Prettier, ESLint
- **Python**: Python, Pylance, Black, isort
- **Web Development**: React snippets, Tailwind CSS, Thunder Client
- **Godot**: godot-tools for GDScript development
- **Productivity**: Todo Tree, Better Comments, Project Manager

### `tasks.json`
Predefined tasks for common operations:
- **Python**: Virtual env setup, install requirements, run tests
- **Node/NPM**: Install dependencies, dev server, build
- **Godot**: Open project, run game
- **Git**: Status, pull
- **Maintenance**: Clean caches, code statistics

### `launch.json`
Debug configurations for different project types:
- **Python**: Current file, Django, Flask, Pytest
- **Node/JavaScript**: Launch program, attach to process
- **Chrome**: Web app debugging with live server
- **Godot**: Launch game, launch scene

### Code Snippets
Custom snippets organized by language:

#### `python.code-snippets`
- `pymain` - Main guard
- `pyfunc` - Function with docstring
- `pyclass` - Class with docstrings
- `pytry` - Try-except block
- `pylog` - Logger setup
- `pydataclass` - Dataclass

#### `javascript.code-snippets`
- `rfc` - React functional component
- `rfcs` - React component with useState
- `useeff` - useEffect hook
- `tsint` - TypeScript interface
- `asyncf` - Async function
- `imp` - Import statement

#### `gdscript.code-snippets`
- `ready` - _ready function
- `process` - _process function
- `physics` - _physics_process function
- `input` - _input function
- `signal` - Signal declaration
- `export` - Export variable
- `move2d` - 2D movement template

## 🚀 Quick Start

### 1. Install Recommended Extensions
When you open this workspace, VS Code will prompt you to install recommended extensions. Click "Install All" or:
```
Cmd+Shift+P → "Extensions: Show Recommended Extensions"
```

### 2. Run a Task
```
Cmd+Shift+P → "Tasks: Run Task"
```
Then select from available tasks like:
- `Python: Create Virtual Environment`
- `NPM: Dev Server`
- `Godot: Open Project in Editor`
- `Clean: Remove Python Cache`

### 3. Start Debugging
Press `F5` or:
```
Cmd+Shift+D → Select debug configuration → Press F5
```

### 4. Use Code Snippets
Start typing a snippet prefix and press `Tab`:
- In Python file: Type `pyfunc` + Tab
- In JavaScript file: Type `rfc` + Tab
- In GDScript file: Type `ready` + Tab

## 🎯 Workflow Integration

These configurations align with the documented workflow in:
- [docs/workflows/macos-vscode-strategy.md](../docs/workflows/macos-vscode-strategy.md)
- [docs/workflows/workflow-context.md](../docs/workflows/workflow-context.md)
- [docs/workflows/vscode-extension-setup-guide.md](../docs/workflows/vscode-extension-setup-guide.md)

## 💡 Tips

### Multi-Root Workspace
To work on multiple projects simultaneously:
```
File → Add Folder to Workspace
```
Then save as `.code-workspace` file.

### Custom Keybindings
Create `keybindings.json` in this directory for workspace-specific shortcuts.

### Sync Settings
Settings in this `.vscode` folder are:
- ✅ Committed to Git (shared across machines)
- ✅ Override user settings
- ✅ Specific to Developer workspace

User settings at `~/Library/Application Support/Code/User/settings.json`:
- ✅ Apply globally
- ✅ Can be overridden by workspace settings
- ⚠️  Not committed to Git

## 📝 Maintenance

When adding new projects or changing workflow:
1. Update `settings.json` for new file types or language settings
2. Add tasks to `tasks.json` for new operations
3. Create launch configurations for new debug scenarios
4. Add snippets for repetitive code patterns

## 🔗 Related Resources

- [VS Code Workspace Settings](https://code.visualstudio.com/docs/getstarted/settings#_workspace-settings)
- [VS Code Tasks](https://code.visualstudio.com/docs/editor/tasks)
- [VS Code Debugging](https://code.visualstudio.com/docs/editor/debugging)
- [VS Code Snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets)
