# Godot Development Workflow

**Created:** December 9, 2025  
**Focus:** Cross-platform game development with your multi-machine setup

---

## 🎮 Godot Overview

### What You're Working With

- **Engine:** Godot 4.x (open-source, no fees, no royalties)
- **Languages:** GDScript (primary), C# (optional)
- **Platforms:** Windows, macOS, Linux, iOS, Android, Web
- **Project Types:** 2D and 3D games

### Why Godot Fits Your Setup

- ✅ Open-source and completely free
- ✅ Excellent cross-platform support
- ✅ Works great on Mac for 2D
- ✅ Leverages PC GPU for 3D
- ✅ Lightweight enough for your MacBook
- ✅ Git-friendly (text-based scenes)
- ✅ Built-in version control integration
- ✅ No vendor lock-in

---

## 💻 Machine-Specific Godot Setup

### MacBook Air M2 - 2D Games & Prototyping

**Installation:**

```bash
# Install via Homebrew
brew install --cask godot

# Or download from godotengine.org
# Godot runs natively on Apple Silicon
```

**Best For:**

- ✅ 2D game development (perfect performance)
- ✅ GDScript coding and prototyping
- ✅ UI/menu design
- ✅ Initial project setup
- ✅ Mobile game development (2D)
- ✅ Simple 3D prototypes (low poly)
- ⚠️ Complex 3D scenes (will struggle)
- ❌ High-fidelity 3D games

**Performance Tips:**

```
2D Projects:
- No issues, run smoothly
- Can handle large tile maps
- Multiple viewports work fine

3D Projects:
- Keep poly count low (<10k triangles visible)
- Limit real-time lights (max 2-3)
- Use baked lighting when possible
- Test on PC regularly for performance
- Editor will be slower with complex scenes
```

**VS Code Setup for Godot (Mac):**

```bash
# Install godot-tools extension
# In VS Code, install: "godot-tools" by geequlim

# Configure Godot to use VS Code
# In Godot: Editor → Editor Settings → Text Editor → External
# Exec Path: /usr/local/bin/code (or path to VS Code)
# Exec Flags: --goto {file}:{line}:{col}
```

---

### Gaming PC - 3D Games & Performance Testing

**Installation (Dual-Boot):**

**Windows (For Gaming + Godot):**

```bash
# Download from godotengine.org
# Install to: C:\Program Files\Godot

# Add to PATH for command-line access
# Or use Steam version (if available)

# Install Visual Studio (for C# support)
# Community edition is free
```

**Linux (For Clean Dev Environment):**

```bash
# Ubuntu/Debian
sudo snap install godot-4

# Or download from godotengine.org
wget https://downloads.tuxfamily.org/godotengine/4.x/Godot_v4.x_linux.x86_64.zip
unzip Godot_v4.x_linux.x86_64.zip
sudo mv Godot_v4.x_linux.x86_64 /opt/godot
sudo ln -s /opt/godot/godot /usr/local/bin/godot

# Install Blender (3D asset creation)
sudo snap install blender --classic
```

**Best For:**

- ✅ 3D game development (full power)
- ✅ Complex physics simulations
- ✅ High-poly models and scenes
- ✅ Real-time lighting and shadows
- ✅ Shader development
- ✅ Performance profiling
- ✅ Final builds and testing
- ✅ VR/AR (if exploring)

**GPU Configuration:**

```
RTX 4060 Advantages:
- Real-time ray tracing (if using Godot 4.x)
- Fast shader compilation
- Smooth editor viewport (60+ FPS in complex scenes)
- Multiple viewports for debugging
- Baking lightmaps quickly
- Video capture/streaming (OBS)

NVIDIA Settings:
- Enable CUDA for compatible plugins
- Set Godot.exe to "Prefer Maximum Performance"
- Use dedicated GPU (not integrated)
```

---

### NAS - Version Control & Automation

**Setup:**

```yaml
# docker-compose.yml addition for Godot CI/CD
services:
  # Godot Export Server
  godot-ci:
    image: barichello/godot-ci:4.2 # Or latest version
    container_name: godot-ci
    volumes:
      - /volume1/development/godot-projects:/projects
      - /volume1/development/godot-exports:/exports
    restart: unless-stopped
    # Used by CI/CD for automated builds

  # Gitea for version control (already in your setup)
  # Projects stored at: /volume1/development/git-server
```

**Best For:**

- ✅ Git repository hosting (Gitea)
- ✅ Automated exports (CI/CD)
- ✅ Asset storage (large textures, audio)
- ✅ Build artifact storage
- ✅ Backup of project files
- ✅ Collaboration (if working with others)

---

## 📁 Project Organization

### Recommended Structure

```
~/Developer/games/
├── my-games/                      # Your game projects
│   ├── platformer-2d/            # Example: 2D platformer
│   │   ├── .git/                 # Git repo
│   │   ├── project.godot         # Godot project file
│   │   ├── .gitignore           # Godot-specific ignores
│   │   ├── assets/
│   │   │   ├── sprites/
│   │   │   ├── audio/
│   │   │   ├── fonts/
│   │   │   └── shaders/
│   │   ├── scenes/
│   │   │   ├── characters/
│   │   │   ├── levels/
│   │   │   └── ui/
│   │   ├── scripts/
│   │   │   ├── player.gd
│   │   │   ├── enemy.gd
│   │   │   └── game_manager.gd
│   │   ├── builds/              # Export builds (gitignored)
│   │   │   ├── windows/
│   │   │   ├── macos/
│   │   │   ├── linux/
│   │   │   ├── ios/
│   │   │   ├── android/
│   │   │   └── web/
│   │   └── README.md
│   │
│   ├── rpg-3d/                   # Example: 3D RPG
│   │   └── [same structure]
│   │
│   └── mobile-puzzle/            # Example: Mobile game
│       └── [same structure]
│
├── godot-tutorial/               # Learning projects (already exists)
│   └── [tutorial projects]
│
└── shared-assets/                # Reusable assets
    ├── ui-themes/
    ├── sound-effects/
    ├── music/
    └── plugins/
```

### Git Configuration for Godot

**Create `.gitignore` for each project:**

```gitignore
# Godot-specific ignores
.import/
export.cfg
export_presets.cfg
.mono/
data_*/

# Builds (exported games)
builds/
*.app/
*.exe
*.dmg
*.zip
*.apk
*.aab

# OS-specific
.DS_Store
Thumbs.db
desktop.ini

# IDE
.vscode/
.idea/

# Logs
*.log
```

**Git LFS for Large Assets (Optional):**

```bash
# Install Git LFS
brew install git-lfs  # Mac
sudo apt install git-lfs  # Linux

# Initialize in project
cd ~/Developer/games/my-games/platformer-2d
git lfs install

# Track large files
git lfs track "*.png"
git lfs track "*.jpg"
git lfs track "*.wav"
git lfs track "*.mp3"
git lfs track "*.ogg"
git lfs track "*.blend"  # Blender files

# Commit .gitattributes
git add .gitattributes
git commit -m "Configure Git LFS"
```

---

## 🔄 Development Workflows

### Workflow 1: 2D Game (Mac-Primary)

**Day-to-Day Development:**

```
1. Work on Mac
   ├── Open project in Godot
   ├── Edit scenes and scripts
   ├── Test in editor (F5)
   ├── Commit changes to Git
   └── Push to NAS (Gitea)

2. Periodically test on PC
   ├── Pull from NAS
   ├── Test performance
   ├── Test on Windows
   └── Push any fixes

3. Automated builds on NAS (CI/CD)
   └── Export for all platforms nightly
```

**Example Daily Flow:**

```bash
# Morning - Mac
cd ~/Developer/games/my-games/platformer-2d
git pull origin main
open -a Godot project.godot

# [Work in Godot all day]

# Evening - Commit
git add .
git commit -m "Add enemy AI and level 2"
git push origin main

# Automated on NAS
# CI/CD triggers export of all platforms
# Builds available at: http://nas-ip:3000/builds/platformer-2d
```

---

### Workflow 2: 3D Game (PC-Primary)

**Development on PC:**

```
1. Boot PC into Windows or Linux

2. Clone project (first time)
   git clone http://nas-ip:3000/your-org/rpg-3d.git
   cd rpg-3d

3. Open in Godot
   # Linux: godot project.godot
   # Windows: godot.exe project.godot

4. Heavy development
   ├── 3D modeling and scene design
   ├── Lighting setup
   ├── Shader development
   ├── Physics testing
   └── Performance profiling

5. Regular commits
   git add .
   git commit -m "Add dungeon level with lighting"
   git push origin main

6. Test on Mac (occasionally)
   ├── Pull latest
   ├── Check if it runs at acceptable FPS
   └── Optimize if needed
```

**Asset Pipeline (3D):**

```
Blender (3D modeling) → Export → Godot
├── Create model in Blender (on PC)
├── Export as .glb or .gltf
├── Import into Godot
└── Configure materials and physics

Alternative:
├── Model in Blender on PC
├── Save .blend file to NAS
└── Access from Mac if needed
```

---

### Workflow 3: Mobile Game (Cross-Development)

**Mac (iOS Focus):**

```
1. Develop game on Mac
   ├── 2D mobile game (portrait mode)
   ├── Touch controls
   └── Test in iOS Simulator

2. Export to iOS
   ├── Project → Export
   ├── iOS (Xcode project)
   └── Open in Xcode for final build

3. TestFlight deployment
   ├── Archive in Xcode
   ├── Upload to App Store Connect
   └── Test on real device
```

**PC (Android Focus):**

```
1. Pull project from NAS

2. Set up Android SDK
   ├── Download Android Studio
   ├── Install SDK tools
   └── Configure in Godot

3. Export to Android
   ├── Project → Export
   ├── Android (APK/AAB)
   └── Test on Android device or emulator

4. Push builds to NAS
   └── Share with testers
```

**Shared Development:**

```
Assets and Logic:
├── Develop on Mac (primary)
├── Test iOS builds on Mac
├── Test Android builds on PC
└── Keep in sync via Git (NAS)
```

---

## 🚀 Export & Distribution Strategy

### Export Templates Setup

**First-Time Setup (Do Once):**

```
1. In Godot: Editor → Manage Export Templates
2. Download official templates
3. Or compile custom templates if needed
```

**Export Presets (Per Project):**

```
Project → Export
├── Windows Desktop
│   ├── 64-bit: Yes
│   ├── Icon: res://icon.ico
│   └── Executable name: game.exe
│
├── macOS
│   ├── App name: MyGame.app
│   ├── Identifier: com.yourstudio.mygame
│   └── Code signing: (for distribution)
│
├── Linux/X11
│   ├── 64-bit: Yes
│   └── Executable: game.x86_64
│
├── iOS
│   ├── App Store Team ID: (your ID)
│   ├── Bundle Identifier: com.yourstudio.mygame
│   └── Provisioning profile
│
├── Android
│   ├── Package name: com.yourstudio.mygame
│   ├── Keystore: (for release)
│   └── Architectures: arm64-v8a, armeabi-v7a
│
└── Web (HTML5)
    ├── Export type: Regular
    └── Head include: (analytics, etc.)
```

### Platform-Specific Build Locations

**Mac → iOS:**

```bash
# Export from Godot
# Output: builds/ios/MyGame.xcodeproj

# Open in Xcode
open builds/ios/MyGame.xcodeproj

# Archive and upload to App Store Connect
# Product → Archive → Distribute App
```

**PC → Windows:**

```bash
# Export from Godot
# Output: builds/windows/game.exe

# Test locally
./builds/windows/game.exe

# Package for distribution
# Zip or create installer (NSIS, Inno Setup)
```

**PC → Android:**

```bash
# Export from Godot
# Output: builds/android/game.apk (debug)
#         builds/android/game.aab (release)

# Install on device for testing
adb install builds/android/game.apk

# Upload .aab to Google Play Console for release
```

**Any → Web:**

```bash
# Export from Godot
# Output: builds/web/index.html + assets

# Test locally
cd builds/web
python3 -m http.server 8000
# Open: http://localhost:8000

# Deploy to NAS or web hosting
# Upload to: itch.io, GitHub Pages, Netlify, etc.
```

---

## 🤖 Automated Builds (NAS CI/CD)

### Drone CI Configuration

**Create `.drone.yml` in project root:**

```yaml
kind: pipeline
name: godot-export

steps:
  # Export Windows build
  - name: export-windows
    image: barichello/godot-ci:4.2
    commands:
      - mkdir -p builds/windows
      - godot --headless --export "Windows Desktop" builds/windows/game.exe

  # Export Linux build
  - name: export-linux
    image: barichello/godot-ci:4.2
    commands:
      - mkdir -p builds/linux
      - godot --headless --export "Linux/X11" builds/linux/game.x86_64

  # Export Web build
  - name: export-web
    image: barichello/godot-ci:4.2
    commands:
      - mkdir -p builds/web
      - godot --headless --export "HTML5" builds/web/index.html

  # Archive builds
  - name: archive
    image: alpine
    commands:
      - apk add zip
      - cd builds/windows && zip -r ../windows-build.zip .
      - cd ../linux && zip -r ../linux-build.zip .
      - cd ../web && zip -r ../web-build.zip .

  # Upload to NAS storage
  - name: upload
    image: plugins/s3 # Or custom upload script
    settings:
      source: builds/*.zip
      target: /volume1/development/godot-exports/${DRONE_REPO_NAME}/${DRONE_BUILD_NUMBER}

trigger:
  branch:
    - main
  event:
    - push
    - tag
```

**Workflow:**

```
1. Push to main branch on Gitea (NAS)
2. Drone CI detects push
3. Builds export automatically
4. Builds available at: http://nas-ip:3000/builds/
5. Download and test
```

### Manual Export Script (Alternative)

**Create `export-all.sh`:**

```bash
#!/bin/bash
# Export all platforms locally

PROJECT_NAME="MyGame"
BUILD_DIR="builds"

echo "🎮 Exporting $PROJECT_NAME for all platforms..."

# Create build directory
mkdir -p "$BUILD_DIR"/{windows,macos,linux,web}

# Windows
echo "📦 Exporting Windows..."
godot --headless --export "Windows Desktop" "$BUILD_DIR/windows/$PROJECT_NAME.exe"

# macOS
echo "📦 Exporting macOS..."
godot --headless --export "macOS" "$BUILD_DIR/macos/$PROJECT_NAME.zip"

# Linux
echo "📦 Exporting Linux..."
godot --headless --export "Linux/X11" "$BUILD_DIR/linux/$PROJECT_NAME.x86_64"

# Web
echo "📦 Exporting Web..."
godot --headless --export "HTML5" "$BUILD_DIR/web/index.html"

echo "✅ Export complete! Builds in: $BUILD_DIR/"
```

**Usage:**

```bash
# Make executable
chmod +x export-all.sh

# Run
./export-all.sh
```

---

## 🎨 Asset Management

### Working with Large Assets

**Storage Strategy:**

```
Small Assets (< 1MB):
├── Store in Git (with LFS)
├── Commit directly to repo
└── Available on all machines

Large Assets (> 1MB):
├── Store on NAS
├── Use Git LFS
└── Or reference via NAS mount

Huge Assets (> 100MB):
├── Store on NAS only
├── Don't commit to Git
├── Document in README
└── Download manually when needed
```

**NAS Asset Library:**

```
/volume1/development/godot-shared/
├── textures/
│   ├── environments/
│   ├── characters/
│   └── ui/
├── models/
│   ├── props/
│   └── characters/
├── audio/
│   ├── music/
│   └── sfx/
└── plugins/
    └── [reusable Godot plugins]
```

**Accessing from Projects:**

```bash
# Mount NAS share on Mac
~/NAS/development/godot-shared → /volume1/development/godot-shared

# Symlink in project
cd ~/Developer/games/my-games/platformer-2d
ln -s ~/NAS/development/godot-shared shared-assets

# Or copy specific assets when needed
cp ~/NAS/development/godot-shared/audio/music/theme.ogg assets/audio/
```

---

## 🧪 Testing Strategy

### Performance Testing

**Mac (2D Projects):**

```
Target: 60 FPS
├── Test in editor (F5)
├── Profile with Godot profiler
├── Check frame time (< 16.6ms)
└── Monitor with Activity Monitor

Acceptable:
✅ 60 FPS in 2D games
✅ Simple 3D scenes (low poly)
⚠️ 30+ FPS for mobile games (acceptable on device)
```

**PC (3D Projects):**

```
Target: 60+ FPS (can handle 120+ FPS)
├── Test complex scenes
├── Stress test with many objects
├── Profile GPU usage (NVIDIA overlay)
└── Test ray tracing (if using)

Optimization on PC:
├── If < 60 FPS on PC, will be unplayable on Mac
├── Optimize until 120+ FPS on PC
└── Then test on Mac (should be 30-60 FPS)
```

### Multi-Platform Testing

**Testing Checklist:**

```
For Each Platform:
□ Launch and run without crashes
□ Input controls work (keyboard, mouse, gamepad, touch)
□ Graphics render correctly
□ Audio plays correctly
□ Save/load works
□ Performance is acceptable
□ UI scales properly
□ No platform-specific bugs

Platforms:
□ Windows (PC)
□ macOS (Mac)
□ Linux (PC or VM)
□ iOS (Mac + real device)
□ Android (PC + real device or emulator)
□ Web (any browser)
```

---

## 📚 Learning Resources & Templates

### Getting Started Projects

**Create template projects:**

```bash
cd ~/Developer/templates/
mkdir godot-templates

# 2D Platformer template
godot-templates/
├── 2d-platformer-starter/
│   ├── Basic player movement
│   ├── Enemy AI
│   ├── Level template
│   └── UI system
│
├── 2d-topdown-starter/
│   ├── Top-down movement
│   ├── Inventory system
│   └── Basic combat
│
├── 3d-fps-starter/
│   ├── First-person controller
│   ├── Weapon system
│   └── Level geometry
│
└── mobile-template/
    ├── Touch controls
    ├── Menu system
    └── Ads integration (optional)
```

### Recommended Learning Path

**Week 1-2: Godot Basics (Use Mac)**

```
- Official Godot tutorials
- "Your First 2D Game" tutorial
- Learn GDScript
- Understand nodes and scenes
- Build simple games
```

**Week 3-4: 2D Game Development (Mac)**

```
- Platformer game
- Top-down game
- UI and menus
- State machines
- Save/load system
```

**Week 5-6: 3D Basics (Switch to PC)**

```
- 3D navigation and camera
- Lighting and materials
- Simple 3D game
- Physics and collisions
```

**Week 7-8: Mobile Development (Mac for iOS, PC for Android)**

```
- Touch input
- Screen resolutions
- Performance optimization
- Mobile-specific features
```

**Ongoing: Advanced Topics**

```
- Multiplayer (networking)
- Shaders and visual effects
- AI and pathfinding
- Procedural generation
- Publishing and monetization
```

---

## 🔧 Troubleshooting Common Issues

### Mac-Specific Issues

**Problem: Low FPS in 3D scenes**

```
Solutions:
├── Reduce polygon count
├── Use LOD (Level of Detail) models
├── Bake lighting instead of real-time
├── Reduce shadow quality
├── Disable post-processing effects
└── Switch to PC for 3D development
```

**Problem: Export fails for iOS**

```
Solutions:
├── Ensure Xcode is installed
├── Update to latest Godot version
├── Check code signing certificates
├── Verify bundle identifier
└── Check export logs for errors
```

### PC-Specific Issues

**Problem: NVIDIA GPU not being used**

```
Solutions:
├── NVIDIA Control Panel → Manage 3D Settings
├── Add godot.exe → High-performance NVIDIA processor
├── Set "Power management mode" to "Prefer maximum performance"
└── Restart Godot
```

**Problem: Dual-boot game project sync**

```
Solutions:
├── Store projects on shared NTFS partition
├── Or use NAS (recommended)
├── Always commit before switching OS
└── Pull after switching OS
```

### Cross-Platform Issues

**Problem: Game works on PC but crashes on Mac**

```
Debug steps:
├── Check export log on Mac
├── Test in Mac Godot editor first
├── Common causes:
│   ├── Windows-specific file paths (use res://)
│   ├── Missing resources
│   ├── Platform-specific code not wrapped
│   └── Shader compatibility
└── Use print() debug statements
```

---

## 📋 Quick Reference Commands

### Mac

```bash
# Open Godot
open -a Godot project.godot

# Export headless
godot --headless --export "macOS" builds/mac/game.zip

# Run tests
godot --headless --script test_runner.gd
```

### PC (Linux)

```bash
# Open Godot
godot project.godot

# Export
godot --headless --export "Windows Desktop" builds/windows/game.exe

# Monitor GPU
nvidia-smi -l 1
```

### Git Workflow

```bash
# Daily workflow
git pull                          # Get latest
# [work in Godot]
git add .
git commit -m "Add feature X"
git push                          # Upload to NAS

# Before switching machines
git push                          # Save work

# On other machine
git pull                          # Get latest work
```

---

## 🎯 Best Practices Summary

1. **Machine Usage:**

   - Mac: 2D games, prototypes, iOS builds
   - PC: 3D games, Android builds, performance testing
   - NAS: Git hosting, automated builds, asset storage

2. **Version Control:**

   - Commit often (daily or after features)
   - Use meaningful commit messages
   - Push to NAS regularly
   - Use Git LFS for large assets

3. **Performance:**

   - Target 60 FPS minimum
   - Test on weakest device (Mac for you)
   - Profile regularly
   - Optimize early for 3D

4. **Assets:**

   - Organize by type (sprites, audio, etc.)
   - Use consistent naming
   - Document large asset locations
   - Share common assets via NAS

5. **Exports:**
   - Test each platform regularly
   - Automate when possible
   - Keep export templates updated
   - Document platform-specific requirements

---

**Status:** Workflow planning complete. Ready for implementation when you are!

**Next Steps (When Ready):**

1. Set up first Godot project
2. Configure Git repo on NAS
3. Set up export templates
4. Create CI/CD pipeline
5. Start building!
