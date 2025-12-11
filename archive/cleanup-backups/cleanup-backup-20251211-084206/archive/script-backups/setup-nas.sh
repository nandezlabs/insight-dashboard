#!/bin/bash
# NAS Setup Automation Script
# Sets up UGREEN NASync for development workflow

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  UGREEN NAS Setup for Development${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Step 1: NAS Discovery
echo -e "${YELLOW}Step 1: Finding NAS on network...${NC}\n"

read -p "Enter NAS IP address (or press Enter to auto-detect): " NAS_IP

if [ -z "$NAS_IP" ]; then
    echo "Scanning network..."
    # Try common patterns
    for ip in 192.168.1.{1..254}; do
        timeout 0.2 ping -c 1 $ip &>/dev/null && \
        echo "Found: $ip" &
    done
    wait
    
    read -p "Enter NAS IP from above: " NAS_IP
fi

echo -e "${GREEN}✅ NAS IP: $NAS_IP${NC}\n"

# Step 2: Test Connection
echo -e "${YELLOW}Step 2: Testing NAS connection...${NC}\n"

if ping -c 1 $NAS_IP &>/dev/null; then
    echo -e "${GREEN}✅ NAS is reachable${NC}"
else
    echo -e "${RED}❌ Cannot reach NAS. Check network connection.${NC}"
    exit 1
fi

# Step 3: SSH Setup
echo -e "\n${YELLOW}Step 3: Setting up SSH access...${NC}\n"

read -p "NAS admin username [admin]: " NAS_USER
NAS_USER=${NAS_USER:-admin}

read -sp "NAS password: " NAS_PASS
echo ""

# Test SSH connection
if sshpass -p "$NAS_PASS" ssh -o StrictHostKeyChecking=no $NAS_USER@$NAS_IP "echo 'SSH OK'" 2>/dev/null; then
    echo -e "${GREEN}✅ SSH connection successful${NC}"
else
    echo -e "${YELLOW}⚠️  sshpass not installed. Installing...${NC}"
    brew install hudochenkov/sshpass/sshpass
    
    if sshpass -p "$NAS_PASS" ssh -o StrictHostKeyChecking=no $NAS_USER@$NAS_IP "echo 'SSH OK'" 2>/dev/null; then
        echo -e "${GREEN}✅ SSH connection successful${NC}"
    else
        echo -e "${RED}❌ SSH connection failed. Enable SSH in NAS settings.${NC}"
        exit 1
    fi
fi

# Step 4: Create Directory Structure
echo -e "\n${YELLOW}Step 4: Creating directory structure on NAS...${NC}\n"

DIRS=(
    # Cloud (Personal - iCloud replacement)
    "/volume1/cloud/Desktop"
    "/volume1/cloud/Documents/Work"
    "/volume1/cloud/Documents/Personal"
    "/volume1/cloud/Documents/Archives"
    "/volume1/cloud/Photos/Library"
    "/volume1/cloud/Photos/Shared Albums"
    "/volume1/cloud/Videos"
    "/volume1/cloud/Music"
    "/volume1/cloud/Downloads"
    "/volume1/cloud/iCloud Drive/Applications"
    "/volume1/cloud/iCloud Drive/Quick Access"
    
    # Family Cloud (OneDrive-style)
    "/volume1/family-cloud/Photos"
    "/volume1/family-cloud/Videos"
    "/volume1/family-cloud/Documents"
    
    # Backups
    "/volume1/backups/mac-timemachine"
    "/volume1/backups/code-repos"
    "/volume1/backups/mobile-backups"
    "/volume1/backups/duplicates-review"
    
    # Development
    "/volume1/development/projects/active"
    "/volume1/development/projects/production"
    "/volume1/development/projects/staging"
    "/volume1/development/docker"
    "/volume1/development/databases/postgres"
    "/volume1/development/databases/mongodb"
    "/volume1/development/databases/redis"
    "/volume1/development/git-server"
    
    # AI Models
    "/volume1/ai-models/llm-models"
    "/volume1/ai-models/embeddings"
    
    # Services
    "/volume1/services/nextcloud"
    "/volume1/services/photoprism"
    "/volume1/services/nginx-proxy"
    "/volume1/services/monitoring"
)

for dir in "${DIRS[@]}"; do
    sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "mkdir -p $dir" 2>/dev/null
    echo "Created: $dir"
done

echo -e "${GREEN}✅ Directory structure created${NC}"

# Step 5: Deploy Docker Compose Stack
echo -e "\n${YELLOW}Step 5: Setting up Docker services...${NC}\n"

# Create docker-compose.yml on NAS
cat > /tmp/docker-compose.yml << 'EOF'
version: '3.8'

services:
  # Portainer - Docker Management
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /volume1/development/portainer:/data
    restart: always

  # Gitea - Git Server
  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    ports:
      - "3000:3000"
      - "2222:22"
    volumes:
      - /volume1/development/git-server:/data
    environment:
      - USER_UID=1000
      - USER_GID=1000
    restart: always

  # PostgreSQL
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    ports:
      - "5432:5432"
    volumes:
      - /volume1/development/databases/postgres:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: changeme123
      POSTGRES_USER: nandez
    restart: always

  # MongoDB
  mongodb:
    image: mongo:7
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - /volume1/development/databases/mongodb:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: nandez
      MONGO_INITDB_ROOT_PASSWORD: changeme123
    restart: always

  # Redis
  redis:
    image: redis:7-alpine
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - /volume1/development/databases/redis:/data
    restart: always

  # Ollama - AI Models
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - /volume1/ai-models/ollama:/root/.ollama
    restart: always

  # Open WebUI - ChatGPT-like interface for Ollama
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    ports:
      - "3001:8080"
    volumes:
      - /volume1/ai-models/open-webui:/app/backend/data
    environment:
      OLLAMA_BASE_URL: http://ollama:11434
    depends_on:
      - ollama
    restart: always

  # Tailscale - Secure remote access
  tailscale:
    image: tailscale/tailscale:latest
    container_name: tailscale
    hostname: nas-dev
    network_mode: host
    privileged: true
    volumes:
      - /volume1/services/tailscale:/var/lib/tailscale
      - /dev/net/tun:/dev/net/tun
    environment:
      - TS_AUTHKEY=${TS_AUTHKEY:-}
      - TS_STATE_DIR=/var/lib/tailscale
    restart: always

  # Nginx Proxy Manager - Reverse proxy with SSL
  nginx-proxy:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    volumes:
      - /volume1/services/nginx-proxy/data:/data
      - /volume1/services/nginx-proxy/letsencrypt:/etc/letsencrypt
    restart: always

  # Nextcloud - iCloud/OneDrive replacement
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    ports:
      - "8081:80"
    volumes:
      - /volume1/services/nextcloud:/var/www/html
      - /volume1/cloud:/data/cloud
      - /volume1/family-cloud:/data/family-cloud
    environment:
      POSTGRES_HOST: postgres
      POSTGRES_DB: nextcloud
      POSTGRES_USER: nandez
      POSTGRES_PASSWORD: changeme123
      NEXTCLOUD_TRUSTED_DOMAINS: "localhost 100.* nas-dev"
    depends_on:
      - postgres
    restart: always

  # PhotoPrism - iCloud Photos replacement + AI
  photoprism:
    image: photoprism/photoprism:latest
    container_name: photoprism
    ports:
      - "2342:2342"
    volumes:
      - /volume1/services/photoprism:/photoprism/storage
      - /volume1/cloud/Photos:/photoprism/originals/personal
      - /volume1/family-cloud/Photos:/photoprism/originals/family
      - /volume1/backups/duplicates-review:/photoprism/duplicates
    environment:
      PHOTOPRISM_ADMIN_PASSWORD: changeme123
      PHOTOPRISM_DATABASE_DRIVER: postgres
      PHOTOPRISM_DATABASE_DSN: "postgres:changeme123@tcp(postgres:5432)/photoprism?sslmode=disable"
      PHOTOPRISM_DETECT_NSFW: "false"
      PHOTOPRISM_UPLOAD_NSFW: "true"
      PHOTOPRISM_EXPERIMENTAL: "true"
    depends_on:
      - postgres
    restart: always

  # Code Server - VS Code in Browser
  code-server:
    image: codercom/code-server:latest
    container_name: code-server
    ports:
      - "8080:8080"
    volumes:
      - /volume1/development/projects:/home/coder/projects
    environment:
      PASSWORD: changeme123
    restart: always

EOF

# Upload docker-compose.yml
scp /tmp/docker-compose.yml $NAS_USER@$NAS_IP:/volume1/development/docker/docker-compose.yml

# Start services
echo -e "${YELLOW}Starting Docker services...${NC}"
sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "cd /volume1/development/docker && docker-compose up -d"

echo -e "${GREEN}✅ Docker services started${NC}"

# Step 6: Mount NAS on Mac
echo -e "\n${YELLOW}Step 6: Mounting NAS on Mac...${NC}\n"

# Mount via SMB (cloud is YOUR personal iCloud replacement, family-cloud is for family only)
osascript <<EOF
tell application "Finder"
    try
        mount volume "smb://$NAS_USER@$NAS_IP/cloud"
        mount volume "smb://$NAS_USER@$NAS_IP/family-cloud"
        mount volume "smb://$NAS_USER@$NAS_IP/development"
        mount volume "smb://$NAS_USER@$NAS_IP/backups"
    end try
end tell
EOF

echo -e "${GREEN}✅ NAS mounted${NC}"
echo -e "${BLUE}📁 /Volumes/cloud - Your personal cloud (iCloud replacement)${NC}"
echo -e "${BLUE}📁 /Volumes/family-cloud - Family shared only (not for you)${NC}"
echo -e "${BLUE}📁 /Volumes/development - Dev work${NC}"
echo -e "${BLUE}📁 /Volumes/backups - Time Machine + code${NC}"

# Step 7: Configure Environment
echo -e "\n${YELLOW}Step 7: Configuring Mac environment...${NC}\n"

# Add to .zshrc
if ! grep -q "# NAS Configuration" ~/.zshrc 2>/dev/null; then
    cat >> ~/.zshrc << EOF

# NAS Configuration
export NAS_IP="$NAS_IP"
export NAS_USER="$NAS_USER"
export NAS_DEV="/Volumes/development"
export NAS_DEV="/Volumes/development"
export NAS_BACKUP="/Volumes/backups"
export NAS_CLOUD="/Volumes/cloud"
export NAS_FAMILY="/Volumes/family-cloud"

# NAS Aliases
alias nas-ssh='ssh $NAS_USER@$NAS_IP'
alias nas-dev='cd $NAS_DEV'
alias nas-backup='cd $NAS_BACKUP'
alias nas-cloud='cd $NAS_CLOUD'
alias nas-family='cd $NAS_FAMILY'
alias nas-ollama='OLLAMA_HOST=http://$NAS_IP:11434 ollama'
alias nas-status='docker -H tcp://$NAS_IP:2375 ps'
alias nas-portainer='open http://$NAS_IP:9000'
alias nas-gitea='open http://$NAS_IP:3000'
alias nas-code='open http://$NAS_IP:8080'
alias nas-webui='open http://$NAS_IP:3001'
alias nas-nextcloud='open http://$NAS_IP:8081'
alias nas-photos='open http://$NAS_IP:2342'

EOF
    echo -e "${GREEN}✅ Environment configured${NC}"
fi

# Step 8: Setup Backup Scripts
echo -e "\n${YELLOW}Step 8: Setting up automated backups...${NC}\n"

# GitHub backup script
cat > /tmp/backup-github.sh << 'SCRIPT'
#!/bin/bash
BACKUP_DIR="/volume1/backups/code-repos"
GITHUB_USER="nandezlabs"

gh repo list $GITHUB_USER --limit 1000 --json name -q '.[].name' | while read repo; do
    echo "Backing up: $repo"
    if [ -d "$BACKUP_DIR/$repo" ]; then
        cd "$BACKUP_DIR/$repo" && git pull
    else
        cd "$BACKUP_DIR" && gh repo clone "$GITHUB_USER/$repo"
    fi
done
echo "✅ Backup complete: $(date)" >> /volume1/backups/backup.log
SCRIPT

scp /tmp/backup-github.sh $NAS_USER@$NAS_IP:/volume1/backups/scripts/
sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "chmod +x /volume1/backups/scripts/backup-github.sh"

# Add cron job
sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "crontab -l 2>/dev/null | { cat; echo '0 2 * * * /volume1/backups/scripts/backup-github.sh'; } | crontab -"

echo -e "${GREEN}✅ Automated backups configured${NC}"

# Step 9: Pull AI Models
echo -e "\n${YELLOW}Step 9: Would you like to pull AI models now? (y/n)${NC}"
read -p "> " PULL_MODELS

if [ "$PULL_MODELS" = "y" ]; then
    echo "Pulling LLaMA 2 (7B)..."
    sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "docker exec ollama ollama pull llama2"
    
    echo "Pulling CodeLlama (7B)..."
    sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "docker exec ollama ollama pull codellama"
    
    echo -e "${GREEN}✅ Models pulled${NC}"
fi

# Final Summary
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BLUE}📋 Services Running:${NC}"
echo "  • Portainer (Docker UI):     http://$NAS_IP:9000"
echo "  • Nextcloud (Cloud Storage): http://$NAS_IP:8081"
echo "  • PhotoPrism (Photos):       http://$NAS_IP:2342"
echo "  • Gitea (Git Server):        http://$NAS_IP:3000"
echo "  • PostgreSQL:                $NAS_IP:5432"
echo "  • MongoDB:                   $NAS_IP:27017"
echo "  • Redis:                     $NAS_IP:6379"
echo "  • Ollama (AI):               http://$NAS_IP:11434"
echo "  • Open WebUI (Chat):         http://$NAS_IP:3001"
echo "  • Code Server:               http://$NAS_IP:8080"

echo -e "\n${BLUE}📁 NAS Mounted at:${NC}"
echo "  • Cloud (YOUR personal):  /Volumes/cloud"
echo "  • Family Cloud:           /Volumes/family-cloud"
echo "  • Development:            /Volumes/development"
echo "  • Backups:                /Volumes/backups"

echo -e "\n${BLUE}🚀 Quick Commands:${NC}"
echo "  nas-ssh          # SSH into NAS"
echo "  nas-cloud        # Go to YOUR cloud folder"
echo "  nas-family       # Go to family shared folder"
echo "  nas-dev          # Go to development folder"
echo "  nas-ollama       # Use Ollama on NAS"
echo "  nas-portainer    # Open Portainer"
echo "  nas-nextcloud    # Open Nextcloud"
echo "  nas-photos       # Open PhotoPrism"
echo "  nas-webui        # Open AI Chat UI"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "  1. Restart terminal: source ~/.zshrc"
echo "  2. Access Portainer and set admin password"
echo "  3. Configure Nextcloud at http://$NAS_IP:8081"
echo "  4. Configure PhotoPrism at http://$NAS_IP:2342"
echo "  5. Start migrating from iCloud/OneDrive to /Volumes/cloud"
echo ""
echo -e "${BLUE}💡 Migration Tips:${NC}"
echo "  • Download iCloud Photos → Upload to PhotoPrism"
echo "  • Move OneDrive files → /Volumes/cloud/documents"
echo "  • Install Nextcloud mobile app for auto-sync"
echo "  • Use PhotoPrism app for photo backup"
echo ""

# Save config
cat > ~/Desktop/workspace/nas-config.txt << EOF
NAS_IP=$NAS_IP
NAS_USER=$NAS_USER
Setup Date: $(date)
EOF

echo -e "${GREEN}Config saved to: ~/Desktop/workspace/nas-config.txt${NC}\n"
