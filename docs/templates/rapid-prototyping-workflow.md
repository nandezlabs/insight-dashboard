# ⚡ Rapid Prototyping Workflow (Godot)

**Created:** December 10, 2025  
**Goal:** Go from idea to playable prototype in hours/days, not weeks

---

## 🎯 Philosophy

### The Prototyping Mindset

**Core Principles:**

1. **Speed over perfection** - Make it work, not pretty
2. **Test the fun** - Prove the core mechanic first
3. **Fail fast** - Bad ideas are okay, find them quickly
4. **Placeholder everything** - Art comes later
5. **One feature at a time** - Build incrementally

**Quote to Remember:**

> "A prototype is meant to answer ONE question: Is this fun?"

---

## ⏱️ Time-Boxed Prototyping

### 2-Hour Prototype (Concept Test)

**Goal:** Can you control something and interact with one thing?

```
Hour 1: Core Movement
✓ Create player object (colored square)
✓ Add movement (WASD or click-to-move)
✓ Basic camera follow
✓ Simple collision

Hour 2: One Interaction
✓ Add one enemy/obstacle/collectible
✓ Add win condition OR lose condition
✓ Add simple feedback (sound/visual)
✓ Test: Is it interesting for 30 seconds?

Result: Answer "yes" or "no" to continue
```

---

### 1-Day Prototype (Core Loop)

**Goal:** Can you play for 5 minutes without getting bored?

```
Hours 1-2: Player mechanics (from 2-hour prototype)
Hours 3-4: Core game mechanic
  - What's the main action? (jump, shoot, match, etc.)
  - Does it feel good?
  - Add basic feedback

Hours 5-6: Basic loop
  - Add simple goal
  - Add scoring/progress
  - Add restart

Hours 7-8: Polish the feel
  - Tweak movement speed
  - Adjust difficulty
  - Add particle effects (minimal)
  - Add sound (3-5 sound effects max)

Result: Playable 5-minute experience
```

---

### 3-Day Prototype (Vertical Slice)

**Goal:** One complete level/experience that shows the game

```
Day 1: Core (use 1-day work)
  - Player movement
  - Main mechanic
  - Basic loop

Day 2: Content
  - Create 1 complete level
  - Add variety (3 enemy types OR 3 obstacles)
  - Add progression (difficulty curve)
  - Basic UI (score, health, timer)

Day 3: Polish & Juice
  - Better visuals (still placeholder)
  - More sound effects
  - Screen shake, particles
  - Menu (start, restart, quit)
  - Victory/defeat screens

Result: Something you can show people
```

---

## 🛠️ Rapid Development Techniques

### Template Setup (Do Once)

**Create a Godot Project Template:**

```
~/Developer/templates/godot-templates/quick-prototype/

Contains:
├── project.godot (pre-configured)
├── scenes/
│   ├── player.tscn (basic controller)
│   ├── ui.tscn (basic HUD)
│   └── main.tscn (game scene)
├── scripts/
│   ├── player.gd (movement template)
│   ├── game_manager.gd (singleton)
│   └── ui.gd (basic UI)
├── assets/
│   ├── placeholder_sprites/ (colored squares)
│   └── placeholder_sounds/ (basic beeps)
└── README.md (how to use)
```

**Project Settings (Pre-configured):**

```gdscript
# Display
window/size/viewport_width = 1280
window/size/viewport_height = 720
window/size/resizable = true

# Physics
physics/2d/default_gravity = 980  # Or 0 for top-down

# Input Map (already set up)
move_left, move_right, move_up, move_down
jump, shoot, interact
pause, restart
```

---

### Placeholder Assets

**Visual Placeholders (Use Built-in Godot Primitives):**

```gdscript
# Quick colored squares/circles
extends Sprite2D

func _ready():
    # Create simple colored square
    var texture = ImageTexture.create_from_image(Image.create(64, 64, false, Image.FORMAT_RGBA8))
    modulate = Color(1, 0, 0, 1)  # Red player
    # texture = texture
```

**Or use ColorRect for even faster:**

```gdscript
# Add ColorRect node
# Set size: 64x64
# Set color: Red for player, Blue for enemy, Yellow for collectible
# Done!
```

**Audio Placeholders:**

```bash
# Use synthesized beeps
# Or download free from:
https://sfxr.me  # Generate 8-bit sounds instantly

Quick sounds needed:
- Jump: "powerup" preset
- Shoot: "laser" preset
- Collect: "pickup" preset
- Death: "explosion" preset
- UI click: "blip" preset

Download as .wav, drag into Godot
```

---

### Code Templates

**Player Movement (2D Platformer):**

```gdscript
# player.gd - Copy-paste ready
extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
    # Gravity
    if not is_on_floor():
        velocity.y += gravity * delta

    # Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # Move
    var direction = Input.get_axis("move_left", "move_right")
    velocity.x = direction * speed

    move_and_slide()
```

**Player Movement (Top-Down):**

```gdscript
# player.gd - Top-down
extends CharacterBody2D

@export var speed = 200.0

func _physics_process(_delta):
    var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = input_dir * speed
    move_and_slide()
```

**Enemy (Simple Patrol):**

```gdscript
# enemy.gd
extends CharacterBody2D

@export var speed = 100.0
@export var patrol_distance = 200.0

var start_pos
var direction = 1

func _ready():
    start_pos = position

func _physics_process(_delta):
    # Simple back-and-forth
    velocity.x = direction * speed
    move_and_slide()

    # Flip direction at patrol limits
    if abs(position.x - start_pos.x) > patrol_distance:
        direction *= -1
```

**Collectible:**

```gdscript
# collectible.gd
extends Area2D

signal collected

func _ready():
    body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if body.name == "Player":
        collected.emit()
        queue_free()  # Remove from scene
```

**Game Manager (Singleton):**

```gdscript
# game_manager.gd (AutoLoad as "Game")
extends Node

var score = 0
var lives = 3
var level = 1

func add_score(amount: int):
    score += amount

func lose_life():
    lives -= 1
    if lives <= 0:
        game_over()

func game_over():
    get_tree().reload_current_scene()

func next_level():
    level += 1
    get_tree().reload_current_scene()
```

---

## 🎮 Prototyping Workflow

### Step-by-Step Process

**1. New Project from Template (1 minute):**

```bash
# Copy template
cp -r ~/Developer/templates/godot-templates/quick-prototype ~/Developer/games/my-games/new-prototype

cd ~/Developer/games/my-games/new-prototype
godot project.godot
```

**2. Define Core Mechanic (5 minutes):**

```markdown
# Quick Design Doc

Core Mechanic: [Jump between platforms]
Win Condition: [Reach the flag]
Lose Condition: [Fall off screen]
One Unique Thing: [Double jump]

That's it. Start coding.
```

**3. Build Player (30 minutes):**

```
- Add CharacterBody2D
- Add ColorRect (64x64, red)
- Add CollisionShape2D
- Attach player.gd (from template)
- Test movement
```

**4. Build World (30 minutes):**

```
- Add StaticBody2D (ground)
- Add ColorRect (1280x64, gray)
- Add CollisionShape2D
- Add 2-3 platforms
- Test jumping
```

**5. Add Goal (15 minutes):**

```
- Add Area2D (flag)
- Add ColorRect (64x64, yellow)
- Connect signal: body_entered → win()
- Add "You Win!" label
```

**6. Add Challenge (30 minutes):**

```
- Add obstacles (spikes, enemies, gaps)
- Add lose condition (fall below screen)
- Add restart button
```

**7. Test & Iterate (1 hour+):**

```
- Play for 2 minutes
- What feels bad? Fix it.
- What's missing? Add it.
- Is it fun? If no, pivot or abandon.
- If yes, continue.
```

---

## 🔄 Iteration Speed Tips

### Fast Feedback Loop

**Use These Godot Features:**

```gdscript
# Hot reload - modify and test immediately
# Just press F5 again, changes apply!

# Debug features
func _ready():
    # Print to console
    print("Player speed: ", speed)

    # Draw debug shapes
    queue_redraw()

func _draw():
    # Visualize collision shapes, ranges, etc.
    draw_circle(Vector2.ZERO, 100, Color(1, 0, 0, 0.3))

# In-game tweaking with @export
@export_range(0, 1000, 10) var speed = 300
# Adjust in inspector while game is running!
```

**Keyboard Shortcuts for Speed:**

```
F5:     Run game
F6:     Run current scene
F8:     Stop game
Ctrl+D: Duplicate node
Ctrl+Shift+D: Duplicate scene

# Learn these, save hours
```

---

### Common Prototype Patterns

**Pattern 1: Endless Runner**

```gdscript
# Time to prototype: 2-3 hours

Player:
- Auto-move forward
- Jump on spacebar
- Collision = death

World:
- Infinite scrolling background
- Spawn obstacles ahead
- Despawn obstacles behind

Loop:
- Dodge obstacles
- Survive as long as possible
- Score = distance traveled
```

**Pattern 2: Match-3 Puzzle**

```gdscript
# Time to prototype: 4-6 hours

Grid:
- 8x8 grid of colored squares
- Click to swap adjacent

Logic:
- Check for 3+ matches
- Remove matches
- Drop pieces down
- Fill empty spaces

Loop:
- Match 3+ to clear
- Score points
- Timer or moves limit
```

**Pattern 3: Twin-Stick Shooter**

```gdscript
# Time to prototype: 3-4 hours

Player:
- WASD to move
- Mouse aim
- Click to shoot

Enemies:
- Move toward player
- Die on hit
- Spawn continuously

Loop:
- Shoot enemies
- Survive waves
- Score = enemies killed
```

---

## 🧪 Testing Your Prototype

### The 60-Second Test

**Give it to someone, watch them play:**

```
:00 - Can they figure out controls?
:10 - Are they engaged?
:30 - Are they smiling/focused?
:60 - Do they want to continue?

If NO at any point = needs work
If YES to all = you have something!
```

### Key Questions

**Ask yourself:**

1. ❓ Is the core mechanic clear?
2. ❓ Do I want to play this for 5 more minutes?
3. ❓ Can I think of 5 ways to expand this?
4. ❓ Is there a "one more try" feeling?
5. ❓ Would I pay $1 for this idea polished?

**If 3+ answers are "yes" → Continue development**  
**If 3+ answers are "no" → Pivot or start new prototype**

---

## 🎯 Prototype Success Metrics

### What Makes a Good Prototype?

**Technical:**

- ✅ Runs without crashing
- ✅ Controls are responsive
- ✅ Core mechanic works
- ✅ Can win AND lose
- ✅ Can restart

**Design:**

- ✅ Fun for 60 seconds
- ✅ Clear goal
- ✅ Clear feedback
- ✅ One unique thing
- ✅ Makes you want to replay

**Feel:**

- ✅ Responsive (no input lag)
- ✅ Fair (doesn't feel cheap)
- ✅ Satisfying (good feedback)
- ✅ Challenging but possible

---

## 📦 Prototype to Full Game

### When to Expand

**DON'T expand if:**

- Prototype isn't fun yet
- Core mechanic needs work
- You're not excited about it
- Test players are confused

**DO expand if:**

- Core loop is solid and fun
- People ask for more
- You have ideas for content
- You're passionate about it

### Expansion Roadmap

**Week 1: Prototype (done)**

```
✓ Core mechanic
✓ Basic loop
✓ Placeholder art
✓ Basic sounds
```

**Week 2-3: Pre-Alpha**

```
□ Replace placeholder art (priority visuals)
□ Add 3-5 levels
□ Add basic progression
□ Better audio
□ Simple menu
```

**Week 4-6: Alpha**

```
□ All art finalized
□ 10+ levels
□ Full progression system
□ All audio
□ Complete UI
```

**Week 7-8: Beta**

```
□ Polish everything
□ Bug fixes
□ Balance testing
□ Performance optimization
```

**Week 9: Release Prep**

```
□ Export for platforms
□ Marketing materials
□ Store page
□ Final QA
```

**Week 10: Launch**

```
□ Release!
□ Monitor feedback
□ Plan updates
```

---

## 🔥 Rapid Prototyping Challenges

### 1-Hour Game Jam

**Challenge yourself:**

```
Theme: [Random word generator]
Time: 60 minutes
Goal: Playable start to finish

Rules:
- All placeholder art
- Max 3 sound effects
- One screen only
- One mechanic only

Result: Practice speed, decision-making
```

### Weekend Prototype Marathon

**Make 3 prototypes in one weekend:**

```
Saturday Morning (9am-12pm):
  Prototype 1: Platformer variant

Saturday Afternoon (1pm-4pm):
  Prototype 2: Puzzle game

Saturday Evening (5pm-8pm):
  Prototype 3: Action game

Sunday (all day):
  Pick best one, polish it

Result: Practice finding fun quickly
```

---

## 🎨 Prototype Asset Resources

### Free Placeholder Assets

**Graphics:**

```
Kenney.nl:
- Free game assets
- Placeholder sprites
- UI elements
- Sounds

OpenGameArt.org:
- Free sprites
- Textures
- Backgrounds

Itch.io (Free Assets):
- Search "free sprites"
- CC0 license preferred
```

**Audio:**

```
Freesound.org:
- Free sound effects
- CC licensed
- Massive library

JFXR:
- Generate 8-bit sounds
- Web-based
- Export as .wav

OpenGameArt.org:
- Free music
- Free SFX
```

**Fonts:**

```
Google Fonts:
- Free fonts
- Commercial use okay
- Easy to download

DaFont:
- Thousands of fonts
- Check license
- Many free for games
```

---

## 📋 Prototyping Checklist

### Before You Start

- [ ] One-sentence game description written
- [ ] Core mechanic identified
- [ ] Win/lose conditions defined
- [ ] Template project copied
- [ ] Time limit set (2hr/1day/3day)

### During Development

- [ ] Focus on core mechanic first
- [ ] Use placeholder everything
- [ ] Test every 15-30 minutes
- [ ] Take notes on what feels good/bad
- [ ] Don't add features until core works

### After Prototype

- [ ] Play for 5 minutes straight
- [ ] Show to 2-3 people
- [ ] Get honest feedback
- [ ] Decide: Continue, Pivot, or Abandon
- [ ] Document lessons learned

---

## 🚀 Next Steps

### If Prototype is Fun

```
1. Create GitHub repo
2. Plan next features (prioritized)
3. Replace placeholder art (phase by phase)
4. Add more content
5. Polish and release
```

### If Prototype Needs Work

```
1. Identify what's not fun
2. Try 2-3 quick variations
3. Test again
4. If still not fun, move on
```

### If Prototype Failed

```
1. That's OK! This is learning.
2. Document what you learned
3. Start new prototype
4. Repeat process

Remember: Fast failures are GOOD failures
```

---

## 💡 Prototyping Tips

### Do's ✅

- Start with one core mechanic
- Use colored shapes for placeholder art
- Test early and often
- Time-box your work
- Embrace failure
- Keep prototypes small
- Focus on feel over features

### Don'ts ❌

- Don't add art before mechanic works
- Don't add features before core is fun
- Don't spend more than planned time
- Don't get attached to bad ideas
- Don't skip playtesting
- Don't prototype alone (get feedback!)

---

**Remember:**

> "A week of coding can save you an hour of planning."
> "A day of prototyping can save you a month of development."

**Prototype fast. Fail fast. Learn fast. Build great games.** 🎮

---

**Quick Start:**

```bash
# Copy this template directory structure
# Add to ~/Developer/templates/godot-templates/
# Start every new idea from it
# You'll go from idea to playable in < 2 hours
```
