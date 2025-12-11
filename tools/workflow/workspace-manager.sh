#!/bin/bash

################################################################################
# General Workspace Manager
# Manage notes, documents, research, and knowledge work
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

# Default workspace
DEFAULT_WORKSPACE="$HOME/Developer/notes"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📝  General Workspace Manager${NC}"
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

print_section() {
    echo ""
    echo -e "${MAGENTA}################################################################################${NC}"
    echo -e "${MAGENTA}# $1${NC}"
    echo -e "${MAGENTA}################################################################################${NC}"
    echo ""
}

################################################################################
# Note Templates
################################################################################

create_note_template() {
    local note_type="$1"
    local title="$2"
    
    case $note_type in
        daily)
            cat << EOF
# Daily Note - $(date +"%Y-%m-%d")

## Today's Focus
- 

## Tasks
- [ ] 

## Notes


## Ideas


## Follow-up

EOF
            ;;
        meeting)
            cat << EOF
# Meeting Notes - $title

**Date:** $(date +"%Y-%m-%d %H:%M")
**Attendees:** 

## Agenda


## Discussion


## Action Items
- [ ] 

## Next Meeting

EOF
            ;;
        research)
            cat << EOF
# Research: $title

**Date:** $(date +"%Y-%m-%d")
**Topic:** $title

## Objective


## Key Findings


## Sources


## Next Steps


## Related Notes

EOF
            ;;
        decision)
            cat << EOF
# Decision: $title

**Date:** $(date +"%Y-%m-%d")
**Status:** 🤔 Considering

## Context


## Options

### Option 1:
**Pros:**
- 

**Cons:**
- 

### Option 2:
**Pros:**
- 

**Cons:**
- 

## Decision


## Rationale


## Follow-up

EOF
            ;;
        planning)
            cat << EOF
# Planning: $title

**Date:** $(date +"%Y-%m-%d")
**Timeline:** 

## Goal


## Requirements


## Approach


## Tasks
- [ ] 

## Resources


## Risks


## Success Criteria

EOF
            ;;
        idea)
            cat << EOF
# Idea: $title

**Date:** $(date +"%Y-%m-%d")
**Status:** 💡 New

## Description


## Why This Matters


## Potential Implementation


## Next Steps
- [ ] 

## Related

EOF
            ;;
        *)
            cat << EOF
# $title

**Date:** $(date +"%Y-%m-%d")

## Overview


## Details


## Notes

EOF
            ;;
    esac
}

################################################################################
# Note Creation
################################################################################

create_note() {
    local workspace="$1"
    local note_type="$2"
    local title="$3"
    
    # Generate filename
    local filename
    case $note_type in
        daily)
            filename="daily-$(date +%Y-%m-%d).md"
            ;;
        *)
            local slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
            filename="$slug.md"
            ;;
    esac
    
    local filepath="$workspace/$filename"
    
    # Check if file exists
    if [[ -f "$filepath" ]]; then
        print_warning "Note already exists: $filename"
        read -p "Open existing note? (y/n): " open_choice
        if [[ "$open_choice" == "y" ]]; then
            ${EDITOR:-code} "$filepath"
        fi
        return 0
    fi
    
    # Create note from template
    create_note_template "$note_type" "$title" > "$filepath"
    
    print_success "Created: $filename"
    
    # Open in editor
    ${EDITOR:-code} "$filepath"
}

################################################################################
# Note Search
################################################################################

search_notes() {
    local workspace="$1"
    local query="$2"
    
    print_section "Search Results for: $query"
    
    local results=$(grep -l -i "$query" "$workspace"/*.md 2>/dev/null)
    
    if [[ -z "$results" ]]; then
        print_warning "No notes found matching: $query"
        return 1
    fi
    
    echo "$results" | while read file; do
        local filename=$(basename "$file")
        local matches=$(grep -n -i "$query" "$file" | head -n 3)
        
        echo -e "${CYAN}$filename${NC}"
        echo "$matches" | while IFS=: read line_num content; do
            echo -e "  ${YELLOW}L$line_num:${NC} $(echo "$content" | sed "s/$query/${GREEN}$query${NC}/gi")"
        done
        echo ""
    done
}

################################################################################
# List Notes
################################################################################

list_notes() {
    local workspace="$1"
    local sort_by="${2:-modified}"
    
    print_section "Notes in Workspace"
    
    if [[ ! -d "$workspace" ]]; then
        print_error "Workspace not found: $workspace"
        return 1
    fi
    
    local files
    if [[ "$sort_by" == "modified" ]]; then
        files=$(ls -t "$workspace"/*.md 2>/dev/null)
    else
        files=$(ls "$workspace"/*.md 2>/dev/null)
    fi
    
    if [[ -z "$files" ]]; then
        print_warning "No notes found in workspace"
        return 0
    fi
    
    echo "$files" | while read file; do
        local filename=$(basename "$file")
        local modified=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file")
        local size=$(stat -f "%z" "$file" | awk '{printf "%.1fKB", $1/1024}')
        local first_line=$(head -n 1 "$file" | sed 's/^# //')
        
        echo -e "${GREEN}•${NC} ${CYAN}$filename${NC}"
        echo -e "  ${first_line}"
        echo -e "  ${YELLOW}Modified:${NC} $modified | ${YELLOW}Size:${NC} $size"
        echo ""
    done
}

################################################################################
# Link Notes
################################################################################

find_related_notes() {
    local workspace="$1"
    local note_file="$2"
    
    if [[ ! -f "$note_file" ]]; then
        print_error "Note not found: $note_file"
        return 1
    fi
    
    print_section "Related Notes"
    
    # Extract key terms from note (simple approach)
    local keywords=$(grep -o '\*\*[^*]*\*\*' "$note_file" | sed 's/\*\*//g' | tr '\n' '|' | sed 's/|$//')
    
    if [[ -z "$keywords" ]]; then
        print_warning "No keywords found to search for related notes"
        return 0
    fi
    
    grep -l -i -E "$keywords" "$workspace"/*.md 2>/dev/null | grep -v "$note_file" | while read file; do
        local filename=$(basename "$file")
        echo -e "${GREEN}•${NC} ${CYAN}$filename${NC}"
    done
}

################################################################################
# Archive Notes
################################################################################

archive_old_notes() {
    local workspace="$1"
    local days_old="${2:-90}"
    
    local archive_dir="$workspace/.archive"
    mkdir -p "$archive_dir"
    
    print_section "Archiving Notes Older Than $days_old Days"
    
    local count=0
    find "$workspace" -maxdepth 1 -name "*.md" -type f -mtime +${days_old} | while read file; do
        local filename=$(basename "$file")
        mv "$file" "$archive_dir/"
        print_info "Archived: $filename"
        ((count++))
    done
    
    if [[ $count -eq 0 ]]; then
        print_info "No notes to archive"
    else
        print_success "Archived $count note(s)"
    fi
}

################################################################################
# Generate Summary
################################################################################

generate_summary() {
    local workspace="$1"
    local output_file="$workspace/SUMMARY-$(date +%Y-%m-%d).md"
    
    print_section "Generating Workspace Summary"
    
    {
        echo "# Workspace Summary"
        echo ""
        echo "**Generated:** $(date +"%Y-%m-%d %H:%M")"
        echo "**Workspace:** $workspace"
        echo ""
        
        # Count notes
        local total_notes=$(ls -1 "$workspace"/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "## Statistics"
        echo ""
        echo "- Total Notes: $total_notes"
        echo "- Last Modified: $(ls -t "$workspace"/*.md 2>/dev/null | head -n 1 | xargs stat -f "%Sm" -t "%Y-%m-%d")"
        echo ""
        
        # List all notes with first line
        echo "## All Notes"
        echo ""
        ls -t "$workspace"/*.md 2>/dev/null | while read file; do
            local filename=$(basename "$file")
            local first_line=$(head -n 1 "$file" | sed 's/^# //')
            echo "- **[$filename]($filename)**: $first_line"
        done
        echo ""
        
        # Recent notes
        echo "## Recent Notes (Last 7 Days)"
        echo ""
        find "$workspace" -maxdepth 1 -name "*.md" -type f -mtime -7 | sort -r | while read file; do
            local filename=$(basename "$file")
            local first_line=$(head -n 1 "$file" | sed 's/^# //')
            echo "- **[$filename]($filename)**: $first_line"
        done
        echo ""
        
    } > "$output_file"
    
    print_success "Summary created: $output_file"
    ${EDITOR:-code} "$output_file"
}

################################################################################
# Export Notes
################################################################################

export_notes() {
    local workspace="$1"
    local format="${2:-pdf}"
    
    print_section "Exporting Notes to $format"
    
    case $format in
        html)
            local output_dir="$workspace/export-html-$(date +%Y%m%d)"
            mkdir -p "$output_dir"
            
            ls "$workspace"/*.md 2>/dev/null | while read file; do
                local filename=$(basename "$file" .md)
                if command -v pandoc >/dev/null 2>&1; then
                    pandoc "$file" -o "$output_dir/$filename.html"
                    print_success "Exported: $filename.html"
                else
                    print_warning "pandoc not installed, skipping $filename"
                fi
            done
            
            print_success "HTML export complete: $output_dir"
            ;;
        pdf)
            local output_dir="$workspace/export-pdf-$(date +%Y%m%d)"
            mkdir -p "$output_dir"
            
            ls "$workspace"/*.md 2>/dev/null | while read file; do
                local filename=$(basename "$file" .md)
                if command -v pandoc >/dev/null 2>&1; then
                    pandoc "$file" -o "$output_dir/$filename.pdf"
                    print_success "Exported: $filename.pdf"
                else
                    print_warning "pandoc not installed, skipping $filename"
                fi
            done
            
            print_success "PDF export complete: $output_dir"
            ;;
        *)
            print_error "Unknown format: $format"
            return 1
            ;;
    esac
}

################################################################################
# Organize Notes
################################################################################

organize_by_tags() {
    local workspace="$1"
    
    print_section "Organizing by Tags"
    
    # Create tags directory
    local tags_dir="$workspace/.by-tags"
    mkdir -p "$tags_dir"
    
    # Find all tags in notes (format: #tag)
    grep -h -o '#[a-zA-Z0-9_-]*' "$workspace"/*.md 2>/dev/null | sort -u | while read tag; do
        local tag_name=$(echo "$tag" | sed 's/#//')
        local tag_dir="$tags_dir/$tag_name"
        mkdir -p "$tag_dir"
        
        # Find notes with this tag
        grep -l "$tag" "$workspace"/*.md 2>/dev/null | while read file; do
            local filename=$(basename "$file")
            ln -sf "../../$filename" "$tag_dir/$filename" 2>/dev/null
        done
        
        print_info "Tag: $tag_name"
    done
    
    print_success "Notes organized by tags in: $tags_dir"
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    local workspace="${1:-$DEFAULT_WORKSPACE}"
    
    print_header
    print_info "Workspace: $workspace"
    echo ""
    
    echo -e "${CYAN}What would you like to do?${NC}"
    echo "  1) Create new note"
    echo "  2) Daily note"
    echo "  3) List all notes"
    echo "  4) Search notes"
    echo "  5) Generate summary"
    echo "  6) Archive old notes"
    echo "  7) Export notes"
    echo "  8) Organize by tags"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            echo ""
            echo "Note type:"
            echo "  1) General"
            echo "  2) Meeting"
            echo "  3) Research"
            echo "  4) Decision"
            echo "  5) Planning"
            echo "  6) Idea"
            read -p "Type: " type_choice
            
            case $type_choice in
                1) note_type="general" ;;
                2) note_type="meeting" ;;
                3) note_type="research" ;;
                4) note_type="decision" ;;
                5) note_type="planning" ;;
                6) note_type="idea" ;;
                *) note_type="general" ;;
            esac
            
            read -p "Title: " title
            create_note "$workspace" "$note_type" "$title"
            ;;
        2)
            create_note "$workspace" "daily" "Daily Note"
            ;;
        3)
            list_notes "$workspace" "modified"
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode "$workspace"
            ;;
        4)
            read -p "Search query: " query
            search_notes "$workspace" "$query"
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode "$workspace"
            ;;
        5)
            generate_summary "$workspace"
            ;;
        6)
            read -p "Archive notes older than (days) [90]: " days
            days="${days:-90}"
            archive_old_notes "$workspace" "$days"
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode "$workspace"
            ;;
        7)
            echo ""
            echo "Export format:"
            echo "  1) HTML"
            echo "  2) PDF"
            read -p "Format: " format_choice
            
            case $format_choice in
                1) export_notes "$workspace" "html" ;;
                2) export_notes "$workspace" "pdf" ;;
            esac
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode "$workspace"
            ;;
        8)
            organize_by_tags "$workspace"
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode "$workspace"
            ;;
        q|Q)
            print_info "Goodbye! 👋"
            exit 0
            ;;
        *)
            print_error "Invalid selection"
            sleep 1
            interactive_mode "$workspace"
            ;;
    esac
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [COMMAND] [WORKSPACE] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  new [WS] <TYPE> <TITLE>   Create new note"
    echo "  daily [WS]                Create daily note"
    echo "  list [WS]                 List all notes"
    echo "  search [WS] <QUERY>       Search notes"
    echo "  summary [WS]              Generate summary"
    echo "  archive [WS] [DAYS]       Archive old notes"
    echo "  export [WS] [FORMAT]      Export notes (html/pdf)"
    echo "  organize [WS]             Organize by tags"
    echo "  interactive [WS]          Interactive mode"
    echo ""
    echo "Note Types:"
    echo "  general, meeting, research, decision, planning, idea"
    echo ""
    echo "Examples:"
    echo "  $0 daily"
    echo "  $0 new . research \"AI Model Comparison\""
    echo "  $0 search . kubernetes"
    echo "  $0 summary"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local workspace="${2:-$DEFAULT_WORKSPACE}"
    
    # Create workspace if it doesn't exist
    mkdir -p "$workspace"
    
    case $command in
        new)
            local note_type="$3"
            local title="$4"
            if [[ -z "$note_type" ]] || [[ -z "$title" ]]; then
                print_error "Note type and title required"
                show_usage
                exit 1
            fi
            print_header
            create_note "$workspace" "$note_type" "$title"
            ;;
        daily)
            print_header
            create_note "$workspace" "daily" "Daily Note"
            ;;
        list)
            print_header
            list_notes "$workspace" "modified"
            ;;
        search)
            local query="$3"
            if [[ -z "$query" ]]; then
                print_error "Search query required"
                exit 1
            fi
            print_header
            search_notes "$workspace" "$query"
            ;;
        summary)
            print_header
            generate_summary "$workspace"
            ;;
        archive)
            local days="${3:-90}"
            print_header
            archive_old_notes "$workspace" "$days"
            ;;
        export)
            local format="${3:-pdf}"
            print_header
            export_notes "$workspace" "$format"
            ;;
        organize)
            print_header
            organize_by_tags "$workspace"
            ;;
        interactive)
            interactive_mode "$workspace"
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            # Treat first arg as workspace if not a command
            if [[ -d "$command" ]]; then
                interactive_mode "$command"
            else
                print_error "Unknown command: $command"
                show_usage
                exit 1
            fi
            ;;
    esac
}

main "$@"
