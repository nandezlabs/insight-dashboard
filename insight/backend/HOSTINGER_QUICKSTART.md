# Hostinger VPS Quick Start Guide

**Complete Hostinger deployment in 15 minutes!**

## Prerequisites Checklist

- [ ] Hostinger VPS (VPS 2 or higher) with Ubuntu 22.04
- [ ] Domain name configured to point to VPS IP
- [ ] SSH access to your VPS
- [ ] This repository ready to deploy

## Step-by-Step Deployment

### 1. Initial VPS Setup (5 minutes)

```bash
# SSH into your VPS
ssh root@your-vps-ip

# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install -y docker-compose-plugin

# Configure firewall
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
```

### 2. Clone and Configure (5 minutes)

```bash
# Create app directory
mkdir -p /opt/insight
cd /opt/insight

# Clone repository
git clone https://github.com/yourusername/insight.git .

# Navigate to backend
cd backend

# Configure environment
cp .env.production .env
nano .env

# IMPORTANT: Edit these values in .env:
# 1. DATABASE_URL - Change password
# 2. SECRET_KEY - Generate with: openssl rand -hex 32
# 3. POSTGRES_PASSWORD - Same as DATABASE_URL password
# 4. CORS_ORIGINS - Your domain (https://yourdomain.com)
```

### 3. Deploy Backend (3 minutes)

```bash
# Copy Hostinger docker-compose
cp docker-compose-hostinger.yml docker-compose.yml

# Deploy
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Test backend (in new terminal)
curl http://localhost:8000/health
```

### 4. Configure Nginx and SSL (2 minutes)

```bash
# Run automated setup
./setup-nginx.sh

# Follow prompts:
# - Enter your domain
# - Include www? (y/n)
# - Enter email for Let's Encrypt
```

### 5. Verify Deployment

```bash
# Test HTTPS endpoint
curl https://yourdomain.com/health

# Visit in browser
# https://yourdomain.com/docs
```

## Common Issues

### Backend won't start
```bash
# Check logs
docker compose logs backend

# Check environment variables
cat .env

# Restart
docker compose restart
```

### Can't connect to database
```bash
# Check PostgreSQL
docker compose ps postgres
docker compose logs postgres

# Verify password in .env matches DATABASE_URL
```

### SSL certificate fails
```bash
# Verify DNS
nslookup yourdomain.com

# Check firewall
ufw status

# Wait for DNS propagation (up to 24 hours)
```

## Update App URLs

After successful deployment, update your Flutter apps:

### Store Manager App
```dart
// packages/insight_core/lib/src/constants/api_constants.dart
static const String baseUrl = 'https://yourdomain.com/api/v1';
```

### Store App
```dart
// Same file, same change
static const String baseUrl = 'https://yourdomain.com/api/v1';
```

Then rebuild both apps:
```bash
cd apps/store_manager
flutter build macos

cd ../store
flutter build ios
flutter build android
```

## Maintenance Commands

```bash
# View logs
docker compose logs -f backend

# Restart services
docker compose restart

# Update deployment
./deploy-hostinger.sh

# Backup database
mkdir -p /opt/insight/backups
docker compose exec -T postgres pg_dump -U insight_user insight_db > /opt/insight/backups/backup_$(date +%Y%m%d).sql

# View resource usage
docker stats
```

## Support

- **Full Guide**: [HOSTINGER_DEPLOYMENT.md](HOSTINGER_DEPLOYMENT.md)
- **Hostinger Support**: Live chat 24/7
- **Docker Issues**: https://docs.docker.com

## Deployment Checklist

- [ ] VPS provisioned and accessible
- [ ] Docker and Docker Compose installed
- [ ] Repository cloned to `/opt/insight`
- [ ] `.env` file configured with secure credentials
- [ ] Backend deployed and running
- [ ] Nginx configured with SSL
- [ ] Domain points to VPS and resolves correctly
- [ ] API accessible via HTTPS
- [ ] Flutter apps updated with new API URL
- [ ] Database backup scheduled

## Next Steps

1. Set up automated backups (daily cron job)
2. Configure monitoring and alerts
3. Set up CI/CD for automated deployments
4. Create staging environment for testing

---

**Estimated Total Time**: 15 minutes  
**Difficulty**: Intermediate  
**Cost**: $5.99-$23.99/month (Hostinger VPS)
