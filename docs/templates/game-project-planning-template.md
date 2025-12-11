# 🎮 Game Project Planning Template

**Created:** December 10, 2025  
**Purpose:** Comprehensive planning framework for rapid iteration and development

---

## 📋 Project Overview

### Basic Info

```yaml
Project Name: [Game Name]
Type: [2D/3D]
Genre: [Platformer/Puzzle/RPG/etc.]
Target Platform: [iOS/Android/Steam/Web/Console]
Development Time: [Estimated weeks/months]
Team Size: [Solo/2-5/etc.]
Status: [Planning/Prototype/Development/Polish/Released]
```

### Elevator Pitch

**In 1-2 sentences, what is your game?**

> Example: "A fast-paced 2D platformer where you play as a bird navigating through obstacles, inspired by Flappy Bird but with unique power-ups and level progression."

### Core Loop

**What does the player do repeatedly?**

1. [Action 1] → 2. [Action 2] → 3. [Action 3] → 4. [Back to 1]

> Example: Run → Jump → Collect coins → Avoid enemies → Reach checkpoint → Repeat

---

## 🎯 Planning Phase Checklist

### Phase 1: Concept (1-3 days)

**The fastest and most important phase - spend time here!**

- [ ] **Define the core mechanic** (What makes it fun?)
- [ ] **Identify the player fantasy** (What experience do they want?)
- [ ] **List 3 similar games** (Research competition/inspiration)
- [ ] **Determine unique selling point** (Why play YOUR game?)
- [ ] **Choose target platform** (Mobile/PC/Web/Console)
- [ ] **Sketch basic UI/layout** (Paper or digital mockup)
- [ ] **Define success criteria** (What does "done" look like?)

**Key Questions:**

```
❓ Can I explain this game in 10 seconds?
❓ Is the core mechanic fun on its own?
❓ Can I prototype this in 1-3 days?
❓ Does it fit my chosen platform?
❓ Is the scope realistic for my timeline?
```

**Output:** Game Concept Document (1 page)

---

### Phase 2: Design Deep Dive (2-5 days)

**Now that you know WHAT, figure out HOW**

#### Core Mechanics

- [ ] List all player actions (jump, shoot, collect, etc.)
- [ ] Define win/lose conditions
- [ ] Design progression system (levels, unlocks, difficulty)
- [ ] Plan economy (if applicable - coins, resources, etc.)
- [ ] Sketch level flow/structure

#### Technical Planning

- [ ] Choose art style (pixel art, low poly, hand-drawn, etc.)
- [ ] Decide on scope (number of levels, features)
- [ ] List required assets (sprites, sounds, music)
- [ ] Identify technical challenges
- [ ] Plan data storage (save system, cloud sync)

#### User Experience

- [ ] Design onboarding (tutorial/first 60 seconds)
- [ ] Plan UI/UX flow (menus, HUD, settings)
- [ ] Define controls (touch/keyboard/gamepad)
- [ ] Consider accessibility options

**Output:** Game Design Document (3-5 pages max)

---

### Phase 3: Asset Planning (1-2 days)

**Before coding, know what you need**

#### Visual Assets Checklist

```
Characters:
- [ ] Player sprite/model
- [ ] Enemy types (list each)
- [ ] NPCs (if applicable)

Environment:
- [ ] Background layers
- [ ] Tiles/terrain
- [ ] Props and decorations
- [ ] Obstacles

UI:
- [ ] Menu screens
- [ ] Buttons and icons
- [ ] HUD elements
- [ ] Font choices

Effects:
- [ ] Particle effects
- [ ] Animation sprites
- [ ] Shaders (if needed)
```

#### Audio Assets Checklist

```
Music:
- [ ] Main menu theme
- [ ] Gameplay music (how many tracks?)
- [ ] Victory/Game over music

Sound Effects:
- [ ] Player actions (jump, shoot, etc.)
- [ ] Enemy sounds
- [ ] UI feedback (clicks, hover)
- [ ] Environment ambience
- [ ] Special effects
```

**Asset Strategy:**

- [ ] **Create placeholder art** (colored rectangles, simple shapes)
- [ ] **Find free/paid assets** (itch.io, OpenGameArt, Asset Store)
- [ ] **Commission artists** (if budget allows)
- [ ] **Create final art** (yourself or hire)

**Output:** Asset List with priorities (Must Have / Nice to Have / Polish)

---

## 🚀 Prototyping Phase

### Week 1: Core Mechanics

**Goal: Prove the fun factor**

```
Day 1-2: Basic player movement
  - [ ] Character moves on screen
  - [ ] Controls feel responsive
  - [ ] Basic physics work correctly

Day 3-4: Core game mechanic
  - [ ] Main interaction works (jump/shoot/collect)
  - [ ] Test if it's fun for 60 seconds
  - [ ] Iterate on feel/feedback

Day 5-7: Basic game loop
  - [ ] Win condition works
  - [ ] Lose condition works
  - [ ] Can restart
  - [ ] Basic scoring
```

**Success Check:** ✅ Is it fun to play for 5 minutes with placeholder art?

---

### Week 2: First Playable

**Goal: Show it to someone**

```
Day 1-2: Visual polish
  - [ ] Replace key placeholders with real/better art
  - [ ] Add basic animations
  - [ ] Improve visual feedback

Day 3-4: Audio integration
  - [ ] Add essential sound effects
  - [ ] Add background music
  - [ ] Test audio balance

Day 5-7: First level/content
  - [ ] Create first complete level
  - [ ] Add tutorial/onboarding
  - [ ] Basic UI (start, pause, game over)
```

**Success Check:** ✅ Can someone else play and understand it without explanation?

---

## 🔄 Rapid Iteration Framework

### Daily Iteration Cycle

```mermaid
Build (2-4 hours)
  ↓
Test (30 min)
  ↓
Get Feedback (30 min)
  ↓
Analyze (30 min)
  ↓
Plan Next Change (30 min)
  ↓
Repeat
```

### Iteration Questions

**After each build:**

1. ❓ What feels good?
2. ❓ What feels bad?
3. ❓ What's confusing?
4. ❓ What's missing?
5. ❓ What should I fix first?

### Prioritization Matrix

```
┌─────────────────┬──────────────────┐
│  HIGH IMPACT    │   POLISH         │
│  EASY FIX       │   EASY FIX       │
│                 │                  │
│  DO FIRST ✅    │  DO LATER 📋     │
├─────────────────┼──────────────────┤
│  HIGH IMPACT    │   LOW IMPACT     │
│  HARD FIX       │   HARD FIX       │
│                 │                  │
│  PLAN/SCOPE ⚠️  │  SKIP ❌         │
└─────────────────┴──────────────────┘
```

**Rules:**

- Fix high-impact/easy items immediately
- Batch similar changes together
- Test after every significant change
- Don't add features until core is solid

---

## 📊 Platform-Specific Planning

### Mobile (iOS/Android)

**Pre-Development:**

- [ ] Design for portrait OR landscape (pick one)
- [ ] Plan touch controls (where do fingers naturally rest?)
- [ ] Consider one-handed vs two-handed play
- [ ] Design for interruptions (calls, notifications)
- [ ] Plan monetization (ads, IAP, premium)
- [ ] Account for different screen sizes (iPhone SE to iPad)

**Key Decisions:**

```yaml
Orientation: [Portrait/Landscape/Both]
Controls: [Tap/Swipe/Virtual Joystick/Tilt]
Monetization: [Free+Ads/IAP/Premium/$0.99]
Online Features: [None/Leaderboards/Multiplayer]
Persistence: [Local Only/iCloud/Custom Backend]
```

---

### PC (Steam/Itch.io)

**Pre-Development:**

- [ ] Decide on control schemes (KB+M, Gamepad, or both)
- [ ] Plan for different resolutions (1920x1080 to 4K)
- [ ] Consider graphics options (low/medium/high)
- [ ] Plan Steam features (achievements, cloud saves, workshop)
- [ ] Decide on pricing strategy
- [ ] Plan for demo vs full game

**Key Decisions:**

```yaml
Price Point: [$Free/$5/$10/$20+]
Controls: [Keyboard+Mouse/Gamepad/Both]
Engine Mode: [2D/3D]
Distribution: [Steam/Itch.io/Epic/GOG]
DLC Strategy: [None/Cosmetic/Content/Season Pass]
Early Access: [Yes/No]
```

---

### Web (HTML5)

**Pre-Development:**

- [ ] Design for browser limitations (file size, memory)
- [ ] Plan for keyboard controls (WASD, Arrow keys)
- [ ] Consider mobile browser support
- [ ] Keep total size under 50MB for fast loading
- [ ] Test on multiple browsers
- [ ] Plan monetization (ads are common for web)

**Key Decisions:**

```yaml
Target Size: [<10MB/<50MB/<100MB]
Platforms: [Itch.io/Newgrounds/Poki/Kongregate]
Controls: [Keyboard/Mouse/Touch/All]
Monetization: [Free/Ads/Donations]
Offline Play: [Yes/No]
```

---

### Console (Nintendo Switch/Xbox/PlayStation)

**Pre-Development:**

- [ ] Apply for developer program (do this EARLY)
- [ ] Get dev kit (may take weeks/months)
- [ ] Plan for certification requirements
- [ ] Design for gamepad-only input
- [ ] Consider local multiplayer
- [ ] Budget for certification costs ($$$)
- [ ] Plan for age ratings (ESRB, PEGI)

**Key Decisions:**

```yaml
Target Console: [Switch/Xbox/PlayStation/All]
Price Point: [$10/$15/$20/$30+]
Multiplayer: [None/Local Co-op/Online]
Physical Release: [Digital Only/Physical]
Publisher: [Self-Publish/Partner with Publisher]
```

---

## 📈 Development Milestones

### Pre-Alpha (Prototype)

**Goal:** Prove the concept

- [ ] Core mechanic works
- [ ] Basic visuals (can be placeholders)
- [ ] Playable for 5-10 minutes
- [ ] One level/area complete

**Timeline:** 1-3 weeks

---

### Alpha (First Playable)

**Goal:** Complete vertical slice

- [ ] All core mechanics implemented
- [ ] Tutorial/onboarding complete
- [ ] 20-30% of final content
- [ ] Basic audio
- [ ] Can be completed start-to-finish

**Timeline:** 1-2 months

---

### Beta (Feature Complete)

**Goal:** Everything implemented, needs polish

- [ ] All features implemented
- [ ] All levels/content complete
- [ ] All art finalized
- [ ] All audio implemented
- [ ] Bugs being actively fixed
- [ ] External playtesting happening

**Timeline:** 2-4 months

---

### Release Candidate

**Goal:** Ready to ship, final testing

- [ ] All major bugs fixed
- [ ] Performance optimized
- [ ] Platform compliance met
- [ ] Marketing materials ready
- [ ] Store page ready
- [ ] Final QA pass complete

**Timeline:** 2-4 weeks

---

## 🎯 Scope Management

### Feature Tiers

**Tier 1: Must Have (Core Features)**

> Without these, the game doesn't work

- Core gameplay mechanic
- Basic visuals
- Essential audio
- Win/lose conditions
- Main menu

**Tier 2: Should Have (Important Features)**

> Makes the game better, but not required for launch

- Multiple levels
- Power-ups or variety
- Settings menu
- Better art/animations
- Music

**Tier 3: Nice to Have (Polish)**

> Adds to experience but can be post-launch

- Achievements
- Leaderboards
- Extra content
- Advanced graphics options
- Special effects

### Scope Cutting Guide

**When running out of time:**

1. ✅ Keep: Core mechanic + basic presentation
2. ⚠️ Simplify: Number of levels, variety of enemies
3. ❌ Cut: Extra modes, online features, achievements
4. 📅 Post-Launch: Polish, extra content, community requests

---

## 📝 Documentation Templates

### Game Design Document (GDD) Outline

```markdown
# [Game Name] - Design Document

## Core Concept

- Elevator pitch
- Target audience
- Platform
- Genre

## Gameplay

- Core mechanics
- Controls
- Progression
- Win/lose conditions

## Content

- Level design
- Enemies/obstacles
- Power-ups/items
- Bosses (if applicable)

## Technical

- Engine choice
- Art style
- Audio needs
- Performance targets

## Scope

- Must have features
- Should have features
- Nice to have features
- Post-launch ideas
```

### Feature Planning Template

```markdown
## Feature: [Name]

**Priority:** [Must Have / Should Have / Nice to Have]
**Estimated Time:** [Hours/Days]
**Dependencies:** [What must be done first?]

**Description:**
[What does this feature do?]

**Implementation Notes:**

- Step 1
- Step 2
- Step 3

**Testing Criteria:**

- [ ] Test case 1
- [ ] Test case 2
- [ ] Test case 3

**Done When:**
[Specific, measurable completion criteria]
```

---

## 🧪 Playtesting Framework

### Self-Testing Checklist

**Before showing anyone:**

- [ ] Game launches without errors
- [ ] Tutorial/instructions are clear
- [ ] Can complete at least one level
- [ ] Controls feel responsive
- [ ] Audio isn't annoying
- [ ] No game-breaking bugs
- [ ] Can quit and restart

### External Playtesting

**First Playtest (Friends/Family):**

```
Goals:
- Can they figure it out?
- Do they have fun?
- Where do they get stuck?

Questions to ask:
1. What did you think this game was about?
2. What was confusing?
3. What was fun?
4. What was frustrating?
5. Would you play this again?
```

**Second Playtest (Strangers/Community):**

```
Goals:
- Validate improvements
- Find edge cases
- Get honest feedback

Distribution:
- Itch.io (private link)
- Discord communities
- Reddit (r/playmygame)
- Friends of friends
```

### Feedback Processing

**After each playtest:**

1. 📝 **Document everything** (even small comments)
2. 🔍 **Look for patterns** (multiple people say same thing?)
3. 📊 **Categorize feedback** (bugs / UX / content / polish)
4. ⚖️ **Prioritize** (high impact / easy fix first)
5. ✅ **Act on top 3-5 items** (don't try to fix everything at once)

---

## ⏱️ Time Management

### Weekly Planning Template

```markdown
## Week of [Date]

### Primary Goal:

[One main thing to accomplish this week]

### Daily Breakdown:

**Monday:**

- [ ] Task 1 (2h)
- [ ] Task 2 (2h)
- [ ] Task 3 (1h)

**Tuesday:**

- [ ] Task 1 (3h)
- [ ] Playtest (1h)
- [ ] Iterate (1h)

[Continue for each day...]

### Backup Tasks:

[Things to do if you finish early or get blocked]

### Reflections:

[End of week: What worked? What didn't?]
```

### Daily Development Log

```markdown
## [Date] - Day [#]

**Hours:** [X hours]
**Focus:** [Main task]

**Completed:**

- ✅ Thing 1
- ✅ Thing 2
- ✅ Thing 3

**Problems:**

- ⚠️ Issue 1 (How I solved it)
- ⚠️ Issue 2 (Still working on it)

**Tomorrow:**

- 📋 Task 1
- 📋 Task 2

**Notes:**
[Any insights, ideas, or reminders]
```

---

## 🎉 Pre-Launch Checklist

### 2 Weeks Before Launch

- [ ] Game is feature complete
- [ ] All major bugs fixed
- [ ] Performance optimized
- [ ] Platform-specific requirements met
- [ ] Store page created (screenshots, description, trailer)
- [ ] Press kit ready (if applicable)
- [ ] Social media accounts set up
- [ ] Community channels ready (Discord, etc.)

### 1 Week Before Launch

- [ ] Final playtest complete
- [ ] All known bugs fixed or documented
- [ ] Store page submitted for review
- [ ] Marketing materials ready
- [ ] Launch day post scheduled
- [ ] Monitoring tools set up (analytics, crash reporting)
- [ ] Support email/system ready

### Launch Day

- [ ] Monitor for crashes/issues
- [ ] Respond to early feedback
- [ ] Post on social media
- [ ] Engage with players
- [ ] Celebrate! 🎉

### Post-Launch (First Week)

- [ ] Hot-fix critical bugs immediately
- [ ] Collect feedback from players
- [ ] Monitor reviews and ratings
- [ ] Plan first update
- [ ] Thank supporters

---

## 📚 Resources & Tools

### Planning Tools

- **Miro/Mural:** Visual brainstorming and planning
- **Notion:** Game design docs and task management
- **Trello:** Kanban boards for features
- **Google Docs:** Collaborative design documents
- **Paper & Pencil:** Quick sketches and notes

### Prototyping Tools

- **Godot:** Main development (obviously!)
- **Figma:** UI/UX mockups
- **Piskel/Aseprite:** Quick sprite creation
- **Audacity:** Audio editing
- **OBS:** Screen recording for playtests

### Feedback Tools

- **Google Forms:** Structured playtest surveys
- **Discord:** Community feedback
- **Itch.io:** Early access / demo feedback
- **Twitter/Reddit:** Public feedback
- **Loom:** Record playtest sessions

---

**Remember:**

> "Planning is about making decisions early when they're cheap to change. Code is expensive to rewrite. Design documents are free to edit."

**Key Principle:**

> Spend 30% of your time planning, 50% building, 20% iterating. Front-load the thinking.

---

**Next Steps:**

1. ✅ Fill out Project Overview section
2. ✅ Complete Phase 1: Concept checklist
3. ✅ Create simple 1-page design doc
4. ✅ Start prototyping!
