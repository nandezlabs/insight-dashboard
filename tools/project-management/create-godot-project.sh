#!/bin/bash

################################################################################
# Godot Project Creator
# Creates a new Godot game project with proper structure and configuration
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GAMES_DIR="$HOME/Developer/games/my-games"

# Auto-detect Godot version or use fallback
if command -v godot &> /dev/null; then
    GODOT_VERSION=$(godot --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
    if [[ -z "$GODOT_VERSION" ]]; then
        GODOT_VERSION="4.4"  # fallback if detection fails
    fi
else
    GODOT_VERSION="4.4"  # fallback if Godot not in PATH
fi

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🎮 Godot Project Creator${NC}"
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

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Creates a new Godot game project with standardized structure.

OPTIONS:
    -n, --name NAME         Project name (required)
    -t, --type TYPE         Project type: 2d or 3d (default: 2d)
    -d, --description DESC  Project description
    -h, --help             Show this help message

EXAMPLES:
    # Create a 2D game project
    $(basename "$0") --name "Platformer" --type 2d

    # Create a 3D game project
    $(basename "$0") -n "First Person Shooter" -t 3d -d "FPS game prototype"

EOF
}

################################################################################
# Project Structure Creation
################################################################################

create_directory_structure() {
    local project_dir="$1"
    local project_type="$2"
    
    print_info "Creating directory structure..."
    
    # Common directories for all projects
    mkdir -p "$project_dir"/{scenes,scripts,assets,resources}
    mkdir -p "$project_dir/assets"/{sprites,sounds,music,fonts,textures}
    mkdir -p "$project_dir/resources"/{materials,themes}
    mkdir -p "$project_dir/scenes"/{levels,ui,characters,objects}
    
    # Type-specific directories
    if [[ "$project_type" == "3d" ]]; then
        mkdir -p "$project_dir/assets"/{models,animations,shaders}
        mkdir -p "$project_dir/scenes"/{environment,props}
    else
        mkdir -p "$project_dir/assets"/{tilesets,animations}
        mkdir -p "$project_dir/scenes"/{tiles,effects}
    fi
    
    # Keep directories in git
    find "$project_dir" -type d -empty -exec touch {}/.gitkeep \;
    
    print_success "Directory structure created"
}

create_gitignore() {
    local project_dir="$1"
    
    print_info "Creating .gitignore..."
    
    cat > "$project_dir/.gitignore" << 'EOF'
# Godot 4+ specific ignores
.godot/

# Godot-specific
*.translation
*.import

# Android build files
/android/
android/build/
android/.gradle/
android/gradle/
android/gradlew
android/gradlew.bat

# iOS build files
/ios/

# Mono-specific ignores (C# projects)
.mono/
data_*/
mono_crash.*.json

# System/tool-specific
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Backup files
*.bak
*.gd.backup
*.tscn.backup
*.tres.backup

# Build/export files
builds/
exports/
*.apk
*.ipa
*.exe
*.dmg
*.zip

# Logs
*.log
logs/

EOF
    
    print_success ".gitignore created"
}

create_gitattributes() {
    local project_dir="$1"
    
    print_info "Creating .gitattributes..."
    
    cat > "$project_dir/.gitattributes" << 'EOF'
# Normalize line endings
* text=auto eol=lf

# Godot files
*.gd text diff=gd
*.tscn text diff=tscn merge=union
*.tres text diff=tres merge=union
*.godot text diff=godot

# Binary files
*.png binary
*.jpg binary
*.jpeg binary
*.wav binary
*.ogg binary
*.mp3 binary
*.ttf binary
*.otf binary
*.import binary

EOF
    
    print_success ".gitattributes created"
}

create_editorconfig() {
    local project_dir="$1"
    
    print_info "Creating .editorconfig..."
    
    cat > "$project_dir/.editorconfig" << 'EOF'
# EditorConfig for Godot projects
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.gd]
indent_style = tab
indent_size = 4

[*.{tscn,tres,godot,import}]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

EOF
    
    print_success ".editorconfig created"
}

create_project_godot() {
    local project_dir="$1"
    local project_name="$2"
    local project_type="$3"
    
    print_info "Creating project.godot..."
    
    local renderer="Forward+"
    if [[ "$project_type" == "2d" ]]; then
        renderer="Mobile"
    fi
    
    cat > "$project_dir/project.godot" << EOF
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="$project_name"
config/features=PackedStringArray("$GODOT_VERSION", "$renderer")
config/icon="res://icon.svg"

[display]

window/size/viewport_width=1920
window/size/viewport_height=1080
window/size/mode=2
window/stretch/mode="canvas_items"

[rendering]

renderer/rendering_method="$renderer"

EOF
    
    print_success "project.godot created"
}

create_readme() {
    local project_dir="$1"
    local project_name="$2"
    local project_type="$3"
    local description="$4"
    
    print_info "Creating README.md..."
    
    local project_type_upper=$(echo "$project_type" | tr '[:lower:]' '[:upper:]')
    cat > "$project_dir/README.md" << EOF
# $project_name

$description

## 📋 Project Info

- **Engine:** Godot $GODOT_VERSION
- **Type:** $project_type_upper
- **Created:** $(date +"%B %d, %Y")

## 🎮 Project Structure

\`\`\`
$(basename "$project_dir")/
├── assets/          # Game assets (sprites, sounds, etc.)
├── scenes/          # Godot scene files
├── scripts/         # GDScript files
├── resources/       # Godot resources (materials, themes)
└── project.godot    # Main project file
\`\`\`

## 🚀 Getting Started

1. Open Godot $GODOT_VERSION
2. Import this project
3. Open the main scene in \`scenes/\`

## 🛠️ Development

### Using VS Code

This project includes VS Code workspace configuration for Godot development.

### Asset Organization

- \`assets/sprites/\` - 2D sprites and textures
- \`assets/sounds/\` - Sound effects
- \`assets/music/\` - Background music
- \`assets/fonts/\` - Custom fonts

### Scene Organization

- \`scenes/levels/\` - Game levels
- \`scenes/ui/\` - User interface
- \`scenes/characters/\` - Player and NPCs
- \`scenes/objects/\` - Game objects

## 📝 Notes

- Keep scenes modular and reusable
- Follow GDScript style guide
- Document complex logic
- Test on target platforms regularly

## 🎯 TODO

- [ ] Create main menu scene
- [ ] Implement core gameplay
- [ ] Add sound effects
- [ ] Create game levels
- [ ] Test and polish

---

**Developed with:** Godot Engine
EOF
    
    print_success "README.md created"
}

create_vscode_workspace() {
    local project_dir="$1"
    local project_name="$2"
    
    print_info "Creating VS Code workspace..."
    
    # Create workspace file
    local workspace_file="$project_dir/${project_name}.code-workspace"
    
    cat > "$workspace_file" << 'EOF'
{
    "folders": [
        {
            "path": "."
        }
    ],
    "settings": {
        "godot_tools.editor_path": "/Applications/Godot.app",
        "godot_tools.gdscript_lsp_server_port": 6005,
        "files.exclude": {
            ".godot/": true,
            ".import/": true
        },
        "files.associations": {
            "*.gd": "gdscript",
            "*.tscn": "godot-scene",
            "*.tres": "godot-resource"
        },
        "editor.insertSpaces": false,
        "editor.tabSize": 4,
        "[gdscript]": {
            "editor.insertSpaces": false,
            "editor.tabSize": 4
        }
    },
    "extensions": {
        "recommendations": [
            "geequlim.godot-tools"
        ]
    }
}
EOF
    
    print_success "VS Code workspace created"
}

create_icon() {
    local project_dir="$1"
    
    print_info "Creating placeholder icon..."
    
    # Create a simple SVG icon
    cat > "$project_dir/icon.svg" << 'EOF'
<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg">
    <rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/>
    <g transform="scale(.101) translate(122 122)">
        <g fill="#fff">
            <path d="M105 673v33q407 354 814 0v-33z"/>
            <path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/>
            <path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/>
            <circle cx="725" cy="526" r="90"/>
            <circle cx="299" cy="526" r="90"/>
        </g>
        <g fill="#414042">
            <circle cx="307" cy="532" r="60"/>
            <circle cx="717" cy="532" r="60"/>
        </g>
    </g>
</svg>
EOF
    
    print_success "Icon created"
}

create_main_scene() {
    local project_dir="$1"
    local project_type="$2"
    
    print_info "Creating main scene template..."
    
    if [[ "$project_type" == "2d" ]]; then
        cat > "$project_dir/scenes/main.tscn" << 'EOF'
[gd_scene format=3 uid="uid://placeholder"]

[node name="Main" type="Node2D"]

[node name="ColorRect" type="ColorRect" parent="."]
offset_right = 1920.0
offset_bottom = 1080.0
color = Color(0.2, 0.2, 0.3, 1)

[node name="Label" type="Label" parent="."]
offset_left = 810.0
offset_top = 500.0
offset_right = 1110.0
offset_bottom = 580.0
text = "Godot 2D Project
Ready to Go!"
horizontal_alignment = 1
vertical_alignment = 1
EOF
    else
        cat > "$project_dir/scenes/main.tscn" << 'EOF'
[gd_scene format=3 uid="uid://placeholder"]

[node name="Main" type="Node3D"]

[node name="Camera3D" type="Camera3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 5)

[node name="DirectionalLight3D" type="DirectionalLight3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 0.707107, 0.707107, 0, -0.707107, 0.707107, 0, 5, 0)

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
EOF
    fi
    
    print_success "Main scene created"
}

init_git_repository() {
    local project_dir="$1"
    local project_name="$2"
    
    print_info "Initializing Git repository..."
    
    cd "$project_dir"
    git init -q
    git add .
    git commit -q -m "Initial commit: $project_name project setup"
    
    print_success "Git repository initialized"
}

################################################################################
# Main Script
################################################################################

main() {
    print_header
    
    # Parse arguments
    local project_name=""
    local project_type="2d"
    local description="A Godot game project"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--name)
                project_name="$2"
                shift 2
                ;;
            -t|--type)
                project_type="$2"
                shift 2
                ;;
            -d|--description)
                description="$2"
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
    
    # Validate inputs
    if [[ -z "$project_name" ]]; then
        print_error "Project name is required"
        show_usage
        exit 1
    fi
    
    if [[ ! "$project_type" =~ ^(2d|3d)$ ]]; then
        print_error "Project type must be '2d' or '3d'"
        exit 1
    fi
    
    # Create project directory path
    local project_slug=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    local project_dir="$GAMES_DIR/$project_name/$project_slug"
    
    # Check if project already exists
    if [[ -d "$project_dir" ]]; then
        print_error "Project directory already exists: $project_dir"
        exit 1
    fi
    
    local project_type_upper=$(echo "$project_type" | tr '[:lower:]' '[:upper:]')
    print_info "Creating $project_type_upper project: $project_name"
    print_info "Location: $project_dir"
    echo ""
    
    # Create project
    create_directory_structure "$project_dir" "$project_type"
    create_gitignore "$project_dir"
    create_gitattributes "$project_dir"
    create_editorconfig "$project_dir"
    create_project_godot "$project_dir" "$project_name" "$project_type"
    create_readme "$project_dir" "$project_name" "$project_type" "$description"
    create_vscode_workspace "$project_dir" "$project_name"
    create_icon "$project_dir"
    create_main_scene "$project_dir" "$project_type"
    init_git_repository "$project_dir" "$project_name"
    
    echo ""
    print_success "Project created successfully!"
    echo ""
    print_info "Next steps:"
    echo "  1. cd \"$project_dir\""
    echo "  2. code \"${project_name}.code-workspace\""
    echo "  3. Open Godot and import the project"
    echo ""
}

main "$@"
