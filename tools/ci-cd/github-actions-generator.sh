#!/bin/bash

################################################################################
# GitHub Actions Workflow Generator
# Create CI/CD pipelines for different project types
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  ⚙️  GitHub Actions Generator${NC}"
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

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

################################################################################
# Project Detection
################################################################################

detect_project_type() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/next.config.js" ]] || [[ -f "$project_dir/next.config.mjs" ]] || [[ -f "$project_dir/next.config.ts" ]]; then
        echo "nextjs"
    elif [[ -f "$project_dir/vite.config.ts" ]] || [[ -f "$project_dir/vite.config.js" ]]; then
        echo "vite"
    elif [[ -f "$project_dir/Package.swift" ]]; then
        echo "swift"
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "go"
    elif [[ -f "$project_dir/package.json" ]]; then
        echo "nodejs"
    else
        echo "unknown"
    fi
}

################################################################################
# Next.js Workflow
################################################################################

create_nextjs_workflow() {
    local project_dir="$1"
    local workflow_dir="$project_dir/.github/workflows"
    
    mkdir -p "$workflow_dir"
    
    cat > "$workflow_dir/ci.yml" << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
  
  test:
    name: Test
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
  
  build:
    name: Build
    runs-on: ubuntu-latest
    needs: [lint, test]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build application
        run: npm run build
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: .next
  
  deploy:
    name: Deploy to Vercel
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
EOF
    
    print_success "Created Next.js CI/CD workflow"
}

################################################################################
# Python Workflow
################################################################################

create_python_workflow() {
    local project_dir="$1"
    local workflow_dir="$project_dir/.github/workflows"
    
    mkdir -p "$workflow_dir"
    
    cat > "$workflow_dir/ci.yml" << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: Lint & Format Check
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install Poetry
        run: |
          curl -sSL https://install.python-poetry.org | python3 -
          echo "$HOME/.local/bin" >> $GITHUB_PATH
      
      - name: Install dependencies
        run: poetry install
      
      - name: Run Black
        run: poetry run black --check .
      
      - name: Run Flake8
        run: poetry run flake8 .
      
      - name: Run isort
        run: poetry run isort --check-only .
  
  type-check:
    name: Type Check
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install Poetry
        run: |
          curl -sSL https://install.python-poetry.org | python3 -
          echo "$HOME/.local/bin" >> $GITHUB_PATH
      
      - name: Install dependencies
        run: poetry install
      
      - name: Run MyPy
        run: poetry run mypy .
  
  test:
    name: Test
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.9', '3.10', '3.11']
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      
      - name: Install Poetry
        run: |
          curl -sSL https://install.python-poetry.org | python3 -
          echo "$HOME/.local/bin" >> $GITHUB_PATH
      
      - name: Install dependencies
        run: poetry install
      
      - name: Run tests with coverage
        run: poetry run pytest --cov=. --cov-report=xml
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
          flags: unittests
  
  security:
    name: Security Scan
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install Poetry
        run: |
          curl -sSL https://install.python-poetry.org | python3 -
          echo "$HOME/.local/bin" >> $GITHUB_PATH
      
      - name: Install dependencies
        run: poetry install
      
      - name: Run Safety check
        run: poetry run safety check
      
      - name: Run Bandit
        run: poetry run bandit -r .
EOF
    
    print_success "Created Python CI/CD workflow"
}

################################################################################
# Node.js API Workflow
################################################################################

create_nodejs_workflow() {
    local project_dir="$1"
    local workflow_dir="$project_dir/.github/workflows"
    
    mkdir -p "$workflow_dir"
    
    cat > "$workflow_dir/ci.yml" << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run ESLint
        run: npm run lint
      
      - name: Check formatting
        run: npm run format:check
  
  test:
    name: Test
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
  
  build:
    name: Build
    runs-on: ubuntu-latest
    needs: [lint, test]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
  
  docker:
    name: Build & Push Docker Image
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:latest
          cache-from: type=registry,ref=${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:buildcache
          cache-to: type=registry,ref=${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:buildcache,mode=max
EOF
    
    print_success "Created Node.js CI/CD workflow"
}

################################################################################
# Swift/iOS Workflow
################################################################################

create_swift_workflow() {
    local project_dir="$1"
    local workflow_dir="$project_dir/.github/workflows"
    
    mkdir -p "$workflow_dir"
    
    cat > "$workflow_dir/ci.yml" << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    name: SwiftLint
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Install SwiftLint
        run: brew install swiftlint
      
      - name: Run SwiftLint
        run: swiftlint lint --strict
  
  test:
    name: Test
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Select Xcode version
        run: sudo xcode-select -s /Applications/Xcode_15.0.app
      
      - name: Build and test
        run: |
          xcodebuild test \
            -scheme MyApp \
            -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
            -enableCodeCoverage YES \
            clean test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./DerivedData/Logs/Test/*.xcresult
  
  build:
    name: Build
    runs-on: macos-latest
    needs: [lint, test]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Select Xcode version
        run: sudo xcode-select -s /Applications/Xcode_15.0.app
      
      - name: Build archive
        run: |
          xcodebuild archive \
            -scheme MyApp \
            -configuration Release \
            -archivePath $PWD/build/MyApp.xcarchive \
            -destination 'generic/platform=iOS'
      
      - name: Export IPA
        run: |
          xcodebuild -exportArchive \
            -archivePath $PWD/build/MyApp.xcarchive \
            -exportPath $PWD/build \
            -exportOptionsPlist ExportOptions.plist
      
      - name: Upload IPA
        uses: actions/upload-artifact@v3
        with:
          name: MyApp.ipa
          path: build/MyApp.ipa
EOF
    
    print_success "Created Swift/iOS CI/CD workflow"
}

################################################################################
# Docker Workflow
################################################################################

create_docker_workflow() {
    local project_dir="$1"
    local workflow_dir="$project_dir/.github/workflows"
    
    mkdir -p "$workflow_dir"
    
    cat > "$workflow_dir/docker.yml" << 'EOF'
name: Docker Build & Push

on:
  push:
    branches: [main]
    tags:
      - 'v*'
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Log in to registry
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ steps.meta.outputs.version }}
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
EOF
    
    print_success "Created Docker workflow"
}

################################################################################
# Dependabot Configuration
################################################################################

create_dependabot_config() {
    local project_dir="$1"
    local project_type="$2"
    local config_dir="$project_dir/.github"
    
    mkdir -p "$config_dir"
    
    cat > "$config_dir/dependabot.yml" << EOF
version: 2
updates:
EOF
    
    case $project_type in
        nextjs|vite|nodejs)
            cat >> "$config_dir/dependabot.yml" << EOF
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
EOF
            ;;
        python)
            cat >> "$config_dir/dependabot.yml" << EOF
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
EOF
            ;;
        swift)
            cat >> "$config_dir/dependabot.yml" << EOF
  - package-ecosystem: "swift"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
EOF
            ;;
    esac
    
    # Always add GitHub Actions updates
    cat >> "$config_dir/dependabot.yml" << EOF
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
EOF
    
    print_success "Created Dependabot configuration"
}

################################################################################
# Code Quality Workflow
################################################################################

create_codeql_workflow() {
    local project_dir="$1"
    local workflow_dir="$project_dir/.github/workflows"
    
    mkdir -p "$workflow_dir"
    
    cat > "$workflow_dir/codeql.yml" << 'EOF'
name: CodeQL Analysis

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write
    
    strategy:
      fail-fast: false
      matrix:
        language: ['javascript', 'typescript']
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Initialize CodeQL
        uses: github/codeql-action/init@v2
        with:
          languages: ${{ matrix.language }}
      
      - name: Autobuild
        uses: github/codeql-action/autobuild@v2
      
      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v2
EOF
    
    print_success "Created CodeQL security workflow"
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    local project_dir="${1:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local project_type=$(detect_project_type "$project_dir")
    local project_name=$(basename "$project_dir")
    
    print_info "Project: $project_name"
    print_info "Type: $project_type"
    echo ""
    
    echo -e "${CYAN}Workflow Options:${NC}"
    echo "  1) Create CI/CD workflow for project type"
    echo "  2) Create Docker workflow"
    echo "  3) Create CodeQL security workflow"
    echo "  4) Create Dependabot configuration"
    echo "  5) Create all workflows"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            case $project_type in
                nextjs)
                    create_nextjs_workflow "$project_dir"
                    ;;
                python)
                    create_python_workflow "$project_dir"
                    ;;
                nodejs)
                    create_nodejs_workflow "$project_dir"
                    ;;
                swift)
                    create_swift_workflow "$project_dir"
                    ;;
                vite)
                    create_nextjs_workflow "$project_dir"
                    ;;
                *)
                    print_error "No workflow template for: $project_type"
                    ;;
            esac
            ;;
        2)
            create_docker_workflow "$project_dir"
            ;;
        3)
            create_codeql_workflow "$project_dir"
            ;;
        4)
            create_dependabot_config "$project_dir" "$project_type"
            ;;
        5)
            case $project_type in
                nextjs|python|nodejs|swift|vite)
                    case $project_type in
                        nextjs|vite) create_nextjs_workflow "$project_dir" ;;
                        python) create_python_workflow "$project_dir" ;;
                        nodejs) create_nodejs_workflow "$project_dir" ;;
                        swift) create_swift_workflow "$project_dir" ;;
                    esac
                    create_docker_workflow "$project_dir"
                    create_codeql_workflow "$project_dir"
                    create_dependabot_config "$project_dir" "$project_type"
                    echo ""
                    print_success "All workflows created!"
                    ;;
                *)
                    print_error "Unsupported project type: $project_type"
                    ;;
            esac
            ;;
        q|Q)
            print_info "Cancelled"
            exit 0
            ;;
        *)
            print_error "Invalid selection"
            exit 1
            ;;
    esac
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [COMMAND] [PROJECT_DIR]"
    echo ""
    echo "Commands:"
    echo "  create [DIR]         Create workflow for project"
    echo "  docker [DIR]         Create Docker workflow"
    echo "  security [DIR]       Create CodeQL workflow"
    echo "  dependabot [DIR]     Create Dependabot config"
    echo "  all [DIR]            Create all workflows"
    echo "  interactive [DIR]    Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 create"
    echo "  $0 all ~/Developer/projects/my-app"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"
    
    print_header
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local project_type=$(detect_project_type "$project_dir")
    
    case $command in
        create)
            case $project_type in
                nextjs|vite) create_nextjs_workflow "$project_dir" ;;
                python) create_python_workflow "$project_dir" ;;
                nodejs) create_nodejs_workflow "$project_dir" ;;
                swift) create_swift_workflow "$project_dir" ;;
                *) print_error "Unsupported project type: $project_type" ;;
            esac
            ;;
        docker)
            create_docker_workflow "$project_dir"
            ;;
        security)
            create_codeql_workflow "$project_dir"
            ;;
        dependabot)
            create_dependabot_config "$project_dir" "$project_type"
            ;;
        all)
            case $project_type in
                nextjs|vite) create_nextjs_workflow "$project_dir" ;;
                python) create_python_workflow "$project_dir" ;;
                nodejs) create_nodejs_workflow "$project_dir" ;;
                swift) create_swift_workflow "$project_dir" ;;
            esac
            create_docker_workflow "$project_dir"
            create_codeql_workflow "$project_dir"
            create_dependabot_config "$project_dir" "$project_type"
            ;;
        interactive)
            interactive_mode "$project_dir"
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
