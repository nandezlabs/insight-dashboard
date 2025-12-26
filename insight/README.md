# Insight

A powerful business operations management system with form creation and completion capabilities.

## Project Structure

```
insight/
├── apps/
│   ├── store_manager/    # Manager app for form creation and analytics
│   └── store/            # Store app for form completion
├── backend/              # FastAPI server for NAS deployment
├── packages/
│   ├── insight_core/     # Shared business logic and data models
│   └── insight_ui/       # Shared UI components and themes
├── supabase/             # Database schema and setup
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
- **Backend**: FastAPI (Python) + PostgreSQL on UGREEN NAS
- **Networking**: Tailscale VPN for secure remote access
- **State Management**: Riverpod
- **Routing**: Go Router
- **Local Storage**: Drift (SQLite) with encryption
- **Monorepo**: Melos
- **Deployment**: Docker + Docker Compose

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

````bash
melos bootstrap
```Set up backend on your NAS (see `backend/DEPLOYMENT.md`)

4. Create `.env` files in both apps with your Tailscale IP

5. Run the apps:

```bash
# Store Manager
cd apps/store_manager && flutter run

# Store
cd apps/store && flutter run
````

### Backend Deployment

Deploy the FastAPI backend on your UGREEN NAS:

```bash
cd backend

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Deploy with one command
./deploy.sh
```

See [backend/DEPLOYMENT.md](backend/DEPLOYMENT.md) for detailed instructions.tore
cd apps/store && flutter run

````

## Development

### Available Scripts

```bash
melos analyze      # Run static analysis
melos format       # Format all code
melos test         # Run all tests
melos clean        # Clean all packages
melos get          # Get dependencies
````

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
