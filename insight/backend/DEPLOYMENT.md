# Deployment Guide - UGREEN NAS

Complete guide for deploying the Insight backend on your UGREEN NAS with Tailscale.

## Prerequisites

### 1. UGREEN NAS Setup

- UGREEN NAS with UGOS (or similar) installed
- Docker and Docker Compose installed
- SSH access enabled
- At least 2GB RAM available
- 10GB storage space

### 2. Tailscale Account

- Create account at [tailscale.com](https://tailscale.com)
- Generate an auth key:
  1. Go to Settings → Keys
  2. Click "Generate auth key"
  3. Select "Reusable" and "Ephemeral" (optional)
  4. Copy the key (starts with `tskey-auth-`)

## Installation Steps

### Step 1: Access Your NAS

SSH into your NAS:

```bash
ssh admin@your-nas-ip
# Or use the UGOS web terminal
```

### Step 2: Clone the Repository

```bash
# Create app directory
cd /volume1/docker  # Adjust path for your NAS
mkdir insight
cd insight

# Clone or copy the backend directory
# If you have git:
git clone https://github.com/yourusername/insight.git .

# Or manually copy files via SFTP/SCP
```

### Step 3: Configure Environment

```bash
cd backend
cp .env.example .env
nano .env  # Or use vi, or edit via file manager
```

Configure the following in `.env`:

```bash
# Generate a strong password
DB_PASSWORD=your-secure-database-password-here

# Generate a secret key (use: openssl rand -hex 32)
SECRET_KEY=your-32-char-secret-key-here

# Your Tailscale auth key
TAILSCALE_AUTH_KEY=tskey-auth-xxxxx

# Optional: Set specific CORS origins
CORS_ORIGINS=http://100.*.*.*, https://yourdomain.com

# Debug mode (false for production)
DEBUG=false
LOG_LEVEL=info
```

### Step 4: Build and Start Services

```bash
# Build the API container
docker-compose build

# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

You should see three containers running:

- `insight-db` (PostgreSQL)
- `insight-api` (FastAPI)
- `insight-tailscale` (Tailscale VPN)

### Step 5: Verify Tailscale Connection

```bash
# Check Tailscale status
docker-compose exec tailscale tailscale status

# Get your Tailscale IP
docker-compose exec tailscale tailscale ip
```

Your Tailscale IP will be something like: `100.x.x.x`

Go to [Tailscale admin console](https://login.tailscale.com/admin/machines) and verify your NAS appears as `insight-nas`.

### Step 6: Test the API

From any device on your Tailscale network:

```bash
# Health check
curl http://100.x.x.x:8000/health

# API documentation
open http://100.x.x.x:8000/docs
```

You should see:

```json
{
  "status": "healthy",
  "service": "insight-api",
  "version": "v1"
}
```

### Step 7: Initialize Database

The database schema is automatically loaded on first start. Verify:

```bash
# Connect to database
docker-compose exec postgres psql -U insight -d insight

# List tables
\dt

# Check team table (should have seed data)
SELECT * FROM team;

# Exit
\q
```

## Configure Flutter Apps

### Update API Client in Flutter

Edit `packages/insight_core/lib/src/services/api_client.dart`:

```dart
// In your app initialization
ApiClient.initialize(
  baseUrl: 'http://100.x.x.x:8000/api/v1',  // Your Tailscale IP
);
```

Or use environment variables:

```dart
// apps/store_manager/.env
API_BASE_URL=http://100.x.x.x:8000/api/v1

// apps/store/.env
API_BASE_URL=http://100.x.x.x:8000/api/v1
```

### Install Tailscale on Devices

**iOS (Store Manager & Store App):**

1. Install Tailscale from App Store
2. Sign in with your account
3. Enable VPN connection

**Android (Store App):**

1. Install Tailscale from Play Store
2. Sign in with your account
3. Enable VPN connection

**macOS (Store Manager):**

1. Download from [tailscale.com/download](https://tailscale.com/download)
2. Install and sign in
3. Enable at startup (optional)

## Management

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f api
docker-compose logs -f postgres
docker-compose logs -f tailscale
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart api
```

### Stop Services

```bash
docker-compose stop
```

### Update Application

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose down
docker-compose build
docker-compose up -d
```

### Database Backup

```bash
# Create backup
docker-compose exec postgres pg_dump -U insight insight > backup_$(date +%Y%m%d).sql

# Restore from backup
docker-compose exec -T postgres psql -U insight insight < backup_20231215.sql
```

### Database Migrations

```bash
# Check current version
docker-compose exec api alembic current

# Run pending migrations
docker-compose exec api alembic upgrade head

# Create new migration (after model changes)
docker-compose exec api alembic revision --autogenerate -m "description"
```

## Monitoring

### Check Resource Usage

```bash
# Container stats
docker stats insight-db insight-api insight-tailscale

# Disk usage
docker-compose exec api df -h /app/uploads
```

### Check Database Connections

```bash
docker-compose exec postgres psql -U insight -d insight -c "SELECT count(*) FROM pg_stat_activity;"
```

## Troubleshooting

### API Won't Start

**Check logs:**

```bash
docker-compose logs api
```

**Common issues:**

- Database not ready: Wait for `insight-db` to be healthy
- Missing SECRET_KEY: Check `.env` file
- Port conflict: Check if port 8000 is in use

### Can't Connect from Flutter App

**Verify Tailscale:**

1. Check Tailscale is running on both NAS and device
2. Verify both devices are on same Tailnet
3. Ping the NAS IP: `ping 100.x.x.x`

**Check firewall:**

```bash
# On NAS, verify port is open
docker-compose exec api netstat -ln | grep 8000
```

### Database Connection Errors

**Check credentials:**

```bash
# Verify DB_PASSWORD matches in .env
cat .env | grep DB_PASSWORD
```

**Check connection:**

```bash
docker-compose exec api python -c "from app.database import engine; print(engine.connect())"
```

### Tailscale Not Connecting

**Check logs:**

```bash
docker-compose logs tailscale
```

**Verify auth key:**

- Key should start with `tskey-auth-`
- Check if key expired (regenerate if needed)

**Restart Tailscale:**

```bash
docker-compose restart tailscale
```

## Security Best Practices

1. **Change default credentials** - Use strong passwords
2. **Regular updates** - Keep Docker images updated
3. **Backup regularly** - Automated daily backups recommended
4. **Limit CORS origins** - Don't use `*` in production
5. **Monitor logs** - Check for suspicious activity
6. **Use firewall** - Only expose necessary ports

## Performance Tuning

### For Heavy Usage

Edit `docker-compose.yml`:

```yaml
postgres:
  environment:
    POSTGRES_MAX_CONNECTIONS: 100
  shm_size: 256mb

api:
  deploy:
    resources:
      limits:
        cpus: "2"
        memory: 2G
```

### Enable Connection Pooling

Edit `app/database.py`:

```python
engine = create_engine(
    settings.DATABASE_URL,
    pool_size=20,
    max_overflow=40,
    pool_pre_ping=True,
)
```

## Maintenance Schedule

**Daily:**

- Check service health: `docker-compose ps`
- Review error logs: `docker-compose logs --tail=100 api | grep ERROR`

**Weekly:**

- Database backup
- Check disk space: `df -h`
- Update containers: `docker-compose pull && docker-compose up -d`

**Monthly:**

- Review Tailscale access logs
- Verify API performance
- Clean old backups

## Support

### Useful Commands

```bash
# Check all services status
docker-compose ps

# View recent logs
docker-compose logs --tail=100

# Interactive shell in API container
docker-compose exec api bash

# Database shell
docker-compose exec postgres psql -U insight -d insight

# Check API version
curl http://100.x.x.x:8000/api/v1/sync/status
```

### Log Files

- API logs: `docker-compose logs api`
- Database logs: `docker-compose logs postgres`
- Tailscale logs: `docker-compose logs tailscale`

## Next Steps

1. ✅ Deploy backend on NAS
2. ✅ Install Tailscale on all devices
3. ✅ Configure Flutter apps with API URL
4. ✅ Test sync functionality
5. ✅ Set up automated backups
6. ✅ Configure monitoring (optional)

---

**Congratulations!** Your Insight backend is now running on your UGREEN NAS with secure Tailscale access. 🎉
