#!/bin/bash
# NAS Setup Preparation Script
# Automate Mac-side configuration before NAS connection
# Run this while waiting for NAS to boot

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  NAS Setup Preparation (Mac Side)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check if running on Mac
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script must run on macOS${NC}"
    exit 1
fi

# Step 1: Generate SSH Key
echo -e "${YELLOW}Step 1: Generating SSH key for passwordless NAS access...${NC}\n"

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "nandez@mac" -f ~/.ssh/id_ed25519 -N ""
    echo -e "${GREEN}✅ SSH key generated${NC}\n"
else
    echo -e "${GREEN}✅ SSH key already exists${NC}\n"
fi

# Step 2: Install required tools
echo -e "${YELLOW}Step 2: Installing required tools...${NC}\n"

# Add Homebrew to PATH if it exists but not in PATH
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Homebrew not found. Install from https://brew.sh${NC}"
    exit 1
fi

# Install postgresql client (for psql)
if ! command -v psql &> /dev/null; then
    echo "Installing PostgreSQL client..."
    brew install postgresql libpq
    echo -e "${GREEN}✅ PostgreSQL client installed${NC}"
else
    echo -e "${GREEN}✅ PostgreSQL client already installed${NC}"
fi

# Install redis client
if ! command -v redis-cli &> /dev/null; then
    echo "Installing Redis client..."
    brew install redis
    echo -e "${GREEN}✅ Redis client installed${NC}"
else
    echo -e "${GREEN}✅ Redis client already installed${NC}"
fi

# Install ssh-copy-id if needed
if ! command -v ssh-copy-id &> /dev/null; then
    echo "Installing ssh-copy-id..."
    brew install ssh-copy-id
    echo -e "${GREEN}✅ ssh-copy-id installed${NC}"
else
    echo -e "${GREEN}✅ ssh-copy-id already installed${NC}"
fi

echo ""

# Step 3: Prepare Docker Compose files
echo -e "${YELLOW}Step 3: Preparing Docker Compose configurations...${NC}\n"

TEMP_DIR="$HOME/Developer/temp-workspace/nas-configs"
mkdir -p "$TEMP_DIR"

# Create basic docker-compose.yml
cat > "$TEMP_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  # PostgreSQL - Main database
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: nandez
      POSTGRES_PASSWORD: changeme123
      POSTGRES_DB: postgres
    ports:
      - "5432:5432"
    volumes:
      - /volume1/docker-data/databases/postgres:/var/lib/postgresql/data
    networks:
      - nas-network

  # Redis - Cache & queues
  redis:
    image: redis:7-alpine
    container_name: redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - /volume1/docker-data/databases/redis:/data
    command: redis-server --appendonly yes
    networks:
      - nas-network

  # Portainer - Docker management UI
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /volume1/docker-data/services/portainer:/data
    networks:
      - nas-network

networks:
  nas-network:
    driver: bridge
EOF

echo -e "${GREEN}✅ docker-compose.yml created in $TEMP_DIR${NC}\n"

# Create NAS deployment script
cat > "$TEMP_DIR/deploy-to-nas.sh" << 'EOF'
#!/bin/bash
# Deploy Docker services to NAS
# Run this after NAS is configured

set -e

NAS_IP="192.168.1.177"
NAS_USER="nandez"

echo "Deploying Docker services to NAS..."

# Copy docker-compose file
scp docker-compose.yml $NAS_USER@$NAS_IP:/volume1/docker-data/

# SSH and start services
ssh $NAS_USER@$NAS_IP << 'ENDSSH'
cd /volume1/docker-data
docker compose down
docker compose pull
docker compose up -d
docker ps
ENDSSH

echo "✅ Deployment complete!"
echo "Access Portainer: http://$NAS_IP:9000"
EOF

chmod +x "$TEMP_DIR/deploy-to-nas.sh"
echo -e "${GREEN}✅ deploy-to-nas.sh created${NC}\n"

# Create NAS directory structure script
cat > "$TEMP_DIR/setup-nas-dirs.sh" << 'EOF'
#!/bin/bash
# Run this on NAS after SSH is enabled
# Creates directory structure for Docker

set -e

echo "Creating NAS directory structure..."

# Create base directories
mkdir -p /volume1/docker-data/{databases,services,backups}
mkdir -p /volume1/docker-data/databases/{postgres,mongodb,redis}
mkdir -p /volume1/docker-data/services/{nextcloud,photoprism,portainer}

# Set permissions
chown -R $(whoami):$(whoami) /volume1/docker-data
chmod -R 755 /volume1/docker-data

echo "✅ Directory structure created:"
ls -la /volume1/docker-data/
EOF

chmod +x "$TEMP_DIR/setup-nas-dirs.sh"
echo -e "${GREEN}✅ setup-nas-dirs.sh created${NC}\n"

# Step 4: Add NAS configuration to .zshrc
echo -e "${YELLOW}Step 4: Adding NAS configuration to ~/.zshrc...${NC}\n"

ZSHRC="$HOME/.zshrc"

# Backup .zshrc
cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"

# Check if NAS config already exists
if grep -q "# NAS Configuration" "$ZSHRC" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  NAS configuration already exists in .zshrc${NC}"
    echo -e "${YELLOW}Skipping to avoid duplicates${NC}\n"
else
    cat >> "$ZSHRC" << 'EOF'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NAS Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
export NAS_IP="192.168.1.177"
export NAS_USER="nandez"
export NAS_DEV="/Volumes/development"
export NAS_BACKUP="/Volumes/backups"
export NAS_CLOUD="/Volumes/cloud"

# NAS Aliases
alias nas-ssh='ssh $NAS_USER@$NAS_IP'
alias nas-dev='cd $NAS_DEV'
alias nas-backup='cd $NAS_BACKUP'
alias nas-cloud='cd $NAS_CLOUD'
alias nas-docker='ssh $NAS_USER@$NAS_IP "docker ps"'
alias nas-logs='ssh $NAS_USER@$NAS_IP "docker logs -f"'
alias nas-deploy='cd ~/Developer/temp-workspace/nas-configs && ./deploy-to-nas.sh'

# Quick NAS status check
nas-status() {
    echo "🔍 Checking NAS status..."
    if ping -c 1 -W 1 $NAS_IP &>/dev/null; then
        echo "✅ NAS is online at $NAS_IP"
        ssh $NAS_USER@$NAS_IP "uptime; df -h | grep volume1; docker ps --format 'table {{.Names}}\t{{.Status}}'"
    else
        echo "❌ NAS is offline or unreachable"
    fi
}
EOF
    echo -e "${GREEN}✅ NAS configuration added to .zshrc${NC}\n"
fi

# Step 5: Create connection test script
echo -e "${YELLOW}Step 5: Creating NAS connection test script...${NC}\n"

cat > "$TEMP_DIR/test-nas-connection.sh" << 'EOF'
#!/bin/bash
# Test NAS connection and services

NAS_IP="${NAS_IP:-192.168.1.177}"
NAS_USER="${NAS_USER:-nandez}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  NAS Connection Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test 1: Ping
echo "1. Testing network connectivity..."
if ping -c 1 -W 2 $NAS_IP &>/dev/null; then
    echo "   ✅ NAS is reachable at $NAS_IP"
else
    echo "   ❌ Cannot reach NAS"
    exit 1
fi

# Test 2: SSH
echo "2. Testing SSH access..."
if ssh -o ConnectTimeout=5 -o BatchMode=yes $NAS_USER@$NAS_IP "echo 'SSH OK'" 2>/dev/null; then
    echo "   ✅ SSH connection successful"
else
    echo "   ❌ SSH connection failed"
    echo "   Run: ssh-copy-id $NAS_USER@$NAS_IP"
fi

# Test 3: Docker
echo "3. Testing Docker..."
DOCKER_STATUS=$(ssh $NAS_USER@$NAS_IP "docker ps --format '{{.Names}}'" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "   ✅ Docker is running"
    if [ -n "$DOCKER_STATUS" ]; then
        echo "   Running containers:"
        echo "$DOCKER_STATUS" | sed 's/^/      - /'
    else
        echo "   No containers running yet"
    fi
else
    echo "   ❌ Cannot access Docker"
fi

# Test 4: PostgreSQL
echo "4. Testing PostgreSQL..."
if psql -h $NAS_IP -U nandez -d postgres -c "SELECT version();" &>/dev/null; then
    echo "   ✅ PostgreSQL is accessible"
else
    echo "   ⚠️  PostgreSQL not accessible (may not be started yet)"
fi

# Test 5: Redis
echo "5. Testing Redis..."
if redis-cli -h $NAS_IP ping 2>/dev/null | grep -q PONG; then
    echo "   ✅ Redis is accessible"
else
    echo "   ⚠️  Redis not accessible (may not be started yet)"
fi

# Test 6: SMB Shares
echo "6. Testing SMB shares..."
if smbutil view //$NAS_USER@$NAS_IP 2>/dev/null | grep -q "Share"; then
    echo "   ✅ SMB shares are accessible"
    smbutil view //$NAS_USER@$NAS_IP 2>/dev/null | grep "^Share:" | sed 's/^/      /'
else
    echo "   ⚠️  SMB shares not accessible yet"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test complete!"
EOF

chmod +x "$TEMP_DIR/test-nas-connection.sh"
echo -e "${GREEN}✅ test-nas-connection.sh created${NC}\n"

# Step 6: Create SSH config entry
echo -e "${YELLOW}Step 6: Adding NAS to SSH config...${NC}\n"

SSH_CONFIG="$HOME/.ssh/config"
mkdir -p ~/.ssh
touch "$SSH_CONFIG"

if grep -q "Host nas" "$SSH_CONFIG" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  NAS SSH config already exists${NC}\n"
else
    cat >> "$SSH_CONFIG" << EOF

# NAS (UGREEN DXP4800 Plus)
Host nas
    HostName 192.168.1.177
    User nandez
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
EOF
    echo -e "${GREEN}✅ NAS added to SSH config${NC}"
    echo -e "${GREEN}   You can now use: ssh nas${NC}\n"
fi

# Step 7: Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  ✅ Preparation Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${GREEN}What was done:${NC}"
echo "  ✅ SSH key generated (if needed)"
echo "  ✅ Required tools installed (psql, redis-cli)"
echo "  ✅ Docker Compose files prepared"
echo "  ✅ NAS deployment scripts created"
echo "  ✅ .zshrc configured with NAS aliases"
echo "  ✅ SSH config updated"
echo ""

echo -e "${YELLOW}Files created in:${NC} $TEMP_DIR"
echo "  - docker-compose.yml (ready to deploy)"
echo "  - deploy-to-nas.sh (deploy Docker services)"
echo "  - setup-nas-dirs.sh (run on NAS first)"
echo "  - test-nas-connection.sh (verify everything works)"
echo ""

echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Reload your shell: ${BLUE}source ~/.zshrc${NC}"
echo "  2. Connect NAS to Mac with Ethernet cable"
echo "  3. Follow NAS-First-Time-Setup.md guide"
echo "  4. After NAS setup, copy SSH key: ${BLUE}ssh-copy-id nandez@192.168.1.177${NC}"
echo "  5. Copy setup script to NAS: ${BLUE}scp $TEMP_DIR/setup-nas-dirs.sh nandez@192.168.1.177:~${NC}"
echo "  6. Run on NAS: ${BLUE}ssh nas 'bash ~/setup-nas-dirs.sh'${NC}"
echo "  7. Deploy services: ${BLUE}nas-deploy${NC}"
echo "  8. Test connection: ${BLUE}$TEMP_DIR/test-nas-connection.sh${NC}"
echo ""

echo -e "${GREEN}Your SSH public key (for reference):${NC}"
cat ~/.ssh/id_ed25519.pub
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
