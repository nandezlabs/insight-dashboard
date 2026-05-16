#!/bin/bash

# Backup script for Insight Dashboard Database
# Run weekly via cron: 0 2 * * 0 /home/insight/insight/scripts/backup.sh

set -e

# Configuration
BACKUP_DIR="/home/insight/backups"
DATE=$(date +%Y%m%d_%H%M%S)
FILENAME="insight_db_${DATE}.sql"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load environment variables
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | xargs)
fi

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

echo "Starting database backup: $FILENAME"

# Extract database credentials from Supabase URL
# Supabase URL format: https://xxx.supabase.co
# Database host format: db.xxx.supabase.co
DB_PROJECT=$(echo "$NEXT_PUBLIC_SUPABASE_URL" | sed -n 's|https://\([^.]*\)\.supabase\.co|\1|p')
DB_HOST="db.${DB_PROJECT}.supabase.co"
DB_USER="postgres"
DB_NAME="postgres"
DB_PORT="5432"

# Check if we have the database password
if [ -z "$SUPABASE_DB_PASSWORD" ]; then
    echo "Error: SUPABASE_DB_PASSWORD not set in .env file"
    echo "Add it to your .env file: SUPABASE_DB_PASSWORD=your-password-here"
    exit 1
fi

# Perform backup using pg_dump
echo "Connecting to $DB_HOST..."
PGPASSWORD="$SUPABASE_DB_PASSWORD" pg_dump \
    -h "$DB_HOST" \
    -U "$DB_USER" \
    -p "$DB_PORT" \
    -d "$DB_NAME" \
    --no-owner \
    --no-acl \
    -F plain \
    -f "$BACKUP_DIR/$FILENAME" 2>&1

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "✓ Backup completed successfully"
    
    # Compress backup
    echo "Compressing backup..."
    gzip "$BACKUP_DIR/$FILENAME"
    
    BACKUP_SIZE=$(du -h "$BACKUP_DIR/${FILENAME}.gz" | cut -f1)
    echo "✓ Backup compressed: ${BACKUP_SIZE}"
    
    # Delete backups older than 30 days
    echo "Cleaning old backups (>30 days)..."
    find "$BACKUP_DIR" -name "insight_db_*.sql.gz" -mtime +30 -delete
    
    # Optional: Upload to cloud storage
    # Uncomment and configure rclone if needed
    # if command -v rclone &> /dev/null; then
    #     echo "Uploading to cloud storage..."
    #     rclone copy "$BACKUP_DIR/${FILENAME}.gz" onedrive:backups/insight/
    #     echo "✓ Uploaded to cloud storage"
    # fi
    
    echo ""
    echo "Backup completed: $BACKUP_DIR/${FILENAME}.gz"
    echo "Backup size: $BACKUP_SIZE"
    
else
    echo "✗ Backup failed"
    exit 1
fi
