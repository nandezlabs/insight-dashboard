# Insight Dashboard Backend

Python FastAPI backend for the Insight Dashboard application.

## Setup

1. **Create virtual environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment**:
   ```bash
   cp ../.env.example .env
   # Edit .env with your Supabase credentials
   ```

4. **Run development server**:
   ```bash
   uvicorn main:app --reload --port 8000
   ```

API will be available at:
- http://localhost:8000
- Docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### Health Check
- `GET /health` - Check API health and Supabase connection

### Coming Soon
- `/api/submissions` - Form submission management
- `/api/exports` - Export generation (CSV, Excel, PDF)
- `/api/analytics` - Analytics and completion tracking
- `/api/alerts` - Alert management

## Testing

```bash
pytest
pytest --cov  # With coverage report
```

## Database Schema

The database schema is defined in `database/schema.sql`. Run this in your Supabase SQL Editor to create all tables.

## Development

- Use `black` for code formatting: `black .`
- Use `flake8` for linting: `flake8 .`
- Use `mypy` for type checking: `mypy .`
