#!/bin/bash
# Check Secrets - Scan for accidentally committed secrets
# Usage: ./check-secrets.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔒 Scanning for secrets...${NC}\n"

PATTERNS=(
    "api[_-]?key"
    "api[_-]?secret"
    "access[_-]?token"
    "secret[_-]?key"
    "private[_-]?key"
    "password"
    "passwd"
    "aws[_-]?access"
    "aws[_-]?secret"
    "AKIA[0-9A-Z]{16}"  # AWS Access Key
)

FOUND=0

cd "$HOME/Developer/projects"

for PROJECT in *; do
    if [ -d "$PROJECT/.git" ]; then
        cd "$PROJECT"
        PROJECT_NAME=$(basename "$PROJECT")
        
        for PATTERN in "${PATTERNS[@]}"; do
            RESULTS=$(git grep -i -n "$PATTERN" -- ':(exclude)*.md' ':(exclude)package-lock.json' 2>/dev/null || true)
            
            if [ -n "$RESULTS" ]; then
                if [ $FOUND -eq 0 ]; then
                    echo -e "${YELLOW}⚠️  Potential secrets found in $PROJECT_NAME:${NC}"
                    FOUND=1
                fi
                echo "$RESULTS" | head -5
                echo ""
            fi
        done
        
        cd ..
    fi
done

if [ $FOUND -eq 0 ]; then
    echo -e "${GREEN}✓ No obvious secrets found${NC}"
else
    echo -e "${RED}⚠️  Review the above findings${NC}"
    echo -e "${YELLOW}Remember to:${NC}"
    echo "  - Use .env files (and add to .gitignore)"
    echo "  - Never commit API keys or passwords"
    echo "  - Rotate any exposed credentials"
fi
