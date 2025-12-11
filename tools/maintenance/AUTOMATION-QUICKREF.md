# Automated Cleanup Quick Reference

## ✅ System Status

**Schedule:** Every Sunday at 2:00 AM  
**Mode:** Safe (backup + consolidate + basic cleanup)  
**Status:** ACTIVE ✓

## 📋 Quick Commands

```bash
# Check status
./tools/maintenance/schedule-cleanup.sh status

# Run test cleanup (dry-run)
./tools/maintenance/schedule-cleanup.sh test

# View latest report
./tools/maintenance/schedule-cleanup.sh report

# List all reports
./tools/maintenance/schedule-cleanup.sh reports

# View latest log
./tools/maintenance/schedule-cleanup.sh logs

# Stop schedule
./tools/maintenance/schedule-cleanup.sh stop

# Start schedule
./tools/maintenance/schedule-cleanup.sh start

# Uninstall schedule
./tools/maintenance/schedule-cleanup.sh uninstall
```

## 📊 Reports Location

```
~/Developer/reports/cleanup/
├── cleanup-report-20251211-084206.txt
├── cleanup-report-20251218-020000.txt
└── cleanup-report-20251225-020000.txt
```

## 📝 Logs Location

```
~/Developer/logs/cleanup/
├── cleanup-20251211.log
├── cleanup-20251218.log
└── cleanup-error-20251211.log (if errors occur)
```

## 🔧 Customization

### Change Schedule

```bash
# Run every 3 days at 3 AM in standard mode
./tools/maintenance/schedule-cleanup.sh install 3 3 standard

# Weekly at midnight in deep mode
./tools/maintenance/schedule-cleanup.sh install 7 0 deep
```

### Manual Cleanup

```bash
# Run cleanup manually anytime
./tools/maintenance/cleanup-workflow.sh safe
./tools/maintenance/cleanup-workflow.sh quick
./tools/maintenance/cleanup-workflow.sh standard
./tools/maintenance/cleanup-workflow.sh deep
```

## 📈 What Gets Cleaned

### Every Run (Safe Mode)

- ✓ macOS system files (.DS*Store, .*\*)
- ✓ Temporary files (.tmp, .log, .bak, .swp)
- ✓ Python cache (**pycache**, .pyc, .pyo)
- ✓ Empty directories (protected: .git, node_modules)
- ✓ Old archive duplicates (keeps newest)
- ✓ Safety backups older than 7 days

### Never Cleaned

- 🔒 node_modules (analysis only)
- 🔒 .git directories
- 🔒 .venv directories
- 🔒 Active project files
- 🔒 Unique archive files

## 🔔 Getting Notified

### Email Reports (Future Enhancement)

```bash
# Add email to plist configuration
# Edit: ~/Library/LaunchAgents/com.developer.cleanup.plist
# Add notification service
```

### Desktop Notifications

```bash
# macOS notifications automatically sent on completion
# Check System Preferences > Notifications > Script Editor
```

## 🛠️ Troubleshooting

### Schedule Not Running

```bash
# Check if loaded
launchctl list | grep com.developer.cleanup

# Reload schedule
./tools/maintenance/schedule-cleanup.sh stop
./tools/maintenance/schedule-cleanup.sh start
```

### View Errors

```bash
# Check error logs
ls ~/Developer/logs/cleanup/cleanup-error-*.log
cat ~/Developer/logs/cleanup/cleanup-error-$(date +%Y%m%d).log
```

### Manual Test

```bash
# Run cleanup manually to test
./tools/maintenance/cleanup-workflow.sh safe --dry-run
```

## 📅 Next Run

Check next scheduled run:

```bash
./tools/maintenance/schedule-cleanup.sh status
```

Expected: **Every Sunday at 2:00 AM**

## 🔗 Related Tools

- **Main cleanup:** [cleanup-workflow.sh](cleanup-workflow.sh)
- **Full guide:** [CLEANUP-GUIDE.md](CLEANUP-GUIDE.md)
- **Scheduler:** [schedule-cleanup.sh](schedule-cleanup.sh)

## 💡 Best Practices

1. **Check reports weekly** - Review what's being cleaned
2. **Run test before changes** - Use dry-run mode
3. **Keep logs** - Don't delete, they're small
4. **Monitor space** - Track trends in reports
5. **Adjust schedule** - Change frequency as needed

---

**Last Updated:** December 11, 2025  
**Version:** 1.0  
**Status:** ✅ Active and Running
