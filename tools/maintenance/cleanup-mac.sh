#!/bin/bash

################################################################################
# Mac Cleanup & Optimization Script
# Safely clean caches, logs, and free up disk space
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
    echo -e "${BLUE}  🧹 Mac Cleanup & Optimization${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_section() {
    echo -e "\n${CYAN}▸ $1${NC}"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "  ${YELLOW}ℹ${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

get_size() {
    local path="$1"
    if [[ -e "$path" ]]; then
        du -sh "$path" 2>/dev/null | awk '{print $1}'
    else
        echo "0B"
    fi
}

get_disk_space() {
    df -h / | awk 'NR==2 {print $4}'
}

################################################################################
# Cleanup Functions
################################################################################

cleanup_system_caches() {
    print_section "System Caches"
    
    local saved=0
    
    # System cache
    if [[ -d ~/Library/Caches ]]; then
        local size=$(get_size ~/Library/Caches)
        print_info "Cleaning user caches ($size)..."
        find ~/Library/Caches -type f -atime +30 -delete 2>/dev/null || true
        print_success "User caches cleaned"
    fi
    
    # Application caches (safe to remove)
    local cache_dirs=(
        "~/Library/Caches/com.apple.Safari"
        "~/Library/Caches/Google/Chrome"
        "~/Library/Caches/Firefox"
        "~/Library/Caches/com.spotify.client"
    )
    
    for cache_dir in "${cache_dirs[@]}"; do
        cache_dir="${cache_dir/#\~/$HOME}"
        if [[ -d "$cache_dir" ]]; then
            local size=$(get_size "$cache_dir")
            print_info "Cleaning $(basename "$cache_dir") ($size)..."
            rm -rf "$cache_dir"/* 2>/dev/null || true
            print_success "$(basename "$cache_dir") cleaned"
        fi
    done
}

cleanup_development() {
    print_section "Development Cleanup"
    
    # Node modules (ask before cleaning)
    print_info "Finding old node_modules folders..."
    local node_modules_count=$(find ~/Developer -name "node_modules" -type d 2>/dev/null | wc -l | xargs)
    
    if [[ $node_modules_count -gt 0 ]]; then
        print_warning "Found $node_modules_count node_modules folders"
        echo -n "  Clean node_modules older than 30 days? [y/N] "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            find ~/Developer -name "node_modules" -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true
            print_success "Old node_modules cleaned"
        else
            print_info "Skipped node_modules cleanup"
        fi
    else
        print_info "No node_modules folders found"
    fi
    
    # Python cache
    print_info "Cleaning Python cache files..."
    find ~/Developer -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
    find ~/Developer -name "*.pyc" -delete 2>/dev/null || true
    find ~/Developer -name ".pytest_cache" -type d -exec rm -rf {} + 2>/dev/null || true
    print_success "Python cache cleaned"
    
    # Godot builds and imports
    print_info "Cleaning Godot build files..."
    find ~/Developer/games -name ".godot" -type d -exec rm -rf {} + 2>/dev/null || true
    find ~/Developer/games -name "builds" -type d -exec rm -rf {} + 2>/dev/null || true
    print_success "Godot build files cleaned"
    
    # VS Code extensions cache
    if [[ -d ~/Library/Application\ Support/Code/CachedExtensionVSIXs ]]; then
        local size=$(get_size ~/Library/Application\ Support/Code/CachedExtensionVSIXs)
        print_info "Cleaning VS Code extension cache ($size)..."
        rm -rf ~/Library/Application\ Support/Code/CachedExtensionVSIXs/* 2>/dev/null || true
        print_success "VS Code cache cleaned"
    fi
}

cleanup_homebrew() {
    print_section "Homebrew Cleanup"
    
    if command -v brew &> /dev/null; then
        print_info "Running brew cleanup..."
        brew cleanup -s 2>/dev/null || true
        print_success "Homebrew cleaned"
        
        print_info "Removing old versions..."
        brew autoremove 2>/dev/null || true
        print_success "Old formulae removed"
    else
        print_info "Homebrew not installed, skipping"
    fi
}

cleanup_logs() {
    print_section "System Logs"
    
    # User logs
    if [[ -d ~/Library/Logs ]]; then
        local size=$(get_size ~/Library/Logs)
        print_info "Cleaning old log files ($size)..."
        find ~/Library/Logs -type f -mtime +30 -delete 2>/dev/null || true
        print_success "Old logs cleaned"
    fi
    
    # System logs (requires sudo)
    echo -n "  Clean system logs (requires sudo)? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_info "Cleaning system logs..."
        sudo rm -rf /var/log/asl/*.asl 2>/dev/null || true
        sudo rm -rf /Library/Logs/DiagnosticReports/* 2>/dev/null || true
        print_success "System logs cleaned"
    else
        print_info "Skipped system logs"
    fi
}

cleanup_downloads() {
    print_section "Downloads Folder"
    
    local size=$(get_size ~/Downloads)
    print_info "Downloads folder size: $size"
    
    # Find old files
    local old_files=$(find ~/Downloads -type f -mtime +90 2>/dev/null | wc -l | xargs)
    if [[ $old_files -gt 0 ]]; then
        print_warning "Found $old_files files older than 90 days"
        echo -n "  List them? [y/N] "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            find ~/Downloads -type f -mtime +90 -exec ls -lh {} \; 2>/dev/null | tail -20
            echo -n "  Delete these files? [y/N] "
            read -r del_response
            if [[ "$del_response" =~ ^[Yy]$ ]]; then
                find ~/Downloads -type f -mtime +90 -delete 2>/dev/null || true
                print_success "Old downloads deleted"
            fi
        fi
    else
        print_info "No old files in Downloads"
    fi
}

cleanup_trash() {
    print_section "Trash"
    
    local size=$(get_size ~/.Trash)
    print_info "Trash size: $size"
    
    if [[ "$size" != "0B" ]]; then
        echo -n "  Empty trash? [y/N] "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rm -rf ~/.Trash/* 2>/dev/null || true
            print_success "Trash emptied"
        else
            print_info "Trash not emptied"
        fi
    else
        print_info "Trash is empty"
    fi
}

cleanup_docker() {
    print_section "Docker Cleanup"
    
    if command -v docker &> /dev/null; then
        print_info "Cleaning Docker..."
        
        # Remove unused images
        docker image prune -a -f 2>/dev/null || true
        
        # Remove unused volumes
        docker volume prune -f 2>/dev/null || true
        
        # Remove build cache
        docker builder prune -a -f 2>/dev/null || true
        
        print_success "Docker cleaned"
    else
        print_info "Docker not installed, skipping"
    fi
}

cleanup_xcode() {
    print_section "Xcode & iOS"
    
    # Derived data
    if [[ -d ~/Library/Developer/Xcode/DerivedData ]]; then
        local size=$(get_size ~/Library/Developer/Xcode/DerivedData)
        print_info "Xcode DerivedData size: $size"
        echo -n "  Clean DerivedData? [y/N] "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null || true
            print_success "DerivedData cleaned"
        fi
    fi
    
    # Old simulators
    if command -v xcrun &> /dev/null; then
        print_info "Cleaning old iOS simulators..."
        xcrun simctl delete unavailable 2>/dev/null || true
        print_success "Old simulators removed"
    fi
    
    # Archives
    if [[ -d ~/Library/Developer/Xcode/Archives ]]; then
        local size=$(get_size ~/Library/Developer/Xcode/Archives)
        print_info "Xcode Archives size: $size"
        print_warning "Archives contain your app builds - only clean if sure!"
    fi
}

optimize_system() {
    print_section "System Optimization"
    
    # Rebuild Spotlight index
    echo -n "  Rebuild Spotlight index? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_info "Rebuilding Spotlight index (this may take a while)..."
        sudo mdutil -E / 2>/dev/null || true
        print_success "Spotlight index rebuilding"
    fi
    
    # Clear DNS cache
    print_info "Clearing DNS cache..."
    sudo dscacheutil -flushcache 2>/dev/null || true
    sudo killall -HUP mDNSResponder 2>/dev/null || true
    print_success "DNS cache cleared"
    
    # Purge memory (only if needed)
    local memory_pressure=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%')
    if [[ -n "$memory_pressure" ]] && [[ $memory_pressure -lt 20 ]]; then
        print_warning "Low memory detected ($memory_pressure% free)"
        echo -n "  Purge inactive memory? [y/N] "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo purge
            print_success "Memory purged"
        fi
    else
        print_info "Memory pressure is good"
    fi
}

show_summary() {
    print_section "Summary"
    
    local free_space=$(get_disk_space)
    print_success "Cleanup complete!"
    print_info "Free disk space: $free_space"
    
    echo ""
    print_info "Recommendations:"
    echo "  • Restart your Mac for best performance"
    echo "  • Empty trash if you haven't already"
    echo "  • Review large files: sudo du -sh ~/Downloads/* | sort -h"
    echo "  • Check storage: About This Mac → Storage"
}

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Clean up and optimize your Mac.

OPTIONS:
    --all           Run all cleanup tasks (interactive)
    --safe          Run only safe cleanups (no prompts)
    --dev           Clean development files only
    --brew          Clean Homebrew only
    --docker        Clean Docker only
    --dry-run       Show what would be cleaned without doing it
    -h, --help      Show this help message

EXAMPLES:
    # Interactive full cleanup
    $(basename "$0") --all

    # Safe automatic cleanup
    $(basename "$0") --safe

    # Clean development files only
    $(basename "$0") --dev

EOF
}

################################################################################
# Main Script
################################################################################

main() {
    print_header
    
    local before_space=$(get_disk_space)
    print_info "Available disk space: $before_space"
    
    case "${1:-}" in
        --all)
            cleanup_system_caches
            cleanup_development
            cleanup_homebrew
            cleanup_logs
            cleanup_downloads
            cleanup_trash
            cleanup_docker
            cleanup_xcode
            optimize_system
            show_summary
            ;;
        --safe)
            print_info "Running safe cleanup (no prompts)..."
            cleanup_system_caches
            # Safe dev cleanup
            find ~/Developer -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
            find ~/Developer -name "*.pyc" -delete 2>/dev/null || true
            if command -v brew &> /dev/null; then
                brew cleanup -s 2>/dev/null || true
            fi
            print_success "Safe cleanup complete!"
            ;;
        --dev)
            cleanup_development
            ;;
        --brew)
            cleanup_homebrew
            ;;
        --docker)
            cleanup_docker
            ;;
        --dry-run)
            print_info "Dry run mode - showing what would be cleaned..."
            echo ""
            print_info "User caches: $(get_size ~/Library/Caches)"
            print_info "VS Code cache: $(get_size ~/Library/Application\ Support/Code/CachedExtensionVSIXs)"
            print_info "Downloads: $(get_size ~/Downloads)"
            print_info "Trash: $(get_size ~/.Trash)"
            if [[ -d ~/Library/Developer/Xcode/DerivedData ]]; then
                print_info "Xcode DerivedData: $(get_size ~/Library/Developer/Xcode/DerivedData)"
            fi
            local node_count=$(find ~/Developer -name "node_modules" -type d 2>/dev/null | wc -l | xargs)
            print_info "node_modules folders: $node_count"
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            show_usage
            ;;
    esac
}

main "$@"
