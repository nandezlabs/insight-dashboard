#!/bin/bash
set -euo pipefail

################################################################################
# Pre-commit Hook Manager
# Manage Git pre-commit hooks for code quality checks
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
    echo -e "${BLUE}  🪝  Pre-commit Hook Manager${NC}"
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

    if [[ -f "$project_dir/package.json" ]]; then
        echo "nodejs"
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "go"
    elif [[ -f "$project_dir/Package.swift" ]]; then
        echo "swift"
    else
        echo "unknown"
    fi
}

################################################################################
# Pre-commit Framework Installation
################################################################################

install_precommit_framework() {
    local project_dir="$1"

    print_info "Installing pre-commit framework..."

    if command -v pre-commit >/dev/null 2>&1; then
        print_success "pre-commit already installed: $(pre-commit --version)"
    else
        if command -v pip3 >/dev/null 2>&1; then
            pip3 install pre-commit
            print_success "Installed pre-commit via pip"
        elif command -v brew >/dev/null 2>&1; then
            brew install pre-commit
            print_success "Installed pre-commit via Homebrew"
        else
            print_error "Cannot install pre-commit. Please install pip3 or Homebrew first."
            return 1
        fi
    fi
}

################################################################################
# Node.js/TypeScript Pre-commit Config
################################################################################

create_nodejs_precommit() {
    local project_dir="$1"

    cat > "$project_dir/.pre-commit-config.yaml" << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-merge-conflict
      - id: detect-private-key
      - id: mixed-line-ending
        args: ['--fix=lf']

  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.56.0
    hooks:
      - id: eslint
        files: \.(js|jsx|ts|tsx)$
        types: [file]
        additional_dependencies:
          - eslint
          - '@typescript-eslint/parser'
          - '@typescript-eslint/eslint-plugin'

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.1.0
    hooks:
      - id: prettier
        files: \.(js|jsx|ts|tsx|json|css|scss|md|yaml|yml)$

  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
EOF

    print_success "Created Node.js pre-commit configuration"
}

################################################################################
# Python Pre-commit Config
################################################################################

create_python_precommit() {
    local project_dir="$1"

    cat > "$project_dir/.pre-commit-config.yaml" << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-merge-conflict
      - id: detect-private-key
      - id: mixed-line-ending
        args: ['--fix=lf']
      - id: check-docstring-first
      - id: check-ast
      - id: debug-statements

  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
        language_version: python3.11

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: ['--profile', 'black']

  - repo: https://github.com/pycqa/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
        args: ['--max-line-length=88', '--extend-ignore=E203']

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies: [types-all]

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.6
    hooks:
      - id: bandit
        args: ['-c', 'pyproject.toml']
        additional_dependencies: ['bandit[toml]']

  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
EOF

    print_success "Created Python pre-commit configuration"
}

################################################################################
# Rust Pre-commit Config
################################################################################

create_rust_precommit() {
    local project_dir="$1"

    cat > "$project_dir/.pre-commit-config.yaml" << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-merge-conflict
      - id: detect-private-key
      - id: mixed-line-ending
        args: ['--fix=lf']

  - repo: local
    hooks:
      - id: cargo-fmt
        name: cargo fmt
        entry: cargo fmt --
        language: system
        types: [rust]
        pass_filenames: false

      - id: cargo-clippy
        name: cargo clippy
        entry: cargo clippy -- -D warnings
        language: system
        types: [rust]
        pass_filenames: false

      - id: cargo-test
        name: cargo test
        entry: cargo test
        language: system
        types: [rust]
        pass_filenames: false

  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
EOF

    print_success "Created Rust pre-commit configuration"
}

################################################################################
# Go Pre-commit Config
################################################################################

create_go_precommit() {
    local project_dir="$1"

    cat > "$project_dir/.pre-commit-config.yaml" << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-merge-conflict
      - id: detect-private-key
      - id: mixed-line-ending
        args: ['--fix=lf']

  - repo: local
    hooks:
      - id: go-fmt
        name: go fmt
        entry: gofmt -w
        language: system
        types: [go]

      - id: go-imports
        name: go imports
        entry: goimports -w
        language: system
        types: [go]

      - id: go-vet
        name: go vet
        entry: go vet
        language: system
        types: [go]
        pass_filenames: false

      - id: go-test
        name: go test
        entry: go test ./...
        language: system
        types: [go]
        pass_filenames: false

      - id: golangci-lint
        name: golangci-lint
        entry: golangci-lint run
        language: system
        types: [go]
        pass_filenames: false

  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
EOF

    print_success "Created Go pre-commit configuration"
}

################################################################################
# Swift Pre-commit Config
################################################################################

create_swift_precommit() {
    local project_dir="$1"

    cat > "$project_dir/.pre-commit-config.yaml" << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-merge-conflict
      - id: detect-private-key
      - id: mixed-line-ending
        args: ['--fix=lf']

  - repo: local
    hooks:
      - id: swiftlint
        name: SwiftLint
        entry: swiftlint
        language: system
        types: [swift]
        args: ['--strict']

      - id: swiftformat
        name: SwiftFormat
        entry: swiftformat
        language: system
        types: [swift]

  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
EOF

    print_success "Created Swift pre-commit configuration"
}

################################################################################
# Install Hooks
################################################################################

install_hooks() {
    local project_dir="$1"

    cd "$project_dir"

    if [[ ! -f ".pre-commit-config.yaml" ]]; then
        print_error "No .pre-commit-config.yaml found. Create configuration first."
        return 1
    fi

    print_info "Installing pre-commit hooks..."

    if pre-commit install >/dev/null 2>&1; then
        print_success "Hooks installed in .git/hooks/"
    else
        print_error "Failed to install hooks"
        return 1
    fi

    # Also install commit-msg hook for commitizen
    if pre-commit install --hook-type commit-msg >/dev/null 2>&1; then
        print_success "Commit message hook installed"
    fi
}

################################################################################
# Run Hooks on All Files
################################################################################

run_all() {
    local project_dir="$1"

    cd "$project_dir"

    if [[ ! -f ".pre-commit-config.yaml" ]]; then
        print_error "No .pre-commit-config.yaml found"
        return 1
    fi

    print_info "Running hooks on all files..."
    echo ""

    if pre-commit run --all-files; then
        echo ""
        print_success "All checks passed!"
    else
        echo ""
        print_warning "Some checks failed. Review the output above."
        return 1
    fi
}

################################################################################
# Update Hooks
################################################################################

update_hooks() {
    local project_dir="$1"

    cd "$project_dir"

    if [[ ! -f ".pre-commit-config.yaml" ]]; then
        print_error "No .pre-commit-config.yaml found"
        return 1
    fi

    print_info "Updating pre-commit hooks..."

    if pre-commit autoupdate; then
        print_success "Hooks updated to latest versions"
    else
        print_error "Failed to update hooks"
        return 1
    fi
}

################################################################################
# Uninstall Hooks
################################################################################

uninstall_hooks() {
    local project_dir="$1"

    cd "$project_dir"

    print_info "Uninstalling pre-commit hooks..."

    if pre-commit uninstall >/dev/null 2>&1; then
        print_success "Hooks removed from .git/hooks/"
    fi

    if pre-commit uninstall --hook-type commit-msg >/dev/null 2>&1; then
        print_success "Commit message hook removed"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    local project_dir="${1:-.}"

    project_dir=$(cd "$project_dir" && pwd)

    if [[ ! -d "$project_dir/.git" ]]; then
        print_error "Not a git repository: $project_dir"
        exit 1
    fi

    local project_type=$(detect_project_type "$project_dir")
    local project_name=$(basename "$project_dir")

    print_info "Project: $project_name"
    print_info "Type: $project_type"
    echo ""

    echo -e "${CYAN}Pre-commit Options:${NC}"
    echo "  1) Create & install hooks"
    echo "  2) Install hooks (config exists)"
    echo "  3) Run hooks on all files"
    echo "  4) Update hooks to latest versions"
    echo "  5) Uninstall hooks"
    echo "  q) Quit"
    echo ""

    read -p "Selection: " choice

    case $choice in
        1)
            # Check if framework is installed
            if ! command -v pre-commit >/dev/null 2>&1; then
                install_precommit_framework "$project_dir"
            fi

            # Create config based on project type
            case $project_type in
                nodejs)
                    create_nodejs_precommit "$project_dir"
                    ;;
                python)
                    create_python_precommit "$project_dir"
                    ;;
                rust)
                    create_rust_precommit "$project_dir"
                    ;;
                go)
                    create_go_precommit "$project_dir"
                    ;;
                swift)
                    create_swift_precommit "$project_dir"
                    ;;
                *)
                    print_error "No pre-commit template for: $project_type"
                    exit 1
                    ;;
            esac

            # Install hooks
            install_hooks "$project_dir"

            echo ""
            print_info "Run 'git commit' to trigger hooks automatically"
            print_info "Or use: $0 run [DIR] to check all files now"
            ;;
        2)
            install_hooks "$project_dir"
            ;;
        3)
            run_all "$project_dir"
            ;;
        4)
            update_hooks "$project_dir"
            ;;
        5)
            uninstall_hooks "$project_dir"
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
    echo "  init [DIR]           Create config & install hooks"
    echo "  install [DIR]        Install hooks from existing config"
    echo "  run [DIR]            Run hooks on all files"
    echo "  update [DIR]         Update hooks to latest versions"
    echo "  uninstall [DIR]      Remove hooks from git"
    echo "  interactive [DIR]    Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 init"
    echo "  $0 run ~/Developer/projects/my-app"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"

    print_header

    project_dir=$(cd "$project_dir" && pwd)

    if [[ ! -d "$project_dir/.git" ]]; then
        print_error "Not a git repository: $project_dir"
        exit 1
    fi

    case $command in
        init)
            if ! command -v pre-commit >/dev/null 2>&1; then
                install_precommit_framework "$project_dir"
            fi

            local project_type=$(detect_project_type "$project_dir")

            case $project_type in
                nodejs) create_nodejs_precommit "$project_dir" ;;
                python) create_python_precommit "$project_dir" ;;
                rust) create_rust_precommit "$project_dir" ;;
                go) create_go_precommit "$project_dir" ;;
                swift) create_swift_precommit "$project_dir" ;;
                *) print_error "Unsupported project type: $project_type"; exit 1 ;;
            esac

            install_hooks "$project_dir"
            ;;
        install)
            install_hooks "$project_dir"
            ;;
        run)
            run_all "$project_dir"
            ;;
        update)
            update_hooks "$project_dir"
            ;;
        uninstall)
            uninstall_hooks "$project_dir"
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
