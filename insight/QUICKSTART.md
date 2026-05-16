# Quick Start Guide

Get the Insight Dashboard running locally in under 10 minutes!

## Prerequisites

- Node.js 20+ installed
- Python 3.11+ installed
- Supabase account (free tier)
- Git installed

## Step 1: Create Supabase Project (3 minutes)

1. Go to [supabase.com](https://supabase.com/dashboard) and create a new project
2. Name it "Insight" and choose a region close to you
3. Wait for project initialization (~2 minutes)
4. Go to **Settings → API** and copy:
   - Project URL
   - `anon` public key
   - `service_role` secret key

## Step 2: Setup Database (2 minutes)

1. In Supabase Dashboard, go to **SQL Editor**
2. Open the file `backend/database/schema.sql`
3. Copy all contents and paste into SQL Editor
4. Click **Run** - this creates all 8 tables with indexes
5. Verify in **Database → Tables** that tables were created

## Step 3: Configure Environment (1 minute)

```bash
# In project root
cp .env.example .env

# Edit .env and add your Supabase credentials:
# NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
# SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## Step 4: Start Frontend (2 minutes)

```bash
cd frontend

# Copy environment file
cp ../.env .env.local

# Install dependencies (only first time)
npm install

# Start development server
npm run dev
```

Frontend will start at: http://localhost:3000

## Step 5: Start Backend (2 minutes)

Open a **new terminal**:

```bash
cd backend

# Create virtual environment (only first time)
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies (only first time)
pip install -r requirements.txt

# Copy environment file
cp ../.env .env

# Start development server
uvicorn main:app --reload --port 8000
```

Backend will start at:

- API: http://localhost:8000
- Docs: http://localhost:8000/docs

## Step 6: Verify Everything Works

1. **Frontend**: Open http://localhost:3000
   - You should see the welcome screen
   - Click on "Forms", "Dashboard", or "Analytics" links

2. **Backend**: Open http://localhost:8000/docs
   - You should see the FastAPI interactive docs
   - Try the `/health` endpoint

3. **Database**: In Supabase Dashboard
   - Go to **Database → Tables → form_templates**
   - You should see 1 sample form

## 🎉 Done!

You now have:

- ✅ Next.js frontend running on port 3000
- ✅ FastAPI backend running on port 8000
- ✅ Supabase database with schema
- ✅ Sample form template

## Next Steps

### Development

- Read `docs/SETUP.md` for full documentation
- Start building forms in `/forms` page (coming soon)
- Check `docs/ENV.md` for all configuration options

### Production Deployment

- Follow `docs/SETUP.md` Part 2 for VPS setup
- Setup GitHub repository for CI/CD
- Configure domain and SSL

## Troubleshooting

### Frontend won't start

```bash
# Clear cache and reinstall
cd frontend
rm -rf .next node_modules package-lock.json
npm install
npm run dev
```

### Backend errors

```bash
# Check Python version
python3 --version  # Should be 3.11+

# Reinstall dependencies
cd backend
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Database connection errors

- Check Supabase project is active (not paused)
- Verify credentials in `.env` match Supabase dashboard
- Make sure you ran `schema.sql` in Supabase SQL Editor

### Port already in use

```bash
# Frontend (port 3000)
lsof -ti:3000 | xargs kill -9

# Backend (port 8000)
lsof -ti:8000 | xargs kill -9
```

## Development Workflow

1. **Make changes** to code
2. **Frontend**: Auto-reloads (hot reload)
3. **Backend**: Auto-reloads (uvicorn --reload)
4. **Test** in browser
5. **Commit** to git when ready

## Useful Commands

```bash
# Frontend
npm run dev          # Start dev server
npm run build        # Build for production
npm run lint         # Run linter
npm test             # Run tests (coming soon)

# Backend
uvicorn main:app --reload     # Start dev server
pytest                        # Run tests (coming soon)
black .                       # Format code
flake8 .                      # Lint code
```

## Need Help?

- Read full documentation in `docs/`
- Check `README.md` for project overview
- Review `docs/ENV.md` for configuration
- See `docs/DISASTER_RECOVERY.md` for troubleshooting

---

**Estimated setup time**: 10 minutes  
**Difficulty**: Beginner-friendly  
**Last updated**: May 2026
