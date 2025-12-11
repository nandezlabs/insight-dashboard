#!/bin/bash
# Encrypt ENV - Encrypt sensitive environment files
# Usage: ./encrypt-env.sh <project-name>

set -e

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

echo "🔐 Encrypting .env files for $1..."

# Check if gpg is installed
if ! command -v gpg &> /dev/null; then
    echo "❌ gpg not installed. Install with: brew install gpg"
    exit 1
fi

# Find and encrypt .env files
find . -name ".env*" -not -name "*.gpg" -not -name "*.example" \
    -not -path "*/node_modules/*" 2>/dev/null | while read envfile; do
    
    echo "  → Encrypting $envfile..."
    gpg --symmetric --cipher-algo AES256 "$envfile"
    echo "    Created: ${envfile}.gpg"
    echo ""
done

echo "✓ Encryption complete"
echo ""
echo "To decrypt later:"
echo "  gpg -d .env.gpg > .env"
echo ""
echo "⚠️  Remember to:"
echo "  - Add *.gpg to git (encrypted files are safe)"
echo "  - Add .env to .gitignore (plaintext should NEVER be committed)"
echo "  - Store the encryption password safely"
