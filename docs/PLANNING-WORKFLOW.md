# Planning-First Workflow

## Overview

All new projects begin with a **planning phase** before any code implementation. This ensures thoughtful design and prevents rushed development.

## Workflow Phases

### Phase 1: Planning (New Projects)

**Status:** Planning Phase Active  
**Marker:** `.copilot-planning` file exists  
**AI Modes:** `/plan`, `/ask`, `/edit` only (agent mode only on explicit request)

**Steps:**
1. Create new project: `~/Developer/tools/project-management/init-project.sh`
2. Complete `PLANNING-MASTER.md` template
3. Use planning-focused AI modes
4. No code implementation

**Files Created:**
- `PLANNING-MASTER.md` - Main planning document
- `.copilot-planning` - Phase marker
- `README.md` - Planning instructions
- `.vscode/settings.json` - AI mode controls

### Phase 2: Implementation

**Status:** Active Development  
**Marker:** `.copilot-planning` deleted  
**AI Modes:** All modes available including agent

**Transition:**
```bash
cd ~/Developer/projects/{type}/{project-name}
~/Developer/tools/project-management/complete-planning.sh
```

**What Changes:**
- Planning restrictions removed
- Agent mode available for implementation
- README updated to development phase
- VS Code settings updated

## Scripts

### Initialize New Project
```bash
~/Developer/tools/project-management/init-project.sh
```
Creates project with planning-first setup.

### Complete Planning Phase
```bash
cd /path/to/project
~/Developer/tools/project-management/complete-planning.sh
```
Transitions from planning to implementation.

## AI Mode Guide

| Phase | /plan | /ask | /edit | Agent |
|-------|-------|------|-------|-------|
| Planning | ✅ | ✅ | ✅ | ⚠️ Only on explicit request |
| Implementation | ✅ | ✅ | ✅ | ✅ Available |

## Project Structure

```
projects/{type}/{project-name}/
├── PLANNING-MASTER.md        # Planning document (all phases)
├── .copilot-planning          # Planning phase marker (removed after planning)
├── README.md                  # Phase-specific instructions
├── README-PLANNING.md         # Archived after planning complete
└── .vscode/
    └── settings.json          # AI mode controls
```

## Best Practices

1. **Complete Planning First** - Don't rush into implementation
2. **Use Appropriate AI Modes** - Respect planning phase restrictions
3. **Document Decisions** - Use PLANNING-MASTER.md decision log
4. **Explicit Agent Requests** - If you need agent mode during planning, explicitly request it
5. **Mark Planning Complete** - Only transition when truly ready

## Benefits

✅ **Thoughtful Design** - Forces planning before coding  
✅ **Better Architecture** - Time to consider alternatives  
✅ **Reduced Rework** - Fewer changes during implementation  
✅ **Clear Documentation** - Planning becomes reference material  
✅ **Controlled AI Usage** - Right tool for right phase  

---

**Related Files:**
- [PLANNING-MASTER.md template](../templates/planning/PLANNING-MASTER.md)
- [init-project.sh](../tools/project-management/init-project.sh)
- [complete-planning.sh](../tools/project-management/complete-planning.sh)
