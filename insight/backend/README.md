# Insight Backend API

FastAPI server for the Insight business management system, designed to run on your UGREEN NAS with Tailscale.

## Features

- 🚀 **FastAPI** - Modern, fast Python web framework
- 🐘 **PostgreSQL** - Robust database for central storage
- 🔄 **Bidirectional Sync** - Keep mobile apps and manager in sync
- 🔒 **Tailscale VPN** - Secure remote access
- 🐳 **Docker** - Easy deployment and management

## Architecture

```
┌─────────────────────────────────────┐
│         UGREEN NAS                  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   PostgreSQL Database       │   │
│  │   (Port 5432)               │   │
│  └─────────────────────────────┘   │
│              ↕                      │
│  ┌─────────────────────────────┐   │
│  │   FastAPI Server            │   │
│  │   (Port 8000)               │   │
│  │   - Sync endpoints          │   │
│  │   - Data validation         │   │
│  │   - Conflict resolution     │   │
│  └─────────────────────────────┘   │
│              ↕                      │
│  ┌─────────────────────────────┐   │
│  │   Tailscale                 │   │
│  │   (VPN Access)              │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

## Prerequisites

- UGREEN NAS with Docker support
- Tailscale account and auth key
- Python 3.11+ (for local development)

## Quick Start (Development)

```bash
# Install dependencies
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Set up environment
cp .env.example .env
# Edit .env with your settings

# Run migrations
alembic upgrade head

# Start server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

API will be available at: http://localhost:8000
API docs at: http://localhost:8000/docs

## Deployment Options

### Hostinger VPS (Recommended) ⭐

**Quick Start**: [HOSTINGER_QUICKSTART.md](./HOSTINGER_QUICKSTART.md)  
**Full Guide**: [HOSTINGER_DEPLOYMENT.md](./HOSTINGER_DEPLOYMENT.md)

Deploy to Hostinger VPS with Docker, PostgreSQL, and SSL in 15 minutes:

```bash
# On your Hostinger VPS
git clone https://github.com/yourusername/insight.git /opt/insight
cd /opt/insight/backend
cp .env.production .env
# Edit .env with your settings
./setup-nginx.sh
./deploy-hostinger.sh
```

**Cost**: $5.99-$23.99/month | **Setup Time**: 15 mins

### UGREEN NAS (Legacy)

See [DEPLOYMENT.md](./DEPLOYMENT.md) for NAS deployment with Tailscale VPN.

Quick deploy:

```bash
# On your NAS
cd insight/backend
docker-compose up -d
```

## API Endpoints

### Health & Status

- `GET /health` - Server health check
- `GET /api/v1/status` - Database status and version

### Sync

- `POST /api/v1/sync/pull` - Pull changes from server
- `POST /api/v1/sync/push` - Push changes to server
- `POST /api/v1/sync/conflict` - Resolve sync conflicts

### Forms

- `GET /api/v1/forms` - List all forms
- `GET /api/v1/forms/{id}` - Get form details
- `POST /api/v1/forms` - Create form
- `PUT /api/v1/forms/{id}` - Update form
- `DELETE /api/v1/forms/{id}` - Delete form

### Submissions

- `GET /api/v1/submissions` - List submissions
- `GET /api/v1/submissions/{id}` - Get submission
- `POST /api/v1/submissions` - Create submission
- `PUT /api/v1/submissions/{id}` - Update submission

### KPIs & Goals

- `GET /api/v1/kpis` - Get KPI data
- `POST /api/v1/kpis` - Update KPI data
- `GET /api/v1/goals` - Get goals
- `POST /api/v1/goals` - Set goals

### Team

- `GET /api/v1/team` - List team members
- `POST /api/v1/team` - Add team member
- `PUT /api/v1/team/{id}` - Update member
- `DELETE /api/v1/team/{id}` - Remove member

## Environment Variables

```bash
# Database
DATABASE_URL=postgresql://insight:password@postgres:5432/insight

# API
SECRET_KEY=your-secret-key-here
API_VERSION=v1
CORS_ORIGINS=*  # Comma-separated list

# Tailscale (for Docker)
TAILSCALE_AUTH_KEY=tskey-auth-xxxxx

# Optional
DEBUG=false
LOG_LEVEL=info
MAX_UPLOAD_SIZE=10485760  # 10MB in bytes
```

## Development

```bash
# Format code
black app/
isort app/

# Lint
pylint app/
mypy app/

# Test
pytest

# Create migration
alembic revision --autogenerate -m "Description"

# Apply migration
alembic upgrade head
```

## Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app initialization
│   ├── config.py            # Configuration settings
│   ├── database.py          # Database connection
│   ├── models/              # SQLAlchemy models
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── form.py
│   │   ├── submission.py
│   │   └── ...
│   ├── schemas/             # Pydantic schemas
│   │   ├── __init__.py
│   │   ├── form.py
│   │   └── ...
│   ├── api/                 # API endpoints
│   │   ├── __init__.py
│   │   ├── deps.py          # Dependencies
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── forms.py
│   │       ├── sync.py
│   │       └── ...
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   ├── sync_service.py
│   │   └── ...
│   └── utils/
│       ├── __init__.py
│       └── helpers.py
├── alembic/                 # Database migrations
│   ├── versions/
│   └── env.py
├── tests/
│   ├── __init__.py
│   └── test_api.py
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── .env.example
└── README.md
```

## Security

- All API endpoints are accessible only through Tailscale VPN
- No public internet exposure required
- Database credentials stored in environment variables
- File uploads validated and size-limited

## Monitoring

View logs:

```bash
docker-compose logs -f api
docker-compose logs -f postgres
```

## Troubleshooting

### Can't connect to database

- Check PostgreSQL is running: `docker-compose ps`
- Verify credentials in `.env`
- Check container logs: `docker-compose logs postgres`

### Tailscale not connecting

- Verify auth key is valid
- Check Tailscale container: `docker-compose logs tailscale`
- Restart Tailscale: `docker-compose restart tailscale`

### API returning errors

- Check API logs: `docker-compose logs -f api`
- Verify database migrations: `docker-compose exec api alembic current`
- Run migrations: `docker-compose exec api alembic upgrade head`

## Support

For issues or questions, check the main project README.
