# Goals & KPI API Endpoints

This document describes the API endpoints needed for the Goals and Performance tracking feature.

## Goals Endpoints

### Get All Goals

```
GET /api/v1/goals
Query Parameters:
  - type (optional): Filter by goal type (sales_week, sales_period, gem_period, labor_percentage)
  - period_date (optional): Filter by period date (ISO 8601 format)

Response: 200 OK
[
  {
    "id": "uuid",
    "goal_type": "sales_week",
    "target_value": 50000.0,
    "period_date": "2025-12-23T00:00:00Z",
    "created_at": "2025-12-20T10:00:00Z"
  }
]
```

### Get Goal by ID

```
GET /api/v1/goals/{id}

Response: 200 OK
{
  "id": "uuid",
  "goal_type": "sales_week",
  "target_value": 50000.0,
  "period_date": "2025-12-23T00:00:00Z",
  "created_at": "2025-12-20T10:00:00Z"
}
```

### Create Goal

```
POST /api/v1/goals
Body:
{
  "goal_type": "sales_week",
  "target_value": 50000.0,
  "period_date": "2025-12-23T00:00:00Z"
}

Response: 201 Created
{
  "id": "uuid",
  "goal_type": "sales_week",
  "target_value": 50000.0,
  "period_date": "2025-12-23T00:00:00Z",
  "created_at": "2025-12-20T10:00:00Z"
}
```

### Update Goal

```
PUT /api/v1/goals/{id}
Body (all fields optional):
{
  "goal_type": "sales_period",
  "target_value": 60000.0,
  "period_date": "2025-12-30T00:00:00Z"
}

Response: 200 OK
{
  "id": "uuid",
  "goal_type": "sales_period",
  "target_value": 60000.0,
  "period_date": "2025-12-30T00:00:00Z",
  "created_at": "2025-12-20T10:00:00Z"
}
```

### Delete Goal

```
DELETE /api/v1/goals/{id}

Response: 204 No Content
```

## KPI Data Endpoints

### Get Latest KPI Data

```
GET /api/v1/kpi-data/latest

Response: 200 OK
{
  "id": "uuid",
  "data_date": "2025-12-26T00:00:00Z",
  "gem_score": 85.5,
  "hours_scheduled": 160.0,
  "hours_recommended": 150.0,
  "labor_used_percentage": 106.7,
  "sales_actual": 45000.0,
  "created_at": "2025-12-26T08:00:00Z",
  "updated_at": "2025-12-26T08:00:00Z"
}
```

### Get KPI Data by Date

```
GET /api/v1/kpi-data?date={iso_date}

Response: 200 OK
{
  "id": "uuid",
  "data_date": "2025-12-26T00:00:00Z",
  "gem_score": 85.5,
  "hours_scheduled": 160.0,
  "hours_recommended": 150.0,
  "labor_used_percentage": 106.7,
  "sales_actual": 45000.0,
  "created_at": "2025-12-26T08:00:00Z",
  "updated_at": "2025-12-26T08:00:00Z"
}
```

### Get KPI Data Range

```
GET /api/v1/kpi-data/range?start_date={iso_date}&end_date={iso_date}

Response: 200 OK
[
  {
    "id": "uuid",
    "data_date": "2025-12-26T00:00:00Z",
    "gem_score": 85.5,
    "hours_scheduled": 160.0,
    "hours_recommended": 150.0,
    "labor_used_percentage": 106.7,
    "sales_actual": 45000.0,
    "created_at": "2025-12-26T08:00:00Z",
    "updated_at": "2025-12-26T08:00:00Z"
  }
]
```

### Create or Update KPI Data

```
POST /api/v1/kpi-data
Body (all metrics optional except data_date):
{
  "data_date": "2025-12-26T00:00:00Z",
  "gem_score": 85.5,
  "hours_scheduled": 160.0,
  "hours_recommended": 150.0,
  "labor_used_percentage": 106.7,
  "sales_actual": 45000.0
}

Response: 200 OK (if existing record updated) or 201 Created (if new record)
{
  "id": "uuid",
  "data_date": "2025-12-26T00:00:00Z",
  "gem_score": 85.5,
  "hours_scheduled": 160.0,
  "hours_recommended": 150.0,
  "labor_used_percentage": 106.7,
  "sales_actual": 45000.0,
  "created_at": "2025-12-26T08:00:00Z",
  "updated_at": "2025-12-26T08:00:00Z"
}
```

## Goal Types

- `sales_week`: Weekly sales target
- `sales_period`: Period sales target (4-week period)
- `gem_period`: GEM score target for a period
- `labor_percentage`: Labor percentage target

## Data Models

### Goal

```dart
{
  id: String (UUID),
  goalType: GoalType enum,
  targetValue: double,
  periodDate: DateTime,
  createdAt: DateTime
}
```

### KpiData

```dart
{
  id: String (UUID),
  dataDate: DateTime,
  gemScore: double?,
  hoursScheduled: double?,
  hoursRecommended: double?,
  laborUsedPercentage: double?,
  salesActual: double?,
  createdAt: DateTime,
  updatedAt: DateTime
}
```

## Database Schema

### goals table

```sql
CREATE TABLE goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_type VARCHAR(50) NOT NULL,
  target_value DECIMAL(10,2) NOT NULL,
  period_date TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT goal_type_check CHECK (goal_type IN ('sales_week', 'sales_period', 'gem_period', 'labor_percentage'))
);

CREATE INDEX idx_goals_period_date ON goals(period_date);
CREATE INDEX idx_goals_goal_type ON goals(goal_type);
```

### kpi_data table

```sql
CREATE TABLE kpi_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data_date DATE NOT NULL UNIQUE,
  gem_score DECIMAL(5,2),
  hours_scheduled DECIMAL(10,2),
  hours_recommended DECIMAL(10,2),
  labor_used_percentage DECIMAL(5,2),
  sales_actual DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_kpi_data_date ON kpi_data(data_date);
```

## Notes

- All timestamps should be in UTC (ISO 8601 format)
- The KPI data endpoint uses upsert logic (creates if not exists, updates if exists)
- Goal types are enum values that map to specific KPI metrics
- Progress calculation: `(current_value / target_value) * 100`
