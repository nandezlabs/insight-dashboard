#!/bin/bash

# Local Environment Verification Script
# Ensures all project dependencies are contained within the project

echo "🔍 Verifying Local Environment Setup..."
echo "========================================"
echo ""

# Check current directory
BACKEND_DIR="/Users/nandez/Developer/insight/backend"
if [ "$PWD" != "$BACKEND_DIR" ]; then
    echo "❌ Wrong directory! Please cd to $BACKEND_DIR"
    exit 1
fi

# 1. Virtual Environment
echo "1️⃣ Checking Python Virtual Environment..."
if [ -d "venv" ]; then
    echo "   ✅ Virtual environment exists at: $BACKEND_DIR/venv"
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "   ✅ Virtual environment is activated: $VIRTUAL_ENV"
    else
        echo "   ⚠️  Virtual environment not activated. Run: source venv/bin/activate"
    fi
else
    echo "   ❌ Virtual environment not found. Run: python3 -m venv venv"
    exit 1
fi
echo ""

# 2. Python packages
echo "2️⃣ Checking Python Dependencies..."
if [ -n "$VIRTUAL_ENV" ]; then
    PACKAGE_COUNT=$(pip list | wc -l)
    echo "   ✅ Installed packages: $PACKAGE_COUNT (local to venv)"
    echo "   ✅ FastAPI: $(pip show fastapi 2>/dev/null | grep Version || echo 'Not installed')"
    echo "   ✅ SQLAlchemy: $(pip show sqlalchemy 2>/dev/null | grep Version || echo 'Not installed')"
    echo "   ✅ Alembic: $(pip show alembic 2>/dev/null | grep Version || echo 'Not installed')"
else
    echo "   ⚠️  Activate venv first: source venv/bin/activate"
fi
echo ""

# 3. Database
echo "3️⃣ Checking Database Configuration..."
if [ -f ".env" ]; then
    echo "   ✅ Environment file exists: .env"
    DB_URL=$(grep DATABASE_URL .env | cut -d '=' -f 2)
    echo "   ℹ️  Database URL: $DB_URL"
else
    echo "   ❌ Missing .env file"
fi
echo ""

# 4. Docker setup
echo "4️⃣ Checking Docker Configuration..."
if [ -f "docker-compose.yml" ]; then
    echo "   ✅ docker-compose.yml exists"
else
    echo "   ❌ docker-compose.yml missing"
fi

if command -v docker &> /dev/null; then
    echo "   ✅ Docker is installed: $(docker --version)"
    
    # Check for running containers
    if docker ps | grep -q insight-postgres; then
        echo "   ✅ PostgreSQL container is running"
    else
        echo "   ⚠️  PostgreSQL container not running. Start with: docker-compose up -d postgres"
    fi
else
    echo "   ⚠️  Docker not installed. Install from: https://www.docker.com/products/docker-desktop/"
fi
echo ""

# 5. Data directory
echo "5️⃣ Checking Local Data Storage..."
if [ -d "postgres-data" ]; then
    SIZE=$(du -sh postgres-data 2>/dev/null | cut -f1)
    echo "   ✅ PostgreSQL data directory exists: $BACKEND_DIR/postgres-data"
    echo "   ℹ️  Size: $SIZE"
else
    echo "   ⚠️  No data directory yet (will be created on first run)"
fi
echo ""

# 6. Git ignore
echo "6️⃣ Checking Git Configuration..."
if [ -f ".gitignore" ]; then
    if grep -q "postgres-data" .gitignore; then
        echo "   ✅ postgres-data/ is in .gitignore"
    else
        echo "   ⚠️  Add postgres-data/ to .gitignore"
    fi
    if grep -q "venv" .gitignore; then
        echo "   ✅ venv/ is in .gitignore"
    else
        echo "   ⚠️  Add venv/ to .gitignore"
    fi
else
    echo "   ❌ No .gitignore file"
fi
echo ""

# 7. Global vs Local
echo "7️⃣ Checking for Global Installations..."
GLOBAL_POSTGRES=$(which postgres 2>/dev/null || echo "Not found")
if [ "$GLOBAL_POSTGRES" = "Not found" ]; then
    echo "   ✅ No global PostgreSQL found"
else
    echo "   ⚠️  Global PostgreSQL found at: $GLOBAL_POSTGRES"
    echo "      (Docker setup will use containerized version instead)"
fi
echo ""

# Summary
echo "========================================"
echo "📊 Summary"
echo "========================================"
echo ""
echo "✅ Local Assets:"
echo "   • Python venv: $BACKEND_DIR/venv"
echo "   • Database data: $BACKEND_DIR/postgres-data (Docker volume)"
echo "   • Dependencies: All in venv, not global"
echo "   • Config: .env file (local)"
echo ""
echo "🎯 Next Steps:"
if ! command -v docker &> /dev/null; then
    echo "   1. Install Docker Desktop"
fi
if [ ! -n "$VIRTUAL_ENV" ]; then
    echo "   1. Activate venv: source venv/bin/activate"
fi
echo "   2. Start PostgreSQL: docker-compose up -d postgres"
echo "   3. Run migrations: alembic upgrade head"
echo "   4. Start backend: uvicorn app.main:app --reload"
echo ""
echo "✨ All project assets will remain in: $BACKEND_DIR"
