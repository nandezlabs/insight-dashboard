# Backend Integration Guide

Quick guide to integrate the Flutter apps with the NAS backend.

## Current Status ✅

### Backend (Complete)

- ✅ FastAPI server with PostgreSQL
- ✅ Bidirectional sync endpoints
- ✅ Docker deployment ready
- ✅ Tailscale VPN configuration
- ✅ Comprehensive documentation

### Flutter (In Progress)

- ✅ ApiClient configured with Dio
- ✅ SyncService with conflict resolution
- ✅ Sync models (Freezed generated)
- ✅ Repository structure
- ⏳ Local database (Drift tables needed)
- ⏳ Background sync scheduler
- ⏳ Repository offline support

## Quick Start

### 1. Deploy Backend to NAS

```bash
# On your NAS
cd /path/to/insight/backend
cp .env.example .env

# Edit .env with:
# - DB_PASSWORD (strong password)
# - SECRET_KEY (run: openssl rand -hex 32)
# - TAILSCALE_AUTH_KEY (from tailscale.com)

./deploy.sh
```

### 2. Get Your Tailscale IP

```bash
docker-compose exec tailscale tailscale ip
# Example output: 100.64.123.45
```

### 3. Configure Flutter Apps

**Store Manager** (`apps/store_manager/lib/main.dart`):

```dart
import 'package:insight_core/insight_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client with your Tailscale IP
  ApiClient.initialize(
    baseUrl: 'http://100.64.123.45:8000/api/v1',
  );

  // Initialize sync service
  final syncService = SyncService();
  syncService.startAutoSync(); // Sync every 5 minutes

  runApp(const StoreManagerApp());
}
```

**Store** (`apps/store/lib/main.dart`):

```dart
import 'package:insight_core/insight_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client
  ApiClient.initialize(
    baseUrl: 'http://100.64.123.45:8000/api/v1',
  );

  // Initialize sync service (Store app only needs specific tables)
  final syncService = SyncService();
  syncService.startAutoSync();

  runApp(const StoreApp());
}
```

### 4. Install Tailscale on Devices

**iOS/Android:**

1. Install Tailscale from App Store/Play Store
2. Sign in with your account
3. Connect to VPN

**macOS:**

1. Download from tailscale.com/download
2. Install and sign in
3. Enable at startup

### 5. Test Integration

```dart
// Example: Manual sync
final syncService = SyncService();
final result = await syncService.performSync();

if (result.success) {
  print('Synced ${result.pulledChanges} from server');
  print('Pushed ${result.pushedChanges} to server');
} else {
  print('Sync failed: ${result.message}');
}
```

## Usage Examples

### Using SyncService

```dart
import 'package:insight_core/insight_core.dart';

class MyDataScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              final syncService = SyncService();
              final result = await syncService.performSync();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.message ?? 'Sync completed'),
                  backgroundColor: result.success ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final syncService = SyncService();
          await syncService.performSync();
        },
        child: YourListView(),
      ),
    );
  }
}
```

### Checking Sync Status

```dart
final syncService = SyncService();

// Check if sync is in progress
if (syncService.isSyncing) {
  print('Sync already running...');
  return;
}

// Get server status
final status = await syncService.getServerStatus();
if (status != null) {
  print('Server version: ${status.version}');
  print('Available tables: ${status.tables}');
}
```

### Handling Conflicts

```dart
final result = await syncService.performSync();

if (result.hasConflicts) {
  // Show conflicts to user
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Sync Conflicts'),
      content: Text(
        'Found ${result.conflicts!.length} conflicts.\n'
        'These will be resolved automatically.',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await syncService.resolveConflicts(result.conflicts!);
            Navigator.pop(context);
          },
          child: Text('Resolve'),
        ),
      ],
    ),
  );
}
```

## Next Steps

### TODO: Local Database Setup

Create Drift tables for local SQLite storage:

**File:** `packages/insight_core/lib/src/database/database.dart`

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Define tables
class SyncMetadataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text()();
  DateTimeColumn get lastSyncAt => dateTime()();
  IntColumn get lastSyncVersion => integer().withDefault(const Constant(0))();
}

class PendingChangesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // INSERT, UPDATE, DELETE
  TextColumn get data => text()(); // JSON
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [SyncMetadataTable, PendingChangesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'insight.db'));
      return NativeDatabase(file);
    });
  }
}
```

### TODO: Background Sync

Add WorkManager for periodic background sync:

```yaml
# pubspec.yaml
dependencies:
  workmanager: ^0.5.2
```

```dart
// Initialize in main()
await Workmanager().initialize(callbackDispatcher);
await Workmanager().registerPeriodicTask(
  'sync-task',
  'syncData',
  frequency: Duration(minutes: 15),
);

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final syncService = SyncService();
    await syncService.performSync();
    return Future.value(true);
  });
}
```

### TODO: Repository Updates

Update repositories to use local database:

```dart
class FormRepository {
  final AppDatabase _db;

  Future<List<FormModel>> getForms() async {
    // 1. Try to get from local DB first
    final localForms = await _db.getAllForms();

    // 2. Trigger background sync
    SyncService().performSync(tables: ['forms']);

    return localForms;
  }

  Future<void> createForm(FormModel form) async {
    // 1. Save to local DB
    await _db.insertForm(form);

    // 2. Add to pending changes queue
    await _db.addPendingChange(
      PendingChange(
        tableName: 'forms',
        recordId: form.id,
        operation: PendingOperation.insert,
        data: form.toJson(),
        createdAt: DateTime.now(),
      ),
    );

    // 3. Trigger immediate sync
    await SyncService().performSync(tables: ['forms']);
  }
}
```

## Testing

### Test Backend Connection

```bash
# Health check
curl http://100.64.123.45:8000/health

# Sync status
curl http://100.64.123.45:8000/api/v1/sync/status

# Test pull sync
curl -X POST http://100.64.123.45:8000/api/v1/sync/pull \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "test-device",
    "last_sync_timestamp": null,
    "tables": ["forms", "team"]
  }'
```

### Test Flutter Integration

```dart
// In your test file
testWidgets('Sync service works', (tester) async {
  final syncService = SyncService();

  // Test device ID generation
  final deviceId = await syncService.deviceId;
  expect(deviceId, isNotEmpty);

  // Test sync
  final result = await syncService.performSync(
    tables: ['forms'],
  );

  expect(result.success, isTrue);
});
```

## Troubleshooting

### Can't connect to backend

- ✅ Check Tailscale is running on both NAS and device
- ✅ Verify both devices show in Tailscale admin console
- ✅ Ping the NAS: `ping 100.64.123.45`
- ✅ Check backend is running: `docker-compose ps`

### Sync fails

- ✅ Check internet connection
- ✅ View API logs: `docker-compose logs -f api`
- ✅ Enable debug mode in ApiClient
- ✅ Check for pending changes in local DB

### Conflicts not resolving

- ✅ Verify conflict resolution logic in SyncService
- ✅ Check server response for conflict details
- ✅ Manually accept server version if needed

## Architecture Summary

```
┌─────────────────────────────────────────────┐
│           Flutter App (Offline-First)       │
│                                             │
│  ┌─────────────┐      ┌─────────────────┐  │
│  │ UI Layer    │ ───> │ Repositories    │  │
│  └─────────────┘      └─────────────────┘  │
│                              │              │
│                              ↓              │
│                    ┌──────────────────┐     │
│                    │ Local SQLite DB  │     │
│                    │ (Drift)          │     │
│                    └──────────────────┘     │
│                              │              │
│                              ↓              │
│                    ┌──────────────────┐     │
│                    │ SyncService      │     │
│                    │ - Queue changes  │     │
│                    │ - Auto sync      │     │
│                    │ - Conflicts      │     │
│                    └──────────────────┘     │
└──────────────────────────┬──────────────────┘
                           │ Tailscale VPN
                           ↓
┌──────────────────────────────────────────────┐
│              NAS Backend                     │
│  ┌────────────┐         ┌────────────────┐  │
│  │ FastAPI    │ ──────> │ PostgreSQL     │  │
│  │ (Docker)   │         │ (Docker)       │  │
│  └────────────┘         └────────────────┘  │
└──────────────────────────────────────────────┘
```

## Resources

- **Backend API Docs:** http://100.64.123.45:8000/docs
- **Deployment Guide:** [backend/DEPLOYMENT.md](../backend/DEPLOYMENT.md)
- **Sync Architecture:** [docs/SYNC_ARCHITECTURE.md](./SYNC_ARCHITECTURE.md)
- **Database Schema:** [docs/database/local-database-architecture.md](./database/local-database-architecture.md)

---

**Status:** Backend is ready for deployment. Flutter integration requires local database setup (Drift tables) and repository updates for offline-first operation.
