# Insight Dashboard

A full-stack web dashboard for single-store inventory management with mobile-first design, offline capability, and comprehensive monitoring.

## 🚀 Features

- **Dynamic Forms**: Auto-save, scheduled submission, file attachments with FormIO.js
- **Data Visualization**: Interactive charts with Recharts
- **Mobile-First**: Responsive design optimized for tablets and phones
- **Offline Capable**: 7-day cache with automatic sync
- **Export Tools**: CSV, Excel, PDF generation
- **Analytics**: Form completion tracking and abandonment analysis
- **Alert System**: Real-time notifications with email summaries
- **Monitoring**: Sentry integration with in-app error logs

## 📚 Tech Stack

### Frontend
- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript
- **UI Framework**: Refine (headless) + Tailwind CSS
- **Charts**: Recharts
- **Forms**: FormIO.js
- **State**: React Query (via Refine)

### Backend
- **Framework**: Python FastAPI
- **Database**: Supabase PostgreSQL
- **Storage**: Supabase Storage
- **Cache**: SQLite (optional, 7-day)

### Infrastructure
- **Hosting**: Hostinger VPS (2GB RAM)
- **Web Server**: Nginx
- **SSL**: Let's Encrypt
- **CI/CD**: GitHub Actions
- **Monitoring**: Sentry
- **Email**: SMTP (Gmail/SendGrid)

## 🏗️ Project Structure

```
insight/
├── frontend/           # Next.js application
│   ├── app/           # App Router pages
│   ├── components/    # React components
│   ├── lib/           # Utilities and clients
│   └── public/        # Static assets
├── backend/           # Python FastAPI
│   ├── api/           # API routes
│   ├── services/      # Business logic
│   ├── models/        # Database models
│   └── tests/         # Test suite
├── docs/              # Documentation
├── scripts/           # Deployment scripts
└── .github/           # CI/CD workflows
```

## 🛠️ Setup

See [docs/SETUP.md](docs/SETUP.md) for detailed setup instructions.

### Quick Start

1. **Clone and install dependencies**:
   ```bash
   git clone https://github.com/yourusername/insight.git
   cd insight
   
   # Frontend
   cd frontend
   npm install
   
   # Backend
   cd ../backend
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase credentials
   ```

3. **Run development servers**:
   ```bash
   # Frontend (terminal 1)
   cd frontend
   npm run dev
   
   # Backend (terminal 2)
   cd backend
   uvicorn main:app --reload
   ```

## 📖 Documentation

- [Setup Guide](docs/SETUP.md) - Complete installation instructions
- [Environment Variables](docs/ENV.md) - Configuration reference
- [Backup Procedures](docs/BACKUP.md) - Backup and restore guide
- [Disaster Recovery](docs/DISASTER_RECOVERY.md) - Recovery procedures

## 🧪 Testing

```bash
# Backend tests
cd backend
pytest

# Frontend tests
cd frontend
npm test

# E2E tests
npm run test:e2e
```

## 🚀 Deployment

See [docs/SETUP.md](docs/SETUP.md#deployment) for production deployment.

```bash
# Deploy to staging
git push origin staging

# Deploy to production
git push origin main
```

## 📊 Monitoring

- **Error Tracking**: Sentry dashboard at sentry.io
- **Health Check**: https://your-domain.com/api/health
- **Alert Center**: In-app bell icon for system alerts

## 🔒 Security

- HTTPS enforced via Let's Encrypt
- Basic authentication via Nginx
- Supabase Row Level Security enabled
- Environment variables for sensitive data
- Regular security updates via Dependabot

## 📝 License

MIT

## 👤 Author

Built for single-store inventory management.
