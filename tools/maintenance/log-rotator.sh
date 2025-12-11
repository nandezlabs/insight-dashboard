#!/bin/bash

################################################################################
# Log Rotator
# Manage and clean log files across projects
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
LOG_DIR="$HOME/Developer/logs"
MAX_LOG_SIZE="100M"
MAX_LOG_AGE=30  # days
MAX_ARCHIVED_LOGS=10

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📝 Log Rotator${NC}"
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
# Log Discovery
################################################################################

find_all_logs() {
    local search_paths=(
        "$HOME/Developer/projects"
        "$HOME/Developer/games"
        "/tmp"
        "$HOME/Library/Logs"
    )
    
    for path in "${search_paths[@]}"; do
        if [[ -d "$path" ]]; then
            find "$path" -name "*.log" -type f 2>/dev/null
        fi
    done
}

find_large_logs() {
    local min_size="${1:-10M}"
    
    print_info "Large log files (>$min_size):\n"
    
    while IFS= read -r logfile; do
        local size=$(du -h "$logfile" | awk '{print $1}')
        local mtime=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$logfile" 2>/dev/null || echo "unknown")
        echo "  $size - $logfile (modified: $mtime)"
    done < <(find_all_logs | while read -r f; do
        if [[ -f "$f" ]]; then
            local fsize=$(stat -f%z "$f")
            local minsize_bytes=$(numfmt --from=iec "$min_size" 2>/dev/null || echo "10485760")
            if [[ $fsize -gt $minsize_bytes ]]; then
                echo "$f"
            fi
        fi
    done)
}

find_old_logs() {
    local days="${1:-30}"
    
    print_info "Old log files (>$days days):\n"
    
    while IFS= read -r logfile; do
        local size=$(du -h "$logfile" | awk '{print $1}')
        local mtime=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$logfile" 2>/dev/null || echo "unknown")
        echo "  $size - $logfile (modified: $mtime)"
    done < <(find_all_logs | while read -r f; do
        if [[ -f "$f" ]]; then
            local age=$((($(date +%s) - $(stat -f%m "$f")) / 86400))
            if [[ $age -gt $days ]]; then
                echo "$f"
            fi
        fi
    done)
}

################################################################################
# Log Rotation
################################################################################

rotate_log() {
    local logfile="$1"
    
    if [[ ! -f "$logfile" ]]; then
        print_error "Log file not found: $logfile"
        return 1
    fi
    
    local basename=$(basename "$logfile")
    local dirname=$(dirname "$logfile")
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local rotated="${dirname}/${basename}.${timestamp}"
    
    print_info "Rotating: $basename"
    
    # Copy and compress the log file
    if cp "$logfile" "$rotated" && gzip "$rotated"; then
        # Clear the original log file
        > "$logfile"
        print_success "Rotated to: ${rotated}.gz"
        
        # Clean old rotated logs
        cleanup_rotated_logs "$dirname" "$basename"
    else
        print_error "Failed to rotate: $logfile"
        return 1
    fi
}

rotate_large_logs() {
    local min_size="${1:-$MAX_LOG_SIZE}"
    
    print_info "Rotating logs larger than $min_size...\n"
    
    local count=0
    
    while IFS= read -r logfile; do
        local size=$(du -h "$logfile" | awk '{print $1}')
        local fsize=$(stat -f%z "$logfile")
        local minsize_bytes=$(numfmt --from=iec "$min_size" 2>/dev/null || echo "104857600")
        
        if [[ $fsize -gt $minsize_bytes ]]; then
            rotate_log "$logfile"
            ((count++))
        fi
    done < <(find_all_logs)
    
    echo ""
    if [[ $count -gt 0 ]]; then
        print_success "Rotated $count log file(s)"
    else
        print_info "No logs to rotate"
    fi
}

cleanup_rotated_logs() {
    local dirname="$1"
    local basename="$2"
    
    # Find rotated logs for this file
    local rotated_logs=("$dirname/${basename}".*.gz)
    local count=${#rotated_logs[@]}
    
    if [[ $count -gt $MAX_ARCHIVED_LOGS ]]; then
        local to_delete=$((count - MAX_ARCHIVED_LOGS))
        
        # Sort by date and delete oldest
        find "$dirname" -name "${basename}.*.gz" -type f -print0 | \
            xargs -0 ls -t | \
            tail -n "$to_delete" | \
            while read -r old_log; do
                rm "$old_log"
                print_info "  Removed old archive: $(basename "$old_log")"
            done
    fi
}

################################################################################
# Log Cleanup
################################################################################

clean_old_logs() {
    local days="${1:-$MAX_LOG_AGE}"
    
    print_warning "This will delete log files older than $days days"
    read -p "Continue? (y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        return 0
    fi
    
    print_info "Cleaning old logs...\n"
    
    local count=0
    local total_size=0
    
    while IFS= read -r logfile; do
        local age=$((($(date +%s) - $(stat -f%m "$logfile")) / 86400))
        
        if [[ $age -gt $days ]]; then
            local size=$(stat -f%z "$logfile")
            rm "$logfile"
            print_info "  Removed: $logfile (${age} days old)"
            ((count++))
            ((total_size += size))
        fi
    done < <(find_all_logs)
    
    echo ""
    if [[ $count -gt 0 ]]; then
        local human_size=$(numfmt --to=iec-i --suffix=B "$total_size" 2>/dev/null || echo "${total_size} bytes")
        print_success "Removed $count log file(s) ($human_size freed)"
    else
        print_info "No old logs to remove"
    fi
}

clean_empty_logs() {
    print_info "Cleaning empty log files...\n"
    
    local count=0
    
    while IFS= read -r logfile; do
        if [[ ! -s "$logfile" ]]; then
            rm "$logfile"
            print_info "  Removed: $logfile"
            ((count++))
        fi
    done < <(find_all_logs)
    
    echo ""
    if [[ $count -gt 0 ]]; then
        print_success "Removed $count empty log file(s)"
    else
        print_info "No empty logs found"
    fi
}

################################################################################
# Log Analysis
################################################################################

analyze_log() {
    local logfile="$1"
    
    if [[ ! -f "$logfile" ]]; then
        print_error "Log file not found: $logfile"
        return 1
    fi
    
    print_info "Log Analysis: $(basename "$logfile")\n"
    
    # File size
    local size=$(du -h "$logfile" | awk '{print $1}')
    echo "  Size: $size"
    
    # Line count
    local lines=$(wc -l < "$logfile")
    echo "  Lines: $lines"
    
    # Last modified
    local mtime=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$logfile")
    echo "  Modified: $mtime"
    
    # Error count
    local errors=$(grep -i "error" "$logfile" 2>/dev/null | wc -l | tr -d ' ')
    echo "  Errors: $errors"
    
    # Warning count
    local warnings=$(grep -i "warn" "$logfile" 2>/dev/null | wc -l | tr -d ' ')
    echo "  Warnings: $warnings"
    
    echo ""
    
    if [[ $errors -gt 0 ]]; then
        print_warning "Recent errors:"
        grep -i "error" "$logfile" | tail -5 | sed 's/^/  /'
    fi
}

show_log_summary() {
    print_info "Log File Summary:\n"
    
    local total_count=0
    local total_size=0
    
    while IFS= read -r logfile; do
        if [[ -f "$logfile" ]]; then
            ((total_count++))
            local size=$(stat -f%z "$logfile")
            ((total_size += size))
        fi
    done < <(find_all_logs)
    
    local human_size=$(numfmt --to=iec-i --suffix=B "$total_size" 2>/dev/null || echo "${total_size} bytes")
    
    echo "  Total log files: $total_count"
    echo "  Total size: $human_size"
    
    # Count by directory
    echo ""
    print_info "By location:"
    
    local locations=("$HOME/Developer/projects" "$HOME/Developer/games" "/tmp" "$HOME/Library/Logs")
    
    for location in "${locations[@]}"; do
        if [[ -d "$location" ]]; then
            local count=$(find "$location" -name "*.log" -type f 2>/dev/null | wc -l | tr -d ' ')
            if [[ $count -gt 0 ]]; then
                echo "  $location: $count file(s)"
            fi
        fi
    done
}

################################################################################
# Log Viewer
################################################################################

tail_log() {
    local logfile="$1"
    local lines="${2:-50}"
    
    if [[ ! -f "$logfile" ]]; then
        print_error "Log file not found: $logfile"
        return 1
    fi
    
    print_info "Last $lines lines of $(basename "$logfile"):\n"
    tail -n "$lines" "$logfile"
}

follow_log() {
    local logfile="$1"
    
    if [[ ! -f "$logfile" ]]; then
        print_error "Log file not found: $logfile"
        return 1
    fi
    
    print_info "Following: $(basename "$logfile") (Ctrl+C to stop)\n"
    tail -f "$logfile"
}

search_logs() {
    local pattern="$1"
    local context="${2:-2}"
    
    print_info "Searching logs for: $pattern\n"
    
    while IFS= read -r logfile; do
        if grep -q "$pattern" "$logfile" 2>/dev/null; then
            echo "  ${CYAN}$(basename "$logfile"):${NC}"
            grep -C "$context" "$pattern" "$logfile" | head -20 | sed 's/^/    /'
            echo ""
        fi
    done < <(find_all_logs)
}

################################################################################
# Automated Rotation
################################################################################

schedule_rotation() {
    local schedule="$1"  # daily, weekly, monthly
    
    print_info "Setting up automated log rotation..."
    
    local cron_command="$0 rotate-large"
    local cron_schedule=""
    
    case $schedule in
        daily)
            cron_schedule="0 3 * * *"  # 3 AM daily
            ;;
        weekly)
            cron_schedule="0 3 * * 0"  # 3 AM Sunday
            ;;
        monthly)
            cron_schedule="0 3 1 * *"  # 3 AM 1st of month
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
# Interactive Mode
################################################################################

interactive_mode() {
    echo -e "${CYAN}Log Management Options:${NC}"
    echo "  1) Show log summary"
    echo "  2) Find large logs"
    echo "  3) Find old logs"
    echo "  4) Rotate large logs"
    echo "  5) Clean old logs"
    echo "  6) Clean empty logs"
    echo "  7) Analyze log file"
    echo "  8) Search logs"
    echo "  9) Tail log file"
    echo "  10) Follow log file"
    echo "  11) Schedule rotation"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            show_log_summary
            ;;
        2)
            read -p "Minimum size (default: 10M): " size
            find_large_logs "${size:-10M}"
            ;;
        3)
            read -p "Age in days (default: 30): " days
            find_old_logs "${days:-30}"
            ;;
        4)
            read -p "Minimum size (default: 100M): " size
            rotate_large_logs "${size:-100M}"
            ;;
        5)
            read -p "Age in days (default: 30): " days
            clean_old_logs "${days:-30}"
            ;;
        6)
            clean_empty_logs
            ;;
        7)
            read -p "Log file path: " logfile
            analyze_log "$logfile"
            ;;
        8)
            read -p "Search pattern: " pattern
            search_logs "$pattern"
            ;;
        9)
            read -p "Log file path: " logfile
            read -p "Number of lines (default: 50): " lines
            tail_log "$logfile" "${lines:-50}"
            ;;
        10)
            read -p "Log file path: " logfile
            follow_log "$logfile"
            ;;
        11)
            read -p "Schedule (daily/weekly/monthly): " schedule
            schedule_rotation "$schedule"
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
    echo "  summary              Show log file summary"
    echo "  large [SIZE]         Find large log files"
    echo "  old [DAYS]           Find old log files"
    echo "  rotate [FILE]        Rotate specific log file"
    echo "  rotate-large [SIZE]  Rotate all large logs"
    echo "  clean [DAYS]         Remove old log files"
    echo "  clean-empty          Remove empty log files"
    echo "  analyze FILE         Analyze log file"
    echo "  search PATTERN       Search in all logs"
    echo "  tail FILE [LINES]    Show last N lines"
    echo "  follow FILE          Follow log file"
    echo "  schedule FREQUENCY   Setup automated rotation"
    echo "  interactive          Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 summary"
    echo "  $0 large 50M"
    echo "  $0 clean 30"
    echo "  $0 search ERROR"
    echo "  $0 schedule daily"
}

main() {
    local command="${1:-interactive}"
    
    print_header
    
    case $command in
        summary)
            show_log_summary
            ;;
        large)
            find_large_logs "${2:-10M}"
            ;;
        old)
            find_old_logs "${2:-30}"
            ;;
        rotate)
            if [[ -z "$2" ]]; then
                print_error "Log file path required"
                show_usage
                exit 1
            fi
            rotate_log "$2"
            ;;
        rotate-large)
            rotate_large_logs "${2:-$MAX_LOG_SIZE}"
            ;;
        clean)
            clean_old_logs "${2:-$MAX_LOG_AGE}"
            ;;
        clean-empty)
            clean_empty_logs
            ;;
        analyze)
            if [[ -z "$2" ]]; then
                print_error "Log file path required"
                show_usage
                exit 1
            fi
            analyze_log "$2"
            ;;
        search)
            if [[ -z "$2" ]]; then
                print_error "Search pattern required"
                show_usage
                exit 1
            fi
            search_logs "$2"
            ;;
        tail)
            if [[ -z "$2" ]]; then
                print_error "Log file path required"
                show_usage
                exit 1
            fi
            tail_log "$2" "${3:-50}"
            ;;
        follow)
            if [[ -z "$2" ]]; then
                print_error "Log file path required"
                show_usage
                exit 1
            fi
            follow_log "$2"
            ;;
        schedule)
            if [[ -z "$2" ]]; then
                print_error "Schedule frequency required"
                show_usage
                exit 1
            fi
            schedule_rotation "$2"
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
