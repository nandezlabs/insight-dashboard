#!/bin/bash

# Insight Backend Deployment Script for Hostinger VPS
# Usage: ./deploy-hostinger.sh [production|staging]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-production}
APP_DIR="/opt/insight/backend"
BACKUP_DIR="/opt/insight/backups"
LOG_FILE="/opt/insight/deploy-$(date +%Y%m%d_%H%M%S).log"

# Functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

# Pre-deployment checks
check_requirements() {
    log "Checking system requirements..."
    
    # Check if running as correct user
    if [ "$EUID" -eq 0 ]; then 
        warning "Running as root. Consider using a non-root user with sudo."
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker first."
    fi
    
    # Check Docker Compose
    if ! docker compose version &> /dev/null; then
        error "Docker Compose plugin is not installed."
    fi
    
    # Check if app directory exists
    if [ ! -d "$APP_DIR" ]; then
        error "Application directory $APP_DIR does not exist."
    fi
    
    # Check if .env file exists
    if [ ! -f "$APP_DIR/.env" ]; then
        error ".env file not found in $APP_DIR. Please create it first."
    fi
    
    log "✓ All requirements met"
}

# Backup current database
backup_database() {
    log "Creating database backup..."
    
    mkdir -p "$BACKUP_DIR"
    
    BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql"
    
    # Check if postgres container is running
    if docker ps | grep -q insight-postgres; then
        docker compose exec -T postgres pg_dump -U insight_user insight_db > "$BACKUP_FILE" 2>/dev/null || {
            warning "Could not create backup. Continuing anyway..."
            return 0
        }
        log "✓ Database backed up to $BACKUP_FILE"
        
        # Compress backup
        gzip "$BACKUP_FILE"
        log "✓ Backup compressed"
        
        # Clean up old backups (keep last 7 days)
        find "$BACKUP_DIR" -name "backup_*.sql.gz" -mtime +7 -delete
        log "✓ Old backups cleaned up"
    else
        warning "PostgreSQL container not running. Skipping backup."
    fi
}

# Pull latest code
update_code() {
    log "Updating code..."
    
    cd "$APP_DIR"
    
    # Check if git repository
    if [ -d .git ]; then
        # Stash any local changes
        git stash save "Auto-stash before deployment $(date)"
        
        # Pull latest changes
        git pull origin main || error "Failed to pull latest code"
        
        log "✓ Code updated from git"
    else
        log "Not a git repository. Skipping code update."
    fi
}

# Build and deploy
deploy() {
    log "Starting deployment for $ENVIRONMENT environment..."
    
    cd "$APP_DIR"
    
    # Use appropriate docker-compose file
    export COMPOSE_FILE="docker-compose-hostinger.yml"
    
    # Pull latest base images
    log "Pulling latest Docker images..."
    docker compose pull postgres || warning "Could not pull postgres image"
    
    # Build new image
    log "Building application image..."
    docker compose build --no-cache backend || error "Build failed"
    
    # Stop old containers
    log "Stopping old containers..."
    docker compose down || warning "Could not stop containers gracefully"
    
    # Start new containers
    log "Starting new containers..."
    docker compose up -d || error "Failed to start containers"
    
    # Wait for services to be healthy
    log "Waiting for services to be healthy..."
    sleep 10
    
    # Check if backend is healthy
    for i in {1..30}; do
        if docker compose ps | grep -q "insight-backend.*running"; then
            log "✓ Backend is running"
            break
        fi
        if [ $i -eq 30 ]; then
            error "Backend failed to start"
        fi
        sleep 2
    done
    
    # Run database migrations
    log "Running database migrations..."
    docker compose exec -T backend alembic upgrade head || error "Migrations failed"
    
    log "✓ Deployment complete"
}

# Health check
health_check() {
    log "Performing health check..."
    
    # Wait a bit for services to stabilize
    sleep 5
    
    # Check backend health endpoint
    if curl -f http://localhost:8000/health > /dev/null 2>&1; then
        log "✓ Backend health check passed"
    else
        error "Backend health check failed"
    fi
    
    # Check if database is accessible
    if docker compose exec -T postgres pg_isready -U insight_user -d insight_db > /dev/null 2>&1; then
        log "✓ Database health check passed"
    else
        error "Database health check failed"
    fi
    
    # Check Nginx (if installed)
    if command -v nginx &> /dev/null; then
        if systemctl is-active --quiet nginx; then
            log "✓ Nginx is running"
        else
            warning "Nginx is not running"
        fi
    fi
}

# Rollback function
rollback() {
    warning "Rolling back deployment..."
    
    cd "$APP_DIR"
    
    # Stop new containers
    docker compose down
    
    # Restore previous image (if tagged)
    docker tag insight-backend:previous insight-backend:latest 2>/dev/null || true
    
    # Start with old image
    docker compose up -d
    
    # Restore database from latest backup
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup_*.sql.gz | head -1)
    if [ -n "$LATEST_BACKUP" ]; then
        log "Restoring database from $LATEST_BACKUP"
        gunzip -c "$LATEST_BACKUP" | docker compose exec -T postgres psql -U insight_user insight_db
    fi
    
    error "Rollback complete. Please investigate the issue."
}

# Clean up Docker resources
cleanup() {
    log "Cleaning up Docker resources..."
    
    # Remove unused images
    docker image prune -af --filter "until=72h" || warning "Could not prune images"
    
    # Remove unused volumes
    docker volume prune -f || warning "Could not prune volumes"
    
    log "✓ Cleanup complete"
}

# Display deployment summary
summary() {
    log "==================================="
    log "Deployment Summary"
    log "==================================="
    log "Environment: $ENVIRONMENT"
    log "Time: $(date)"
    log "Log file: $LOG_FILE"
    log ""
    log "Container Status:"
    docker compose ps
    log ""
    log "Resource Usage:"
    docker stats --no-stream
    log "==================================="
}

# Main deployment process
main() {
    log "Starting Insight Backend Deployment"
    log "Environment: $ENVIRONMENT"
    
    # Set trap for rollback on error
    trap rollback ERR
    
    # Run deployment steps
    check_requirements
    backup_database
    
    # Tag current image as previous (for rollback)
    docker tag insight-backend:latest insight-backend:previous 2>/dev/null || true
    
    update_code
    deploy
    health_check
    cleanup
    summary
    
    log "✅ Deployment successful!"
    log "API URL: http://localhost:8000"
    log "API Docs: http://localhost:8000/docs"
    
    # Open API docs in browser (optional)
    # xdg-open http://localhost:8000/docs 2>/dev/null || true
}

# Run main function
main
