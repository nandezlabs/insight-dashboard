#!/bin/bash
set -euo pipefail

################################################################################
# Hostinger Deployment Script
# Deploys web projects to Hostinger hosting via SFTP
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🚀 Hostinger Deployment${NC}"
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

check_requirements() {
    print_info "Checking requirements..."

    # Check for lftp (best SFTP client for scripting)
    if ! command -v lftp &> /dev/null; then
        print_error "lftp not found. Installing..."
        if command -v brew &> /dev/null; then
            brew install lftp
        else
            print_error "Please install lftp: brew install lftp"
            exit 1
        fi
    fi

    print_success "lftp $(lftp --version | head -1 | awk '{print $4}')"
}

################################################################################
# Configuration Loading
################################################################################

load_config() {
    local config_file=".hostinger-config"

    if [[ ! -f "${config_file}" ]]; then
        print_error "No .hostinger-config file found!"
        print_info "Creating template configuration..."
        create_config_template
        print_error "Please edit .hostinger-config with your Hostinger credentials"
        exit 1
    fi

    # Source the config file
    # shellcheck disable=SC1090
    source "${config_file}"

    # Validate required variables
    if [[ -z "${HOSTINGER_HOST:-}" ]] || [[ -z "${HOSTINGER_USER:-}" ]] || [[ -z "${HOSTINGER_PASSWORD:-}" ]]; then
        print_error "Missing required configuration in .hostinger-config"
        print_error "Required: HOSTINGER_HOST, HOSTINGER_USER, HOSTINGER_PASSWORD"
        exit 1
    fi

    print_success "Configuration loaded"
}

create_config_template() {
    cat > .hostinger-config << 'EOF'
# Hostinger SFTP Configuration
# Get these from: Hostinger Panel > Hosting > Manage > FTP Accounts

# SFTP Hostname (usually ftp.yourdomain.com or IP address)
HOSTINGER_HOST="ftp.yourdomain.com"

# FTP Username (usually u123456789 format)
HOSTINGER_USER="u123456789"

# FTP Password
HOSTINGER_PASSWORD="your_password_here"

# Remote directory (usually public_html or specific subdomain folder)
# For main domain: public_html
# For subdomain: public_html/subdomain
REMOTE_DIR="public_html"

# Local build directory (where your built files are)
LOCAL_BUILD_DIR="dist"

# Project type: static, react, nextjs, php
PROJECT_TYPE="static"

# Files to exclude (space-separated)
EXCLUDE_FILES=".git node_modules .env .DS_Store"

# Backup before deploy (yes/no)
CREATE_BACKUP="yes"
EOF

    print_success ".hostinger-config template created"
}

################################################################################
# Project Detection & Building
################################################################################

detect_project_type() {
    if [[ -f "package.json" ]]; then
        if grep -q "\"next\"" package.json; then
            echo "nextjs"
        elif grep -q "\"react\"" package.json || grep -q "\"vite\"" package.json; then
            echo "react"
        else
            echo "static"
        fi
    elif [[ -f "composer.json" ]]; then
        echo "php"
    else
        echo "static"
    fi
}

build_project() {
    local project_type="${PROJECT_TYPE:-$(detect_project_type)}"

    print_info "Building project (type: $project_type)..."

    case $project_type in
        nextjs)
            if [[ -f "package.json" ]]; then
                print_info "Building Next.js project..."
                npm run build
                # Next.js static export
                if grep -q "\"output\": \"export\"" next.config.js 2>/dev/null; then
                    LOCAL_BUILD_DIR="out"
                else
                    print_error "Next.js project must use static export for Hostinger"
                    print_info "Add 'output: \"export\"' to next.config.js"
                    exit 1
                fi
            fi
            ;;
        react)
            if [[ -f "package.json" ]]; then
                print_info "Building React project..."
                npm run build
                # Auto-detect build directory
                if [[ -d "dist" ]]; then
                    LOCAL_BUILD_DIR="dist"
                elif [[ -d "build" ]]; then
                    LOCAL_BUILD_DIR="build"
                fi
            fi
            ;;
        php)
            print_info "PHP project - no build step required"
            LOCAL_BUILD_DIR="."
            ;;
        static)
            print_info "Static site - no build step required"
            LOCAL_BUILD_DIR="${LOCAL_BUILD_DIR:-.}"
            ;;
    esac

    # Verify build directory exists
    if [[ ! -d "$LOCAL_BUILD_DIR" ]]; then
        print_error "Build directory not found: $LOCAL_BUILD_DIR"
        exit 1
    fi

    print_success "Project built successfully"
}

################################################################################
# Backup
################################################################################

create_backup() {
    if [[ "$CREATE_BACKUP" != "yes" ]]; then
        return 0
    fi

    print_info "Creating backup of remote files..."

    local backup_dir="backups/hostinger-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    lftp -u "$HOSTINGER_USER,$HOSTINGER_PASSWORD" "sftp://$HOSTINGER_HOST" << EOF
set sftp:auto-confirm yes
set ssl:verify-certificate no
mirror --verbose "$REMOTE_DIR" "$backup_dir"
quit
EOF

    if [[ $? -eq 0 ]]; then
        print_success "Backup created: $backup_dir"
    else
        print_error "Backup failed, but continuing..."
    fi
}

################################################################################
# Deployment
################################################################################

deploy_via_sftp() {
    print_info "Deploying to Hostinger via SFTP..."

    # Build exclude pattern for lftp
    local exclude_pattern=""
    for pattern in $EXCLUDE_FILES; do
        exclude_pattern="$exclude_pattern --exclude $pattern"
    done

    print_info "Uploading from: $LOCAL_BUILD_DIR"
    print_info "Remote directory: $REMOTE_DIR"

    # Use lftp for reliable SFTP upload with mirror
    lftp -u "$HOSTINGER_USER,$HOSTINGER_PASSWORD" "sftp://$HOSTINGER_HOST" << EOF
set sftp:auto-confirm yes
set ssl:verify-certificate no
set mirror:use-pget-n 5
cd "$REMOTE_DIR"
mirror --reverse --delete --verbose $exclude_pattern "$LOCAL_BUILD_DIR" .
quit
EOF

    if [[ $? -eq 0 ]]; then
        print_success "Deployment completed successfully!"
    else
        print_error "Deployment failed!"
        exit 1
    fi
}

################################################################################
# Post-Deployment
################################################################################

set_permissions() {
    print_info "Setting file permissions..."

    # Set proper permissions for PHP/web files
    lftp -u "$HOSTINGER_USER,$HOSTINGER_PASSWORD" "sftp://$HOSTINGER_HOST" << 'EOF'
set sftp:auto-confirm yes
set ssl:verify-certificate no
cd "$REMOTE_DIR"
# Directories: 755
find . -type d -exec chmod 755 {} \;
# Files: 644
find . -type f -exec chmod 644 {} \;
quit
EOF

    print_success "Permissions set"
}

verify_deployment() {
    print_info "Verifying deployment..."

    # Check if index.html or index.php exists
    lftp -u "$HOSTINGER_USER,$HOSTINGER_PASSWORD" "sftp://$HOSTINGER_HOST" << EOF > /tmp/hostinger_verify.txt
set sftp:auto-confirm yes
set ssl:verify-certificate no
cd "$REMOTE_DIR"
ls -la
quit
EOF

    if grep -q "index\." /tmp/hostinger_verify.txt; then
        print_success "Deployment verified - index file found"
    else
        print_error "Warning: No index file found in $REMOTE_DIR"
    fi

    rm -f /tmp/hostinger_verify.txt
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --init          Create .hostinger-config template"
    echo "  --build         Build project before deployment"
    echo "  --no-backup     Skip backup step"
    echo "  --dry-run       Show what would be deployed without uploading"
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --init                  # Create configuration file"
    echo "  $0                         # Deploy with current build"
    echo "  $0 --build                 # Build and deploy"
    echo "  $0 --no-backup             # Deploy without backup"
}

main() {
    local do_build=false
    local do_backup=true
    local dry_run=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --init)
                print_header
                create_config_template
                exit 0
                ;;
            --build)
                do_build=true
                shift
                ;;
            --no-backup)
                do_backup=false
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    print_header
    check_requirements
    load_config

    # Build if requested
    if [[ "$do_build" == true ]]; then
        build_project
    fi

    # Verify build directory exists
    if [[ ! -d "$LOCAL_BUILD_DIR" ]]; then
        print_error "Build directory not found: $LOCAL_BUILD_DIR"
        print_info "Run with --build to build the project first"
        exit 1
    fi

    # Show deployment info
    echo -e "\n${BLUE}Deployment Configuration:${NC}\n"
    echo "  Project Type: ${PROJECT_TYPE:-auto-detect}"
    echo "  Local Dir:    $LOCAL_BUILD_DIR"
    echo "  Remote Host:  $HOSTINGER_HOST"
    echo "  Remote Dir:   $REMOTE_DIR"
    echo "  User:         $HOSTINGER_USER"
    echo "  Backup:       $([ "$do_backup" == true ] && echo "yes" || echo "no")"
    echo ""

    if [[ "$dry_run" == true ]]; then
        print_info "DRY RUN - showing files that would be uploaded..."
        find "$LOCAL_BUILD_DIR" -type f | head -20
        echo "..."
        print_info "Total files: $(find "$LOCAL_BUILD_DIR" -type f | wc -l)"
        exit 0
    fi

    # Confirm deployment
    read -p "Deploy to Hostinger? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_error "Deployment cancelled"
        exit 0
    fi

    # Execute deployment
    if [[ "$do_backup" == true ]]; then
        create_backup
    fi

    deploy_via_sftp
    set_permissions
    verify_deployment

    # Success message
    echo -e "\n${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✓ Deployment Complete!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}\n"

    print_success "Files deployed to $REMOTE_DIR"
    print_info "Your site should be live at your domain"

    if [[ "$do_backup" == true ]]; then
        print_info "Backup saved in: backups/"
    fi

    echo -e "\n${BLUE}Next Steps:${NC}"
    echo "  • Visit your domain to verify deployment"
    echo "  • Check browser console for any errors"
    echo "  • Clear CDN cache if using Cloudflare"

    if [[ "$PROJECT_TYPE" == "nextjs" || "$PROJECT_TYPE" == "react" ]]; then
        echo -e "\n${YELLOW}Note:${NC} For Next.js/React apps, ensure your build completed successfully"
    fi

    echo ""
}

main "$@"
