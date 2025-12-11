#!/bin/bash
# Quick Commit - Auto-stage and commit with timestamp
# Usage: ./quick-commit.sh [optional message]

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not a git repository"
    exit 1
fi

# Check for unstaged changes
if [[ -z $(git status -s) ]]; then
    echo "✓ No changes to commit"
    exit 0
fi

# Stage all changes
git add -A
echo -e "${BLUE}📦 Staged all changes${NC}"

# Generate commit message
if [ -z "$1" ]; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    COMMIT_MSG="Update: $TIMESTAMP"
else
    COMMIT_MSG="$*"
fi

# Commit
git commit -m "$COMMIT_MSG"
echo -e "${GREEN}✓ Committed: $COMMIT_MSG${NC}"

# Show status
echo -e "\n${BLUE}Current branch:${NC}"
git branch --show-current
