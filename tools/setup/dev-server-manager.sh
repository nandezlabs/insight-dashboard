#!/bin/bash

################################################################################
# Development Server Manager
# Start, stop, and manage multiple development servers
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
STATE_FILE="$HOME/.dev_servers_state"
PROJECTS_DIR="$HOME/Developer/projects"
GAMES_DIR="$HOME/Developer/games"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🚀 Development Server Manager${NC}"
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

################################################################################
# Server Detection
################################################################################

detect_server_command() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/package.json" ]]; then
        # Check for dev script
        if grep -q "\"dev\":" "$project_dir/package.json"; then
            echo "npm run dev"
        elif grep -q "\"start\":" "$project_dir/package.json"; then
            echo "npm start"
        else
            echo ""
        fi
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        if grep -q "fastapi" "$project_dir/pyproject.toml" 2>/dev/null; then
            echo "poetry run uvicorn main:app --reload"
        elif grep -q "flask" "$project_dir/pyproject.toml" 2>/dev/null; then
            echo "poetry run flask run"
        else
            echo ""
        fi
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "cargo run"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "go run ."
    else
        echo ""
    fi
}

detect_server_port() {
    local project_dir="$1"
    
    # Check package.json for port
    if [[ -f "$project_dir/package.json" ]]; then
        # Check vite.config or next.config for port
        if [[ -f "$project_dir/vite.config.ts" ]]; then
            local port=$(grep -o "port: [0-9]*" "$project_dir/vite.config.ts" 2>/dev/null | grep -o "[0-9]*")
            [[ -n "$port" ]] && echo "$port" && return
        fi
        
        # Default ports by framework
        if grep -q "\"next\"" "$project_dir/package.json"; then
            echo "3000"
        elif grep -q "\"vite\"" "$project_dir/package.json"; then
            echo "3000"
        elif grep -q "\"fastify\"" "$project_dir/package.json"; then
            echo "3000"
        elif grep -q "\"express\"" "$project_dir/package.json"; then
            echo "3000"
        else
            echo "3000"
        fi
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        echo "8000"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "8080"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "8080"
    else
        echo "3000"
    fi
}

################################################################################
# State Management
################################################################################

save_server_state() {
    local project_name="$1"
    local project_dir="$2"
    local pid="$3"
    local port="$4"
    
    # Create or update state file
    touch "$STATE_FILE"
    
    # Remove existing entry
    grep -v "^$project_name:" "$STATE_FILE" > "$STATE_FILE.tmp" 2>/dev/null || true
    
    # Add new entry
    echo "$project_name:$project_dir:$pid:$port:$(date +%s)" >> "$STATE_FILE.tmp"
    mv "$STATE_FILE.tmp" "$STATE_FILE"
}

remove_server_state() {
    local project_name="$1"
    
    if [[ -f "$STATE_FILE" ]]; then
        grep -v "^$project_name:" "$STATE_FILE" > "$STATE_FILE.tmp" 2>/dev/null || true
        mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi
}

get_running_servers() {
    if [[ ! -f "$STATE_FILE" ]]; then
        return
    fi
    
    # Clean up stale entries
    while IFS=: read -r name dir pid port timestamp; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "$name:$dir:$pid:$port:$timestamp"
        fi
    done < "$STATE_FILE" > "$STATE_FILE.tmp"
    
    mv "$STATE_FILE.tmp" "$STATE_FILE"
    
    cat "$STATE_FILE" 2>/dev/null || true
}

################################################################################
# Server Operations
################################################################################

start_server() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    
    if [[ ! -d "$project_dir" ]]; then
        print_error "Project directory not found: $project_dir"
        return 1
    fi
    
    # Check if already running
    if get_running_servers | grep -q "^$project_name:"; then
        print_warning "$project_name is already running"
        return 0
    fi
    
    # Detect server command and port
    local command=$(detect_server_command "$project_dir")
    local port=$(detect_server_port "$project_dir")
    
    if [[ -z "$command" ]]; then
        print_error "No dev server command found for $project_name"
        return 1
    fi
    
    print_info "Starting $project_name on port $port..."
    
    # Check if port is available
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_error "Port $port is already in use"
        return 1
    fi
    
    # Start server in background
    cd "$project_dir"
    nohup bash -c "$command" > "/tmp/$project_name.log" 2>&1 &
    local pid=$!
    
    # Wait a bit and check if it's still running
    sleep 2
    if ! kill -0 "$pid" 2>/dev/null; then
        print_error "Failed to start server. Check /tmp/$project_name.log"
        return 1
    fi
    
    # Save state
    save_server_state "$project_name" "$project_dir" "$pid" "$port"
    
    print_success "$project_name started (PID: $pid)"
    print_info "URL: http://localhost:$port"
    print_info "Logs: /tmp/$project_name.log"
}

stop_server() {
    local project_name="$1"
    
    local server_info=$(get_running_servers | grep "^$project_name:")
    
    if [[ -z "$server_info" ]]; then
        print_error "$project_name is not running"
        return 1
    fi
    
    local pid=$(echo "$server_info" | cut -d: -f3)
    
    print_info "Stopping $project_name (PID: $pid)..."
    
    # Kill process and all children
    pkill -P "$pid" 2>/dev/null || true
    kill "$pid" 2>/dev/null || true
    
    # Wait for process to die
    local count=0
    while kill -0 "$pid" 2>/dev/null && [[ $count -lt 10 ]]; do
        sleep 0.5
        ((count++))
    done
    
    # Force kill if still alive
    if kill -0 "$pid" 2>/dev/null; then
        kill -9 "$pid" 2>/dev/null || true
    fi
    
    # Remove from state
    remove_server_state "$project_name"
    
    print_success "$project_name stopped"
}

restart_server() {
    local project_name="$1"
    
    local server_info=$(get_running_servers | grep "^$project_name:")
    
    if [[ -z "$server_info" ]]; then
        print_error "$project_name is not running"
        return 1
    fi
    
    local project_dir=$(echo "$server_info" | cut -d: -f2)
    
    stop_server "$project_name"
    sleep 1
    start_server "$project_dir"
}

list_servers() {
    local servers=$(get_running_servers)
    
    if [[ -z "$servers" ]]; then
        print_info "No servers running"
        return
    fi
    
    echo -e "${CYAN}Running Servers:${NC}\n"
    
    printf "%-30s %-10s %-10s %-20s\n" "Project" "PID" "Port" "Uptime"
    printf "%-30s %-10s %-10s %-20s\n" "-------" "---" "----" "------"
    
    while IFS=: read -r name dir pid port timestamp; do
        local uptime=$(($(date +%s) - timestamp))
        local uptime_str=$(format_uptime "$uptime")
        
        printf "${GREEN}%-30s${NC} %-10s %-10s %-20s\n" "$name" "$pid" "$port" "$uptime_str"
        printf "  ${YELLOW}└─${NC} http://localhost:$port\n"
    done <<< "$servers"
    
    echo ""
}

format_uptime() {
    local seconds=$1
    local minutes=$((seconds / 60))
    local hours=$((minutes / 60))
    local days=$((hours / 24))
    
    if [[ $days -gt 0 ]]; then
        echo "${days}d ${hours}h"
    elif [[ $hours -gt 0 ]]; then
        echo "${hours}h ${minutes}m"
    elif [[ $minutes -gt 0 ]]; then
        echo "${minutes}m"
    else
        echo "${seconds}s"
    fi
}

tail_logs() {
    local project_name="$1"
    local log_file="/tmp/$project_name.log"
    
    if [[ ! -f "$log_file" ]]; then
        print_error "No log file found for $project_name"
        return 1
    fi
    
    print_info "Tailing logs for $project_name (Ctrl+C to stop)..."
    echo ""
    tail -f "$log_file"
}

stop_all_servers() {
    local servers=$(get_running_servers)
    
    if [[ -z "$servers" ]]; then
        print_info "No servers running"
        return
    fi
    
    print_info "Stopping all servers..."
    
    while IFS=: read -r name dir pid port timestamp; do
        stop_server "$name"
    done <<< "$servers"
    
    print_success "All servers stopped"
}

################################################################################
# Interactive Selection
################################################################################

select_project_interactive() {
    local projects=()
    
    # Find all projects
    while IFS= read -r project_dir; do
        [[ ! -d "$project_dir" ]] && continue
        
        local command=$(detect_server_command "$project_dir")
        [[ -z "$command" ]] && continue
        
        projects+=("$project_dir")
    done < <(find "$PROJECTS_DIR" "$GAMES_DIR" -maxdepth 2 -type f \( -name "package.json" -o -name "pyproject.toml" \) -exec dirname {} \; 2>/dev/null | sort -u)
    
    if [[ ${#projects[@]} -eq 0 ]]; then
        print_error "No projects with dev servers found"
        return 1
    fi
    
    echo -e "${CYAN}Available Projects:${NC}\n"
    
    local index=1
    for project in "${projects[@]}"; do
        local name=$(basename "$project")
        local port=$(detect_server_port "$project")
        
        # Check if running
        if get_running_servers | grep -q "^$name:"; then
            printf "${GREEN}%2d) ● %-30s${NC} ${CYAN}(port %s)${NC}\n" "$index" "$name" "$port"
        else
            printf "${BLUE}%2d) ○ %-30s${NC} ${CYAN}(port %s)${NC}\n" "$index" "$name" "$port"
        fi
        
        ((index++))
    done
    
    echo ""
    read -p "Select project (1-${#projects[@]}): " selection
    
    if [[ $selection -ge 1 && $selection -le ${#projects[@]} ]]; then
        echo "${projects[$((selection-1))]}"
        return 0
    else
        print_error "Invalid selection"
        return 1
    fi
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  start [PROJECT]    Start development server"
    echo "  stop [PROJECT]     Stop development server"
    echo "  restart [PROJECT]  Restart development server"
    echo "  list               List running servers"
    echo "  logs [PROJECT]     Tail server logs"
    echo "  stop-all           Stop all running servers"
    echo ""
    echo "Examples:"
    echo "  $0 start ~/Developer/projects/my-app"
    echo "  $0 start               # Interactive selection"
    echo "  $0 stop my-app"
    echo "  $0 list"
    echo "  $0 logs my-app"
}

main() {
    local command="${1:-list}"
    
    print_header
    
    case $command in
        start)
            if [[ -n "$2" ]]; then
                # Resolve project path
                if [[ -d "$2" ]]; then
                    start_server "$2"
                else
                    # Try to find by name
                    local project_dir=$(find "$PROJECTS_DIR" "$GAMES_DIR" -maxdepth 1 -type d -name "$2" 2>/dev/null | head -1)
                    if [[ -n "$project_dir" ]]; then
                        start_server "$project_dir"
                    else
                        print_error "Project not found: $2"
                        exit 1
                    fi
                fi
            else
                # Interactive selection
                local selected=$(select_project_interactive)
                if [[ -n "$selected" ]]; then
                    start_server "$selected"
                fi
            fi
            ;;
        stop)
            if [[ -z "$2" ]]; then
                print_error "Project name required"
                exit 1
            fi
            stop_server "$2"
            ;;
        restart)
            if [[ -z "$2" ]]; then
                print_error "Project name required"
                exit 1
            fi
            restart_server "$2"
            ;;
        list)
            list_servers
            ;;
        logs)
            if [[ -z "$2" ]]; then
                print_error "Project name required"
                exit 1
            fi
            tail_logs "$2"
            ;;
        stop-all)
            stop_all_servers
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
