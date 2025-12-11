# Hostinger Deployment Guide

Complete guide for deploying web projects to Hostinger hosting.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Project Types](#project-types)
- [Deployment Workflow](#deployment-workflow)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This deployment workflow supports:

- ✅ Static HTML/CSS/JS sites
- ✅ React applications (Vite, CRA)
- ✅ Next.js static exports
- ✅ PHP projects
- ✅ Any build tool that outputs static files

**Deployment Method**: SFTP (Secure File Transfer Protocol)

- Works with all Hostinger plans (Basic, Premium, Business)
- Secure encrypted transfer
- Automated with `lftp` command-line tool

## 📦 Prerequisites

### 1. Hostinger Account Setup

1. **Get FTP Credentials**:

   - Login to [Hostinger Panel](https://hpanel.hostinger.com/)
   - Go to: **Hosting** → Your domain → **Manage**
   - Navigate to: **Files** → **FTP Accounts**
   - Note your:
     - FTP Hostname (e.g., `ftp.yourdomain.com`)
     - Username (format: `u123456789`)
     - Password

2. **Know Your Directories**:
   - **Main domain**: `public_html`
   - **Subdomain**: `public_html/subdomain_name`
   - **Addon domain**: `public_html/addondomain.com`

### 2. Local Machine Setup

```bash
# Install lftp (SFTP client)
brew install lftp

# Navigate to your project
cd ~/Developer/projects/your-project
```

## 🚀 Quick Start

### Step 1: Initialize Configuration

```bash
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --init
```

This creates `.hostinger-config` in your project directory.

### Step 2: Edit Configuration

Edit `.hostinger-config` with your Hostinger credentials:

```bash
# SFTP Hostname
HOSTINGER_HOST="ftp.yourdomain.com"

# FTP Username
HOSTINGER_USER="u123456789"

# FTP Password
HOSTINGER_PASSWORD="your_secure_password"

# Remote directory
REMOTE_DIR="public_html"

# Local build directory
LOCAL_BUILD_DIR="dist"

# Project type: static, react, nextjs, php
PROJECT_TYPE="react"

# Create backup before deploy
CREATE_BACKUP="yes"
```

### Step 3: Deploy

```bash
# Build and deploy
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --build

# Or deploy existing build
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh
```

## ⚙️ Configuration

### Configuration File: `.hostinger-config`

| Variable             | Description                  | Example                            |
| -------------------- | ---------------------------- | ---------------------------------- |
| `HOSTINGER_HOST`     | SFTP hostname from Hostinger | `ftp.mysite.com`                   |
| `HOSTINGER_USER`     | FTP username                 | `u987654321`                       |
| `HOSTINGER_PASSWORD` | FTP password                 | `SecurePass123!`                   |
| `REMOTE_DIR`         | Target directory on server   | `public_html`                      |
| `LOCAL_BUILD_DIR`    | Local build output directory | `dist` or `build`                  |
| `PROJECT_TYPE`       | Project type for auto-build  | `react`, `nextjs`, `static`, `php` |
| `EXCLUDE_FILES`      | Files to skip                | `.git node_modules .env`           |
| `CREATE_BACKUP`      | Backup before deploy         | `yes` or `no`                      |

### Security Note

⚠️ **Never commit `.hostinger-config` to Git!**

Add to your `.gitignore`:

```bash
# Hostinger credentials
.hostinger-config
```

## 📁 Project Types

### 1. Static HTML/CSS/JS

```bash
# .hostinger-config
PROJECT_TYPE="static"
LOCAL_BUILD_DIR="."  # Deploy entire directory
REMOTE_DIR="public_html"
```

No build step needed. Deploys files as-is.

### 2. React (Vite or Create React App)

```bash
# .hostinger-config
PROJECT_TYPE="react"
LOCAL_BUILD_DIR="dist"  # or "build" for CRA
REMOTE_DIR="public_html"
```

**Deployment:**

```bash
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --build
```

The script automatically runs `npm run build`.

### 3. Next.js (Static Export)

**Important**: Hostinger doesn't support Next.js server-side rendering. Use static export.

**1. Configure Next.js for Static Export**

Edit `next.config.js`:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export", // Enable static export
  images: {
    unoptimized: true, // Required for static export
  },
};

module.exports = nextConfig;
```

**2. Configure Deployment**

```bash
# .hostinger-config
PROJECT_TYPE="nextjs"
LOCAL_BUILD_DIR="out"
REMOTE_DIR="public_html"
```

**3. Deploy**

```bash
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --build
```

### 4. PHP Projects

```bash
# .hostinger-config
PROJECT_TYPE="php"
LOCAL_BUILD_DIR="."
REMOTE_DIR="public_html"
```

No build step. Uploads PHP files directly.

## 🔄 Deployment Workflow

### Full Deployment Process

```bash
# 1. Navigate to project
cd ~/Developer/projects/my-react-app

# 2. Deploy with build
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --build
```

**What happens:**

1. ✅ Checks for `lftp` installation
2. ✅ Loads `.hostinger-config`
3. ✅ Builds project (`npm run build`)
4. ✅ Creates backup of live site
5. ✅ Uploads files via SFTP
6. ✅ Sets correct file permissions
7. ✅ Verifies deployment

### Command Options

```bash
# Initialize config file
bash deploy-to-hostinger.sh --init

# Build and deploy
bash deploy-to-hostinger.sh --build

# Deploy without backup
bash deploy-to-hostinger.sh --no-backup

# Dry run (see what would be uploaded)
bash deploy-to-hostinger.sh --dry-run

# Show help
bash deploy-to-hostinger.sh --help
```

## 🎯 Common Scenarios

### Scenario 1: Main Domain Deployment

Deploying to `https://yourdomain.com`

```bash
REMOTE_DIR="public_html"
```

### Scenario 2: Subdomain Deployment

Deploying to `https://app.yourdomain.com`

**First, create subdomain in Hostinger:**

- Hostinger Panel → Domains → Subdomains → Create

```bash
REMOTE_DIR="public_html/app"
```

### Scenario 3: Project in Subfolder

Deploying to `https://yourdomain.com/portfolio`

```bash
REMOTE_DIR="public_html/portfolio"
```

### Scenario 4: Multiple Projects

Create separate config for each:

```bash
# Project 1: Main site
cp .hostinger-config .hostinger-main
# Edit REMOTE_DIR="public_html"

# Project 2: Blog
cp .hostinger-config .hostinger-blog
# Edit REMOTE_DIR="public_html/blog"

# Deploy specific config
bash deploy-to-hostinger.sh -c .hostinger-blog
```

## 🐛 Troubleshooting

### Issue: "Connection failed"

**Causes:**

- Incorrect hostname/username/password
- Firewall blocking FTP

**Solutions:**

```bash
# Test connection manually
lftp -u "u123456789,password" sftp://ftp.yourdomain.com

# Check Hostinger FTP credentials
# Go to: Hostinger Panel → Files → FTP Accounts
```

### Issue: "Permission denied"

**Cause:** FTP user doesn't have write access

**Solution:**

- Check FTP account has write permissions in Hostinger Panel
- Verify you're uploading to the correct directory

### Issue: "Site shows old content"

**Causes:**

- Browser cache
- CDN cache (if using Cloudflare)

**Solutions:**

```bash
# Clear browser cache
Cmd+Shift+R (macOS) or Ctrl+Shift+R (Windows)

# If using Cloudflare:
# Cloudflare Dashboard → Caching → Purge Everything
```

### Issue: "Next.js routes return 404"

**Cause:** Next.js dynamic routes don't work with static export

**Solution:**
Use only static routes or add `.htaccess`:

```apache
# Create .htaccess in public_html
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>
```

### Issue: "Build files too large"

**Cause:** Hostinger may have upload size limits

**Solution:**

```bash
# Split large files
# Or optimize build:
# - Remove source maps in production
# - Enable code splitting
# - Compress images
```

## 📊 Deployment Checklist

Before deploying:

- [ ] Project builds successfully locally
- [ ] `.hostinger-config` created and configured
- [ ] `.hostinger-config` added to `.gitignore`
- [ ] Backup enabled (especially for first deploy)
- [ ] Correct remote directory set
- [ ] Environment variables configured (if needed)

For Next.js:

- [ ] `output: 'export'` in `next.config.js`
- [ ] No server-side features used (API routes, ISR, SSR)
- [ ] Images set to `unoptimized: true`

For React:

- [ ] Public URL configured if in subdirectory
- [ ] Build output directory correct (`dist` or `build`)

## 🔐 Security Best Practices

1. **Never commit credentials**

   ```bash
   echo ".hostinger-config" >> .gitignore
   ```

2. **Use strong FTP passwords**

   - Generate in Hostinger Panel
   - Change regularly

3. **Enable SSL/HTTPS**

   - Free SSL available in Hostinger
   - Hosting → Manage → SSL → Install

4. **Keep backups**
   - Script creates automatic backups
   - Store locally: `backups/hostinger-YYYYMMDD-HHMMSS/`

## 🎓 Examples

### Example 1: React Vite App

```bash
# 1. Build locally first
cd ~/Developer/projects/my-vite-app
npm run build

# 2. Initialize deployment
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --init

# 3. Edit .hostinger-config
HOSTINGER_HOST="ftp.mywebsite.com"
HOSTINGER_USER="u123456789"
HOSTINGER_PASSWORD="mypass123"
REMOTE_DIR="public_html"
LOCAL_BUILD_DIR="dist"
PROJECT_TYPE="react"

# 4. Deploy
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --build
```

### Example 2: Next.js Static Site

```bash
# 1. Configure Next.js
# Edit next.config.js:
# output: 'export'

# 2. Initialize
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --init

# 3. Edit .hostinger-config
HOSTINGER_HOST="ftp.myblog.com"
REMOTE_DIR="public_html"
LOCAL_BUILD_DIR="out"
PROJECT_TYPE="nextjs"

# 4. Deploy
bash ~/Developer/tools/deployment/deploy-to-hostinger.sh --build
```

## 📚 Additional Resources

- [Hostinger Knowledge Base](https://support.hostinger.com/)
- [Hostinger FTP Guide](https://www.hostinger.com/tutorials/how-to-use-ftp)
- [lftp Documentation](https://lftp.yar.ru/)

## 🆘 Support

If you encounter issues:

1. Check this guide's Troubleshooting section
2. Verify credentials in Hostinger Panel
3. Test FTP connection manually with `lftp`
4. Contact Hostinger Support (24/7 chat available)

---

**Created**: December 11, 2025
**Last Updated**: December 11, 2025
