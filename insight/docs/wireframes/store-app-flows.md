# Store App - Navigation & Flows

## Navigation Structure

### Primary Navigation
**Horizontal Tab Bar** (Top of Dashboard)
- Overview (Default)
- (Future features will add more tabs)

---

## Screen Hierarchy

```
Store App
│
├── Geofence Check (Entry Point)
│   └── If valid → Dashboard
│       If invalid → Location Error Screen
│
├── Overview (Dashboard)
│   ├── Row 1: Current Period Info (Week/Period/Quarter)
│   ├── Row 2: Today Section (Date, Weather, Peak Hours)
│   ├── Row 3: Team Schedule
│   ├── Row 4: KPIs Row
│   ├── Row 5: Goals Table
│   ├── Row 6: Forms Section
│   │   ├── Daily Forms (Grid)
│   │   ├── Weekly Forms (Grid)
│   │   ├── Period Forms (Grid)
│   │   └── Other Forms (Grid)
│   │
│   └── Tap Form Card → Form Viewer
│
└── Form Viewer
    ├── Form Header (Title, Progress)
    ├── Scrollable Questions
    ├── Auto-save indicator
    └── Submit Button
```

---

## Key Screens Detail

### 0. Geofence Check (Launch Screen)

**Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│          🔒 Insight                 │
│                                     │
│      Verifying location...          │
│                                     │
│          [Loading...]               │
│                                     │
│                                     │
│    (Test mode: Bypass enabled)      │
│                                     │
└─────────────────────────────────────┘
```

**If Location Valid:**
- Smooth transition to Dashboard

**If Location Invalid:**
```
┌─────────────────────────────────────┐
│                                     │
│          📍 Location Required       │
│                                     │
│   You must be at the store          │
│   to access this app.               │
│                                     │
│   Current distance: 2.3 km          │
│                                     │
│   [Retry]  [Contact Support]        │
│                                     │
└─────────────────────────────────────┘
```

---

### 1. Dashboard (Overview)

**Layout (Mobile):**
```
┌─────────────────────────────────────┐
│ Store                        [Menu] │
├─────────────────────────────────────┤
│ [Overview]                          │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Week 3 | Period 13 | Quarter 4 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Today                               │
│ ┌─────────────────────────────────┐ │
│ │ Monday, December 16, 2025       │ │
│ │ ☀️ 72°F, Sunny                  │ │
│ │ Peak Hours: 12pm-2pm, 6pm-8pm  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Team Schedule                       │
│ ┌─────────────────────────────────┐ │
│ │ John Doe      9:00 AM - 5:00 PM │ │
│ │ Jane Smith   11:00 AM - 7:00 PM │ │
│ │ Mike Johnson  2:00 PM - 10:00 PM│ │
│ └─────────────────────────────────┘ │
│                                     │
│ KPIs                                │
│ ┌───────────┐ ┌───────────┐       │
│ │ GEM Score │ │ Hours     │       │
│ │   85.2    │ │ 142/150   │       │
│ │   ↑ 2.1%  │ │   95%     │       │
│ └───────────┘ └───────────┘       │
│ ┌───────────┐ ┌───────────┐       │
│ │ Labor %   │ │ Period    │       │
│ │  13.5%    │ │ Progress  │       │
│ │  ↑ 0.5%   │ │   65%     │       │
│ └───────────┘ └───────────┘       │
│                                     │
│ Goals                               │
│ ┌─────────────────────────────────┐ │
│ │          Week    Period          │ │
│ │ Sales   $4,200   $16,800        │ │
│ │ Goal    $5,000   $20,000        │ │
│ │ %         84%       84%         │ │
│ │                                 │ │
│ │ GEM     85.2     Target: 85.0  │ │
│ │                                 │ │
│ │ Forms    92%   8 auto-submitted │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ▼ Scroll for Forms ▼               │
│                                     │
└─────────────────────────────────────┘
```

**Forms Section (Scrolled Down):**
```
┌─────────────────────────────────────┐
│                                     │
│ Daily Operations                    │
│ ┌───────────┐ ┌───────────┐        │
│ │ Opening   │ │ Closing   │        │
│ │ Checklist │ │ Checklist │        │
│ │ ────────  │ │ ────────  │        │
│ │ ● Not     │ │ ● In Prog │        │
│ │   Started │ │   40%     │        │
│ │           │ │           │        │
│ │ [Open]    │ │ [Resume]  │        │
│ └───────────┘ └───────────┘        │
│                                     │
│ Weekly                              │
│ ┌───────────┐ ┌───────────┐        │
│ │ Safety    │ │ Inventory │        │
│ │ Check     │ │ Review    │        │
│ │ ────────  │ │ ────────  │        │
│ │ ✓ Complete│ │ ● Not     │        │
│ │           │ │   Started │        │
│ │           │ │           │        │
│ │ [View]    │ │ [Open]    │        │
│ └───────────┘ └───────────┘        │
│                                     │
│ Period                              │
│ ┌───────────┐                       │
│ │ End of    │                       │
│ │ Period    │                       │
│ │ ────────  │                       │
│ │ ⚠️ Auto-  │                       │
│ │   Submit  │                       │
│ │           │                       │
│ │ [View]    │                       │
│ └───────────┘                       │
│                                     │
│ Other                               │
│ ┌───────────┐ ┌───────────┐        │
│ │ Customer  │ │ Feedback  │        │
│ │ Feedback  │ │ Form      │        │
│ │ ────────  │ │ ────────  │        │
│ │ ● In Prog │ │ ✓ Complete│        │
│ │   25%     │ │           │        │
│ │ [Resume]  │ │ [View]    │        │
│ └───────────┘ └───────────┘        │
│                                     │
└─────────────────────────────────────┘
```

**Status Indicators:**
- ● Gray dot = Not Started
- ● Blue dot = In Progress
- ✓ Green check = Completed
- ⚠️ Orange warning = Auto-Submitted

**Interactions:**
- **Tap form card** → Opens Form Viewer
- **Pull to refresh** → Reload data
- **Scroll sections** → View all content
- Forms outside timeframe are grayed out with 🔒 lock icon

---

### 2. Form Viewer (Scrollable Single Page)

**Layout:**
```
┌─────────────────────────────────────┐
│ ← Opening Checklist          [Save]│
├─────────────────────────────────────┤
│                                     │
│ Progress: 40% ████░░░░░             │
│ Auto-saving... ✓ Saved              │
│                                     │
├─────────────────────────────────────┤
│ Section: Pre-Opening Tasks          │
├─────────────────────────────────────┤
│                                     │
│ 1. Unlock all doors? *              │
│ ┌─────────────────────────────────┐ │
│ │ ○ Yes  ○ No  ○ N/A              │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 2. Turn on all lights? *            │
│ ┌─────────────────────────────────┐ │
│ │ ○ Yes  ● No  ○ N/A              │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 3. System boot time                 │
│ ┌─────────────────────────────────┐ │
│ │ [08:15 AM____________]          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 4. Any issues to report?            │
│ ┌─────────────────────────────────┐ │
│ │ [________________________]      │ │
│ │ [________________________]      │ │
│ │ [________________________]      │ │
│ └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│ Section: Equipment Check            │
├─────────────────────────────────────┤
│                                     │
│ 5. Register working properly? *     │
│ ┌─────────────────────────────────┐ │
│ │ ○ Yes  ○ No                     │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 6. Temperature check (°F) *         │
│ ┌─────────────────────────────────┐ │
│ │ [72_____]                       │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ▼ Scroll for more ▼                │
│                                     │
│                                     │
│ [Submit Form]                       │
│                                     │
└─────────────────────────────────────┘
```

**Field Types Displayed:**
- **Radio buttons** - Single choice (Yes/No, etc.)
- **Checkboxes** - Multiple choice
- **Text input** - Short answers
- **Text area** - Long answers
- **Number input** - Numeric values
- **Time picker** - Time selection
- **Date picker** - Date selection
- **Dropdown** - Select from list
- **File upload** - Photos/documents

**Auto-save Behavior:**
- Saves after each field change (500ms debounce)
- Shows "Saving..." → "✓ Saved"
- Works offline, syncs when online
- Progress bar updates in real-time

**Validation:**
- Required fields marked with *
- Can't submit until all required fields filled
- Inline error messages
- Red border on invalid fields

**Interactions:**
- **Fill out field** → Auto-saves
- **Tap "← Back"** → Save and return to dashboard
- **Tap "Submit"** → 
  - Validates all fields
  - If valid: Confirm dialog → Submit → Return to dashboard
  - If invalid: Scroll to first error, show message

---

### 3. Completed Form View (Read-only)

**Layout:**
```
┌─────────────────────────────────────┐
│ ← Closing Checklist                │
├─────────────────────────────────────┤
│                                     │
│ ✓ Completed                         │
│ Submitted: Dec 16, 2025 - 10:00 PM │
│                                     │
├─────────────────────────────────────┤
│ Section: Closing Tasks              │
├─────────────────────────────────────┤
│                                     │
│ 1. All customers left premises?     │
│ Answer: Yes                         │
│                                     │
│ 2. All registers closed?            │
│ Answer: Yes                         │
│                                     │
│ 3. Final cash count                 │
│ Answer: $1,247.50                   │
│                                     │
│ 4. Notes for tomorrow               │
│ Answer: Restock aisle 3, schedule  │
│ delivery for Wednesday              │
│                                     │
│ ▼ Scroll for more ▼                │
│                                     │
└─────────────────────────────────────┘
```

**Auto-Submitted Form:**
- Same layout
- Orange banner: "⚠️ Auto-Submitted"
- Shows "No Response" for empty fields
- Cannot edit

---

## User Flows

### Flow 1: Complete a Daily Form

1. **Launch app** → Geofence check passes
2. **Dashboard** loads
   - View current period info
   - See today's weather, schedule
   - Scroll to Daily Operations section
3. **Tap "Opening Checklist" card**
   - Status: Not Started
4. **Form Viewer** opens
   - Progress: 0%
5. **Fill out questions** one by one
   - Each answer auto-saves
   - Progress bar updates
   - Sections clearly divided
6. **Answer all required fields**
   - Submit button becomes enabled
7. **Tap "Submit"**
   - Confirmation dialog
   - "Are you sure you want to submit?"
8. **Confirm** → Form submitted!
   - Success message
   - Return to dashboard
9. **Dashboard** updates
   - Form card shows ✓ Completed
   - Progress bars update

### Flow 2: Resume Partial Form

1. **Dashboard** → See "In Progress" form (40%)
2. **Tap form card**
3. **Form Viewer** opens at same scroll position
   - Previously answered fields filled
   - Continue where left off
4. **Fill remaining fields**
5. **Submit** → Complete!

### Flow 3: View Completed/Auto-Submitted Form

1. **Dashboard** → Tap completed form card
2. **Read-only view** opens
   - See all answers
   - Can't edit
   - See submission timestamp
3. **Tap "← Back"** → Return to dashboard

### Flow 4: Locked Form (Outside Timeframe)

1. **Dashboard** → See form with 🔒 lock icon
2. **Tap form card** → Nothing happens
   - Or shows toast: "Form available 8:00 AM - 10:00 PM"

---

## Interaction Patterns

### Pull to Refresh
- Dashboard pulls down
- Shows loading spinner
- Refreshes all data

### Auto-save Feedback
- Small indicator in top bar
- "Saving..." with spinner
- "✓ Saved" with checkmark (2 sec)
- Haptic feedback on save

### Form Navigation
- Smooth scrolling
- Sticky progress bar at top
- Sections with dividers
- Auto-scroll to validation errors

### Offline Behavior
- Yellow banner: "Offline - Changes saved locally"
- Forms still work
- Syncs when back online
- Green banner: "✓ Synced"

---

## Empty States

### No Forms Available
```
┌─────────────────────────────────────┐
│                                     │
│          📝                         │
│                                     │
│     No Forms Available              │
│                                     │
│  All forms for today are complete!  │
│                                     │
└─────────────────────────────────────┘
```

### Loading State
```
┌─────────────────────────────────────┐
│                                     │
│          ⟳                          │
│                                     │
│     Loading your dashboard...       │
│                                     │
└─────────────────────────────────────┘
```

---

## Color Coding

**Form Status Colors:**
- Not Started: Gray border, gray dot
- In Progress: Blue border, blue dot, progress bar
- Completed: Green border, green checkmark
- Auto-Submitted: Orange border, orange warning icon

**KPI Cards:**
- Positive trend: Green arrow ↑
- Negative trend: Red arrow ↓
- Neutral: Gray text

---

Next step: Would you like me to:
1. Create more detailed component specs?
2. Design the interaction animations?
3. Create a clickable prototype guide?
4. Move to database architecture planning?
