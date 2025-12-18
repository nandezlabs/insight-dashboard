# Store Manager App - Navigation & Flows

## Navigation Structure

### Primary Navigation
**Horizontal Tab Bar** (Top of Dashboard)
- Overview (Default)
- Forms
- Analytics
- Settings

---

## Screen Hierarchy

```
Store Manager App
│
├── Overview (Dashboard)
│   ├── Header: Week/Period/Quarter Display
│   ├── Row 1: Progress Bars (Daily, Weekly, Period)
│   ├── Row 2: Statistics Cards
│   └── Row 3: Quick Action Cards
│
├── Forms
│   ├── Forms Library (Grid View)
│   │   ├── Search/Filter Bar
│   │   ├── Form Cards (Grid)
│   │   └── FAB: Create New Form
│   │
│   └── Form Builder (when creating/editing)
│       ├── Top Bar: Form Name + Tabs
│       │   ├── Creation Tab (Active)
│       │   ├── Settings Tab
│       │   └── Preview Tab
│       │
│       ├── Creation View (2-column layout)
│       │   ├── Left: Field Palette (bottom drawer when editing)
│       │   ├── Center: Form Canvas (drag-drop)
│       │   └── Right: Field Properties Panel
│       │
│       ├── Settings View
│       │   ├── Schedule Configuration
│       │   ├── Tags Management
│       │   ├── Assignments
│       │   └── Auto-submit Settings
│       │
│       └── Preview View
│           └── Live Form Preview
│
├── Analytics (Future)
│   └── Placeholder for now
│
└── Settings
    ├── Business Calendar
    ├── Goals & Targets
    ├── Team Management
    ├── Timeframes
    ├── Geofencing
    └── Data Import/Export
```

---

## Key Screens Detail

### 1. Overview (Dashboard)

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ Store Manager                                    [Menu] │
├─────────────────────────────────────────────────────────┤
│ [Overview] [Forms] [Analytics] [Settings]               │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ ┌───────────────────────────────────────────────────┐   │
│ │  Week 3  |  Period 13  |  Quarter 4              │   │
│ │  Current Date: Monday, Dec 16, 2025              │   │
│ └───────────────────────────────────────────────────┘   │
│                                                         │
│ ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│ │   Daily     │  │   Weekly    │  │   Period    │     │
│ │   ████ 75%  │  │   ███░ 60%  │  │   ██░░ 45%  │     │
│ │ Operations  │  │ Operations  │  │ Operations  │     │
│ └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                         │
│ ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│ │   Other     │  │   Other     │  │   Other     │     │
│ │   ██░░ 40%  │  │   █░░░ 25%  │  │   ████ 80%  │     │
│ └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                         │
│ Statistics (Current Timeframe)                          │
│ ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│ │ Completion  │  │ User Submit │  │ Auto Submit │     │
│ │    92%      │  │    85%      │  │    15%      │     │
│ └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                         │
│ Actions                                                 │
│ ┌──────────────────┐  ┌──────────────────┐            │
│ │  📝 Create Form  │  │  📊 View Forms   │            │
│ └──────────────────┘  └──────────────────┘            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Interactions:**
- Tap progress bars → View detailed submission list
- Tap stat cards → View breakdown/analytics
- Tap action cards → Navigate to respective screens
- Horizontal scroll on tab bar

---

### 2. Forms Library

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ Store Manager                                    [Menu] │
├─────────────────────────────────────────────────────────┤
│ Overview [Forms] Analytics Settings                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ ┌─────────────────────────────────────────┐  [Filter]  │
│ │ 🔍 Search forms...                      │            │
│ └─────────────────────────────────────────┘            │
│                                                         │
│ ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│ │ Daily Ops    │  │ Weekly Check │  │ Period Close │  │
│ │ ────────     │  │ ────────     │  │ ────────     │  │
│ │ Active       │  │ Active       │  │ Draft        │  │
│ │ [daily,main] │  │ [weekly]     │  │ [period]     │  │
│ │              │  │              │  │              │  │
│ │ [Edit] [⋮]   │  │ [Edit] [⋮]   │  │ [Edit] [⋮]   │  │
│ └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                         │
│ ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│ │ + Template   │  │ + Template   │  │              │  │
│ │   Library    │  │   Library    │  │              │  │
│ └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                         │
│                                  [+] Create New Form    │
└─────────────────────────────────────────────────────────┘
```

**Interactions:**
- Tap form card → Open form builder (edit mode)
- Tap [⋮] menu → Duplicate, Archive, Delete, Analytics
- Tap [+] FAB → Create new form (starts in builder)
- Long press card → Enter multi-select mode

---

### 3. Form Builder - Creation Tab

**Layout (Desktop/Tablet - 2 Column):**
```
┌─────────────────────────────────────────────────────────┐
│ ← Form Builder: Daily Operations                [Save] │
├─────────────────────────────────────────────────────────┤
│ [Creation] Settings Preview                      👁 View │
├──────────────────┬──────────────────────────────────────┤
│                  │                                      │
│  FORM CANVAS     │  FIELD PROPERTIES                    │
│                  │                                      │
│ ┌──────────────┐ │  Selected: Question 3                │
│ │ 1. Question  │ │                                      │
│ │    [Text]    │ │  Label: [What is your name?____]    │
│ │    [📝][🗑]  │ │  Type: [Short Text ▼]               │
│ │              │ │  Required: [✓]                       │
│ └──────────────┘ │  Placeholder: [Enter name...]        │
│                  │  Help text: [_________________]      │
│ ┌──────────────┐ │                                      │
│ │ 2. Question  │ │  Validation:                         │
│ │   [Dropdown] │ │  Min length: [2]  Max: [50]         │
│ │   [📝][🗑]   │ │                                      │
│ └──────────────┘ │  Conditional Logic:                  │
│                  │  Show if: [None ▼]                   │
│ ┌──────────────┐ │                                      │
│ │ 3. Question  │ │  Template:                           │
│ │    [Number]  │ │  [💾 Save as Template]              │
│ │    [📝][🗑]  │ │  [📂 Use Template]                  │
│ └──────────────┘ │                                      │
│                  │                                      │
│ [+ Add Section]  │  [Delete Field] [Duplicate]          │
│                  │                                      │
│ [Edit Mode ⋮]    │                                      │
│                  │                                      │
└──────────────────┴──────────────────────────────────────┘
```

**Layout (Mobile - Single Column with Bottom Drawer):**
```
┌─────────────────────────────────────┐
│ ← Daily Operations          [Save] │
├─────────────────────────────────────┤
│ [Creation] Settings Preview    👁   │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 1. What is your name?           │ │
│ │    Short Text | Required        │ │
│ │    [Tap to edit]                │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 2. Select your department       │ │
│ │    Dropdown | Optional          │ │
│ │    [Tap to edit]                │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ + Add Question                  │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
     ↑ Tap to show field palette
```

**Edit Mode (Drag & Drop):**
- Long press any field → Activates edit mode
- Drag handles appear (≡)
- Bottom palette shows field types to drag
- Tap outside or "Done" to exit edit mode

**Interactions:**
- Tap field → Select & show properties in right panel
- Drag field → Reorder
- Tap [📝] → Edit inline
- Tap [🗑] → Delete with confirmation
- Tap "+ Add Section" → Create new section divider
- Tap "💾 Save as Template" → Name and save field config
- Tap "📂 Use Template" → Modal with template library

---

### 4. Form Builder - Settings Tab

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ ← Form Builder: Daily Operations                [Save] │
├─────────────────────────────────────────────────────────┤
│ Creation [Settings] Preview                      👁 View │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ Form Information                                        │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Title: [Daily Operations________________]          │ │
│ │ Description: [_________________________]           │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Tags                                                    │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ [daily] [operations] [main]               [+ Add]  │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Schedule Configuration                                  │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Schedule Type: [Tag-based ▼]                       │ │
│ │                                                     │ │
│ │ Based on tags: daily, operations                   │ │
│ │ Timeframe: 08:00 - 22:00                          │ │
│ │ Auto-submit: 22:00                                 │ │
│ │                                                     │ │
│ │ [Configure Custom Schedule]                        │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Assignment                                              │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Assign to: [All Stores ▼]                         │ │
│ │                                                     │ │
│ │ ☐ Assign specific questions to team members       │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Advanced Settings                                       │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Max submissions per timeframe: [1____]             │ │
│ │ ☑ Allow saving as template                         │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Status                                                  │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Form Status: [Active ▼]                            │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

### 5. Settings Screen

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ Store Manager                                    [Menu] │
├─────────────────────────────────────────────────────────┤
│ Overview Forms Analytics [Settings]                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ Business Calendar                                       │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Start Date: [Dec 1, 2024]                          │ │
│ │ Current Week: 3    Period: 13    Quarter: 4       │ │
│ │                                                     │ │
│ │ [Reset Calendar]  [Manual Adjust]                  │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Timeframes                                              │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Daily:   08:00 - 22:00  Auto-submit: 22:00  [Edit]│ │
│ │ Weekly:  08:00 - 22:00  Auto-submit: 22:00  [Edit]│ │
│ │ Period:  08:00 - 22:00  Auto-submit: 22:00  [Edit]│ │
│ │                                                     │ │
│ │ [+ Add Custom Timeframe]                           │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Goals & Targets                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Sales Goal (Week): [$5,000]                        │ │
│ │ Sales Goal (Period): [$20,000]                     │ │
│ │ GEM Score Target: [85]                             │ │
│ │ Labor %: [12-15%]                                   │ │
│ │                                                     │ │
│ │ [Edit Goals]                                        │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Team Management                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Employees: 5                                        │ │
│ │ [Manage Team]  [Import Schedule]                   │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Geofencing                                              │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Address: [Your Store Address_________]             │ │
│ │ Radius: [100] meters                               │ │
│ │ ☐ Enabled  ☑ Test Mode                            │ │
│ │                                                     │ │
│ │ [Set Location]                                      │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ Data Management                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ [Import CSV/Excel]  [Export Data]                  │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## User Flows

### Flow 1: Create a New Form

1. **Dashboard** → Tap "Create Form" action card
2. **Form Builder** opens (Creation tab)
   - Enter form title
   - Tap "+" or drag field from palette
3. **Add fields** one by one
   - Select field from palette
   - Configure in properties panel
   - Optionally save as template
4. **Add sections** (optional)
   - Tap "+ Add Section"
   - Group related fields
5. **Switch to Settings tab**
   - Add tags (daily, operations, main)
   - Configure schedule
   - Set assignments
6. **Switch to Preview tab**
   - Test form appearance
7. **Tap Save** → Form created!
8. **Return to Forms Library** → See new form card

### Flow 2: Edit Existing Form

1. **Forms Library** → Tap form card
2. **Form Builder** opens with existing data
3. **Make changes** in Creation or Settings tabs
4. **Auto-save** or tap Save
5. **Close** → Return to library

### Flow 3: View Progress

1. **Dashboard** → View progress bars
2. **Tap progress bar** → See detailed submission list
   - Filter by date, status, team member
   - See completion percentages
3. **Tap submission** → View details/answers

---

## Navigation Patterns

### Tab Navigation
- Horizontal tabs stay visible at top
- Active tab highlighted
- Smooth transitions between tabs

### Back Navigation
- "←" arrow in top left
- Returns to previous screen
- Maintains scroll position

### Modal/Sheet Navigation
- Settings dialogs slide up from bottom
- Dismiss with X or swipe down
- Blur background

---

Next: Store App wireframes?
