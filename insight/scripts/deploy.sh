#!/bin/bash

# Deploy script for Insight Dashboard
# Usage: ./deploy.sh [staging|production]

set -e

ENVIRONMENT=${1:-production}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Deploying Insight Dashboard to $ENVIRONMENT..."

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if environment is valid
if [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "production" ]; then
    print_error "Invalid environment. Use 'staging' or 'production'"
    exit 1
fi

# Navigate to project root
cd "$PROJECT_ROOT"

# Pull latest code
print_status "Pulling latest code from $ENVIRONMENT branch..."
git checkout $ENVIRONMENT
git pull origin $ENVIRONMENT

# Install frontend dependencies and build
print_status "Building frontend..."
cd frontend
npm install --production=false
npm run build

# Install backend dependencies
print_status "Installing backend dependencies..."
cd ../backend
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt --quiet

# Run database migrations if any
print_status "Running database migrations..."
# TODO: Add migration script when implemented

# Restart services
print_status "Restarting services..."
sudo systemctl restart insight-frontend
sudo systemctl restart insight-backend

# Wait for services to start
sleep 3

# Health check
print_status "Running health checks..."
if curl -s -f http://localhost:3000/api/health > /dev/null; then
    print_status "Frontend health check passed"
else
    print_error "Frontend health check failed"
    exit 1
fi

if curl -s -f http://localhost:8000/health > /dev/null; then
    print_status "Backend health check passed"
else
    print_error "Backend health check failed"
    exit 1
fi

# Check service status
if systemctl is-active --quiet insight-frontend && systemctl is-active --quiet insight-backend; then
    print_status "All services running"
else
    print_error "Some services failed to start"
    sudo systemctl status insight-frontend
    sudo systemctl status insight-backend
    exit 1
fi

print_status "Deployment to $ENVIRONMENT completed successfully! 🎉"
echo ""
echo "Application is now running at:"
if [ "$ENVIRONMENT" = "production" ]; then
    echo "  https://yourdomain.com"
else
    echo "  https://staging.yourdomain.com"
fi
