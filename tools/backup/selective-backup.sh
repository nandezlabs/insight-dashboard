#!/bin/bash
set -euo pipefail
# Selective Backup - Backup only source code (no dependencies)
# Usage: ./selective-backup.sh [destination]

if [ -z "${1:-}" ]; then
    DEST="${HOME}/Developer/archive/selective-backups"
else
    DEST="$1"
fi

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
BACKUP_PATH="${DEST}/src_backup_${TIMESTAMP}"

mkdir -p "${BACKUP_PATH}"

echo "📦 Creating selective backup (source only)..."

# Validate projects directory exists
if [ ! -d "${HOME}/Developer/projects" ]; then
    echo "Error: Projects directory not found" >&2
    exit 1
fi

cd "${HOME}/Developer/projects"

for PROJECT in *; do
    if [ -d "${PROJECT}" ]; then
        echo "  → ${PROJECT}"

        # Create project directory
        mkdir -p "${BACKUP_PATH}/${PROJECT}"

        # Copy only essential files
        rsync -av \
            --exclude="node_modules" \
            --exclude=".venv" \
            --exclude="venv" \
            --exclude="env" \
            --exclude="dist" \
            --exclude="build" \
            --exclude=".cache" \
            --exclude="*.log" \
            --exclude=".DS_Store" \
            "${PROJECT}/" "${BACKUP_PATH}/${PROJECT}/" \
            2>/dev/null || {
                echo "Warning: Failed to backup ${PROJECT}" >&2
            }
    fi
done

# Compress the backup
echo "  → Compressing..."
cd "${DEST}"
if tar -czf "src_backup_${TIMESTAMP}.tar.gz" "src_backup_${TIMESTAMP}"; then
    rm -rf "src_backup_${TIMESTAMP}"
    echo "✓ Selective backup complete: ${DEST}/src_backup_${TIMESTAMP}.tar.gz"
else
    echo "Error: Failed to compress backup" >&2
    exit 1
fi
