# Insight Dashboard - Setup Guide

Complete guide for setting up the Insight Dashboard from development to production deployment.

## 📋 Prerequisites

### Local Development

- **Node.js**: 20.x or higher
- **Python**: 3.11 or higher
- **Git**: Latest version
- **Code Editor**: VS Code recommended

### Production VPS (Hostinger)

- **RAM**: 2GB minimum
- **CPU**: 1-2 cores
- **Storage**: 200MB minimum for app + cache
- **OS**: Ubuntu 22.04 LTS (recommended)

### Third-Party Services

- **Supabase Account**: Free tier (500MB database + 1GB storage)
- **GitHub Account**: For code hosting and CI/CD
- **Sentry Account**: Free tier (5k errors/month) - optional but recommended
- **Email Service**: Gmail with App Password OR SendGrid free tier

## 🚀 Part 1: Local Development Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/yourusername/insight.git
cd insight
```

### Step 2: Setup Supabase Project

1. **Create Supabase Project**:
   - Go to https://supabase.com/dashboard
   - Click "New Project"
   - Name: `Insight` (or your preferred name)
   - Choose region closest to your VPS location
   - Generate strong database password
   - Wait for project to initialize (~2 minutes)

2. **Get API Credentials**:
   - Navigate to Settings → API
   - Copy and save:
     - `Project URL`: `https://xxx.supabase.co`
     - `anon public`: Your anon key
     - `service_role`: Your service role key (**keep secret!**)

3. **Create Database Schema**:
   - Navigate to SQL Editor
   - Copy and run the schema from `backend/database/schema.sql` (we'll create this file)
   - Verify tables created in Database → Tables

4. **Setup Storage Bucket**:
   - Navigate to Storage
   - Create new bucket: `uploads`
   - Make it **public** (for file downloads)
   - Create folders: `uploads/2026/05/` (year/month structure)

5. **Configure Row Level Security**:
   - Navigate to Authentication → Policies
   - For now, create permissive policies (we'll restrict later):
     ```sql
     -- Allow all operations for development
     CREATE POLICY "Allow all" ON form_templates FOR ALL USING (true);
     CREATE POLICY "Allow all" ON submissions FOR ALL USING (true);
     CREATE POLICY "Allow all" ON form_drafts FOR ALL USING (true);
     -- Repeat for all tables
     ```

### Step 3: Frontend Setup (Next.js)

```bash
cd frontend

# Install dependencies
npm install

# Copy environment file
cp ../.env.example .env.local

# Edit .env.local with your credentials
nano .env.local

# Run development server
npm run dev
```

Frontend will be available at http://localhost:3000

### Step 4: Backend Setup (Python FastAPI)

```bash
cd backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Copy environment file (if not shared with frontend)
cp ../.env.example .env

# Edit .env with your credentials
nano .env

# Run development server
uvicorn main:app --reload --port 8000
```

Backend API will be available at http://localhost:8000
API docs at http://localhost:8000/docs

### Step 5: Verify Setup

1. **Test Supabase Connection**:

   ```bash
   # In backend directory
   python scripts/test_connection.py
   ```

2. **Test Frontend-Backend Communication**:
   - Open http://localhost:3000
   - Check browser console for errors
   - Verify API calls work in Network tab

3. **Create Test Form**:
   - Navigate to Forms page
   - Create simple test form
   - Submit test data
   - Verify in Supabase dashboard: Database → Tables → submissions

## 🏗️ Part 2: VPS Production Setup

### Step 1: Provision VPS

1. **Order Hostinger VPS**:
   - Go to Hostinger VPS hosting
   - Select **KVM Basic** plan (2GB RAM, 1 CPU)
   - Choose Ubuntu 22.04 LTS
   - Complete purchase and note credentials

2. **Initial SSH Connection**:

   ```bash
   ssh root@your-vps-ip
   ```

3. **Update System**:
   ```bash
   apt update && apt upgrade -y
   ```

### Step 2: Create Non-Root User

```bash
# Create user
adduser insight
usermod -aG sudo insight

# Setup SSH for new user
mkdir /home/insight/.ssh
cp ~/.ssh/authorized_keys /home/insight/.ssh/
chown -R insight:insight /home/insight/.ssh
chmod 700 /home/insight/.ssh
chmod 600 /home/insight/.ssh/authorized_keys

# Test login from your local machine
ssh insight@your-vps-ip

# Disable root login (optional but recommended)
nano /etc/ssh/sshd_config
# Set: PermitRootLogin no
systemctl restart sshd
```

### Step 3: Install Dependencies

```bash
# Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Python 3.11
sudo apt install -y python3.11 python3.11-venv python3-pip

# Nginx
sudo apt install -y nginx

# Certbot for SSL
sudo apt install -y certbot python3-certbot-nginx

# SQLite3 (for optional cache)
sudo apt install -y sqlite3

# Git
sudo apt install -y git

# Verify installations
node --version  # Should show v20.x
python3.11 --version
nginx -v
certbot --version
```

### Step 4: Clone and Setup Application

```bash
# Clone repository
cd /home/insight
git clone https://github.com/yourusername/insight.git
cd insight

# Setup frontend
cd frontend
npm install
cp ../.env.example .env.production
nano .env.production  # Add production credentials
npm run build

# Setup backend
cd ../backend
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp ../.env.example .env
nano .env  # Add production credentials
```

### Step 5: Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/insight
```

Add this configuration:

```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}

# HTTPS configuration
server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;

    # SSL certificates (will be added by Certbot)
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Basic Authentication
    auth_basic "Insight Dashboard";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API
    location /api/python/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check (no auth required)
    location /api/health {
        auth_basic off;
        proxy_pass http://localhost:3000;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

Enable site and test:

```bash
sudo ln -s /etc/nginx/sites-available/insight /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 6: Setup SSL with Let's Encrypt

```bash
# Before running Certbot, make sure your domain points to VPS IP

sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Test auto-renewal
sudo certbot renew --dry-run
```

### Step 7: Setup Basic Authentication

```bash
# Install htpasswd tool
sudo apt install -y apache2-utils

# Create password file (replace 'admin' with your desired username)
sudo htpasswd -c /etc/nginx/.htpasswd admin
# Enter password when prompted

# Test Nginx configuration
sudo nginx -t
sudo systemctl reload nginx
```

### Step 8: Create Systemd Services

**Frontend Service** (`/etc/systemd/system/insight-frontend.service`):

```bash
sudo nano /etc/systemd/system/insight-frontend.service
```

```ini
[Unit]
Description=Insight Dashboard Frontend (Next.js)
After=network.target

[Service]
Type=simple
User=insight
WorkingDirectory=/home/insight/insight/frontend
Environment="NODE_ENV=production"
Environment="PORT=3000"
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Backend Service** (`/etc/systemd/system/insight-backend.service`):

```bash
sudo nano /etc/systemd/system/insight-backend.service
```

```ini
[Unit]
Description=Insight Dashboard Backend (FastAPI)
After=network.target

[Service]
Type=simple
User=insight
WorkingDirectory=/home/insight/insight/backend
Environment="PYTHON_ENV=production"
ExecStart=/home/insight/insight/backend/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start services:

```bash
sudo systemctl daemon-reload
sudo systemctl enable insight-frontend
sudo systemctl enable insight-backend
sudo systemctl start insight-frontend
sudo systemctl start insight-backend

# Check status
sudo systemctl status insight-frontend
sudo systemctl status insight-backend

# View logs
sudo journalctl -u insight-frontend -f
sudo journalctl -u insight-backend -f
```

### Step 9: Configure Firewall

```bash
# Install UFW
sudo apt install -y ufw

# Configure rules
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

### Step 10: Verify Production Deployment

1. **Test HTTPS**: Visit https://your-domain.com (should show basic auth prompt)
2. **Test Authentication**: Enter credentials, should see dashboard
3. **Test Backend**: Check https://your-domain.com/api/python/health
4. **Test Forms**: Create and submit test form
5. **Check Logs**: Monitor systemd logs for errors

## 🔄 Part 3: CI/CD Setup (GitHub Actions)

### Step 1: Create GitHub Repository

```bash
# On your local machine
cd /path/to/insight
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/yourusername/insight.git
git push -u origin main

# Create branches
git checkout -b staging
git push -u origin staging
git checkout -b develop
git push -u origin develop
```

### Step 2: Add GitHub Secrets

Go to GitHub Repository → Settings → Secrets and variables → Actions

Add these secrets:

- `VPS_HOST`: Your VPS IP or domain
- `VPS_USER`: `insight`
- `VPS_SSH_KEY`: Your private SSH key (content of ~/.ssh/id_rsa)
- `SUPABASE_URL`: Your Supabase URL
- `SUPABASE_ANON_KEY`: Your anon key
- `SUPABASE_SERVICE_ROLE_KEY`: Your service role key
- `SENTRY_AUTH_TOKEN`: Your Sentry auth token (if using)

### Step 3: Test Deployment

```bash
# On your local machine
git checkout develop
# Make some changes
git add .
git commit -m "Test change"
git push origin develop

# Merge to staging
git checkout staging
git merge develop
git push origin staging

# GitHub Actions will automatically deploy to staging

# After testing staging, merge to main
git checkout main
git merge staging
git push origin main
# Manual approval required for production deployment
```

## 🔧 Part 4: Maintenance

### Daily Operations

**View Application Logs**:

```bash
# Frontend logs
sudo journalctl -u insight-frontend -n 100 --no-pager

# Backend logs
sudo journalctl -u insight-backend -n 100 --no-pager

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

**Restart Services**:

```bash
sudo systemctl restart insight-frontend
sudo systemctl restart insight-backend
sudo systemctl restart nginx
```

**Update Application**:

```bash
cd /home/insight/insight
git pull origin main

# Update frontend
cd frontend
npm install
npm run build
sudo systemctl restart insight-frontend

# Update backend
cd ../backend
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart insight-backend
```

### Weekly Tasks

1. **Check Disk Usage**:

   ```bash
   df -h
   du -sh /home/insight/insight/*
   ```

2. **Review Error Logs**: Check Sentry dashboard

3. **Backup Database**: See [BACKUP.md](BACKUP.md)

### Monthly Tasks

1. **Update System**:

   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo systemctl restart insight-frontend
   sudo systemctl restart insight-backend
   ```

2. **Check SSL Certificate**:

   ```bash
   sudo certbot certificates
   ```

3. **Review Supabase Usage**: Check database and storage usage in Supabase dashboard

## 🆘 Troubleshooting

### Application Won't Start

```bash
# Check service status
sudo systemctl status insight-frontend
sudo systemctl status insight-backend

# Check logs for errors
sudo journalctl -u insight-frontend -n 50
sudo journalctl -u insight-backend -n 50

# Common fixes
cd /home/insight/insight/frontend
npm run build  # Rebuild if needed
cd /home/insight/insight/backend
source venv/bin/activate
pip install -r requirements.txt  # Reinstall dependencies
```

### Can't Connect to Supabase

1. Check environment variables in `.env` files
2. Verify Supabase project is active (not paused)
3. Test connection: `python scripts/test_connection.py`

### SSL Certificate Issues

```bash
# Renew certificate manually
sudo certbot renew --force-renewal

# Reload Nginx
sudo systemctl reload nginx
```

### Out of Disk Space

```bash
# Check usage
df -h

# Clean old logs
sudo journalctl --vacuum-time=7d

# Clean npm cache
npm cache clean --force

# Clean pip cache
pip cache purge

# Clear SQLite cache (if enabled)
rm /home/insight/insight/backend/cache.db
```

## 📚 Next Steps

1. ✅ Complete this setup guide
2. ✅ Read [ENV.md](ENV.md) for environment configuration
3. ✅ Read [BACKUP.md](BACKUP.md) for backup procedures
4. ✅ Read [DISASTER_RECOVERY.md](DISASTER_RECOVERY.md) for recovery plans
5. ✅ Monitor Sentry for first 48 hours
6. ✅ Test all features in production
7. ✅ Setup weekly database backups

## 🎉 Congratulations!

Your Insight Dashboard is now live in production! 🚀

Access it at: https://your-domain.com
