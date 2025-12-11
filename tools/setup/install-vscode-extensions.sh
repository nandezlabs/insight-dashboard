#!/bin/bash

################################################################################
# VS Code Extensions Installer
# Installs recommended extensions for your development workflow
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# VS Code command (try both)
if command -v code &> /dev/null; then
    VSCODE_CMD="code"
else
    VSCODE_CMD="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📦 VS Code Extensions Installer${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_section() {
    echo -e "\n${CYAN}▸ $1${NC}"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_skip() {
    echo -e "  ${YELLOW}⊘${NC} $1"
}

print_info() {
    echo -e "  ${YELLOW}ℹ${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Install VS Code extensions for your development workflow.

OPTIONS:
    --all           Install all recommended extensions
    --essential     Install only essential extensions
    --web           Install web development extensions
    --godot         Install Godot game development extensions
    --python        Install Python development extensions
    --mobile        Install iOS/mobile development extensions
    --list          List all available extensions
    -h, --help      Show this help message

EXAMPLES:
    # Install essential extensions only
    $(basename "$0") --essential

    # Install web development extensions
    $(basename "$0") --web

    # Install everything
    $(basename "$0") --all

EOF
}

is_installed() {
    local extension="$1"
    "$VSCODE_CMD" --list-extensions 2>/dev/null | grep -qi "^${extension}$"
}

install_extension() {
    local extension="$1"
    local description="$2"
    
    if is_installed "$extension"; then
        print_skip "$description (already installed)"
    else
        local output
        output=$("$VSCODE_CMD" --install-extension "$extension" --force 2>&1)
        if echo "$output" | grep -q "successfully installed"; then
            print_success "$description"
        else
            print_error "$description (installation failed)"
            echo "$output" | grep -i "error" >&2
        fi
    fi
}

################################################################################
# Extension Categories
################################################################################

install_essential_extensions() {
    print_section "Essential Extensions"
    
    # Already installed: GitHub Copilot, GitLens, Prettier, Material Icon Theme,
    # Path Intellisense, Error Lens, Better Comments, Todo Tree
    
    install_extension "dbaeumer.vscode-eslint" "ESLint"
    install_extension "formulahendry.auto-close-tag" "Auto Close Tag"
    # Auto Rename Tag already installed
    install_extension "wayou.vscode-todo-highlight" "TODO Highlight"
    install_extension "oderwat.indent-rainbow" "Indent Rainbow"
}

install_web_extensions() {
    print_section "Web Development Extensions"
    
    # React/Next.js
    install_extension "dsznajder.es7-react-js-snippets" "ES7+ React/Redux/React-Native snippets"
    install_extension "bradlc.vscode-tailwindcss" "Tailwind CSS IntelliSense"
    install_extension "zignd.html-css-class-completion" "CSS Peek"
    
    # TypeScript
    install_extension "yoavbls.pretty-ts-errors" "Pretty TypeScript Errors"
    
    # Backend/API - Already have REST Client and Thunder Client
    # Docker already installed
    
    print_success "Web development extensions configured"
}

install_godot_extensions() {
    print_section "Godot Game Development Extensions"
    
    install_extension "geequlim.godot-tools" "Godot Tools (GDScript support)"
    install_extension "neikeq.godot-csharp-vscode" "Godot C# Support"
    
    print_info "Configure Godot to use VS Code:"
    echo "    In Godot: Editor → Editor Settings → Text Editor → External"
    echo "    Exec Path: code"
    echo "    Exec Flags: {project} --goto {file}:{line}:{col}"
}

install_python_extensions() {
    print_section "Python Development Extensions"
    
    # Already installed: Python, Pylance, Python Debugger, Jupyter
    
    install_extension "ms-python.black-formatter" "Black Formatter"
    install_extension "ms-python.isort" "isort"
    install_extension "ms-python.flake8" "Flake8"
    
    print_success "Python extensions configured"
}

install_mobile_extensions() {
    print_section "iOS/Mobile Development Extensions"
    
    install_extension "sweetpad.sweetpad" "SweetPad (iOS/Swift development)"
    
    print_info "For iOS development, Xcode is still required for building"
}

install_database_extensions() {
    print_section "Database Extensions"
    
    # SQLTools already installed
    install_extension "mtxr.sqltools-driver-sqlite" "SQLTools SQLite Driver"
    install_extension "mtxr.sqltools-driver-pg" "SQLTools PostgreSQL Driver"
    install_extension "cweijan.vscode-postgresql-client2" "PostgreSQL Client"
}

install_productivity_extensions() {
    print_section "Productivity Extensions"
    
    # Already installed: Project Manager, Git Graph, Git History
    
    install_extension "mikestead.dotenv" "DotENV"
    install_extension "editorconfig.editorconfig" "EditorConfig"
    install_extension "shardulm94.trailing-spaces" "Trailing Spaces"
    install_extension "wmaurer.change-case" "Change Case"
}

################################################################################
# List Available Extensions
################################################################################

list_extensions() {
    print_header
    
    echo -e "${CYAN}Essential Extensions:${NC}"
    echo "  • ESLint - JavaScript/TypeScript linting"
    echo "  • Auto Close Tag - Automatically close HTML/XML tags"
    echo "  • TODO Highlight - Highlight TODO, FIXME, etc."
    echo "  • Indent Rainbow - Colorize indentation"
    
    echo -e "\n${CYAN}Web Development:${NC}"
    echo "  • ES7+ React/Redux snippets - React code snippets"
    echo "  • Tailwind CSS IntelliSense - Tailwind autocomplete"
    echo "  • CSS Peek - Navigate to CSS definitions"
    echo "  • Pretty TypeScript Errors - Readable TS errors"
    
    echo -e "\n${CYAN}Godot Game Development:${NC}"
    echo "  • Godot Tools - GDScript support and debugging"
    echo "  • Godot C# Support - C# scripting in Godot"
    
    echo -e "\n${CYAN}Python Development:${NC}"
    echo "  • Black Formatter - Python code formatting"
    echo "  • isort - Import statement sorting"
    echo "  • Flake8 - Python linting"
    
    echo -e "\n${CYAN}iOS/Mobile Development:${NC}"
    echo "  • SweetPad - Complete iOS/Swift development in VS Code"
    echo "  • Includes Swift syntax, debugging, and Xcode integration"
    
    echo -e "\n${CYAN}Database:${NC}"
    echo "  • SQLTools SQLite Driver - SQLite support"
    echo "  • SQLTools PostgreSQL Driver - PostgreSQL support"
    echo "  • PostgreSQL Client - Enhanced PostgreSQL tools"
    
    echo -e "\n${CYAN}Productivity:${NC}"
    echo "  • DotENV - .env file syntax highlighting"
    echo "  • EditorConfig - Maintain coding styles"
    echo "  • Trailing Spaces - Highlight/remove trailing spaces"
    echo "  • Change Case - Quick case conversion"
    
    echo -e "\n${CYAN}Already Installed (Core):${NC}"
    echo "  ✓ GitHub Copilot & Copilot Chat"
    echo "  ✓ GitLens"
    echo "  ✓ Prettier"
    echo "  ✓ Material Icon Theme"
    echo "  ✓ Path Intellisense"
    echo "  ✓ Error Lens"
    echo "  ✓ Auto Rename Tag"
    echo "  ✓ Better Comments"
    echo "  ✓ Todo Tree"
    echo "  ✓ REST Client"
    echo "  ✓ Thunder Client"
    echo "  ✓ Docker"
    echo "  ✓ Python + Pylance + Jupyter"
    echo "  ✓ Project Manager"
    echo "  ✓ Git Graph"
    echo "  ✓ Code Spell Checker"
    echo ""
}

################################################################################
# Main Script
################################################################################

main() {
    # Check if VS Code is available
    if ! command -v "$VSCODE_CMD" &> /dev/null && [ ! -f "$VSCODE_CMD" ]; then
        print_error "VS Code not found. Please install VS Code first."
        exit 1
    fi
    
    # Parse arguments
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 0
    fi
    
    case "$1" in
        --all)
            print_header
            install_essential_extensions
            install_web_extensions
            install_godot_extensions
            install_python_extensions
            install_mobile_extensions
            install_database_extensions
            install_productivity_extensions
            echo ""
            print_success "All extensions installed!"
            ;;
        --essential)
            print_header
            install_essential_extensions
            echo ""
            print_success "Essential extensions installed!"
            ;;
        --web)
            print_header
            install_web_extensions
            echo ""
            print_success "Web development extensions installed!"
            ;;
        --godot)
            print_header
            install_godot_extensions
            echo ""
            print_success "Godot extensions installed!"
            ;;
        --python)
            print_header
            install_python_extensions
            echo ""
            print_success "Python extensions installed!"
            ;;
        --mobile)
            print_header
            install_mobile_extensions
            echo ""
            print_success "Mobile development extensions installed!"
            ;;
        --list)
            list_extensions
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
