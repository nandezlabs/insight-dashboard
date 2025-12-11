#!/bin/bash

# =============================================================================
# Schedule Cleanup - Automated Cleanup Scheduling for macOS
# =============================================================================
# Manages automated cleanup scheduling using launchd (macOS)
# Features:
# - Weekly cleanup automation (every 7 days)
# - Email/notification reports
# - Easy enable/disable
# - Status monitoring
# - Custom schedules
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Configuration
PLIST_NAME="com.developer.cleanup"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_NAME}.plist"
CLEANUP_SCRIPT="$HOME/Developer/tools/maintenance/cleanup-workflow.sh"
LOG_DIR="$HOME/Developer/logs/cleanup"
REPORT_DIR="$HOME/Developer/reports/cleanup"

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

success() { echo -e "${GREEN}✓${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
info() { echo -e "${CYAN}ℹ${NC} $1"; }

# =============================================================================
# Plist Generation
# =============================================================================

create_plist() {
    local interval_days=${1:-7}
    local hour=${2:-2}  # 2 AM default
    local cleanup_mode=${3:-safe}
    
    # Calculate interval in seconds (days * 24 * 60 * 60)
    local interval_seconds=$((interval_days * 86400))
    
    mkdir -p "$(dirname "$PLIST_PATH")"
    mkdir -p "$LOG_DIR"
    mkdir -p "$REPORT_DIR"
    
    cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_NAME}</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${CLEANUP_SCRIPT}</string>
        <string>${cleanup_mode}</string>
        <string>--scheduled</string>
    </array>
    
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>0</integer>
        <key>Hour</key>
        <integer>${hour}</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    
    <key>StandardOutPath</key>
    <string>${LOG_DIR}/cleanup-\$(date +\%Y\%m\%d).log</string>
    
    <key>StandardErrorPath</key>
    <string>${LOG_DIR}/cleanup-error-\$(date +\%Y\%m\%d).log</string>
    
    <key>RunAtLoad</key>
    <false/>
    
    <key>Nice</key>
    <integer>10</integer>
    
    <key>ProcessType</key>
    <string>Background</string>
    
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        <key>HOME</key>
        <string>${HOME}</string>
    </dict>
</dict>
</plist>
EOF
    
    success "Created plist configuration"
    info "Schedule: Every Sunday at ${hour}:00 AM"
    info "Mode: $cleanup_mode"
    info "Logs: $LOG_DIR"
}

# =============================================================================
# Schedule Management
# =============================================================================

install_schedule() {
    local interval_days=${1:-7}
    local hour=${2:-2}
    local cleanup_mode=${3:-safe}
    
    print_section "Installing Cleanup Schedule"
    
    # Check if cleanup script exists
    if [ ! -f "$CLEANUP_SCRIPT" ]; then
        error "Cleanup script not found: $CLEANUP_SCRIPT"
        exit 1
    fi
    
    # Create plist
    create_plist "$interval_days" "$hour" "$cleanup_mode"
    
    # Load the agent
    if launchctl list | grep -q "$PLIST_NAME"; then
        warning "Schedule already loaded, reloading..."
        launchctl unload "$PLIST_PATH" 2>/dev/null || true
    fi
    
    launchctl load "$PLIST_PATH"
    
    if [ $? -eq 0 ]; then
        success "Cleanup schedule installed and activated"
        echo ""
        info "Next run: Every Sunday at ${hour}:00 AM"
        info "Cleanup mode: $cleanup_mode"
        info "Logs directory: $LOG_DIR"
        info "Reports directory: $REPORT_DIR"
    else
        error "Failed to load schedule"
        exit 1
    fi
}

uninstall_schedule() {
    print_section "Uninstalling Cleanup Schedule"
    
    if [ -f "$PLIST_PATH" ]; then
        if launchctl list | grep -q "$PLIST_NAME"; then
            launchctl unload "$PLIST_PATH"
            success "Schedule unloaded"
        else
            info "Schedule was not running"
        fi
        
        rm "$PLIST_PATH"
        success "Schedule configuration removed"
    else
        warning "No schedule configuration found"
    fi
}

status_schedule() {
    print_section "Cleanup Schedule Status"
    
    if [ ! -f "$PLIST_PATH" ]; then
        warning "Schedule not installed"
        echo ""
        info "Run: $0 install"
        return
    fi
    
    # Check if loaded
    if launchctl list | grep -q "$PLIST_NAME"; then
        success "Schedule is ACTIVE"
        echo ""
        
        # Parse configuration
        local hour=$(grep -A1 "Hour" "$PLIST_PATH" | grep "integer" | sed 's/[^0-9]//g')
        local mode=$(grep -A4 "ProgramArguments" "$PLIST_PATH" | grep -v "bash" | grep -v "ProgramArguments" | grep -v "array" | grep -v "string.*cleanup-workflow" | grep "string" | head -1 | sed 's/.*<string>//; s/<\/string>//')
        
        info "Schedule: Every Sunday at ${hour}:00 AM"
        info "Mode: ${mode:-safe}"
        info "Plist: $PLIST_PATH"
        
        # Show recent runs
        echo ""
        print_section "Recent Runs"
        
        if [ -d "$LOG_DIR" ] && [ "$(ls -A $LOG_DIR 2>/dev/null)" ]; then
            echo "Last 5 cleanup runs:"
            echo ""
            ls -t "$LOG_DIR"/cleanup-*.log 2>/dev/null | head -5 | while read log; do
                local date=$(basename "$log" | sed 's/cleanup-//; s/.log//')
                local size=$(du -h "$log" 2>/dev/null | awk '{print $1}')
                echo "  📄 $date ($size)"
            done
        else
            info "No cleanup runs yet"
        fi
        
        # Show recent reports
        if [ -d "$REPORT_DIR" ] && [ "$(ls -A $REPORT_DIR 2>/dev/null)" ]; then
            echo ""
            echo "Recent reports:"
            echo ""
            ls -t "$REPORT_DIR"/cleanup-report-*.txt 2>/dev/null | head -3 | while read report; do
                local date=$(basename "$report" | sed 's/cleanup-report-//; s/.txt//')
                echo "  📊 $date"
            done
        fi
        
    else
        warning "Schedule is INSTALLED but NOT ACTIVE"
        echo ""
        info "Run: $0 start"
    fi
}

start_schedule() {
    print_section "Starting Cleanup Schedule"
    
    if [ ! -f "$PLIST_PATH" ]; then
        error "Schedule not installed"
        echo ""
        info "Run: $0 install"
        exit 1
    fi
    
    if launchctl list | grep -q "$PLIST_NAME"; then
        warning "Schedule is already running"
    else
        launchctl load "$PLIST_PATH"
        success "Schedule started"
    fi
}

stop_schedule() {
    print_section "Stopping Cleanup Schedule"
    
    if launchctl list | grep -q "$PLIST_NAME"; then
        launchctl unload "$PLIST_PATH"
        success "Schedule stopped"
    else
        warning "Schedule is not running"
    fi
}

test_run() {
    print_section "Running Test Cleanup"
    
    info "Running cleanup in dry-run mode..."
    echo ""
    
    "$CLEANUP_SCRIPT" safe --dry-run
    
    echo ""
    success "Test completed - check output above"
}

view_logs() {
    print_section "Recent Cleanup Logs"
    
    if [ ! -d "$LOG_DIR" ] || [ -z "$(ls -A $LOG_DIR 2>/dev/null)" ]; then
        warning "No logs found"
        return
    fi
    
    local latest_log=$(ls -t "$LOG_DIR"/cleanup-*.log 2>/dev/null | head -1)
    
    if [ -n "$latest_log" ]; then
        info "Showing: $(basename "$latest_log")"
        echo ""
        cat "$latest_log"
    fi
}

view_report() {
    local date=${1:-latest}
    
    print_section "Cleanup Report"
    
    if [ ! -d "$REPORT_DIR" ] || [ -z "$(ls -A $REPORT_DIR 2>/dev/null)" ]; then
        warning "No reports found"
        return
    fi
    
    local report
    if [ "$date" = "latest" ]; then
        report=$(ls -t "$REPORT_DIR"/cleanup-report-*.txt 2>/dev/null | head -1)
    else
        report="$REPORT_DIR/cleanup-report-${date}.txt"
    fi
    
    if [ -f "$report" ]; then
        cat "$report"
    else
        error "Report not found: $report"
    fi
}

list_reports() {
    print_section "Available Reports"
    
    if [ ! -d "$REPORT_DIR" ] || [ -z "$(ls -A $REPORT_DIR 2>/dev/null)" ]; then
        warning "No reports found"
        return
    fi
    
    echo ""
    ls -t "$REPORT_DIR"/cleanup-report-*.txt 2>/dev/null | while read report; do
        local date=$(basename "$report" | sed 's/cleanup-report-//; s/.txt//')
        local size=$(du -h "$report" 2>/dev/null | awk '{print $1}')
        local lines=$(wc -l < "$report" 2>/dev/null | tr -d ' ')
        
        echo "📊 $date - $size ($lines lines)"
    done
    
    echo ""
    info "View report: $0 report <date>"
}

# =============================================================================
# Interactive Mode
# =============================================================================

interactive_mode() {
    print_header "Schedule Cleanup - Interactive Setup"
    
    echo "1) Install schedule (every 7 days, 2 AM, safe mode)"
    echo "2) Install custom schedule"
    echo "3) Uninstall schedule"
    echo "4) Start schedule"
    echo "5) Stop schedule"
    echo "6) View status"
    echo "7) Test run (dry-run)"
    echo "8) View latest log"
    echo "9) View latest report"
    echo "10) List all reports"
    echo ""
    read -p "Enter choice (1-10): " choice
    
    case $choice in
        1)
            install_schedule 7 2 safe
            ;;
        2)
            echo ""
            read -p "Run every X days [7]: " days
            days=${days:-7}
            read -p "Hour (0-23) [2]: " hour
            hour=${hour:-2}
            read -p "Cleanup mode (safe/quick/standard/deep) [safe]: " mode
            mode=${mode:-safe}
            install_schedule "$days" "$hour" "$mode"
            ;;
        3)
            uninstall_schedule
            ;;
        4)
            start_schedule
            ;;
        5)
            stop_schedule
            ;;
        6)
            status_schedule
            ;;
        7)
            test_run
            ;;
        8)
            view_logs
            ;;
        9)
            view_report latest
            ;;
        10)
            list_reports
            ;;
        *)
            error "Invalid choice"
            exit 1
            ;;
    esac
}

# =============================================================================
# Usage
# =============================================================================

show_usage() {
    cat << EOF
Usage: $(basename "$0") [COMMAND] [OPTIONS]

Manage automated cleanup scheduling for Developer folder

COMMANDS:
    install [days] [hour] [mode]  Install cleanup schedule
                                   Default: every 7 days at 2 AM, safe mode
    uninstall                      Remove cleanup schedule
    start                          Start cleanup schedule
    stop                           Stop cleanup schedule
    status                         Show schedule status
    test                           Run test cleanup (dry-run)
    logs                           View latest cleanup log
    report [date|latest]           View cleanup report
    reports                        List all reports
    interactive                    Interactive setup (default)

INSTALL OPTIONS:
    days    Run every X days (default: 7)
    hour    Hour to run 0-23 (default: 2 = 2 AM)
    mode    Cleanup mode: safe/quick/standard/deep (default: safe)

EXAMPLES:
    $(basename "$0")                      # Interactive mode
    $(basename "$0") install              # Install with defaults (every 7 days, 2 AM)
    $(basename "$0") install 7 3 safe     # Every 7 days at 3 AM, safe mode
    $(basename "$0") status               # Check status
    $(basename "$0") test                 # Test run
    $(basename "$0") report latest        # View latest report
    $(basename "$0") uninstall            # Remove schedule

CLEANUP MODES:
    safe     - Backup + consolidate + basic cleanup (recommended)
    quick    - Fast cleanup (system files, temp files)
    standard - Quick + Python artifacts + logs
    deep     - Standard + build artifacts + archives

SCHEDULE:
    • Uses macOS launchd (preferred over cron)
    • Runs in background (low priority)
    • Automatic logging to: $LOG_DIR
    • Reports saved to: $REPORT_DIR
    • Email notifications (if configured)

EOF
}

# =============================================================================
# Main
# =============================================================================

main() {
    local command=${1:-interactive}
    
    case $command in
        install)
            install_schedule "${2:-7}" "${3:-2}" "${4:-safe}"
            ;;
        uninstall)
            uninstall_schedule
            ;;
        start)
            start_schedule
            ;;
        stop)
            stop_schedule
            ;;
        status)
            status_schedule
            ;;
        test)
            test_run
            ;;
        logs)
            view_logs
            ;;
        report)
            view_report "${2:-latest}"
            ;;
        reports)
            list_reports
            ;;
        interactive)
            interactive_mode
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            error "Unknown command: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
