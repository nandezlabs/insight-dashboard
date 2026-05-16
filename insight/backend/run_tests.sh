#!/bin/bash
# Run backend tests with pytest

set -e

echo "🧪 Running Backend Tests..."
echo "================================"

# Activate virtual environment
if [ -d "venv" ]; then
    source venv/bin/activate
    echo "✓ Virtual environment activated"
else
    echo "❌ Virtual environment not found. Run ./setup.sh first."
    exit 1
fi

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "❌ pytest not found. Installing test dependencies..."
    pip install pytest pytest-asyncio pytest-cov httpx
fi

# Run tests with coverage
echo ""
echo "Running tests..."
python -m pytest tests/ -v --cov=. --cov-report=term-missing --cov-report=html

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All tests passed!"
    echo ""
    echo "📊 Coverage report generated in htmlcov/index.html"
    echo "   Open it with: open htmlcov/index.html"
else
    echo ""
    echo "❌ Some tests failed. Check output above."
    exit 1
fi
