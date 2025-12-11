#!/bin/bash

################################################################################
# Project Switcher
# Quick navigation between active projects with fuzzy search and history
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
PROJECTS_DIR="$HOME/Developer/projects"
GAMES_DIR="$HOME/Developer/games"
HISTORY_FILE="$HOME/.project_history"
MAX_HISTORY=20

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🔄 Project Switcher${NC}"
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
# Project Discovery
################################################################################

find_projects() {
    local base_dir="$1"
    
    # Find directories with package.json, Cargo.toml, go.mod, pyproject.toml, etc.
    find "$base_dir" -maxdepth 2 -type f \( \
        -name "package.json" -o \
        -name "pyproject.toml" -o \
        -name "Cargo.toml" -o \
        -name "go.mod" -o \
        -name "Package.swift" -o \
        -name "project.godot" -o \
        -name "pom.xml" -o \
        -name "build.gradle" \
    \) -exec dirname {} \; 2>/dev/null | sort -u
}

get_all_projects() {
    {
        find_projects "$PROJECTS_DIR"
        find_projects "$GAMES_DIR"
    } | sort -u
}

get_project_type() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/package.json" ]]; then
        if grep -q "\"next\"" "$project_dir/package.json" 2>/dev/null; then
            echo "Next.js"
        elif grep -q "\"react\"" "$project_dir/package.json" 2>/dev/null; then
            echo "React"
        elif grep -q "\"fastify\"" "$project_dir/package.json" 2>/dev/null; then
            echo "Fastify"
        elif grep -q "\"express\"" "$project_dir/package.json" 2>/dev/null; then
            echo "Express"
        else
            echo "Node.js"
        fi
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        if grep -q "fastapi" "$project_dir/pyproject.toml" 2>/dev/null; then
            echo "FastAPI"
        elif grep -q "flask" "$project_dir/pyproject.toml" 2>/dev/null; then
            echo "Flask"
        else
            echo "Python"
        fi
    elif [[ -f "$project_dir/Package.swift" ]]; then
        echo "Swift"
    elif [[ -f "$project_dir/project.godot" ]]; then
        echo "Godot"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "Rust"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "Go"
    else
        echo "Unknown"
    fi
}

get_project_status() {
    local project_dir="$1"
    
    cd "$project_dir" 2>/dev/null || return
    
    if [[ -d ".git" ]]; then
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        
        if [[ $changes -gt 0 ]]; then
            echo -e "${YELLOW}●${NC} $branch ($changes changes)"
        else
            echo -e "${GREEN}●${NC} $branch"
        fi
    else
        echo -e "${CYAN}○${NC} No git"
    fi
}

get_last_modified() {
    local project_dir="$1"
    
    # Get the most recently modified file
    local last_file=$(find "$project_dir" -type f -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" -not -path "*/build/*" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    
    if [[ -n "$last_file" ]]; then
        local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$last_file" 2>/dev/null || stat -c "%y" "$last_file" 2>/dev/null | cut -d'.' -f1)
        echo "$mod_time"
    else
        echo "Unknown"
    fi
}

################################################################################
# History Management
################################################################################

add_to_history() {
    local project_path="$1"
    
    # Create history file if it doesn't exist
    touch "$HISTORY_FILE"
    
    # Remove existing entry for this project
    grep -v "^$project_path$" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" 2>/dev/null || true
    
    # Add to top
    echo "$project_path" | cat - "$HISTORY_FILE.tmp" > "$HISTORY_FILE"
    rm -f "$HISTORY_FILE.tmp"
    
    # Keep only last MAX_HISTORY entries
    head -n "$MAX_HISTORY" "$HISTORY_FILE" > "$HISTORY_FILE.tmp"
    mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}

get_recent_projects() {
    if [[ -f "$HISTORY_FILE" ]]; then
        cat "$HISTORY_FILE"
    fi
}

################################################################################
# Project Display
################################################################################

display_projects() {
    local projects=("$@")
    local index=1
    
    echo -e "${CYAN}Available Projects:${NC}\n"
    
    for project in "${projects[@]}"; do
        local name=$(basename "$project")
        local type=$(get_project_type "$project")
        local status=$(get_project_status "$project")
        local modified=$(get_last_modified "$project")
        
        printf "${BLUE}%2d)${NC} %-30s ${CYAN}[%s]${NC} %s\n" \
            "$index" "$name" "$type" "$status"
        printf "    ${YELLOW}└─${NC} Last modified: %s\n" "$modified"
        printf "    ${YELLOW}└─${NC} Path: %s\n\n" "$project"
        
        ((index++))
    done
}

display_recent_projects() {
    echo -e "${CYAN}Recent Projects:${NC}\n"
    
    local index=1
    while IFS= read -r project; do
        if [[ -d "$project" ]]; then
            local name=$(basename "$project")
            local type=$(get_project_type "$project")
            local status=$(get_project_status "$project")
            
            printf "${BLUE}%2d)${NC} %-30s ${CYAN}[%s]${NC} %s\n" \
                "$index" "$name" "$type" "$status"
            
            ((index++))
        fi
    done < <(get_recent_projects | head -10)
    
    echo ""
}

################################################################################
# Interactive Selection
################################################################################

select_project_interactive() {
    local projects=("$@")
    
    if [[ ${#projects[@]} -eq 0 ]]; then
        print_error "No projects found"
        return 1
    fi
    
    display_projects "${projects[@]}"
    
    echo -e "${BLUE}Commands:${NC}"
    echo "  1-${#projects[@]}  - Select project"
    echo "  r         - Show recent projects"
    echo "  s [term]  - Search projects"
    echo "  q         - Quit"
    echo ""
    
    while true; do
        read -p "Selection: " selection
        
        case $selection in
            q|Q)
                print_info "Cancelled"
                return 1
                ;;
            r|R)
                display_recent_projects
                continue
                ;;
            s|S)
                read -p "Search term: " search_term
                search_projects "$search_term"
                return $?
                ;;
            ''|*[!0-9]*)
                print_error "Invalid selection"
                continue
                ;;
            *)
                if [[ $selection -ge 1 && $selection -le ${#projects[@]} ]]; then
                    local selected_project="${projects[$((selection-1))]}"
                    switch_to_project "$selected_project"
                    return 0
                else
                    print_error "Invalid number. Choose 1-${#projects[@]}"
                fi
                ;;
        esac
    done
}

search_projects() {
    local search_term="$1"
    
    echo -e "\n${CYAN}Searching for: ${YELLOW}$search_term${NC}\n"
    
    local matching_projects=()
    while IFS= read -r project; do
        local name=$(basename "$project")
        if [[ "$name" == *"$search_term"* ]]; then
            matching_projects+=("$project")
        fi
    done < <(get_all_projects)
    
    if [[ ${#matching_projects[@]} -eq 0 ]]; then
        print_error "No projects found matching '$search_term'"
        return 1
    fi
    
    select_project_interactive "${matching_projects[@]}"
}

################################################################################
# Project Switching
################################################################################

switch_to_project() {
    local project_path="$1"
    
    if [[ ! -d "$project_path" ]]; then
        print_error "Project directory not found: $project_path"
        return 1
    fi
    
    local project_name=$(basename "$project_path")
    local project_type=$(get_project_type "$project_path")
    
    # Add to history
    add_to_history "$project_path"
    
    # Open in VS Code
    print_info "Opening $project_name in VS Code..."
    code "$project_path"
    
    # Change directory in a new terminal or print command
    print_success "Project: $project_name ($project_type)"
    print_info "Path: $project_path"
    
    echo -e "\n${BLUE}To navigate in terminal:${NC}"
    echo -e "${GREEN}cd $project_path${NC}"
    
    # Check for dev server
    if [[ -f "$project_path/package.json" ]]; then
        echo -e "\n${BLUE}Start dev server:${NC}"
        echo -e "${GREEN}npm run dev${NC}"
    elif [[ -f "$project_path/pyproject.toml" ]]; then
        echo -e "\n${BLUE}Activate environment:${NC}"
        echo -e "${GREEN}poetry shell${NC}"
    fi
    
    # Git status
    if [[ -d "$project_path/.git" ]]; then
        echo -e "\n${BLUE}Git Status:${NC}"
        cd "$project_path"
        git status -sb
    fi
    
    echo ""
}

################################################################################
# Quick Actions
################################################################################

show_project_info() {
    local project_path="$1"
    
    echo -e "\n${BLUE}Project Information:${NC}\n"
    
    local name=$(basename "$project_path")
    local type=$(get_project_type "$project_path")
    
    echo "  Name:     $name"
    echo "  Type:     $type"
    echo "  Path:     $project_path"
    echo ""
    
    # Git info
    if [[ -d "$project_path/.git" ]]; then
        cd "$project_path"
        echo -e "${BLUE}Git Information:${NC}"
        echo "  Branch:   $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        echo "  Commits:  $(git rev-list --count HEAD 2>/dev/null)"
        echo "  Remote:   $(git remote get-url origin 2>/dev/null || echo 'None')"
        echo ""
    fi
    
    # Dependencies info
    if [[ -f "$project_path/package.json" ]]; then
        echo -e "${BLUE}Node.js Dependencies:${NC}"
        local deps=$(grep -c "\".*\":.*\"" "$project_path/package.json" 2>/dev/null || echo 0)
        echo "  Total:    $deps"
        
        if [[ -d "$project_path/node_modules" ]]; then
            local size=$(du -sh "$project_path/node_modules" 2>/dev/null | cut -f1)
            echo "  Size:     $size"
        fi
        echo ""
    elif [[ -f "$project_path/pyproject.toml" ]]; then
        echo -e "${BLUE}Python Dependencies:${NC}"
        grep "^\[tool.poetry.dependencies\]" -A 20 "$project_path/pyproject.toml" | grep "=" | wc -l | xargs echo "  Total:"
        echo ""
    fi
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -l, --list         List all projects"
    echo "  -r, --recent       Show recent projects"
    echo "  -s, --search TERM  Search for projects"
    echo "  -i, --info PATH    Show project information"
    echo "  -h, --help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                 # Interactive mode"
    echo "  $0 -l              # List all projects"
    echo "  $0 -r              # Show recent projects"
    echo "  $0 -s my-app       # Search for 'my-app'"
}

main() {
    local mode="interactive"
    local search_term=""
    local info_path=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -l|--list)
                mode="list"
                shift
                ;;
            -r|--recent)
                mode="recent"
                shift
                ;;
            -s|--search)
                mode="search"
                search_term="$2"
                shift 2
                ;;
            -i|--info)
                mode="info"
                info_path="$2"
                shift 2
                ;;
            -h|--help)
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
    
    case $mode in
        list)
            local all_projects=()
            while IFS= read -r project; do
                all_projects+=("$project")
            done < <(get_all_projects)
            display_projects "${all_projects[@]}"
            ;;
        recent)
            display_recent_projects
            ;;
        search)
            if [[ -z "$search_term" ]]; then
                print_error "Search term required"
                exit 1
            fi
            search_projects "$search_term"
            ;;
        info)
            if [[ -z "$info_path" ]]; then
                print_error "Project path required"
                exit 1
            fi
            show_project_info "$info_path"
            ;;
        interactive)
            # Check for fzf (optional fuzzy finder)
            if command -v fzf &> /dev/null; then
                print_info "Using fzf for fuzzy search..."
                local selected=$(get_all_projects | fzf --height 50% --reverse --header "Select a project:")
                if [[ -n "$selected" ]]; then
                    switch_to_project "$selected"
                fi
            else
                # Fall back to manual selection
                mapfile -t all_projects < <(get_all_projects)
                select_project_interactive "${all_projects[@]}"
            fi
            ;;
    esac
}

main "$@"
