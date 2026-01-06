# Hostinger Setup - Step-by-Step Guide

## Prerequisites Checklist

- [ ] Hostinger VPS account (get at hostinger.com)
- [ ] VPS 2 or higher plan ($5.99/mo minimum)
- [ ] Domain name (can buy from Hostinger or use existing)
- [ ] Domain DNS configured (A record pointing to VPS IP)
- [ ] Git repository accessible (GitHub/GitLab/Bitbucket)

## Step 1: Get Your Hostinger VPS

1. Go to hostinger.com/vps-hosting
2. Choose a plan:
   - **VPS 2** ($5.99/mo) - Good for development/small scale
   - **VPS 4** ($11.99/mo) - Recommended for production
3. Select **Ubuntu 22.04 LTS** as operating system
4. Complete purchase and wait for VPS provisioning (5-10 minutes)
5. Note your VPS IP address from control panel

## Step 2: Configure DNS

1. Log into Hostinger control panel
2. Go to **Domains** → Your domain → **DNS/Nameservers**
3. Add these records:
   ```
   Type: A
   Name: @
   Points to: YOUR_VPS_IP
   TTL: 3600

   Type: A  
   Name: www
   Points to: YOUR_VPS_IP
   TTL: 3600
   ```
4. Wait 10-30 minutes for DNS propagation (can take up to 24 hours)

## Step 3: Prepare Local Environment

Generate secure credentials:

```bash
# Generate SECRET_KEY (copy this)
openssl rand -hex 32

# Generate database password (copy this)
openssl rand -base64 32
```

**Save these values!** You'll need them in Step 5.

## Step 4: SSH into Your VPS

```bash
# From your Mac terminal
ssh root@YOUR_VPS_IP

# If prompted about fingerprint, type: yes
# Enter the password from Hostinger email
```

## Step 5: Run Initial Setup on VPS

Copy and paste these commands **on your VPS**:

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt install -y docker-compose-plugin

# Configure firewall
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Install git (if not installed)
apt install -y git

# Verify installations
docker --version
docker compose version
```

## Step 6: Clone and Configure

**On your VPS**, continue with:

```bash
# Create app directory
mkdir -p /opt/insight
cd /opt/insight

# Clone your repository (replace with your actual repo URL)
git clone https://github.com/YOURUSERNAME/insight.git .

# Navigate to backend
cd backend

# Create production environment file
cp .env.production .env

# Edit the environment file
nano .env
```

**In the nano editor**:
1. Replace `CHANGE_THIS_PASSWORD` with your database password (from Step 3)
2. Replace `CHANGE_THIS_TO_A_SECURE_64_CHARACTER_HEX_STRING` with SECRET_KEY (from Step 3)
3. Replace `yourdomain.com` with your actual domain
4. Press `Ctrl+O` to save, `Enter` to confirm, `Ctrl+X` to exit

Example:
```bash
DATABASE_URL=postgresql://insight_user:XyZ9#mK2$pQr@postgres:5432/insight_db
POSTGRES_PASSWORD=XyZ9#mK2$pQr
SECRET_KEY=abc123def456...your_64_char_hex...
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
```

## Step 7: Deploy Backend

**On your VPS**:

```bash
# Copy Hostinger docker-compose
cp docker-compose-hostinger.yml docker-compose.yml

# Build and start services
docker compose build
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f backend

# Press Ctrl+C to stop viewing logs
```

Expected output:
```
NAME                  STATUS              PORTS
insight-backend       running             127.0.0.1:8000->8000/tcp
insight-postgres      running (healthy)   127.0.0.1:5432->5432/tcp
```

## Step 8: Setup Nginx and SSL

**On your VPS**:

```bash
# Make script executable (if needed)
chmod +x setup-nginx.sh

# Run setup script
./setup-nginx.sh
```

**Follow the prompts**:
1. Enter your domain (e.g., `yourdomain.com`)
2. Include www subdomain? Type: `y`
3. Continue with SSL? Type: `y`
4. Enter your email address
5. Wait for SSL certificate generation

## Step 9: Verify Deployment

**Test from your Mac**:

```bash
# Test health endpoint
curl https://yourdomain.com/health

# Should return: {"status":"healthy"}
```

**In your browser**, visit:
- `https://yourdomain.com/docs` - API documentation
- `https://yourdomain.com/health` - Health check

## Step 10: Update Flutter Apps

On your Mac:

```bash
cd /Users/nandez/Developer/insight

# Find and update API base URL
# Search for localhost:8000 references
grep -r "localhost:8000" packages/insight_core/lib/src/

# Update to your domain
# In repositories, change:
# http://localhost:8000/api/v1
# to:
# https://yourdomain.com/api/v1
```

## Troubleshooting

### Can't connect to VPS
```bash
# Check if VPS is running in Hostinger control panel
# Try SSH again with verbose mode
ssh -v root@YOUR_VPS_IP
```

### Docker fails to start
```bash
# Check Docker status
systemctl status docker

# Restart Docker
systemctl restart docker
```

### SSL certificate fails
```bash
# Verify domain points to VPS
nslookup yourdomain.com

# Check if it shows your VPS IP
# Wait longer if DNS hasn't propagated yet
```

### Backend won't start
```bash
# Check logs
docker compose logs backend

# Common issues:
# 1. Wrong .env values - edit and restart
# 2. Database not ready - wait and check: docker compose ps
```

## Next Steps

After successful deployment:

1. ✅ Backend running on Hostinger
2. ⬜ Update Flutter apps with new API URL (see UPDATE_FLUTTER_APPS.md)
3. ⬜ Test all API endpoints
4. ⬜ Set up automated backups
5. ⬜ Configure monitoring

## Quick Commands Reference

```bash
# View logs
docker compose logs -f backend

# Restart services
docker compose restart

# Stop services
docker compose down

# Update deployment
cd /opt/insight/backend
git pull
./deploy-hostinger.sh

# Backup database
docker compose exec -T postgres pg_dump -U insight_user insight_db > backup.sql
```

## Support

- Full guide: backend/HOSTINGER_DEPLOYMENT.md
- App updates: backend/UPDATE_FLUTTER_APPS.md
- Hostinger support: 24/7 live chat

---

**Estimated Time**: 30-45 minutes (including waiting for DNS)
**Difficulty**: Intermediate
