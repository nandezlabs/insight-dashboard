#!/bin/bash

# Backend Setup Script
# Installs Python dependencies and verifies setup

set -e  # Exit on error

echo "🔧 Setting up Backend Environment..."

# Check Python version
echo "Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
required_version="3.11"

if [[ $(echo -e "$python_version\n$required_version" | sort -V | head -n1) != "$required_version" ]]; then
    echo "❌ Python $required_version or higher required. Found: $python_version"
    exit 1
fi
echo "✅ Python $python_version detected"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies from requirements.txt..."
pip install -r requirements.txt

echo ""
echo "✅ Backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Copy .env.example to .env and configure your Supabase credentials"
echo "2. Activate venv: source venv/bin/activate"
echo "3. Start server: uvicorn main:app --reload"
echo "4. Visit http://localhost:8000/docs for API documentation"
