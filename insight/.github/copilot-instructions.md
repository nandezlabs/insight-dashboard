# Insight - AI Coding Agent Instructions

## Project Overview

Insight is a Flutter monorepo for business operations management with two apps: **Store Manager** (form creation/analytics) and **Store** (form completion). Built with Flutter/Dart targeting iOS, Android, and macOS.

## Architecture

### Monorepo Structure (Melos)
```
apps/
├── store_manager/    # Manager app - form builder, scheduling, analytics
└── store/            # Store app - form completion, operations dashboard
packages/
├── insight_core/     # Shared domain logic, models, services, repositories
└── insight_ui/       # Shared UI components and theming
```

**Critical**: All shared code belongs in `packages/`. Apps should primarily compose features using shared packages.

### Core Package Architecture (`packages/insight_core/`)

```
lib/src/
├── models/           # Freezed data classes with JSON serialization
├── repositories/     # Data access layer (Supabase interactions)
├── services/         # Business logic and external integrations
├── constants/        # App-wide constants and configuration
└── utils/            # Extensions, formatters, validators
```

**Key models**: `FormModel` (with nested `FormSection`), `Submission`, `BusinessCalendar`, `TeamMember`, `GeofenceSettings`

## Development Workflows

### Essential Commands

```bash
# Initial setup (run once)
dart pub global activate melos
melos bootstrap

# Development cycle
melos analyze          # Static analysis (runs flutter analyze)
melos format           # Format all code
melos test             # Run all tests
melos clean && melos bootstrap  # Reset dependencies

# Running apps
cd apps/store_manager && flutter run
cd apps/store && flutter run

# Building
melos build:ios        # Build iOS (requires ios/ dir)
melos build:android    # Build Android (requires android/ dir)
melos build:macos      # Build macOS (requires macos/ dir)
```

### Code Generation

This project uses **Freezed** and **json_serializable** for immutable models with JSON serialization. Whenever you modify models in `packages/insight_core/lib/src/models/`:

```bash
cd packages/insight_core
flutter pub run build_runner build --delete-conflicting-outputs
```

**Pattern**: All model classes use `@freezed` annotation and generate `.freezed.dart` and `.g.dart` files.

## Tech Stack & Patterns

### State Management: Riverpod
- Use Riverpod providers for state management (not yet visible in scanned files, but per README)
- Follow standard Riverpod patterns for dependency injection

### Routing: Go Router
- Declarative routing configuration (not yet visible, but per README)
- Named routes for navigation

### Local Storage: Drift (SQLite)
- Encrypted local storage using Drift
- Database name: `insight.db` (see `AppConstants.databaseName`)
- **Security**: AES-256 encryption via `EncryptionService`

### Backend: Supabase
- PostgreSQL with Real-time subscriptions
- Row Level Security (RLS) enforced
- All backend calls through repositories in `insight_core`

## Critical Domain Concepts

### Business Calendar System
Custom calendar with Week/Period/Quarter tracking:
- **Week**: 7 days
- **Period**: 4 weeks (13 periods/year, not 12 months)
- **Quarter**: 3 periods

Models: `BusinessCalendar`, `BusinessPeriod` (see `business_calendar.dart`)
Service: `BusinessCalendarService`

### Form Scheduling System
Forms use tag-based or custom scheduling:
- **Tags**: `daily`, `weekly`, `period`, `operations`, `main` (see `FormConstants`)
- **Schedule types**: `tagBased`, `custom`, `manual` (enum `FormScheduleType`)
- **Statuses**: `active`, `archived`, `draft` (enum `FormStatus`)

Service: `FormSchedulerService`

### Field Types
Three categories (see `FormConstants`):
- **Basic**: `short_text`, `long_text`, `number`, `date`, `time`
- **Selection**: `dropdown`, `radio`, `checkbox`
- **Advanced**: `email`, `phone`, `file`

Validation constants: `defaultMaxTextLength` (500), `defaultMaxLongTextLength` (5000)

### Geofencing
Location-based access control with configurable radius:
- Default radius: 100 meters (`AppConstants.defaultGeofenceRadius`)
- Update interval: 5 seconds
- Model: `GeofenceSettings`
- Service: `GeofenceService`

### Auto-Save & Submission
- Auto-save debounce: 500ms (`FormConstants.autoSaveDebounceMs`)
- Submission timeout: 30 minutes
- No response default: "No Response" (`AppConstants.noResponseText`)

## Security Requirements

1. **Encryption**: All sensitive data encrypted with AES-256 via `EncryptionService`
   - Key stored in Flutter Secure Storage
   - See `packages/insight_core/lib/src/services/encryption_service.dart`

2. **Geofencing**: Location validation before form access (Store app)

3. **TLS**: All network calls use HTTPS/TLS 1.3

4. **RLS**: Supabase Row Level Security enforced on all tables

## Code Conventions

### Import Organization
1. Dart/Flutter imports
2. Third-party packages
3. Local package imports (relative paths)

### Barrel Files
Use barrel files (`models.dart`, `services.dart`, `repositories.dart`) for clean imports:
```dart
export 'form.dart';
export 'submission.dart';
// etc.
```

### Model Pattern (Freezed)
```dart
@freezed
class FormModel with _$FormModel {
  const factory FormModel({
    required String id,
    required String title,
    @Default([]) List<String> tags,
    // ...
  }) = _FormModel;

  factory FormModel.fromJson(Map<String, dynamic> json) =>
      _$FormModelFromJson(json);
}
```

**Always** include both `part` directives:
```dart
part 'form.freezed.dart';
part 'form.g.dart';
```

### Environment Configuration
Both apps require `.env` files (see `.env.example` in each app if available). Manage Supabase credentials and API keys there.

## Integration Points

- **Weather API**: `WeatherService` for store operations dashboard
- **Supabase Real-time**: Listen for form/submission updates
- **Supabase Storage**: File uploads for file field types
- **Flutter Secure Storage**: Encrypted credential storage

## Common Tasks

**Adding a new model:**
1. Create in `packages/insight_core/lib/src/models/`
2. Use `@freezed` with JSON serialization
3. Export in `models.dart` barrel file
4. Run `build_runner` in `insight_core`

**Adding a new service:**
1. Create in `packages/insight_core/lib/src/services/`
2. Export in `services.dart`
3. Inject via Riverpod provider (when creating providers)

**Adding a new repository:**
1. Create in `packages/insight_core/lib/src/repositories/`
2. Export in `repositories.dart`
3. Use Supabase client for data access

**Modifying business logic:**
- Core logic belongs in `packages/insight_core/lib/src/services/`
- Data access belongs in repositories
- UI logic stays in app-specific directories

## Testing

- Test files mirror `lib/` structure in `test/` directories
- Run all tests: `melos test`
- Package-specific: `cd packages/insight_core && flutter test`

---

*Generated: Dec 2025 | Project size: ~45 Dart files | Flutter 3.24.0+*
