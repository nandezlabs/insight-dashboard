#!/bin/bash

################################################################################
# Project Lifecycle Workflow Manager
# Manage complete project lifecycle from creation to production
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🔄  Project Lifecycle Manager${NC}"
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

print_section() {
    echo ""
    echo -e "${MAGENTA}################################################################################${NC}"
    echo -e "${MAGENTA}# $1${NC}"
    echo -e "${MAGENTA}################################################################################${NC}"
    echo ""
}

print_step() {
    echo -e "\n${CYAN}▶${NC} $1\n"
}

################################################################################
# Project State Management
################################################################################

get_project_state() {
    local project_dir="$1"

    # First check for explicit phase markers
    if [[ -f "$project_dir/.copilot-planning" ]]; then
        echo "planning"
        return
    elif [[ -f "$project_dir/.copilot-development" ]]; then
        echo "development"
        return
    elif [[ -f "$project_dir/.copilot-production" ]]; then
        echo "production"
        return
    elif [[ -f "$project_dir/.copilot-maintenance" ]]; then
        echo "maintenance"
        return
    fi

    # Fallback to legacy detection if no markers
    # Check various indicators of project state
    local has_git=false
    local has_deps=false
    local has_tests=false
    local has_ci=false
    local has_hooks=false
    local is_deployed=false

    [[ -d "$project_dir/.git" ]] && has_git=true
    [[ -d "$project_dir/node_modules" ]] || [[ -d "$project_dir/.venv" ]] || [[ -d "$project_dir/target" ]] && has_deps=true
    [[ -f "$project_dir/package.json" ]] && grep -q '"test"' "$project_dir/package.json" && has_tests=true
    [[ -d "$project_dir/.github/workflows" ]] && has_ci=true
    [[ -f "$project_dir/.pre-commit-config.yaml" ]] && has_hooks=true
    [[ -f "$project_dir/.deployed" ]] && is_deployed=true

    # Determine lifecycle stage
    if [[ "$is_deployed" == true ]]; then
        echo "production"
    elif [[ "$has_ci" == true ]] && [[ "$has_tests" == true ]]; then
        echo "ready"
    elif [[ "$has_git" == true ]] && [[ "$has_deps" == true ]]; then
        echo "development"
    elif [[ "$has_git" == true ]]; then
        echo "initialized"
    else
        echo "new"
    fi
}

show_project_status() {
    local project_dir="$1"
    local state=$(get_project_state "$project_dir")

    print_section "Project Status"

    echo -e "${CYAN}Project:${NC} $(basename "$project_dir")"
    echo -e "${CYAN}Path:${NC} $project_dir"
    echo -e "${CYAN}State:${NC} $state"
    echo ""

    # Check for PLANNING-MASTER.md
    if [[ -f "$project_dir/PLANNING-MASTER.md" ]]; then
        print_success "PLANNING-MASTER.md present"

        # Try to extract phase info
        if grep -q "**Current Phase:**" "$project_dir/PLANNING-MASTER.md" 2>/dev/null; then
            local doc_phase=$(grep "**Current Phase:**" "$project_dir/PLANNING-MASTER.md" | sed 's/.*\*\*Current Phase:\*\* *//')
            echo "    Planning Doc Phase: $doc_phase"
        fi
    fi

    # Show phase markers
    echo ""
    echo -e "${CYAN}Phase Markers:${NC}"
    local found_marker=false
    for marker in .copilot-planning .copilot-development .copilot-production .copilot-maintenance; do
        if [[ -f "$project_dir/$marker" ]]; then
            print_success "$(basename $marker)"
            found_marker=true

            # Show phase start time if available
            if grep -q "Phase Started:" "$project_dir/$marker"; then
                local started=$(grep "Phase Started:" "$project_dir/$marker" | cut -d: -f2- | xargs)
                echo "    Started: $started"
            fi
        fi
    done
    [[ "$found_marker" == false ]] && print_warning "No phase markers found"

    # Detailed checks
    echo ""
    echo -e "${CYAN}Setup Status:${NC}"

    if [[ -d "$project_dir/.git" ]]; then
        print_success "Git repository"
        local branch=$(cd "$project_dir" && git branch --show-current 2>/dev/null)
        echo "    Branch: $branch"
        local commits=$(cd "$project_dir" && git rev-list --count HEAD 2>/dev/null || echo "0")
        echo "    Commits: $commits"
    else
        print_error "No Git repository"
    fi

    if [[ -d "$project_dir/node_modules" ]]; then
        print_success "Node dependencies installed"
    elif [[ -d "$project_dir/.venv" ]]; then
        print_success "Python virtual environment"
    elif [[ -d "$project_dir/target" ]]; then
        print_success "Rust dependencies"
    else
        print_warning "Dependencies not installed"
    fi

    if [[ -d "$project_dir/.github/workflows" ]]; then
        print_success "CI/CD configured"
        local workflow_count=$(ls -1 "$project_dir/.github/workflows"/*.yml 2>/dev/null | wc -l | tr -d ' ')
        echo "    Workflows: $workflow_count"
    else
        print_warning "No CI/CD pipelines"
    fi

    if [[ -f "$project_dir/.pre-commit-config.yaml" ]]; then
        print_success "Pre-commit hooks configured"
    else
        print_warning "No pre-commit hooks"
    fi

    if [[ -f "$project_dir/.deployed" ]]; then
        print_success "Deployed to production"
        local deploy_info=$(cat "$project_dir/.deployed")
        echo "    $deploy_info"
    else
        print_info "Not yet deployed"
    fi
}

################################################################################
# Lifecycle Stage: Initialize
################################################################################

lifecycle_initialize() {
    local project_dir="$1"

    print_section "Lifecycle: Initialize"

    cd "$project_dir"

    # Check if already initialized
    if [[ -d ".git" ]]; then
        print_info "Project already initialized"
        return 0
    fi

    # Initialize Git
    print_step "Initializing Git repository"
    git init

    # Create .gitignore
    print_step "Creating .gitignore"
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.venv/
venv/
__pycache__/
*.pyc
target/
.cargo/
vendor/

# Build outputs
dist/
build/
.next/
out/
*.exe
*.dll
*.so
*.dylib

# IDE
.vscode/
.idea/
*.swp
*.swo
.DS_Store

# Environment
.env
.env.local
.env.*.local

# Logs
*.log
logs/
npm-debug.log*

# Testing
coverage/
.coverage
htmlcov/

# Temporary
tmp/
temp/
*.tmp
EOF

    # Initial commit
    print_step "Creating initial commit"
    git add .
    git commit -m "Initial commit - Project setup"

    print_success "Project initialized"
}

################################################################################
# Lifecycle Stage: Setup Development
################################################################################

lifecycle_setup_dev() {
    local project_dir="$1"

    print_section "Lifecycle: Setup Development"

    cd "$project_dir"

    # Install dependencies
    print_step "Installing dependencies"

    if [[ -f "package.json" ]]; then
        if [[ -f "package-lock.json" ]]; then
            npm ci
        else
            npm install
        fi
    elif [[ -f "pyproject.toml" ]]; then
        if command -v poetry >/dev/null 2>&1; then
            poetry install
        else
            pip install -e .
        fi
    elif [[ -f "Cargo.toml" ]]; then
        cargo fetch
    elif [[ -f "go.mod" ]]; then
        go mod download
    fi

    print_success "Dependencies installed"

    # Setup pre-commit hooks
    print_step "Setting up pre-commit hooks"

    if [[ ! -f ".pre-commit-config.yaml" ]]; then
        "$HOME/Developer/tools/ci-cd/precommit-manager.sh" init "$project_dir" 2>/dev/null || true
    fi

    # Setup environment files
    print_step "Creating environment template"

    if [[ -f "package.json" ]] && [[ ! -f ".env.example" ]]; then
        cat > .env.example << 'EOF'
# Environment Configuration
# Copy this file to .env and fill in your values

NODE_ENV=development
PORT=3000
EOF
    elif [[ -f "pyproject.toml" ]] && [[ ! -f ".env.example" ]]; then
        cat > .env.example << 'EOF'
# Environment Configuration
# Copy this file to .env and fill in your values

ENV=development
DEBUG=True
EOF
    fi

    print_success "Development environment configured"
}

################################################################################
# Lifecycle Stage: Setup CI/CD
################################################################################

lifecycle_setup_cicd() {
    local project_dir="$1"

    print_section "Lifecycle: Setup CI/CD"

    cd "$project_dir"

    # Generate CI/CD workflows
    print_step "Generating CI/CD pipelines"
    "$HOME/Developer/tools/ci-cd/github-actions-generator.sh" all "$project_dir" 2>/dev/null || true

    # Commit CI/CD configuration
    if [[ -d ".github/workflows" ]]; then
        git add .github/
        git commit -m "Configure CI/CD pipelines" 2>/dev/null || true
        print_success "CI/CD configured"
    else
        print_warning "CI/CD setup failed"
    fi
}

################################################################################
# Lifecycle Stage: Quality Gate
################################################################################

lifecycle_quality_gate() {
    local project_dir="$1"
    local fix="${2:-false}"

    print_section "Lifecycle: Quality Gate"

    cd "$project_dir"

    local issues=0

    # Code quality
    print_step "Checking code quality"

    if [[ "$fix" == "true" ]]; then
        "$HOME/Developer/tools/ci-cd/code-quality-checker.sh" fix "$project_dir" || ((issues++))
    else
        "$HOME/Developer/tools/ci-cd/code-quality-checker.sh" check "$project_dir" || ((issues++))
    fi

    # Tests
    print_step "Running tests"
    "$HOME/Developer/tools/ci-cd/test-runner.sh" run "$project_dir" || ((issues++))

    # Security
    print_step "Security scan"

    if [[ -f "package.json" ]]; then
        npm audit --audit-level=moderate || ((issues++))
    elif [[ -f "Cargo.toml" ]] && command -v cargo-audit >/dev/null 2>&1; then
        cargo audit || ((issues++))
    fi

    if [[ $issues -eq 0 ]]; then
        print_success "Quality gate passed"
        return 0
    else
        print_error "Quality gate failed with $issues issue(s)"
        return 1
    fi
}

################################################################################
# Lifecycle Stage: Build
################################################################################

lifecycle_build() {
    local project_dir="$1"
    local mode="${2:-development}"

    print_section "Lifecycle: Build ($mode)"

    cd "$project_dir"

    print_step "Building project"

    if [[ -f "package.json" ]] && grep -q '"build"' package.json; then
        if [[ "$mode" == "production" ]]; then
            NODE_ENV=production npm run build
        else
            npm run build
        fi
    elif [[ -f "Cargo.toml" ]]; then
        if [[ "$mode" == "production" ]]; then
            cargo build --release
        else
            cargo build
        fi
    elif [[ -f "go.mod" ]]; then
        if [[ "$mode" == "production" ]]; then
            CGO_ENABLED=0 go build -ldflags="-s -w"
        else
            go build
        fi
    elif [[ -f "pyproject.toml" ]]; then
        poetry build 2>/dev/null || python -m build 2>/dev/null || true
    fi

    print_success "Build completed"
}

################################################################################
# Lifecycle Stage: Deploy
################################################################################

lifecycle_deploy() {
    local project_dir="$1"
    local target="${2:-auto}"

    print_section "Lifecycle: Deploy"

    cd "$project_dir"

    # Auto-detect deployment target if needed
    if [[ "$target" == "auto" ]]; then
        if [[ -f "vercel.json" ]] || grep -q "vercel" package.json 2>/dev/null; then
            target="vercel"
        elif [[ -f "netlify.toml" ]]; then
            target="netlify"
        elif [[ -f "Dockerfile" ]]; then
            target="docker"
        elif [[ -f "Package.swift" ]] || [[ -d "*.xcodeproj" ]]; then
            target="appstore"
        else
            target="hostinger"
        fi

        print_info "Auto-detected deployment target: $target"
    fi

    print_step "Deploying to $target"

    case $target in
        vercel)
            "$HOME/Developer/tools/deployment/deploy-to-vercel.sh" --deploy "$project_dir"
            ;;
        netlify)
            "$HOME/Developer/tools/deployment/deploy-to-netlify.sh" --deploy "$project_dir"
            ;;
        docker)
            "$HOME/Developer/tools/deployment/deploy-to-docker.sh" --push "$project_dir"
            ;;
        appstore)
            "$HOME/Developer/tools/deployment/deploy-to-appstore.sh" --testflight "$project_dir"
            ;;
        hostinger)
            "$HOME/Developer/tools/deployment/deploy-to-hostinger.sh" --deploy "$project_dir"
            ;;
        *)
            print_error "Unknown deployment target: $target"
            return 1
            ;;
    esac

    # Mark as deployed
    echo "Deployed to $target on $(date)" > .deployed
    git add .deployed
    git commit -m "Deploy to $target" 2>/dev/null || true

    print_success "Deployment completed"
}

################################################################################
# Full Lifecycle Workflows
################################################################################

workflow_zero_to_production() {
    local project_dir="$1"

    print_header
    print_info "Starting: Zero to Production workflow"
    print_info "Project: $(basename "$project_dir")"
    echo ""

    # Stage 1: Initialize
    lifecycle_initialize "$project_dir"

    # Stage 2: Setup Development
    lifecycle_setup_dev "$project_dir"

    # Stage 3: Setup CI/CD
    lifecycle_setup_cicd "$project_dir"

    # Stage 4: Quality Gate
    if ! lifecycle_quality_gate "$project_dir" "true"; then
        print_warning "Quality gate failed, but continuing..."
    fi

    # Stage 5: Build
    lifecycle_build "$project_dir" "production"

    # Stage 6: Deploy
    read -p "Deploy to production? (y/n): " deploy_choice
    if [[ "$deploy_choice" == "y" ]]; then
        lifecycle_deploy "$project_dir" "auto"
    else
        print_info "Skipped deployment"
    fi

    print_section "Zero to Production Complete! 🚀"
    show_project_status "$project_dir"
}

workflow_maintenance_cycle() {
    local project_dir="$1"

    print_header
    print_info "Starting: Maintenance Cycle"
    print_info "Project: $(basename "$project_dir")"
    echo ""

    cd "$project_dir"

    # Update dependencies
    print_step "Updating dependencies"
    "$HOME/Developer/tools/setup/dependency-updater.sh" update "$project_dir"

    # Quality checks
    print_step "Running quality checks"
    lifecycle_quality_gate "$project_dir" "true"

    # Rebuild
    print_step "Rebuilding project"
    lifecycle_build "$project_dir" "production"

    # Commit updates
    if [[ -n $(git status --porcelain) ]]; then
        git add .
        git commit -m "chore: Maintenance cycle - dependency updates and quality fixes"
        print_success "Changes committed"
    fi

    print_section "Maintenance Cycle Complete! ✨"
}

workflow_pre_release() {
    local project_dir="$1"
    local version="$2"

    print_header
    print_info "Starting: Pre-release workflow"
    print_info "Project: $(basename "$project_dir")"
    print_info "Version: $version"
    echo ""

    cd "$project_dir"

    # Quality gate
    print_step "Running quality gate"
    if ! lifecycle_quality_gate "$project_dir" "false"; then
        print_error "Quality gate failed - fix issues before release"
        return 1
    fi

    # Build for production
    print_step "Building for production"
    lifecycle_build "$project_dir" "production"

    # Run tests with coverage
    print_step "Running tests with coverage"
    "$HOME/Developer/tools/ci-cd/test-runner.sh" coverage "$project_dir"

    print_section "Pre-release Checks Complete! ✅"
    print_info "Ready to create release $version"
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    local project_dir="${1:-.}"

    project_dir=$(cd "$project_dir" && pwd)

    print_header

    show_project_status "$project_dir"

    echo ""
    echo -e "${CYAN}Lifecycle Workflows:${NC}"
    echo "  1) Zero to Production (full setup)"
    echo "  2) Initialize project"
    echo "  3) Setup development"
    echo "  4) Setup CI/CD"
    echo "  5) Run quality gate"
    echo "  6) Build project"
    echo "  7) Deploy project"
    echo "  8) Maintenance cycle"
    echo "  9) Pre-release checks"
    echo "  q) Quit"
    echo ""

    read -p "Selection: " choice

    case $choice in
        1)
            workflow_zero_to_production "$project_dir"
            ;;
        2)
            lifecycle_initialize "$project_dir"
            ;;
        3)
            lifecycle_setup_dev "$project_dir"
            ;;
        4)
            lifecycle_setup_cicd "$project_dir"
            ;;
        5)
            read -p "Auto-fix issues? (y/n): " fix_choice
            if [[ "$fix_choice" == "y" ]]; then
                lifecycle_quality_gate "$project_dir" "true"
            else
                lifecycle_quality_gate "$project_dir" "false"
            fi
            ;;
        6)
            read -p "Build mode (development/production): " mode
            lifecycle_build "$project_dir" "${mode:-development}"
            ;;
        7)
            read -p "Deployment target (vercel/netlify/docker/appstore/hostinger/auto): " target
            lifecycle_deploy "$project_dir" "${target:-auto}"
            ;;
        8)
            workflow_maintenance_cycle "$project_dir"
            ;;
        9)
            read -p "Version for release: " version
            workflow_pre_release "$project_dir" "$version"
            ;;
        q|Q)
            print_info "Goodbye! 👋"
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
    echo "Usage: $0 [COMMAND] [PROJECT_DIR] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  status [DIR]              Show project status"
    echo "  init [DIR]                Initialize project"
    echo "  setup-dev [DIR]           Setup development environment"
    echo "  setup-ci [DIR]            Setup CI/CD"
    echo "  quality [DIR]             Run quality gate"
    echo "  build [DIR] [MODE]        Build project"
    echo "  deploy [DIR] [TARGET]     Deploy project"
    echo "  zero-to-prod [DIR]        Full setup to production"
    echo "  maintenance [DIR]         Maintenance cycle"
    echo "  pre-release [DIR] [VER]   Pre-release checks"
    echo "  interactive [DIR]         Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 zero-to-prod ~/Developer/projects/my-app"
    echo "  $0 deploy . vercel"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"

    if [[ ! "$command" =~ ^(status|init|setup-dev|setup-ci|quality|build|deploy|zero-to-prod|maintenance|pre-release|interactive|-h|--help)$ ]]; then
        project_dir="$command"
        command="interactive"
    fi

    project_dir=$(cd "$project_dir" && pwd)

    case $command in
        status)
            print_header
            show_project_status "$project_dir"
            ;;
        init)
            print_header
            lifecycle_initialize "$project_dir"
            ;;
        setup-dev)
            print_header
            lifecycle_setup_dev "$project_dir"
            ;;
        setup-ci)
            print_header
            lifecycle_setup_cicd "$project_dir"
            ;;
        quality)
            print_header
            lifecycle_quality_gate "$project_dir" "false"
            ;;
        build)
            local mode="${3:-development}"
            print_header
            lifecycle_build "$project_dir" "$mode"
            ;;
        deploy)
            local target="${3:-auto}"
            print_header
            lifecycle_deploy "$project_dir" "$target"
            ;;
        zero-to-prod)
            workflow_zero_to_production "$project_dir"
            ;;
        maintenance)
            workflow_maintenance_cycle "$project_dir"
            ;;
        pre-release)
            local version="$3"
            print_header
            workflow_pre_release "$project_dir" "$version"
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
