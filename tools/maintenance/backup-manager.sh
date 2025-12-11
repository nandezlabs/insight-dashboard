#!/bin/bash

################################################################################
# Backup Manager
# Automated project backups with rotation and compression
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
BACKUP_ROOT="$HOME/Developer/backups"
PROJECTS_DIR="$HOME/Developer/projects"
GAMES_DIR="$HOME/Developer/games"
TOOLS_DIR="$HOME/Developer/tools"
MAX_BACKUPS=10
COMPRESSION="gzip"  # gzip or zip

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  💾 Backup Manager${NC}"
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
# Backup Configuration
################################################################################

init_backup_dirs() {
    mkdir -p "$BACKUP_ROOT"/{projects,games,tools,databases,configs}
    print_success "Backup directories initialized"
}

get_backup_size() {
    local path="$1"
    du -sh "$path" 2>/dev/null | awk '{print $1}' || echo "0B"
}

################################################################################
# Project Backup
################################################################################

backup_project() {
    local project_path="$1"
    local project_name=$(basename "$project_path")
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$BACKUP_ROOT/projects/$project_name"
    
    mkdir -p "$backup_dir"
    
    print_info "Backing up: $project_name"
    
    # Determine backup file name
    local backup_file="$backup_dir/${project_name}_${timestamp}.tar.gz"
    
    # Exclude patterns
    local excludes=(
        "node_modules"
        ".git"
        "dist"
        "build"
        ".next"
        "__pycache__"
        ".pytest_cache"
        "venv"
        ".venv"
        "target"
        ".DS_Store"
        "*.log"
    )
    
    # Build exclude arguments
    local exclude_args=()
    for pattern in "${excludes[@]}"; do
        exclude_args+=(--exclude="$pattern")
    done
    
    # Create backup
    if tar czf "$backup_file" "${exclude_args[@]}" -C "$(dirname "$project_path")" "$(basename "$project_path")" 2>/dev/null; then
        local size=$(get_backup_size "$backup_file")
        print_success "Backup created: $backup_file ($size)"
        
        # Clean old backups
        rotate_backups "$backup_dir"
    else
        print_error "Backup failed for $project_name"
        return 1
    fi
}

backup_all_projects() {
    print_info "Backing up all projects...\n"
    
    local total=0
    local success=0
    local failed=0
    
    # Backup projects
    if [[ -d "$PROJECTS_DIR" ]]; then
        while IFS= read -r project; do
            [[ ! -d "$project" ]] && continue
            ((total++))
            
            if backup_project "$project"; then
                ((success++))
            else
                ((failed++))
            fi
            echo ""
        done < <(find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d)
    fi
    
    # Backup games
    if [[ -d "$GAMES_DIR" ]]; then
        while IFS= read -r game; do
            [[ ! -d "$game" ]] && continue
            ((total++))
            
            if backup_project "$game"; then
                ((success++))
            else
                ((failed++))
            fi
            echo ""
        done < <(find "$GAMES_DIR" -maxdepth 1 -mindepth 1 -type d)
    fi
    
    print_info "Summary:"
    echo "  Total: $total"
    echo "  Success: $success"
    echo "  Failed: $failed"
}

################################################################################
# Tools Backup
################################################################################

backup_tools() {
    print_info "Backing up tools directory..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_ROOT/tools/tools_${timestamp}.tar.gz"
    
    mkdir -p "$BACKUP_ROOT/tools"
    
    if tar czf "$backup_file" -C "$(dirname "$TOOLS_DIR")" "$(basename "$TOOLS_DIR")" 2>/dev/null; then
        local size=$(get_backup_size "$backup_file")
        print_success "Tools backup created: $backup_file ($size)"
        
        # Clean old backups
        rotate_backups "$BACKUP_ROOT/tools"
    else
        print_error "Tools backup failed"
        return 1
    fi
}

################################################################################
# Configuration Backup
################################################################################

backup_configs() {
    print_info "Backing up configuration files..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$BACKUP_ROOT/configs"
    local backup_file="$backup_dir/configs_${timestamp}.tar.gz"
    
    mkdir -p "$backup_dir"
    
    # Important config files to backup
    local configs=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.gitconfig"
        "$HOME/.ssh/config"
        "$HOME/.aws"
        "$HOME/.docker/config.json"
        "$HOME/.kube/config"
    )
    
    # Build list of existing configs
    local existing_configs=()
    for config in "${configs[@]}"; do
        if [[ -e "$config" ]]; then
            existing_configs+=("$config")
        fi
    done
    
    if [[ ${#existing_configs[@]} -gt 0 ]]; then
        if tar czf "$backup_file" "${existing_configs[@]}" 2>/dev/null; then
            local size=$(get_backup_size "$backup_file")
            print_success "Config backup created: $backup_file ($size)"
            
            rotate_backups "$backup_dir"
        else
            print_error "Config backup failed"
            return 1
        fi
    else
        print_warning "No config files found to backup"
    fi
}

################################################################################
# Backup Rotation
################################################################################

rotate_backups() {
    local backup_dir="$1"
    
    # Count backups
    local count=$(find "$backup_dir" -maxdepth 1 -type f -name "*.tar.gz" | wc -l | tr -d ' ')
    
    if [[ $count -gt $MAX_BACKUPS ]]; then
        local to_delete=$((count - MAX_BACKUPS))
        print_info "Rotating backups: removing $to_delete old backup(s)"
        
        # Delete oldest backups
        find "$backup_dir" -maxdepth 1 -type f -name "*.tar.gz" -printf '%T+ %p\n' | \
            sort | \
            head -n "$to_delete" | \
            cut -d' ' -f2- | \
            while read -r file; do
                rm "$file"
                print_info "  Removed: $(basename "$file")"
            done
    fi
}

################################################################################
# Restore Functions
################################################################################

list_backups() {
    local project_name="$1"
    
    if [[ -n "$project_name" ]]; then
        local backup_dir="$BACKUP_ROOT/projects/$project_name"
        
        if [[ ! -d "$backup_dir" ]]; then
            print_warning "No backups found for: $project_name"
            return 1
        fi
        
        print_info "Backups for $project_name:\n"
        
        find "$backup_dir" -type f -name "*.tar.gz" -printf '%T@ %p\n' | \
            sort -rn | \
            while read -r timestamp path; do
                local date=$(date -r "${timestamp%.*}" '+%Y-%m-%d %H:%M:%S')
                local size=$(get_backup_size "$path")
                local filename=$(basename "$path")
                echo "  $date - $filename ($size)"
            done
    else
        print_info "All backups:\n"
        
        for category in projects games tools configs databases; do
            local category_dir="$BACKUP_ROOT/$category"
            
            if [[ -d "$category_dir" ]]; then
                local count=$(find "$category_dir" -type f -name "*.tar.gz" 2>/dev/null | wc -l | tr -d ' ')
                if [[ $count -gt 0 ]]; then
                    local total_size=$(get_backup_size "$category_dir")
                    echo "  $category: $count backup(s) ($total_size)"
                fi
            fi
        done
    fi
}

restore_backup() {
    local backup_file="$1"
    local restore_path="${2:-.}"
    
    if [[ ! -f "$backup_file" ]]; then
        print_error "Backup file not found: $backup_file"
        return 1
    fi
    
    print_warning "This will restore: $(basename "$backup_file")"
    print_warning "To: $restore_path"
    read -p "Continue? (y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        return 0
    fi
    
    print_info "Restoring backup..."
    
    if tar xzf "$backup_file" -C "$restore_path"; then
        print_success "Backup restored to: $restore_path"
    else
        print_error "Restore failed"
        return 1
    fi
}

################################################################################
# Automated Backup
################################################################################

schedule_backup() {
    local schedule="$1"  # daily, weekly, monthly
    
    print_info "Setting up automated backups..."
    
    local cron_command="$0 backup-all"
    local cron_schedule=""
    
    case $schedule in
        daily)
            cron_schedule="0 2 * * *"  # 2 AM daily
            ;;
        weekly)
            cron_schedule="0 2 * * 0"  # 2 AM Sunday
            ;;
        monthly)
            cron_schedule="0 2 1 * *"  # 2 AM 1st of month
            ;;
        *)
            print_error "Invalid schedule: $schedule"
            print_info "Use: daily, weekly, or monthly"
            return 1
            ;;
    esac
    
    print_info "Schedule: $schedule ($cron_schedule)"
    print_info "Command: $cron_command"
    echo ""
    print_info "To add to crontab, run:"
    echo "  (crontab -l 2>/dev/null; echo \"$cron_schedule $cron_command\") | crontab -"
}

################################################################################
# Backup Statistics
################################################################################

show_stats() {
    print_info "Backup Statistics:\n"
    
    local total_backups=0
    local total_size=0
    
    for category in projects games tools configs databases; do
        local category_dir="$BACKUP_ROOT/$category"
        
        if [[ -d "$category_dir" ]]; then
            local count=$(find "$category_dir" -type f -name "*.tar.gz" 2>/dev/null | wc -l | tr -d ' ')
            
            if [[ $count -gt 0 ]]; then
                local size=$(get_backup_size "$category_dir")
                echo "  $category:"
                echo "    Backups: $count"
                echo "    Size: $size"
                echo ""
                
                ((total_backups += count))
            fi
        fi
    done
    
    local total_size=$(get_backup_size "$BACKUP_ROOT")
    
    echo "  Total:"
    echo "    Backups: $total_backups"
    echo "    Size: $total_size"
    echo "    Location: $BACKUP_ROOT"
}

################################################################################
# Cleanup
################################################################################

cleanup_old_backups() {
    local days="${1:-30}"
    
    print_warning "This will delete backups older than $days days"
    read -p "Continue? (y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        return 0
    fi
    
    print_info "Cleaning up old backups..."
    
    local count=0
    while IFS= read -r file; do
        rm "$file"
        ((count++))
        print_info "  Removed: $file"
    done < <(find "$BACKUP_ROOT" -type f -name "*.tar.gz" -mtime +"$days")
    
    if [[ $count -gt 0 ]]; then
        print_success "Removed $count old backup(s)"
    else
        print_info "No old backups to remove"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    echo -e "${CYAN}Backup Options:${NC}"
    echo "  1) Backup single project"
    echo "  2) Backup all projects"
    echo "  3) Backup tools directory"
    echo "  4) Backup configuration files"
    echo "  5) List backups"
    echo "  6) Restore backup"
    echo "  7) Show statistics"
    echo "  8) Clean old backups"
    echo "  9) Schedule automated backups"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            read -p "Project path: " project_path
            backup_project "$project_path"
            ;;
        2)
            backup_all_projects
            ;;
        3)
            backup_tools
            ;;
        4)
            backup_configs
            ;;
        5)
            read -p "Project name (or leave empty for all): " project_name
            list_backups "$project_name"
            ;;
        6)
            read -p "Backup file path: " backup_file
            read -p "Restore to (default: current dir): " restore_path
            restore_backup "$backup_file" "${restore_path:-.}"
            ;;
        7)
            show_stats
            ;;
        8)
            read -p "Delete backups older than days (default: 30): " days
            cleanup_old_backups "${days:-30}"
            ;;
        9)
            read -p "Schedule (daily/weekly/monthly): " schedule
            schedule_backup "$schedule"
            ;;
        q|Q)
            print_info "Exiting"
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
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  backup PROJECT_PATH      Backup single project"
    echo "  backup-all               Backup all projects"
    echo "  backup-tools             Backup tools directory"
    echo "  backup-configs           Backup configuration files"
    echo "  list [PROJECT]           List backups"
    echo "  restore FILE [PATH]      Restore backup"
    echo "  stats                    Show backup statistics"
    echo "  cleanup [DAYS]           Remove old backups"
    echo "  schedule FREQUENCY       Setup automated backups"
    echo "  interactive              Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 backup ~/Developer/projects/my-app"
    echo "  $0 backup-all"
    echo "  $0 list my-app"
    echo "  $0 cleanup 30"
    echo "  $0 schedule daily"
}

main() {
    local command="${1:-interactive}"
    
    print_header
    
    init_backup_dirs
    
    echo ""
    
    case $command in
        backup)
            if [[ -z "$2" ]]; then
                print_error "Project path required"
                show_usage
                exit 1
            fi
            backup_project "$2"
            ;;
        backup-all)
            backup_all_projects
            ;;
        backup-tools)
            backup_tools
            ;;
        backup-configs)
            backup_configs
            ;;
        list)
            list_backups "$2"
            ;;
        restore)
            if [[ -z "$2" ]]; then
                print_error "Backup file required"
                show_usage
                exit 1
            fi
            restore_backup "$2" "$3"
            ;;
        stats)
            show_stats
            ;;
        cleanup)
            cleanup_old_backups "${2:-30}"
            ;;
        schedule)
            if [[ -z "$2" ]]; then
                print_error "Schedule frequency required"
                show_usage
                exit 1
            fi
            schedule_backup "$2"
            ;;
        interactive)
            interactive_mode
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
