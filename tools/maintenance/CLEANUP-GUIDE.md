# Cleanup Workflow Guide

## Overview

The **cleanup-workflow.sh** tool provides safe, automated cleanup with data consolidation and protection features.

## Key Safety Features

✅ **Automatic Backups** - Creates backups before major operations  
✅ **Version Comparison** - Compares file dates before removing duplicates  
✅ **Data Preservation** - Keeps newer versions automatically  
✅ **Backup Retention** - Maintains backups for 7 days  
✅ **Dry-Run Mode** - Preview changes before executing

## Quick Start

```bash
# Interactive mode (recommended for first use)
./tools/maintenance/cleanup-workflow.sh

# Safe cleanup with backup and consolidation
./tools/maintenance/cleanup-workflow.sh safe

# Preview what would be cleaned
./tools/maintenance/cleanup-workflow.sh deep --dry-run
```

## Cleanup Modes

### 1. Safe Mode (Recommended)

```bash
./tools/maintenance/cleanup-workflow.sh safe
```

- Creates safety backup
- Consolidates archives (removes older versions)
- Cleans system files, temp files, Python artifacts
- Removes empty directories
- Auto-cleans old backups (>7 days)

**Best for**: Regular maintenance, first-time use

### 2. Quick Mode

```bash
./tools/maintenance/cleanup-workflow.sh quick
```

- macOS system files (.DS_Store)
- Temporary files (.tmp, .log, .bak)
- Empty directories

**Best for**: Daily quick cleanup

### 3. Standard Mode

```bash
./tools/maintenance/cleanup-workflow.sh standard
```

- Everything in Quick mode
- Python artifacts (**pycache**, .pyc)
- Git artifacts
- Old logs (30+ days)

**Best for**: Weekly maintenance

### 4. Deep Mode

```bash
./tools/maintenance/cleanup-workflow.sh deep
```

- Everything in Standard mode
- Build artifacts (dist, build, .next)
- Archive consolidation
- Duplicate detection
- Large directory analysis

**Best for**: Monthly deep clean

### 5. Analysis Mode

```bash
./tools/maintenance/cleanup-workflow.sh analysis
```

- No deletions
- Shows what would be cleaned
- Analyzes large directories
- Scans node_modules
- Finds duplicates

**Best for**: Understanding disk usage

### 6. Compare Mode

```bash
./tools/maintenance/cleanup-workflow.sh compare
```

- Compares archived files with current versions
- Shows file differences
- Identifies which version is newer
- No deletions

**Best for**: Before consolidating archives

## Command Options

### Dry Run

```bash
./tools/maintenance/cleanup-workflow.sh deep --dry-run
```

Preview all changes without deleting anything.

### Verbose Output

```bash
./tools/maintenance/cleanup-workflow.sh standard --verbose
```

Show detailed output for each file processed.

### Custom Directory

```bash
./tools/maintenance/cleanup-workflow.sh safe --dir /path/to/directory
```

Run cleanup on a different directory.

## Data Consolidation

The cleanup workflow intelligently handles duplicate files:

1. **Compares file dates** - Identifies which version is newer
2. **Preserves latest** - Keeps the most recent version
3. **Backs up before removing** - Creates safety backup
4. **Warns on conflicts** - Alerts if archive is newer than current

### Archive Consolidation Process

```
Archive (Dec 9 08:57) ← older
Current (Dec 9 08:58) ← newer ✓ KEEP

Result: Archive version removed, backup created
```

## Safety Backups

Backups are automatically created in hidden folders:

```
.cleanup-backup-YYYYMMDD-HHMMSS/
```

### Backup Retention

- Kept for **7 days** by default
- Auto-cleaned by cleanup workflow
- Contains complete copy of removed files

### Manual Backup Restore

```bash
# If you need to restore a file
cp .cleanup-backup-20251211-084206/archive/script-backups/file.sh ./restore-location/
```

## What Gets Cleaned

### ✅ Always Safe to Clean

- macOS system files (.DS*Store, .*\*)
- Temporary files (.tmp, .temp, .bak, .swp)
- Python cache (**pycache**, .pyc, .pyo)
- Empty directories (excluding protected: .git, node_modules)
- Old log files (30+ days)
- Git artifacts (gc.log)

### ⚠️ Cleaned with Analysis

- Build artifacts (dist, build, .next, .cache)
- Archived files (if current version newer)

### 🔒 Never Cleaned

- node_modules (analysis only, never auto-deleted)
- .git directories
- .venv directories
- Active project files
- Unique archive files (no current version)

## Custom Cleanup Tasks

```bash
./tools/maintenance/cleanup-workflow.sh
# Choose option 7: Custom

# Available tasks:
1) Create safety backup
2) Consolidate archives
3) macOS system files
4) Temporary files
5) Build artifacts
6) Python artifacts
7) Git artifacts
8) Empty directories
9) Old logs
10) Find duplicates
11) Analyze large directories
12) Clean old backups
```

Enter space-separated task numbers:

```
Tasks: 1 2 8 12
```

## Automation

### Schedule Weekly Cleanup

Add to crontab:

```bash
# Run standard cleanup every Sunday at 2 AM
0 2 * * 0 /Users/nandez/Developer/tools/maintenance/cleanup-workflow.sh standard
```

### Pre-commit Hook

```bash
# Add to .git/hooks/pre-commit
/Users/nandez/Developer/tools/maintenance/cleanup-workflow.sh quick --dry-run
```

## Troubleshooting

### "Files need manual review"

The workflow detected files where the archive version is newer than current.

**Solution:**

```bash
# Compare the files
./tools/maintenance/cleanup-workflow.sh compare

# Review differences and manually merge if needed
diff archive/script-backups/file.sh tools/location/file.sh

# After resolving, remove archive version or update current
```

### Large node_modules Directories

node_modules are **never** auto-deleted by this tool.

**To clean manually:**

```bash
cd project-directory
rm -rf node_modules
npm install  # or yarn install
```

### Restore from Backup

```bash
# List available backups
ls -la .cleanup-backup-*

# Restore specific file
cp .cleanup-backup-20251211-084206/path/to/file.sh ./destination/

# Restore entire archive
cp -R .cleanup-backup-20251211-084206/archive ./
```

## Best Practices

1. **Run analysis first** - Use `analysis` mode to understand what will be cleaned
2. **Use safe mode regularly** - Weekly `safe` mode keeps things clean
3. **Check backups** - Verify backups exist before running deep cleanup
4. **Use dry-run** - Preview with `--dry-run` for deep cleanups
5. **Review conflicts** - Use `compare` mode if you have archives

## Statistics

After cleanup, the tool shows:

- Files removed
- Directories removed
- Space freed
- Available disk space

## Integration with Dev Tools

The cleanup workflow integrates with other automation tools:

```bash
# Part of dev-master orchestration
./tools/orchestration/dev-master.sh workflow maintenance

# Part of project lifecycle
./tools/orchestration/project-lifecycle.sh workflow maintenance-cycle
```

## Examples

### Daily Routine

```bash
# Quick cleanup before starting work
./tools/maintenance/cleanup-workflow.sh quick
```

### Weekly Maintenance

```bash
# Standard cleanup every Friday
./tools/maintenance/cleanup-workflow.sh standard
```

### Monthly Deep Clean

```bash
# First Saturday of month
./tools/maintenance/cleanup-workflow.sh deep --verbose
```

### Before Major Changes

```bash
# Create backup before major refactoring
./tools/maintenance/cleanup-workflow.sh
# Choose: 1) Safe mode
```

### Space Analysis

```bash
# Check what's using space
./tools/maintenance/cleanup-workflow.sh analysis
```

## Help

```bash
./tools/maintenance/cleanup-workflow.sh --help
```

Shows all options, modes, and examples.
