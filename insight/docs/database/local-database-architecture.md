# Insight - Local Database Architecture

## Overview

**Database Solution:** SQLite with Remote Sync

- **Local Storage:** Each app has its own SQLite database (offline-first)
- **Central Database:** PostgreSQL on UGREEN NAS
- **Sync Strategy:** Bi-directional sync when devices are online
- **Access:** Remote access via Tailscale VPN

---

## Architecture Components

```
┌─────────────────────────────────────────────────────────────┐
│                     UGREEN NAS                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              PostgreSQL Database                      │  │
│  │  - Central source of truth                           │  │
│  │  - Stores all forms, submissions, KPIs               │  │
│  │  - Accessible via Tailscale network                  │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↕                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              REST API (Node.js/Python)                │  │
│  │  - Sync endpoints                                     │  │
│  │  - Data validation                                    │  │
│  │  - Conflict resolution                                │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↕
              ┌─────────────────────────┐
              │   Tailscale Network     │
              │   (Encrypted VPN)       │
              └─────────────────────────┘
                           ↕
        ┌──────────────────┴──────────────────┐
        ↓                                     ↓
┌──────────────────┐                  ┌──────────────────┐
│ Store Manager    │                  │ Store App        │
│ (Mac/iOS)        │                  │ (iOS/Android)    │
│                  │                  │                  │
│ ┌──────────────┐ │                  │ ┌──────────────┐ │
│ │   SQLite     │ │                  │ │   SQLite     │ │
│ │   Local DB   │ │                  │ │   Local DB   │ │
│ │              │ │                  │ │              │ │
│ │  - Forms     │ │                  │ │  - Forms     │ │
│ │  - Fields    │ │                  │ │  - Assigned  │ │
│ │  - Templates │ │                  │ │  - Submissns │ │
│ │  - Settings  │ │                  │ │  - KPIs      │ │
│ └──────────────┘ │                  │ └──────────────┘ │
│                  │                  │                  │
│  Drift Package   │                  │  Drift Package   │
│  (Type-safe ORM) │                  │  (Type-safe ORM) │
└──────────────────┘                  └──────────────────┘
```

---

## Database Schema

### Local SQLite Schema (Each App)

#### Common Tables (Both Apps)

**1. sync_metadata**

```sql
CREATE TABLE sync_metadata (
    id INTEGER PRIMARY KEY,
    table_name TEXT NOT NULL,
    last_sync_at INTEGER NOT NULL, -- Unix timestamp
    last_sync_version INTEGER DEFAULT 0
);
```

**2. pending_changes**

```sql
CREATE TABLE pending_changes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    data TEXT, -- JSON
    created_at INTEGER NOT NULL,
    synced INTEGER DEFAULT 0
);
```

**3. business_calendar**

```sql
CREATE TABLE business_calendar (
    id TEXT PRIMARY KEY,
    start_date INTEGER NOT NULL,
    current_week INTEGER NOT NULL,
    current_period INTEGER NOT NULL,
    current_quarter INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
);
```

**4. timeframes**

```sql
CREATE TABLE timeframes (
    id TEXT PRIMARY KEY,
    tag TEXT NOT NULL UNIQUE,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    auto_submit_time TEXT NOT NULL,
    is_default INTEGER DEFAULT 0
);
```

**5. team**

```sql
CREATE TABLE team (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL, -- 'manager' or 'employee'
    created_at INTEGER NOT NULL
);
```

**6. forms**

```sql
CREATE TABLE forms (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    tags TEXT, -- JSON array
    is_template INTEGER DEFAULT 0,
    schedule_type TEXT DEFAULT 'tag_based',
    custom_start_date INTEGER,
    custom_end_date INTEGER,
    custom_time TEXT,
    max_submissions INTEGER,
    status TEXT DEFAULT 'draft',
    created_by TEXT,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    FOREIGN KEY (created_by) REFERENCES team(id)
);
```

**7. form_sections**

```sql
CREATE TABLE form_sections (
    id TEXT PRIMARY KEY,
    form_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE
);
```

**8. fields**

```sql
CREATE TABLE fields (
    id TEXT PRIMARY KEY,
    form_id TEXT,
    section_id TEXT,
    field_type TEXT NOT NULL,
    label TEXT NOT NULL,
    placeholder TEXT,
    help_text TEXT,
    is_required INTEGER DEFAULT 0,
    order_index INTEGER NOT NULL,
    validation_rules TEXT, -- JSON
    default_value TEXT,
    conditional_logic TEXT, -- JSON
    template_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES form_sections(id) ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES field_templates(id)
);
```

**9. dropdown_options**

```sql
CREATE TABLE dropdown_options (
    id TEXT PRIMARY KEY,
    field_id TEXT NOT NULL,
    label TEXT NOT NULL,
    value TEXT NOT NULL,
    order_index INTEGER NOT NULL,
    FOREIGN KEY (field_id) REFERENCES fields(id) ON DELETE CASCADE
);
```

**10. submissions**

```sql
CREATE TABLE submissions (
    id TEXT PRIMARY KEY,
    form_id TEXT NOT NULL,
    submitted_by TEXT NOT NULL,
    submission_date INTEGER NOT NULL,
    submission_time INTEGER NOT NULL,
    status TEXT DEFAULT 'in_progress',
    completion_percentage REAL DEFAULT 0.0,
    is_auto_submitted INTEGER DEFAULT 0,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    FOREIGN KEY (form_id) REFERENCES forms(id),
    FOREIGN KEY (submitted_by) REFERENCES team(id)
);
```

**11. submission_answers**

```sql
CREATE TABLE submission_answers (
    id TEXT PRIMARY KEY,
    submission_id TEXT NOT NULL,
    field_id TEXT NOT NULL,
    answer_value TEXT,
    file_url TEXT,
    answered_at INTEGER NOT NULL,
    FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    FOREIGN KEY (field_id) REFERENCES fields(id),
    UNIQUE(submission_id, field_id)
);
```

#### Store Manager Specific Tables

**12. field_templates**

```sql
CREATE TABLE field_templates (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    field_type TEXT NOT NULL,
    label TEXT NOT NULL,
    placeholder TEXT,
    help_text TEXT,
    is_required INTEGER DEFAULT 0,
    validation_rules TEXT, -- JSON
    default_value TEXT,
    created_by TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (created_by) REFERENCES team(id)
);
```

**13. form_assignments**

```sql
CREATE TABLE form_assignments (
    id TEXT PRIMARY KEY,
    form_id TEXT NOT NULL,
    assigned_to TEXT,
    field_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES team(id),
    FOREIGN KEY (field_id) REFERENCES fields(id)
);
```

#### Store App Specific Tables

**14. kpi_data**

```sql
CREATE TABLE kpi_data (
    id TEXT PRIMARY KEY,
    data_date INTEGER NOT NULL UNIQUE,
    gem_score REAL,
    hours_scheduled REAL,
    hours_recommended REAL,
    labor_used_percentage REAL,
    sales_actual REAL,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
);
```

**15. goals**

```sql
CREATE TABLE goals (
    id TEXT PRIMARY KEY,
    goal_type TEXT NOT NULL,
    target_value REAL NOT NULL,
    period_date INTEGER NOT NULL,
    created_at INTEGER NOT NULL
);
```

**16. team_schedule**

```sql
CREATE TABLE team_schedule (
    id TEXT PRIMARY KEY,
    schedule_date INTEGER NOT NULL,
    employee_name TEXT NOT NULL,
    shift_start TEXT NOT NULL,
    shift_end TEXT NOT NULL,
    created_at INTEGER NOT NULL
);
```

**17. manager_notes**

```sql
CREATE TABLE manager_notes (
    id TEXT PRIMARY KEY,
    note_date INTEGER NOT NULL,
    note_type TEXT DEFAULT 'general',
    content TEXT NOT NULL,
    created_at INTEGER NOT NULL
);
```

**18. geofence_settings**

```sql
CREATE TABLE geofence_settings (
    id TEXT PRIMARY KEY,
    address TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    radius_meters INTEGER DEFAULT 100,
    enabled INTEGER DEFAULT 1,
    test_mode INTEGER DEFAULT 0
);
```

---

## Central Database (PostgreSQL on NAS)

Same schema as SQLite but with additional features:

- **Timestamps with timezone** support
- **JSON/JSONB** for validation_rules, conditional_logic
- **Full-text search** on forms, fields
- **Indexes** for performance
- **Version tracking** for conflict resolution

**Additional Version Tracking:**

```sql
ALTER TABLE forms ADD COLUMN version INTEGER DEFAULT 1;
ALTER TABLE submissions ADD COLUMN version INTEGER DEFAULT 1;
-- ... (add to all synced tables)
```

---

## Sync Strategy

### 1. Offline-First Approach

- All operations work locally first
- Changes queued in `pending_changes` table
- Sync happens in background when online

### 2. Sync Flow

**Store Manager → Central DB:**

```
1. Create/Edit form locally (SQLite)
2. Add to pending_changes queue
3. Background sync service uploads to NAS
4. NAS validates and stores
5. Returns new version number
6. Update local record with version
7. Remove from pending_changes
```

**Central DB → Store App:**

```
1. Store app checks for assigned forms (on launch/refresh)
2. Request forms newer than last_sync_version
3. Download new/updated forms
4. Store locally in SQLite
5. Update sync_metadata
```

**Store App → Central DB (Submissions):**

```
1. User answers questions (auto-save to SQLite)
2. Each answer queued in pending_changes
3. Background sync uploads answers
4. Partial submissions synced incrementally
5. Final submit sends completion status
```

### 3. Conflict Resolution

**Last Write Wins (LWW):**

- Each record has `updated_at` timestamp
- Conflicts resolved by comparing timestamps
- Server version always wins (Store Manager authoritative)

**For Submissions:**

- Store app can't conflict (only creates/updates own submissions)
- Auto-submitted submissions locked (read-only)

---

## API Endpoints (NAS Server)

### Authentication

```
POST /api/auth/device
- Register device
- Get sync token
```

### Sync Endpoints

```
GET  /api/sync/forms?since={version}
POST /api/sync/forms
PUT  /api/sync/forms/{id}

GET  /api/sync/submissions?since={version}
POST /api/sync/submissions
PUT  /api/sync/submissions/{id}

GET  /api/sync/kpi?date={date}
POST /api/sync/kpi

GET  /api/sync/full
- Full sync (initial or after long offline)
```

### Status Endpoints

```
GET /api/status
- Server health check

GET /api/sync/status
- Check pending syncs
```

---

## Technology Stack

### Local Database (Both Apps)

- **Drift** (Flutter ORM)
  - Type-safe queries
  - Auto-migration
  - Reactive streams
  - Built-in encryption support

### Central Database (NAS)

- **PostgreSQL 16**
  - Reliable, mature
  - JSON support
  - Full-text search
  - Lightweight on NAS

### API Server (NAS)

**Option A: Node.js + Express**

```javascript
- Lightweight
- Easy to deploy
- Good JSON handling
```

**Option B: Python + FastAPI**

```python
- Modern, fast
- Auto-generated docs
- Type hints
- Great for data validation
```

**Recommendation:** FastAPI (Python) for better data validation

---

## Deployment on UGREEN NAS

### Docker Compose Setup

```yaml
version: "3.8"

services:
  postgres:
    image: postgres:16-alpine
    container_name: insight-db
    environment:
      POSTGRES_DB: insight
      POSTGRES_USER: insight
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
      - ./schema.sql:/docker-entrypoint-initdb.d/schema.sql
    ports:
      - "5432:5432"
    restart: unless-stopped

  api:
    image: insight-api:latest
    container_name: insight-api
    environment:
      DATABASE_URL: postgresql://insight:${DB_PASSWORD}@postgres:5432/insight
      SECRET_KEY: ${SECRET_KEY}
    depends_on:
      - postgres
    ports:
      - "8000:8000"
    restart: unless-stopped
    volumes:
      - ./uploads:/app/uploads

  tailscale:
    image: tailscale/tailscale:latest
    container_name: insight-tailscale
    network_mode: host
    privileged: true
    environment:
      - TS_AUTHKEY=${TAILSCALE_KEY}
      - TS_STATE_DIR=/var/lib/tailscale
    volumes:
      - ./data/tailscale:/var/lib/tailscale
    restart: unless-stopped
```

### File Structure on NAS

```
/volume1/docker/insight/
├── docker-compose.yml
├── .env
├── schema.sql
├── data/
│   ├── postgres/
│   └── tailscale/
├── uploads/
└── api/
    ├── Dockerfile
    ├── main.py
    ├── models.py
    ├── routes/
    └── requirements.txt
```

---

## Security

### 1. Network Security

- **Tailscale VPN:** All traffic encrypted
- **No port forwarding:** Only accessible via VPN
- **MagicDNS:** Use `insight-nas` instead of IP

### 2. Data Security

- **Local encryption:** SQLite database encrypted with Drift
- **TLS in transit:** HTTPS for API calls
- **API tokens:** Device-specific auth tokens

### 3. Sensitive Data

- Encrypted fields in database:
  - Team member info
  - Submission answers (if sensitive)
  - KPI data

---

## Performance Optimization

### Indexes

```sql
-- Local SQLite
CREATE INDEX idx_forms_status ON forms(status);
CREATE INDEX idx_forms_tags ON forms(tags);
CREATE INDEX idx_submissions_form_date ON submissions(form_id, submission_date);
CREATE INDEX idx_pending_changes_sync ON pending_changes(synced, created_at);

-- Central PostgreSQL (additional)
CREATE INDEX idx_forms_fulltext ON forms USING GIN(to_tsvector('english', title || ' ' || description));
CREATE INDEX idx_submissions_date_range ON submissions(submission_date) WHERE status = 'completed';
```

### Caching

- **Store Manager:** Cache form templates, field types
- **Store App:** Cache active forms for current period
- **API:** Redis for frequently accessed data (optional)

### Background Sync

- **Exponential backoff** on failures
- **Batch operations** for multiple changes
- **Delta sync** (only changed records)

---

## Migration Strategy

### Phase 1: Local Development (Now)

1. Build apps with SQLite only
2. Mock sync responses
3. Test offline functionality

### Phase 2: NAS Setup (Week 2-3)

1. Deploy PostgreSQL on NAS
2. Create schema
3. Set up Tailscale

### Phase 3: API Development (Week 3-4)

1. Build FastAPI server
2. Implement sync endpoints
3. Test with apps

### Phase 4: Integration (Week 4-5)

1. Connect apps to API
2. Test sync flows
3. Handle edge cases

---

## Backup Strategy

### Automated Backups

```bash
# Daily PostgreSQL backup
0 2 * * * pg_dump insight > /backups/insight_$(date +\%Y\%m\%d).sql

# Weekly full backup
0 3 * * 0 tar -czf /backups/insight_full_$(date +\%Y\%m\%d).tar.gz /volume1/docker/insight/
```

### Retention Policy

- Daily backups: Keep 7 days
- Weekly backups: Keep 4 weeks
- Monthly backups: Keep 6 months

---

## Next Steps

1. ✅ Schema designed
2. 🔜 Implement Drift database in Flutter apps
3. 🔜 Create PostgreSQL schema for NAS
4. 🔜 Build FastAPI sync server
5. 🔜 Set up Tailscale on NAS
6. 🔜 Deploy and test

Ready to start implementing?
