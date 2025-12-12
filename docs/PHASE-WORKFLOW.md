# Phase-Based Development Workflow

## Overview

Projects now have comprehensive phase tracking integrated with PLANNING-MASTER.md, VS Code settings, and automation scripts.

## Project Phases

### 1. 📋 Planning Phase
**Marker:** `.copilot-planning`
**AI Mode:** `/plan`, `/ask`, `/edit` only (agent mode restricted)
**Focus:** Complete PLANNING-MASTER.md template

**Initialize:**
```bash
~/Developer/tools/project-management/init-project.sh
```

**Transition to Development:**
```bash
~/Developer/tools/project-management/complete-planning.sh
```

---

### 2. 💻 Development Phase
**Marker:** `.copilot-development`
**AI Mode:** All modes including agent
**Focus:** Implement Phase 1 MVP features

**Auto-created by:** `complete-planning.sh`

**Key Activities:**
- Implement features from PLANNING-MASTER.md
- Write tests and documentation
- Beta testing
- Production environment setup

**Transition to Production:**
```bash
~/Developer/tools/project-management/transition-to-production.sh
```

---

### 3. 🚀 Production Phase
**Marker:** `.copilot-production`
**AI Mode:** All modes (with production caution)
**Focus:** Live application with active feature development

**Auto-created by:** `transition-to-production.sh`

**Key Activities:**
- Monitor production metrics
- Implement Phase 2/3 enhancements
- User feedback and support
- Performance optimization

**Transition to Maintenance:**
```bash
~/Developer/tools/project-management/enter-maintenance.sh
```

---

### 4. 🔧 Maintenance Phase

**Marker:** `.copilot-maintenance`
**AI Mode:** All modes (maintenance focus)
**Focus:** Stability, security, and support

**Auto-created by:** `enter-maintenance.sh`

**Key Activities:**

- Bug fixes and patches
- Security updates
- Dependency maintenance
- User support

---

### 🔄 Restart Planning Cycle (Circular Lifecycle)

**Marker:** `.copilot-planning` (restarted)
**AI Mode:** `/plan`, `/ask`, `/edit` only (agent mode restricted)
**Focus:** Strategic planning for next major version

**Use Cases:**

- Major version releases (v2.0, v3.0)
- Architecture overhauls (monolith → microservices)
- Platform expansions (web → mobile)
- Significant feature additions requiring product rethinking

**NOT for:**

- Bug fixes and patches
- Minor feature additions
- Performance optimizations
- Dependency updates

**Transition Command:**

```bash
~/Developer/tools/project-management/restart-planning-cycle.sh
```

**What Happens:**

- Archives current phase markers and docs (timestamped)
- Removes current phase markers
- Creates new `.copilot-planning` marker for next major version
- Copies PLANNING-NEXT-VERSION.md template → PLANNING-v[X].0.md
- Pre-fills with project info (current version, target version)
- Logs transition to `.phase-history.log`
- Updates VS Code settings for planning mode

**Planning Template Sections:**

The PLANNING-NEXT-VERSION.md template includes:
- Current State Assessment (what works, pain points, metrics)
- Vision for next version
- Evolution Strategy (what stays/improves/replaces/new)
- Technical Changes (architecture, stack, database, API)
- Migration Planning (user migration, data migration, deployment)
- Feature Planning
- Timeline & Roadmap
- Backward Compatibility
- Risk Assessment
- Learnings Applied

**Parallel Version Management:**

When planning v2.0:
- Keep v1.x stable on `main` branch
- Create `v2.0-planning` branch
- Bug fixes → `main` (v1.x)
- Major features → `v2.0-planning`
- Merge v1.x fixes into v2.0 as needed

**Strategy:**

1. Assess current version comprehensively
2. Define clear vision for next major version
3. Plan evolution strategy (not rewrite from scratch)
4. Consider migration paths and backward compatibility
5. Apply learnings from current version
6. When planning complete → transition to development

---

## Phase Management Utilities

### Check Current Phase
```bash
~/Developer/tools/project-management/get-project-phase.sh
```

Shows:
- Current phase
- Phase duration
- Next recommended actions
- Planning doc status

**Options:**
```bash
# Verbose mode
get-project-phase.sh -v

# Script-friendly output (phase name only)
get-project-phase.sh --phase-only

# Check specific project
get-project-phase.sh ~/Developer/projects/apps/my-app
```

---

## Phase Tracking Features

### Automatic Updates

Each phase transition automatically:
1. Updates phase marker files
2. Logs transition in `.phase-history.log`
3. Updates VS Code settings for phase context
4. Updates PLANNING-MASTER.md phase status
5. Creates phase-specific documentation

### Phase History

All transitions logged in `.phase-history.log`:
```
2025-12-11 10:30:00 | Planning → Development | Transitioned via complete-planning.sh
2025-12-15 14:20:00 | Development → Production | Target: Vercel | URL: https://app.example.com
```

### PLANNING-MASTER.md Integration

Template now includes:
- **Project Phase Status** section in metadata
- **Phase History** table
- **Phase Transition Workflows** with checklists
- **Phase-Specific Completion Checklists**
- **Phase Management Utilities** reference

---

## Integration with Existing Tools

### project-lifecycle.sh
Updated to:
- Check for phase markers first
- Display PLANNING-MASTER.md phase info
- Show phase marker status
- Fall back to legacy detection

### VS Code Settings
Phase-specific instructions:
- **Planning:** Restrict to planning modes
- **Development:** Full feature development
- **Production:** Caution and stability focus
- **Maintenance:** Maintenance priorities

---

## Workflow Examples

### New Project Start to Production

```bash
# 1. Initialize project (Planning phase)
~/Developer/tools/project-management/init-project.sh

# 2. Complete PLANNING-MASTER.md
# ... work on planning document ...

# 3. Check phase status
~/Developer/tools/project-management/get-project-phase.sh

# 4. Transition to Development
~/Developer/tools/project-management/complete-planning.sh

# 5. Implement MVP
# ... development work ...

# 6. Transition to Production
~/Developer/tools/project-management/transition-to-production.sh

# 7. Deploy and monitor
# ... production operations ...

# 8. When feature development stabilizes
~/Developer/tools/project-management/enter-maintenance.sh
```

### Restart Planning Cycle for Next Major Version

```bash
# From maintenance or production phase

# 1. Check current phase
~/Developer/tools/project-management/get-project-phase.sh

# 2. Restart at planning phase for major evolution
~/Developer/tools/project-management/restart-planning-cycle.sh
# Confirms: v1.0 → v2.0
# Use for: Major versions, architecture overhauls, platform expansions

# 3. Create planning branch
git checkout -b v2.0-planning

# 4. Fill out PLANNING-v2.0.md
# • Current state assessment (what worked, what didn't)
# • Vision for v2.0
# • Evolution strategy
# • Technical changes
# • Migration planning
# • Apply v1.0 learnings

# 5. Transition to development when planning complete
~/Developer/tools/project-management/complete-planning.sh

# 6. Develop v2.0 features
# ... implement ...

# 7. When ready, transition to production
~/Developer/tools/project-management/transition-to-production.sh
```

### Circular Lifecycle

```
📋 Planning → 💻 Development → 🚀 Production → 🔧 Maintenance
   ↑                                              ↓
   └──────────────────────────────────────────────┘
        (restart-planning-cycle for major versions)

Minor changes (bugs, patches) stay in current phase
Major evolution (v2.0, v3.0) restarts at planning
```

### Check Phase Status Across Projects

```bash
# Check current project
cd ~/Developer/projects/apps/my-app
~/Developer/tools/project-management/get-project-phase.sh

# Check specific project from anywhere
~/Developer/tools/project-management/get-project-phase.sh ~/Developer/projects/apps/another-app

# Get just the phase name for scripting
PHASE=$(~/Developer/tools/project-management/get-project-phase.sh --phase-only)
echo "Current phase: $PHASE"
```

---

## Files Created by Phase Transitions

### Planning → Development
- `.copilot-development` marker
- `.phase-history.log` (initiated)
- Updated `.vscode/settings.json`
- `README.md` (development version)

### Development → Production
- `.copilot-production` marker
- `.production-info.json`
- `PRODUCTION-CHECKLIST.md`
- Updated `.phase-history.log`

### Production → Maintenance

- `.copilot-maintenance` marker
- `.maintenance-info.json`
- `MAINTENANCE-PROCEDURES.md`
- Updated `.phase-history.log`
- Archived `PRODUCTION-CHECKLIST.md`

### Maintenance/Production → Planning (Restart)

- `.copilot-planning` marker (new major version)
- `PLANNING-v[X].0.md` (from PLANNING-NEXT-VERSION.md template)
- Updated `.phase-history.log`
- `.phase-archive/` (previous phase markers and docs archived)
- Updated `.vscode/settings.json`

---

## Best Practices

1. **Always use phase transition scripts** - Don't manually edit phase markers
2. **Keep PLANNING-MASTER.md updated** - Update phase history table
3. **Review checklists before transitions** - Ensure readiness
4. **Monitor phase history log** - Track project evolution
5. **Use get-project-phase.sh regularly** - Stay aware of current phase
6. **Update phase-specific docs** - Keep procedures current
7. **Commit phase transitions** - Git commit after each transition

---

## Troubleshooting

### Multiple Phase Markers Present
```bash
# Remove all markers and set correct one
rm .copilot-*

# For development phase
cat > .copilot-development << 'EOF'
# Development Phase Active
# Phase Started: $(date +%Y-%m-%d\ %H:%M:%S)
EOF
```

### Phase Mismatch with PLANNING-MASTER.md
Manually update the phase in PLANNING-MASTER.md:
```markdown
**Current Phase:** Development
**Phase Started:** 2025-12-11
```

### Missing Phase Marker
Run the appropriate phase transition script to set up markers correctly.

---

## Migration for Existing Projects

If you have projects without phase markers:

1. **Determine current phase** manually
2. **Create appropriate marker:**
   ```bash
   # For development
   cat > .copilot-development << 'EOF'
   # Development Phase Active
   # Phase Started: 2025-12-11 10:00:00
   EOF
   ```
3. **Update PLANNING-MASTER.md** if present
4. **Initialize phase history:**
   ```bash
   echo "$(date +%Y-%m-%d\ %H:%M:%S) | Migrated to phase tracking | Phase: development" > .phase-history.log
   ```

---

## Related Documentation

- [PLANNING-WORKFLOW.md](PLANNING-WORKFLOW.md) - Original planning workflow
- [PLANNING-MASTER.md template](../templates/planning/PLANNING-MASTER.md) - Enhanced template
- Project Management Scripts: `~/Developer/tools/project-management/`
- Orchestration Scripts: `~/Developer/tools/orchestration/`
