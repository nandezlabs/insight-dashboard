# 🎯 Platform Comparison & Decision Guide

**Created:** December 10, 2025  
**Purpose:** Help you choose the right platform for your game

---

## 📊 Quick Decision Matrix

### Choose Your Platform Based On:

```
┌──────────────────────┬─────────────────────────────────┐
│ Your Game Type       │ Recommended Platform            │
├──────────────────────┼─────────────────────────────────┤
│ Casual/Simple        │ Web (Itch.io) → Mobile          │
│ Story/Narrative      │ Steam → iOS → Android           │
│ Puzzle               │ iOS → Android → Web             │
│ Platformer (2D)      │ Steam → iOS → Web               │
│ Action (2D)          │ Steam → iOS/Android → Web       │
│ RPG                  │ Steam → iOS/Android             │
│ Strategy             │ Steam → iOS/iPad                │
│ Multiplayer          │ Steam → Web → Mobile            │
│ Arcade/Endless       │ Mobile (iOS+Android) → Web      │
│ Game Jam Entry       │ Web (Itch.io) ONLY              │
│ Portfolio Piece      │ Web (GitHub Pages)              │
│ Commercial Indie     │ Steam + Mobile (both stores)    │
└──────────────────────┴─────────────────────────────────┘
```

---

## 📱 Mobile: iOS vs Android

### iOS (App Store)

**Pros:**

- 💰 Higher revenue per user (2-3x Android)
- 🎯 Premium market (users pay for quality)
- 🔧 Easier testing (fewer devices)
- 💳 Better payment conversion
- 🛡️ Better quality control
- 📊 More stable audience

**Cons:**

- 💵 $99/year developer fee
- 🍎 Mac required for builds
- ⏰ App review (1-3 days wait)
- 🎨 Strict design guidelines
- 📱 Fewer total users than Android

**Best For:**

```
Game Types:
✅ Premium games ($2.99+)
✅ Polished experiences
✅ Western markets
✅ Puzzle games
✅ Story-driven games

Revenue Models:
✅ Paid upfront ($0.99-$9.99)
✅ Premium IAP
✅ Subscription
❌ Ad-heavy games (less effective)
```

**Requirements:**

- Mac computer
- Apple Developer Account ($99/year)
- Patience with review process
- Focus on quality over quantity

---

### Android (Google Play)

**Pros:**

- 🌍 Massive audience (70%+ of mobile)
- 🚀 Faster approval (hours, not days)
- 💻 Can build on any OS
- 💵 Lower barrier ($25 one-time fee)
- 🌏 Strong in emerging markets
- 🔧 More open platform

**Cons:**

- 💸 Lower revenue per user
- 📱 Device fragmentation (testing nightmare)
- 🏴‍☠️ Higher piracy rate
- 💳 Lower payment conversion
- 🎯 More competition

**Best For:**

```
Game Types:
✅ Free-to-play
✅ Ad-supported games
✅ Hypercasual
✅ Global/emerging markets
✅ High-volume games

Revenue Models:
✅ Free + Ads
✅ Free + IAP
✅ Rewarded ads
❌ Premium pricing (harder)
```

**Requirements:**

- Google Play Developer Account ($25 one-time)
- Android device for testing (or good emulator)
- Patience for device testing
- Ad integration (usually)

---

### Decision: iOS vs Android vs Both?

**Choose iOS if:**

- You have a Mac
- Game is polished and premium
- Targeting Western markets
- Willing to charge upfront
- Want higher revenue per player

**Choose Android if:**

- You don't have a Mac
- Game is free-to-play
- Targeting global markets
- Monetizing with ads
- Want maximum reach

**Choose BOTH if:**

- You have time/resources
- Cross-platform tools (Godot ✓)
- Want to maximize revenue
- Serious about mobile market
- Can handle extra testing

**Recommendation:**

```
Solo Developer Timeline:

Month 1-3: Build game
Month 4:   iOS ONLY (easier to test)
Month 5:   Launch iOS, collect feedback
Month 6:   Android port (now you know game works)
Month 7:   Launch Android

Why this order:
- iOS validates the concept (premium users)
- Feedback improves the game
- Android gets better version
- Easier than simultaneous launch
```

---

## 💻 PC: Steam vs Itch.io

### Steam

**Pros:**

- 🎮 120M+ active users
- 💰 Best PC revenue potential
- 🏆 Features (achievements, workshop, etc.)
- 📊 Strong discovery algorithm
- 🌐 Global reach with regional pricing
- 💳 Trusted payment system

**Cons:**

- 💵 $100 fee per game
- ⏰ 2-week approval for first game
- 🤝 30% revenue cut
- 🏪 Very competitive
- 📋 Steamworks integration work
- 🎯 Needs quality to stand out

**Best For:**

```
Game Types:
✅ Complete, polished games
✅ Games with depth (10+ hours)
✅ Story-driven experiences
✅ Multiplayer games
✅ Strategy/simulation
✅ RPGs

Revenue Models:
✅ Premium ($9.99-$29.99)
✅ Early Access
✅ DLC/expansions
❌ Free browser games
```

---

### Itch.io

**Pros:**

- 🆓 Completely free to use
- 🚀 Instant publishing (no approval)
- 🎨 Creative/indie community
- 💝 Only 10% cut (or less, you choose!)
- 🔧 Easy to update
- 📦 Multiple formats (downloadable + web)

**Cons:**

- 👥 Smaller audience than Steam
- 💰 Lower revenue potential
- 📊 Less discovery
- 🎯 More niche/indie audience
- 💳 Less trusted payment (some users)

**Best For:**

```
Game Types:
✅ Game jam entries
✅ Experimental games
✅ Short experiences (< 1 hour)
✅ Prototypes
✅ Free games
✅ Pay-what-you-want
✅ NSFW/adult content

Revenue Models:
✅ Free
✅ Pay-what-you-want
✅ Low-price ($1-$5)
❌ Premium ($20+) less effective
```

---

### Decision: Steam vs Itch.io?

**Choose Steam if:**

- Game is complete and polished
- You can afford $100 fee
- Targeting 10+ hours gameplay
- Want maximum revenue
- Game has commercial appeal
- You have marketing budget/plan

**Choose Itch.io if:**

- Game is experimental
- Made for game jam
- Want instant release
- Testing the market
- Learning game dev
- Short/free game

**Choose BOTH if:**

```
Strategy: Itch.io First, Steam Later

Week 1:   Release on Itch.io (free/pay-what-you-want)
Week 2-4: Collect feedback, fix bugs
Week 5:   Polish based on feedback
Week 6:   Release on Steam ($9.99+)

Benefits:
- Free beta testing on Itch.io
- Improve before Steam launch
- Build community early
- Itch.io players convert to Steam reviews
```

**Other PC Options:**

```
Epic Games Store:
- 12% cut (vs Steam's 30%)
- Smaller audience
- Harder to get accepted
- Good if accepted (guaranteed minimum)

GOG:
- DRM-free focus
- Curated (harder to get on)
- Older game-focused audience
- Good for classic-style games

Game Jolt:
- Similar to Itch.io
- Younger audience
- Less popular than Itch.io
```

---

## 🌐 Web vs Native Apps

### Web (HTML5)

**Pros:**

- 🚀 Instant play (no download)
- 🔗 Easy to share (just a link)
- 💻 Cross-platform automatically
- 🆓 Free hosting options
- ⚡ Fast updates (no approval)
- 📱 Works on mobile browsers too

**Cons:**

- 🐌 Performance limitations
- 📦 File size constraints (<50MB ideal)
- 💰 Limited monetization
- 🌐 Requires internet
- 🔒 Can't access native features
- 🏆 No achievements/platform features

**Best For:**

```
✅ Jam games
✅ Quick prototypes
✅ Marketing demos
✅ Casual games
✅ Browser multiplayer
✅ Portfolio pieces
✅ Viral/social games
```

---

### Native Apps (Download)

**Pros:**

- ⚡ Full performance
- 📦 No file size limits
- 💰 Better monetization
- 📴 Offline play
- 🔧 Full device access
- 🏆 Platform features

**Cons:**

- ⬇️ Download friction (barrier to entry)
- ⏰ Approval processes
- 💾 Takes device storage
- 🔄 Update management
- 💵 Distribution costs

**Best For:**

```
✅ Commercial games
✅ Large games (100MB+)
✅ Complex games
✅ Games needing performance
✅ Offline experiences
✅ Platform-specific features
```

---

### Decision Matrix

```
┌─────────────────────┬──────────┬─────────┐
│ Criteria            │ Web      │ Native  │
├─────────────────────┼──────────┼─────────┤
│ Time to market      │ Hours    │ Weeks   │
│ Development cost    │ Low      │ Medium  │
│ Distribution cost   │ $0       │ $0-$99  │
│ Performance         │ Good     │ Great   │
│ File size limit     │ <50MB    │ None    │
│ Monetization        │ Limited  │ Full    │
│ Update speed        │ Instant  │ Days    │
│ Player friction     │ None     │ High    │
│ Revenue potential   │ Low      │ High    │
│ Mobile support      │ Basic    │ Full    │
└─────────────────────┴──────────┴─────────┘
```

**Hybrid Strategy:**

```
1. Start with Web version
   - Quick to market
   - Get feedback fast
   - Validate concept

2. If successful, make Native
   - Better monetization
   - Full features
   - Optimized performance

Examples:
- Vampire Survivors (Web → Steam)
- Among Us (Mobile → PC)
- Wordle (Web → Mobile app)
```

---

## 🎯 Platform Strategy by Game Type

### Casual Mobile Game

**Recommended Path:**

```
Phase 1: Prototype (Web)
- Build on Itch.io web
- Test with friends
- Iterate quickly

Phase 2: Mobile Beta (iOS)
- TestFlight beta
- Collect feedback
- Refine monetization

Phase 3: Launch
- iOS App Store
- Android Google Play
- Keep web version as demo
```

**Monetization:**

```
Free + Ads (Rewarded videos)
Optional IAP (Remove ads, cosmetics)
```

---

### Indie PC Game

**Recommended Path:**

```
Phase 1: Early Access (Itch.io)
- Pay-what-you-want
- Build community
- Get feedback

Phase 2: Polish
- Fix based on feedback
- Add content
- Prepare for Steam

Phase 3: Steam Launch
- Full price ($14.99-$19.99)
- Use Itch.io community for reviews
- Launch discount (10-15% off)
```

**Monetization:**

```
Steam: $14.99-$19.99
Itch.io: Pay-what-you-want (min $5)
```

---

### Multi-Platform Commercial Game

**Recommended Path:**

```
Phase 1: Primary Platform (3 months)
- Choose based on game type
- Full focus, polished launch
- Build initial audience

Phase 2: Second Platform (1 month)
- Port to complementary platform
- Leverage existing marketing
- Cross-promote

Phase 3: Remaining Platforms (ongoing)
- Fill out other platforms
- Maintain all versions
- Unified updates

Example Timeline:
Month 1-3:  Steam (PC primary)
Month 4:    iOS (mobile strategy)
Month 5:    Android (complete mobile)
Month 6:    Web (marketing/demo)
Month 7+:   Console (if successful)
```

---

## 💰 Revenue Comparison

### Expected Revenue by Platform (Indie Game)

```
Rough Estimates (your results will vary):

Steam (Good indie game):
- 1,000 sales × $15 = $15,000
- Steam cut (30%): -$4,500
- Net: $10,500

iOS (Successful mobile):
- 10,000 downloads × $2.99 = $29,900
- Apple cut (30%): -$8,970
- Net: $20,930

Android (Ad-supported):
- 50,000 players
- Ad revenue: $0.05-$0.50 per user
- Net: $2,500 - $25,000

Itch.io (Indie community):
- 2,000 downloads × $5 average = $10,000
- Itch cut (10%): -$1,000
- Net: $9,000

Web (Free with ads):
- 100,000 plays
- Ad revenue: $0.01-$0.05 per play
- Net: $1,000 - $5,000
```

**Takeaway:**

> Platform choice matters, but game quality matters more. A great game on ANY platform can succeed. A bad game on ALL platforms will fail.

---

## 🚀 Launch Timing by Platform

### Best Days to Launch

```
Steam:
- Thursday (best visibility)
- Tuesday (second best)
- Avoid Monday, Friday, weekends
- Avoid major sale periods (Summer/Winter sale)

iOS App Store:
- Thursday (features refresh)
- Early in month
- Avoid major app launches (Apple events)

Android:
- Any weekday fine
- Less timing sensitivity

Web (Itch.io):
- Weekend (gamers browsing)
- During game jams
- Any time (less critical)
```

### Time of Year

```
Best:
- January-March (post-holiday)
- September-October (pre-holiday buildup)

Avoid:
- June-July (Summer Sale on Steam)
- November-December (AAA releases, holidays)
- During major game expos (E3, Gamescom)
```

---

## 📋 Decision Checklist

### Before Choosing Platform, Ask:

**About Your Game:**

- [ ] What's the file size? (<50MB = web viable)
- [ ] How complex is it? (Simple = mobile, Complex = PC)
- [ ] How long to complete? (<1hr = web, 10hr+ = PC)
- [ ] What controls does it need? (Touch = mobile, complex = PC)
- [ ] Does it need high performance? (Yes = native, No = web)

**About Your Goals:**

- [ ] Want maximum reach? → Web/Mobile
- [ ] Want maximum revenue? → Steam/iOS
- [ ] Want fastest launch? → Itch.io/Web
- [ ] Want to learn? → Any platform you want!
- [ ] Building portfolio? → Web (easy to share)
- [ ] Going commercial? → Steam + Mobile

**About Your Resources:**

- [ ] Do you have a Mac? (If no, skip iOS initially)
- [ ] Can you afford $100? (Steam fee)
- [ ] How much time for porting? (Multi-platform takes time)
- [ ] Marketing budget? (Steam needs more marketing)

---

## 🎯 Final Recommendations

### For Beginners:

```
1st Game:  Itch.io (web) - Learn the process
2nd Game:  Itch.io (download) - Add more complexity
3rd Game:  Steam OR Mobile - Choose your path
```

### For Intermediate:

```
Start:     Primary platform (Steam OR iOS)
Expand:    Add 1-2 complementary platforms
Maintain:  All platforms equally
```

### For Advanced:

```
Day 1:     Simultaneous multi-platform launch
Strategy:  Steam + iOS + Android + Web
Goal:      Maximum market coverage
```

---

**Remember:**

> "It's better to launch on ONE platform successfully than to launch on ALL platforms poorly."

**Start focused, expand when validated.**
