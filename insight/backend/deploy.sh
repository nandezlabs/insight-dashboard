#!/bin/bash
set -e

echo "🚀 Insight Backend Deployment Script"
echo "===================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "📝 Creating from .env.example..."
    cp .env.example .env
    echo "✅ Created .env file"
    echo ""
    echo "⚠️  Please edit .env file with your settings:"
    echo "   - DB_PASSWORD"
    echo "   - SECRET_KEY"
    echo "   - TAILSCALE_AUTH_KEY"
    echo ""
    echo "Run this script again after configuring .env"
    exit 1
fi

# Source environment variables
source .env

# Check required variables
if [ -z "$DB_PASSWORD" ] || [ "$DB_PASSWORD" = "your_password_here" ]; then
    echo "❌ Error: DB_PASSWORD not set in .env"
    exit 1
fi

if [ -z "$SECRET_KEY" ] || [ "$SECRET_KEY" = "change-this-to-a-random-secret-key-min-32-chars" ]; then
    echo "❌ Error: SECRET_KEY not set in .env"
    exit 1
fi

if [ -z "$TAILSCALE_AUTH_KEY" ] || [ "$TAILSCALE_AUTH_KEY" = "tskey-auth-your-key-here" ]; then
    echo "⚠️  Warning: TAILSCALE_AUTH_KEY not set - Tailscale will not start"
fi

echo "✅ Environment configuration verified"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running"
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Build the containers
echo "🏗️  Building containers..."
docker-compose build --no-cache

echo "✅ Containers built successfully"
echo ""

# Start the services
echo "🚀 Starting services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🔍 Checking API health..."
sleep 5

# Try to connect to API
if curl -sf http://localhost:8000/health > /dev/null; then
    echo "✅ API is healthy!"
    echo ""
    echo "📝 API Documentation: http://localhost:8000/docs"
else
    echo "⚠️  API health check failed. Checking logs..."
    docker-compose logs --tail=20 api
fi

# Check Tailscale if key was provided
if [ ! -z "$TAILSCALE_AUTH_KEY" ] && [ "$TAILSCALE_AUTH_KEY" != "tskey-auth-your-key-here" ]; then
    echo ""
    echo "🔍 Checking Tailscale status..."
    sleep 5
    docker-compose exec -T tailscale tailscale status || echo "⚠️  Tailscale not ready yet"
fi

echo ""
echo "========================================"
echo "✅ Deployment Complete!"
echo "========================================"
echo ""
echo "📖 Next Steps:"
echo "   1. Check logs: docker-compose logs -f"
echo "   2. Verify Tailscale: docker-compose exec tailscale tailscale status"
echo "   3. Get Tailscale IP: docker-compose exec tailscale tailscale ip"
echo "   4. Update Flutter apps with your Tailscale IP"
echo ""
echo "📚 For more information, see DEPLOYMENT.md"
echo ""
