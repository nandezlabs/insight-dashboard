#!/bin/bash

################################################################################
# Development Dashboard
# Real-time overview of development environment and projects
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

print_header() {
    clear
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}               Development Dashboard                    ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_box_header() {
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${WHITE} $1${NC}"
    echo -e "${CYAN}├───────────────────────────────────────────────────────────┤${NC}"
}

print_box_footer() {
    echo -e "${CYAN}└───────────────────────────────────────────────────────────┘${NC}"
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
# System Status
################################################################################

show_system_status() {
    print_box_header "System Status"
    
    # Hostname and user
    echo -e "  ${CYAN}User:${NC}     $(whoami)@$(hostname)"
    echo -e "  ${CYAN}OS:${NC}       $(sw_vers -productName) $(sw_vers -productVersion)"
    echo ""
    
    # CPU
    local cpu_usage=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
    local cpu_cores=$(sysctl -n hw.ncpu)
    local cpu_percent=$(echo "scale=1; $cpu_usage / $cpu_cores" | bc)
    
    if (( $(echo "$cpu_percent < 50" | bc -l) )); then
        echo -e "  ${CYAN}CPU:${NC}      ${GREEN}${cpu_percent}%${NC} ($cpu_cores cores)"
    elif (( $(echo "$cpu_percent < 80" | bc -l) )); then
        echo -e "  ${CYAN}CPU:${NC}      ${YELLOW}${cpu_percent}%${NC} ($cpu_cores cores)"
    else
        echo -e "  ${CYAN}CPU:${NC}      ${RED}${cpu_percent}%${NC} ($cpu_cores cores)"
    fi
    
    # Memory
    local mem_total=$(sysctl -n hw.memsize)
    local mem_total_gb=$(echo "scale=1; $mem_total / 1024 / 1024 / 1024" | bc)
    local mem_used=$(ps -A -o rss | awk '{s+=$1} END {print s}')
    local mem_used_gb=$(echo "scale=1; $mem_used / 1024 / 1024" | bc)
    local mem_percent=$(echo "scale=1; ($mem_used_gb / $mem_total_gb) * 100" | bc)
    
    if (( $(echo "$mem_percent < 70" | bc -l) )); then
        echo -e "  ${CYAN}Memory:${NC}   ${GREEN}${mem_used_gb}GB${NC} / ${mem_total_gb}GB (${mem_percent}%)"
    elif (( $(echo "$mem_percent < 85" | bc -l) )); then
        echo -e "  ${CYAN}Memory:${NC}   ${YELLOW}${mem_used_gb}GB${NC} / ${mem_total_gb}GB (${mem_percent}%)"
    else
        echo -e "  ${CYAN}Memory:${NC}   ${RED}${mem_used_gb}GB${NC} / ${mem_total_gb}GB (${mem_percent}%)"
    fi
    
    # Disk
    local disk_info=$(df -h "$HOME" | tail -n 1)
    local disk_used=$(echo "$disk_info" | awk '{print $3}')
    local disk_total=$(echo "$disk_info" | awk '{print $2}')
    local disk_percent=$(echo "$disk_info" | awk '{print $5}' | tr -d '%')
    
    if [[ $disk_percent -lt 70 ]]; then
        echo -e "  ${CYAN}Disk:${NC}     ${GREEN}${disk_used}${NC} / ${disk_total} (${disk_percent}%)"
    elif [[ $disk_percent -lt 85 ]]; then
        echo -e "  ${CYAN}Disk:${NC}     ${YELLOW}${disk_used}${NC} / ${disk_total} (${disk_percent}%)"
    else
        echo -e "  ${CYAN}Disk:${NC}     ${RED}${disk_used}${NC} / ${disk_total} (${disk_percent}%)"
    fi
    
    # Uptime
    local uptime_info=$(uptime | sed 's/.*up //' | sed 's/,.*//')
    echo -e "  ${CYAN}Uptime:${NC}   $uptime_info"
    
    echo ""
    print_box_footer
    echo ""
}

################################################################################
# Projects Overview
################################################################################

show_projects_overview() {
    local workspace_dir="${1:-$HOME/Developer}"
    
    print_box_header "Projects Overview"
    
    # Count projects
    local total_projects=0
    local git_projects=0
    local active_repos=0
    
    while IFS= read -r project_dir; do
        ((total_projects++))
        
        if [[ -d "$project_dir/.git" ]]; then
            ((git_projects++))
            
            cd "$project_dir"
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                ((active_repos++))
            fi
        fi
    done < <(find "$workspace_dir/projects" -type d -maxdepth 1 -mindepth 1 -not -name ".*" 2>/dev/null)
    
    echo -e "  ${CYAN}Total Projects:${NC}     $total_projects"
    echo -e "  ${CYAN}Git Repositories:${NC}   $git_projects"
    echo -e "  ${CYAN}With Changes:${NC}       $active_repos"
    echo ""
    
    # Recent projects
    echo -e "  ${CYAN}Recent Projects:${NC}"
    find "$workspace_dir/projects" -type d -maxdepth 1 -mindepth 1 -not -name ".*" 2>/dev/null | \
        xargs ls -dt 2>/dev/null | head -n 5 | while read dir; do
        local project_name=$(basename "$dir")
        local last_modified=$(stat -f "%Sm" -t "%Y-%m-%d" "$dir" 2>/dev/null)
        
        if [[ -d "$dir/.git" ]]; then
            cd "$dir"
            local branch=$(git branch --show-current 2>/dev/null || echo "")
            local has_changes=""
            [[ -n $(git status --porcelain 2>/dev/null) ]] && has_changes="${YELLOW}*${NC}"
            
            echo -e "    ${GREEN}•${NC} $project_name ${has_changes}${CYAN}($branch)${NC} - $last_modified"
        else
            echo -e "    ${BLUE}•${NC} $project_name - $last_modified"
        fi
    done
    
    echo ""
    print_box_footer
    echo ""
}

################################################################################
# Active Services
################################################################################

show_active_services() {
    print_box_header "Active Development Services"
    
    local services_found=false
    
    # Node dev servers
    if pgrep -f "next dev\|vite\|npm run dev\|node.*server" >/dev/null 2>&1; then
        echo -e "  ${CYAN}Node.js Servers:${NC}"
        pgrep -lf "next dev\|vite\|npm run dev" 2>/dev/null | while read pid cmd; do
            local port=$(lsof -nP -p "$pid" 2>/dev/null | grep LISTEN | awk '{print $9}' | cut -d: -f2 | head -n 1)
            if [[ -n "$port" ]]; then
                echo -e "    ${GREEN}•${NC} PID $pid - Port $port"
            else
                echo -e "    ${GREEN}•${NC} PID $pid"
            fi
            services_found=true
        done
        echo ""
    fi
    
    # Python servers
    if pgrep -f "python.*manage.py\|flask run\|uvicorn\|gunicorn" >/dev/null 2>&1; then
        echo -e "  ${CYAN}Python Servers:${NC}"
        pgrep -lf "python.*manage.py\|flask run\|uvicorn\|gunicorn" 2>/dev/null | while read pid cmd; do
            local port=$(lsof -nP -p "$pid" 2>/dev/null | grep LISTEN | awk '{print $9}' | cut -d: -f2 | head -n 1)
            if [[ -n "$port" ]]; then
                echo -e "    ${GREEN}•${NC} PID $pid - Port $port"
            else
                echo -e "    ${GREEN}•${NC} PID $pid"
            fi
            services_found=true
        done
        echo ""
    fi
    
    # Databases
    if pgrep -f "postgres\|mysql\|mongod" >/dev/null 2>&1; then
        echo -e "  ${CYAN}Databases:${NC}"
        pgrep -l "postgres" 2>/dev/null | head -n 1 | while read pid cmd; do
            echo -e "    ${GREEN}•${NC} PostgreSQL (PID $pid)"
            services_found=true
        done
        pgrep -l "mysql" 2>/dev/null | head -n 1 | while read pid cmd; do
            echo -e "    ${GREEN}•${NC} MySQL (PID $pid)"
            services_found=true
        done
        pgrep -l "mongod" 2>/dev/null | head -n 1 | while read pid cmd; do
            echo -e "    ${GREEN}•${NC} MongoDB (PID $pid)"
            services_found=true
        done
        echo ""
    fi
    
    # Docker
    if command -v docker >/dev/null 2>&1; then
        local running_containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
        if [[ $running_containers -gt 0 ]]; then
            echo -e "  ${CYAN}Docker:${NC}"
            echo -e "    ${GREEN}•${NC} $running_containers running container(s)"
            services_found=true
            echo ""
        fi
    fi
    
    if [[ "$services_found" == false ]]; then
        echo -e "  ${YELLOW}No active development services${NC}"
        echo ""
    fi
    
    print_box_footer
    echo ""
}

################################################################################
# Git Status Summary
################################################################################

show_git_summary() {
    local workspace_dir="${1:-$HOME/Developer}"
    
    print_box_header "Git Status Summary"
    
    local repos_with_changes=()
    local repos_unpushed=()
    
    while IFS= read -r project_dir; do
        if [[ -d "$project_dir/.git" ]]; then
            cd "$project_dir"
            local project_name=$(basename "$project_dir")
            
            # Check for uncommitted changes
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                repos_with_changes+=("$project_name")
            fi
            
            # Check for unpushed commits
            local unpushed=$(git log @{u}.. --oneline 2>/dev/null | wc -l | tr -d ' ')
            if [[ $unpushed -gt 0 ]]; then
                repos_unpushed+=("$project_name ($unpushed)")
            fi
        fi
    done < <(find "$workspace_dir/projects" -type d -maxdepth 1 -mindepth 1 -not -name ".*" 2>/dev/null)
    
    if [[ ${#repos_with_changes[@]} -gt 0 ]]; then
        echo -e "  ${YELLOW}Uncommitted Changes:${NC}"
        for repo in "${repos_with_changes[@]}"; do
            echo -e "    ${YELLOW}•${NC} $repo"
        done
        echo ""
    fi
    
    if [[ ${#repos_unpushed[@]} -gt 0 ]]; then
        echo -e "  ${CYAN}Unpushed Commits:${NC}"
        for repo in "${repos_unpushed[@]}"; do
            echo -e "    ${CYAN}•${NC} $repo"
        done
        echo ""
    fi
    
    if [[ ${#repos_with_changes[@]} -eq 0 ]] && [[ ${#repos_unpushed[@]} -eq 0 ]]; then
        echo -e "  ${GREEN}All repositories clean and pushed${NC}"
        echo ""
    fi
    
    print_box_footer
    echo ""
}

################################################################################
# Quick Actions
################################################################################

show_quick_actions() {
    print_box_header "Quick Actions"
    
    echo -e "  ${MAGENTA}1.${NC} Create new project       ${MAGENTA}6.${NC} Backup projects"
    echo -e "  ${MAGENTA}2.${NC} Deploy project           ${MAGENTA}7.${NC} Check system health"
    echo -e "  ${MAGENTA}3.${NC} Run tests                ${MAGENTA}8.${NC} Update dependencies"
    echo -e "  ${MAGENTA}4.${NC} Code quality check       ${MAGENTA}9.${NC} View logs"
    echo -e "  ${MAGENTA}5.${NC} Create release           ${MAGENTA}0.${NC} Open project"
    echo ""
    echo -e "  ${MAGENTA}r.${NC} Refresh dashboard        ${MAGENTA}q.${NC} Quit"
    echo ""
    
    print_box_footer
}

################################################################################
# Interactive Dashboard
################################################################################

handle_action() {
    local action="$1"
    local workspace_dir="$2"
    
    case $action in
        1)
            "$HOME/Developer/tools/orchestration/dev-master.sh" workflow new
            read -p "Press Enter to continue..."
            ;;
        2)
            read -p "Project directory: " proj_dir
            proj_dir="${proj_dir:-$workspace_dir/projects}"
            "$HOME/Developer/tools/orchestration/dev-master.sh" workflow deploy "$proj_dir"
            read -p "Press Enter to continue..."
            ;;
        3)
            read -p "Project directory: " proj_dir
            proj_dir="${proj_dir:-$workspace_dir/projects}"
            "$HOME/Developer/tools/ci-cd/test-runner.sh" interactive "$proj_dir"
            ;;
        4)
            read -p "Project directory: " proj_dir
            proj_dir="${proj_dir:-$workspace_dir/projects}"
            "$HOME/Developer/tools/ci-cd/code-quality-checker.sh" interactive "$proj_dir"
            ;;
        5)
            read -p "Project directory: " proj_dir
            proj_dir="${proj_dir:-$workspace_dir/projects}"
            "$HOME/Developer/tools/orchestration/release-manager.sh" interactive "$proj_dir"
            ;;
        6)
            "$HOME/Developer/tools/maintenance/backup-manager.sh" --backup "$workspace_dir"
            read -p "Press Enter to continue..."
            ;;
        7)
            "$HOME/Developer/tools/maintenance/health-checker.sh" --check
            read -p "Press Enter to continue..."
            ;;
        8)
            "$HOME/Developer/tools/setup/dependency-updater.sh" interactive
            ;;
        9)
            "$HOME/Developer/tools/maintenance/log-rotator.sh" --analyze
            read -p "Press Enter to continue..."
            ;;
        0)
            "$HOME/Developer/tools/setup/project-switcher.sh" interactive
            ;;
        r|R)
            # Just return to refresh
            ;;
        q|Q)
            echo ""
            echo -e "${GREEN}Goodbye! 👋${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid selection${NC}"
            sleep 1
            ;;
    esac
}

interactive_dashboard() {
    local workspace_dir="${1:-$HOME/Developer}"
    
    while true; do
        print_header
        show_system_status
        show_projects_overview "$workspace_dir"
        show_active_services
        show_git_summary "$workspace_dir"
        show_quick_actions
        
        read -n 1 -p "Select action: " action
        echo ""
        
        if [[ "$action" == "q" ]] || [[ "$action" == "Q" ]]; then
            echo ""
            echo -e "${GREEN}Goodbye! 👋${NC}"
            exit 0
        fi
        
        handle_action "$action" "$workspace_dir"
    done
}

################################################################################
# Watch Mode
################################################################################

watch_mode() {
    local workspace_dir="${1:-$HOME/Developer}"
    local interval="${2:-5}"
    
    while true; do
        print_header
        show_system_status
        show_projects_overview "$workspace_dir"
        show_active_services
        show_git_summary "$workspace_dir"
        
        echo -e "${CYAN}Refreshing every ${interval}s... (Ctrl+C to stop)${NC}"
        sleep "$interval"
    done
}

################################################################################
# Export Dashboard Data
################################################################################

export_dashboard() {
    local workspace_dir="${1:-$HOME/Developer}"
    local output_file="$workspace_dir/dashboard-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "Development Dashboard Export"
        echo "Generated: $(date)"
        echo ""
        echo "=========================================="
        show_system_status
        show_projects_overview "$workspace_dir"
        show_active_services
        show_git_summary "$workspace_dir"
    } > "$output_file"
    
    echo "Dashboard exported to: $output_file"
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  interactive [DIR]         Interactive dashboard (default)"
    echo "  watch [DIR] [INTERVAL]    Watch mode (refresh every N seconds)"
    echo "  export [DIR]              Export dashboard to file"
    echo "  system                    Show system status only"
    echo "  projects [DIR]            Show projects overview only"
    echo "  services                  Show active services only"
    echo "  git [DIR]                 Show git summary only"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 watch ~/Developer 10"
    echo "  $0 export"
    echo "  $0 system"
}

main() {
    local command="${1:-interactive}"
    local workspace_dir="${2:-$HOME/Developer}"
    
    case $command in
        interactive)
            interactive_dashboard "$workspace_dir"
            ;;
        watch)
            local interval="${3:-5}"
            watch_mode "$workspace_dir" "$interval"
            ;;
        export)
            export_dashboard "$workspace_dir"
            ;;
        system)
            print_header
            show_system_status
            ;;
        projects)
            print_header
            show_projects_overview "$workspace_dir"
            ;;
        services)
            print_header
            show_active_services
            ;;
        git)
            print_header
            show_git_summary "$workspace_dir"
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            # If not a command, treat as workspace dir
            interactive_dashboard "$command"
            ;;
    esac
}

main "$@"
