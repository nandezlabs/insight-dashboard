# 🌐 Web (HTML5) Development Workflow (Godot)

**Created:** December 10, 2025  
**Platform:** Web Browsers (Desktop & Mobile)  
**Distribution:** Itch.io, Newgrounds, Poki, Your own website

---

## 🎯 Platform Overview

### Why Web?

**Pros:**

- ✅ Zero friction - plays in browser, no download
- ✅ Cross-platform automatically (Desktop + Mobile browsers)
- ✅ Easy to share (just a link)
- ✅ Fast iteration and updates
- ✅ No app store approval needed
- ✅ Can embed anywhere (website, portfolio)
- ✅ Free hosting options available

**Cons:**

- ❌ Performance limitations (slower than native)
- ❌ File size constraints (keep under 50-100MB)
- ❌ Browser compatibility issues
- ❌ Limited monetization options
- ❌ Cannot access full device features
- ❌ Requires internet connection
- ❌ Less discovery than app stores

**Best For:**

- Casual games
- Jam games / prototypes
- Marketing demos
- Portfolio pieces
- Browser-based multiplayer
- Quick viral games
- Educational games

---

## 🛠️ Setup Requirements

### Before You Start

**Hardware:**

- Any computer with modern browser (Mac/PC/Linux)

**Software:**

- Godot 4.x with HTML5 export templates
- Modern browser (Chrome 90+, Firefox 88+, Safari 14+)
- Local web server for testing (Python included)
- Text editor for HTML/CSS customization (optional)

**Hosting Options:**

- Itch.io (free, game-focused)
- GitHub Pages (free, requires GitHub)
- Netlify/Vercel (free tier available)
- Your own web hosting
- Newgrounds (free, older audience)
- Poki, Crazy Games (rev-share, needs approval)

---

## 📋 Pre-Production Planning

### Technical Constraints

**File Size Limits:**

```yaml
Itch.io:         1 GB max (but aim for <100MB)
Newgrounds:      200 MB recommended
Poki:           50 MB max
GitHub Pages:    1 GB per repo
Your hosting:    Depends on plan

Recommended:     20-50 MB total
  ↓
Means careful asset optimization!
```

**Performance Targets:**

```
Desktop Browser:
- Chrome/Edge:  60 FPS (WebGL2)
- Firefox:      60 FPS (WebGL2)
- Safari:       30-60 FPS (WebGL2 limited)

Mobile Browser:
- Android:      30-60 FPS
- iOS Safari:   30 FPS (acceptable)

Loading Time:
- First Load:   <10 seconds ideal
- Restart:      <3 seconds
```

**Browser Compatibility:**

```
Must Support:
- Chrome 90+ (Most users)
- Firefox 88+
- Safari 14+ (Important for iOS)
- Edge 90+

Test On:
- Desktop: Latest Chrome, Firefox
- Mobile: iOS Safari, Chrome Android
- Tablet: iPad Safari, Android Chrome
```

### Design Considerations

**Screen Size & Responsiveness:**

```
Design for:
  Desktop:   1920x1080 (most common)
  Laptop:    1366x768  (still popular)
  Tablet:    1024x768  (iPad)
  Mobile:    375x667   (iPhone SE size)

Strategy:
- Fixed aspect ratio OR
- Responsive scaling OR
- Multiple layouts
```

**Controls:**

```yaml
Desktop:
  - Keyboard (WASD, Arrows, Space)
  - Mouse (Click, Drag)
  - NO gamepad (unreliable in browser)

Mobile:
  - Touch (tap, swipe, drag)
  - Virtual buttons
  - Tilt (rarely, unreliable)

Best Practice:
  - Support BOTH keyboard AND mouse
  - Auto-detect touch vs mouse
  - Show appropriate controls
```

**Browser Limitations:**

```
Cannot Use:
- File system access (no save to disk)
- Microphone/camera (needs permission, limited)
- Full screen (needs user interaction)
- Clipboard (limited)
- High precision timing

Must Use Instead:
- LocalStorage (max 5-10MB per domain)
- IndexedDB (larger storage)
- Request permissions explicitly
- Fullscreen on button click only
```

---

## 🎮 Development Workflow

### Phase 1: Godot Configuration

**1. Project Settings for Web:**

```gdscript
# Project Settings → Display → Window
window/size/viewport_width = 1280
window/size/viewport_height = 720
window/size/resizable = true
window/stretch/mode = "canvas_items"
window/stretch/aspect = "expand"  # Or "keep" for fixed ratio

# Project Settings → Rendering
renderer/rendering_method = "gl_compatibility"  # Better web support
rendering/renderer/rendering_method.web = "gl_compatibility"
rendering/limits/buffers/canvas_polygon_buffer_size_kb = 128

# Project Settings → Network (if using multiplayer)
network/limits/debugger/remote_port = 6007
network/limits/debugger/max_queued_messages = 2048
```

**2. Input Handling (Mouse + Touch):**

```gdscript
# Detect input type
var is_mobile = OS.has_touchscreen_ui_hint()

func _input(event):
    # Handle both mouse and touch
    if event is InputEventScreenTouch or event is InputEventMouseButton:
        if event.pressed:
            handle_press(event.position)

    # Keyboard for desktop
    if event is InputEventKey:
        handle_keyboard(event)

# Auto-detect and show appropriate controls
func _ready():
    if is_mobile:
        $VirtualControls.show()
        $KeyboardHint.hide()
    else:
        $VirtualControls.hide()
        $KeyboardHint.show()
```

**3. Asset Optimization:**

```bash
# Compress images aggressively
# Project Settings → Import Defaults → Texture
compression_mode = "Lossy"  # Or VRAM compressed
mipmaps/generate = true     # Better performance

# Reduce audio quality
# Import tab → Audio
compression = "OGG Vorbis"
quality = 0.7  # Balance between size and quality

# Limit particle count
max_particles = 50  # Instead of 1000

# Use simple shaders
# Avoid complex post-processing
```

---

### Phase 2: Export Configuration

**1. HTML5 Export Setup:**

```
Project → Export → Add → Web

Export Settings:
  Name: Web
  Runnable: ✓

HTML:
  Export Type: Regular (or Threads if needed)
  Custom HTML Shell: [Optional custom template]
  Head Include: [Optional analytics/ads]

Texture:
  VRAM Compression: For Web ✓

Resources:
  Export Mode: Export all resources in the project
  Filters: [Leave default unless optimizing]
```

**2. Create Custom HTML Template (Optional):**

```html
<!-- custom_shell.html -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, user-scalable=no"
    />
    <title>Your Game Title</title>
    <style>
      body {
        margin: 0;
        padding: 0;
        background: #000;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        font-family: Arial, sans-serif;
      }
      #canvas {
        display: block;
        max-width: 100%;
        max-height: 100vh;
      }
      #loading {
        color: white;
        text-align: center;
      }
    </style>
  </head>
  <body>
    <div id="loading">
      <h1>Loading...</h1>
      <div id="progress">0%</div>
    </div>
    <canvas id="canvas"> Your browser doesn't support HTML5 canvas. </canvas>

    <script src="$GODOT_HEAD_INCLUDE"></script>
    <script>
      var engine = new Engine($GODOT_CONFIG);

      engine.startGame({
        onProgress: function (current, total) {
          var percent = Math.floor((current / total) * 100);
          document.getElementById("progress").textContent = percent + "%";
          if (percent === 100) {
            document.getElementById("loading").style.display = "none";
          }
        },
      });
    </script>
  </body>
</html>
```

**3. Export for Web:**

```bash
# Export from Godot
Project → Export → Web → Export Project
Save to: builds/web/

# Output files:
builds/web/
├── index.html          # Main HTML file
├── index.js            # Godot engine
├── index.wasm          # Compiled game
├── index.pck           # Game assets
└── index.icon.png      # Favicon
```

---

### Phase 3: Local Testing

**1. Test with Local Server:**

```bash
# Navigate to build directory
cd builds/web/

# Start simple HTTP server
# Python 3 (Mac/Linux)
python3 -m http.server 8000

# Python 2 (if only option)
python -m SimpleHTTPServer 8000

# Open in browser
open http://localhost:8000
```

**2. Testing Checklist:**

```
Desktop Browser (Chrome):
- [ ] Game loads without errors
- [ ] Graphics render correctly
- [ ] Audio plays
- [ ] Keyboard controls work
- [ ] Mouse controls work
- [ ] Game runs at 60 FPS
- [ ] No console errors

Desktop Browser (Firefox):
- [ ] Same as Chrome

Desktop Browser (Safari):
- [ ] Same (may be slower)

Mobile (iPhone Safari):
- [ ] Game loads
- [ ] Touch controls work
- [ ] Performance acceptable (30+ FPS)
- [ ] Fits screen correctly
- [ ] No layout issues

Mobile (Android Chrome):
- [ ] Same as iOS
```

---

## 🌐 Deployment Platforms

### Option 1: Itch.io (Recommended for Indie)

**Why Itch.io:**

- Free hosting
- Game-focused audience
- No approval process
- Built-in payment system
- Community features
- Easy to update
- Good for jams and indie games

**Setup:**

```
1. Create itch.io account
2. Dashboard → Create New Project
3. Fill basic info:
   - Title
   - Project URL (yourname.itch.io/yourgame)
   - Short description
   - Classification: Game
   - Kind of project: HTML

4. Upload files:
   - ZIP your builds/web/ folder
   - Upload to itch.io
   - Check "This file will be played in the browser"
   - Set to "index.html" as main file

5. Configure:
   - Embed options:
     • Width: 1280, Height: 720 (or your game size)
     • Fullscreen button: ✓
     • Mobile friendly: ✓ (if applicable)

6. Publish:
   - Add screenshots
   - Add cover image (630x500)
   - Set pricing (Free or Paid)
   - Set visibility (Public/Restricted)
   - Click "Save & View Page"
```

**Monetization on Itch.io:**

```yaml
Free + Donations:
  - "Name your own price" (minimum $0)
  - Users can donate what they want
  - Good for jam games, prototypes

Paid:
  - Set minimum price ($0.99, $2.99, $4.99)
  - Itch.io takes 10% (you get 90%)
  - Can run sales easily

Free + Ads:
  - Not built-in on Itch.io
  - Can add your own ad code to HTML
```

---

### Option 2: Newgrounds

**Why Newgrounds:**

- Established gaming community (since 1995)
- Revenue sharing available
- User rating system
- No file size approval needed
- Built-in ad network

**Setup:**

```
1. Create Newgrounds account
2. Upload → Game
3. Game settings:
   - Title, description
   - Category (Action, Adventure, etc.)
   - Tags

4. Upload:
   - ZIP your web build
   - Upload to Newgrounds
   - Set dimensions (1280x720)

5. Monetization:
   - Join Newgrounds Ad Revenue program
   - Ads automatically shown
   - Earn based on plays

6. Submit for judgment:
   - Community votes on your game
   - Pass judgment = stays on site
   - Fail = removed (rare for quality games)
```

---

### Option 3: Game Portals (Poki, Crazy Games)

**Why Game Portals:**

- Massive audience (millions of players)
- Revenue sharing (can earn $$$ with hits)
- Professional distribution
- Mobile web traffic

**Requirements:**

```
Poki:
- File size: <50MB
- No external links
- Family-friendly content
- High quality gameplay
- Apply: developers.poki.com

Crazy Games:
- Similar to Poki
- <100MB
- Apply: developer.crazygames.com

Process:
1. Build game to their specs
2. Submit application
3. Wait for review (1-2 weeks)
4. If approved, they host and promote
5. Revenue share (typically 50/50 on ads)
```

---

### Option 4: GitHub Pages (Free)

**Why GitHub Pages:**

- Free hosting
- Good for portfolio
- Version control built-in
- Custom domain support
- Professional option

**Setup:**

```bash
# 1. Create GitHub repo
git init
git add .
git commit -m "Initial commit"

# 2. Create gh-pages branch
git checkout -b gh-pages

# 3. Add web build
cp -r builds/web/* .
git add .
git commit -m "Add web build"

# 4. Push to GitHub
git remote add origin https://github.com/yourusername/yourgame.git
git push origin gh-pages

# 5. Enable GitHub Pages
# Go to: Settings → Pages
# Source: gh-pages branch
# Save

# Your game will be at:
# https://yourusername.github.io/yourgame/
```

---

## 💰 Monetization

### Web Monetization Options

**1. Ads (Most Common):**

```javascript
// Add to custom HTML shell
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>

// Display ad on game over
function showAd() {
    // Show interstitial ad
    // Or banner ad between games
}

Pros:
- Easy to implement
- Passive income
- Works for free games

Cons:
- Disrupts gameplay
- Low revenue unless high traffic
- Ad blockers reduce income
```

**2. Premium / Pay-to-Play:**

```yaml
Itch.io Pricing:
  - Set minimum price
  - Offer playable demo + paid full game
  - Or pay-what-you-want model

Revenue:
  - Keep 90% (Itch takes 10%)
  - Can run sales
  - One-time payment
```

**3. Donations:**

```
- "Support the Developer" button
- Link to Ko-fi, Patreon, PayPal
- Completely optional for players
- Good for free games
```

---

## 🧪 Testing & Optimization

### Performance Optimization

**1. Reduce File Size:**

```bash
# Compress textures
# Use texture packer/atlas
# Remove unused assets

# Before export:
# Project → Project Settings → Compression
rendering/quality/driver/driver_name = "GLES3"  # Or GLES2 for wider support

# Check final size
du -sh builds/web/
# Target: <20MB ideal, <50MB acceptable
```

**2. Optimize Performance:**

```gdscript
# Limit draw calls
# Use CanvasLayer for UI
# Pool objects instead of create/destroy

# Example: Object pooling
var bullet_pool = []

func get_bullet():
    if bullet_pool.size() > 0:
        return bullet_pool.pop_back()
    return load("res://bullet.tscn").instantiate()

func return_bullet(bullet):
    bullet.hide()
    bullet_pool.append(bullet)
```

**3. Loading Optimization:**

```gdscript
# Show custom loading screen
# Load heavy assets asynchronously

func _ready():
    show_loading_screen()

    # Load resources in background
    ResourceLoader.load_threaded_request("res://heavy_asset.tscn")

func _process(_delta):
    var status = ResourceLoader.load_threaded_get_status("res://heavy_asset.tscn")
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        hide_loading_screen()
        start_game()
```

---

### Cross-Browser Testing

**Testing Matrix:**

```
✓ Desktop Chrome (Windows)
✓ Desktop Firefox (Windows)
✓ Desktop Safari (macOS)
✓ Desktop Edge (Windows)
✓ Mobile Safari (iPhone)
✓ Mobile Chrome (Android)
✓ Tablet iPad (Safari)

Common Issues:
- Audio autoplay blocked (need user interaction)
- Fullscreen requires button click
- Safari WebGL limitations
- Mobile performance varies widely
```

---

## 🚀 Launch Strategy

### Pre-Launch

**2 Weeks Before:**

- [ ] Game fully complete and tested
- [ ] All platforms tested (browsers/devices)
- [ ] Screenshots taken (at least 5)
- [ ] GIF/video trailer created
- [ ] Store page written
- [ ] Social media posts prepared

**1 Week Before:**

- [ ] Upload to platform(s)
- [ ] Set as "unlisted" for final testing
- [ ] Send to beta testers
- [ ] Fix any last issues
- [ ] Prepare launch announcement

**Launch Day:**

- [ ] Set game to "Public"
- [ ] Post on social media (Twitter, Reddit, Discord)
- [ ] Submit to game communities
- [ ] Post on IndieDB, Game Jolt
- [ ] Email press/YouTubers (if applicable)

---

### Post-Launch

**Week 1:**

```bash
Monitor:
- Player feedback (comments, reviews)
- Bug reports
- Analytics (plays, completion rate)
- Revenue (if monetized)

Respond:
- Reply to comments
- Fix critical bugs quickly
- Update game if needed (easy on web!)
```

**Ongoing:**

```
- Update based on feedback
- Add content if popular
- Run promotions/sales
- Post updates on social media
- Engage with community
```

---

## 📊 Analytics

### Track Player Behavior

**Google Analytics (Free):**

```html
<!-- Add to custom HTML -->
<script
  async
  src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"
></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag("js", new Date());
  gtag("config", "G-XXXXXXXXXX");
</script>
```

**Track Events from Godot:**

```gdscript
# Call JavaScript from Godot
func track_event(event_name: String, value: int = 0):
    if OS.has_feature("web"):
        JavaScriptBridge.eval("""
            gtag('event', '%s', {'value': %d});
        """ % [event_name, value])

# Usage:
track_event("level_complete", current_level)
track_event("game_over", score)
track_event("powerup_collected", powerup_type)
```

---

## 🔧 Quick Reference

### Export Script

```bash
#!/bin/bash
# export_web.sh

echo "Exporting for Web..."

# Clean previous build
rm -rf builds/web/

# Export
godot --headless --export-release "Web" builds/web/index.html

# Check size
echo "Build size:"
du -sh builds/web/

# Optionally start local server
echo "Starting local server..."
cd builds/web/
python3 -m http.server 8000
```

### Upload to Itch.io (Butler CLI)

```bash
# Install butler
# https://itchio.itch.io/butler

# Push build
butler push builds/web/ yourusername/yourgame:html5 --userversion 1.0.0

# Auto-updates your itch.io game
```

---

## 📝 Best Practices

### Do's ✅

- Optimize file size aggressively (<50MB)
- Test on mobile browsers
- Handle audio autoplay blocking
- Show loading progress
- Support fullscreen
- Make controls obvious
- Add "How to Play" instructions
- Responsive design for different screens

### Don'ts ❌

- Don't assume gamepad support
- Don't use advanced WebGL features (compatibility)
- Don't make file size huge (slow loading = bounce)
- Don't forget mobile users
- Don't autoplay audio (blocked anyway)
- Don't require plugins/downloads
- Don't use external dependencies that break offline

---

**Timeline Example:**

```
Week 1-4:   Development (design for web constraints)
Week 5:     Web export and optimization
Week 6:     Cross-browser testing
Week 7:     Platform setup (Itch.io, etc.)
Week 8:     Marketing prep
Week 9:     LAUNCH! 🎉
Week 10+:   Updates based on feedback
```

**Key Takeaway:**

> Web games offer instant access and easy sharing but require aggressive optimization. Perfect for reaching massive audiences quickly, especially for casual and jam games.
