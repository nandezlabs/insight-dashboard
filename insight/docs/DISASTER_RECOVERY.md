# Disaster Recovery Plan

Critical procedures for recovering from catastrophic failures. Print this document and store offline.

## 🚨 Emergency Response Protocol

### Immediate Actions (Within 5 Minutes)

1. **Assess the Situation**
   - What failed? (VPS, database, network, application)
   - When did it fail? (check timestamps)
   - Is data at risk? (corruption, deletion, encryption)

2. **Stop Making Changes**
   - Don't attempt fixes without assessment
   - Don't restart services until cause is identified
   - Don't delete anything "to free space"

3. **Document Everything**
   - Take screenshots of errors
   - Save log files immediately
   - Note exact time of failure
   - Record any recent changes made

4. **Notify Stakeholders**
   - Update status page or send notification
   - Set realistic expectations for recovery time

### Recovery Priority Matrix

| Priority    | Component            | Max Downtime | Data Loss Tolerance |
| ----------- | -------------------- | ------------ | ------------------- |
| P0 Critical | Database Access      | 30 minutes   | None                |
| P1 High     | Application Frontend | 2 hours      | Last 24 hours       |
| P2 Medium   | File Uploads         | 4 hours      | Last week           |
| P3 Low      | Analytics/Reports    | 24 hours     | Last month          |

## 📋 Recovery Procedures by Scenario

### Scenario 1: Complete VPS Failure

**Detection**: Cannot SSH, VPS unreachable, Hostinger shows "down"

**Recovery Time**: 2-4 hours  
**Data Loss**: None (data stored in Supabase)

**Steps**:

```bash
# 1. Provision New VPS (30 minutes)
# - Login to Hostinger panel
# - Order new KVM Basic (2GB RAM)
# - Choose Ubuntu 22.04 LTS
# - Note new IP address

# 2. Update DNS (if using domain)
# - Update A record to new VPS IP
# - Note: DNS propagation takes 10-60 minutes

# 3. Setup New VPS (60 minutes)
ssh root@new-vps-ip

# Update system
apt update && apt upgrade -y

# Create user
adduser insight
usermod -aG sudo insight
mkdir /home/insight/.ssh
# Copy SSH keys from your local machine
cat ~/.ssh/id_rsa.pub | ssh insight@new-vps-ip "cat >> ~/.ssh/authorized_keys"

# Install dependencies
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt install -y nodejs python3.11 python3.11-venv python3-pip nginx certbot python3-certbot-nginx sqlite3 git ufw

# 4. Deploy Application (60 minutes)
su - insight
git clone https://github.com/yourusername/insight.git
cd insight

# Restore .env files from encrypted backup
# (You have this stored securely, right?)
gpg -d /path/to/config_backup.tar.gz.gpg | tar -xzf -

# Setup frontend
cd frontend
npm install
npm run build

# Setup backend
cd ../backend
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 5. Configure Nginx
sudo cp /home/insight/insight/scripts/nginx.conf /etc/nginx/sites-available/insight
sudo ln -s /etc/nginx/sites-available/insight /etc/nginx/sites-enabled/
sudo htpasswd -c /etc/nginx/.htpasswd admin  # Set password
sudo nginx -t
sudo systemctl reload nginx

# 6. Setup SSL
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# 7. Create systemd services
sudo cp /home/insight/insight/scripts/insight-frontend.service /etc/systemd/system/
sudo cp /home/insight/insight/scripts/insight-backend.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable insight-frontend insight-backend
sudo systemctl start insight-frontend insight-backend

# 8. Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

# 9. Verify deployment
curl https://your-domain.com/api/health
# Check frontend loads in browser
```

**Verification Checklist**:

- [ ] Frontend loads at https://your-domain.com
- [ ] Basic auth works
- [ ] Backend API responds at /api/python/health
- [ ] Forms load correctly
- [ ] Submissions save to Supabase
- [ ] Files upload successfully
- [ ] Check systemd logs for errors

**Post-Recovery**:

- Document what caused VPS failure
- Review Hostinger support ticket
- Consider upgrading VPS plan if resource-related

---

### Scenario 2: Database Corruption

**Detection**: SQL errors in logs, missing data, query timeouts, Supabase dashboard shows issues

**Recovery Time**: 15-30 minutes  
**Data Loss**: Up to 24 hours (depending on backup age)

**Steps**:

```bash
# 1. Stop application to prevent further corruption
sudo systemctl stop insight-frontend
sudo systemctl stop insight-backend

# 2. Access Supabase Dashboard
# Go to https://supabase.com/dashboard
# Navigate to your project

# 3. Option A: Restore from Supabase Automatic Backup (if within 7 days)
# - Go to Database → Backups
# - Select backup point from before corruption
# - Click "Restore" and confirm
# - Wait 2-5 minutes for restore to complete

# 4. Option B: Restore from Manual Backup (if older than 7 days)
cd /home/insight/backups

# Find latest good backup
ls -lth insight_db_*.sql.gz | head -5

# Extract backup
gunzip insight_db_20260514_020000.sql.gz

# Get Supabase connection details from .env
cat /home/insight/insight/.env | grep SUPABASE

# Restore to Supabase
PGPASSWORD='your-db-password' psql \
  -h db.xyzcompany.supabase.co \
  -U postgres \
  -p 5432 \
  -d postgres \
  -f insight_db_20260514_020000.sql

# 5. Verify data integrity
psql -h db.xyzcompany.supabase.co -U postgres -d postgres << EOF
-- Check critical tables
SELECT 'form_templates', COUNT(*) FROM form_templates;
SELECT 'submissions', COUNT(*) FROM submissions;
SELECT 'form_drafts', COUNT(*) FROM form_drafts;
SELECT 'files', COUNT(*) FROM files;
EOF

# 6. Restart application
sudo systemctl start insight-frontend
sudo systemctl start insight-backend

# 7. Test functionality
# - Load frontend
# - View existing forms
# - Submit test form
# - Check new submission in database
```

**Verification Checklist**:

- [ ] Row counts match expected values
- [ ] Recent forms are visible
- [ ] Can create new submissions
- [ ] No SQL errors in logs
- [ ] Files are accessible

**Post-Recovery**:

- Identify what caused corruption (disk full, bad query, etc.)
- Review recent code changes
- Consider upgrading Supabase to Pro for point-in-time recovery

---

### Scenario 3: Supabase Account Locked/Deleted

**Detection**: Cannot login to Supabase, project missing, authentication errors

**Recovery Time**: 4-8 hours  
**Data Loss**: Depends on backup age (none if you have recent pg_dump)

**Steps**:

```bash
# 1. Contact Supabase Support Immediately
# - Email: support@supabase.com
# - Explain situation
# - Provide project ID, account email
# - Request project recovery

# 2. While Waiting for Support Response, Create New Supabase Project
# Go to https://supabase.com/dashboard
# Create new project: "Insight-Recovery"
# Note new credentials

# 3. Restore Database from Manual Backup
cd /home/insight/backups
gunzip insight_db_latest.sql.gz

# Import to new Supabase project
PGPASSWORD='new-db-password' psql \
  -h db.newproject.supabase.co \
  -U postgres \
  -p 5432 \
  -d postgres \
  -f insight_db_latest.sql

# 4. Restore Files from Backup
cd /home/insight/backups/files
python3 << EOF
import os
from supabase import create_client

# New project credentials
SUPABASE_URL = "https://newproject.supabase.co"
SUPABASE_KEY = "new-service-role-key"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Upload all files
for root, dirs, files in os.walk('.'):
    for file in files:
        filepath = os.path.join(root, file)
        with open(filepath, 'rb') as f:
            supabase.storage.from_('uploads').upload(filepath, f)
        print(f"Restored: {filepath}")
EOF

# 5. Update Application Configuration
cd /home/insight/insight

# Update .env files with new Supabase credentials
nano .env
nano frontend/.env.production
nano backend/.env

# Update:
# - NEXT_PUBLIC_SUPABASE_URL
# - NEXT_PUBLIC_SUPABASE_ANON_KEY
# - SUPABASE_SERVICE_ROLE_KEY

# 6. Rebuild and restart
cd frontend
npm run build
cd ../backend
sudo systemctl restart insight-frontend
sudo systemctl restart insight-backend

# 7. Verify everything works
curl https://your-domain.com/api/health
```

**Verification Checklist**:

- [ ] All forms restored
- [ ] Submissions count matches backup
- [ ] Files are accessible
- [ ] New submissions save correctly
- [ ] Analytics data present

---

### Scenario 4: Accidental Mass Deletion

**Detection**: User reports missing forms/data, Supabase logs show DELETE queries

**Recovery Time**: 30-60 minutes  
**Data Loss**: None (if caught within 7 days)

**Steps**:

```bash
# 1. Identify What Was Deleted and When
# Check Supabase Dashboard → Logs
# Look for DELETE queries with timestamp

# 2. Stop Application (prevent further deletions)
sudo systemctl stop insight-frontend
sudo systemctl stop insight-backend

# 3. Option A: Point-in-Time Restore (Pro plan only)
# Supabase Dashboard → Database → Point-in-time recovery
# Select timestamp just before deletion
# Restore

# 4. Option B: Restore Specific Table from Backup (Free plan)
cd /home/insight/backups

# Create temporary database locally
createdb temp_restore

# Restore full backup to temp database
gunzip -c insight_db_20260514_020000.sql.gz | psql -d temp_restore

# Export deleted table
pg_dump temp_restore -t form_templates > form_templates_restore.sql

# Restore to production
PGPASSWORD='your-db-password' psql \
  -h db.xyzcompany.supabase.co \
  -U postgres \
  -d postgres \
  << EOF
-- First, backup current state (in case restore goes wrong)
CREATE TABLE form_templates_backup AS SELECT * FROM form_templates;

-- Delete current data
TRUNCATE form_templates CASCADE;

-- Restore from backup file
\i form_templates_restore.sql

-- Verify
SELECT COUNT(*) FROM form_templates;
EOF

# Clean up temp database
dropdb temp_restore

# 5. Restart application
sudo systemctl start insight-frontend
sudo systemctl start insight-backend
```

**Verification Checklist**:

- [ ] Deleted data is restored
- [ ] New data created after backup is NOT lost (merge if needed)
- [ ] Application functions normally
- [ ] No foreign key constraint errors

---

### Scenario 5: Ransomware/Security Breach

**Detection**: Encrypted files, unauthorized access, strange network activity, extortion message

**Recovery Time**: 8-12 hours  
**Data Loss**: None (data not stored on VPS)

**CRITICAL: Do NOT pay ransom!**

**Steps**:

```bash
# 1. Immediate Containment
# - Disconnect VPS from network (Hostinger panel → Stop VPS)
# - DO NOT SHUT DOWN (preserve memory for forensics)
# - Take VPS snapshot if possible

# 2. Document Evidence
# - Screenshot ransom message
# - Note affected files/directories
# - Check Supabase logs for unauthorized queries
# - Review Nginx access logs for suspicious IPs

# 3. Assess Data Integrity
# - Check if Supabase was accessed (Dashboard → Logs)
# - Verify data in Supabase is intact
# - Check if attackers had access to .env files

# 4. Provision New Clean VPS
# Follow "Scenario 1: Complete VPS Failure" procedure
# Use NEW SSH keys
# Use NEW basic auth password

# 5. Rotate ALL Credentials
# Supabase:
# - Go to Settings → API → Regenerate keys
# - Update RLS policies to be more restrictive

# GitHub:
# - Rotate deploy keys
# - Review commit history for backdoors
# - Scan repository for secrets

# Email:
# - Change Gmail App Password
# - Or rotate SendGrid API key

# Sentry:
# - Rotate auth token

# SSH:
# - Generate new SSH key pair
# - Update GitHub, VPS authorized_keys

# Basic Auth:
# - Change Nginx htpasswd password

# 6. Security Audit
# Review code for vulnerabilities:
# - SQL injection points
# - File upload validation
# - Authentication bypasses

# Check for backdoors:
grep -r "eval\|exec\|system\|shell_exec" /home/insight/insight/
find /home/insight/insight/ -name "*.php" -o -name "*.sh"  # Should be none

# 7. Deploy Fresh Code from GitHub
# Verify commit history is clean
git log --all --oneline | head -20

# Deploy to new VPS
# Update all credentials in .env files

# 8. Enable Additional Security
# Add fail2ban
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# Add monitoring
apt install -y logwatch
# Configure daily security reports

# Restrict SSH
nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
# Set: PermitRootLogin no
# Set: AllowUsers insight
systemctl restart sshd

# 9. Report Incident
# - File report with Hostinger
# - Document in security log
# - Review incident response plan
```

**Post-Recovery Checklist**:

- [ ] All credentials rotated
- [ ] New VPS with hardened security
- [ ] No backdoors in code
- [ ] Monitoring alerts configured
- [ ] Incident documented
- [ ] Prevention measures implemented

---

## 🔐 Credential Recovery

### Lost .env File

If you lose your `.env` file but still have access to Supabase:

1. **Supabase Credentials**: Copy from Supabase Dashboard → Settings → API
2. **Email Credentials**: Regenerate Gmail App Password or SendGrid API key
3. **Sentry DSN**: Copy from Sentry project settings
4. **Basic Auth**: Reset with `sudo htpasswd -c /etc/nginx/.htpasswd admin`

### Lost SSH Access

If you lose SSH key and can't access VPS:

1. Login to Hostinger panel
2. Use "VPS Console" (browser-based terminal)
3. Reset password for `insight` user
4. Add new SSH key to `~/.ssh/authorized_keys`

### Lost Supabase Password

If you lose Supabase database password:

1. Go to Supabase Dashboard → Settings → Database
2. Click "Reset database password"
3. Update in all `.env` files
4. Restart application services

## 📞 Emergency Contacts

### Service Providers

- **Hostinger Support**: https://www.hostinger.com/support (24/7 live chat)
- **Supabase Support**: support@supabase.com (email), https://supabase.com/support
- **GitHub Support**: https://support.github.com
- **Sentry Support**: https://sentry.io/support

### External Resources

- **DigitalOcean Community**: https://www.digitalocean.com/community (troubleshooting guides)
- **Stack Overflow**: https://stackoverflow.com/questions/tagged/supabase
- **Supabase Discord**: https://discord.supabase.com (community support)

## 📊 Recovery Metrics

Track these metrics after each incident:

- **Detection Time**: How long until we noticed the issue
- **Response Time**: How long until we started recovery
- **Recovery Time**: Total downtime
- **Data Loss**: Amount of data lost (time range)
- **Root Cause**: What caused the failure
- **Prevention**: What we'll do to prevent recurrence

Document in: `/home/insight/logs/incidents.log`

## 🧪 Disaster Recovery Testing

### Quarterly DR Drill Schedule

**Q2 2026**: Test VPS failure recovery (Scenario 1)  
**Q3 2026**: Test database restore (Scenario 2)  
**Q4 2026**: Test credential rotation (Scenario 5)  
**Q1 2027**: Full disaster recovery drill (all scenarios)

### Testing Checklist

- [ ] Create test plan document
- [ ] Schedule 2-hour testing window
- [ ] Notify users of planned maintenance
- [ ] Execute recovery procedure on staging
- [ ] Document time taken for each step
- [ ] Note any issues or improvements needed
- [ ] Update this document with lessons learned
- [ ] Store test results in `/home/insight/logs/dr_tests/`

---

## 📝 Recovery Log Template

```
INCIDENT REPORT
================
Date: YYYY-MM-DD
Time: HH:MM UTC
Severity: [P0-Critical / P1-High / P2-Medium / P3-Low]

SUMMARY
-------
[Brief description of what happened]

DETECTION
---------
Detected by: [Monitoring alert / User report / Manual check]
Detected at: HH:MM UTC
Detection time: [How long after incident started]

IMPACT
------
Services affected: [Frontend / Backend / Database / Files]
Users affected: [Number or "All"]
Downtime duration: [HH:MM]
Data lost: [Yes/No, time range]

ROOT CAUSE
----------
[What caused the failure]

RECOVERY STEPS
--------------
1. [First step taken]
2. [Second step taken]
...

RESOLUTION TIME
---------------
Started: HH:MM UTC
Ended: HH:MM UTC
Total: HH:MM

VERIFICATION
------------
[How we verified the system was fully recovered]

PREVENTION
----------
[What we'll do to prevent this in the future]

LESSONS LEARNED
---------------
[What went well]
[What could be improved]
[Action items]
```

---

**Last Updated**: May 2026  
**Next Review**: August 2026  
**Owner**: Insight Administrator

**Print this document and store it in a safe, accessible location!**
