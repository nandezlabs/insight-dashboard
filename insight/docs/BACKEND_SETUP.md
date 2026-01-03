# Backend Setup and Deployment Guide

## Goals & KPI API - Completed Implementation

### What's Been Implemented ✅

**Backend Components**:

1. **Models** (`backend/app/models/calendar.py`)

   - `Goal` model with goal_type, target_value, period_date
   - `KPIData` model with all KPI metrics
   - Already existed - no changes needed

2. **Schemas** (`backend/app/schemas/goal.py`)

   - Pydantic schemas for validation
   - Request/Response models
   - Enum for GoalType

3. **API Endpoints** (`backend/app/api/v1/goals.py`)

   - **Goals**: GET (list/single), POST (create), PUT (update), DELETE
   - **KPI Data**: GET (latest/by-date/range), POST (upsert)
   - Query parameters for filtering
   - Proper HTTP status codes

4. **Configuration**
   - Environment variables configured
   - Dependencies installed
   - Router registration ready

### Database Setup (To Do)

The models are defined and migrations are ready to generate once PostgreSQL is running.

#### 1. Start PostgreSQL Database

**Option A: Docker (Recommended)**

```bash
cd /Users/nandez/Developer/insight/backend
docker-compose up -d
```

**Option B: Local PostgreSQL**

```bash
# Install PostgreSQL (if not installed)
brew install postgresql@14

# Start PostgreSQL service
brew services start postgresql@14

# Create database
createdb insight
```

#### 2. Generate and Run Migrations

```bash
cd /Users/nandez/Developer/insight/backend

# Generate migration for goals and kpi_data tables
alembic revision --autogenerate -m "Add goals and kpi_data tables"

# Apply migration
alembic upgrade head
```

The migration will create:

```sql
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    goal_type goal_type_enum NOT NULL,
    target_value NUMERIC(12, 2) NOT NULL,
    period_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE kpi_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data_date DATE NOT NULL UNIQUE,
    gem_score NUMERIC(5, 2),
    hours_scheduled NUMERIC(8, 2),
    hours_recommended NUMERIC(8, 2),
    labor_used_percentage NUMERIC(5, 2),
    sales_actual NUMERIC(12, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_goals_period_date ON goals(period_date);
CREATE INDEX idx_goals_goal_type ON goals(goal_type);
CREATE INDEX idx_kpi_data_date ON kpi_data(data_date);
```

#### 3. Start Backend Server

```bash
cd /Users/nandez/Developer/insight/backend
uvicorn app.main:app --reload --port 8000
```

Server will be available at: `http://localhost:8000`

API Documentation: `http://localhost:8000/docs` (Swagger UI)

### Testing the API

#### Create a Goal

```bash
curl -X POST http://localhost:8000/api/v1/goals \
  -H "Content-Type: application/json" \
  -d '{
    "goal_type": "sales_week",
    "target_value": 50000.0,
    "period_date": "2025-12-30"
  }'
```

#### Get All Goals

```bash
curl http://localhost:8000/api/v1/goals
```

#### Filter Goals by Type

```bash
curl "http://localhost:8000/api/v1/goals?type=sales_week"
```

#### Create/Update KPI Data

```bash
curl -X POST http://localhost:8000/api/v1/kpi-data \
  -H "Content-Type: application/json" \
  -d '{
    "data_date": "2025-12-26",
    "sales_actual": 45000.0,
    "gem_score": 85.5,
    "labor_used_percentage": 106.7
  }'
```

#### Get Latest KPI Data

```bash
curl http://localhost:8000/api/v1/kpi-data/latest
```

### Integration with Flutter App

The Flutter app is already configured to use these endpoints via:

- `GoalRepository` in `packages/insight_core/lib/src/repositories/goal_repository.dart`
- `GoalProvider` in `apps/store_manager/lib/core/providers/goal_provider.dart`

**Update API Base URL** (if needed):
In `packages/insight_core/lib/src/services/api_client.dart`, ensure the base URL points to your backend:

```dart
static const String baseUrl = 'http://localhost:8000';  // Development
// or
static const String baseUrl = 'https://your-domain.com';  // Production
```

### Docker Deployment (Optional)

Create `docker-compose.yml`:

```yaml
version: "3.8"

services:
  db:
    image: postgres:14
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: insight
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://postgres:postgres@db:5432/insight
      SECRET_KEY: ${SECRET_KEY}
    depends_on:
      - db
    volumes:
      - ./backend:/app

volumes:
  postgres_data:
```

Run with:

```bash
docker-compose up
```

### Security Considerations

Before production deployment:

1. **Change SECRET_KEY**: Generate a secure random key

   ```bash
   python -c "import secrets; print(secrets.token_urlsafe(32))"
   ```

2. **Enable HTTPS**: Use SSL/TLS certificates

3. **Add Authentication**: Protect endpoints with JWT tokens

4. **Configure CORS**: Restrict allowed origins in production

5. **Database Security**:
   - Use strong passwords
   - Enable SSL for database connections
   - Implement Row Level Security (RLS)

### Next Steps

Once database is running:

1. ✅ Run migrations: `alembic upgrade head`
2. ✅ Start backend: `uvicorn app.main:app --reload`
3. ✅ Test endpoints with Swagger UI (`http://localhost:8000/docs`)
4. ✅ Update Flutter app API base URL
5. ✅ Test end-to-end flow from Flutter app

### Troubleshooting

**Issue**: `connection refused` when generating migrations

- **Solution**: Start PostgreSQL database first

**Issue**: Import errors in Python

- **Solution**: Install dependencies: `pip install -r requirements.txt`

**Issue**: Flutter can't connect to API

- **Solution**: Check API base URL and ensure backend is running

**Issue**: CORS errors

- **Solution**: Add Flutter app origin to CORS_ORIGINS in `.env`

### Files Modified

- ✅ `backend/app/models/goal.py` - Created (but models already in calendar.py)
- ✅ `backend/app/schemas/goal.py` - Created
- ✅ `backend/app/api/v1/goals.py` - Created (198 lines)
- ✅ `backend/app/api/v1/router.py` - Updated to include goals router
- ✅ `backend/app/schemas/__init__.py` - Updated to export goal schemas
- ✅ `backend/.env` - Created with configuration

### API Endpoints Summary

| Method | Endpoint                       | Description                   |
| ------ | ------------------------------ | ----------------------------- |
| GET    | `/api/v1/goals`                | List all goals (with filters) |
| GET    | `/api/v1/goals/{id}`           | Get single goal               |
| POST   | `/api/v1/goals`                | Create goal                   |
| PUT    | `/api/v1/goals/{id}`           | Update goal                   |
| DELETE | `/api/v1/goals/{id}`           | Delete goal                   |
| GET    | `/api/v1/kpi-data/latest`      | Get latest KPI data           |
| GET    | `/api/v1/kpi-data?date={date}` | Get KPI by date               |
| GET    | `/api/v1/kpi-data/range`       | Get KPI range                 |
| POST   | `/api/v1/kpi-data`             | Upsert KPI data               |

All endpoints return JSON and use proper HTTP status codes (200, 201, 204, 400, 404).
