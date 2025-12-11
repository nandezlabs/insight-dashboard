#!/bin/bash

################################################################################
# Deploy to Netlify
# Automated deployment workflow for Netlify hosting
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
    echo -e "${BLUE}  🌐 Netlify Deployment${NC}"
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
# Netlify CLI Check
################################################################################

check_netlify_cli() {
    if ! command -v netlify &> /dev/null; then
        print_error "Netlify CLI not found"
        print_info "Install with: npm install -g netlify-cli"
        exit 1
    fi
    
    print_success "Netlify CLI found"
}

check_netlify_auth() {
    if ! netlify status &> /dev/null; then
        print_error "Not logged into Netlify"
        print_info "Run: netlify login"
        exit 1
    fi
    
    print_success "Logged into Netlify"
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
    elif [[ -f "$project_dir/package.json" ]]; then
        echo "nodejs"
    elif [[ -f "$project_dir/index.html" ]]; then
        echo "static"
    else
        echo "unknown"
    fi
}

get_build_command() {
    local project_type="$1"
    
    case $project_type in
        nextjs)
            echo "npm run build && npm run export"
            ;;
        vite)
            echo "npm run build"
            ;;
        static)
            echo ""
            ;;
        *)
            echo "npm run build"
            ;;
    esac
}

get_publish_directory() {
    local project_type="$1"
    
    case $project_type in
        nextjs)
            echo "out"
            ;;
        vite)
            echo "dist"
            ;;
        static)
            echo "."
            ;;
        *)
            echo "dist"
            ;;
    esac
}

################################################################################
# Site Configuration
################################################################################

create_netlify_toml() {
    local project_dir="$1"
    local project_type="$2"
    
    if [[ -f "$project_dir/netlify.toml" ]]; then
        print_info "netlify.toml already exists"
        return 0
    fi
    
    print_info "Creating netlify.toml..."
    
    local build_cmd=$(get_build_command "$project_type")
    local publish_dir=$(get_publish_directory "$project_type")
    
    cat > "$project_dir/netlify.toml" << EOF
[build]
  command = "$build_cmd"
  publish = "$publish_dir"

[build.environment]
  NODE_VERSION = "18"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
EOF
    
    print_success "Created netlify.toml"
}

################################################################################
# Site Initialization
################################################################################

init_site() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    if [[ -f ".netlify/state.json" ]]; then
        print_info "Site already linked"
        return 0
    fi
    
    print_info "Initializing Netlify site..."
    
    if netlify init; then
        print_success "Site initialized"
    else
        print_error "Failed to initialize site"
        exit 1
    fi
}

################################################################################
# Pre-deployment Checks
################################################################################

check_git_status() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_warning "Not a git repository"
        return 1
    fi
    
    local branch=$(git branch --show-current)
    print_info "Current branch: $branch"
    
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "Uncommitted changes detected"
        git status --short
        echo ""
    else
        print_success "Working directory clean"
    fi
}

run_build_test() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Running build test..."
    
    if npm run build &> /tmp/netlify_build_test.log; then
        print_success "Build test passed"
        return 0
    else
        print_error "Build test failed"
        print_info "Check log: /tmp/netlify_build_test.log"
        tail -20 /tmp/netlify_build_test.log
        return 1
    fi
}

################################################################################
# Deployment Functions
################################################################################

deploy_production() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Deploying to production..."
    echo ""
    
    if netlify deploy --prod; then
        echo ""
        print_success "Deployed to production!"
        
        # Get site info
        local site_url=$(netlify status | grep "Site URL" | awk '{print $3}')
        if [[ -n "$site_url" ]]; then
            print_info "Site URL: $site_url"
        fi
    else
        echo ""
        print_error "Production deployment failed"
        exit 1
    fi
}

deploy_preview() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Deploying preview..."
    echo ""
    
    if netlify deploy; then
        echo ""
        print_success "Preview deployed!"
        print_info "Check the URL above to preview your changes"
    else
        echo ""
        print_error "Preview deployment failed"
        exit 1
    fi
}

deploy_build() {
    local project_dir="$1"
    local publish_dir="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Deploying pre-built site from: $publish_dir"
    echo ""
    
    if netlify deploy --dir="$publish_dir" --prod; then
        echo ""
        print_success "Deployed to production!"
    else
        echo ""
        print_error "Deployment failed"
        exit 1
    fi
}

################################################################################
# Site Management
################################################################################

show_status() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Site status:"
    netlify status
}

open_site() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Opening site in browser..."
    netlify open:site
}

open_admin() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Opening admin dashboard..."
    netlify open:admin
}

################################################################################
# Environment Variables
################################################################################

list_env_vars() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Environment variables:"
    netlify env:list
}

set_env_var() {
    local project_dir="$1"
    local key="$2"
    local value="$3"
    
    cd "$project_dir" || exit 1
    
    print_info "Setting environment variable: $key"
    
    if netlify env:set "$key" "$value"; then
        print_success "Environment variable set"
    else
        print_error "Failed to set environment variable"
    fi
}

################################################################################
# Functions & Forms
################################################################################

list_functions() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Netlify Functions:"
    netlify functions:list
}

watch_functions() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Starting Netlify Dev server..."
    netlify dev
}

################################################################################
# Logs
################################################################################

show_logs() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Recent logs:"
    netlify logs:site
}

show_function_logs() {
    local project_dir="$1"
    local function_name="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Logs for function: $function_name"
    netlify logs:function "$function_name"
}

################################################################################
# Domain Management
################################################################################

list_domains() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Domains:"
    netlify domains:list
}

add_domain() {
    local project_dir="$1"
    local domain="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Adding domain: $domain"
    
    if netlify domains:add "$domain"; then
        print_success "Domain added"
        print_info "Configure DNS records:"
        netlify domains:show "$domain"
    else
        print_error "Failed to add domain"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_deploy() {
    local project_dir="${1:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local project_type=$(detect_project_type "$project_dir")
    local project_name=$(basename "$project_dir")
    
    print_info "Project: $project_name"
    print_info "Type: $project_type"
    echo ""
    
    echo -e "${CYAN}Deployment Options:${NC}"
    echo "  1) Deploy to production"
    echo "  2) Deploy preview"
    echo "  3) Initialize site"
    echo "  4) Create netlify.toml"
    echo "  5) View status"
    echo "  6) View logs"
    echo "  7) Start Netlify Dev"
    echo "  8) Manage domains"
    echo "  9) Manage environment variables"
    echo "  0) Open admin dashboard"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            deploy_production "$project_dir"
            ;;
        2)
            deploy_preview "$project_dir"
            ;;
        3)
            init_site "$project_dir"
            ;;
        4)
            create_netlify_toml "$project_dir" "$project_type"
            ;;
        5)
            show_status "$project_dir"
            ;;
        6)
            show_logs "$project_dir"
            ;;
        7)
            watch_functions "$project_dir"
            ;;
        8)
            list_domains "$project_dir"
            ;;
        9)
            list_env_vars "$project_dir"
            ;;
        0)
            open_admin "$project_dir"
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
    echo "  deploy [DIR]         Deploy to production (default: current dir)"
    echo "  preview [DIR]        Deploy preview"
    echo "  init [DIR]           Initialize Netlify site"
    echo "  config [DIR]         Create netlify.toml"
    echo "  status [DIR]         Show site status"
    echo "  logs [DIR]           Show deployment logs"
    echo "  dev [DIR]            Start Netlify Dev server"
    echo "  domains [DIR]        List domains"
    echo "  env [DIR]            List environment variables"
    echo "  interactive [DIR]    Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 deploy"
    echo "  $0 preview ~/Developer/projects/my-app"
    echo "  $0 init"
    echo "  $0 dev"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"
    
    print_header
    
    check_netlify_cli
    check_netlify_auth
    
    echo ""
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local project_type=$(detect_project_type "$project_dir")
    
    case $command in
        deploy)
            check_git_status "$project_dir"
            deploy_production "$project_dir"
            ;;
        preview)
            check_git_status "$project_dir"
            deploy_preview "$project_dir"
            ;;
        init)
            init_site "$project_dir"
            ;;
        config)
            create_netlify_toml "$project_dir" "$project_type"
            ;;
        status)
            show_status "$project_dir"
            ;;
        logs)
            show_logs "$project_dir"
            ;;
        dev)
            watch_functions "$project_dir"
            ;;
        domains)
            list_domains "$project_dir"
            ;;
        env)
            list_env_vars "$project_dir"
            ;;
        interactive)
            interactive_deploy "$project_dir"
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
