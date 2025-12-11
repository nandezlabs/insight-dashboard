#!/bin/bash
# Rotate Keys - Helper for updating API keys safely
# Usage: ./rotate-keys.sh <project-name>

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT="$HOME/Developer/projects/$1"

if [ ! -d "$PROJECT" ]; then
    echo "❌ Project not found: $1"
    exit 1
fi

cd "$PROJECT"

echo -e "${BLUE}🔐 Key Rotation Checklist for $1${NC}\n"

# Check for .env files
echo -e "${YELLOW}1. Environment Files:${NC}"
find . -name ".env*" -not -path "*/node_modules/*" 2>/dev/null | while read envfile; do
    echo "   → $envfile"
done

echo ""
echo -e "${YELLOW}2. Steps to rotate keys:${NC}"
echo "   1. Generate new API keys from service provider"
echo "   2. Update .env files with new keys"
echo "   3. Test the application"
echo "   4. Revoke old keys from service provider"
echo "   5. Clear any cached credentials"

echo ""
echo -e "${YELLOW}3. Common key locations:${NC}"
echo "   → .env"
echo "   → .env.local"
echo "   → .env.production"
echo "   → config/ directory"

echo ""
echo -e "${GREEN}✓ Remember to NEVER commit .env files${NC}"
echo -e "${BLUE}Add to .gitignore:${NC}"
echo "   .env"
echo "   .env.local"
echo "   .env.*.local"
echo "   *.secrets"
