#!/bin/bash

################################################################################
# Environment Manager
# Manage .env files across projects with templates and validation
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TEMPLATES_DIR="$HOME/Developer/.env-templates"
PROJECTS_DIR="$HOME/Developer/projects"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🔐 Environment Manager${NC}"
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
# Template Management
################################################################################

init_templates() {
    print_info "Initializing environment templates..."
    
    mkdir -p "$TEMPLATES_DIR"
    
    # Next.js template
    cat > "$TEMPLATES_DIR/nextjs.env" << 'EOF'
# Next.js Environment Template

# Application
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Authentication
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=generate-with-openssl-rand-base64-32

# API Keys
NEXT_PUBLIC_API_KEY=
API_SECRET=

# Optional: Analytics
NEXT_PUBLIC_GA_ID=
NEXT_PUBLIC_SENTRY_DSN=
EOF

    # React/Vite template
    cat > "$TEMPLATES_DIR/react-vite.env" << 'EOF'
# React/Vite Environment Template

# Application
VITE_APP_URL=http://localhost:3000
VITE_ENV=development

# API
VITE_API_URL=http://localhost:3000/api
VITE_API_KEY=

# Optional: Services
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
EOF

    # Node API template
    cat > "$TEMPLATES_DIR/node-api.env" << 'EOF'
# Node.js API Environment Template

# Application
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Authentication
JWT_SECRET=generate-with-openssl-rand-base64-32
JWT_EXPIRES_IN=24h

# CORS
CORS_ORIGIN=http://localhost:3000

# Optional: Services
REDIS_URL=redis://localhost:6379
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=
EOF

    # Python/FastAPI template
    cat > "$TEMPLATES_DIR/python-api.env" << 'EOF'
# Python API Environment Template

# Application
ENVIRONMENT=development
DEBUG=True
HOST=0.0.0.0
PORT=8000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Security
SECRET_KEY=generate-with-python-secrets-token-hex-32
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8000

# Optional: Services
REDIS_URL=redis://localhost:6379
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1
EOF

    # Hostinger deployment template
    cat > "$TEMPLATES_DIR/hostinger.env" << 'EOF'
# Hostinger Deployment Environment Template

# SFTP Credentials
HOSTINGER_HOST=ftp.yourdomain.com
HOSTINGER_USER=u123456789
HOSTINGER_PASSWORD=your_password_here

# Deployment
REMOTE_DIR=public_html
LOCAL_BUILD_DIR=dist
PROJECT_TYPE=react
CREATE_BACKUP=yes
EOF

    print_success "Templates initialized at: $TEMPLATES_DIR"
}

list_templates() {
    print_info "Available templates:\n"
    
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        print_warning "No templates found. Run with --init to create templates."
        return
    fi
    
    local index=1
    for template in "$TEMPLATES_DIR"/*.env; do
        if [[ -f "$template" ]]; then
            local name=$(basename "$template" .env)
            local vars=$(grep -c "^[A-Z]" "$template" 2>/dev/null || echo 0)
            printf "${BLUE}%2d)${NC} %-20s ${CYAN}(%d variables)${NC}\n" "$index" "$name" "$vars"
            ((index++))
        fi
    done
    echo ""
}

################################################################################
# Project Detection
################################################################################

detect_project_type() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/next.config.js" ]] || [[ -f "$project_dir/next.config.ts" ]]; then
        echo "nextjs"
    elif [[ -f "$project_dir/vite.config.ts" ]] && grep -q "react" "$project_dir/package.json" 2>/dev/null; then
        echo "react-vite"
    elif [[ -f "$project_dir/package.json" ]] && (grep -q "express" "$project_dir/package.json" 2>/dev/null || grep -q "fastify" "$project_dir/package.json" 2>/dev/null); then
        echo "node-api"
    elif [[ -f "$project_dir/pyproject.toml" ]] && (grep -q "fastapi" "$project_dir/pyproject.toml" 2>/dev/null || grep -q "flask" "$project_dir/pyproject.toml" 2>/dev/null); then
        echo "python-api"
    else
        echo "unknown"
    fi
}

################################################################################
# Environment File Operations
################################################################################

create_env_from_template() {
    local project_dir="$1"
    local template_name="$2"
    local template_path="$TEMPLATES_DIR/$template_name.env"
    
    if [[ ! -f "$template_path" ]]; then
        print_error "Template not found: $template_name"
        return 1
    fi
    
    local env_file="$project_dir/.env"
    local example_file="$project_dir/.env.example"
    
    # Create .env if it doesn't exist
    if [[ -f "$env_file" ]]; then
        print_warning ".env already exists in $project_dir"
        read -p "Overwrite? (y/n): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Skipped"
            return 0
        fi
    fi
    
    # Copy template to .env
    cp "$template_path" "$env_file"
    print_success "Created .env from $template_name template"
    
    # Create .env.example (without sensitive values)
    sed 's/=.*/=/' "$template_path" > "$example_file"
    print_success "Created .env.example"
    
    # Ensure .env is in .gitignore
    if [[ -f "$project_dir/.gitignore" ]]; then
        if ! grep -q "^\.env$" "$project_dir/.gitignore"; then
            echo ".env" >> "$project_dir/.gitignore"
            print_success "Added .env to .gitignore"
        fi
    fi
    
    print_info "Edit $env_file with your values"
}

validate_env_file() {
    local env_file="$1"
    
    if [[ ! -f "$env_file" ]]; then
        print_error "File not found: $env_file"
        return 1
    fi
    
    print_info "Validating $env_file...\n"
    
    local warnings=0
    local line_num=0
    
    while IFS= read -r line; do
        ((line_num++))
        
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        
        # Check format
        if [[ ! "$line" =~ ^[A-Z_][A-Z0-9_]*=.*$ ]]; then
            print_warning "Line $line_num: Invalid format: $line"
            ((warnings++))
            continue
        fi
        
        # Extract key and value
        local key="${line%%=*}"
        local value="${line#*=}"
        
        # Check for empty values
        if [[ -z "$value" ]]; then
            print_warning "Line $line_num: Empty value for $key"
            ((warnings++))
        fi
        
        # Check for placeholder values
        if [[ "$value" == *"your-"* || "$value" == *"change-"* || "$value" == *"generate-"* ]]; then
            print_warning "Line $line_num: Placeholder value for $key"
            ((warnings++))
        fi
        
        # Check for common issues
        case $key in
            *SECRET*|*PASSWORD*|*KEY*)
                if [[ ${#value} -lt 16 ]]; then
                    print_warning "Line $line_num: $key is too short (< 16 chars)"
                    ((warnings++))
                fi
                ;;
            *URL*)
                if [[ ! "$value" =~ ^https?:// ]] && [[ ! "$value" =~ ^postgres:// ]] && [[ ! "$value" =~ ^mongodb:// ]] && [[ ! "$value" =~ ^redis:// ]]; then
                    print_warning "Line $line_num: $key doesn't look like a valid URL"
                    ((warnings++))
                fi
                ;;
            PORT)
                if [[ ! "$value" =~ ^[0-9]+$ ]] || [[ $value -lt 1 || $value -gt 65535 ]]; then
                    print_warning "Line $line_num: Invalid port number: $value"
                    ((warnings++))
                fi
                ;;
        esac
    done < "$env_file"
    
    echo ""
    if [[ $warnings -eq 0 ]]; then
        print_success "No issues found"
    else
        print_warning "Found $warnings warnings"
    fi
    
    return 0
}

compare_env_files() {
    local file1="$1"
    local file2="$2"
    
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        print_error "One or both files not found"
        return 1
    fi
    
    print_info "Comparing files:\n"
    echo "  File 1: $file1"
    echo "  File 2: $file2"
    echo ""
    
    # Extract keys from both files
    local keys1=$(grep -v "^#" "$file1" | grep "=" | cut -d'=' -f1 | sort)
    local keys2=$(grep -v "^#" "$file2" | grep "=" | cut -d'=' -f1 | sort)
    
    # Keys in file1 but not in file2
    local missing_in_2=$(comm -23 <(echo "$keys1") <(echo "$keys2"))
    if [[ -n "$missing_in_2" ]]; then
        echo -e "${YELLOW}Missing in file 2:${NC}"
        echo "$missing_in_2" | while read -r key; do
            echo "  - $key"
        done
        echo ""
    fi
    
    # Keys in file2 but not in file1
    local missing_in_1=$(comm -13 <(echo "$keys1") <(echo "$keys2"))
    if [[ -n "$missing_in_1" ]]; then
        echo -e "${YELLOW}Missing in file 1:${NC}"
        echo "$missing_in_1" | while read -r key; do
            echo "  - $key"
        done
        echo ""
    fi
    
    # Common keys
    local common=$(comm -12 <(echo "$keys1") <(echo "$keys2"))
    if [[ -n "$common" ]]; then
        echo -e "${GREEN}Common keys: $(echo "$common" | wc -l | tr -d ' ')${NC}"
    fi
}

sync_env_keys() {
    local source_file="$1"
    local target_file="$2"
    
    if [[ ! -f "$source_file" ]]; then
        print_error "Source file not found: $source_file"
        return 1
    fi
    
    if [[ ! -f "$target_file" ]]; then
        print_error "Target file not found: $target_file"
        return 1
    fi
    
    print_info "Syncing keys from $source_file to $target_file..."
    
    # Backup target file
    cp "$target_file" "$target_file.backup"
    print_info "Backup created: $target_file.backup"
    
    # Extract keys from source that are missing in target
    while IFS= read -r line; do
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        
        local key="${line%%=*}"
        
        if ! grep -q "^$key=" "$target_file"; then
            echo "$line" >> "$target_file"
            print_success "Added: $key"
        fi
    done < "$source_file"
    
    print_success "Sync complete"
}

################################################################################
# Bulk Operations
################################################################################

scan_all_projects() {
    print_info "Scanning all projects for environment files...\n"
    
    local total=0
    local with_env=0
    local without_env=0
    
    while IFS= read -r project_dir; do
        [[ ! -d "$project_dir" ]] && continue
        
        local project_name=$(basename "$project_dir")
        ((total++))
        
        if [[ -f "$project_dir/.env" ]]; then
            ((with_env++))
            local vars=$(grep -c "^[A-Z]" "$project_dir/.env" 2>/dev/null || echo 0)
            printf "${GREEN}✓${NC} %-30s ${CYAN}(%d vars)${NC}\n" "$project_name" "$vars"
        else
            ((without_env++))
            printf "${YELLOW}○${NC} %-30s ${RED}(no .env)${NC}\n" "$project_name"
        fi
    done < <(find "$PROJECTS_DIR" -maxdepth 2 -type f -name "package.json" -o -name "pyproject.toml" | xargs -I {} dirname {} | sort -u)
    
    echo ""
    print_info "Summary: $total projects ($with_env with .env, $without_env without)"
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --init                     Initialize environment templates"
    echo "  --list-templates           List available templates"
    echo "  --create PROJECT TEMPLATE  Create .env from template"
    echo "  --validate FILE            Validate environment file"
    echo "  --compare FILE1 FILE2      Compare two environment files"
    echo "  --sync SOURCE TARGET       Sync keys from source to target"
    echo "  --scan                     Scan all projects for .env files"
    echo "  -h, --help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --init"
    echo "  $0 --list-templates"
    echo "  $0 --create ~/Developer/projects/my-app nextjs"
    echo "  $0 --validate ~/Developer/projects/my-app/.env"
    echo "  $0 --scan"
}

main() {
    case "${1:-}" in
        --init)
            print_header
            init_templates
            ;;
        --list-templates)
            print_header
            list_templates
            ;;
        --create)
            if [[ -z "$2" || -z "$3" ]]; then
                print_error "Usage: $0 --create PROJECT_DIR TEMPLATE_NAME"
                exit 1
            fi
            print_header
            create_env_from_template "$2" "$3"
            ;;
        --validate)
            if [[ -z "$2" ]]; then
                print_error "Usage: $0 --validate ENV_FILE"
                exit 1
            fi
            print_header
            validate_env_file "$2"
            ;;
        --compare)
            if [[ -z "$2" || -z "$3" ]]; then
                print_error "Usage: $0 --compare FILE1 FILE2"
                exit 1
            fi
            print_header
            compare_env_files "$2" "$3"
            ;;
        --sync)
            if [[ -z "$2" || -z "$3" ]]; then
                print_error "Usage: $0 --sync SOURCE_FILE TARGET_FILE"
                exit 1
            fi
            print_header
            sync_env_keys "$2" "$3"
            ;;
        --scan)
            print_header
            scan_all_projects
            ;;
        -h|--help|*)
            show_usage
            exit 0
            ;;
    esac
}

main "$@"
