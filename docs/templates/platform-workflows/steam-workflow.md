# 🎮 Steam Development Workflow (Godot)

**Created:** December 10, 2025  
**Platform:** PC (Windows, macOS, Linux)  
**Distribution:** Steam

---

## 🎯 Platform Overview

### Why Steam?

**Pros:**

- ✅ Largest PC gaming platform (120M+ users)
- ✅ Built-in features (achievements, cloud saves, workshop)
- ✅ Strong discovery algorithms
- ✅ Community features (forums, guides, reviews)
- ✅ Automatic updates
- ✅ Cross-platform support (Win/Mac/Linux)
- ✅ Regional pricing

**Cons:**

- ❌ $100 fee per game (one-time, recoupable)
- ❌ 30% revenue cut (20% after $10M, 15% after $50M)
- ❌ Competitive marketplace (thousands of games)
- ❌ Requires Steamworks integration
- ❌ 2-week review process for first approval

**Best For:**

- PC-first games
- Games with depth/complexity
- Multiplayer games
- Moddable games
- Games with ongoing support

---

## 🛠️ Setup Requirements

### Before You Start

**Hardware:**

- [ ] Windows PC (for testing/building)
- [ ] Mac (optional, for macOS builds)
- [ ] Linux (optional, for Linux builds)

**Software:**

- [ ] Godot 4.x
- [ ] Steamworks SDK (free)
- [ ] Steam account (for testing)
- [ ] Git (for version control)

**Accounts & Fees:**

- [ ] Steam Partner account ($100 fee per game)
- [ ] Business/tax information ready
- [ ] Bank account for payments

### Initial Setup (One-Time)

**1. Register as Steam Partner:**

```
1. Visit: https://partner.steamgames.com
2. Click "Sign Up"
3. Pay $100 fee (refunded after $1000 in sales)
4. Complete tax forms (W-8/W-9)
5. Fill out company information
6. Wait 1-2 weeks for approval
```

**2. Create App on Steamworks:**

```
1. Log into Steamworks Partner
2. Click "Apps & Packages"
3. "Add New App"
4. Choose app type: "Game"
5. Name your game
6. Get your App ID (you'll need this)
```

**3. Download Steamworks SDK:**

```bash
# Download from: https://partner.steamgames.com/downloads/
# Extract SDK
unzip steamworks_sdk.zip
cd steamworks_sdk/

# Important files:
# - sdk/public/steam/          (Headers)
# - sdk/redistributable_bin/   (DLLs/SOs)
# - sdk/tools/ContentBuilder/  (Upload tool)
```

**4. Install GodotSteam Plugin:**

```bash
# Option 1: GodotSteam (Community plugin)
# Download from: https://github.com/GodotSteam/GodotSteam

# Option 2: Build custom export template with Steamworks
# (Advanced, for full integration)

# For basic integration:
# Add steam_api dll/so/dylib to your export templates
```

---

## 📋 Pre-Production Planning

### Technical Requirements

**Platform Support:**

```yaml
Windows:
  Min Version: Windows 7 (but target 10/11)
  Architecture: 64-bit (recommended)
  DirectX: DX11 minimum

macOS:
  Min Version: macOS 10.13+
  Architecture: Universal (Intel + Apple Silicon)

Linux:
  Distros: Ubuntu 18.04+ or equivalent
  Architecture: 64-bit
```

**Performance Targets:**

```
Entry-Level PC:
- CPU: Intel i3 / Ryzen 3
- GPU: GTX 1050 / RX 560
- RAM: 4-8GB
- Target: 30-60 FPS

Mid-Range PC:
- CPU: Intel i5 / Ryzen 5
- GPU: GTX 1660 / RX 5600
- RAM: 8-16GB
- Target: 60 FPS

High-End PC:
- CPU: Intel i7 / Ryzen 7
- GPU: RTX 3060 / RX 6700
- RAM: 16-32GB
- Target: 60-120+ FPS
```

**Resolution Support:**

```
1920x1080 (1080p) - Standard, must support
2560x1440 (1440p) - Common, should support
3840x2160 (4K)     - Nice to have
Ultrawide variants - Optional but appreciated
```

### Design Considerations

**Controls:**

- [ ] Keyboard + Mouse (essential)
- [ ] Gamepad support (highly recommended)
- [ ] Rebindable controls (best practice)
- [ ] Multiple control schemes
- [ ] Steam Input API integration

**Steam Features:**

- [ ] Achievements (highly recommended)
- [ ] Cloud Saves (essential)
- [ ] Trading Cards (passive income)
- [ ] Workshop (if moddable)
- [ ] Leaderboards (if competitive)
- [ ] Rich Presence (show game status)
- [ ] Overlay support

---

## 🎮 Development Workflow

### Phase 1: Steamworks Integration

**1. Set Up GodotSteam:**

```gdscript
# Install GodotSteam plugin
# Download from: https://godotsteam.com

# Add to project:
# res://addons/godotsteam/

# Create steam_appid.txt in project root
# Contents: Your Steam App ID (e.g., 480 for Spacewar test app)
```

**2. Initialize Steam:**

```gdscript
# Create Steam.gd singleton
extends Node

var is_initialized = false
var steam_id = 0
var steam_username = ""

func _ready():
    # Initialize Steam
    var init_result = Steam.steamInit()
    if init_result['status'] != 1:
        push_error("Failed to initialize Steam: " + str(init_result))
        return

    is_initialized = true
    steam_id = Steam.getSteamID()
    steam_username = Steam.getPersonaName()

    print("Steam initialized for: " + steam_username)

func _process(_delta):
    if is_initialized:
        Steam.run_callbacks()
```

**3. Implement Basic Features:**

```gdscript
# Achievements
func unlock_achievement(name: String):
    if Steam.is_initialized:
        Steam.setAchievement(name)
        Steam.storeStats()

# Cloud Saves
func save_game_to_cloud(save_data: Dictionary):
    var save_json = JSON.stringify(save_data)
    Steam.fileWrite("save_game.json", save_json.to_utf8_buffer())

func load_game_from_cloud():
    if Steam.fileExists("save_game.json"):
        var size = Steam.fileGetSize("save_game.json")
        var data = Steam.fileRead("save_game.json", size)
        return JSON.parse_string(data.get_string_from_utf8())
    return null

# Stats
func update_stat(stat_name: String, value: float):
    Steam.setStatFloat(stat_name, value)
    Steam.storeStats()
```

---

### Phase 2: Development

**Daily Workflow:**

```bash
# Morning - Pull latest changes
cd ~/Developer/games/my-games/your-game
git pull

# Open in Godot
godot project.godot

# Develop features
# Test with F5 (Steam will be active if steam_appid.txt exists)

# Test Steam features
# - Achievements unlock
# - Cloud saves work
# - Stats update

# Evening - Commit
git add .
git commit -m "Add feature X with Steam integration"
git push
```

**Testing Strategy:**

```
Level 1: Godot Editor (Quick tests)
  ↓
Level 2: Exported Build (Local test)
  ↓
Level 3: Steam SDK Test App (Spacewar App ID 480)
  ↓
Level 4: Your Steam App ID (Private beta)
  ↓
Level 5: Steam Beta Branch (External testers)
```

---

### Phase 3: Optimization

**PC Performance Tips:**

```gdscript
# Graphics options
var graphics_settings = {
    "low": {
        "shadows": false,
        "particles": false,
        "post_processing": false,
        "max_fps": 60
    },
    "medium": {
        "shadows": true,
        "particles": true,
        "post_processing": false,
        "max_fps": 60
    },
    "high": {
        "shadows": true,
        "particles": true,
        "post_processing": true,
        "max_fps": 120
    },
    "ultra": {
        "shadows": true,
        "particles": true,
        "post_processing": true,
        "max_fps": 0  # Unlimited
    }
}

func apply_graphics(preset: String):
    var settings = graphics_settings[preset]

    # Apply settings
    RenderingServer.environment_set_glow(get_viewport().world_3d.environment,
        settings.post_processing)

    Engine.max_fps = settings.max_fps

    # Save to config
    save_settings()
```

**Multi-Platform Considerations:**

```bash
# Windows build
# Export → Windows Desktop → 64-bit

# macOS build
# Export → macOS → Universal (Intel + Apple Silicon)

# Linux build
# Export → Linux/X11 → 64-bit
```

---

## 📦 Build & Upload Process

### Prepare Builds

**1. Configure Export Presets:**

```
Project → Export → Add

Windows Desktop:
- Name: Windows
- Architecture: x86_64
- Embed PCK: Yes
- Include Steam API DLL
- Output: builds/windows/game.exe

macOS:
- Name: macOS
- Bundle Identifier: com.yourstudio.yourgame
- Architecture: Universal
- Include Steam API dylib
- Output: builds/macos/game.app

Linux/X11:
- Name: Linux
- Architecture: x86_64
- Include Steam API so
- Output: builds/linux/game.x86_64
```

**2. Export All Platforms:**

```bash
# Create export script
#!/bin/bash

echo "Exporting for Steam..."

# Clean previous builds
rm -rf builds/

# Export Windows
godot --headless --export-release "Windows" builds/windows/game.exe

# Export macOS
godot --headless --export-release "macOS" builds/macos/game.zip

# Export Linux
godot --headless --export-release "Linux" builds/linux/game.x86_64

# Add Steam API libraries
cp steam_sdk/redistributable_bin/win64/steam_api64.dll builds/windows/
cp steam_sdk/redistributable_bin/osx/libsteam_api.dylib builds/macos/game.app/Contents/MacOS/
cp steam_sdk/redistributable_bin/linux64/libsteam_api.so builds/linux/

echo "Export complete!"
```

---

### Upload to Steam

**1. Configure Steamworks Depots:**

```
In Steamworks Partner Portal:

Apps & Packages → Your App → Depots

Create depots:
- Depot 1: Windows content
- Depot 2: macOS content
- Depot 3: Linux content
- Depot 4: Shared content (if any)

Set platform restrictions for each depot
```

**2. Create Build Configuration:**

```bash
# Edit steamworks_sdk/tools/ContentBuilder/scripts/app_build.vdf

"AppBuild"
{
    "AppID" "YOUR_APP_ID"
    "Desc" "Version 1.0.0 - Initial Release"
    "BuildOutput" "../../../build_output"
    "ContentRoot" "../../../builds/"
    "SetLive" "beta"  // Or "default" for public

    "Depots"
    {
        "YOUR_DEPOT_ID_WINDOWS"
        {
            "FileMapping"
            {
                "LocalPath" "windows/*"
                "DepotPath" "."
                "recursive" "1"
            }
        }

        "YOUR_DEPOT_ID_MACOS"
        {
            "FileMapping"
            {
                "LocalPath" "macos/*"
                "DepotPath" "."
                "recursive" "1"
            }
        }

        "YOUR_DEPOT_ID_LINUX"
        {
            "FileMapping"
            {
                "LocalPath" "linux/*"
                "DepotPath" "."
                "recursive" "1"
            }
        }
    }
}
```

**3. Run SteamPipe (Upload Tool):**

```bash
cd steamworks_sdk/tools/ContentBuilder

# Windows
builder\steamcmd.exe +login YOUR_STEAM_USERNAME +run_app_build ..\scripts\app_build.vdf +quit

# macOS/Linux
./builder_osx/steamcmd.sh +login YOUR_STEAM_USERNAME +run_app_build ../scripts/app_build.vdf +quit

# Wait for upload (can take minutes to hours depending on size)
```

---

## 🎨 Store Page Setup

### Required Assets

**Images:**

```yaml
Header Capsule: 460x215  (Main store image)
Small Capsule: 231x87   (Lists and search)
Main Capsule: 616x353  (Library view)
Hero Capsule: 1920x620 (Top of store page, optional)
Library Hero: 3840x1240 (Big Picture mode)
Library Logo: PNG with transparency (varies)

Screenshots: 1920x1080 or 1280x720 (at least 5)
Trailers: 1080p MP4 (optional but highly recommended)
```

**Text Content:**

```yaml
Game Name: Max 100 characters
Short Description: Max 300 characters (shown in search)
Full Description: No limit (use formatting)
About This Game: Rich text with features/gameplay

Minimum Requirements:
  OS: Windows 7/8/10
  Processor: Intel i3
  Memory: 4 GB RAM
  Graphics: GTX 1050
  Storage: 2 GB available space

Recommended Requirements:
  OS: Windows 10/11
  Processor: Intel i5
  Memory: 8 GB RAM
  Graphics: GTX 1660
  Storage: 2 GB available space
```

### Store Page Configuration

**1. Basic Information:**

```
Name: Your Game Title
Developer: Your Studio Name
Publisher: Your Studio Name (or publisher)
Release Date: TBD or specific date
Languages: Supported languages
Price: $9.99, $14.99, $19.99, etc.
```

**2. Categories & Tags:**

```
Genre:
- Action
- Adventure
- Indie
- Puzzle
- RPG
- Strategy
- etc.

Tags (choose relevant):
- 2D Platformer
- Pixel Graphics
- Singleplayer
- Controller Support
- Great Soundtrack
- etc. (up to 20)

Features:
☑ Single-player
☑ Steam Achievements
☑ Steam Cloud
☑ Full controller support
☑ Steam Trading Cards
☑ Steam Workshop
```

**3. Community Setup:**

```
Steam Community:
- Create discussion forums
- Enable screenshots
- Enable guides
- Set community moderators
```

---

## 🧪 Beta Testing

### Steam Beta Branches

**1. Create Beta Branch:**

```
Steamworks → Builds → Branches

Create branch: "beta"
Password: [optional password for access]
Set build to branch
```

**2. Generate Beta Keys:**

```
Steamworks → Users & Permissions → Steam Keys

Generate keys:
- Quantity: 100-1000
- Key Type: Beta (Pre-release)
- Activation Details: Beta branch access

Distribute to testers
```

**3. Playtest Feature:**

```
Steamworks → Playtest

Enable Steam Playtest:
- Free temporary access for testing
- Request through store page
- Automatic access removal after period
- Great for large-scale testing
```

---

## 🚀 Launch Strategy

### Pre-Launch Checklist (2 Weeks Before)

**Technical:**

- [ ] All builds uploaded and tested
- [ ] Steam achievements work
- [ ] Cloud saves functional
- [ ] Controller support tested
- [ ] All platforms tested
- [ ] No game-breaking bugs
- [ ] Performance optimized

**Store Page:**

- [ ] All required images uploaded
- [ ] Trailer published
- [ ] Description complete and compelling
- [ ] System requirements accurate
- [ ] Tags and categories set
- [ ] Community features enabled
- [ ] Pricing set (with regional pricing)

**Marketing:**

- [ ] Social media posts scheduled
- [ ] Press kit ready
- [ ] Email list notification prepared
- [ ] Reddit/Discord announcements ready
- [ ] Steam curator keys requested

---

### Launch Day

**Timeline:**

```
10:00 AM PST - Default Steam launch time
(adjust to your timezone/target market)

Launch Day Checklist:
- [ ] Set build to "default" branch (goes live)
- [ ] Publish store page (if still hidden)
- [ ] Monitor Steam forums for issues
- [ ] Respond to early reviews
- [ ] Post on social media
- [ ] Engage with community
- [ ] Watch for bugs/crashes
- [ ] Prepare hotfix if needed
```

---

### Post-Launch

**Week 1:**

```bash
Daily:
- Monitor crash reports
- Read all reviews (respond to negative ones)
- Check Steam forum
- Track sales numbers
- Fix critical bugs

Prepare hotfix update if needed:
- Export new build
- Upload via SteamPipe
- Set to default branch
- Announcement post about fix
```

**First Month:**

```
Week 2: Collect feedback
Week 3: Develop updates
Week 4: Release first major update

Update should include:
- Bug fixes from feedback
- Community requested features
- Performance improvements
- New content (if applicable)
```

---

## 💰 Monetization & Business

### Pricing Strategy

**Pricing Tiers:**

```yaml
Budget: $4.99 - $9.99   (Casual, short games)
Standard: $9.99 - $19.99  (Most indie games)
Premium: $19.99 - $29.99 (Larger games)
AAA Indie: $29.99+         (Major indie releases)
```

**Discount Strategy:**

```
Launch Week:        10% off (optional launch discount)
First Sale:         Month 2-3, 15-20% off
Major Sales:        Summer/Winter Sale, 25-50% off
Bundle Deals:       After 6 months
Free Weekend:       After 1 year (optional)
```

### Revenue

Tracking

```
Steamworks → Sales & Activations → Regional Sales

Key Metrics:
- Units sold
- Gross revenue
- Refund rate (keep under 10%)
- Regional breakdown
- Wishlist conversion rate
- Player retention
```

---

## 🎯 Best Practices

### Do's ✅

- Release on Thursday (best day for visibility)
- Engage with community regularly
- Update game frequently (shows support)
- Respond to reviews (especially negative)
- Use all Steam features available
- Build wishlist before launch
- Plan content updates post-launch

### Don'ts ❌

- Don't launch broken (first impression matters)
- Don't ignore negative feedback
- Don't spam Steam forums
- Don't fake reviews
- Don't abandon game post-launch
- Don't overprice
- Don't miss seasonal sales

---

## 🔧 Quick Reference

### SteamPipe Upload Script

```bash
#!/bin/bash
# upload_to_steam.sh

APP_ID="YOUR_APP_ID"
BUILD_DESC="Version $1"

echo "Uploading build to Steam..."
echo "Description: $BUILD_DESC"

cd steamworks_sdk/tools/ContentBuilder
./builder_osx/steamcmd.sh \
    +login YOUR_USERNAME \
    +run_app_build ../scripts/app_build.vdf \
    +quit

echo "Upload complete! Check Steamworks for status."
```

**Usage:**

```bash
./upload_to_steam.sh "1.0.1 - Bug fixes"
```

### Useful Links

```
Steamworks Partner:    https://partner.steamgames.com
Steamworks Docs:       https://partner.steamgames.com/doc/home
GodotSteam:           https://godotsteam.com
Steam Spy (Stats):    https://steamspy.com
Steam DB (Analysis):  https://steamdb.info
```

---

**Timeline Example:**

```
Week 1-12:  Development
Week 13:    Steamworks integration
Week 14:    Beta testing
Week 15:    Store page setup
Week 16:    Marketing push
Week 17:    LAUNCH! 🎉
Week 18+:   Updates and support
```

**Key Takeaway:**

> Steam offers the largest PC audience and powerful features, but requires integration work and faces heavy competition. Success comes from quality games, community engagement, and ongoing support.
