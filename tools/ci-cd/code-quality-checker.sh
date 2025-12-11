#!/bin/bash
set -euo pipefail

################################################################################
# Code Quality Checker
# Run linting, formatting, and type checking across project types
################################################################################

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
    echo -e "${BLUE}  ✨  Code Quality Checker${NC}"
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

    if [ ! -d "${project_dir}" ]; then
        echo "unknown"
        return 1
    fi

    if [[ -f "${project_dir}/package.json" ]]; then
        echo "nodejs"
    elif [[ -f "${project_dir}/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "${project_dir}/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "${project_dir}/go.mod" ]]; then
        echo "go"
    elif [[ -f "${project_dir}/Package.swift" ]]; then
        echo "swift"
    else
        echo "unknown"
    fi
}

################################################################################
# Node.js/TypeScript Quality Checks
################################################################################

check_nodejs_quality() {
    local project_dir="$1"
    local fix="${2:-false}"

    if [ ! -d "${project_dir}" ]; then
        print_error "Project directory not found: ${project_dir}"
        return 1
    fi

    cd "${project_dir}"

    local issues=0

    # ESLint
    print_section "ESLint"

    if [[ ! -d "node_modules" ]]; then
        print_info "Installing dependencies..."
        npm install
    fi

    if grep -q '"lint"' package.json; then
        if [[ "$fix" == "true" ]]; then
            print_info "Running ESLint with --fix..."
            if npm run lint -- --fix; then
                print_success "ESLint passed (auto-fixed)"
            else
                print_error "ESLint found issues"
                ((issues++))
            fi
        else
            print_info "Running ESLint..."
            if npm run lint; then
                print_success "ESLint passed"
            else
                print_error "ESLint found issues"
                ((issues++))
            fi
        fi
    else
        print_warning "No lint script found"
    fi

    # Prettier
    print_section "Prettier"

    if command -v prettier >/dev/null 2>&1 || [[ -d "node_modules/.bin/prettier" ]]; then
        if [[ "$fix" == "true" ]]; then
            print_info "Running Prettier with --write..."
            if npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,md}"; then
                print_success "Prettier formatted files"
            fi
        else
            print_info "Checking Prettier formatting..."
            if npx prettier --check "**/*.{js,jsx,ts,tsx,json,css,scss,md}"; then
                print_success "Prettier formatting is correct"
            else
                print_error "Prettier found formatting issues"
                ((issues++))
            fi
        fi
    else
        print_warning "Prettier not found"
    fi

    # TypeScript
    print_section "TypeScript"

    if [[ -f "tsconfig.json" ]]; then
        print_info "Type checking with TypeScript..."
        if npx tsc --noEmit; then
            print_success "Type checking passed"
        else
            print_error "Type checking failed"
            ((issues++))
        fi
    else
        print_info "No TypeScript configuration found"
    fi

    return $issues
}

################################################################################
# Python Quality Checks
################################################################################

check_python_quality() {
    local project_dir="$1"
    local fix="${2:-false}"

    cd "$project_dir"

    local issues=0

    # Black
    print_section "Black (Formatter)"

    if [[ "$fix" == "true" ]]; then
        print_info "Running Black..."
        if poetry run black .; then
            print_success "Black formatted files"
        fi
    else
        print_info "Checking Black formatting..."
        if poetry run black --check .; then
            print_success "Black formatting is correct"
        else
            print_error "Black found formatting issues"
            ((issues++))
        fi
    fi

    # isort
    print_section "isort (Import Sorting)"

    if [[ "$fix" == "true" ]]; then
        print_info "Running isort..."
        if poetry run isort .; then
            print_success "isort organized imports"
        fi
    else
        print_info "Checking isort..."
        if poetry run isort --check-only .; then
            print_success "Import sorting is correct"
        else
            print_error "isort found issues"
            ((issues++))
        fi
    fi

    # Flake8
    print_section "Flake8 (Linter)"

    print_info "Running Flake8..."
    if poetry run flake8 .; then
        print_success "Flake8 passed"
    else
        print_error "Flake8 found issues"
        ((issues++))
    fi

    # MyPy
    print_section "MyPy (Type Checker)"

    print_info "Running MyPy..."
    if poetry run mypy .; then
        print_success "MyPy type checking passed"
    else
        print_error "MyPy found type errors"
        ((issues++))
    fi

    # Bandit (Security)
    print_section "Bandit (Security)"

    print_info "Running Bandit security scan..."
    if poetry run bandit -r . -ll; then
        print_success "Bandit security scan passed"
    else
        print_warning "Bandit found security issues"
        ((issues++))
    fi

    return $issues
}

################################################################################
# Rust Quality Checks
################################################################################

check_rust_quality() {
    local project_dir="$1"
    local fix="${2:-false}"

    cd "$project_dir"

    local issues=0

    # Rustfmt
    print_section "Rustfmt (Formatter)"

    if [[ "$fix" == "true" ]]; then
        print_info "Running rustfmt..."
        if cargo fmt; then
            print_success "Rustfmt formatted files"
        fi
    else
        print_info "Checking rustfmt..."
        if cargo fmt -- --check; then
            print_success "Rustfmt formatting is correct"
        else
            print_error "Rustfmt found formatting issues"
            ((issues++))
        fi
    fi

    # Clippy
    print_section "Clippy (Linter)"

    print_info "Running Clippy..."
    if cargo clippy -- -D warnings; then
        print_success "Clippy passed"
    else
        print_error "Clippy found issues"
        ((issues++))
    fi

    # Cargo check
    print_section "Cargo Check"

    print_info "Running cargo check..."
    if cargo check; then
        print_success "Cargo check passed"
    else
        print_error "Cargo check failed"
        ((issues++))
    fi

    return $issues
}

################################################################################
# Go Quality Checks
################################################################################

check_go_quality() {
    local project_dir="$1"
    local fix="${2:-false}"

    cd "$project_dir"

    local issues=0

    # gofmt
    print_section "gofmt (Formatter)"

    if [[ "$fix" == "true" ]]; then
        print_info "Running gofmt..."
        gofmt -w .
        print_success "gofmt formatted files"
    else
        print_info "Checking gofmt..."
        local unformatted=$(gofmt -l .)
        if [[ -z "$unformatted" ]]; then
            print_success "gofmt formatting is correct"
        else
            print_error "gofmt found unformatted files:"
            echo "$unformatted"
            ((issues++))
        fi
    fi

    # goimports
    print_section "goimports (Import Formatter)"

    if command -v goimports >/dev/null 2>&1; then
        if [[ "$fix" == "true" ]]; then
            print_info "Running goimports..."
            goimports -w .
            print_success "goimports formatted imports"
        else
            print_info "Checking goimports..."
            local unformatted=$(goimports -l .)
            if [[ -z "$unformatted" ]]; then
                print_success "Import formatting is correct"
            else
                print_error "goimports found issues"
                ((issues++))
            fi
        fi
    else
        print_warning "goimports not installed"
    fi

    # go vet
    print_section "go vet (Static Analysis)"

    print_info "Running go vet..."
    if go vet ./...; then
        print_success "go vet passed"
    else
        print_error "go vet found issues"
        ((issues++))
    fi

    # golangci-lint
    print_section "golangci-lint (Comprehensive Linter)"

    if command -v golangci-lint >/dev/null 2>&1; then
        if [[ "$fix" == "true" ]]; then
            print_info "Running golangci-lint with --fix..."
            if golangci-lint run --fix; then
                print_success "golangci-lint passed (auto-fixed)"
            else
                print_error "golangci-lint found issues"
                ((issues++))
            fi
        else
            print_info "Running golangci-lint..."
            if golangci-lint run; then
                print_success "golangci-lint passed"
            else
                print_error "golangci-lint found issues"
                ((issues++))
            fi
        fi
    else
        print_warning "golangci-lint not installed"
    fi

    return $issues
}

################################################################################
# Swift Quality Checks
################################################################################

check_swift_quality() {
    local project_dir="$1"
    local fix="${2:-false}"

    cd "$project_dir"

    local issues=0

    # SwiftFormat
    print_section "SwiftFormat (Formatter)"

    if command -v swiftformat >/dev/null 2>&1; then
        if [[ "$fix" == "true" ]]; then
            print_info "Running SwiftFormat..."
            if swiftformat .; then
                print_success "SwiftFormat formatted files"
            fi
        else
            print_info "Checking SwiftFormat..."
            if swiftformat --lint .; then
                print_success "SwiftFormat formatting is correct"
            else
                print_error "SwiftFormat found formatting issues"
                ((issues++))
            fi
        fi
    else
        print_warning "SwiftFormat not installed"
    fi

    # SwiftLint
    print_section "SwiftLint (Linter)"

    if command -v swiftlint >/dev/null 2>&1; then
        if [[ "$fix" == "true" ]]; then
            print_info "Running SwiftLint with --fix..."
            if swiftlint --fix; then
                print_success "SwiftLint auto-fixed issues"
            fi

            # Still check for remaining issues
            if swiftlint; then
                print_success "SwiftLint passed"
            else
                print_error "SwiftLint found remaining issues"
                ((issues++))
            fi
        else
            print_info "Running SwiftLint..."
            if swiftlint; then
                print_success "SwiftLint passed"
            else
                print_error "SwiftLint found issues"
                ((issues++))
            fi
        fi
    else
        print_warning "SwiftLint not installed"
    fi

    return $issues
}

################################################################################
# Check All Workspace Projects
################################################################################

check_all_workspace() {
    local workspace_dir="${1:-$HOME/Developer}"
    local fix="${2:-false}"

    print_info "Scanning for projects in: $workspace_dir"
    echo ""

    local check_count=0
    local pass_count=0
    local fail_count=0

    # Find all git repositories
    while IFS= read -r project_dir; do
        local project_name=$(basename "$project_dir")
        local project_type=$(detect_project_type "$project_dir")

        if [[ "$project_type" != "unknown" ]]; then
            echo ""
            print_info "Checking: $project_name ($project_type)"

            ((check_count++))

            if check_project_quality "$project_dir" "$fix"; then
                ((pass_count++))
                print_success "Quality checks passed"
            else
                ((fail_count++))
                print_error "Quality checks failed"
            fi
        fi
    done < <(find "$workspace_dir" -name ".git" -type d -maxdepth 3 | sed 's/\/.git$//')

    # Summary
    print_section "Quality Check Summary"
    echo "Total projects checked: $check_count"
    echo -e "${GREEN}Passed: $pass_count${NC}"
    echo -e "${RED}Failed: $fail_count${NC}"
}

################################################################################
# Check Project Quality
################################################################################

check_project_quality() {
    local project_dir="$1"
    local fix="${2:-false}"

    local project_type=$(detect_project_type "$project_dir")

    case $project_type in
        nodejs)
            check_nodejs_quality "$project_dir" "$fix"
            ;;
        python)
            check_python_quality "$project_dir" "$fix"
            ;;
        rust)
            check_rust_quality "$project_dir" "$fix"
            ;;
        go)
            check_go_quality "$project_dir" "$fix"
            ;;
        swift)
            check_swift_quality "$project_dir" "$fix"
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

    echo -e "${CYAN}Quality Check Options:${NC}"
    echo "  1) Check code quality"
    echo "  2) Check and auto-fix issues"
    echo "  3) Check all workspace projects"
    echo "  q) Quit"
    echo ""

    read -p "Selection: " choice

    case $choice in
        1)
            check_project_quality "$project_dir" "false"
            ;;
        2)
            check_project_quality "$project_dir" "true"
            ;;
        3)
            read -p "Auto-fix issues? (y/n): " fix_choice
            if [[ "$fix_choice" == "y" ]]; then
                check_all_workspace "$HOME/Developer" "true"
            else
                check_all_workspace "$HOME/Developer" "false"
            fi
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
    echo "  check [DIR]          Check code quality"
    echo "  fix [DIR]            Check and auto-fix issues"
    echo "  all [WORKSPACE]      Check all projects in workspace"
    echo "  interactive [DIR]    Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 check"
    echo "  $0 fix ~/Developer/projects/my-app"
    echo "  $0 all ~/Developer"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"

    print_header

    case $command in
        check)
            project_dir=$(cd "$project_dir" && pwd)
            check_project_quality "$project_dir" "false"
            ;;
        fix)
            project_dir=$(cd "$project_dir" && pwd)
            check_project_quality "$project_dir" "true"
            ;;
        all)
            check_all_workspace "$project_dir" "false"
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
