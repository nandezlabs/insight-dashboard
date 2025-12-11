# 🐛 Universal Debugging Workflow

**Created:** December 10, 2025  
**Purpose:** Systematic debugging approach for all development projects  
**Applies to:** Games, Web Apps, APIs, Scripts, Mobile Apps, Desktop Apps

---

## 🎯 Core Philosophy

### The Debugging Mindset

**Golden Rules:**

1. **Don't assume, verify** - Test your assumptions
2. **Reproduce first** - Can't fix what you can't reproduce
3. **Isolate the problem** - Narrow down the scope
4. **Change one thing at a time** - Know what fixed it
5. **Document everything** - Future you will thank present you

**Quote to Remember:**

> "Hours of debugging can save you minutes of planning."  
> "The bug is not in the computer, it's in your assumptions."

---

## 📋 The 5-Step Debugging Process

### Step 1: Reproduce the Bug (15-30 min)

**Goal:** Consistently trigger the problem

```
❓ Questions to Answer:
- Does it happen every time or randomly?
- What are the exact steps to reproduce?
- What's the minimum setup needed?
- Does it happen in different environments?
- Can someone else reproduce it?

✅ Success Criteria:
- Can reproduce bug on demand (90%+ of the time)
- Have written step-by-step reproduction steps
- Know the expected vs actual behavior
```

**Reproduction Template:**

```markdown
## Bug Reproduction Steps

**Environment:**

- OS: [macOS 13.5 / Windows 11 / Linux Ubuntu 22.04]
- Version: [App version / commit hash]
- Device: [MacBook Air M2 / iPhone 14 / etc.]

**Steps to Reproduce:**

1. Launch app
2. Click on [specific button]
3. Enter [specific value]
4. Observe [error]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**Frequency:**

- [ ] Always (100%)
- [ ] Often (>50%)
- [ ] Sometimes (<50%)
- [ ] Rare (<10%)

**Screenshots/Video:**
[Attach evidence]
```

---

### Step 2: Isolate the Problem (30-60 min)

**Goal:** Narrow down where the bug lives

**Binary Search Debugging:**

```
1. Divide the codebase in half
2. Determine which half has the bug
3. Divide that half in half
4. Repeat until you find the line

Example:
- Does it happen with no user input? → Input handling issue
- Does it happen with test data? → Data-specific issue
- Does it happen in fresh install? → State/cache issue
- Does it happen in older version? → Recent change issue
```

**Isolation Techniques:**

```python
# 1. Comment Out Code (Binary elimination)
# def problematic_function():
#     step1()  # Comment this
#     step2()  # Then this
#     step3()  # Then this
#     # Find which step causes the issue

# 2. Add Early Returns
def problematic_function():
    return  # Does bug still happen? If no, it's in this function
    step1()
    step2()
    step3()

# 3. Minimal Reproduction
# Create smallest possible code that shows the bug
def minimal_bug_demo():
    x = 10
    y = 0
    result = x / y  # Bug! Now isolated to one line
```

**Godot-Specific Isolation:**

```gdscript
# Test in minimal scene
# Create new scene with ONLY the problematic code
# If bug disappears, it's an interaction with other systems

# Test without dependencies
# Remove complex dependencies one by one
# Find which dependency causes the issue

# Test in empty project
# Copy just the broken code to fresh project
# If it works, issue is in project configuration
```

**Web/JavaScript Isolation:**

```javascript
// Disable features one by one
// Comment out modules/imports
// Use debugger to pause execution at suspected points
// Test in different browsers (Chrome, Firefox, Safari)
```

---

### Step 3: Understand the Root Cause (15-45 min)

**Goal:** Why is this happening?

**The "5 Whys" Technique:**

```
Problem: Player falls through floor
Why? → Collision not detected
Why? → Collision shape missing
Why? → Forgot to add in new scene
Why? → No checklist for new objects
Why? → Process not documented
Root Cause: Missing documentation/checklist
```

**Common Root Causes:**

```
Category: Logic Errors
- Off-by-one errors (< vs <=)
- Wrong operator (= vs ==)
- Wrong order of operations
- Missing null checks
- Incorrect conditional logic

Category: State Issues
- Variable not initialized
- Race condition (timing)
- Incorrect state transitions
- Shared mutable state

Category: Integration Issues
- API contract mismatch
- Version incompatibility
- Missing dependencies
- Configuration errors

Category: Environment Issues
- Platform-specific behavior
- Missing permissions
- Resource constraints (memory, storage)
- Network issues
```

**Investigation Tools by Project Type:**

```yaml
Godot:
  - Debugger: F10-F11 stepping
  - Remote Inspector: View live scene tree
  - Performance Monitor: Check FPS, memory
  - Output Window: print() statements
  - Script Editor: Breakpoints

Python:
  - pdb: import pdb; pdb.set_trace()
  - print(): Strategic logging
  - type(): Check variable types
  - dir(): List object attributes
  - IDE Debugger: VS Code, PyCharm

JavaScript/Web:
  - Chrome DevTools: Console, Network, Performance
  - console.log(): Strategic logging
  - debugger: Breakpoint statement
  - React DevTools: Component inspection
  - Network Tab: API calls

iOS (Swift/Xcode):
  - LLDB: Command-line debugger
  - Breakpoints: Visual debugger
  - Instruments: Performance profiling
  - Console: print() statements
  - Memory Graph: Detect leaks

Android:
  - Logcat: System logs
  - Debug.log(): Logging
  - Android Profiler: CPU, Memory, Network
  - Layout Inspector: UI debugging
  - Breakpoints: Android Studio debugger
```

---

### Step 4: Fix the Bug (15 min - 2 hours)

**Goal:** Implement the minimal fix

**Fix Strategies:**

```
Strategy 1: The Obvious Fix
- Direct fix to the root cause
- Example: Add missing null check
- Time: 15-30 minutes
- Use when: Root cause is clear

Strategy 2: The Defensive Fix
- Fix the symptom + add guards
- Example: Handle error + log warning
- Time: 30-60 minutes
- Use when: Can't change root cause

Strategy 3: The Refactor Fix
- Redesign the problematic area
- Example: Replace fragile code with robust pattern
- Time: 1-4 hours
- Use when: Multiple related issues

Strategy 4: The Workaround
- Avoid the problem entirely
- Example: Use different API/approach
- Time: 30 minutes - 2 hours
- Use when: Fix is too risky/complex
```

**Fix Template:**

```python
# ❌ BEFORE (Broken)
def process_user_input(data):
    result = data['value'] * 2  # Crashes if 'value' missing
    return result

# ✅ AFTER (Fixed)
def process_user_input(data):
    # Fix: Add null/key check with default
    if 'value' not in data or data['value'] is None:
        print("Warning: 'value' missing in data, using default 0")
        return 0

    result = data['value'] * 2
    return result
```

**Godot Fix Example:**

```gdscript
# ❌ BEFORE (Player falls through floor)
extends CharacterBody2D

func _physics_process(delta):
    velocity.y += 980 * delta
    move_and_slide()  # No collision!

# ✅ AFTER (Fixed)
extends CharacterBody2D

func _physics_process(delta):
    if not is_on_floor():
        velocity.y += 980 * delta

    move_and_slide()

    # Debug: Verify collision is working
    if is_on_floor():
        print("On floor: ", get_floor_normal())
```

**Fix Checklist:**

```
Before Applying Fix:
- [ ] Understand the root cause
- [ ] Have reproduction steps
- [ ] Know expected behavior
- [ ] Considered side effects
- [ ] Planned how to test fix

After Applying Fix:
- [ ] Bug no longer reproduces
- [ ] No new bugs introduced
- [ ] Code is readable
- [ ] Added comments explaining fix
- [ ] Updated documentation (if needed)
```

---

### Step 5: Verify & Prevent (30-60 min)

**Goal:** Confirm fix works and won't happen again

**Verification Checklist:**

```
Test the Fix:
- [ ] Original reproduction steps → No bug
- [ ] Edge cases → No issues
- [ ] Related features → Still work
- [ ] Different environments → Consistent
- [ ] Performance → Not degraded

Regression Testing:
- [ ] Run all existing tests
- [ ] Manual test critical paths
- [ ] Check related functionality
- [ ] Test on all target platforms
```

**Prevention Strategies:**

```
1. Add Automated Test
   - Write unit test for the bug
   - Ensures it doesn't come back
   - Example: test_null_value_handling()

2. Add Assertions
   - Fail fast with clear error
   - Example: assert(player != null, "Player required")

3. Improve Error Messages
   - Make failures obvious
   - Example: "Error: 'value' key missing in data"

4. Update Documentation
   - Add to troubleshooting guide
   - Document gotchas
   - Update API docs

5. Refactor Fragile Code
   - Replace brittle patterns
   - Use defensive programming
   - Add validation layers
```

**Prevention Template:**

```python
# Add test to prevent regression
def test_process_user_input_handles_missing_value():
    """Regression test for bug #123: crash on missing 'value' key"""
    data = {'other': 'stuff'}  # Missing 'value'
    result = process_user_input(data)
    assert result == 0, "Should return default 0 for missing value"

def test_process_user_input_handles_null_value():
    """Regression test for bug #123: crash on null 'value'"""
    data = {'value': None}
    result = process_user_input(data)
    assert result == 0, "Should return default 0 for null value"
```

---

## 🔍 Advanced Debugging Techniques

### 1. Print Debugging (Universal)

**Strategic Logging:**

```python
# ❌ Bad: Random prints
print("here")
print("x")
print("test")

# ✅ Good: Structured logging
print(f"[DEBUG] process_input: data={data}, type={type(data)}")
print(f"[DEBUG] process_input: value={data.get('value', 'MISSING')}")
print(f"[DEBUG] process_input: result={result}")

# Even Better: Use logging module
import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

logger.debug(f"Processing input: {data}")
logger.info(f"Result calculated: {result}")
logger.warning(f"Missing value key, using default")
logger.error(f"Unexpected error: {error}")
```

**Godot Print Debugging:**

```gdscript
# Strategic prints with context
func _physics_process(delta):
    print("[Physics] velocity: ", velocity, " is_on_floor: ", is_on_floor())

    if not is_on_floor():
        velocity.y += gravity * delta
        print("[Physics] Applied gravity, new velocity.y: ", velocity.y)

    var collision = move_and_slide()
    print("[Physics] Collision count: ", get_slide_collision_count())
```

**Web/JavaScript Debugging:**

```javascript
// Strategic console methods
console.log("[Init] Component mounted");
console.warn("[API] Slow response time:", responseTime);
console.error("[API] Request failed:", error);
console.table(arrayOfObjects); // Nice table format
console.group("User Action"); // Group related logs
console.log("Click event:", event);
console.log("Target:", event.target);
console.groupEnd();

// Conditional logging
const DEBUG = true;
if (DEBUG) console.log("[Debug] State:", state);
```

---

### 2. Breakpoint Debugging

**VS Code Breakpoints (Python, JavaScript):**

```
1. Click left of line number → Red dot appears
2. Run in debug mode (F5)
3. Execution pauses at breakpoint
4. Inspect variables in left panel
5. Step through code:
   - F10: Step over (next line)
   - F11: Step into (enter function)
   - Shift+F11: Step out (exit function)
   - F5: Continue to next breakpoint
```

**Godot Breakpoints:**

```gdscript
# Click left of line number in script editor
# Run scene in debug mode (F5)
# Game pauses when breakpoint hit
# Use "Step Into" (F11), "Step Over" (F10)
# Inspect variables in debugger panel

func problematic_function():
    var x = 10
    var y = 0
    # Breakpoint here ⭕
    var result = x / y  # Will pause before crash
    return result
```

**Xcode Breakpoints (iOS):**

```swift
// Click left gutter → Blue breakpoint
// Run app (Cmd+R)
// App pauses at breakpoint
// LLDB console available
// Inspect variables with "po variable"

func fetchData() {
    let url = URL(string: apiEndpoint)
    // Breakpoint here ⭕
    let data = try? Data(contentsOf: url)
    print("Data: \(data)")
}
```

---

### 3. Rubber Duck Debugging

**Explain the Problem Out Loud:**

```
1. Get a rubber duck (or patient human)
2. Explain your code line by line
3. Explain what you THINK each line does
4. Often you'll spot the bug while explaining

Example:
"So this function takes user data...
wait, what if data is nil?
OH! I never check for nil!
That's the bug!"
```

---

### 4. Binary Search Debugging

**For "It Worked Yesterday" Bugs:**

```bash
# Using Git bisect
git bisect start
git bisect bad  # Current broken commit
git bisect good <commit-hash>  # Last known working commit

# Git will checkout middle commit
# Test if bug exists
git bisect good  # or bad
# Repeat until bug-introducing commit found
git bisect reset
```

---

### 5. Divide and Conquer

**For Complex Systems:**

```
1. Split system into modules
2. Test each module independently
3. Find which module fails
4. Split that module
5. Repeat until you find the line

Example (Game):
- Does menu work? → Yes
- Does gameplay work? → No
  - Does player spawn work? → Yes
  - Does player move work? → No
    - Does input work? → Yes
    - Does physics work? → No
      → Bug is in physics setup
```

---

### 6. Time-Travel Debugging

**Using Git History:**

```bash
# Find when bug was introduced
git log --oneline  # Find suspicious commits

# Checkout old commits
git checkout <commit-hash>
# Test if bug exists
# Keep going back until you find the breaking commit

# Compare working vs broken
git diff <good-commit> <bad-commit>
# Shows exactly what changed
```

---

## 🎮 Platform-Specific Debugging

### Godot Debugging Tools

**1. Built-in Debugger:**

```gdscript
# Breakpoints
func _ready():
    var player = get_node("Player")  # Add breakpoint here
    print(player.position)

# Remote Scene Inspector
# Scene → Remote → Inspector
# View/modify live game state while running

# Performance Monitor
# Project → Tools → Monitor
# View FPS, memory, draw calls, etc.
```

**2. Debug Draw:**

```gdscript
# Visualize collision shapes, paths, etc.
func _draw():
    # Draw collision area
    draw_circle(Vector2.ZERO, 50, Color(1, 0, 0, 0.3))

    # Draw velocity vector
    draw_line(Vector2.ZERO, velocity, Color(0, 1, 0), 2.0)

    # Draw path
    for point in path_points:
        draw_circle(point, 5, Color(0, 0, 1))

# Call queue_redraw() to update
```

**3. Debug Logging:**

```gdscript
# Print to output window
print("Player position: ", position)
print_debug("Debug info with stack trace")
push_warning("Warning message")
push_error("Error message")

# Conditional debug
const DEBUG = true
if DEBUG:
    print("[DEBUG] State: ", current_state)
```

---

### Web/JavaScript Debugging

**1. Chrome DevTools:**

```javascript
// Console debugging
console.log("Normal log");
console.warn("Warning");
console.error("Error");
console.table([
  { a: 1, b: 2 },
  { a: 3, b: 4 },
]);
console.time("operation");
// ... code ...
console.timeEnd("operation"); // Shows duration

// Debugger statement
function problematic() {
  debugger; // Execution pauses here
  let x = something();
  return x;
}

// Network inspection
// DevTools → Network tab
// See all API calls, timings, responses
```

**2. React DevTools:**

```javascript
// Install React DevTools extension
// Inspect component tree
// View props and state
// See component rerenders

// Console profiling
import { Profiler } from "react";

<Profiler id="App" onRender={callback}>
  <App />
</Profiler>;
```

---

### iOS Debugging (Xcode)

**1. LLDB Debugger:**

```swift
// Set breakpoint
// When paused, use LLDB console:

po variable  // Print object
p variable   // Print primitive
expr variable = newValue  // Modify during debug
bt  // Backtrace (call stack)
frame variable  // All local variables
```

**2. Instruments:**

```
Xcode → Product → Profile
Choose instrument:
- Time Profiler: Find slow code
- Allocations: Track memory usage
- Leaks: Find memory leaks
- Network: Monitor API calls
```

---

### Android Debugging

**1. Logcat:**

```kotlin
// Add logs
Log.d("MyApp", "Debug message")
Log.i("MyApp", "Info message")
Log.w("MyApp", "Warning message")
Log.e("MyApp", "Error message")

// View in Android Studio
// View → Tool Windows → Logcat
// Filter by tag: "MyApp"
```

**2. Android Profiler:**

```
View → Tool Windows → Profiler
- CPU: Find performance issues
- Memory: Track allocations
- Network: Monitor API calls
- Energy: Battery usage
```

---

### Python Debugging

**1. PDB (Python Debugger):**

```python
import pdb

def problematic_function():
    x = 10
    pdb.set_trace()  # Execution pauses here
    y = x * 2
    return y

# When paused:
# n - next line
# s - step into function
# c - continue execution
# p variable - print variable
# l - show code around current line
# q - quit debugger
```

**2. VS Code Python Debugger:**

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal",
      "justMyCode": false // Debug into libraries
    }
  ]
}
```

---

## 🚨 Common Bug Patterns & Solutions

### Pattern 1: Null/Undefined Reference

**Symptoms:**

```
- NullPointerException (Java)
- AttributeError (Python)
- Cannot read property of undefined (JavaScript)
- Null reference exception (C#/Godot)
```

**Fix:**

```python
# ❌ Crashes if data is None
result = data.value

# ✅ Safe with null check
result = data.value if data else default_value

# ✅ Safe with try-except
try:
    result = data.value
except AttributeError:
    result = default_value

# ✅ Safe with get (dictionaries)
result = data.get('value', default_value)
```

---

### Pattern 2: Off-by-One Error

**Symptoms:**

```
- Array index out of bounds
- Loop runs one too many/few times
- Boundary conditions fail
```

**Fix:**

```python
# ❌ Classic off-by-one
for i in range(len(array)):
    if i < len(array) - 1:  # Should be <=
        process(array[i])

# ✅ Correct boundary
for i in range(len(array)):
    process(array[i])

# ❌ Slice off-by-one
items = array[0:len(array)-1]  # Missing last item

# ✅ Correct slice
items = array[0:len(array)]  # Or just array[:]
```

---

### Pattern 3: Race Condition

**Symptoms:**

```
- Works sometimes, fails randomly
- Timing-dependent failures
- Intermittent crashes
```

**Fix:**

```python
# ❌ Race condition (async)
async def fetch_data():
    data = await api_call()
    process(data)  # What if data isn't ready?

# ✅ Proper await
async def fetch_data():
    data = await api_call()
    if data:  # Verify data loaded
        process(data)
    else:
        handle_error()

# ❌ Race condition (threads)
shared_counter = 0
def increment():
    shared_counter += 1  # Not atomic!

# ✅ Thread-safe
import threading
lock = threading.Lock()
shared_counter = 0

def increment():
    with lock:
        shared_counter += 1
```

---

### Pattern 4: Memory Leak

**Symptoms:**

```
- Memory usage keeps growing
- App slows down over time
- Eventually crashes
```

**Fix:**

```gdscript
# ❌ Memory leak (Godot)
func spawn_enemy():
    var enemy = preload("res://enemy.tscn").instantiate()
    add_child(enemy)
    # Never removed! Keeps accumulating

# ✅ Proper cleanup
func spawn_enemy():
    var enemy = preload("res://enemy.tscn").instantiate()
    add_child(enemy)
    enemy.tree_exited.connect(_on_enemy_removed)

func remove_enemy(enemy):
    enemy.queue_free()  # Proper cleanup

# ❌ Memory leak (JavaScript)
let bigData = [];
function addData() {
    bigData.push(new Array(1000000));  # Never cleared
}

# ✅ Proper management
let bigData = [];
const MAX_SIZE = 100;

function addData() {
    bigData.push(new Array(1000));
    if (bigData.length > MAX_SIZE) {
        bigData.shift();  # Remove old data
    }
}
```

---

### Pattern 5: Wrong Variable Scope

**Symptoms:**

```
- Variable not found
- Variable has unexpected value
- Changes don't persist
```

**Fix:**

```python
# ❌ Scope issue
def update_score():
    score = 100  # Creates local variable
    print(score)  # 100

score = 0
update_score()
print(score)  # Still 0! Local variable shadowed global

# ✅ Proper scope
score = 0

def update_score():
    global score  # Reference global
    score = 100

update_score()
print(score)  # 100

# ✅ Better: Return value
def calculate_score():
    return 100

score = calculate_score()
print(score)  # 100
```

---

## 📝 Debugging Cheat Sheet

### Quick Reference

```
┌──────────────────────┬─────────────────────────────────┐
│ Problem Type         │ First Thing to Try              │
├──────────────────────┼─────────────────────────────────┤
│ Crash/Exception      │ Read error message, check stack │
│ Wrong Output         │ Print debugging, verify inputs  │
│ Performance Issue    │ Profile, check loops/complexity │
│ Intermittent Bug     │ Look for race conditions/state  │
│ Works in Dev, Fails  │ Check environment differences   │
│ Worked Yesterday     │ Git diff recent changes         │
│ Can't Reproduce      │ Check environment/data/state    │
│ Infinite Loop        │ Add print/break in loop         │
│ Memory Issue         │ Profile memory, check leaks     │
│ UI Not Updating      │ Check event handlers/refresh    │
└──────────────────────┴─────────────────────────────────┘
```

### Debug Commands by Language

```bash
# Python
python -m pdb script.py          # Debug mode
python -m cProfile script.py     # Profile performance

# JavaScript/Node
node --inspect script.js         # Debug mode
node --inspect-brk script.js     # Debug from start

# Godot
godot --verbose                  # Verbose logging
godot --debug                    # Debug mode

# iOS
xcrun simctl list                # List simulators
instruments -t "Time Profiler"   # Profile app

# Android
adb logcat                       # View logs
adb shell am force-stop com.app  # Force stop app
```

---

## 🎯 Debugging Workflow Template

### Use This for Every Bug

```markdown
## Bug Report: [Title]

**Date:** [YYYY-MM-DD]
**Reported by:** [Name]
**Priority:** [Critical / High / Medium / Low]

---

### 1. Reproduction (30 min)

**Steps:**

1.
2.
3.

**Expected:**

**Actual:**

**Frequency:** [ ] Always [ ] Often [ ] Sometimes [ ] Rare

---

### 2. Isolation (60 min)

**Hypothesis:**

**Tests Performed:**

- [ ] Test 1:
- [ ] Test 2:
- [ ] Test 3:

**Narrowed to:**

---

### 3. Root Cause (30 min)

**5 Whys:**

1. Why? →
2. Why? →
3. Why? →
4. Why? →
5. Why? →

**Root Cause:**

---

### 4. Fix (60 min)

**Strategy:** [ ] Direct Fix [ ] Defensive [ ] Refactor [ ] Workaround

**Changes Made:**

**Files Modified:**

-
-

**Commit:** [hash]

---

### 5. Verification (30 min)

**Tests Passed:**

- [ ] Original reproduction steps
- [ ] Edge cases
- [ ] Related features
- [ ] All automated tests

**Prevention:**

- [ ] Test added
- [ ] Documentation updated
- [ ] Code review completed

---

**Total Time:** [X hours]
**Status:** [ ] Fixed [ ] In Progress [ ] Blocked
```

---

## 🔧 Debugging Tools Reference

### Essential Tools

```yaml
Universal:
  - Git: Version control, bisect for bug hunting
  - IDE Debugger: Breakpoints, stepping
  - Logging: Strategic print/log statements
  - Documentation: Read the manual!

Godot:
  - Built-in Debugger: Breakpoints, inspector
  - Performance Monitor: FPS, memory
  - Remote Inspector: Live scene tree
  - Debug Draw: Visualize game state

Web:
  - Chrome DevTools: Console, Network, Performance
  - React DevTools: Component inspection
  - Lighthouse: Performance audit
  - Postman: API testing

Python:
  - pdb: Interactive debugger
  - logging: Structured logging
  - cProfile: Performance profiling
  - pytest: Test framework

iOS:
  - Xcode Debugger: LLDB, breakpoints
  - Instruments: Profiling
  - Console.app: System logs
  - Charles Proxy: Network debugging

Android:
  - Android Studio: Debugger, profiler
  - Logcat: System logs
  - adb: Device interaction
  - Stetho: Debug bridge

General:
  - Wireshark: Network packet analysis
  - Charles/Fiddler: HTTP proxy debugging
  - Memory profilers: Find leaks
  - Performance profilers: Find bottlenecks
```

---

## 📚 When to Ask for Help

### Before Asking

```
✅ Do This First:
- [ ] Spent at least 30 minutes debugging
- [ ] Read error messages carefully
- [ ] Searched Google/Stack Overflow
- [ ] Checked documentation
- [ ] Created minimal reproduction
- [ ] Tried rubber duck debugging

❌ Don't Ask:
- Error message you haven't Googled
- Issue you haven't tried to reproduce
- Problem without showing your code
- "It doesn't work" without details
```

### How to Ask for Help

````markdown
## Help Request Template

**Problem:**
[One-sentence description]

**Environment:**

- OS:
- Language/Framework version:
- Dependencies:

**What I'm Trying to Do:**
[Goal/expected behavior]

**What's Happening Instead:**
[Actual behavior]

**Reproduction Steps:**

1.
2.
3.

**What I've Tried:**

-
-
-

**Relevant Code:**

```[language]
[Minimal code that shows the problem]
```
````

**Error Messages:**

```
[Full error with stack trace]
```

**Question:**
[Specific question]

```

---

## 💡 Debugging Wisdom

### Quotes to Live By

> "If debugging is the process of removing bugs, then programming must be the process of putting them in." - Edsger Dijkstra

> "Everyone knows that debugging is twice as hard as writing a program in the first place." - Brian Kernighan

> "The most effective debugging tool is still careful thought, coupled with judiciously placed print statements." - Brian Kernighan

> "Talk is cheap. Show me the code." - Linus Torvalds

### Pro Tips

1. **Take breaks** - Fresh eyes find bugs faster
2. **Sleep on it** - Your brain debugs while you sleep
3. **Explain it** - Rubber duck debugging works
4. **Start simple** - Check the obvious first
5. **Trust nothing** - Verify all assumptions
6. **Document** - Future you will be grateful
7. **Learn patterns** - Same bugs happen everywhere
8. **Stay calm** - Frustration makes you miss things

---

**Remember:**

> Every bug is an opportunity to learn.
> Every fix makes you a better developer.
> Every debug session teaches you patience.

**Now go squash those bugs! 🐛🔨**

---

**Version:** 1.0
**Last Updated:** December 10, 2025
**Applies to:** All development projects
```
