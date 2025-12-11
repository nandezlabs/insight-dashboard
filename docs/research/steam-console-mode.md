# Steam Deck Mode / Big Picture Auto-Launch Setup

**Created:** December 9, 2025  
**Purpose:** Configure PC to auto-launch Steam in console mode for gaming-first experience

---

## 🎮 Steam Big Picture / Console Mode Setup

### **Why Console Mode?**

```
Benefits:
✓ Gaming-first interface on boot
✓ Controller-friendly
✓ Clean gaming experience
✓ Easy access to game library
✓ Can still exit to desktop for dev work
✓ Perfect for dual-purpose PC
```

---

## 🚀 Option 1: Auto-Launch Steam Big Picture (Windows)

### **Method 1: Startup Script (Recommended)**

```powershell
# C:\Scripts\launch-steam-gaming.ps1

# Wait for system to fully boot
Start-Sleep -Seconds 10

# Check if any dev tools are running (skip if dev mode)
$devMode = Get-Process code,docker,ollama -ErrorAction SilentlyContinue
if ($devMode) {
    Write-Host "🛠️ Dev tools detected - Skipping Steam auto-launch"
    exit
}

# Launch Steam in Big Picture mode
Start-Process "steam://open/bigpicture"

# Optional: Minimize/hide desktop elements
# (Get-Process explorer).CloseMainWindow()  # Hide desktop (can restore from Steam)
```

**Set to Run at Login:**

```powershell
# Create shortcut in Startup folder
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Steam-Gaming.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Scripts\launch-steam-gaming.ps1"
$Shortcut.Save()
```

### **Method 2: Windows Shell Replacement (Advanced)**

**Replace Explorer with Steam as shell:**

```registry
; C:\Scripts\steam-shell.reg

Windows Registry Editor Version 5.00

; Backup original shell
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"ShellBackup"="explorer.exe"

; Set Steam Big Picture as shell
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"Shell"="C:\\Program Files (x86)\\Steam\\steam.exe -bigpicture"
```

**Restore Normal Desktop (when needed):**

```registry
; C:\Scripts\restore-explorer-shell.reg

Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"Shell"="explorer.exe"
```

**Quick Toggle Shortcuts:**

```powershell
# Desktop shortcut: "Gaming Mode"
# Target: reg import C:\Scripts\steam-shell.reg && shutdown /r /t 5

# Desktop shortcut: "Desktop Mode"
# Target: reg import C:\Scripts\restore-explorer-shell.reg && shutdown /r /t 5
```

---

## 🐧 Option 2: Dual Boot with SteamOS (Best Console Experience)

### **Why SteamOS?**

```
Pros:
✓ True console-like experience
✓ Optimized for gaming
✓ Controller UI out of the box
✓ Lightweight Linux gaming
✓ Still have Windows for dev work

Cons:
✗ Requires dual boot setup
✗ Another OS to maintain
✗ Some Windows-only games need Proton
```

### **Installation (Alongside Windows)**

**Requirements:**

- 50GB+ free disk space for SteamOS partition
- USB drive (8GB+)
- Backup important data

**Steps:**

1. **Download SteamOS / HoloISO** (community SteamOS for desktop):

```bash
# HoloISO is SteamOS adapted for desktop PCs
# Download from: https://github.com/HoloISO/holoiso

# Or use Bazzite (Fedora-based Steam gaming OS)
# Download from: https://bazzite.gg
```

2. **Create Bootable USB:**

```powershell
# Windows: Use Rufus or Balena Etcher
# Download Rufus: https://rufus.ie

# Flash HoloISO/Bazzite ISO to USB
```

3. **Partition Drive:**

```
Current Layout:
├── Windows (C:) - 500GB
└── Data (D:) - 1.5TB

New Layout:
├── Windows (C:) - 400GB (shrink by 50GB)
├── SteamOS (new) - 50GB
└── Data (D:) - 1.5TB (shared, NTFS accessible from both)
```

4. **Install SteamOS:**

```
Boot from USB → Install alongside Windows
Select 50GB partition
Install GRUB bootloader
Configure dual boot menu
```

5. **Boot Menu:**

```
GRUB Menu:
├── SteamOS (Gaming) ← Default (5 sec timeout)
└── Windows 11 (Dev Work + AAA games)
```

---

## 🎯 Option 3: Hybrid Approach (Recommended for You)

**Best of both worlds:**

```
Default Boot Behavior:
├── PC boots to Windows
├── Auto-launches Steam Big Picture after 10 seconds
├── Can press Esc during countdown to skip
├── Gaming-first, but Windows available
├── AI services running in background (limited)
```

**Implementation:**

```powershell
# C:\Scripts\smart-boot-to-gaming.ps1

param(
    [int]$CountdownSeconds = 10
)

Write-Host "🎮 Steam Gaming Mode Auto-Launch" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check for dev mode flag file
if (Test-Path "C:\dev-mode-active.flag") {
    Write-Host "🛠️ Dev mode active - Skipping Steam launch" -ForegroundColor Yellow
    Write-Host "   (Delete C:\dev-mode-active.flag to re-enable)"
    exit
}

# Countdown
Write-Host "Launching Steam Big Picture in:" -ForegroundColor Green
for ($i = $CountdownSeconds; $i -gt 0; $i--) {
    Write-Host "  $i seconds... (Press Ctrl+C to cancel)" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "🚀 Launching Steam Big Picture Mode..." -ForegroundColor Green

# Start AI resource manager (limited mode)
Start-Process powershell -ArgumentList "-WindowStyle Hidden -File C:\Scripts\ai-resource-manager.ps1" -WindowStyle Hidden

# Launch Steam Big Picture
Start-Process "steam://open/bigpicture"

# Optional: Hide taskbar/desktop for cleaner gaming
# $null = (New-Object -ComObject Shell.Application).ToggleDesktop()
```

**Create Desktop Shortcuts:**

```powershell
# Shortcut 1: "Gaming Mode" (force Steam Big Picture)
# Target: powershell.exe -File "C:\Scripts\smart-boot-to-gaming.ps1" -CountdownSeconds 0

# Shortcut 2: "Dev Mode" (disable auto-launch)
# Target: powershell.exe -Command "New-Item C:\dev-mode-active.flag"

# Shortcut 3: "Gaming Mode (Enable)" (remove flag)
# Target: powershell.exe -Command "Remove-Item C:\dev-mode-active.flag -ErrorAction SilentlyContinue"
```

---

## 🎮 Controller Support for Dev Work

**Access desktop/dev tools with controller:**

```powershell
# Install JoyXoff or Controller Companion
# Allows controller to control mouse/keyboard

# Steam Input also works:
# In Big Picture: Settings → Controller → Desktop Configuration
```

**Custom Steam Input Profile for Dev:**

```
Steam Controller Config (Desktop Mode):
├── Left Stick: Mouse movement
├── Right Stick: Scroll
├── A: Left click
├── B: Right click
├── X: Enter
├── Y: Esc
├── D-Pad: Arrow keys
├── Triggers: Browser back/forward
└── Steam button: Keyboard
```

---

## 📊 Combined: AI + Gaming Console Experience

### **Optimal Setup:**

```
Boot Sequence:
1. PC starts Windows
2. AI services start (low priority, limited resources)
3. After 10 seconds → Auto-launch Steam Big Picture
4. Gaming-ready interface
5. AI available in background (limited to 25-50% resources)
6. Press Steam button → Exit Big Picture for dev work

Gaming Session:
├── Navigate Steam with controller
├── Launch game
├── AI auto-limits to 10-25% resources
├── Game runs at full performance
├── Can still ask AI quick questions (slower but works)

Dev Session:
├── Exit Steam Big Picture (Desktop button)
├── Windows desktop appears
├── AI restores to 100% performance
├── Open VS Code, Docker, etc.
├── Full dev environment
```

---

## 🔧 Advanced: Mode Switching

**Create quick mode switcher:**

```powershell
# C:\Scripts\mode-switcher.ps1

param([string]$Mode)

switch ($Mode) {
    "gaming" {
        Write-Host "🎮 Switching to Gaming Mode..."
        # Stop dev services
        docker stop $(docker ps -q) 2>$null
        # Limit AI
        & C:\Scripts\ai-resource-manager.ps1 -Limit 25
        # Launch Steam
        Start-Process "steam://open/bigpicture"
        Write-Host "✅ Gaming mode active"
    }

    "dev" {
        Write-Host "🛠️ Switching to Dev Mode..."
        # Exit Steam Big Picture
        Stop-Process -Name steam -Force -ErrorAction SilentlyContinue
        # Restore AI
        & C:\Scripts\ai-resource-manager.ps1 -Limit 100
        # Start dev services
        docker start postgres redis gitea 2>$null
        # Launch VS Code
        code
        Write-Host "✅ Dev mode active"
    }

    "hybrid" {
        Write-Host "🔀 Switching to Hybrid Mode..."
        # Keep Steam running
        if (-not (Get-Process steam -ErrorAction SilentlyContinue)) {
            Start-Process "C:\Program Files (x86)\Steam\steam.exe"
        }
        # AI at 50%
        & C:\Scripts\ai-resource-manager.ps1 -Limit 50
        # Essential dev services only
        docker start postgres redis 2>$null
        Write-Host "✅ Hybrid mode active (Gaming + Light dev)"
    }

    default {
        Write-Host "Usage: mode-switcher.ps1 {gaming|dev|hybrid}"
    }
}
```

**Desktop Shortcuts:**

```
Gaming Mode.lnk:  powershell -File mode-switcher.ps1 gaming
Dev Mode.lnk:     powershell -File mode-switcher.ps1 dev
Hybrid Mode.lnk:  powershell -File mode-switcher.ps1 hybrid
```

---

## 🎯 Recommended Configuration for Your Setup

**PC Startup Behavior:**

```yaml
Default Boot:
  - Windows starts
  - AI services start (limited to 50% by default)
  - Countdown: 10 seconds
  - Auto-launch: Steam Big Picture
  - Interface: Gaming console mode
  - AI: Available but limited (10-25 tok/sec)

Press Esc During Countdown:
  - Skips Steam launch
  - Boots to normal Windows desktop
  - AI restores to 100%
  - Full dev environment

From Big Picture:
  - Can play games (AI auto-limits further)
  - Can exit to desktop for dev work
  - Mode switcher shortcuts on desktop
```

**This gives you:**

- ✅ Gaming-first experience
- ✅ One button to dev mode
- ✅ AI always available (scaled appropriately)
- ✅ No complex dual-boot if you don't want it
- ✅ Controller-friendly interface
- ✅ Windows for AAA games and dev work

Want me to create the complete setup scripts for this configuration?
