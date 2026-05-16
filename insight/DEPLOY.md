# Deployment Guide

## Quick Deploy to Production

This guide covers deploying Insight Dashboard to a production VPS (Hostinger or similar).

## Prerequisites

- VPS with Ubuntu 22.04 LTS (2GB RAM minimum)
- Domain name pointed to VPS IP
- SSH access to VPS
- GitHub repository with code

## 1. Initial VPS Setup

```bash
# SSH into your VPS
ssh root@your-server-ip

# Update system
apt update && apt upgrade -y

# Install required packages
apt install -y nginx certbot python3-certbot-nginx python3.11 python3.11-venv python3-pip nodejs npm git

# Create deployment user
adduser insight
usermod -aG sudo insight
su - insight
```

## 2. Clone Repository

```bash
# Clone your repository
cd ~
git clone https://github.com/yourusername/insight.git
cd insight
```

## 3. Setup Backend

```bash
cd backend

# Run setup script
chmod +x setup.sh
./setup.sh

# Create production .env
cp .env.example .env
nano .env  # Add your Supabase credentials

# Test backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000
# Ctrl+C to stop
```

## 4. Setup Frontend

```bash
cd ../frontend

# Install dependencies
npm ci

# Create production .env.local
cp .env.example .env.local
nano .env.local  # Add your credentials

# Build for production
npm run build

# Test production build
npm start
# Ctrl+C to stop
```

## 5. Create Systemd Services

### Backend Service

```bash
sudo nano /etc/systemd/system/insight-backend.service
```

Paste:

```ini
[Unit]
Description=Insight Dashboard Backend
After=network.target

[Service]
Type=simple
User=insight
WorkingDirectory=/home/insight/insight/backend
Environment="PATH=/home/insight/insight/backend/venv/bin"
ExecStart=/home/insight/insight/backend/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Frontend Service

```bash
sudo nano /etc/systemd/system/insight-frontend.service
```

Paste:

```ini
[Unit]
Description=Insight Dashboard Frontend
After=network.target

[Service]
Type=simple
User=insight
WorkingDirectory=/home/insight/insight/frontend
Environment="PATH=/usr/bin:/usr/local/bin"
Environment="NODE_ENV=production"
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Enable and Start Services

```bash
sudo systemctl daemon-reload
sudo systemctl enable insight-backend
sudo systemctl enable insight-frontend
sudo systemctl start insight-backend
sudo systemctl start insight-frontend

# Check status
sudo systemctl status insight-backend
sudo systemctl status insight-frontend
```

## 6. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/insight
```

Paste:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:8000/health;
    }

    # API docs
    location /docs {
        proxy_pass http://localhost:8000/docs;
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/insight /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 7. Setup SSL with Let's Encrypt

```bash
sudo certbot --nginx -d your-domain.com

# Auto-renewal is set up automatically
# Test renewal:
sudo certbot renew --dry-run
```

## 8. Configure Firewall

```bash
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw enable
sudo ufw status
```

## 9. Setup GitHub Actions for Auto-Deploy

Create `.github/workflows/deploy.yml` in your repository:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy to VPS
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.VPS_HOST }}
          username: insight
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd ~/insight
            git pull origin main

            # Update backend
            cd backend
            source venv/bin/activate
            pip install -r requirements.txt
            sudo systemctl restart insight-backend

            # Update frontend
            cd ../frontend
            npm ci
            npm run build
            sudo systemctl restart insight-frontend

            echo "✅ Deployment complete"
```

Add secrets in GitHub:

- `VPS_HOST`: Your server IP
- `VPS_SSH_KEY`: Your SSH private key

## 10. Monitoring & Maintenance

### View Logs

```bash
# Backend logs
sudo journalctl -u insight-backend -f

# Frontend logs
sudo journalctl -u insight-frontend -f

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Restart Services

```bash
sudo systemctl restart insight-backend
sudo systemctl restart insight-frontend
sudo systemctl restart nginx
```

### Update Application

```bash
cd ~/insight
git pull origin main

# Update backend
cd backend
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart insight-backend

# Update frontend
cd ../frontend
npm ci
npm run build
sudo systemctl restart insight-frontend
```

### Database Backups

Setup automated backups:

```bash
chmod +x scripts/backup.sh

# Add to crontab
crontab -e

# Add this line (runs daily at 2 AM):
0 2 * * * /home/insight/insight/scripts/backup.sh
```

## Troubleshooting

### Service won't start

```bash
# Check logs
sudo journalctl -u insight-backend -n 50
sudo journalctl -u insight-frontend -n 50

# Check if port is in use
sudo lsof -i :8000
sudo lsof -i :3000
```

### Nginx errors

```bash
# Test config
sudo nginx -t

# Reload config
sudo systemctl reload nginx
```

### Database connection issues

```bash
# Check .env files
cat ~/insight/backend/.env
cat ~/insight/frontend/.env.local

# Test Supabase connection
cd ~/insight/backend
source venv/bin/activate
python -c "from services.supabase_client import check_connection; import asyncio; print(asyncio.run(check_connection()))"
```

## Security Checklist

- [ ] Firewall enabled (UFW)
- [ ] SSL certificate installed and auto-renewing
- [ ] SSH key authentication (disable password auth)
- [ ] Regular system updates scheduled
- [ ] Database backups automated
- [ ] Environment variables secured
- [ ] Fail2ban installed for brute-force protection
- [ ] Rate limiting configured in Nginx

## Performance Optimization

```bash
# Enable gzip in Nginx
sudo nano /etc/nginx/nginx.conf

# Add in http block:
gzip on;
gzip_types text/plain text/css application/json application/javascript;
gzip_min_length 256;

# Restart Nginx
sudo systemctl restart nginx
```

## Done! 🎉

Your Insight Dashboard is now live at https://your-domain.com

Monitor the first few hours to ensure everything runs smoothly.
