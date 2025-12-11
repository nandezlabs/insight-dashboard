#!/bin/bash

################################################################################
# VS Code Settings Configurator
# Applies recommended settings for installed extensions
################################################################################

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"
BACKUP_FILE="$HOME/Library/Application Support/Code/User/settings.json.backup.$(date +%Y%m%d_%H%M%S)"

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  ⚙️  VS Code Settings Configurator${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Configure VS Code settings for installed extensions.

OPTIONS:
    --apply         Apply recommended settings (backs up current settings)
    --backup        Backup current settings only
    --restore       Restore from latest backup
    --view          View recommended settings without applying
    -h, --help      Show this help message

EXAMPLES:
    # Apply recommended settings
    $(basename "$0") --apply

    # Just backup current settings
    $(basename "$0") --backup

    # View what would be changed
    $(basename "$0") --view

EOF
}

backup_settings() {
    if [[ -f "$SETTINGS_FILE" ]]; then
        cp "$SETTINGS_FILE" "$BACKUP_FILE"
        print_success "Backed up settings to: $BACKUP_FILE"
    else
        print_info "No existing settings file found"
    fi
}

merge_settings() {
    print_info "Merging recommended settings with your existing settings..."
    
    # This would require jq for proper JSON merging
    # For now, we'll provide manual instructions
    print_info "Please manually merge the recommended settings from:"
    echo "  ~/Developer/temp-workspace/vscode-extension-setup-guide.md"
    echo ""
    print_info "Or copy the recommended settings and paste into:"
    echo "  Cmd+Shift+P → 'Preferences: Open User Settings (JSON)'"
}

view_settings() {
    cat << 'EOF'
Recommended VS Code Settings:
==============================

Key Settings to Add/Update:

1. Godot Integration:
   "godot_tools.editor_path": "/Applications/Godot.app/Contents/MacOS/Godot"

2. File Associations:
   "files.associations": {
     "*.gd": "gdscript",
     "*.tscn": "godot-resource"
   }

3. Python Formatting:
   "[python]": {
     "editor.defaultFormatter": "ms-python.black-formatter"
   }

4. Performance (for 8GB Mac):
   "editor.minimap.enabled": false
   "files.watcherExclude": {
     "**/.godot/**": true,
     "**/node_modules/**": true
   }

See full settings in: ~/Developer/temp-workspace/vscode-extension-setup-guide.md

EOF
}

main() {
    print_header
    
    case "${1:-}" in
        --apply)
            backup_settings
            merge_settings
            echo ""
            print_success "Settings backup created"
            print_info "Open setup guide: code ~/Developer/temp-workspace/vscode-extension-setup-guide.md"
            ;;
        --backup)
            backup_settings
            ;;
        --restore)
            if ls "$HOME/Library/Application Support/Code/User/settings.json.backup."* 1> /dev/null 2>&1; then
                latest_backup=$(ls -t "$HOME/Library/Application Support/Code/User/settings.json.backup."* | head -1)
                cp "$latest_backup" "$SETTINGS_FILE"
                print_success "Restored settings from: $latest_backup"
            else
                print_info "No backup files found"
            fi
            ;;
        --view)
            view_settings
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
