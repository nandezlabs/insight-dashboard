# Copilot Automation Setup

## 🤖 Two Automation Methods Available

### 1. **VS Code Workspace (Automatic)** ✅ Already Active

The workspace is configured to check Copilot permissions once per day when you open it.

**How it works:**
- Runs automatically when you open the Developer workspace
- Checks if it has run today (using `~/.copilot-permission-check`)
- If not run today, prompts you to reset and choose mode
- Silent if already run today

**Location:** Task configured in [.vscode/tasks.json](../../.vscode/tasks.json)

### 2. **macOS launchd (Optional Daily Scheduler)**

Run the script daily at 9:00 AM, even if VS Code isn't open.

**Installation:**
```bash
bash ~/Developer/tools/workflow/install-copilot-automation.sh
```

Select option 1 to install. This will:
- Copy the plist to `~/Library/LaunchAgents/`
- Schedule daily execution at 9:00 AM
- Create logs at `/tmp/copilot-daily-reset.log`

**Uninstall:**
```bash
bash ~/Developer/tools/workflow/install-copilot-automation.sh
```
Select option 2.

**Check Status:**
```bash
bash ~/Developer/tools/workflow/install-copilot-automation.sh
```
Select option 3.

## 🎯 Recommended Setup

**Most Users:** Just use the VS Code automation (already active). It runs once per day when you open the workspace.

**Heavy Users:** Install both. The launchd will run at 9 AM, and VS Code will check when you open it.

## 📝 How It Works

### State Tracking
A file at `~/.copilot-permission-check` stores the last run date. This prevents duplicate prompts.

### Flow
1. Check if run today (date in state file)
2. If not, run the daily reset script:
   - Reset permissions to `oncePerWorkspace`
   - Prompt: "Set to 'always' for today?"
3. Save today's date to state file

## 🛠️ Manual Controls

**Run check now:**
```bash
bash ~/Developer/tools/workflow/copilot-check-once.sh
```

**Force reset (ignores state):**
```bash
bash ~/Developer/tools/workflow/copilot-daily-reset.sh
```

**Change permissions anytime:**
```bash
bash ~/Developer/tools/workflow/copilot-permissions.sh
```

**Or use VS Code tasks:**
- `Cmd+Shift+P` → "Tasks: Run Task"
- Select any Copilot task

## 🔗 Shell Aliases (Optional)

Add to your `~/.zshrc`:
```bash
# Copilot permission management
alias copilot-check='bash ~/Developer/tools/workflow/copilot-check-once.sh'
alias copilot-reset='bash ~/Developer/tools/workflow/copilot-daily-reset.sh'
alias copilot-set='bash ~/Developer/tools/workflow/copilot-permissions.sh'
```

Then reload: `source ~/.zshrc`

## 📅 Typical Daily Flow

### Morning
1. Open VS Code Developer workspace
2. Automatic check runs (once per day)
3. Prompted to choose permission mode
4. Work with chosen settings all day

### During Day
- Use VS Code tasks to change modes as needed
- Or run `copilot-set` from terminal

### Next Morning
- Process repeats automatically

## 🎨 Customization

**Change launchd schedule:**
Edit [com.developer.copilot-daily-reset.plist](../../tools/workflow/com.developer.copilot-daily-reset.plist)
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>9</integer>  <!-- Change this -->
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

Then reinstall:
```bash
bash ~/Developer/tools/workflow/install-copilot-automation.sh
```

## 🔍 Troubleshooting

**VS Code automation not running:**
- Check [.vscode/tasks.json](../../.vscode/tasks.json) has the startup task
- Task runs on "folderOpen" event
- Check presentation is set to "never" (runs silently first time per day)

**launchd not working:**
```bash
# Check if loaded
launchctl list | grep copilot

# View logs
cat /tmp/copilot-daily-reset.log
cat /tmp/copilot-daily-reset.error.log

# Reload service
launchctl unload ~/Library/LaunchAgents/com.developer.copilot-daily-reset.plist
launchctl load ~/Library/LaunchAgents/com.developer.copilot-daily-reset.plist
```

**Want to reset state:**
```bash
rm ~/.copilot-permission-check
```

## 📊 Current Status

**Active Automations:**
- ✅ VS Code workspace check (on folder open, once per day)

**Optional Automations:**
- ⚪ launchd daily scheduler (not installed by default)

To install launchd scheduler:
```bash
bash ~/Developer/tools/workflow/install-copilot-automation.sh
```
