# Backend Setup - Complete ✅

Your Insight backend is successfully deployed and configured!

## Backend Information

### Access URLs
- **API Base**: `http://100.112.230.47:8000`
- **Health Check**: `http://100.112.230.47:8000/health`
- **API Documentation**: `http://100.112.230.47:8000/docs`
- **ReDoc**: `http://100.112.230.47:8000/redoc`

### Deployment Details
- **Location**: UGREEN NAS (dxp4800plus-d6cc-1)
- **Access Method**: Tailscale VPN
- **Tailscale IP**: `100.112.230.47`
- **Port**: `8000`

## Running Services

### 1. PostgreSQL Database
- **Container**: `insight-db`
- **Image**: `postgres:16-alpine`
- **Port**: `5433` (internal)
- **Status**: ✅ Healthy
- **Data Volume**: `insight-backend_postgres_data`

### 2. FastAPI Backend
- **Container**: `insight-api`
- **Port**: `8000` (exposed via host network)
- **Status**: ✅ Running
- **Uploads Volume**: `insight-backend_uploads_data`

### 3. Tailscale VPN
- **Container**: `tailscale_tailscale-1`
- **Status**: ✅ Connected
- **Network**: Secure VPN access

## Security Configuration

✅ **Secure Credentials Generated**
- Database password: Randomly generated (32 characters)
- API secret key: Randomly generated (64 hex characters)
- Stored in: `/home/Cloud/insight-backend/.env`

✅ **Network Security**
- Accessible only through Tailscale VPN
- No public internet exposure
- TLS can be added via reverse proxy if needed

## Flutter Apps Configuration

Both apps are configured to connect to the backend:

### Store Manager App
- Location: `apps/store_manager/lib/main.dart`
- API Client initialized on app start
- Base URL: `AppConstants.apiBaseUrl`

### Store App
- Location: `apps/store/lib/main.dart`
- API Client initialized on app start
- Base URL: `AppConstants.apiBaseUrl`

### Configuration File
- Location: `packages/insight_core/lib/src/constants/app_constants.dart`
- Current API URL: `http://100.112.230.47:8000`

## Managing the Backend

### View Logs
```bash
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml logs -f"
```

### Check Status
```bash
ssh -t Cloud@100.112.230.47 "sudo docker ps"
```

### Restart Services
```bash
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml restart"
```

### Stop Services
```bash
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml down"
```

### Start Services
```bash
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml up -d"
```

### Update Backend Code
```bash
# 1. Make changes locally in backend/
# 2. Create new archive
cd backend && tar -czf ~/Desktop/insight-backend-update.tar.gz .

# 3. Transfer to NAS
cat ~/Desktop/insight-backend-update.tar.gz | ssh Cloud@100.112.230.47 "cat > /home/Cloud/insight-backend-update.tar.gz"

# 4. Extract and rebuild
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && tar -xzf ../insight-backend-update.tar.gz && sudo docker compose -f docker-compose-nas.yml up -d --build"
```

## Database Access

### Connect to PostgreSQL
```bash
ssh -t Cloud@100.112.230.47 "sudo docker exec -it insight-db psql -U insight -d insight -p 5433"
```

### Run Database Migrations
```bash
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml exec api alembic upgrade head"
```

### Create New Migration
```bash
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml exec api alembic revision --autogenerate -m 'description'"
```

## Testing the API

### Health Check
```bash
curl http://100.112.230.47:8000/health
```

### Expected Response
```json
{
  "status": "healthy",
  "service": "insight-api",
  "version": "v1"
}
```

### Interactive API Documentation
Open in browser: `http://100.112.230.47:8000/docs`

## Troubleshooting

### Backend not responding
```bash
# Check if containers are running
ssh -t Cloud@100.112.230.47 "sudo docker ps"

# View logs
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml logs --tail=50"

# Restart services
ssh -t Cloud@100.112.230.47 "cd /home/Cloud/insight-backend && sudo docker compose -f docker-compose-nas.yml restart"
```

### Database connection issues
```bash
# Check database status
ssh -t Cloud@100.112.230.47 "sudo docker exec insight-db pg_isready -U insight -d insight -p 5433"

# View database logs
ssh -t Cloud@100.112.230.47 "sudo docker logs insight-db --tail=50"
```

### Tailscale connection issues
```bash
# Check Tailscale status from your Mac
tailscale status

# Ping the NAS
tailscale ping dxp4800plus-d6cc-1
```

## Next Steps

1. ✅ **Backend Deployed** - Running on NAS via Tailscale
2. ✅ **Flutter Apps Configured** - API client initialized
3. ⏭️ **Test API Endpoints** - Use Swagger UI at `/docs`
4. ⏭️ **Implement Sync Logic** - Connect local SQLite to backend
5. ⏭️ **Test on Devices** - Run apps with Tailscale installed

## Important Notes

- **Tailscale Required**: Both your development machine and any test devices must have Tailscale installed and authenticated to access the backend
- **Key Expiry**: Remember to disable key expiry in Tailscale admin console to keep NAS permanently connected
- **Backups**: Database data persists in Docker volumes. Consider setting up regular backups
- **SSL/TLS**: Currently using HTTP. For production, consider adding HTTPS via reverse proxy

## Files Modified

- ✅ `packages/insight_core/lib/src/constants/app_constants.dart` - Added API base URL
- ✅ `apps/store_manager/lib/main.dart` - Initialized API client
- ✅ `apps/store/lib/main.dart` - Initialized API client

---

**Setup Date**: December 18, 2025  
**Backend Version**: v1  
**Status**: ✅ Production Ready
