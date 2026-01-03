# Alternative: SQLite Setup (No Docker Required)

## Overview

Since Docker is not installed, you can use **SQLite** as a local database alternative. This keeps everything contained within the project directory.

## Setup Steps

### 1. Update Requirements

```bash
cd /Users/nandez/Developer/insight/backend
source venv/bin/activate
pip install aiosqlite
```

### 2. Update .env File

```bash
# Change DATABASE_URL from PostgreSQL to SQLite
DATABASE_URL=sqlite+aiosqlite:///./insight.db
```

### 3. Update database.py for SQLite Compatibility

Add SQLite-specific configuration to `app/database.py`:

```python
# At the top of database.py
from sqlalchemy.pool import StaticPool

# Modify engine creation
if settings.DATABASE_URL.startswith("sqlite"):
    engine = create_async_engine(
        settings.DATABASE_URL,
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
        echo=settings.DEBUG,
    )
else:
    engine = create_async_engine(
        settings.DATABASE_URL,
        echo=settings.DEBUG,
    )
```

### 4. Run Migrations

```bash
alembic upgrade head
```

This will create `insight.db` in your backend directory.

### 5. Start Backend

```bash
uvicorn app.main:app --reload --port 8000
```

### 6. Test API

Visit: http://localhost:8000/docs

---

## Comparison: PostgreSQL vs SQLite

### PostgreSQL (Docker) ✅

**Pros:**

- Production-grade
- Better concurrency
- Advanced features
- Closer to deployment environment

**Cons:**

- Requires Docker installation
- More complex setup
- Heavier resource usage

### SQLite ✅

**Pros:**

- Zero configuration
- Single file database
- Fast for development
- No external dependencies
- Perfect for local testing

**Cons:**

- Limited concurrency
- Not for production
- Fewer advanced features

---

## Recommended Approach

For **local development and testing**, SQLite is perfect:

- ✅ All data in `backend/insight.db`
- ✅ No Docker needed
- ✅ Fast and simple
- ✅ Easy to reset (just delete the file)

For **production deployment**, use PostgreSQL:

- Production server will have proper PostgreSQL setup
- Just change DATABASE_URL in production .env
- Alembic migrations work with both

---

## Quick Start (SQLite)

```bash
# 1. Navigate to backend
cd /Users/nandez/Developer/insight/backend

# 2. Activate venv
source venv/bin/activate

# 3. Install SQLite driver
pip install aiosqlite

# 4. Update .env
echo "DATABASE_URL=sqlite+aiosqlite:///./insight.db" >> .env

# 5. Run this Python script to verify
python << EOF
from app.config import settings
print(f"Database URL: {settings.DATABASE_URL}")
EOF

# 6. Run migrations
alembic upgrade head

# 7. Start server
uvicorn app.main:app --reload
```

---

## What Gets Created (All Local)

```
backend/
├── venv/                    # Virtual environment
├── insight.db               # SQLite database file
├── postgres-data/           # Not used with SQLite
├── .env                     # Local config
└── ...
```

All in `/Users/nandez/Developer/insight/backend/` ✅

---

## Next Steps

**Option A: Use SQLite (Easiest)**

1. Run commands above
2. Start developing immediately

**Option B: Install Docker for PostgreSQL**

1. Download Docker Desktop
2. Run `docker-compose up -d postgres`
3. Use PostgreSQL setup

Both options keep everything local to the project!
