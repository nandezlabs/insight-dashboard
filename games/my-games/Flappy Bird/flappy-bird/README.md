# 🐦 Flappy Bird Clone

A Flappy Bird clone built with Godot 4.x

## 📋 Project Info

- **Engine:** Godot 4.4
- **Type:** 2D Game
- **Platform:** Cross-platform (Desktop, Mobile, Web)
- **Language:** GDScript

## 📁 Project Structure

```
flappy-bird/
├── assets/           # Game assets
│   ├── sprites/     # Character and environment sprites
│   ├── audio/       # Sound effects and music
│   └── fonts/       # UI fonts
├── scenes/          # Godot scene files
│   ├── characters/  # Player and enemies
│   ├── levels/      # Game levels
│   └── ui/          # Menus and HUD
├── scripts/         # GDScript files
├── builds/          # Exported builds (gitignored)
└── project.godot    # Godot project file
```

## 🎮 Development

### Prerequisites

- Godot 4.4+ installed
- Git with LFS (for large assets)

### Opening the Project

```bash
# Clone the repository
git clone <repository-url>
cd flappy-bird

# Open in Godot
godot project.godot
```

### Running the Game

- Press `F5` in Godot editor to run
- Or click the Play button in the top-right

## 🚀 Building / Exporting

### Quick Export

```bash
# Make the export script executable
chmod +x export-all.sh

# Run all exports
./export-all.sh
```

### Manual Export

1. Open Project → Export
2. Select target platform
3. Click "Export Project"

### Available Platforms

- ✅ Windows Desktop
- ✅ macOS
- ✅ Linux
- ✅ iOS (requires Xcode)
- ✅ Android (requires Android SDK)
- ✅ Web (HTML5)

## 📱 Platform-Specific Notes

### macOS Development

- Best for 2D development and prototyping
- Native Apple Silicon support
- Export to iOS directly

### PC (Windows/Linux)

- Use for testing Windows builds
- Android export capability
- Performance testing

### Mobile

- **iOS:** Export from macOS
- **Android:** Export from PC or macOS

## 🎨 Asset Guidelines

### Sprites

- Format: PNG with transparency
- Size: Power of 2 (32x32, 64x64, etc.)
- Location: `assets/sprites/`

### Audio

- Format: OGG (recommended) or WAV
- Sample rate: 44100 Hz
- Location: `assets/audio/`

### Fonts

- Format: TTF or OTF
- Location: `assets/fonts/`

## 🧪 Testing

### Performance Targets

- **Desktop:** 60 FPS
- **Mobile:** 30-60 FPS
- **Web:** 30+ FPS

### Testing Checklist

- [ ] Game launches without errors
- [ ] Player controls work (tap/click/keyboard)
- [ ] Collision detection works
- [ ] Score updates correctly
- [ ] Game over screen appears
- [ ] Restart functionality works
- [ ] Audio plays correctly

## 🔧 Common Issues

### Sprites not showing

- Check import settings in Godot
- Verify file paths in scene
- Ensure sprites are in `assets/sprites/`

### Low FPS

- Reduce sprite resolution
- Optimize collision shapes
- Check for memory leaks

## 📝 Git Workflow

```bash
# Daily workflow
git pull                           # Get latest changes
# [work in Godot]
git add .
git commit -m "Add feature X"
git push                          # Upload changes

# Before switching machines
git push                          # Save your work

# On other machine
git pull                          # Get latest work
```

## 📚 Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- [Flappy Bird Tutorial](https://www.youtube.com/results?search_query=godot+flappy+bird+tutorial)

## 📄 License

[Add your license here]

## 👤 Author

[Your name]

---

**Created:** December 2025  
**Engine:** Godot 4.4
