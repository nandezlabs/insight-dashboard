# 📱 iOS Development Workflow (Godot)

**Created:** December 10, 2025  
**Platform:** iOS (iPhone/iPad)  
**Distribution:** App Store

---

## 🎯 Platform Overview

### Why iOS?

**Pros:**

- ✅ Premium market (users willing to pay)
- ✅ Single ecosystem (easier testing)
- ✅ Better monetization (higher ARPU)
- ✅ TestFlight for easy beta testing
- ✅ Quality control (App Store review)

**Cons:**

- ❌ Apple Developer Account required ($99/year)
- ❌ Mac required for final build
- ❌ Strict review guidelines
- ❌ 30% revenue cut to Apple
- ❌ Limited device testing (expensive)

**Best For:**

- Premium games ($2.99+)
- Polished, high-quality experiences
- Games targeting Western markets
- Developers with Mac hardware

---

## 🛠️ Setup Requirements

### Before You Start

**Hardware:**

- [ ] Mac (for Xcode and final build)
- [ ] iPhone/iPad for testing (recommended)

**Software:**

- [ ] macOS 13+ (Ventura or newer)
- [ ] Xcode 15+ (free from App Store)
- [ ] Godot 4.x with iOS export templates
- [ ] Apple Developer Account ($99/year)

**Accounts:**

- [ ] Apple ID
- [ ] Apple Developer Program membership
- [ ] App Store Connect access

### Initial Setup (One-Time)

```bash
# Install Xcode from App Store
open "https://apps.apple.com/us/app/xcode/id497799835"

# Install Xcode command-line tools
xcode-select --install

# Install Godot iOS export templates
# In Godot: Editor → Manage Export Templates → Download and Install
```

---

## 📋 Pre-Production Planning

### Technical Requirements

**iOS Version Support:**

```yaml
Minimum iOS: 12.0+ (recommended)
Target iOS: Latest (17+ as of 2025)
Device Support: [iPhone only / iPad only / Universal]
Orientation: [Portrait / Landscape / Both]
```

**Performance Targets:**

```
iPhone 12+ (Modern):  60 FPS
iPhone 8-11 (Mid):    60 FPS with reduced effects
iPhone SE (Low-end):  30-60 FPS (acceptable)

iPad Pro:             60-120 FPS
iPad Air/Mini:        60 FPS
```

**Screen Sizes to Support:**

```
iPhone SE:     4.7" (1334x750)
iPhone 13/14:  6.1" (2532x1170)
iPhone 14 Pro: 6.7" (2796x1290)

iPad Mini:     8.3" (2266x1488)
iPad Air:      10.9" (2360x1640)
iPad Pro 12.9: 12.9" (2732x2048)
```

### Design Considerations

**Touch Controls:**

- [ ] Design for thumbs (UI at bottom on phones)
- [ ] Min button size: 44x44 points (Apple guideline)
- [ ] Plan for one-handed or two-handed play
- [ ] Avoid UI in notch/safe areas
- [ ] Test on smallest supported device first

**Apple Design Guidelines:**

- [ ] Respect safe areas (no UI under notch)
- [ ] Use native iOS fonts/styles (or custom)
- [ ] Follow Human Interface Guidelines
- [ ] Support Dark Mode (recommended)
- [ ] Provide app icons in all required sizes

---

## 🎮 Development Workflow

### Phase 1: Godot Setup

**1. Configure Project for iOS:**

```gdscript
# Project Settings → General → Display
window/size/viewport_width = 1170  # iPhone 13 width
window/size/viewport_height = 2532 # iPhone 13 height
window/size/mode = 3  # Viewport scaling
window/stretch/mode = "canvas_items"
window/stretch/aspect = "expand"

# Project Settings → General → Rendering
renderer/rendering_method = "mobile"  # Better for iOS
```

**2. Set Up Export Preset:**

```
Project → Export → Add → iOS

Template Settings:
- App Store Team ID: [Your Team ID from developer.apple.com]
- Bundle Identifier: com.yourstudio.yourgame
- App Name: Your Game Name
- Version: 1.0
- Build Number: 1

Code Signing:
- Automatically Managed Signing: On (recommended)
- Or: Manual signing with provisioning profile

Icons:
- Add icons for all sizes (20pt to 1024pt)
- Use Asset Catalog (iOS Icons)

Launch Screen:
- Configure storyboard or use image
```

**3. Test in Godot:**

```
# Use iOS simulator mode (limited)
Project → Run → Run on Device (if connected)

# Or export and test on real device
```

---

### Phase 2: Development

**Daily Workflow:**

```bash
# Morning - Start development
cd ~/Developer/games/my-games/your-game
git pull
open -a Godot project.godot

# Develop in Godot
# Press F5 to test on Mac (limited touch simulation)

# Export test build for iOS
# Project → Export → iOS → Export Project
# Output: builds/ios/your-game.xcodeproj

# Open in Xcode
open builds/ios/your-game.xcodeproj

# In Xcode:
# 1. Connect iPhone/iPad
# 2. Select your device as target
# 3. Click Run (▶️) button
# 4. Test on real device

# Evening - Commit changes
git add .
git commit -m "Add feature X, test on iOS"
git push
```

**Testing Strategy:**

```
Level 1: Godot Editor (Mac)
  ↓ Test basic functionality, quick iteration

Level 2: iOS Simulator (Xcode)
  ↓ Test UI layout, basic interactions

Level 3: Real Device (iPhone/iPad)
  ↓ Test touch, performance, final validation
```

---

### Phase 3: Optimization

**Performance Optimization:**

```gdscript
# Enable Metal rendering (iOS native)
# Project Settings → Rendering
rendering/renderer/rendering_method = "mobile"
rendering/limits/buffers/canvas_polygon_buffer_size_kb = 128
rendering/limits/buffers/immediate_buffer_size_kb = 512

# Texture compression
rendering/textures/vram_compression/import_etc2_astc = true

# Reduce draw calls
# Batch sprites together
# Use TextureAtlas for multiple sprites
```

**Memory Management:**

```gdscript
# Monitor memory usage
print("Memory: ", Performance.get_monitor(Performance.MEMORY_STATIC))

# Free resources when not needed
func _exit_tree():
    texture = null
    audio_stream = null

# Use object pooling for frequent spawns
var pool = []
func get_enemy():
    if pool.size() > 0:
        return pool.pop_back()
    return preload("res://enemy.tscn").instantiate()
```

**Battery Optimization:**

```
- Limit frame rate to 60 FPS (no higher on most devices)
- Reduce particle effects
- Use static lighting where possible
- Minimize background processing
- Pause game when inactive
```

---

## 📦 Export & Distribution

### Build Process

**1. Prepare for Export:**

```bash
# Update version numbers
# project.godot → Application → Config → Version
# Also update iOS build number

# Clean previous builds
rm -rf builds/ios/

# Export from Godot
# Project → Export → iOS → Export Project
# Save to: builds/ios/YourGame.xcodeproj
```

**2. Configure in Xcode:**

```
Open builds/ios/YourGame.xcodeproj

General Tab:
- Display Name: [Game Name]
- Bundle Identifier: com.yourstudio.yourgame
- Version: 1.0.0
- Build: 1

Signing & Capabilities:
- ✅ Automatically manage signing
- Team: [Your Team]
- Add capabilities if needed:
  • Game Center
  • In-App Purchase
  • Push Notifications

Info Tab:
- Privacy - Camera Usage Description (if using camera)
- Privacy - Microphone Usage Description (if using mic)
```

**3. Build Archive:**

```
In Xcode:
1. Select "Any iOS Device" as target
2. Product → Archive
3. Wait for build to complete (can take 5-15 minutes)
4. Organizer window opens automatically
```

---

### TestFlight Beta Testing

**1. Upload to App Store Connect:**

```
In Xcode Organizer:
1. Select your archive
2. Click "Distribute App"
3. Choose "App Store Connect"
4. Select "Upload"
5. Choose signing options:
   • Automatically manage signing (recommended)
   • Or manual signing
6. Click "Upload"
7. Wait for processing (10-30 minutes)
```

**2. Configure TestFlight:**

```
Visit: https://appstoreconnect.apple.com

1. Select your app
2. Go to TestFlight tab
3. Select build (will appear after processing)
4. Fill out "What to Test" notes
5. Add internal testers (up to 100)
6. Or add external testers (up to 10,000)
   - Requires beta app review (1-2 days)
```

**3. Invite Testers:**

```
Internal Testers (instant):
- Add by email
- They get immediate access
- Great for team/friends

External Testers (needs review):
- Submit for beta review
- 1-2 days approval
- Public link or email invites
- Great for community testing
```

---

### App Store Submission

**1. Prepare App Store Listing:**

```yaml
Required Assets:
  App Name: [Max 30 characters]
  Subtitle: [Max 30 characters]

  Screenshots:
    - iPhone 6.7": 3-10 screenshots (2796x1290)
    - iPhone 6.5": 3-10 screenshots (2688x1242)
    - iPad Pro 12.9": 3-10 screenshots (2732x2048)

  App Preview Video: [Optional, but recommended]
    - 15-30 seconds
    - Landscape or Portrait

  Description: [Max 4000 characters]
  Keywords: [Max 100 characters, comma separated]
  Support URL: [Your support website]
  Marketing URL: [Optional]

  App Icon: 1024x1024 PNG (no transparency)

  Age Rating: [Complete questionnaire]
  Category: [Primary + Secondary]
  Price: [$0.99, $1.99, $2.99, $4.99, etc.]
```

**2. Fill Out App Information:**

```
In App Store Connect:

Version Information:
- What's New in This Version
- Promotional Text (appears above description)

App Store Optimization (ASO):
- Use relevant keywords
- Compelling description
- Eye-catching screenshots
- Show gameplay clearly
```

**3. Submit for Review:**

```
1. Select build from TestFlight
2. Fill all required information
3. Answer app review questions:
   • Does it use encryption? (Usually NO for games)
   • Age rating confirmation
   • Content rights (you own the content)
4. Click "Submit for Review"
5. Wait 1-3 days for review
```

---

## 💰 Monetization Strategies

### Pricing Models

**Premium ($0.99 - $9.99):**

```yaml
Pros:
  - Immediate revenue
  - No ads needed
  - Complete game from start

Cons:
  - Lower download numbers
  - Must prove value upfront

Best For:
  - Polished, complete games
  - Story-driven experiences
  - Premium puzzle games
```

**Free + IAP:**

```yaml
Pros:
  - More downloads
  - Lower barrier to entry
  - Can earn more over time

Cons:
  - Need compelling IAP
  - Balancing free/paid content

Best For:
  - F2P mobile games
  - Cosmetic unlocks
  - Level packs
```

**Free + Ads:**

```yaml
Pros:
  - Completely free to play
  - Steady revenue stream

Cons:
  - Need high player count
  - Ads can harm experience

Best For:
  - Casual games
  - High replay value
  - Large audience targets
```

### Implementing IAP (In-App Purchases)

```gdscript
# Use Godot iOS IAP plugin
# Or implement via iOS StoreKit

# Example: Unlock full game
var iap_manager = InAppStore.new()

func unlock_full_game():
    if iap_manager.purchase("com.yourstudio.yourgame.unlock"):
        Game.full_version = true
        save_game()
```

---

## 🧪 Testing Checklist

### Pre-Submission Testing

**Device Testing:**

- [ ] Test on smallest supported device (iPhone SE)
- [ ] Test on largest device (iPad Pro)
- [ ] Test on notched devices (iPhone 13+)
- [ ] Test on older iOS version (minimum supported)
- [ ] Test on latest iOS version

**Functionality:**

- [ ] App launches without crash
- [ ] Tutorial/onboarding works
- [ ] All touch controls responsive
- [ ] Game can be completed
- [ ] Save/load works correctly
- [ ] IAP works (if applicable)
- [ ] Restore purchases works
- [ ] Game Center works (if used)
- [ ] Audio works correctly
- [ ] Respects silent mode switch
- [ ] Handles interruptions (calls, notifications)
- [ ] Background/foreground transitions
- [ ] Landscape/portrait orientation correct

**Performance:**

- [ ] Maintains target FPS (30-60)
- [ ] No memory leaks
- [ ] Battery usage acceptable
- [ ] Loading times under 3 seconds
- [ ] App size under 200MB (recommended)

---

## 🚫 Common Rejection Reasons

### App Store Review Guidelines

**Avoid These:**

1. **Crashes or Bugs**

   - Most common rejection
   - Test thoroughly before submission

2. **Misleading Screenshots**

   - Must show actual gameplay
   - No fake UI elements

3. **Incomplete Information**

   - Missing privacy policy (if collecting data)
   - Incomplete app description

4. **Copycat Games**

   - Too similar to existing games
   - Using others' IP without permission

5. **Inappropriate Content**

   - Follow age rating guidelines
   - No hate speech, violence (unless appropriate rating)

6. **Broken Features**
   - All advertised features must work
   - No placeholder content

---

## 📊 Post-Launch

### Week 1: Monitor & Respond

```bash
Daily Tasks:
- [ ] Check crash reports (Xcode Organizer)
- [ ] Read user reviews
- [ ] Monitor download numbers
- [ ] Respond to critical bugs immediately
- [ ] Collect feedback for update
```

### Updates & Iterations

**Update Schedule:**

```
Week 1: Hot-fix critical bugs
Week 2-3: Collect feedback
Week 4: Submit 1.1 update
Month 2: Major content update (1.2)
Month 3: Based on user requests (1.3)
```

**Version Numbering:**

```
1.0.0 - Initial release
1.0.1 - Bug fixes
1.1.0 - Minor features
2.0.0 - Major update
```

---

## 🔧 Quick Reference

### Export Command Line

```bash
# Export from terminal (automation)
godot --headless --export-release "iOS" builds/ios/game.xcodeproj
```

### Common Xcode Commands

```bash
# Build from command line
xcodebuild -project YourGame.xcodeproj -scheme YourGame -configuration Release

# Create archive
xcodebuild archive -project YourGame.xcodeproj -scheme YourGame -archivePath ./builds/YourGame.xcarchive
```

### Useful Links

```
App Store Connect:
https://appstoreconnect.apple.com

Developer Portal:
https://developer.apple.com

TestFlight:
https://testflight.apple.com

Human Interface Guidelines:
https://developer.apple.com/design/human-interface-guidelines/ios

App Store Review Guidelines:
https://developer.apple.com/app-store/review/guidelines/
```

---

**Timeline Example:**

```
Week 1-4:   Development (build core game on Mac)
Week 5:     iOS optimization and export setup
Week 6:     TestFlight beta testing
Week 7:     Fix bugs from feedback
Week 8:     Final polish and submission
Week 9:     App review (while you wait)
Week 10:    Launch! 🎉
```

**Key Takeaway:**

> iOS development requires Mac hardware and patience with App Store review, but offers a premium market with high-quality players willing to pay for great games.
