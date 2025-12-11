#!/bin/bash

################################################################################
# Deploy to Vercel
# Automated deployment workflow for Vercel hosting
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
    echo -e "${BLUE}  🚀 Vercel Deployment${NC}"
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
# Vercel CLI Check
################################################################################

check_vercel_cli() {
    if ! command -v vercel &> /dev/null; then
        print_error "Vercel CLI not found"
        print_info "Install with: npm install -g vercel"
        exit 1
    fi
    
    print_success "Vercel CLI found"
}

check_vercel_auth() {
    if ! vercel whoami &> /dev/null; then
        print_error "Not logged into Vercel"
        print_info "Run: vercel login"
        exit 1
    fi
    
    local user=$(vercel whoami 2>/dev/null)
    print_success "Logged in as: $user"
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
    else
        echo "unknown"
    fi
}

get_project_name() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/package.json" ]]; then
        local name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_dir/package.json" | sed 's/"name"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')
        echo "$name"
    else
        basename "$project_dir"
    fi
}

################################################################################
# Pre-deployment Checks
################################################################################

check_git_status() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_warning "Not a git repository - Vercel deployments work best with git"
        return 1
    fi
    
    local branch=$(git branch --show-current)
    print_info "Current branch: $branch"
    
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "Uncommitted changes detected:"
        git status --short
        echo ""
        read -p "Continue anyway? (y/n): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_error "Deployment cancelled"
            exit 1
        fi
    else
        print_success "Working directory clean"
    fi
}

check_env_vars() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/.env.local" ]] || [[ -f "$project_dir/.env" ]]; then
        print_warning "Environment files detected"
        print_info "Don't forget to set environment variables in Vercel dashboard"
        echo "  Visit: https://vercel.com/dashboard"
        echo ""
    fi
}

run_build_test() {
    local project_dir="$1"
    local project_type="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Running build test..."
    
    case $project_type in
        nextjs)
            if npm run build &> /tmp/vercel_build_test.log; then
                print_success "Build test passed"
                return 0
            else
                print_error "Build test failed"
                print_info "Check log: /tmp/vercel_build_test.log"
                tail -20 /tmp/vercel_build_test.log
                return 1
            fi
            ;;
        vite)
            if npm run build &> /tmp/vercel_build_test.log; then
                print_success "Build test passed"
                return 0
            else
                print_error "Build test failed"
                print_info "Check log: /tmp/vercel_build_test.log"
                tail -20 /tmp/vercel_build_test.log
                return 1
            fi
            ;;
        *)
            print_warning "Build test skipped for $project_type"
            return 0
            ;;
    esac
}

################################################################################
# Deployment Functions
################################################################################

deploy_production() {
    local project_dir="$1"
    local project_name="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Deploying to production..."
    echo ""
    
    if vercel --prod; then
        echo ""
        print_success "Deployed to production!"
        print_info "Your app is live at the URL shown above"
    else
        echo ""
        print_error "Production deployment failed"
        exit 1
    fi
}

deploy_preview() {
    local project_dir="$1"
    local project_name="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Deploying preview..."
    echo ""
    
    if vercel; then
        echo ""
        print_success "Preview deployed!"
        print_info "Your preview is live at the URL shown above"
    else
        echo ""
        print_error "Preview deployment failed"
        exit 1
    fi
}

################################################################################
# Vercel Configuration
################################################################################

create_vercel_config() {
    local project_dir="$1"
    local project_type="$2"
    
    if [[ -f "$project_dir/vercel.json" ]]; then
        print_info "vercel.json already exists"
        return 0
    fi
    
    print_info "Creating vercel.json..."
    
    case $project_type in
        nextjs)
            cat > "$project_dir/vercel.json" << 'EOF'
{
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "framework": "nextjs",
  "installCommand": "npm install"
}
EOF
            ;;
        vite)
            cat > "$project_dir/vercel.json" << 'EOF'
{
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "outputDirectory": "dist",
  "installCommand": "npm install",
  "rewrites": [
    { "source": "/(.*)", "destination": "/" }
  ]
}
EOF
            ;;
        *)
            print_warning "No default config for $project_type"
            return 1
            ;;
    esac
    
    print_success "Created vercel.json"
}

################################################################################
# Domain Management
################################################################################

list_domains() {
    local project_name="$1"
    
    print_info "Domains for $project_name:"
    vercel domains ls "$project_name" 2>/dev/null || print_warning "No domains found"
}

add_domain() {
    local project_name="$1"
    local domain="$2"
    
    print_info "Adding domain: $domain"
    
    if vercel domains add "$domain" "$project_name"; then
        print_success "Domain added: $domain"
        print_info "Configure DNS records:"
        vercel domains inspect "$domain"
    else
        print_error "Failed to add domain"
    fi
}

################################################################################
# Environment Variables
################################################################################

list_env_vars() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Environment variables:"
    vercel env ls
}

add_env_var() {
    local project_dir="$1"
    local key="$2"
    local value="$3"
    local environment="${4:-production}"
    
    cd "$project_dir" || exit 1
    
    print_info "Adding environment variable: $key"
    
    echo "$value" | vercel env add "$key" "$environment"
}

pull_env_vars() {
    local project_dir="$1"
    local environment="${2:-development}"
    
    cd "$project_dir" || exit 1
    
    print_info "Pulling environment variables for $environment..."
    
    if vercel env pull ".env.${environment}.local"; then
        print_success "Environment variables pulled to .env.${environment}.local"
    else
        print_error "Failed to pull environment variables"
    fi
}

################################################################################
# Deployment Logs
################################################################################

show_logs() {
    local project_dir="$1"
    local follow="${2:-false}"
    
    cd "$project_dir" || exit 1
    
    if [[ "$follow" == "true" ]]; then
        print_info "Following logs (Ctrl+C to stop)..."
        vercel logs --follow
    else
        print_info "Recent logs:"
        vercel logs
    fi
}

################################################################################
# Rollback
################################################################################

list_deployments() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Recent deployments:"
    vercel ls
}

rollback_deployment() {
    local project_dir="$1"
    local deployment_url="$2"
    
    cd "$project_dir" || exit 1
    
    print_warning "Rolling back to: $deployment_url"
    read -p "Are you sure? (y/n): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        if vercel promote "$deployment_url" --prod; then
            print_success "Rolled back to: $deployment_url"
        else
            print_error "Rollback failed"
        fi
    else
        print_info "Rollback cancelled"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_deploy() {
    local project_dir="${1:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local project_type=$(detect_project_type "$project_dir")
    local project_name=$(get_project_name "$project_dir")
    
    print_info "Project: $project_name"
    print_info "Type: $project_type"
    echo ""
    
    echo -e "${CYAN}Deployment Options:${NC}"
    echo "  1) Deploy to production"
    echo "  2) Deploy preview"
    echo "  3) Create vercel.json"
    echo "  4) List deployments"
    echo "  5) View logs"
    echo "  6) Manage domains"
    echo "  7) Manage environment variables"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            deploy_production "$project_dir" "$project_name"
            ;;
        2)
            deploy_preview "$project_dir" "$project_name"
            ;;
        3)
            create_vercel_config "$project_dir" "$project_type"
            ;;
        4)
            list_deployments "$project_dir"
            ;;
        5)
            show_logs "$project_dir" "false"
            ;;
        6)
            list_domains "$project_name"
            ;;
        7)
            list_env_vars "$project_dir"
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
    echo "  config [DIR]         Create vercel.json"
    echo "  logs [DIR]           Show deployment logs"
    echo "  list [DIR]           List deployments"
    echo "  domains [DIR]        List domains"
    echo "  env [DIR]            List environment variables"
    echo "  pull-env [DIR] [ENV] Pull environment variables"
    echo "  interactive [DIR]    Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 deploy"
    echo "  $0 preview ~/Developer/projects/my-app"
    echo "  $0 config"
    echo "  $0 pull-env . development"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"
    
    print_header
    
    check_vercel_cli
    check_vercel_auth
    
    echo ""
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local project_type=$(detect_project_type "$project_dir")
    local project_name=$(get_project_name "$project_dir")
    
    case $command in
        deploy)
            check_git_status "$project_dir"
            check_env_vars "$project_dir"
            deploy_production "$project_dir" "$project_name"
            ;;
        preview)
            check_git_status "$project_dir"
            deploy_preview "$project_dir" "$project_name"
            ;;
        config)
            create_vercel_config "$project_dir" "$project_type"
            ;;
        logs)
            show_logs "$project_dir" "false"
            ;;
        list)
            list_deployments "$project_dir"
            ;;
        domains)
            list_domains "$project_name"
            ;;
        env)
            list_env_vars "$project_dir"
            ;;
        pull-env)
            local environment="${3:-development}"
            pull_env_vars "$project_dir" "$environment"
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
