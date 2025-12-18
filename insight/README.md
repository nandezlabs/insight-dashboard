# Insight

A powerful business operations management system with form creation and completion capabilities.

## Project Structure

```
insight/
├── apps/
│   ├── store_manager/    # Manager app for form creation and analytics
│   └── store/            # Store app for form completion
├── packages/
│   ├── insight_core/     # Shared business logic and data models
│   └── insight_ui/       # Shared UI components and themes
└── melos.yaml           # Monorepo configuration
```

## Features

### Store Manager
- Drag-and-drop form builder with multi-level templates
- Business calendar tracking (Week/Period/Quarter)
- Real-time progress monitoring
- Advanced scheduling and assignment system
- Analytics dashboard with KPIs

### Store
- Intuitive form completion interface
- Auto-save functionality
- Operations dashboard with today's metrics
- Weather integration and team schedule
- Geofencing security

## Tech Stack

- **Framework**: Flutter (iOS, Android, macOS)
- **Backend**: Supabase (PostgreSQL, Real-time, Storage)
- **State Management**: Riverpod
- **Routing**: Go Router
- **Local Storage**: Drift (SQLite) with encryption
- **Monorepo**: Melos

## Getting Started

### Prerequisites

- Flutter SDK 3.24.0+
- Dart 3.5.0+
- Xcode (for iOS/macOS)
- Android Studio (for Android)
- Melos CLI

### Setup

1. Install Melos:
```bash
dart pub global activate melos
```

2. Bootstrap the project:
```bash
melos bootstrap
```

3. Create `.env` files in both apps (see `.env.example`)

4. Run the apps:
```bash
# Store Manager
cd apps/store_manager && flutter run

# Store
cd apps/store && flutter run
```

## Development

### Available Scripts

```bash
melos analyze      # Run static analysis
melos format       # Format all code
melos test         # Run all tests
melos clean        # Clean all packages
melos get          # Get dependencies
```

### Building

```bash
melos build:ios      # Build iOS apps
melos build:android  # Build Android apps
melos build:macos    # Build macOS apps
```

## Security

- AES-256 encryption for sensitive data
- Geofencing for location-based access control
- Row Level Security (RLS) in Supabase
- HTTPS/TLS 1.3 for all communications
- Encrypted local storage

## License

Private - All Rights Reserved
