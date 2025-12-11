#!/bin/bash
set -euo pipefail
# Daily Backup - Automated daily backup of all projects
# Usage: ./daily-backup.sh

BACKUP_ROOT="${HOME}/Developer/archive/daily-backups"
TIMESTAMP=$(date "+%Y%m%d")
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"

mkdir -p "${BACKUP_DIR}"

echo "📦 Starting daily backup..."

# Validate projects directory exists
if [ ! -d "${HOME}/Developer/projects" ]; then
    echo "Error: Projects directory not found" >&2
    exit 1
fi

# Backup all projects (excluding node_modules, etc.)
cd "${HOME}/Developer/projects"
for PROJECT in *; do
    if [ -d "${PROJECT}" ]; then
        echo "  → Backing up ${PROJECT}..."
        tar -czf "${BACKUP_DIR}/${PROJECT}.tar.gz" \
            --exclude="node_modules" \
            --exclude=".venv" \
            --exclude="venv" \
            --exclude="dist" \
            --exclude="build" \
            "${PROJECT}" 2>/dev/null || {
                echo "Warning: Failed to backup ${PROJECT}" >&2
            }
    fi
done

# Keep only last 7 days of backups
find "${BACKUP_ROOT}" -type d -mtime +7 -exec rm -rf {} + 2>/dev/null || true

echo "✓ Backup complete: ${BACKUP_DIR}"
