#!/bin/bash

################################################################################
# Dependency Updater
# Check and update dependencies across all projects
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PROJECTS_DIR="$HOME/Developer/projects"
GAMES_DIR="$HOME/Developer/games"
REPORT_FILE="/tmp/dependency_report_$(date +%Y%m%d_%H%M%S).txt"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📦 Dependency Updater${NC}"
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
# Project Discovery
################################################################################

find_all_projects() {
    {
        find "$PROJECTS_DIR" "$GAMES_DIR" -maxdepth 2 -type f -name "package.json" -exec dirname {} \; 2>/dev/null
        find "$PROJECTS_DIR" "$GAMES_DIR" -maxdepth 2 -type f -name "pyproject.toml" -exec dirname {} \; 2>/dev/null
        find "$PROJECTS_DIR" "$GAMES_DIR" -maxdepth 2 -type f -name "Cargo.toml" -exec dirname {} \; 2>/dev/null
        find "$PROJECTS_DIR" "$GAMES_DIR" -maxdepth 2 -type f -name "go.mod" -exec dirname {} \; 2>/dev/null
    } | sort -u
}

get_project_type() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/package.json" ]]; then
        echo "node"
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$project_dir/go.mod" ]]; then
        echo "go"
    else
        echo "unknown"
    fi
}

################################################################################
# Node.js Projects
################################################################################

check_node_outdated() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    
    cd "$project_dir" || return 1
    
    if [[ ! -f "package.json" ]]; then
        return 1
    fi
    
    print_info "Checking $project_name (Node.js)..." >&2
    
    # Check if node_modules exists
    if [[ ! -d "node_modules" ]]; then
        print_warning "  No node_modules - run npm install first" >&2
        echo "0"
        return 0
    fi
    
    # Run npm outdated
    local outdated=$(npm outdated --json 2>/dev/null || echo "{}")
    
    if [[ "$outdated" == "{}" ]]; then
        print_success "  All dependencies up to date" >&2
        echo "0"
        return 0
    fi
    
    # Parse and display outdated packages
    local count=0
    while IFS= read -r line; do
        local pkg=$(echo "$line" | jq -r '.package')
        local current=$(echo "$line" | jq -r '.current')
        local wanted=$(echo "$line" | jq -r '.wanted')
        local latest=$(echo "$line" | jq -r '.latest')
        
        if [[ "$current" != "$latest" ]]; then
            ((count++))
            
            if [[ "$current" != "$wanted" ]]; then
                # Minor/patch update available
                echo -e "  ${YELLOW}↑${NC} $pkg: ${RED}$current${NC} → ${GREEN}$wanted${NC} (latest: $latest)" >&2
            else
                # Major update available
                echo -e "  ${MAGENTA}⇡${NC} $pkg: ${RED}$current${NC} → ${BLUE}$latest${NC} (major)" >&2
            fi
        fi
    done < <(echo "$outdated" | jq -c 'to_entries[] | {package: .key, current: .value.current, wanted: .value.wanted, latest: .value.latest}')
    
    if [[ $count -gt 0 ]]; then
        echo -e "  ${CYAN}Total outdated: $count${NC}\n"
    fi
    
    echo "$count"
}

update_node_dependencies() {
    local project_dir="$1"
    local mode="${2:-safe}"  # safe or major
    
    cd "$project_dir" || return 1
    
    local project_name=$(basename "$project_dir")
    print_info "Updating $project_name dependencies..."
    
    case $mode in
        safe)
            # Update within semver range
            npm update
            print_success "  Safe updates applied"
            ;;
        major)
            # Update to latest including major versions
            if command -v npx &> /dev/null; then
                npx npm-check-updates -u
                npm install
                print_success "  Major updates applied - review breaking changes!"
            else
                print_error "  npm-check-updates not available"
                print_info "  Install with: npm install -g npm-check-updates"
            fi
            ;;
    esac
}

audit_node_security() {
    local project_dir="$1"
    
    cd "$project_dir" || return 1
    
    local project_name=$(basename "$project_dir")
    print_info "Auditing $project_name for vulnerabilities..."
    
    local audit_output=$(npm audit --json 2>/dev/null || echo '{"metadata":{"vulnerabilities":{"total":0}}}')
    local total=$(echo "$audit_output" | jq -r '.metadata.vulnerabilities.total')
    local critical=$(echo "$audit_output" | jq -r '.metadata.vulnerabilities.critical // 0')
    local high=$(echo "$audit_output" | jq -r '.metadata.vulnerabilities.high // 0')
    local moderate=$(echo "$audit_output" | jq -r '.metadata.vulnerabilities.moderate // 0')
    local low=$(echo "$audit_output" | jq -r '.metadata.vulnerabilities.low // 0')
    
    if [[ $total -eq 0 ]]; then
        print_success "  No vulnerabilities found"
    else
        echo -e "  ${RED}Vulnerabilities found: $total${NC}"
        [[ $critical -gt 0 ]] && echo -e "    ${RED}Critical: $critical${NC}"
        [[ $high -gt 0 ]] && echo -e "    ${YELLOW}High: $high${NC}"
        [[ $moderate -gt 0 ]] && echo -e "    ${YELLOW}Moderate: $moderate${NC}"
        [[ $low -gt 0 ]] && echo -e "    ${CYAN}Low: $low${NC}"
        
        echo -e "\n  ${YELLOW}Run 'npm audit fix' to fix automatically${NC}"
    fi
    
    echo ""
}

################################################################################
# Python Projects
################################################################################

check_python_outdated() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    
    cd "$project_dir" || return 1
    
    if [[ ! -f "pyproject.toml" ]]; then
        return 1
    fi
    
    print_info "Checking $project_name (Python)..." >&2
    
    if ! command -v poetry &> /dev/null; then
        print_warning "  Poetry not installed" >&2
        echo "0"
        return 0
    fi
    
    # Check for outdated packages
    local outdated=$(poetry show --outdated 2>/dev/null || echo "")
    
    if [[ -z "$outdated" ]]; then
        print_success "  All dependencies up to date" >&2
        echo "0"
        return 0
    fi
    
    local count=0
    while IFS= read -r line; do
        # Parse poetry show output
        local pkg=$(echo "$line" | awk '{print $1}')
        local current=$(echo "$line" | awk '{print $2}')
        local latest=$(echo "$line" | awk '{print $3}')
        
        if [[ -n "$pkg" && "$pkg" != "Warning:" ]]; then
            ((count++))
            echo -e "  ${YELLOW}↑${NC} $pkg: ${RED}$current${NC} → ${GREEN}$latest${NC}" >&2
        fi
    done <<< "$outdated"
    
    if [[ $count -gt 0 ]]; then
        echo -e "  ${CYAN}Total outdated: $count${NC}\n" >&2
    fi
    
    echo "$count"
}

update_python_dependencies() {
    local project_dir="$1"
    
    cd "$project_dir" || return 1
    
    local project_name=$(basename "$project_dir")
    print_info "Updating $project_name dependencies..."
    
    if ! command -v poetry &> /dev/null; then
        print_error "  Poetry not installed"
        return 1
    fi
    
    poetry update
    print_success "  Dependencies updated"
}

################################################################################
# Rust Projects
################################################################################

check_rust_outdated() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    
    cd "$project_dir" || return 1
    
    if [[ ! -f "Cargo.toml" ]]; then
        return 1
    fi
    
    print_info "Checking $project_name (Rust)..." >&2
    
    if ! command -v cargo &> /dev/null; then
        print_warning "  Cargo not installed" >&2
        echo "0"
        return 0
    fi
    
    # Check for outdated crates
    if command -v cargo-outdated &> /dev/null; then
        cargo outdated | tail -n +3 | head -n -1 | while read -r line; do
            [[ -z "$line" ]] && continue
            echo -e "  ${YELLOW}↑${NC} $line" >&2
        done
    else
        print_info "  Install cargo-outdated: cargo install cargo-outdated" >&2
    fi
    
    echo "" >&2
    echo "0"
}

update_rust_dependencies() {
    local project_dir="$1"
    
    cd "$project_dir" || return 1
    
    local project_name=$(basename "$project_dir")
    print_info "Updating $project_name dependencies..."
    
    cargo update
    print_success "  Dependencies updated"
}

################################################################################
# Bulk Operations
################################################################################

scan_all_projects() {
    local mode="${1:-check}"  # check or report
    
    print_info "Scanning all projects...\n"
    
    local total_projects=0
    local projects_with_updates=0
    local total_updates=0
    
    # Start report
    if [[ "$mode" == "report" ]]; then
        {
            echo "Dependency Report - $(date)"
            echo "================================"
            echo ""
        } > "$REPORT_FILE"
    fi
    
    while IFS= read -r project_dir; do
        [[ ! -d "$project_dir" ]] && continue
        
        local project_type=$(get_project_type "$project_dir")
        ((total_projects++))
        
        local count=0
        case $project_type in
            node)
                count=$(check_node_outdated "$project_dir" 2>&1 >/dev/null | tail -1 || echo "0")
                ;;
            python)
                count=$(check_python_outdated "$project_dir" 2>&1 >/dev/null | tail -1 || echo "0")
                ;;
            rust)
                count=$(check_rust_outdated "$project_dir" 2>&1 >/dev/null | tail -1 || echo "0")
                ;;
        esac
        
        # Sanitize count - ensure it's a valid number
        count=$(echo "$count" | grep -o '^[0-9]\+$' || echo "0")
        
        if [[ $count -gt 0 ]]; then
            ((projects_with_updates++))
            ((total_updates += count))
        fi
        
    done < <(find_all_projects)
    
    echo ""
    print_info "Summary:"
    echo "  Total projects: $total_projects"
    echo "  Projects with updates: $projects_with_updates"
    echo "  Total outdated packages: $total_updates"
    
    if [[ "$mode" == "report" ]]; then
        echo ""
        print_success "Report saved: $REPORT_FILE"
    fi
}

update_all_projects() {
    local mode="${1:-safe}"
    
    print_warning "This will update dependencies in ALL projects"
    read -p "Continue? (y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        return 0
    fi
    
    echo ""
    
    while IFS= read -r project_dir; do
        [[ ! -d "$project_dir" ]] && continue
        
        local project_type=$(get_project_type "$project_dir")
        
        case $project_type in
            node)
                update_node_dependencies "$project_dir" "$mode"
                ;;
            python)
                update_python_dependencies "$project_dir"
                ;;
            rust)
                update_rust_dependencies "$project_dir"
                ;;
        esac
        
        echo ""
    done < <(find_all_projects)
    
    print_success "All projects updated"
}

audit_all_projects() {
    print_info "Running security audits...\n"
    
    while IFS= read -r project_dir; do
        [[ ! -d "$project_dir" ]] && continue
        
        local project_type=$(get_project_type "$project_dir")
        
        if [[ "$project_type" == "node" ]]; then
            audit_node_security "$project_dir"
        fi
    done < <(find_all_projects)
    
    print_success "Security audit complete"
}

################################################################################
# Interactive Update
################################################################################

interactive_update() {
    local projects=()
    
    # Build project list
    while IFS= read -r project_dir; do
        [[ ! -d "$project_dir" ]] && continue
        projects+=("$project_dir")
    done < <(find_all_projects)
    
    if [[ ${#projects[@]} -eq 0 ]]; then
        print_error "No projects found"
        return 1
    fi
    
    echo -e "${CYAN}Select projects to update:${NC}\n"
    
    local index=1
    for project in "${projects[@]}"; do
        local name=$(basename "$project")
        local type=$(get_project_type "$project")
        printf "${BLUE}%2d)${NC} %-30s ${CYAN}[%s]${NC}\n" "$index" "$name" "$type"
        ((index++))
    done
    
    echo ""
    echo -e "${BLUE}Commands:${NC}"
    echo "  1-${#projects[@]}  - Select project"
    echo "  all       - Update all projects"
    echo "  audit     - Run security audit"
    echo "  q         - Quit"
    echo ""
    
    read -p "Selection: " selection
    
    case $selection in
        q|Q)
            print_info "Cancelled"
            return 0
            ;;
        all)
            update_all_projects "safe"
            ;;
        audit)
            audit_all_projects
            ;;
        *)
            if [[ $selection -ge 1 && $selection -le ${#projects[@]} ]]; then
                local selected_project="${projects[$((selection-1))]}"
                local project_type=$(get_project_type "$selected_project")
                
                case $project_type in
                    node)
                        update_node_dependencies "$selected_project" "safe"
                        ;;
                    python)
                        update_python_dependencies "$selected_project"
                        ;;
                    rust)
                        update_rust_dependencies "$selected_project"
                        ;;
                esac
            else
                print_error "Invalid selection"
            fi
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
    echo "  check              Scan all projects for outdated dependencies"
    echo "  update [PROJECT]   Update dependencies (safe updates only)"
    echo "  update-major [PROJECT]  Update including major versions"
    echo "  audit              Run security audits on all projects"
    echo "  report             Generate detailed dependency report"
    echo "  interactive        Interactive update mode"
    echo ""
    echo "Examples:"
    echo "  $0 check"
    echo "  $0 update ~/Developer/projects/my-app"
    echo "  $0 update-major my-app"
    echo "  $0 audit"
    echo "  $0 interactive"
}

main() {
    local command="${1:-check}"
    
    print_header
    
    case $command in
        check)
            scan_all_projects "check"
            ;;
        update)
            if [[ -n "$2" ]]; then
                if [[ -d "$2" ]]; then
                    local project_type=$(get_project_type "$2")
                    case $project_type in
                        node) update_node_dependencies "$2" "safe" ;;
                        python) update_python_dependencies "$2" ;;
                        rust) update_rust_dependencies "$2" ;;
                    esac
                else
                    print_error "Project not found: $2"
                    exit 1
                fi
            else
                update_all_projects "safe"
            fi
            ;;
        update-major)
            if [[ -n "$2" ]]; then
                if [[ -d "$2" ]]; then
                    update_node_dependencies "$2" "major"
                else
                    print_error "Project not found: $2"
                    exit 1
                fi
            else
                print_error "Project path required for major updates"
                exit 1
            fi
            ;;
        audit)
            audit_all_projects
            ;;
        report)
            scan_all_projects "report"
            ;;
        interactive)
            interactive_update
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
