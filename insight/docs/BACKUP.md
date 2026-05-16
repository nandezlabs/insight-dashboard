# Backup and Restore Procedures

This document outlines backup strategies and restore procedures for the Insight Dashboard.

## 📊 What Gets Backed Up

1. **Database**: All form templates, submissions, drafts, files metadata, analytics, alerts, and logs
2. **Files**: User-uploaded files (attachments from form submissions)
3. **Configuration**: Environment variables and application configuration

## 🔄 Automatic Backups

### Supabase Automatic Backups

Supabase provides automatic daily backups on the free tier:

- **Frequency**: Daily
- **Retention**: 7 days
- **Coverage**: Full database
- **Location**: Supabase infrastructure (managed)
- **No action required**: Automatic

**Access Backups**:

1. Go to Supabase Dashboard → Database → Backups
2. View available backup points
3. Restore from any point within 7 days

### Limitations

- **Free tier**: 7-day retention only
- **Pro tier** ($25/month): 30-day retention + point-in-time recovery
- **Files**: Supabase Storage does not have automatic file versioning on free tier

## 📥 Manual Backup Procedures

### Weekly Database Backup (Recommended)

Create a `pg_dump` backup and store locally or in cloud storage for long-term retention.

**Script** (`scripts/backup.sh`):

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/home/insight/backups"
DATE=$(date +%Y%m%d_%H%M%S)
FILENAME="insight_db_${DATE}.sql"

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Database connection (from .env)
source /home/insight/insight/.env

# Extract credentials from Supabase URL
# Example: postgres://postgres:password@db.xxx.supabase.co:5432/postgres
DB_HOST=$(echo $SUPABASE_URL | sed -n 's/.*@\(.*\):.*/\1/p')
DB_USER="postgres"
DB_NAME="postgres"
DB_PORT="5432"

# Perform backup
PGPASSWORD=$SUPABASE_DB_PASSWORD pg_dump \
  -h $DB_HOST \
  -U $DB_USER \
  -p $DB_PORT \
  -d $DB_NAME \
  --no-owner \
  --no-acl \
  -F plain \
  -f $BACKUP_DIR/$FILENAME

# Compress backup
gzip $BACKUP_DIR/$FILENAME

# Delete backups older than 30 days
find $BACKUP_DIR -name "insight_db_*.sql.gz" -mtime +30 -delete

echo "Backup completed: $BACKUP_DIR/${FILENAME}.gz"

# Optional: Upload to cloud storage (OneDrive, Dropbox, etc.)
# rclone copy $BACKUP_DIR/${FILENAME}.gz onedrive:backups/insight/
```

**Setup Cron Job**:

```bash
# Edit crontab
crontab -e

# Add weekly backup (every Sunday at 2 AM)
0 2 * * 0 /home/insight/insight/scripts/backup.sh >> /home/insight/logs/backup.log 2>&1

# Or daily backup at 2 AM
0 2 * * * /home/insight/insight/scripts/backup.sh >> /home/insight/logs/backup.log 2>&1
```

### Files Backup

Since Supabase Storage doesn't have automatic versioning on free tier, backup important files manually:

**Option 1: Using Supabase CLI**

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Download all files from bucket
supabase storage download uploads/* /home/insight/backups/files/
```

**Option 2: Using Python Script**

```python
# scripts/backup_files.py
import os
from supabase import create_client
from pathlib import Path

SUPABASE_URL = os.getenv("NEXT_PUBLIC_SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")
BACKUP_DIR = "/home/insight/backups/files"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# List all files
files = supabase.storage.from_("uploads").list()

for file in files:
    # Download each file
    data = supabase.storage.from_("uploads").download(file["name"])

    # Save to backup directory
    filepath = Path(BACKUP_DIR) / file["name"]
    filepath.parent.mkdir(parents=True, exist_ok=True)

    with open(filepath, "wb") as f:
        f.write(data)

    print(f"Backed up: {file['name']}")
```

Run monthly:

```bash
# Add to crontab
0 3 1 * * cd /home/insight/insight && venv/bin/python scripts/backup_files.py >> /home/insight/logs/file_backup.log 2>&1
```

### Configuration Backup

**Backup Environment Files**:

```bash
# Create encrypted backup of .env files
tar -czf /home/insight/backups/config_$(date +%Y%m%d).tar.gz \
  /home/insight/insight/.env \
  /home/insight/insight/frontend/.env.production \
  /home/insight/insight/backend/.env

# Encrypt (optional but recommended)
gpg -c /home/insight/backups/config_$(date +%Y%m%d).tar.gz

# Store encrypted file securely (USB drive, password manager, etc.)
```

**Important**: Store encryption password separately!

## 🔄 Restore Procedures

### Restore Database from pg_dump

```bash
# 1. Stop application services
sudo systemctl stop insight-frontend
sudo systemctl stop insight-backend

# 2. Extract backup
cd /home/insight/backups
gunzip insight_db_20260515_020000.sql.gz

# 3. Restore to Supabase
# WARNING: This will overwrite existing data!

PGPASSWORD=$SUPABASE_DB_PASSWORD psql \
  -h $DB_HOST \
  -U postgres \
  -p 5432 \
  -d postgres \
  -f insight_db_20260515_020000.sql

# 4. Verify restoration
psql -h $DB_HOST -U postgres -d postgres -c "SELECT COUNT(*) FROM submissions;"

# 5. Restart services
sudo systemctl start insight-frontend
sudo systemctl start insight-backend
```

### Restore from Supabase Automatic Backup

1. Go to Supabase Dashboard → Database → Backups
2. Find the backup point you want to restore
3. Click "Restore" button
4. Confirm restoration (takes 2-5 minutes)
5. Verify data in application

**Warning**: This will restore the ENTIRE database to that point in time. Any data created after that backup will be lost.

### Restore Specific Table (Partial Restore)

If you only need to restore specific data without full database restore:

```bash
# 1. Create temporary database
createdb temp_restore

# 2. Restore backup to temp database
psql -d temp_restore -f insight_db_20260515_020000.sql

# 3. Export specific table
pg_dump temp_restore -t submissions > submissions_restore.sql

# 4. Restore to production (be careful!)
psql -h $DB_HOST -U postgres -d postgres -f submissions_restore.sql

# 5. Clean up
dropdb temp_restore
```

### Restore Files

```bash
# Restore all files to Supabase Storage
cd /home/insight/backups/files

# Using Supabase CLI
supabase storage upload uploads/* ./

# Or using Python script
python scripts/restore_files.py
```

## 🚨 Disaster Recovery Scenarios

### Scenario 1: Database Corrupted

**Symptoms**: Application errors, missing data, SQL errors in logs

**Recovery Steps**:

1. Identify last known good backup point
2. Stop application services
3. Restore from Supabase automatic backup (if within 7 days)
4. Or restore from manual pg_dump backup
5. Verify data integrity
6. Restart services
7. Monitor for 24 hours

**Estimated Downtime**: 15-30 minutes

### Scenario 2: VPS Destroyed

**Symptoms**: Cannot SSH, VPS unreachable, hardware failure

**Recovery Steps**:

1. Provision new VPS (follow SETUP.md)
2. Clone repository from GitHub
3. Restore environment variables from encrypted backup
4. Database is safe (stored in Supabase, not on VPS)
5. Files are safe (stored in Supabase Storage, not on VPS)
6. Configure Nginx, SSL, systemd services
7. Start application

**Estimated Downtime**: 2-4 hours (mostly VPS setup time)

**Data Loss**: None (if using Supabase)

### Scenario 3: Accidental Data Deletion

**Symptoms**: User accidentally deleted forms, submissions, or files

**Recovery Options**:

**Option A**: Restore from last night's automatic backup (if within 7 days)

- **Pros**: Quick, easy
- **Cons**: Loses data created after backup

**Option B**: Restore specific table from manual backup

- **Pros**: Surgical, only affects deleted data
- **Cons**: More complex, requires SQL knowledge

**Option C**: If caught quickly, restore from SQLite cache (if enabled)

- **Pros**: Most recent data
- **Cons**: Only works if cache hasn't been cleared

### Scenario 4: Supabase Service Outage

**Symptoms**: Cannot connect to database, Supabase status page shows issues

**Recovery Steps**:

1. Check Supabase status: https://status.supabase.com
2. If outage is confirmed:
   - Enable "offline mode" in application (shows cached data)
   - Display maintenance message to user
   - Monitor Supabase status for resolution
3. When service restored:
   - Application automatically reconnects
   - Sync any cached changes

**Estimated Downtime**: Depends on Supabase (historically rare, <1 hour)

**Data Loss**: None (queue writes in cache, sync when available)

### Scenario 5: Malware/Ransomware on VPS

**Symptoms**: Strange files, unauthorized access, encrypted files

**Recovery Steps**:

1. **DO NOT PAY RANSOM**
2. Immediately disconnect VPS from network
3. Report to Hostinger support
4. Provision new clean VPS
5. Database safe (Supabase, not on VPS)
6. Files safe (Supabase Storage, not on VPS)
7. Redeploy from GitHub
8. Rotate all credentials (Supabase keys, SSH keys, passwords)
9. Review security audit logs
10. Implement additional security measures

**Estimated Downtime**: 4-8 hours

**Data Loss**: None (if malware didn't affect Supabase)

## 🔒 Backup Security

### Encryption

Always encrypt backups containing sensitive data:

```bash
# Encrypt with GPG
gpg --symmetric --cipher-algo AES256 backup.sql.gz

# Decrypt when needed
gpg backup.sql.gz.gpg
```

### Storage Locations

**Recommended Multi-Location Strategy**:

1. **On VPS**: `/home/insight/backups/` (30 days, for quick restores)
2. **Cloud Storage**: OneDrive, Dropbox (90 days, off-site)
3. **Local Machine**: External hard drive (1 year, disaster recovery)

Use `rclone` to sync to cloud:

```bash
# Install rclone
curl https://rclone.org/install.sh | sudo bash

# Configure OneDrive
rclone config

# Sync backups
rclone sync /home/insight/backups/ onedrive:backups/insight/ --exclude "*.tmp"
```

### Access Control

- Backup files should only be readable by `insight` user
- Use SSH keys (not passwords) for remote access
- Store encryption keys in password manager (1Password, Bitwarden, etc.)

```bash
# Set correct permissions
chmod 700 /home/insight/backups
chmod 600 /home/insight/backups/*
```

## 📋 Backup Checklist

### Weekly Tasks

- [ ] Verify automatic Supabase backup completed
- [ ] Run manual `pg_dump` backup script
- [ ] Check backup file size (should be consistent)
- [ ] Verify backup uploaded to cloud storage

### Monthly Tasks

- [ ] Test restore procedure (on staging environment)
- [ ] Backup files from Supabase Storage
- [ ] Review backup storage usage
- [ ] Verify all backups are encrypted
- [ ] Update disaster recovery documentation

### Quarterly Tasks

- [ ] Full disaster recovery drill
- [ ] Rotate encryption keys
- [ ] Archive old backups to long-term storage
- [ ] Review and update backup procedures

## 🧪 Testing Backups

**Never trust an untested backup!**

### Monthly Test Restore

```bash
# 1. Create test Supabase project
# Name it "Insight-Backup-Test"

# 2. Restore latest backup to test project
psql -h test-db-host -U postgres -d postgres -f latest_backup.sql

# 3. Verify data
# - Check row counts match production
# - Spot-check recent submissions
# - Verify files can be accessed

# 4. Document test results
echo "Backup test: $(date) - SUCCESS" >> /home/insight/logs/backup_tests.log

# 5. Clean up test project after verification
```

## 📊 Monitoring Backup Health

### Automated Backup Monitoring

Create a script to verify backups are running:

```bash
# scripts/check_backups.sh
#!/bin/bash

BACKUP_DIR="/home/insight/backups"
ALERT_EMAIL="admin@example.com"

# Check if backup was created today
TODAY=$(date +%Y%m%d)
LATEST_BACKUP=$(ls -t $BACKUP_DIR/insight_db_*.sql.gz | head -1)

if [[ $LATEST_BACKUP == *"$TODAY"* ]]; then
    echo "✓ Backup OK: $LATEST_BACKUP"
else
    echo "✗ Backup MISSING for $TODAY" | mail -s "ALERT: Backup Failed" $ALERT_EMAIL
fi

# Check backup file size (should be > 1MB)
SIZE=$(du -m "$LATEST_BACKUP" | cut -f1)
if [ $SIZE -lt 1 ]; then
    echo "✗ Backup too small: ${SIZE}MB" | mail -s "ALERT: Backup Size Issue" $ALERT_EMAIL
fi
```

Run daily:

```bash
# Add to crontab
0 12 * * * /home/insight/insight/scripts/check_backups.sh
```

## 🆘 Emergency Contacts

- **Hostinger Support**: https://www.hostinger.com/support
- **Supabase Support**: https://supabase.com/support
- **GitHub Support**: https://support.github.com

## 📚 Additional Resources

- [Supabase Backup Documentation](https://supabase.com/docs/guides/platform/backups)
- [PostgreSQL Backup & Restore](https://www.postgresql.org/docs/current/backup.html)
- [Disaster Recovery Best Practices](https://www.disaster-recovery-guide.com/)

---

**Last Updated**: May 2026  
**Review Schedule**: Quarterly
