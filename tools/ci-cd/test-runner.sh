#!/bin/bash

################################################################################
# Test Runner
# Orchestrate tests across different project types
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
    echo -e "${BLUE}  🧪  Test Runner${NC}"
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

################################################################################
# Project Detection
################################################################################

detect_project_type() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/next.config.js" ]] || [[ -f "$project_dir/next.config.mjs" ]] || [[ -f "$project_dir/next.config.ts" ]]; then
        echo "nextjs"
    elif [[ -f "$project_dir/vite.config.ts" ]] || [[ -f "$project_dir/vite.config.js" ]]; then
        echo "vite"
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "go"
    elif [[ -f "$project_dir/Package.swift" ]]; then
        echo "swift"
    elif [[ -f "$project_dir/package.json" ]]; then
        echo "nodejs"
    else
        echo "unknown"
    fi
}

################################################################################
# Node.js/TypeScript Tests
################################################################################

run_nodejs_tests() {
    local project_dir="$1"
    local coverage="${2:-false}"
    local watch="${3:-false}"
    
    cd "$project_dir"
    
    if [[ ! -f "package.json" ]]; then
        print_error "No package.json found"
        return 1
    fi
    
    print_section "Node.js Tests"
    
    # Check for test script
    if ! grep -q '"test"' package.json; then
        print_warning "No test script found in package.json"
        return 1
    fi
    
    # Install dependencies if needed
    if [[ ! -d "node_modules" ]]; then
        print_info "Installing dependencies..."
        npm install
    fi
    
    # Run tests
    if [[ "$watch" == "true" ]]; then
        print_info "Running tests in watch mode..."
        npm run test -- --watch
    elif [[ "$coverage" == "true" ]]; then
        print_info "Running tests with coverage..."
        npm run test -- --coverage
        
        # Show coverage report location
        if [[ -d "coverage" ]]; then
            echo ""
            print_success "Coverage report generated: coverage/lcov-report/index.html"
        fi
    else
        print_info "Running tests..."
        npm test
    fi
}

################################################################################
# Python Tests
################################################################################

run_python_tests() {
    local project_dir="$1"
    local coverage="${2:-false}"
    local watch="${3:-false}"
    
    cd "$project_dir"
    
    print_section "Python Tests"
    
    # Check for pytest
    if [[ -f "pyproject.toml" ]] && grep -q "pytest" pyproject.toml; then
        if [[ "$watch" == "true" ]]; then
            print_info "Running tests in watch mode..."
            poetry run ptw -- -v
        elif [[ "$coverage" == "true" ]]; then
            print_info "Running tests with coverage..."
            poetry run pytest --cov=. --cov-report=html --cov-report=term
            
            if [[ -d "htmlcov" ]]; then
                echo ""
                print_success "Coverage report generated: htmlcov/index.html"
            fi
        else
            print_info "Running tests..."
            poetry run pytest -v
        fi
    else
        print_warning "No pytest configuration found"
        return 1
    fi
}

################################################################################
# Rust Tests
################################################################################

run_rust_tests() {
    local project_dir="$1"
    local coverage="${2:-false}"
    
    cd "$project_dir"
    
    print_section "Rust Tests"
    
    if [[ ! -f "Cargo.toml" ]]; then
        print_error "No Cargo.toml found"
        return 1
    fi
    
    if [[ "$coverage" == "true" ]]; then
        print_info "Running tests with coverage..."
        
        # Check for tarpaulin
        if ! command -v cargo-tarpaulin >/dev/null 2>&1; then
            print_warning "Installing cargo-tarpaulin..."
            cargo install cargo-tarpaulin
        fi
        
        cargo tarpaulin --out Html --output-dir coverage
        
        if [[ -f "coverage/index.html" ]]; then
            echo ""
            print_success "Coverage report generated: coverage/index.html"
        fi
    else
        print_info "Running tests..."
        cargo test -- --nocapture
    fi
}

################################################################################
# Go Tests
################################################################################

run_go_tests() {
    local project_dir="$1"
    local coverage="${2:-false}"
    
    cd "$project_dir"
    
    print_section "Go Tests"
    
    if [[ ! -f "go.mod" ]]; then
        print_error "No go.mod found"
        return 1
    fi
    
    if [[ "$coverage" == "true" ]]; then
        print_info "Running tests with coverage..."
        go test -v -coverprofile=coverage.out ./...
        go tool cover -html=coverage.out -o coverage.html
        
        if [[ -f "coverage.html" ]]; then
            echo ""
            print_success "Coverage report generated: coverage.html"
        fi
        
        # Show coverage percentage
        go tool cover -func=coverage.out | tail -n 1
    else
        print_info "Running tests..."
        go test -v ./...
    fi
}

################################################################################
# Swift Tests
################################################################################

run_swift_tests() {
    local project_dir="$1"
    local coverage="${2:-false}"
    
    cd "$project_dir"
    
    print_section "Swift Tests"
    
    # Find .xcworkspace or .xcodeproj
    local workspace=$(find . -maxdepth 1 -name "*.xcworkspace" | head -n 1)
    local project=$(find . -maxdepth 1 -name "*.xcodeproj" | head -n 1)
    
    if [[ -n "$workspace" ]]; then
        local scheme=$(basename "$workspace" .xcworkspace)
        
        if [[ "$coverage" == "true" ]]; then
            print_info "Running tests with coverage..."
            xcodebuild test \
                -workspace "$workspace" \
                -scheme "$scheme" \
                -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
                -enableCodeCoverage YES \
                clean test
        else
            print_info "Running tests..."
            xcodebuild test \
                -workspace "$workspace" \
                -scheme "$scheme" \
                -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
                clean test
        fi
    elif [[ -n "$project" ]]; then
        local scheme=$(basename "$project" .xcodeproj)
        
        if [[ "$coverage" == "true" ]]; then
            print_info "Running tests with coverage..."
            xcodebuild test \
                -project "$project" \
                -scheme "$scheme" \
                -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
                -enableCodeCoverage YES \
                clean test
        else
            print_info "Running tests..."
            xcodebuild test \
                -project "$project" \
                -scheme "$scheme" \
                -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.0' \
                clean test
        fi
    elif [[ -f "Package.swift" ]]; then
        print_info "Running Swift package tests..."
        swift test
    else
        print_error "No Xcode project or Swift package found"
        return 1
    fi
}

################################################################################
# Run All Tests in Workspace
################################################################################

run_all_workspace_tests() {
    local workspace_dir="${1:-$HOME/Developer}"
    local coverage="${2:-false}"
    
    print_info "Scanning for projects in: $workspace_dir"
    echo ""
    
    local test_count=0
    local pass_count=0
    local fail_count=0
    
    # Find all git repositories
    while IFS= read -r project_dir; do
        local project_name=$(basename "$project_dir")
        local project_type=$(detect_project_type "$project_dir")
        
        if [[ "$project_type" != "unknown" ]]; then
            echo ""
            print_info "Testing: $project_name ($project_type)"
            
            ((test_count++))
            
            if run_project_tests "$project_dir" "$coverage" "false"; then
                ((pass_count++))
                print_success "Tests passed"
            else
                ((fail_count++))
                print_error "Tests failed"
            fi
        fi
    done < <(find "$workspace_dir" -name ".git" -type d -maxdepth 3 | sed 's/\/.git$//')
    
    # Summary
    print_section "Test Summary"
    echo "Total projects tested: $test_count"
    echo -e "${GREEN}Passed: $pass_count${NC}"
    echo -e "${RED}Failed: $fail_count${NC}"
}

################################################################################
# Run Tests for Project
################################################################################

run_project_tests() {
    local project_dir="$1"
    local coverage="${2:-false}"
    local watch="${3:-false}"
    
    local project_type=$(detect_project_type "$project_dir")
    
    case $project_type in
        nextjs|vite|nodejs)
            run_nodejs_tests "$project_dir" "$coverage" "$watch"
            ;;
        python)
            run_python_tests "$project_dir" "$coverage" "$watch"
            ;;
        rust)
            run_rust_tests "$project_dir" "$coverage"
            ;;
        go)
            run_go_tests "$project_dir" "$coverage"
            ;;
        swift)
            run_swift_tests "$project_dir" "$coverage"
            ;;
        *)
            print_error "Unsupported project type: $project_type"
            return 1
            ;;
    esac
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
    
    echo -e "${CYAN}Test Options:${NC}"
    echo "  1) Run tests"
    echo "  2) Run tests with coverage"
    echo "  3) Run tests in watch mode (Node.js/Python only)"
    echo "  4) Test all workspace projects"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            run_project_tests "$project_dir" "false" "false"
            ;;
        2)
            run_project_tests "$project_dir" "true" "false"
            ;;
        3)
            if [[ "$project_type" == "nodejs" ]] || [[ "$project_type" == "nextjs" ]] || [[ "$project_type" == "vite" ]] || [[ "$project_type" == "python" ]]; then
                run_project_tests "$project_dir" "false" "true"
            else
                print_warning "Watch mode only available for Node.js and Python projects"
            fi
            ;;
        4)
            run_all_workspace_tests "$HOME/Developer" "false"
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
    echo "  run [DIR]            Run tests for project"
    echo "  coverage [DIR]       Run tests with coverage"
    echo "  watch [DIR]          Run tests in watch mode"
    echo "  all [WORKSPACE]      Test all projects in workspace"
    echo "  interactive [DIR]    Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 run"
    echo "  $0 coverage ~/Developer/projects/my-app"
    echo "  $0 watch"
    echo "  $0 all ~/Developer"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"
    
    print_header
    
    case $command in
        run)
            project_dir=$(cd "$project_dir" && pwd)
            run_project_tests "$project_dir" "false" "false"
            ;;
        coverage)
            project_dir=$(cd "$project_dir" && pwd)
            run_project_tests "$project_dir" "true" "false"
            ;;
        watch)
            project_dir=$(cd "$project_dir" && pwd)
            run_project_tests "$project_dir" "false" "true"
            ;;
        all)
            run_all_workspace_tests "$project_dir" "false"
            ;;
        interactive)
            project_dir=$(cd "$project_dir" && pwd)
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
