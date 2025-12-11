#!/bin/bash
# NAS Deploy - Deploy projects to self-hosted production on NAS
# Usage: ./nas-deploy.sh <project-name> <environment>

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Load NAS config
if [ -f ~/Desktop/workspace/nas-config.txt ]; then
    source ~/Desktop/workspace/nas-config.txt
else
    echo -e "${RED}❌ NAS not configured. Run setup-nas.sh first${NC}"
    exit 1
fi

# Parse arguments
PROJECT_NAME=${1:-}
ENVIRONMENT=${2:-production}

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Usage: ./nas-deploy.sh <project-name> [environment]${NC}"
    echo ""
    echo "Examples:"
    echo "  ./nas-deploy.sh Insight production"
    echo "  ./nas-deploy.sh Insight staging"
    echo ""
    exit 1
fi

# Check if project exists
if [ ! -d ~/Desktop/workspace/$PROJECT_NAME ]; then
    echo -e "${RED}❌ Project not found: ~/Desktop/workspace/$PROJECT_NAME${NC}"
    exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Deploy: $PROJECT_NAME ($ENVIRONMENT)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Step 1: Sync project to NAS
echo -e "${YELLOW}Step 1: Syncing project to NAS...${NC}\n"

PROJECT_DIR="/volume1/development/projects/$ENVIRONMENT/$PROJECT_NAME"

# Create project directory on NAS
sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "mkdir -p $PROJECT_DIR" 2>/dev/null

# Sync files (exclude node_modules, dist, .git)
rsync -avz --delete \
    --exclude='node_modules' \
    --exclude='dist' \
    --exclude='build' \
    --exclude='.git' \
    --exclude='.env.local' \
    --exclude='.DS_Store' \
    ~/Desktop/workspace/$PROJECT_NAME/ \
    $NAS_USER@$NAS_IP:$PROJECT_DIR/

echo -e "${GREEN}✅ Project synced${NC}"

# Step 2: Build project on NAS
echo -e "\n${YELLOW}Step 2: Building project on NAS...${NC}\n"

# Detect project type
if [ -f ~/Desktop/workspace/$PROJECT_NAME/package.json ]; then
    echo "Node.js project detected"
    
    # Install dependencies
    sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP << EOF
        cd $PROJECT_DIR
        npm install --production
        
        # Build if build script exists
        if grep -q '"build"' package.json; then
            npm run build
        fi
EOF
    
    echo -e "${GREEN}✅ Build complete${NC}"
else
    echo -e "${YELLOW}⚠️  No package.json found, skipping build${NC}"
fi

# Step 3: Create Docker container
echo -e "\n${YELLOW}Step 3: Creating Docker container...${NC}\n"

# Generate Dockerfile if not exists
if [ ! -f ~/Desktop/workspace/$PROJECT_NAME/Dockerfile ]; then
    echo "Generating Dockerfile..."
    
    sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP << 'EOF'
cat > $PROJECT_DIR/Dockerfile << 'DOCKERFILE'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --production

COPY . .

# Environment variables
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
    CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["npm", "start"]
DOCKERFILE
EOF
fi

# Build Docker image
CONTAINER_NAME="${PROJECT_NAME,,}-${ENVIRONMENT}"
IMAGE_NAME="${PROJECT_NAME,,}:${ENVIRONMENT}"

sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP << EOF
    cd $PROJECT_DIR
    
    # Stop existing container
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    
    # Build new image
    docker build -t $IMAGE_NAME .
    
    # Run container
    docker run -d \
        --name $CONTAINER_NAME \
        --restart unless-stopped \
        -p 3000:3000 \
        -e DATABASE_URL=postgresql://nandez:changeme123@localhost:5432/${PROJECT_NAME,,} \
        -e MONGODB_URL=mongodb://nandez:changeme123@localhost:27017/${PROJECT_NAME,,} \
        -e REDIS_URL=redis://localhost:6379 \
        -e OLLAMA_HOST=http://localhost:11434 \
        --network host \
        $IMAGE_NAME
EOF

echo -e "${GREEN}✅ Container deployed${NC}"

# Step 4: Setup reverse proxy
echo -e "\n${YELLOW}Step 4: Configuring reverse proxy...${NC}\n"

# Get Tailscale IP
TAILSCALE_IP=$(sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP "tailscale ip -4" 2>/dev/null || echo "100.x.x.x")

echo -e "${BLUE}Access your app:${NC}"
echo -e "  Tailscale: http://$TAILSCALE_IP:3000"
echo -e "  Local:     http://$NAS_IP:3000"

# Step 5: Setup database
echo -e "\n${YELLOW}Step 5: Setting up database...${NC}\n"

# Create PostgreSQL database
sshpass -p "$NAS_PASS" ssh $NAS_USER@$NAS_IP << EOF
    docker exec postgres psql -U nandez -c "CREATE DATABASE ${PROJECT_NAME,,}" 2>/dev/null || echo "Database already exists"
EOF

# Create MongoDB database (auto-creates on first connection)
echo -e "${GREEN}✅ Database ready${NC}"

# Step 6: Summary
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Deployment Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BLUE}📋 Deployment Summary:${NC}"
echo "  Project:     $PROJECT_NAME"
echo "  Environment: $ENVIRONMENT"
echo "  Container:   $CONTAINER_NAME"
echo "  Image:       $IMAGE_NAME"
echo ""

echo -e "${BLUE}🌐 Access URLs:${NC}"
echo "  Tailscale:   http://$TAILSCALE_IP:3000"
echo "  Local:       http://$NAS_IP:3000"
echo ""

echo -e "${BLUE}💾 Database:${NC}"
echo "  PostgreSQL:  postgresql://nandez:changeme123@$NAS_IP:5432/${PROJECT_NAME,,}"
echo "  MongoDB:     mongodb://nandez:changeme123@$NAS_IP:27017/${PROJECT_NAME,,}"
echo "  Redis:       redis://$NAS_IP:6379"
echo ""

echo -e "${BLUE}🤖 AI Services:${NC}"
echo "  Ollama:      http://$NAS_IP:11434"
echo "  Open WebUI:  http://$NAS_IP:3001"
echo ""

echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo "  View logs:      ssh $NAS_USER@$NAS_IP 'docker logs -f $CONTAINER_NAME'"
echo "  Restart:        ssh $NAS_USER@$NAS_IP 'docker restart $CONTAINER_NAME'"
echo "  Stop:           ssh $NAS_USER@$NAS_IP 'docker stop $CONTAINER_NAME'"
echo "  Shell access:   ssh $NAS_USER@$NAS_IP 'docker exec -it $CONTAINER_NAME sh'"
echo ""

echo -e "${YELLOW}💡 Next Steps:${NC}"
echo "  1. Test your app: http://$TAILSCALE_IP:3000"
echo "  2. Check logs: docker logs -f $CONTAINER_NAME"
echo "  3. Update .env files with NAS database URLs"
echo ""

# Save deployment info
cat > ~/Desktop/workspace/${PROJECT_NAME}-deployment.txt << EOF
Deployment: $PROJECT_NAME ($ENVIRONMENT)
Date: $(date)
Container: $CONTAINER_NAME
Access: http://$TAILSCALE_IP:3000

Database URLs:
  PostgreSQL: postgresql://nandez:changeme123@$NAS_IP:5432/${PROJECT_NAME,,}
  MongoDB: mongodb://nandez:changeme123@$NAS_IP:27017/${PROJECT_NAME,,}
  Redis: redis://$NAS_IP:6379

AI:
  Ollama: http://$NAS_IP:11434
EOF

echo -e "${GREEN}Deployment info saved: ~/Desktop/workspace/${PROJECT_NAME}-deployment.txt${NC}\n"
