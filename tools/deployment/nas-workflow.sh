#!/bin/bash
# NAS + Mac Workflow Integration
# Seamlessly use NAS in your daily development workflow

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Load NAS config
if [ -f ~/Developer/nas-config.txt ]; then
    source ~/Developer/nas-config.txt
fi

show_menu() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  NAS Workflow Manager${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    echo "1)  Review duplicate photos/files"
    echo "2)  Deploy project to production"
    echo "3)  Backup code to NAS"
    echo "4)  Backup VS Code settings"
    echo "5)  Run AI model (Ollama)"
    echo "6)  Database management"
    echo "7)  Monitor NAS services"
    echo "8)  Sync project to/from NAS"
    echo "9)  NAS health check"
    echo "10) Open NAS web interfaces"
    echo "11) Cloud migration status"
    echo "12) Exit"
    echo ""
}

backup_code() {
    echo -e "\n${YELLOW}📦 Backing up Git repositories to NAS...${NC}\n"
    
    # Backup current project
    if [ -d .git ]; then
        PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))
        BACKUP_PATH="/Volumes/backups/code-repos/$PROJECT_NAME"
        
        echo "Backing up: $PROJECT_NAME"
        
        if [ -d "$BACKUP_PATH" ]; then
            echo "Updating existing backup..."
            rsync -av --exclude='node_modules' --exclude='dist' --exclude='.git' \
                . "$BACKUP_PATH/"
        else
            echo "Creating new backup..."
            mkdir -p "$BACKUP_PATH"
            rsync -av --exclude='node_modules' --exclude='dist' --exclude='.git' \
                . "$BACKUP_PATH/"
        fi
        
        echo -e "${GREEN}✅ Backup complete${NC}"
    else
        echo -e "${YELLOW}Not in a Git repository${NC}"
    fi
}

backup_vscode() {
    echo -e "\n${YELLOW}💾 Backing up VS Code settings to NAS...${NC}\n"
    
    VSCODE_BACKUP="/Volumes/backups/vscode-settings"
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    
    mkdir -p "$VSCODE_BACKUP"
    
    # Backup settings
    cp "$VSCODE_USER_DIR/settings.json" "$VSCODE_BACKUP/" 2>/dev/null
    cp "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_BACKUP/" 2>/dev/null
    cp -r "$VSCODE_USER_DIR/snippets" "$VSCODE_BACKUP/" 2>/dev/null
    
    # Export extensions
    code --list-extensions > "$VSCODE_BACKUP/extensions.txt"
    
    # Add timestamp
    echo "Last backup: $(date)" > "$VSCODE_BACKUP/backup-info.txt"
    
    echo -e "${GREEN}✅ VS Code settings backed up to NAS${NC}"
}

review_duplicates() {
    echo -e "\n${YELLOW}🔍 Review Duplicate Photos/Files...${NC}\n"
    
    DUPLICATES_PATH="/Volumes/backups/duplicates-review"
    
    if [ ! -d "$DUPLICATES_PATH" ]; then
        echo "No duplicates found yet"
        return
    fi
    
    echo "Duplicate files location: $DUPLICATES_PATH"
    echo ""
    
    # Count duplicates
    DUPLICATE_COUNT=$(find "$DUPLICATES_PATH" -type f 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$DUPLICATE_COUNT" -eq 0 ]; then
        echo -e "${GREEN}✅ No duplicates to review!${NC}"
        return
    fi
    
    echo -e "${YELLOW}Found $DUPLICATE_COUNT duplicate files${NC}"
    echo ""
    echo "Options:"
    echo "1) Open folder in Finder"
    echo "2) List duplicates"
    echo "3) Delete all duplicates (keep originals)"
    echo "4) Move duplicates back (undo)"
    read -p "Select (1-4): " DUP_OPTION
    
    case $DUP_OPTION in
        1)
            open "$DUPLICATES_PATH"
            ;;
        2)
            ls -lh "$DUPLICATES_PATH"
            ;;
        3)
            read -p "⚠️  Delete $DUPLICATE_COUNT files? (yes/no): " CONFIRM
            if [ "$CONFIRM" = "yes" ]; then
                rm -rf "$DUPLICATES_PATH"/*
                echo -e "${GREEN}✅ Duplicates deleted${NC}"
            fi
            ;;
        4)
            rsync -av "$DUPLICATES_PATH/" "/Volumes/cloud/Photos/Library/"
            echo -e "${GREEN}✅ Files moved back${NC}"
            ;;
    esac
}

deploy_production() {
    echo -e "\n${YELLOW}🚀 Deploy to Production (NAS)...${NC}\n"
    
    if [ ! -d .git ]; then
        echo -e "${YELLOW}Not in a Git repository${NC}"
        return
    fi
    
    PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))
    
    echo "Environment:"
    echo "1) Production (port 3000)"
    echo "2) Staging (port 3001)"
    echo "3) Development (port 3002)"
    read -p "Select (1-3): " ENV_OPTION
    
    case $ENV_OPTION in
        1) ENVIRONMENT="production" ;;
        2) ENVIRONMENT="staging" ;;
        3) ENVIRONMENT="development" ;;
        *) echo "Invalid option"; return ;;
    esac
    
    echo -e "\n${BLUE}Deploying $PROJECT_NAME to $ENVIRONMENT...${NC}\n"
    
    # Call nas-deploy script
    ~/Developer/nas-deploy.sh "$PROJECT_NAME" "$ENVIRONMENT"
}

migration_status() {
    echo -e "\n${YELLOW}☁️  Cloud Migration Status...${NC}\n"
    
    # Check what's migrated
    CLOUD_SIZE=$(du -sh /Volumes/cloud 2>/dev/null | awk '{print $1}')
    FAMILY_SIZE=$(du -sh /Volumes/family-cloud 2>/dev/null | awk '{print $1}')
    
    echo -e "${BLUE}Storage Usage:${NC}"
    echo "  Personal Cloud:  $CLOUD_SIZE"
    echo "  Family Cloud:    $FAMILY_SIZE"
    echo ""
    
    # Photo count
    PHOTO_COUNT=$(find /Volumes/cloud/Photos -type f 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${BLUE}Photos Migrated:${NC} $PHOTO_COUNT"
    echo ""
    
    # Check PhotoPrism indexing
    echo -e "${BLUE}PhotoPrism Status:${NC}"
    echo "  Access: http://$NAS_IP:2342"
    echo "  Login: admin / changeme123"
    echo ""
    
    # Subscription savings
    echo -e "${GREEN}💰 Estimated Annual Savings:${NC}"
    echo "  iCloud 2TB:  $120/year"
    echo "  OneDrive:    $84/year"
    echo "  Total:       $204/year"
    echo ""
}

run_ai_model() {
    echo -e "\n${YELLOW}🤖 Run AI Model on NAS...${NC}\n"
    
    echo "Available models:"
    echo "1) Chat with LLaMA 2"
    echo "2) Code generation (CodeLlama)"
    echo "3) Open WebUI (browser)"
    echo "4) Pull new model"
    read -p "Select (1-4): " AI_OPTION
    
    case $AI_OPTION in
        1)
            echo -e "${BLUE}Starting chat with LLaMA 2...${NC}"
            OLLAMA_HOST=http://$NAS_IP:11434 ollama run llama2
            ;;
        2)
            echo -e "${BLUE}Starting CodeLlama...${NC}"
            OLLAMA_HOST=http://$NAS_IP:11434 ollama run codellama
            ;;
        3)
            open "http://$NAS_IP:3001"
            ;;
        4)
            read -p "Model name (e.g., mistral, llama2, codellama): " MODEL_NAME
            OLLAMA_HOST=http://$NAS_IP:11434 ollama pull $MODEL_NAME
            ;;
    esac
}

database_management() {
    echo -e "\n${YELLOW}🗄️  Database Management...${NC}\n"
    
    echo "1) Connect to PostgreSQL"
    echo "2) Connect to MongoDB"
    echo "3) Redis CLI"
    echo "4) Backup all databases"
    read -p "Select (1-4): " DB_OPTION
    
    case $DB_OPTION in
        1)
            echo "PostgreSQL connection string:"
            echo "postgresql://nandez:changeme123@$NAS_IP:5432/devdb"
            echo ""
            echo "Connect with psql:"
            echo "psql postgresql://nandez:changeme123@$NAS_IP:5432/devdb"
            ;;
        2)
            echo "MongoDB connection string:"
            echo "mongodb://nandez:changeme123@$NAS_IP:27017"
            echo ""
            echo "Connect with mongosh:"
            echo "mongosh mongodb://nandez:changeme123@$NAS_IP:27017"
            ;;
        3)
            redis-cli -h $NAS_IP -p 6379
            ;;
        4)
            echo "Backing up databases..."
            # PostgreSQL backup
            ssh $NAS_USER@$NAS_IP "docker exec postgres pg_dumpall -U nandez > /volume1/backups/postgres-$(date +%Y%m%d).sql"
            # MongoDB backup
            ssh $NAS_USER@$NAS_IP "docker exec mongodb mongodump --out /volume1/backups/mongodb-$(date +%Y%m%d)"
            echo -e "${GREEN}✅ Databases backed up${NC}"
            ;;
    esac
}

monitor_services() {
    echo -e "\n${YELLOW}📊 NAS Services Status...${NC}\n"
    
    echo "Checking services..."
    
    # Check if services are accessible
    services=(
        "Portainer:9000"
        "Gitea:3000"
        "PostgreSQL:5432"
        "MongoDB:27017"
        "Redis:6379"
        "Ollama:11434"
        "OpenWebUI:3001"
        "CodeServer:8080"
    )
    
    for service in "${services[@]}"; do
        NAME="${service%:*}"
        PORT="${service#*:}"
        
        if nc -z -w2 $NAS_IP $PORT 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $NAME (port $PORT)"
        else
            echo -e "  ${RED}✗${NC} $NAME (port $PORT) - NOT RESPONDING"
        fi
    done
    
    echo ""
    echo "Docker containers:"
    ssh $NAS_USER@$NAS_IP "docker ps --format 'table {{.Names}}\t{{.Status}}'"
}

sync_project() {
    echo -e "\n${YELLOW}🔄 Sync Project...${NC}\n"
    
    echo "1) Push to NAS (Mac → NAS)"
    echo "2) Pull from NAS (NAS → Mac)"
    echo "3) Two-way sync"
    read -p "Select (1-3): " SYNC_OPTION
    
    if [ ! -d .git ]; then
        echo -e "${YELLOW}Not in a Git repository${NC}"
        return
    fi
    
    PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))
    NAS_PATH="/Volumes/development/projects/$PROJECT_NAME"
    
    case $SYNC_OPTION in
        1)
            echo "Pushing to NAS..."
            rsync -av --exclude='node_modules' --exclude='dist' --exclude='.git' \
                . "$NAS_PATH/"
            ;;
        2)
            echo "Pulling from NAS..."
            rsync -av --exclude='node_modules' --exclude='dist' --exclude='.git' \
                "$NAS_PATH/" .
            ;;
        3)
            echo "Two-way sync..."
            rsync -av --exclude='node_modules' --exclude='dist' --exclude='.git' \
                --update . "$NAS_PATH/"
            ;;
    esac
    
    echo -e "${GREEN}✅ Sync complete${NC}"
}

health_check() {
    echo -e "\n${YELLOW}🏥 NAS Health Check...${NC}\n"
    
    # Ping test
    if ping -c 1 $NAS_IP &>/dev/null; then
        echo -e "${GREEN}✓${NC} Network connection OK"
    else
        echo -e "${RED}✗${NC} Cannot reach NAS"
        return
    fi
    
    # Check mounted volumes
    if mount | grep -q "/Volumes/development"; then
        echo -e "${GREEN}✓${NC} Development volume mounted"
    else
        echo -e "${RED}✗${NC} Development volume not mounted"
    fi
    
    # Check SSH
    if ssh -o ConnectTimeout=2 $NAS_USER@$NAS_IP "echo OK" &>/dev/null; then
        echo -e "${GREEN}✓${NC} SSH access OK"
    else
        echo -e "${YELLOW}!${NC} SSH access not configured"
    fi
    
    # Check disk space
    echo ""
    echo "Disk usage:"
    ssh $NAS_USER@$NAS_IP "df -h /volume1" | grep -v Filesystem
}

open_interfaces() {
    echo -e "\n${YELLOW}🌐 Opening NAS web interfaces...${NC}\n"
    
    echo "1) Portainer (Docker UI)"
    echo "2) Gitea (Git Server)"
    echo "3) Open WebUI (AI Chat)"
    echo "4) Code Server (VS Code)"
    echo "5) All interfaces"
    read -p "Select (1-5): " INTERFACE
    
    case $INTERFACE in
        1) open "http://$NAS_IP:9000" ;;
        2) open "http://$NAS_IP:3000" ;;
        3) open "http://$NAS_IP:3001" ;;
        4) open "http://$NAS_IP:8080" ;;
        5)
            open "http://$NAS_IP:9000"
            sleep 1
            open "http://$NAS_IP:3000"
            sleep 1
            open "http://$NAS_IP:3001"
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Select option (1-12): " choice
    
    case $choice in
        1) review_duplicates ;;
        2) deploy_production ;;
        3) backup_code ;;
        4) backup_vscode ;;
        5) run_ai_model ;;
        6) database_management ;;
        7) monitor_services ;;
        8) sync_project ;;
        9) health_check ;;
        10) open_interfaces ;;
        11) migration_status ;;
        12) echo -e "\n${GREEN}👋 Goodbye!${NC}\n"; exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
