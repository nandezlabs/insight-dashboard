#!/bin/bash

################################################################################
# Python Project Creator
# Creates a new Python project with proper structure and configuration
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECTS_DIR="$HOME/Developer/projects"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🐍 Python Project Creator${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

validate_project_name() {
    local name="$1"
    
    # Check if name is empty
    if [[ -z "$name" ]]; then
        print_error "Project name cannot be empty"
        return 1
    fi
    
    # Check if name contains only valid characters (lowercase, numbers, hyphens, underscores)
    if [[ ! "$name" =~ ^[a-z0-9_-]+$ ]]; then
        print_error "Project name can only contain lowercase letters, numbers, hyphens, and underscores"
        return 1
    fi
    
    # Check if directory already exists
    if [[ -d "$PROJECTS_DIR/$name" ]]; then
        print_error "Project directory already exists: $PROJECTS_DIR/$name"
        return 1
    fi
    
    return 0
}

################################################################################
# Project Structure Creation
################################################################################

create_directory_structure() {
    local project_name="$1"
    local project_type="$2"
    
    print_info "Creating directory structure..."
    
    # Convert project-name to project_name for package
    local package_name="${project_name//-/_}"
    
    # Base structure
    mkdir -p "$project_name/src/$package_name"
    mkdir -p "$project_name/tests"
    mkdir -p "$project_name/docs"
    mkdir -p "$project_name/.vscode"
    
    # Type-specific directories
    case $project_type in
        cli)
            mkdir -p "$project_name/src/$package_name/commands"
            ;;
        web-flask)
            mkdir -p "$project_name/src/$package_name/routes"
            mkdir -p "$project_name/src/$package_name/models"
            mkdir -p "$project_name/src/$package_name/templates"
            mkdir -p "$project_name/src/$package_name/static"
            ;;
        web-fastapi)
            mkdir -p "$project_name/src/$package_name/api"
            mkdir -p "$project_name/src/$package_name/models"
            mkdir -p "$project_name/src/$package_name/schemas"
            mkdir -p "$project_name/src/$package_name/core"
            ;;
        data)
            mkdir -p "$project_name/notebooks"
            mkdir -p "$project_name/data/raw"
            mkdir -p "$project_name/data/processed"
            mkdir -p "$project_name/models"
            ;;
    esac
    
    print_success "Directory structure created"
}

create_python_files() {
    local project_name="$1"
    local project_type="$2"
    local description="$3"
    
    local package_name="${project_name//-/_}"
    
    print_info "Creating Python files..."
    
    # __init__.py for package
    cat > "$project_name/src/$package_name/__init__.py" << EOF
"""
$description
"""

__version__ = "0.1.0"
__author__ = "nandezlabs"
EOF

    # Main entry point based on type
    case $project_type in
        cli)
            cat > "$project_name/src/$package_name/__main__.py" << 'EOF'
"""
Main entry point for CLI application.
"""
import sys
from .cli import main

if __name__ == "__main__":
    sys.exit(main())
EOF

            cat > "$project_name/src/$package_name/cli.py" << 'EOF'
"""
Command-line interface implementation.
"""
import argparse
from . import __version__


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="CLI tool description"
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}"
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )
    
    args = parser.parse_args()
    
    print("Hello from CLI!")
    return 0


if __name__ == "__main__":
    main()
EOF
            ;;
            
        web-flask)
            cat > "$project_name/src/$package_name/app.py" << 'EOF'
"""
Flask application setup.
"""
from flask import Flask

app = Flask(__name__)


@app.route("/")
def index():
    """Home page."""
    return {"message": "Hello from Flask!"}


@app.route("/health")
def health():
    """Health check endpoint."""
    return {"status": "healthy"}


if __name__ == "__main__":
    app.run(debug=True)
EOF
            ;;
            
        web-fastapi)
            cat > "$project_name/src/$package_name/main.py" << 'EOF'
"""
FastAPI application setup.
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="API",
    description="FastAPI application",
    version="0.1.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """Root endpoint."""
    return {"message": "Hello from FastAPI!"}


@app.get("/health")
async def health():
    """Health check endpoint."""
    return {"status": "healthy"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

            cat > "$project_name/src/$package_name/schemas/__init__.py" << 'EOF'
"""
Pydantic schemas for request/response validation.
"""
EOF

            cat > "$project_name/src/$package_name/core/config.py" << 'EOF'
"""
Application configuration.
"""
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""
    
    app_name: str = "FastAPI App"
    debug: bool = True
    api_prefix: str = "/api/v1"
    
    class Config:
        env_file = ".env"


settings = Settings()
EOF
            ;;
            
        data)
            cat > "$project_name/src/$package_name/analysis.py" << 'EOF'
"""
Data analysis utilities.
"""
import pandas as pd
import numpy as np
from pathlib import Path


def load_data(filepath: str) -> pd.DataFrame:
    """
    Load data from file.
    
    Args:
        filepath: Path to data file
        
    Returns:
        DataFrame containing the data
    """
    return pd.read_csv(filepath)


def preprocess_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Preprocess the input data.
    
    Args:
        df: Input DataFrame
        
    Returns:
        Preprocessed DataFrame
    """
    # Add preprocessing steps here
    return df


def main():
    """Main analysis pipeline."""
    print("Running data analysis...")
    # Add your analysis code here


if __name__ == "__main__":
    main()
EOF
            ;;
            
        lib)
            cat > "$project_name/src/$package_name/core.py" << 'EOF'
"""
Core library functionality.
"""


class Example:
    """Example class for library."""
    
    def __init__(self, name: str):
        self.name = name
    
    def greet(self) -> str:
        """Return a greeting message."""
        return f"Hello from {self.name}!"


def utility_function(value: int) -> int:
    """
    Example utility function.
    
    Args:
        value: Input value
        
    Returns:
        Processed value
    """
    return value * 2
EOF
            ;;
    esac
    
    # Test file
    cat > "$project_name/tests/test_basic.py" << EOF
"""
Basic tests for ${package_name}.
"""
import pytest
from ${package_name} import __version__


def test_version():
    """Test version is set."""
    assert __version__ == "0.1.0"


def test_example():
    """Example test case."""
    assert True
EOF

    print_success "Python files created"
}

create_pyproject_toml() {
    local project_name="$1"
    local project_type="$2"
    local description="$3"
    
    local package_name="${project_name//-/_}"
    
    print_info "Creating pyproject.toml..."
    
    # Base dependencies
    local base_deps='dependencies = [
    "python-dateutil>=2.8.0",
]'

    # Type-specific dependencies
    case $project_type in
        cli)
            base_deps='dependencies = [
    "click>=8.0.0",
    "rich>=13.0.0",
]'
            ;;
        web-flask)
            base_deps='dependencies = [
    "flask>=3.0.0",
    "python-dotenv>=1.0.0",
]'
            ;;
        web-fastapi)
            base_deps='dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
    "pydantic>=2.5.0",
    "pydantic-settings>=2.1.0",
    "python-dotenv>=1.0.0",
]'
            ;;
        data)
            base_deps='dependencies = [
    "pandas>=2.0.0",
    "numpy>=1.24.0",
    "matplotlib>=3.7.0",
    "jupyter>=1.0.0",
]'
            ;;
    esac
    
    cat > "$project_name/pyproject.toml" << EOF
[build-system]
requires = ["setuptools>=65.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$package_name"
version = "0.1.0"
description = "$description"
readme = "README.md"
requires-python = ">=3.11"
authors = [
    {name = "nandezlabs"}
]
license = {text = "MIT"}
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]
$base_deps

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "pytest-cov>=4.1.0",
    "black>=24.0.0",
    "ruff>=0.1.0",
    "mypy>=1.8.0",
    "pre-commit>=3.6.0",
]

[project.urls]
Homepage = "https://github.com/nandezlabs/$project_name"
Repository = "https://github.com/nandezlabs/$project_name"

[tool.setuptools]
package-dir = {"" = "src"}

[tool.setuptools.packages.find]
where = ["src"]

[tool.black]
line-length = 88
target-version = ['py311']
include = '\.pyi?$'

[tool.ruff]
line-length = 88
target-version = "py311"

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-v --cov=src --cov-report=html --cov-report=term"
EOF

    print_success "pyproject.toml created"
}

create_requirements_files() {
    local project_name="$1"
    
    print_info "Creating requirements files..."
    
    # requirements.txt (minimal, pyproject.toml is source of truth)
    cat > "$project_name/requirements.txt" << 'EOF'
# Install with: pip install -e .
# For development: pip install -e ".[dev]"
# This file is kept for backwards compatibility
EOF

    # requirements-dev.txt
    cat > "$project_name/requirements-dev.txt" << 'EOF'
# Development dependencies
pytest>=8.0.0
pytest-cov>=4.1.0
black>=24.0.0
ruff>=0.1.0
mypy>=1.8.0
ipython>=8.20.0
EOF

    print_success "Requirements files created"
}

create_gitignore() {
    local project_name="$1"
    
    print_info "Creating .gitignore..."
    
    cat > "$project_name/.gitignore" << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
pip-wheel-metadata/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual Environment
venv/
env/
ENV/
.venv

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
.idea/
*.swp
*.swo
*~

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.hypothesis/

# Jupyter
.ipynb_checkpoints/
*.ipynb

# Environment
.env
.env.local
*.env

# OS
.DS_Store
Thumbs.db

# Data (for data science projects)
data/raw/*
data/processed/*
!data/raw/.gitkeep
!data/processed/.gitkeep
*.csv
*.parquet

# Models
models/*.pkl
models/*.h5
models/*.joblib
!models/.gitkeep

# Logs
*.log
logs/
EOF

    print_success ".gitignore created"
}

create_readme() {
    local project_name="$1"
    local project_type="$2"
    local description="$3"
    
    local package_name="${project_name//-/_}"
    
    print_info "Creating README.md..."
    
    # Type-specific quick start
    local quick_start=""
    case $project_type in
        cli)
            quick_start="\`\`\`bash
# Run the CLI
python -m $package_name --help

# Or after installation
$package_name --help
\`\`\`"
            ;;
        web-flask)
            quick_start="\`\`\`bash
# Run development server
python -m $package_name.app

# Or using Flask
flask --app src/$package_name/app run --debug
\`\`\`"
            ;;
        web-fastapi)
            quick_start="\`\`\`bash
# Run development server
uvicorn $package_name.main:app --reload

# Or using python
python -m $package_name.main

# API docs available at:
# http://localhost:8000/docs (Swagger UI)
# http://localhost:8000/redoc (ReDoc)
\`\`\`"
            ;;
        data)
            quick_start="\`\`\`bash
# Start Jupyter
jupyter notebook notebooks/

# Or run analysis
python -m $package_name.analysis
\`\`\`"
            ;;
        lib)
            quick_start="\`\`\`python
from $package_name import Example

example = Example(\"Library\")
print(example.greet())
\`\`\`"
            ;;
    esac
    
    cat > "$project_name/README.md" << EOF
# $project_name

$description

## Status
- **Type**: $project_type
- **Created**: $(date +%Y-%m-%d)
- **Python**: 3.11+

## Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/nandezlabs/$project_name.git
cd $project_name

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate

# Install in development mode
pip install -e ".[dev]"
\`\`\`

## Quick Start

$quick_start

## Development

### Setup Development Environment

\`\`\`bash
# Install development dependencies
pip install -e ".[dev]"

# Run tests
pytest

# Run tests with coverage
pytest --cov

# Format code
black src/ tests/

# Lint code
ruff check src/ tests/

# Type checking
mypy src/
\`\`\`

### Project Structure

\`\`\`
$project_name/
├── src/
│   └── $package_name/        # Main package
│       ├── __init__.py
│       └── ...
├── tests/                    # Test files
├── docs/                     # Documentation
├── pyproject.toml           # Project configuration
└── README.md
\`\`\`

## Testing

\`\`\`bash
# Run all tests
pytest

# Run with coverage report
pytest --cov --cov-report=html

# Run specific test file
pytest tests/test_basic.py

# Run tests in watch mode
pytest-watch
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'feat: add amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## License

MIT License - see LICENSE file for details

## Author

nandezlabs

---

**Built with ❤️ using Python**
EOF

    print_success "README.md created"
}

create_vscode_workspace() {
    local project_name="$1"
    local project_type="$2"
    
    local package_name="${project_name//-/_}"
    
    print_info "Creating VS Code workspace settings..."
    
    cat > "$project_name/.vscode/settings.json" << 'EOF'
{
  // Python Configuration
  "python.defaultInterpreterPath": "${workspaceFolder}/venv/bin/python",
  "python.terminal.activateEnvironment": true,
  
  // Formatting
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  },
  
  // Linting
  "python.linting.enabled": true,
  "python.linting.ruffEnabled": true,
  
  // Testing
  "python.testing.pytestEnabled": true,
  "python.testing.unittestEnabled": false,
  "python.testing.pytestArgs": [
    "tests"
  ],
  
  // Type Checking
  "python.analysis.typeCheckingMode": "basic",
  
  // File Exclusions
  "files.exclude": {
    "**/__pycache__": true,
    "**/*.pyc": true,
    ".pytest_cache": true,
    ".coverage": true,
    "htmlcov": true,
    ".mypy_cache": true,
    ".ruff_cache": true,
    "*.egg-info": true
  },
  
  // Search Exclusions
  "search.exclude": {
    "**/__pycache__": true,
    "**/*.pyc": true,
    "**/venv": true,
    "**/.venv": true
  },
  
  // Editor
  "editor.rulers": [88],
  "editor.tabSize": 4,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true
}
EOF

    cat > "$project_name/.vscode/extensions.json" << 'EOF'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-python.black-formatter",
    "charliermarsh.ruff",
    "ms-toolsai.jupyter"
  ]
}
EOF

    print_success "VS Code workspace configured"
}

create_precommit_config() {
    local project_name="$1"
    
    print_info "Creating pre-commit configuration..."
    
    cat > "$project_name/.pre-commit-config.yaml" << 'EOF'
# Pre-commit hooks configuration
# Install: pre-commit install
# Run manually: pre-commit run --all-files

repos:
  # Black code formatter
  - repo: https://github.com/psf/black
    rev: 24.1.1
    hooks:
      - id: black
        language_version: python3.11

  # Ruff linter
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.15
    hooks:
      - id: ruff
        args: [--fix]

  # Basic checks
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict
      - id: debug-statements

  # mypy type checking
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies: [types-all]
        args: [--ignore-missing-imports]
EOF

    print_success "Pre-commit configuration created"
}

create_github_actions() {
    local project_name="$1"
    
    print_info "Creating GitHub Actions workflow..."
    
    mkdir -p "$project_name/.github/workflows"
    
    cat > "$project_name/.github/workflows/test.yml" << 'EOF'
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]

    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e ".[dev]"
    
    - name: Run pre-commit hooks
      run: |
        pre-commit run --all-files
    
    - name: Run tests with coverage
      run: |
        pytest --cov --cov-report=xml --cov-report=term
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
        fail_ci_if_error: false
EOF

    print_success "GitHub Actions workflow created"
}

setup_github_repo() {
    local project_name="$1"
    local description="$2"
    local visibility="$3"
    
    print_info "Creating GitHub repository..."
    
    cd "$project_name"
    
    # Check if gh CLI is available
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) not found. Install with: brew install gh"
        print_info "You can create the repository manually at: https://github.com/new"
        cd ..
        return 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        print_error "Not authenticated with GitHub. Run: gh auth login"
        cd ..
        return 1
    fi
    
    # Create repository
    local visibility_flag="--public"
    if [[ "$visibility" == "private" ]]; then
        visibility_flag="--private"
    fi
    
    if gh repo create "nandezlabs/$project_name" \
        --description "$description" \
        $visibility_flag \
        --source=. \
        --remote=origin; then
        
        print_success "GitHub repository created"
        
        # Add topics
        gh repo edit "nandezlabs/$project_name" --add-topic "python" --add-topic "python3"
        
        # Push to GitHub
        git push -u origin main
        
        print_success "Code pushed to GitHub"
        
        echo -e "\n${GREEN}Repository URL:${NC} https://github.com/nandezlabs/$project_name"
    else
        print_error "Failed to create GitHub repository"
        cd ..
        return 1
    fi
    
    cd ..
}

create_makefile() {
    local project_name="$1"
    
    print_info "Creating Makefile..."
    
    cat > "$project_name/Makefile" << 'EOF'
.PHONY: help install dev test coverage lint format clean hooks

help:
	@echo "Available commands:"
	@echo "  make install   - Install package in production mode"
	@echo "  make dev       - Install package in development mode"
	@echo "  make test      - Run tests"
	@echo "  make coverage  - Run tests with coverage report"
	@echo "  make lint      - Run linters (ruff, mypy)"
	@echo "  make format    - Format code with black"
	@echo "  make hooks     - Install pre-commit hooks"
	@echo "  make clean     - Remove build artifacts"

install:
	pip install -e .

dev:
	pip install -e ".[dev]"
	pre-commit install

test:
	pytest

coverage:
	pytest --cov --cov-report=html --cov-report=term

lint:
	ruff check src/ tests/
	mypy src/

format:
	black src/ tests/
	ruff check --fix src/ tests/

hooks:
	pre-commit install
	@echo "✓ Pre-commit hooks installed"

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov
	rm -rf .mypy_cache
	rm -rf .ruff_cache
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
EOF

    print_success "Makefile created"
}

init_git_repository() {
    local project_name="$1"
    
    print_info "Initializing Git repository..."
    
    cd "$project_name"
    
    git init --initial-branch=main
    git add .
    git commit -m "Initial commit: $project_name

- Project structure initialized
- Dependencies configured in pyproject.toml
- Testing setup with pytest
- VS Code workspace configured
- Development tools configured (black, ruff, mypy)"
    
    print_success "Git repository initialized"
    
    cd ..
}

setup_virtual_environment() {
    local project_name="$1"
    
    print_info "Setting up virtual environment..."
    
    cd "$project_name"
    
    # Create virtual environment
    python3 -m venv venv
    
    # Activate and install package
    source venv/bin/activate
    pip install --upgrade pip
    pip install -e ".[dev]"
    
    print_success "Virtual environment created and dependencies installed"
    
    deactivate
    cd ..
}

################################################################################
# Main Script
################################################################################

main() {
    print_header
    
    # Get project details
    echo -e "${YELLOW}Project Configuration:${NC}\n"
    
    read -p "Project name (lowercase, hyphens): " project_name
    
    if ! validate_project_name "$project_name"; then
        exit 1
    fi
    
    read -p "Description: " description
    
    echo -e "\n${YELLOW}Project Type:${NC}"
    echo "1) CLI Tool"
    echo "2) Web Application (Flask)"
    echo "3) Web API (FastAPI)"
    echo "4) Data Science / Analysis"
    echo "5) Library / Package"
    read -p "Select type (1-5): " type_choice
    
    case $type_choice in
        1) project_type="cli" ;;
        2) project_type="web-flask" ;;
        3) project_type="web-fastapi" ;;
        4) project_type="data" ;;
        5) project_type="lib" ;;
        *) 
            print_error "Invalid selection"
            exit 1
            ;;
    esac
    
    # Ask about GitHub integration
    echo -e "\n${YELLOW}GitHub Integration:${NC}"
    read -p "Create GitHub repository? (y/n): " create_github
    
    github_create="false"
    if [[ "$create_github" == "y" || "$create_github" == "Y" ]]; then
        github_create="true"
        read -p "Repository visibility (public/private): " repo_visibility
        if [[ "$repo_visibility" != "public" && "$repo_visibility" != "private" ]]; then
            repo_visibility="public"
        fi
    fi
    
    # Confirmation
    echo -e "\n${GREEN}Project Summary:${NC}"
    echo -e "  Name: ${BLUE}$project_name${NC}"
    echo -e "  Type: ${BLUE}$project_type${NC}"
    echo -e "  Description: ${BLUE}$description${NC}"
    echo -e "  Location: ${BLUE}$PROJECTS_DIR/$project_name${NC}"
    echo ""
    
    read -p "Create project? (y/n): " confirm
    
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        print_error "Cancelled"
        exit 0
    fi
    
    # Create project
    cd "$PROJECTS_DIR"
    
    create_directory_structure "$project_name" "$project_type"
    create_python_files "$project_name" "$project_type" "$description"
    create_pyproject_toml "$project_name" "$project_type" "$description"
    create_requirements_files "$project_name"
    create_gitignore "$project_name"
    create_readme "$project_name" "$project_type" "$description"
    create_vscode_workspace "$project_name" "$project_type"
    create_precommit_config "$project_name"
    create_github_actions "$project_name"
    create_makefile "$project_name"
    init_git_repository "$project_name"
    setup_virtual_environment "$project_name"
    
    # Setup GitHub repository if requested
    if [[ "$github_create" == "true" ]]; then
        setup_github_repo "$project_name" "$description" "$repo_visibility"
    fi
    
    # Summary
    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Project created successfully!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. cd $PROJECTS_DIR/$project_name"
    echo -e "  2. source venv/bin/activate"
    echo -e "  3. code ."
    echo -e "  4. Start coding!\n"
    
    echo -e "${YELLOW}Quick commands:${NC}"
    echo -e "  make dev       - Install with dev dependencies + hooks"
    echo -e "  make test      - Run tests"
    echo -e "  make format    - Format code"
    echo -e "  make lint      - Check code quality"
    echo -e "  make coverage  - Test coverage report"
    echo -e "  make hooks     - Install pre-commit hooks\n"
    
    if [[ "$github_create" == "true" ]]; then
        echo -e "${BLUE}GitHub:${NC} https://github.com/nandezlabs/$project_name"
        echo -e "${BLUE}CI/CD:${NC} GitHub Actions configured for automated testing\n"
    fi
    
    # Ask to open in VS Code
    read -p "Open in VS Code now? (y/n): " open_vscode
    if [[ "$open_vscode" == "y" || "$open_vscode" == "Y" ]]; then
        code "$PROJECTS_DIR/$project_name"
    fi
}

# Run main function
main "$@"
