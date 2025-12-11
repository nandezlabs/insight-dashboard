#!/bin/bash

################################################################################
# Health Checker
# Monitor services, disk space, and system resources
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Thresholds
DISK_WARNING=80
DISK_CRITICAL=90
MEMORY_WARNING=80
MEMORY_CRITICAL=90
CPU_WARNING=80
CPU_CRITICAL=90

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🏥 Health Checker${NC}"
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

print_status() {
    local value=$1
    local warning=$2
    local critical=$3
    local text="$4"
    
    if [[ $value -ge $critical ]]; then
        echo -e "${RED}✗${NC} $text"
    elif [[ $value -ge $warning ]]; then
        echo -e "${YELLOW}⚠${NC} $text"
    else
        echo -e "${GREEN}✓${NC} $text"
    fi
}

################################################################################
# Disk Space Check
################################################################################

check_disk_space() {
    print_info "Disk Space:\n"
    
    local critical_count=0
    local warning_count=0
    
    # Check macOS volumes
    while IFS= read -r line; do
        local filesystem=$(echo "$line" | awk '{print $1}')
        local size=$(echo "$line" | awk '{print $2}')
        local used=$(echo "$line" | awk '{print $3}')
        local avail=$(echo "$line" | awk '{print $4}')
        local percent=$(echo "$line" | awk '{print $5}' | tr -d '%')
        local mount=$(echo "$line" | awk '{print $9}')
        
        if [[ -z "$percent" || "$percent" == "Capacity" ]]; then
            continue
        fi
        
        if [[ $percent -ge $DISK_CRITICAL ]]; then
            echo -e "  ${RED}✗${NC} $mount: ${percent}% used ($avail available)"
            ((critical_count++))
        elif [[ $percent -ge $DISK_WARNING ]]; then
            echo -e "  ${YELLOW}⚠${NC} $mount: ${percent}% used ($avail available)"
            ((warning_count++))
        else
            echo -e "  ${GREEN}✓${NC} $mount: ${percent}% used ($avail available)"
        fi
    done < <(df -h | grep -E "^/dev/")
    
    echo ""
    
    if [[ $critical_count -gt 0 ]]; then
        print_error "Critical: $critical_count volume(s) need immediate attention"
    elif [[ $warning_count -gt 0 ]]; then
        print_warning "Warning: $warning_count volume(s) running low"
    else
        print_success "All volumes have adequate space"
    fi
}

find_large_files() {
    local path="${1:-$HOME}"
    local min_size="${2:-100M}"
    
    print_info "Large files in $path (>$min_size):\n"
    
    find "$path" -type f -size "+$min_size" -exec ls -lh {} \; 2>/dev/null | \
        awk '{print $5 "\t" $9}' | \
        sort -rh | \
        head -20 | \
        while read -r size file; do
            echo "  $size - $file"
        done
}

################################################################################
# Memory Check
################################################################################

check_memory() {
    print_info "Memory Usage:\n"
    
    # Get memory info for macOS
    local page_size=$(vm_stat | grep "page size" | awk '{print $8}')
    local pages_free=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
    local pages_active=$(vm_stat | grep "Pages active" | awk '{print $3}' | tr -d '.')
    local pages_inactive=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
    local pages_wired=$(vm_stat | grep "Pages wired down" | awk '{print $4}' | tr -d '.')
    
    # Calculate memory in GB
    local free_gb=$(echo "scale=2; $pages_free * $page_size / 1073741824" | bc)
    local active_gb=$(echo "scale=2; $pages_active * $page_size / 1073741824" | bc)
    local wired_gb=$(echo "scale=2; $pages_wired * $page_size / 1073741824" | bc)
    
    # Get total memory
    local total_gb=$(sysctl -n hw.memsize | awk '{print $1/1073741824}')
    
    # Calculate used memory
    local used_gb=$(echo "scale=2; $active_gb + $wired_gb" | bc)
    local used_percent=$(echo "scale=0; $used_gb * 100 / $total_gb" | bc)
    
    echo "  Total: ${total_gb}GB"
    echo "  Used: ${used_gb}GB (${used_percent}%)"
    echo "  Free: ${free_gb}GB"
    echo ""
    
    print_status "$used_percent" "$MEMORY_WARNING" "$MEMORY_CRITICAL" "Memory status: ${used_percent}% used"
}

show_memory_hogs() {
    print_info "Top memory consumers:\n"
    
    ps aux | sort -rk 4,4 | head -11 | tail -10 | \
        awk '{printf "  %s%%\t%s\n", $4, $11}'
}

################################################################################
# CPU Check
################################################################################

check_cpu() {
    print_info "CPU Usage:\n"
    
    # Get CPU usage
    local cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
    
    # Remove decimal point for comparison
    local cpu_int=${cpu_usage%.*}
    
    echo "  CPU: ${cpu_usage}%"
    echo ""
    
    print_status "$cpu_int" "$CPU_WARNING" "$CPU_CRITICAL" "CPU status: ${cpu_usage}%"
}

show_cpu_hogs() {
    print_info "Top CPU consumers:\n"
    
    ps aux | sort -rk 3,3 | head -11 | tail -10 | \
        awk '{printf "  %s%%\t%s\n", $3, $11}'
}

################################################################################
# Service Check
################################################################################

check_service() {
    local service_name="$1"
    local port="$2"
    
    if [[ -n "$port" ]]; then
        if lsof -i ":$port" &> /dev/null; then
            print_success "$service_name is running on port $port"
            return 0
        else
            print_error "$service_name is not running on port $port"
            return 1
        fi
    else
        if pgrep -f "$service_name" &> /dev/null; then
            print_success "$service_name is running"
            return 0
        else
            print_error "$service_name is not running"
            return 1
        fi
    fi
}

check_common_services() {
    print_info "Service Status:\n"
    
    # Docker
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null; then
            print_success "Docker is running"
        else
            print_warning "Docker is installed but not running"
        fi
    else
        print_info "Docker not installed"
    fi
    
    # PostgreSQL
    if command -v psql &> /dev/null; then
        if lsof -i :5432 &> /dev/null; then
            print_success "PostgreSQL is running"
        else
            print_warning "PostgreSQL is installed but not running"
        fi
    else
        print_info "PostgreSQL not installed"
    fi
    
    # MongoDB
    if command -v mongo &> /dev/null || command -v mongosh &> /dev/null; then
        if lsof -i :27017 &> /dev/null; then
            print_success "MongoDB is running"
        else
            print_warning "MongoDB is installed but not running"
        fi
    else
        print_info "MongoDB not installed"
    fi
    
    # Redis
    if command -v redis-cli &> /dev/null; then
        if lsof -i :6379 &> /dev/null; then
            print_success "Redis is running"
        else
            print_warning "Redis is installed but not running"
        fi
    else
        print_info "Redis not installed"
    fi
    
    # Nginx
    if command -v nginx &> /dev/null; then
        if pgrep nginx &> /dev/null; then
            print_success "Nginx is running"
        else
            print_warning "Nginx is installed but not running"
        fi
    else
        print_info "Nginx not installed"
    fi
}

################################################################################
# Network Check
################################################################################

check_network() {
    print_info "Network Status:\n"
    
    # Check internet connectivity
    if ping -c 1 8.8.8.8 &> /dev/null; then
        print_success "Internet connection active"
    else
        print_error "No internet connection"
    fi
    
    # Check DNS
    if ping -c 1 google.com &> /dev/null; then
        print_success "DNS resolution working"
    else
        print_error "DNS resolution failing"
    fi
}

show_network_connections() {
    print_info "Active network connections:\n"
    
    netstat -an | grep ESTABLISHED | head -10 | \
        awk '{print "  " $4 " -> " $5}'
}

show_listening_ports() {
    print_info "Listening ports:\n"
    
    lsof -i -P | grep LISTEN | \
        awk '{printf "  Port %s - %s\n", $9, $1}' | \
        sort -u | \
        head -20
}

################################################################################
# System Info
################################################################################

show_system_info() {
    print_info "System Information:\n"
    
    # macOS version
    local os_version=$(sw_vers -productVersion)
    echo "  OS: macOS $os_version"
    
    # Uptime
    local uptime=$(uptime | awk '{print $3 " " $4}' | sed 's/,//')
    echo "  Uptime: $uptime"
    
    # Hostname
    echo "  Hostname: $(hostname)"
    
    # CPU info
    local cpu_model=$(sysctl -n machdep.cpu.brand_string)
    local cpu_cores=$(sysctl -n hw.ncpu)
    echo "  CPU: $cpu_model ($cpu_cores cores)"
    
    # Memory
    local total_mem=$(sysctl -n hw.memsize | awk '{print $1/1073741824}')
    echo "  Memory: ${total_mem}GB"
}

################################################################################
# Health Report
################################################################################

generate_report() {
    local report_file="/tmp/health_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "System Health Report"
        echo "Generated: $(date)"
        echo "================================"
        echo ""
        
        echo "SYSTEM INFO"
        echo "----------"
        show_system_info
        echo ""
        
        echo "DISK SPACE"
        echo "----------"
        check_disk_space
        echo ""
        
        echo "MEMORY"
        echo "------"
        check_memory
        echo ""
        
        echo "CPU"
        echo "---"
        check_cpu
        echo ""
        
        echo "SERVICES"
        echo "--------"
        check_common_services
        echo ""
        
        echo "NETWORK"
        echo "-------"
        check_network
        echo ""
        
    } | tee "$report_file"
    
    print_success "Report saved: $report_file"
}

################################################################################
# Monitoring
################################################################################

monitor_continuous() {
    local interval="${1:-5}"
    
    print_info "Monitoring system (updates every ${interval}s, Ctrl+C to stop)...\n"
    
    while true; do
        clear
        print_header
        
        check_disk_space
        echo ""
        
        check_memory
        echo ""
        
        check_cpu
        echo ""
        
        echo "Last update: $(date)"
        
        sleep "$interval"
    done
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    echo -e "${CYAN}Health Check Options:${NC}"
    echo "  1) Full system check"
    echo "  2) Disk space check"
    echo "  3) Memory check"
    echo "  4) CPU check"
    echo "  5) Service status"
    echo "  6) Network check"
    echo "  7) Show memory hogs"
    echo "  8) Show CPU hogs"
    echo "  9) Show listening ports"
    echo "  10) Generate report"
    echo "  11) Continuous monitoring"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            show_system_info
            echo ""
            check_disk_space
            echo ""
            check_memory
            echo ""
            check_cpu
            echo ""
            check_common_services
            echo ""
            check_network
            ;;
        2)
            check_disk_space
            ;;
        3)
            check_memory
            show_memory_hogs
            ;;
        4)
            check_cpu
            show_cpu_hogs
            ;;
        5)
            check_common_services
            ;;
        6)
            check_network
            show_network_connections
            ;;
        7)
            show_memory_hogs
            ;;
        8)
            show_cpu_hogs
            ;;
        9)
            show_listening_ports
            ;;
        10)
            generate_report
            ;;
        11)
            read -p "Update interval (seconds, default: 5): " interval
            monitor_continuous "${interval:-5}"
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
    echo "  check                Full system health check"
    echo "  disk                 Check disk space"
    echo "  memory               Check memory usage"
    echo "  cpu                  Check CPU usage"
    echo "  services             Check common services"
    echo "  network              Check network status"
    echo "  report               Generate health report"
    echo "  monitor [INTERVAL]   Continuous monitoring"
    echo "  interactive          Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 check"
    echo "  $0 disk"
    echo "  $0 monitor 10"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    
    print_header
    
    case $command in
        check)
            show_system_info
            echo ""
            check_disk_space
            echo ""
            check_memory
            echo ""
            check_cpu
            echo ""
            check_common_services
            echo ""
            check_network
            ;;
        disk)
            check_disk_space
            ;;
        memory)
            check_memory
            echo ""
            show_memory_hogs
            ;;
        cpu)
            check_cpu
            echo ""
            show_cpu_hogs
            ;;
        services)
            check_common_services
            ;;
        network)
            check_network
            echo ""
            show_network_connections
            ;;
        report)
            generate_report
            ;;
        monitor)
            monitor_continuous "${2:-5}"
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
