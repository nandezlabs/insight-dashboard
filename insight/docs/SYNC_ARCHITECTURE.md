# Sync System Architecture

## Overview

The Insight sync system provides bidirectional data synchronization between Flutter apps and the NAS backend, enabling offline-first operation with automatic conflict resolution.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Apps                          │
│  (Store Manager & Store)                                │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Local SQLite Database (Drift)                   │   │
│  │  - Forms, submissions, KPIs                      │   │
│  │  - Offline-first storage                         │   │
│  └──────────────────────────────────────────────────┘   │
│                      ↕                                   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Sync Service (Dart)                             │   │
│  │  - Detects local changes                         │   │
│  │  - Handles conflict resolution                   │   │
│  │  - Queues offline changes                        │   │
│  └──────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────┘
                         │ HTTP/JSON over Tailscale
                         ↕
┌────────────────────────┴────────────────────────────────┐
│              NAS Backend (FastAPI)                      │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Sync Endpoints                                   │   │
│  │  - POST /sync/pull  (get server changes)         │   │
│  │  - POST /sync/push  (send client changes)        │   │
│  └──────────────────────────────────────────────────┘   │
│                      ↕                                   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  PostgreSQL Database                             │   │
│  │  - Central source of truth                       │   │
│  │  - Full audit trail                              │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Sync Protocol

### 1. Pull Sync (Server → Client)

**Client Request:**

```json
POST /api/v1/sync/pull
{
  "device_id": "store-manager-mac-001",
  "last_sync_timestamp": "2025-12-18T10:30:00Z",
  "tables": ["forms", "submissions", "team", "kpi_data"]
}
```

**Server Response:**

```json
{
  "success": true,
  "timestamp": "2025-12-18T11:00:00Z",
  "changes": {
    "forms": [
      {
        "id": "uuid-1",
        "title": "Updated Form",
        "updated_at": "2025-12-18T10:45:00Z",
        ...
      }
    ],
    "submissions": [...],
    ...
  },
  "conflicts": null
}
```

### 2. Push Sync (Client → Server)

**Client Request:**

```json
POST /api/v1/sync/push
{
  "device_id": "store-iphone-001",
  "timestamp": "2025-12-18T11:00:00Z",
  "changes": {
    "submissions": [
      {
        "id": "uuid-2",
        "form_id": "uuid-1",
        "status": "completed",
        "updated_at": "2025-12-18T10:50:00Z",
        ...
      }
    ],
    "submission_answers": [...]
  }
}
```

**Server Response:**

```json
{
  "success": true,
  "timestamp": "2025-12-18T11:00:05Z",
  "applied": {
    "submissions": [...],
    "submission_answers": [...]
  },
  "conflicts": [
    {
      "table": "submissions",
      "record_id": "uuid-2",
      "client_data": {...},
      "server_data": {...}
    }
  ]
}
```

## Conflict Resolution Strategy

### Conflict Detection

A conflict occurs when:

1. Same record modified on both client and server
2. Server's `updated_at` > client's sync timestamp
3. Different field values

### Resolution Rules

**Priority Order:**

1. **Store Manager wins** - For forms, templates, settings
2. **Latest timestamp wins** - For submissions, KPIs
3. **Server wins** - When in doubt (prevents data loss)

**Specific Cases:**

| Data Type   | Rule         | Reason                      |
| ----------- | ------------ | --------------------------- |
| Forms       | Manager wins | Only manager edits forms    |
| Submissions | Latest wins  | Most recent data is correct |
| KPIs        | Latest wins  | Always use newest data      |
| Team        | Server wins  | Prevent duplicates          |
| Settings    | Manager wins | Manager controls config     |

### Conflict Handling in Client

```dart
// Example Flutter implementation
class SyncService {
  Future<void> handleConflicts(List<Conflict> conflicts) async {
    for (var conflict in conflicts) {
      switch (conflict.table) {
        case 'forms':
          // Manager wins - keep client version
          await keepClientVersion(conflict);
          break;

        case 'submissions':
          // Latest wins - compare timestamps
          if (conflict.clientData.updatedAt.isAfter(
              conflict.serverData.updatedAt)) {
            await retryPush(conflict);
          } else {
            await acceptServerVersion(conflict);
          }
          break;

        default:
          // Server wins by default
          await acceptServerVersion(conflict);
      }
    }
  }
}
```

## Sync Triggers

### Automatic Sync

- **On app startup** - Full sync
- **Every 5 minutes** - Background pull sync
- **On network reconnect** - Resume pending syncs
- **After form submission** - Immediate push

### Manual Sync

- Pull-to-refresh gesture
- "Sync Now" button in settings
- After conflict resolution

## Offline Support

### Queuing Changes

```dart
// Local SQLite table for tracking pending changes
CREATE TABLE pending_changes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE'
    data TEXT,                 -- JSON
    created_at INTEGER NOT NULL,
    synced INTEGER DEFAULT 0
);
```

### Sync Queue Processing

1. **Network available?**

   - Yes → Process queue
   - No → Keep queuing

2. **Process oldest first**

   - Maintain order of operations
   - Group by table for efficiency

3. **Handle failures**
   - Retry with exponential backoff
   - Max 5 retries
   - Alert user after 5 failures

## Data Flow Examples

### Example 1: Create New Form (Manager)

```
1. Manager creates form
   → Save to local SQLite
   → Add to pending_changes queue

2. Background sync triggers
   → POST /sync/push with form data
   → Server saves to PostgreSQL
   → Server returns success

3. Manager receives confirmation
   → Mark as synced in pending_changes
   → Update local sync_metadata

4. Store app pulls changes
   → GET /sync/pull
   → Receives new form
   → Updates local SQLite
```

### Example 2: Complete Submission (Store)

```
1. Employee completes form
   → Auto-save to local SQLite
   → Status: in_progress

2. Employee hits submit
   → Status: completed
   → Add to pending_changes

3. Immediate sync triggered
   → POST /sync/push
   → Server validates and saves
   → Returns success

4. Manager app pulls
   → Sees new completion
   → Updates analytics
```

### Example 3: Offline Submission

```
1. Employee offline
   → Complete form locally
   → Queue in pending_changes

2. Continue working
   → More forms queued

3. Network restored
   → Auto-sync triggered
   → Process queue in order
   → POST /sync/push for each

4. All synced
   → Clear queue
   → Update sync_metadata
```

## Performance Optimization

### Delta Sync

Only sync records modified since last sync:

```sql
-- Server query
SELECT * FROM forms
WHERE updated_at > :last_sync_timestamp;
```

### Batch Operations

Group multiple changes:

```json
{
  "changes": {
    "submissions": [record1, record2, record3],
    "submission_answers": [ans1, ans2, ans3, ans4]
  }
}
```

### Compression

For large payloads, enable gzip compression:

```dart
// Dio client configuration
dio.options.headers['Accept-Encoding'] = 'gzip';
```

### Selective Sync

Only sync needed tables:

```dart
// Store app doesn't need form_templates
final storeTables = ['forms', 'submissions', 'team', 'kpi_data'];

// Manager needs everything
final managerTables = ['forms', 'form_sections', 'fields', ...];
```

## Monitoring & Debugging

### Sync Status Endpoint

```bash
GET /api/v1/sync/status
```

```json
{
  "status": "online",
  "timestamp": "2025-12-18T11:00:00Z",
  "version": "1.0.0",
  "tables": ["forms", "submissions", ...],
  "active_devices": 3,
  "last_sync": {
    "store-manager-mac": "2025-12-18T10:55:00Z",
    "store-iphone-001": "2025-12-18T10:58:00Z",
    "store-iphone-002": "2025-12-18T10:59:00Z"
  }
}
```

### Client Logging

```dart
// Log sync operations
logger.info('Sync started: $deviceId');
logger.debug('Pulling tables: $tables');
logger.info('Received ${changes.length} changes');
logger.error('Sync failed: $error');
```

### Server Logging

```python
# FastAPI logging
logger.info(f"Sync pull: device={device_id} tables={tables}")
logger.warning(f"Conflict detected: {conflict}")
logger.error(f"Sync failed: {error}")
```

## Testing

### Sync Scenarios to Test

1. ✅ Full sync from scratch
2. ✅ Delta sync with changes
3. ✅ Conflict resolution
4. ✅ Offline queue processing
5. ✅ Network interruption during sync
6. ✅ Large data sets (100+ records)
7. ✅ Concurrent device syncs
8. ✅ Sync retry after failure

### Test Tools

```bash
# Simulate offline mode
curl -X POST http://localhost:8000/api/v1/sync/push \
  -H "Content-Type: application/json" \
  -d @test_data/push_payload.json

# Check sync status
curl http://localhost:8000/api/v1/sync/status
```

## Future Enhancements

- [ ] Real-time sync via WebSockets
- [ ] Partial record sync (field-level)
- [ ] Automatic conflict resolution with AI
- [ ] Sync analytics dashboard
- [ ] Multi-user collaboration features

---

For implementation details, see:

- Backend: `backend/app/services/sync_service.py`
- Flutter: `packages/insight_core/lib/src/services/sync_service.dart` (to be created)
