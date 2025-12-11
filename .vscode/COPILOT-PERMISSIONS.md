# Copilot Permission Management

## 🤖 Current Configuration

### Enabled Settings
- ✅ **All languages** - Copilot enabled everywhere
- ✅ **Markdown** - Now enabled for documentation
- ✅ **Source Control Input** - Now enabled for commit messages
- ✅ **Plaintext** - Enabled

### Permission Mode
- 🔓 **Always** - Currently set to always approve

## 🛠️ Management Tools

### Quick Access via VS Code Tasks

Press `Cmd+Shift+P` → "Tasks: Run Task" → Select:

1. **🤖 Copilot: Change Permissions** - Interactive mode to change settings
2. **🤖 Copilot: Daily Reset & Prompt** - Reset to oncePerWorkspace and ask
3. **🤖 Copilot: Set Always** - Quick set to always
4. **🤖 Copilot: Set Once Per Workspace** - Quick set to oncePerWorkspace

### Command Line Scripts

**Interactive Permission Manager:**
```bash
bash ~/Developer/tools/workflow/copilot-permissions.sh
```

**Set Specific Mode:**
```bash
bash ~/Developer/tools/workflow/copilot-permissions.sh always
bash ~/Developer/tools/workflow/copilot-permissions.sh oncePerWorkspace
bash ~/Developer/tools/workflow/copilot-permissions.sh eachTime
bash ~/Developer/tools/workflow/copilot-permissions.sh never
```

**Check Current Status:**
```bash
bash ~/Developer/tools/workflow/copilot-permissions.sh status
```

**Daily Reset (for morning routine):**
```bash
bash ~/Developer/tools/workflow/copilot-daily-reset.sh
```

## 📅 Daily Workflow

### Recommended Morning Routine

Run the daily reset script at the start of your day:
```bash
bash ~/Developer/tools/workflow/copilot-daily-reset.sh
```

This will:
1. Reset permissions to `oncePerWorkspace`
2. Ask if you want to set to `always` for the day
3. Let you choose based on your work needs

### Add to Your Morning Checklist

You can add this to your shell profile for a reminder:
```bash
# Add to ~/.zshrc
alias copilot-morning='bash ~/Developer/tools/workflow/copilot-daily-reset.sh'
```

Or create a launchd job to run it automatically on first terminal open of the day.

## 🎯 Permission Modes Explained

| Mode | Behavior | Best For |
|------|----------|----------|
| **always** | Never asks, always approves | Deep work sessions, high trust |
| **oncePerWorkspace** | Asks once per workspace | Balanced approach (recommended) |
| **eachTime** | Asks every time | Learning, careful review |
| **never** | Never auto-approves | Maximum control |

## 💡 Pro Tips

1. **Start with oncePerWorkspace** - Good balance of convenience and awareness
2. **Use 'always' for focus time** - When you don't want interruptions
3. **Reset daily** - Fresh start each day maintains good habits
4. **Quick toggle via tasks** - Fast switching without leaving VS Code

## 🔗 Related Files

- User Settings: `~/Library/Application Support/Code/User/settings.json`
- Permission Script: [tools/workflow/copilot-permissions.sh](../../tools/workflow/copilot-permissions.sh)
- Daily Reset: [tools/workflow/copilot-daily-reset.sh](../../tools/workflow/copilot-daily-reset.sh)
- Tasks Config: [.vscode/tasks.json](tasks.json)
