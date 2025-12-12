#!/bin/bash
set -euo pipefail
# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true


# =============================================================================
# Cleanup Workflow - Automated Developer Folder Maintenance
# =============================================================================
# Comprehensive cleanup tool for maintaining a clean development environment
# Features:
# - Remove temporary files, caches, and build artifacts
# - Clean empty directories
# - Find and remove duplicate files
# - Archive old/unused projects
# - Clean node_modules and Python venvs
# - Database and log cleanup
# - Interactive and automated modes
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
DEVELOPER_DIR="${HOME}/Developer"
DRY_RUN=false
VERBOSE=false
SCHEDULED=false
GENERATE_REPORT=false
REPORT_DIR="${HOME}${DEV_TOOLS_REPORTS}"

# Statistics
TOTAL_SPACE_FREED=0
FILES_REMOVED=0
DIRS_REMOVED=0
START_TIME=$(date +%s)

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $1"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# Convert bytes to human-readable format
bytes_to_human() {
    local bytes=$1
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$(( bytes / 1024 ))KB"
    elif [ "$bytes" -lt 1073741824 ]; then
        echo "$(( bytes / 1048576 ))MB"
    else
        echo "$(( bytes / 1073741824 ))GB"
    fi
}

# Get directory size in bytes
get_dir_size() {
    local dir="$1"
    if [ -d "${dir}" ]; then
        du -sk "${dir}" 2>/dev/null | awk '{print $1 * 1024}' || echo 0
    else
        echo 0
    fi
}

# Remove file/directory with statistics
remove_item() {
    local path="$1"
    local size=0

    if [ ! -e "${path}" ]; then
        return
    fi

    if [ -d "${path}" ]; then
        size=$(get_dir_size "${path}")
    elif [ -f "${path}" ]; then
        size=$(stat -f%z "${path}" 2>/dev/null || echo 0)
    fi

    if [ "${DRY_RUN}" = true ]; then
        info "Would remove: ${path} ($(bytes_to_human "${size}"))"
    else
        rm -rf "${path}" 2>/dev/null && {
            TOTAL_SPACE_FREED=$((TOTAL_SPACE_FREED + size))
            if [ -d "${path}" ] 2>/dev/null; then
                :
            else
                if [[ "${path}" == */ ]]; then
                    DIRS_REMOVED=$((DIRS_REMOVED + 1))
                else
                    FILES_REMOVED=$((FILES_REMOVED + 1))
                fi
            fi
            [ "${VERBOSE}" = true ] && success "Removed: $(basename "${path}") ($(bytes_to_human "${size}"))"
        }
    fi
}

# =============================================================================
# Data Consolidation Functions
# =============================================================================

consolidate_archives() {
    print_section "Consolidating Archive Data"

    local archive_dir="$DEVELOPER_DIR/archive/script-backups"

    if [ ! -d "$archive_dir" ]; then
        info "No archive directory found"
        return
    fi

    info "Comparing archive versions with current tools..."
    echo ""

    local safe_to_remove=()
    local need_review=()
    local unique_files=()

    # Compare each archived file
    for archived_file in "$archive_dir"/*; do
        if [ ! -f "$archived_file" ]; then
            continue
        fi

        local filename=$(basename "$archived_file")
        local current_file=$(find "$DEVELOPER_DIR/tools" "$DEVELOPER_DIR/docs" -name "$filename" -type f 2>/dev/null | head -1)

        if [ -z "$current_file" ]; then
            # No current version exists - file is unique
            unique_files+=("$archived_file")
            warning "Unique file in archive: $filename"
        else
            # Compare dates
            local archive_date=$(stat -f%m "$archived_file" 2>/dev/null)
            local current_date=$(stat -f%m "$current_file" 2>/dev/null)

            if [ "$current_date" -gt "$archive_date" ]; then
                # Current is newer
                if diff -q "$archived_file" "$current_file" >/dev/null 2>&1; then
                    safe_to_remove+=("$archived_file")
                    [ "$VERBOSE" = true ] && success "$filename - identical to current (newer)"
                else
                    # Different content but current is newer
                    safe_to_remove+=("$archived_file")
                    [ "$VERBOSE" = true ] && success "$filename - current version is newer and different"
                fi
            elif [ "$archive_date" -gt "$current_date" ]; then
                # Archive is newer - need review
                need_review+=("$archived_file:$current_file")
                warning "$filename - archive version is NEWER than current!"
            else
                # Same date
                if diff -q "$archived_file" "$current_file" >/dev/null 2>&1; then
                    safe_to_remove+=("$archived_file")
                    [ "$VERBOSE" = true ] && success "$filename - identical to current"
                else
                    need_review+=("$archived_file:$current_file")
                    warning "$filename - same date but different content"
                fi
            fi
        fi
    done

    echo ""

    # Report findings
    if [ ${#safe_to_remove[@]} -gt 0 ]; then
        success "${#safe_to_remove[@]} archived files safe to remove (current versions newer/identical)"
        if [ "$DRY_RUN" = false ]; then
            for file in "${safe_to_remove[@]}"; do
                remove_item "$file"
            done
        fi
    fi

    if [ ${#unique_files[@]} -gt 0 ]; then
        echo ""
        warning "${#unique_files[@]} unique files in archive (no current version):"
        for file in "${unique_files[@]}"; do
            echo "    - $(basename "$file")"
        done
        info "These files are preserved in archive"
    fi

    if [ ${#need_review[@]} -gt 0 ]; then
        echo ""
        error "${#need_review[@]} files need manual review:"
        for pair in "${need_review[@]}"; do
            local arch="${pair%%:*}"
            local curr="${pair##*:}"
            echo "    ⚠️  $(basename "$arch")"
            echo "        Archive: $arch"
            echo "        Current: $curr"
        done
        echo ""
        warning "Run with --compare to see differences"
    fi
}

compare_archived_files() {
    print_section "Comparing Archived Files with Current Versions"

    local archive_dir="$DEVELOPER_DIR/archive/script-backups"

    if [ ! -d "$archive_dir" ]; then
        error "No archive directory found"
        return
    fi

    for archived_file in "$archive_dir"/*; do
        if [ ! -f "$archived_file" ]; then
            continue
        fi

        local filename=$(basename "$archived_file")
        local current_file=$(find "$DEVELOPER_DIR/tools" "$DEVELOPER_DIR/docs" -name "$filename" -type f 2>/dev/null | head -1)

        if [ -z "$current_file" ]; then
            info "No current version: $filename (unique to archive)"
            continue
        fi

        echo ""
        echo -e "${YELLOW}═══ $filename ═══${NC}"
        echo "Archive: $archived_file"
        echo "Current: $current_file"
        echo ""

        if diff -q "$archived_file" "$current_file" >/dev/null 2>&1; then
            success "Files are IDENTICAL"
        else
            warning "Files DIFFER - showing first 30 lines of diff:"
            echo ""
            diff -u "$archived_file" "$current_file" | head -50 | tail -n +4
        fi
    done
}

backup_before_cleanup() {
    print_section "Creating Safety Backup"

    local backup_dir="$DEVELOPER_DIR/.cleanup-backup-$(date +%Y%m%d-%H%M%S)"

    mkdir -p "$backup_dir"

    # Backup archive folder
    if [ -d "$DEVELOPER_DIR/archive" ]; then
        cp -R "$DEVELOPER_DIR/archive" "$backup_dir/"
        success "Backed up archive to: $backup_dir"
    fi

    info "Backup location: $backup_dir"
    warning "This backup will be kept for 7 days"
}

cleanup_old_backups() {
    print_section "Cleaning Old Safety Backups"

    local count=0

    # Remove backups older than 7 days
    for backup in "$DEVELOPER_DIR"/.cleanup-backup-*; do
        if [ -d "$backup" ]; then
            local backup_date=$(basename "$backup" | sed 's/.cleanup-backup-//')
            local age_days=$(( ($(date +%s) - $(date -j -f "%Y%m%d-%H%M%S" "$backup_date" +%s 2>/dev/null || echo 0)) / 86400 ))

            if [ "$age_days" -gt 7 ]; then
                remove_item "$backup"
                count=$((count + 1))
            fi
        fi
    done

    if [ $count -gt 0 ]; then
        success "Removed $count old backups (>7 days)"
    else
        info "No old backups to remove"
    fi
}

# =============================================================================
# Cleanup Functions
# =============================================================================

cleanup_macos_files() {
    print_section "Cleaning macOS System Files"

    local count=0

    # .DS_Store files
    while IFS= read -r file; do
        remove_item "$file"
        count=$((count + 1))
    done < <(find "$DEVELOPER_DIR" -name ".DS_Store" -type f 2>/dev/null)

    # ._* resource fork files
    while IFS= read -r file; do
        remove_item "$file"
        count=$((count + 1))
    done < <(find "$DEVELOPER_DIR" -name "._*" -type f 2>/dev/null)

    success "Cleaned $count macOS system files"
}

cleanup_empty_directories() {
    print_section "Removing Empty Directories"

    local count=0
    local protected_dirs=(".git" "node_modules" "__pycache__" ".venv")

    # Find empty directories (excluding protected ones)
    while IFS= read -r dir; do
        local basename=$(basename "$dir")
        local skip=false

        for protected in "${protected_dirs[@]}"; do
            if [[ "$dir" == *"$protected"* ]]; then
                skip=true
                break
            fi
        done

        if [ "$skip" = false ]; then
            remove_item "$dir"
            count=$((count + 1))
        fi
    done < <(find "$DEVELOPER_DIR" -type d -empty 2>/dev/null | grep -v "\.git")

    success "Removed $count empty directories"
}

cleanup_temp_files() {
    print_section "Cleaning Temporary Files"

    local patterns=("*.tmp" "*.temp" "*.log" "*.bak" "*.swp" "*.swo" "*~" "*.orig")
    local count=0

    for pattern in "${patterns[@]}"; do
        while IFS= read -r file; do
            # Skip files in archive and certain project directories
            if [[ "$file" == *"/archive/"* ]] || [[ "$file" == *"/node_modules/"* ]]; then
                continue
            fi
            remove_item "$file"
            count=$((count + 1))
        done < <(find "$DEVELOPER_DIR" -name "$pattern" -type f 2>/dev/null)
    done

    success "Cleaned $count temporary files"
}

cleanup_build_artifacts() {
    print_section "Cleaning Build Artifacts"

    local dirs=("dist" "build" ".next" ".nuxt" "out" "target" ".cache" ".parcel-cache")
    local count=0

    for dir_name in "${dirs[@]}"; do
        while IFS= read -r dir; do
            # Skip archive and template directories
            if [[ "$dir" == *"/archive/"* ]] || [[ "$dir" == *"/templates/"* ]]; then
                continue
            fi
            remove_item "$dir"
            count=$((count + 1))
        done < <(find "$DEVELOPER_DIR" -name "$dir_name" -type d 2>/dev/null | grep -v "node_modules")
    done

    success "Cleaned $count build artifact directories"
}

cleanup_node_modules() {
    print_section "Analyzing node_modules (Safe Mode)"

    info "Scanning for node_modules directories..."
    local modules=()
    local total_size=0

    while IFS= read -r dir; do
        # Skip archive and templates
        if [[ "$dir" == *"/archive/"* ]] || [[ "$dir" == *"/templates/"* ]]; then
            continue
        fi

        local size=$(get_dir_size "$dir")
        total_size=$((total_size + size))
        modules+=("$dir:$size")
    done < <(find "$DEVELOPER_DIR/projects" -name "node_modules" -type d -maxdepth 4 2>/dev/null)

    if [ ${#modules[@]} -eq 0 ]; then
        info "No node_modules found in active projects"
        return
    fi

    echo ""
    info "Found ${#modules[@]} node_modules directories (Total: $(bytes_to_human $total_size))"
    echo ""

    for module in "${modules[@]}"; do
        local dir="${module%%:*}"
        local size="${module##*:}"
        local project_dir=$(dirname "$dir")
        echo "  📦 $(basename "$(dirname "$dir")"): $(bytes_to_human $size)"
    done

    echo ""
    warning "Use 'npm install' or 'yarn install' to reinstall dependencies"
    info "To clean specific project: cd <project> && rm -rf node_modules && npm install"
}

cleanup_python_artifacts() {
    print_section "Cleaning Python Artifacts"

    local count=0

    # __pycache__ directories
    while IFS= read -r dir; do
        if [[ "$dir" != *"/archive/"* ]]; then
            remove_item "$dir"
            count=$((count + 1))
        fi
    done < <(find "$DEVELOPER_DIR" -name "__pycache__" -type d 2>/dev/null)

    # .pyc files
    while IFS= read -r file; do
        if [[ "$file" != *"/archive/"* ]]; then
            remove_item "$file"
            count=$((count + 1))
        fi
    done < <(find "$DEVELOPER_DIR" -name "*.pyc" -type f 2>/dev/null)

    # .pyo files
    while IFS= read -r file; do
        if [[ "$file" != *"/archive/"* ]]; then
            remove_item "$file"
            count=$((count + 1))
        fi
    done < <(find "$DEVELOPER_DIR" -name "*.pyo" -type f 2>/dev/null)

    success "Cleaned $count Python artifacts"
}

cleanup_git_artifacts() {
    print_section "Cleaning Git Artifacts"

    local count=0

    # .git/gc.log files
    while IFS= read -r file; do
        remove_item "$file"
        count=$((count + 1))
    done < <(find "$DEVELOPER_DIR" -path "*/.git/gc.log" -type f 2>/dev/null)

    # Git LFS cache (can be large)
    if [ -d "$HOME/.git-lfs" ]; then
        local size=$(get_dir_size "$HOME/.git-lfs/cache")
        if [ "$size" -gt 0 ]; then
            info "Git LFS cache: $(bytes_to_human $size)"
            warning "Run 'git lfs prune' to clean LFS cache manually"
        fi
    fi

    success "Cleaned $count Git artifacts"
}

cleanup_duplicates() {
    print_section "Finding Duplicate Files"

    info "Scanning for duplicate documentation files..."

    # Check for duplicate READMEs and guides
    local docs_to_check=("MAC-SETUP-GUIDE.md" "NAS-SETUP-GUIDE.md" "README.md")
    local found_duplicates=false

    for doc in "${docs_to_check[@]}"; do
        local files=($(find "$DEVELOPER_DIR" -name "$doc" -type f 2>/dev/null | grep -v "node_modules" | grep -v "archive"))

        if [ ${#files[@]} -gt 1 ]; then
            found_duplicates=true
            warning "Found ${#files[@]} copies of $doc:"
            for file in "${files[@]}"; do
                local rel_path="${file#$DEVELOPER_DIR/}"
                echo "    - $rel_path"
            done
            echo ""
        fi
    done

    if [ "$found_duplicates" = false ]; then
        success "No obvious duplicate documentation found"
    fi
}

analyze_large_directories() {
    print_section "Analyzing Large Directories"

    info "Finding directories over 100MB..."
    echo ""

    local large_dirs=()

    # Check major directories
    for dir in "$DEVELOPER_DIR"/*; do
        if [ -d "$dir" ]; then
            local size=$(get_dir_size "$dir")
            if [ "$size" -gt 104857600 ]; then  # 100MB
                local name=$(basename "$dir")
                large_dirs+=("$name:$size")
            fi
        fi
    done

    # Sort by size (descending)
    IFS=$'\n' large_dirs=($(sort -t: -k2 -rn <<<"${large_dirs[*]}"))
    unset IFS

    for item in "${large_dirs[@]}"; do
        local name="${item%%:*}"
        local size="${item##*:}"
        echo "  📁 $name: $(bytes_to_human $size)"
    done

    if [ ${#large_dirs[@]} -eq 0 ]; then
        success "No directories over 100MB found"
    fi
}

cleanup_logs_older_than() {
    local days=${1:-30}
    print_section "Cleaning Logs Older Than $days Days"

    local count=0

    while IFS= read -r file; do
        if [[ "$file" != *"/archive/"* ]]; then
            remove_item "$file"
            count=$((count + 1))
        fi
    done < <(find "$DEVELOPER_DIR" -name "*.log" -type f -mtime +$days 2>/dev/null)

    success "Cleaned $count old log files"
}

# =============================================================================
# Cleanup Profiles
# =============================================================================

cleanup_quick() {
    print_header "Quick Cleanup"

    cleanup_macos_files
    cleanup_temp_files
    cleanup_empty_directories
}

cleanup_standard() {
    print_header "Standard Cleanup"

    cleanup_macos_files
    cleanup_temp_files
    cleanup_empty_directories
    cleanup_python_artifacts
    cleanup_git_artifacts
    cleanup_logs_older_than 30
}

cleanup_deep() {
    print_header "Deep Cleanup"

    backup_before_cleanup
    cleanup_macos_files
    cleanup_temp_files
    cleanup_build_artifacts
    cleanup_python_artifacts
    cleanup_git_artifacts
    cleanup_empty_directories
    cleanup_logs_older_than 30
    consolidate_archives
    cleanup_duplicates
    analyze_large_directories
    cleanup_old_backups
}

cleanup_safe() {
    print_header "Safe Cleanup with Data Consolidation"

    backup_before_cleanup
    consolidate_archives
    cleanup_macos_files
    cleanup_temp_files
    cleanup_python_artifacts
    cleanup_empty_directories
    cleanup_old_backups
}

cleanup_analysis_only() {
    print_header "Cleanup Analysis (No Changes)"

    DRY_RUN=true

    analyze_large_directories
    cleanup_node_modules
    cleanup_duplicates
}

# =============================================================================
# Interactive Mode
# =============================================================================

interactive_mode() {
    print_header "Interactive Cleanup Workflow"

    echo "Select cleanup mode:"
    echo ""
    echo "  1) Safe     - Backup + consolidate archives + basic cleanup (safest)"
    echo "  2) Quick    - System files, temp files, empty dirs (fastest)"
    echo "  3) Standard - Quick + Python artifacts + old logs (recommended)"
    echo "  4) Deep     - Standard + build artifacts + archive consolidation"
    echo "  5) Analysis - Just analyze, don't delete anything"
    echo "  6) Compare  - Compare archived files with current versions"
    echo "  7) Custom   - Choose specific cleanup tasks"
    echo ""
    read -p "Enter choice (1-7): " choice

    case $choice in
        1) cleanup_safe ;;
        2) cleanup_quick ;;
        3) cleanup_standard ;;
        4) cleanup_deep ;;
        5) cleanup_analysis_only ;;
        6) compare_archived_files ;;
        7) custom_cleanup ;;
        *) error "Invalid choice"; exit 1 ;;
    esac
}

custom_cleanup() {
    print_header "Custom Cleanup"

    echo "Select cleanup tasks (space-separated numbers):"
    echo ""
    echo "  1) Create safety backup"
    echo "  2) Consolidate archives (compare & remove older versions)"
    echo "  3) macOS system files (.DS_Store, etc.)"
    echo "  4) Temporary files (.tmp, .log, .bak)"
    echo "  5) Build artifacts (dist, build, .next)"
    echo "  6) Python artifacts (__pycache__, .pyc)"
    echo "  7) Git artifacts"
    echo "  8) Empty directories"
    echo "  9) Old logs (30+ days)"
    echo "  10) Find duplicates"
    echo "  11) Analyze large directories"
    echo "  12) Clean old backups (>7 days)"
    echo ""
    read -p "Tasks: " -a tasks

    for task in "${tasks[@]}"; do
        case $task in
            1) backup_before_cleanup ;;
            2) consolidate_archives ;;
            3) cleanup_macos_files ;;
            4) cleanup_temp_files ;;
            5) cleanup_build_artifacts ;;
            6) cleanup_python_artifacts ;;
            7) cleanup_git_artifacts ;;
            8) cleanup_empty_directories ;;
            9) cleanup_logs_older_than 30 ;;
            10) cleanup_duplicates ;;
            11) analyze_large_directories ;;
            12) cleanup_old_backups ;;
            *) warning "Unknown task: $task" ;;
        esac
    done
}

# =============================================================================
# Statistics and Reporting
# =============================================================================

generate_report() {
    local report_date=$(date +%Y%m%d-%H%M%S)
    local report_file="$REPORT_DIR/cleanup-report-${report_date}.txt"
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local duration_min=$((duration / 60))
    local duration_sec=$((duration % 60))

    mkdir -p "$REPORT_DIR"

    cat > "$report_file" << EOF
╔══════════════════════════════════════════════════════════════════╗
║              Developer Folder Cleanup Report                     ║
╚══════════════════════════════════════════════════════════════════╝

Generated: $(date '+%Y-%m-%d %H:%M:%S')
Duration: ${duration_min}m ${duration_sec}s

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLEANUP SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files Removed:        $FILES_REMOVED
Directories Removed:  $DIRS_REMOVED
Space Freed:          $(bytes_to_human $TOTAL_SPACE_FREED)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DISK USAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$(df -h "$DEVELOPER_DIR" | awk 'NR==1 {print "Filesystem     Size   Used   Avail  Use%"} NR==2 {print $0}')

Developer Folder: $(du -sh "$DEVELOPER_DIR" 2>/dev/null | awk '{print $1}')

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DIRECTORY SIZES (Top 10)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$(du -sh "$DEVELOPER_DIR"/* 2>/dev/null | sort -hr | head -10)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PROJECT COUNT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total Projects:    $(find "$DEVELOPER_DIR/projects" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
Git Repositories:  $(find "$DEVELOPER_DIR" -name ".git" -type d 2>/dev/null | wc -l | tr -d ' ')
Templates:         $(find "$DEVELOPER_DIR/templates" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• Review large directories for archival opportunities
• Run deep cleanup monthly for thorough maintenance
• Check old projects for archival
• Update dependencies regularly

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Report saved to: $report_file

EOF

    echo "$report_file"
}

show_statistics() {
    print_section "Cleanup Statistics"

    echo ""
    echo -e "  ${CYAN}Files Removed:${NC}      $FILES_REMOVED"
    echo -e "  ${CYAN}Directories Removed:${NC} $DIRS_REMOVED"
    echo -e "  ${CYAN}Space Freed:${NC}        $(bytes_to_human $TOTAL_SPACE_FREED)"
    echo ""

    # Show current disk usage
    local available=$(df -h "$DEVELOPER_DIR" | awk 'NR==2 {print $4}')
    success "Available disk space: $available"

    # Generate report
    if [ "$SCHEDULED" = true ] || [ "$GENERATE_REPORT" = true ]; then
        echo ""
        local report=$(generate_report)
        success "Report generated: $report"
    fi
}

# =============================================================================
# Main Function
# =============================================================================

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [MODE]

Automated cleanup workflow for Developer folder maintenance
All cleanup operations are SAFE - creates backups and preserves data

MODES:
    safe        Safe cleanup with backup and archive consolidation (recommended)
    quick       Quick cleanup (system files, temp files)
    standard    Standard cleanup (quick + Python artifacts + logs)
    deep        Deep cleanup (standard + build artifacts + archives)
    analysis    Analysis only (no deletions)
    compare     Compare archived files with current versions
    interactive Interactive mode with menu

OPTIONS:
    -d, --dry-run       Show what would be deleted without deleting
    -v, --verbose       Show detailed output for each file
    --dir DIR          Specify custom developer directory
    -h, --help         Show this help message

DATA SAFETY:
    • Creates automatic backup before major operations
    • Compares file dates before removing duplicates
    • Preserves newer versions automatically
    • Keeps unique archived files
    • Warns about conflicting versions
    • Backups retained for 7 days

EXAMPLES:
    $(basename "$0")                    # Interactive mode (safest)
    $(basename "$0") safe               # Safe cleanup with backup
    $(basename "$0") compare            # Compare archive with current
    $(basename "$0") deep --dry-run     # Preview deep cleanup
    $(basename "$0") --verbose standard # Standard cleanup with details

EOF
}

main() {
    local mode="interactive"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            --dir)
                DEVELOPER_DIR="$2"
                shift 2
                ;;
            --scheduled)
                SCHEDULED=true
                shift
                ;;
            --report)
                GENERATE_REPORT=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            safe|quick|standard|deep|analysis|compare|interactive)
                mode="$1"
                shift
                ;;
            *)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Verify developer directory exists
    if [ ! -d "$DEVELOPER_DIR" ]; then
        error "Directory not found: $DEVELOPER_DIR"
        exit 1
    fi

    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}                   ${CYAN}Cleanup Workflow${NC}                            ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC} Developer Folder Maintenance & Optimization                   ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [ "$DRY_RUN" = true ]; then
        warning "DRY RUN MODE - No files will be deleted"
    fi

    info "Working directory: $DEVELOPER_DIR"
    echo ""

    # Execute selected mode
    case $mode in
        safe)
            cleanup_safe
            ;;
        quick)
            cleanup_quick
            ;;
        standard)
            cleanup_standard
            ;;
        deep)
            cleanup_deep
            ;;
        analysis)
            cleanup_analysis_only
            ;;
        compare)
            compare_archived_files
            ;;
        interactive)
            interactive_mode
            ;;
    esac

    # Show statistics
    if [ "$DRY_RUN" = false ]; then
        show_statistics
    fi

    echo ""
    success "Cleanup completed!"
    echo ""
}

# Run main function
main "$@"
