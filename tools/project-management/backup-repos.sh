#!/bin/bash
# Backup All Repositories - Clone to external location
# Usage: ./backup-repos.sh /path/to/backup
# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true


set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/backup/directory"
    exit 1
fi

BACKUP_DIR="$1"
PROJECTS_DIR="$HOME/Developer/projects"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
BACKUP_PATH="$BACKUP_DIR/repos_backup_$TIMESTAMP"

echo -e "${BLUE}📦 Backing up repositories to: $BACKUP_PATH${NC}\n"

mkdir -p "$BACKUP_PATH"

BACKED_UP=0

for PROJECT in "$PROJECTS_DIR"/*; do
    if [ -d "$PROJECT/.git" ]; then
        PROJECT_NAME=$(basename "$PROJECT")
        echo -e "${BLUE}📂 Backing up $PROJECT_NAME...${NC}"
        
        # Create tar.gz of the project (excluding node_modules, .venv, etc.)
        tar -czf "$BACKUP_PATH/${PROJECT_NAME}.tar.gz" \
            -C "$PROJECTS_DIR" \
            --exclude="node_modules" \
            --exclude=".venv" \
            --exclude="venv" \
            --exclude="dist" \
            --exclude="build" \
            --exclude=".cache" \
            "$PROJECT_NAME" 2>/dev/null
        
        echo -e "  ${GREEN}✓ Backed up${NC}"
        ((BACKED_UP++))
    fi
done

echo -e "\n${GREEN}✓ Backed up $BACKED_UP repositories${NC}"
echo -e "${BLUE}📍 Location: $BACKUP_PATH${NC}"
