# Local PostgreSQL Setup (Docker-based)

## Option 1: Install Docker Desktop (Recommended)

1. **Download Docker Desktop for Mac**:

   - Visit: https://www.docker.com/products/docker-desktop/
   - Download and install Docker Desktop
   - Start Docker Desktop app

2. **Verify Installation**:

   ```bash
   docker --version
   docker-compose --version
   ```

3. **Start PostgreSQL**:

   ```bash
   cd /Users/nandez/Developer/insight/backend
   docker-compose up -d postgres
   ```

4. **Run Migrations**:

   ```bash
   # Make sure you're in the backend directory and venv is activated
   cd /Users/nandez/Developer/insight/backend
   source venv/bin/activate  # or create: python3 -m venv venv
   alembic upgrade head
   ```

5. **Start Backend**:

   ```bash
   docker-compose up backend
   # OR run locally:
   uvicorn app.main:app --reload --port 8000
   ```

6. **Test API**:
   - Swagger UI: http://localhost:8000/docs
   - API: http://localhost:8000/api/v1/

---

## Option 2: Local Python Environment (No Docker)

If you prefer not to use Docker, we can use SQLite instead:

1. **Update DATABASE_URL in .env**:

   ```
   DATABASE_URL=sqlite:///./insight.db
   ```

2. **Install SQLite driver**:

   ```bash
   pip install aiosqlite
   ```

3. **Update app/database.py** to support SQLite:

   - Change `postgresql+asyncpg://` to `sqlite+aiosqlite://`
   - Adjust SQLAlchemy engine parameters

4. **Run migrations**:

   ```bash
   alembic upgrade head
   ```

5. **Start backend**:
   ```bash
   uvicorn app.main:app --reload
   ```

---

## What's Included (All Local to Project)

✅ **Docker Compose Configuration**

- PostgreSQL 15 (Alpine Linux - lightweight)
- Container name: `insight-postgres`
- Port: 5432 (only exposed to localhost)
- Data volume: `./postgres-data` (local directory)
- Health checks enabled

✅ **Environment Isolation**

- All data stored in `backend/postgres-data/`
- No global PostgreSQL installation used
- Containers can be stopped/removed anytime
- Data persists between container restarts

✅ **Git Ignore**

- `postgres-data/` excluded from git
- `.env` files excluded
- All build artifacts excluded

---

## Useful Commands

**Start only PostgreSQL**:

```bash
docker-compose up -d postgres
```

**View logs**:

```bash
docker-compose logs -f postgres
```

**Stop containers**:

```bash
docker-compose down
```

**Stop and remove data**:

```bash
docker-compose down -v
rm -rf postgres-data/
```

**Access PostgreSQL CLI**:

```bash
docker exec -it insight-postgres psql -U postgres -d insight
```

**Check container status**:

```bash
docker-compose ps
```

---

## Next Steps

1. Install Docker Desktop (if not already)
2. Run `docker-compose up -d postgres`
3. Run `alembic upgrade head`
4. Test API endpoints

All data stays in `/Users/nandez/Developer/insight/backend/postgres-data/` - completely local to this project!
