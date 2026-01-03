# Hostinger VPS Deployment Guide

Complete guide for deploying the Insight backend on a Hostinger VPS.

## Prerequisites

### 1. Hostinger VPS Requirements

- **VPS Plan**: Minimum VPS 2 or higher recommended
  - 2GB RAM minimum (4GB recommended)
  - 50GB SSD storage
  - Ubuntu 22.04 LTS
- **Domain**: Your custom domain pointed to VPS IP
- **SSH Access**: Root or sudo user access

### 2. Tools Required

- SSH client (Terminal on macOS/Linux)
- Domain DNS configured to point to your VPS IP

## Part 1: Initial VPS Setup

### Step 1: Access Your VPS

```bash
# SSH into your Hostinger VPS
ssh root@your-vps-ip

# Or if using a custom user:
ssh username@your-vps-ip
```

### Step 2: Update System

```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl git wget ufw fail2ban
```

### Step 3: Install Docker

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo apt install -y docker-compose-plugin

# Verify installation
docker --version
docker compose version

# Add your user to docker group (if not root)
sudo usermod -aG docker $USER
newgrp docker
```

### Step 4: Configure Firewall

```bash
# Allow SSH, HTTP, and HTTPS
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw --force enable
sudo ufw status
```

## Part 2: Deploy the Application

### Step 1: Clone Repository

```bash
# Create application directory
sudo mkdir -p /opt/insight
sudo chown $USER:$USER /opt/insight
cd /opt/insight

# Clone repository (replace with your repo URL)
git clone https://github.com/yourusername/insight.git .

# Or upload files via SCP
# From local machine:
# scp -r backend/ root@your-vps-ip:/opt/insight/
```

### Step 2: Configure Environment Variables

```bash
cd /opt/insight/backend

# Create production environment file
cp .env.example .env
nano .env
```

Configure with your production values:

```bash
# Database Configuration
DATABASE_URL=postgresql://insight_user:YOUR_STRONG_PASSWORD@postgres:5432/insight_db

# Security (generate with: openssl rand -hex 32)
SECRET_KEY=your-64-character-secret-key-here

# API Configuration
API_VERSION=v1
DEBUG=false
LOG_LEVEL=info

# CORS - Your domain
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Authentication
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10080

# File Uploads
MAX_UPLOAD_SIZE=10485760
UPLOAD_DIR=/app/uploads

# Database Credentials (must match DATABASE_URL)
POSTGRES_USER=insight_user
POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD
POSTGRES_DB=insight_db
```

**Generate secure credentials:**
```bash
# Generate SECRET_KEY
openssl rand -hex 32

# Generate database password
openssl rand -base64 32
```

### Step 3: Create Production Docker Compose

```bash
# Use the Hostinger-specific compose file
cp docker-compose-hostinger.yml docker-compose.yml
```

### Step 4: Build and Start Services

```bash
# Build containers
docker compose build

# Start services in detached mode
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

### Step 5: Verify Backend is Running

```bash
# Check if backend responds
curl http://localhost:8000/health

# Should return: {"status":"healthy"}
```

## Part 3: Configure Nginx and SSL

### Step 1: Install Nginx

```bash
sudo apt install -y nginx
```

### Step 2: Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/insight
```

Paste this configuration (replace `yourdomain.com`):

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    # Redirect HTTP to HTTPS (after SSL is set up)
    # return 301 https://$server_name$request_uri;

    # Temporarily serve on HTTP until SSL is configured
    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;

        # Increase timeout for long-running requests
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
    }

    # File upload size limit
    client_max_body_size 10M;
}
```

### Step 3: Enable Site

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/insight /etc/nginx/sites-enabled/

# Remove default site
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

### Step 4: Install SSL with Let's Encrypt

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obtain SSL certificate (replace with your domain)
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Follow prompts:
# - Enter email address
# - Agree to terms
# - Choose to redirect HTTP to HTTPS (recommended)

# Test auto-renewal
sudo certbot renew --dry-run
```

### Step 5: Update Nginx for HTTPS

Certbot will automatically update your config, but verify it looks like:

```bash
sudo nano /etc/nginx/sites-available/insight
```

Should now include:

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass http://localhost:8000;
        # ... rest of proxy configuration
    }
}

server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

## Part 4: Verify Deployment

### Test API Endpoints

```bash
# Health check
curl https://yourdomain.com/health

# API docs (should be accessible in browser)
# Visit: https://yourdomain.com/docs

# Test API endpoint
curl https://yourdomain.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"store_code":"TEST001","password":"test123"}'
```

### Monitor Services

```bash
# View backend logs
docker compose logs -f backend

# View database logs
docker compose logs -f postgres

# Check resource usage
docker stats

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Part 5: Maintenance & Management

### Regular Updates

```bash
cd /opt/insight/backend

# Pull latest changes
git pull origin main

# Rebuild and restart
docker compose down
docker compose build
docker compose up -d

# Run database migrations
docker compose exec backend alembic upgrade head
```

### Backup Database

```bash
# Create backup directory
mkdir -p /opt/insight/backups

# Backup script
cat > /opt/insight/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/insight/backups"
DATE=$(date +%Y%m%d_%H%M%S)
docker compose exec -T postgres pg_dump -U insight_user insight_db > "$BACKUP_DIR/backup_$DATE.sql"
# Keep only last 7 days
find "$BACKUP_DIR" -name "backup_*.sql" -mtime +7 -delete
echo "Backup completed: backup_$DATE.sql"
EOF

chmod +x /opt/insight/backup.sh

# Set up daily backup cron job
crontab -e
# Add this line:
# 0 2 * * * /opt/insight/backup.sh >> /opt/insight/backups/backup.log 2>&1
```

### Restore Database

```bash
# Stop backend
docker compose stop backend

# Restore from backup
docker compose exec -T postgres psql -U insight_user insight_db < /opt/insight/backups/backup_20260103_020000.sql

# Restart backend
docker compose start backend
```

### View Logs

```bash
# Application logs
docker compose logs -f backend

# Last 100 lines
docker compose logs --tail=100 backend

# PostgreSQL logs
docker compose logs -f postgres

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Restart Services

```bash
# Restart all services
docker compose restart

# Restart specific service
docker compose restart backend

# Restart Nginx
sudo systemctl restart nginx
```

## Troubleshooting

### Backend Won't Start

```bash
# Check logs
docker compose logs backend

# Common issues:
# 1. Database not ready - wait and restart
# 2. Environment variables missing - check .env file
# 3. Port conflict - check if port 8000 is in use
sudo lsof -i :8000
```

### Database Connection Errors

```bash
# Check if PostgreSQL is running
docker compose ps postgres

# Test database connection
docker compose exec postgres psql -U insight_user -d insight_db -c "SELECT 1;"

# Check database logs
docker compose logs postgres
```

### SSL Certificate Issues

```bash
# Renew certificate manually
sudo certbot renew

# Check certificate status
sudo certbot certificates

# If renewal fails, check DNS and firewall
```

### High Memory Usage

```bash
# Check container resource usage
docker stats

# Restart containers to free memory
docker compose restart

# Prune unused Docker resources
docker system prune -a
```

## Security Best Practices

### 1. Change Default Passwords

- Use strong, unique passwords for database
- Rotate SECRET_KEY regularly
- Never commit .env file to git

### 2. Keep System Updated

```bash
# Regular updates
sudo apt update && sudo apt upgrade -y
docker compose pull
docker compose up -d
```

### 3. Monitor Logs

```bash
# Set up log rotation
sudo nano /etc/logrotate.d/insight

# Add:
/opt/insight/backend/logs/*.log {
    daily
    rotate 7
    compress
    delaycompress
    notifempty
    create 0640 root root
}
```

### 4. Fail2Ban Configuration

```bash
# Create jail for failed login attempts
sudo nano /etc/fail2ban/jail.local

# Add:
[nginx-limit-req]
enabled = true
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
```

## Domain Configuration

### Point Domain to VPS

1. Log in to Hostinger control panel
2. Go to Domain → DNS/Nameservers
3. Add A records:

```
Type    Name    Value           TTL
A       @       YOUR_VPS_IP     3600
A       www     YOUR_VPS_IP     3600
```

4. Wait for DNS propagation (up to 24 hours)

### Verify DNS

```bash
# Check if domain resolves to your VPS
nslookup yourdomain.com
dig yourdomain.com
```

## Performance Optimization

### Enable Gzip Compression

```bash
sudo nano /etc/nginx/nginx.conf

# Add in http block:
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
```

### Configure Connection Pooling

In [docker-compose-hostinger.yml](docker-compose-hostinger.yml):

```yaml
backend:
  environment:
    DATABASE_URL: postgresql://insight_user:password@postgres:5432/insight_db?pool_size=20&max_overflow=40
```

## Monitoring

### Set Up Simple Monitoring

```bash
# Create monitoring script
cat > /opt/insight/monitor.sh << 'EOF'
#!/bin/bash
if ! curl -f https://yourdomain.com/health > /dev/null 2>&1; then
    echo "$(date): Backend is down!" >> /opt/insight/monitor.log
    docker compose restart backend
fi
EOF

chmod +x /opt/insight/monitor.sh

# Add to crontab (check every 5 minutes)
crontab -e
# Add: */5 * * * * /opt/insight/monitor.sh
```

## Cost Optimization

### Hostinger VPS Plans

- **VPS 1**: $3.99/mo - 1GB RAM (too small)
- **VPS 2**: $5.99/mo - 2GB RAM (minimum recommended)
- **VPS 4**: $11.99/mo - 4GB RAM (recommended for production)
- **VPS 8**: $23.99/mo - 8GB RAM (high traffic)

### Reduce Costs

1. Use VPS 2 for development/testing
2. Upgrade to VPS 4 for production when needed
3. Clean up old Docker images regularly
4. Use database backup compression

## Next Steps

1. ✅ Deploy backend to Hostinger VPS
2. ⬜ Update Flutter apps to use new API URL
3. ⬜ Set up CI/CD for automated deployments
4. ⬜ Configure monitoring and alerting
5. ⬜ Set up staging environment for testing

## Support

- **Hostinger Support**: Live chat available 24/7
- **Docker Docs**: https://docs.docker.com
- **FastAPI Docs**: https://fastapi.tiangolo.com
- **PostgreSQL Docs**: https://www.postgresql.org/docs/

---

**Deployment Date**: January 2026  
**Backend Version**: v1  
**Estimated Setup Time**: 45-60 minutes
