#!/bin/zsh

################################################################################
# Get Project Phase Status
# Utility to detect and display current project phase
################################################################################

# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Detect project phase
detect_phase() {
    local project_dir="${1:-.}"

    if [[ -f "$project_dir/.copilot-planning" ]]; then
        echo "planning"
    elif [[ -f "$project_dir/.copilot-development" ]]; then
        echo "development"
    elif [[ -f "$project_dir/.copilot-production" ]]; then
        echo "production"
    elif [[ -f "$project_dir/.copilot-maintenance" ]]; then
        echo "maintenance"
    else
        echo "unknown"
    fi
}

# Get phase info from marker file
get_phase_info() {
    local phase="$1"
    local marker_file=""

    case $phase in
        planning) marker_file=".copilot-planning" ;;
        development) marker_file=".copilot-development" ;;
        production) marker_file=".copilot-production" ;;
        maintenance) marker_file=".copilot-maintenance" ;;
        *) return 1 ;;
    esac

    if [[ -f "$marker_file" ]]; then
        # Extract info from marker file
        local started=$(grep "Phase Started:" "$marker_file" | cut -d: -f2- | xargs)
        echo "$started"
    fi
}

# Calculate phase duration
calculate_duration() {
    local start_date="$1"

    if [[ -z "$start_date" ]]; then
        echo "Unknown"
        return
    fi

    local start_epoch=$(date -j -f "%Y-%m-%d %H:%M:%S" "$start_date" +%s 2>/dev/null || echo "")

    if [[ -z "$start_epoch" ]]; then
        # Try without time
        start_epoch=$(date -j -f "%Y-%m-%d" "$start_date" +%s 2>/dev/null || echo "")
    fi

    if [[ -z "$start_epoch" ]]; then
        echo "Unknown"
        return
    fi

    local now_epoch=$(date +%s)
    local diff=$((now_epoch - start_epoch))
    local days=$((diff / 86400))
    local weeks=$((days / 7))

    if [[ $days -lt 1 ]]; then
        echo "Less than 1 day"
    elif [[ $days -lt 7 ]]; then
        echo "$days days"
    elif [[ $weeks -lt 4 ]]; then
        echo "$weeks weeks"
    else
        local months=$((weeks / 4))
        echo "$months months"
    fi
}

# Get next recommended actions
get_next_actions() {
    local phase="$1"

    case $phase in
        planning)
            echo "  1. Complete PLANNING-MASTER.md"
            echo "  2. Define tech stack and architecture"
            echo "  3. Specify MVP features"
            echo "  4. Run: ~/Developer/tools/project-management/complete-planning.sh"
            ;;
        development)
            echo "  1. Implement Phase 1 MVP features"
            echo "  2. Write tests and documentation"
            echo "  3. Complete beta testing"
            echo "  4. Run: ~/Developer/tools/project-management/transition-to-production.sh"
            ;;
        production)
            echo "  1. Monitor production metrics"
            echo "  2. Implement Phase 2 enhancements"
            echo "  3. Respond to user feedback"
            echo "  4. When stable: ~/Developer/tools/project-management/enter-maintenance.sh"
            ;;
        maintenance)
            echo "  1. Bug fixes and security updates"
            echo "  2. Monitor for issues"
            echo "  3. Maintain documentation"
            echo "  4. Review MAINTENANCE-PROCEDURES.md"
            ;;
        unknown)
            echo "  1. Initialize project with planning phase"
            echo "  2. Run: ~/Developer/tools/project-management/init-project.sh"
            ;;
    esac
}

# Display phase status
display_status() {
    local project_dir="${1:-.}"
    local verbose="${2:-false}"

    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "${BLUE}           Project Phase Status                                    ${NC}"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    local project_name=$(basename "$project_dir")
    local phase=$(detect_phase "$project_dir")

    echo "${CYAN}Project:${NC} $project_name"
    echo "${CYAN}Path:${NC} $project_dir"
    echo ""

    # Display phase with emoji and color
    case $phase in
        planning)
            echo "${CYAN}Current Phase:${NC} ${YELLOW}📋 Planning${NC}"
            local phase_info=$(get_phase_info "$phase")
            ;;
        development)
            echo "${CYAN}Current Phase:${NC} ${BLUE}💻 Development${NC}"
            local phase_info=$(get_phase_info "$phase")
            ;;
        production)
            echo "${CYAN}Current Phase:${NC} ${GREEN}🚀 Production${NC}"
            local phase_info=$(get_phase_info "$phase")
            ;;
        maintenance)
            echo "${CYAN}Current Phase:${NC} ${MAGENTA}🔧 Maintenance${NC}"
            local phase_info=$(get_phase_info "$phase")
            ;;
        unknown)
            echo "${CYAN}Current Phase:${NC} ${RED}❓ Unknown${NC}"
            echo "${YELLOW}⚠${NC}  No phase marker detected"
            ;;
    esac

    if [[ -n "$phase_info" ]]; then
        echo "${CYAN}Phase Started:${NC} $phase_info"
        local duration=$(calculate_duration "$phase_info")
        echo "${CYAN}Duration:${NC} $duration"
    fi

    echo ""

    # Additional info for known phases
    if [[ "$phase" != "unknown" ]]; then
        # Check for PLANNING-MASTER.md
        if [[ -f "$project_dir/PLANNING-MASTER.md" ]]; then
            echo "${GREEN}✓${NC} PLANNING-MASTER.md present"

            # Try to extract additional info from planning doc
            if grep -q "**Current Phase:**" "$project_dir/PLANNING-MASTER.md" 2>/dev/null; then
                local doc_phase=$(grep "**Current Phase:**" "$project_dir/PLANNING-MASTER.md" | sed 's/.*\*\*Current Phase:\*\* *//')
                if [[ "$doc_phase" != *"$phase"* ]]; then
                    echo "${YELLOW}⚠${NC}  Phase mismatch in PLANNING-MASTER.md (shows: $doc_phase)"
                fi
            fi
        else
            echo "${YELLOW}⚠${NC}  No PLANNING-MASTER.md found"
        fi

        # Check for git
        if [[ -d "$project_dir/.git" ]]; then
            local branch=$(cd "$project_dir" && git branch --show-current 2>/dev/null)
            echo "${GREEN}✓${NC} Git repository (branch: $branch)"
        else
            echo "${YELLOW}⚠${NC}  No git repository"
        fi

        # Check for phase history log
        if [[ -f "$project_dir/.phase-history.log" ]]; then
            local transitions=$(wc -l < "$project_dir/.phase-history.log" | xargs)
            echo "${GREEN}✓${NC} Phase history logged ($transitions transitions)"
        fi
    fi

    echo ""
    echo "${YELLOW}Next Actions:${NC}"
    get_next_actions "$phase"

    # Verbose mode - show additional details
    if [[ "$verbose" == "true" ]]; then
        echo ""
        echo "${CYAN}Additional Information:${NC}"

        # Show all phase markers present
        echo ""
        echo "Phase markers:"
        local found_markers=false
        for marker in .copilot-planning .copilot-development .copilot-production .copilot-maintenance; do
            if [[ -f "$project_dir/$marker" ]]; then
                echo "  ${GREEN}✓${NC} $marker"
                found_markers=true
            fi
        done
        [[ "$found_markers" == false ]] && echo "  ${YELLOW}⚠${NC}  None found"

        # Show phase history if exists
        if [[ -f "$project_dir/.phase-history.log" ]]; then
            echo ""
            echo "Phase History:"
            tail -5 "$project_dir/.phase-history.log" | while read line; do
                echo "  $line"
            done
        fi
    fi

    echo ""
}

# Main script
main() {
    local project_dir="${1:-.}"
    local mode="${2:-normal}"
    local verbose=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                verbose=true
                shift
                ;;
            -h|--help)
                echo "Usage: get-project-phase.sh [project-dir] [options]"
                echo ""
                echo "Options:"
                echo "  -v, --verbose    Show detailed information"
                echo "  -h, --help       Show this help message"
                echo "  --phase-only     Output only the phase name (for scripting)"
                echo ""
                echo "Example:"
                echo "  get-project-phase.sh"
                echo "  get-project-phase.sh ~/Developer/projects/apps/my-app"
                echo "  get-project-phase.sh --phase-only"
                exit 0
                ;;
            --phase-only)
                local phase=$(detect_phase "$project_dir")
                echo "$phase"
                exit 0
                ;;
            *)
                project_dir="$1"
                shift
                ;;
        esac
    done

    display_status "$project_dir" "$verbose"
}

# Run main with all arguments
main "$@"
