#!/bin/bash

################################################################################
# Release Manager
# Automated release creation, versioning, and publishing
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

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📦  Release Manager${NC}"
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

print_section() {
    echo ""
    echo -e "${MAGENTA}################################################################################${NC}"
    echo -e "${MAGENTA}# $1${NC}"
    echo -e "${MAGENTA}################################################################################${NC}"
    echo ""
}

################################################################################
# Version Management
################################################################################

get_current_version() {
    local project_dir="$1"
    
    cd "$project_dir"
    
    if [[ -f "package.json" ]]; then
        node -p "require('./package.json').version" 2>/dev/null || echo "0.0.0"
    elif [[ -f "pyproject.toml" ]]; then
        grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/' | tr -d ' '
    elif [[ -f "Cargo.toml" ]]; then
        grep '^version = ' Cargo.toml | sed 's/version = "\(.*\)"/\1/' | tr -d ' '
    elif [[ -f "go.mod" ]]; then
        git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0"
    else
        git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0"
    fi
}

parse_version() {
    local version="$1"
    
    local major=$(echo "$version" | cut -d. -f1)
    local minor=$(echo "$version" | cut -d. -f2)
    local patch=$(echo "$version" | cut -d. -f3)
    
    echo "$major $minor $patch"
}

bump_version() {
    local current="$1"
    local bump_type="$2"
    
    read -r major minor patch <<< $(parse_version "$current")
    
    case $bump_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "$current"
            return 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

update_version_files() {
    local project_dir="$1"
    local new_version="$2"
    
    cd "$project_dir"
    
    local updated=false
    
    # Update package.json
    if [[ -f "package.json" ]]; then
        npm version "$new_version" --no-git-tag-version --allow-same-version
        updated=true
        print_success "Updated package.json"
    fi
    
    # Update pyproject.toml
    if [[ -f "pyproject.toml" ]]; then
        sed -i '' "s/^version = .*/version = \"$new_version\"/" pyproject.toml
        updated=true
        print_success "Updated pyproject.toml"
    fi
    
    # Update Cargo.toml
    if [[ -f "Cargo.toml" ]]; then
        sed -i '' "s/^version = .*/version = \"$new_version\"/" Cargo.toml
        updated=true
        print_success "Updated Cargo.toml"
    fi
    
    if [[ "$updated" == false ]]; then
        print_warning "No version files found to update"
    fi
}

################################################################################
# Changelog Management
################################################################################

generate_changelog_entry() {
    local project_dir="$1"
    local version="$2"
    local previous_tag="$3"
    
    cd "$project_dir"
    
    echo "## [$version] - $(date +%Y-%m-%d)"
    echo ""
    
    # Get commits since last tag
    local commits
    if [[ -n "$previous_tag" ]]; then
        commits=$(git log "$previous_tag"..HEAD --pretty=format:"%h %s")
    else
        commits=$(git log --pretty=format:"%h %s")
    fi
    
    # Categorize commits
    local features=""
    local fixes=""
    local docs=""
    local chores=""
    local others=""
    
    while IFS= read -r commit; do
        if [[ "$commit" =~ feat:|feature: ]]; then
            features="${features}- ${commit#*:}\n"
        elif [[ "$commit" =~ fix:|bugfix: ]]; then
            fixes="${fixes}- ${commit#*:}\n"
        elif [[ "$commit" =~ docs?: ]]; then
            docs="${docs}- ${commit#*:}\n"
        elif [[ "$commit" =~ chore: ]]; then
            chores="${chores}- ${commit#*:}\n"
        else
            others="${others}- ${commit}\n"
        fi
    done <<< "$commits"
    
    # Output categorized changes
    if [[ -n "$features" ]]; then
        echo "### ✨ Features"
        echo -e "$features"
    fi
    
    if [[ -n "$fixes" ]]; then
        echo "### 🐛 Bug Fixes"
        echo -e "$fixes"
    fi
    
    if [[ -n "$docs" ]]; then
        echo "### 📚 Documentation"
        echo -e "$docs"
    fi
    
    if [[ -n "$chores" ]]; then
        echo "### 🔧 Maintenance"
        echo -e "$chores"
    fi
    
    if [[ -n "$others" ]]; then
        echo "### 🔄 Other Changes"
        echo -e "$others"
    fi
    
    echo ""
}

update_changelog() {
    local project_dir="$1"
    local version="$2"
    
    cd "$project_dir"
    
    local previous_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    
    if [[ ! -f "CHANGELOG.md" ]]; then
        # Create new changelog
        cat > CHANGELOG.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

EOF
    fi
    
    # Generate changelog entry
    local changelog_entry=$(generate_changelog_entry "$project_dir" "$version" "$previous_tag")
    
    # Insert new entry after header
    local temp_file=$(mktemp)
    
    # Find the insertion point (after the header)
    awk -v entry="$changelog_entry" '
        /^## \[/ && !inserted {
            print entry
            inserted=1
        }
        { print }
        END {
            if (!inserted) print entry
        }
    ' CHANGELOG.md > "$temp_file"
    
    mv "$temp_file" CHANGELOG.md
    
    print_success "Updated CHANGELOG.md"
}

################################################################################
# Release Notes
################################################################################

generate_release_notes() {
    local project_dir="$1"
    local version="$2"
    
    cd "$project_dir"
    
    local previous_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    
    cat << EOF
# Release $version

$(date +"%B %d, %Y")

$(generate_changelog_entry "$project_dir" "$version" "$previous_tag")

## Installation

\`\`\`bash
# Add installation instructions here
\`\`\`

## Contributors

$(git log ${previous_tag}..HEAD --pretty=format:"%an" | sort -u | sed 's/^/- /')

---

**Full Changelog**: https://github.com/\$USER/\$REPO/compare/${previous_tag}...v${version}
EOF
}

################################################################################
# Pre-release Checks
################################################################################

run_prerelease_checks() {
    local project_dir="$1"
    
    cd "$project_dir"
    
    print_section "Pre-release Checks"
    
    local issues=0
    
    # Check git status
    print_info "Checking git status..."
    if [[ -n $(git status --porcelain) ]]; then
        print_error "Working directory not clean"
        git status --short
        ((issues++))
    else
        print_success "Working directory clean"
    fi
    
    # Check branch
    print_info "Checking branch..."
    local branch=$(git branch --show-current)
    if [[ "$branch" != "main" ]] && [[ "$branch" != "master" ]]; then
        print_warning "Not on main/master branch (current: $branch)"
    else
        print_success "On $branch branch"
    fi
    
    # Run quality checks
    print_info "Running quality checks..."
    if "$HOME/Developer/tools/ci-cd/code-quality-checker.sh" check "$project_dir" 2>/dev/null; then
        print_success "Code quality passed"
    else
        print_error "Code quality issues found"
        ((issues++))
    fi
    
    # Run tests
    print_info "Running tests..."
    if "$HOME/Developer/tools/ci-cd/test-runner.sh" run "$project_dir" 2>/dev/null; then
        print_success "Tests passed"
    else
        print_error "Tests failed"
        ((issues++))
    fi
    
    # Check for uncommitted changes
    print_info "Checking for uncommitted changes..."
    if [[ -z $(git status --porcelain) ]]; then
        print_success "No uncommitted changes"
    else
        print_error "Uncommitted changes detected"
        ((issues++))
    fi
    
    if [[ $issues -eq 0 ]]; then
        print_success "All pre-release checks passed ✅"
        return 0
    else
        print_error "Pre-release checks failed with $issues issue(s) ❌"
        return 1
    fi
}

################################################################################
# Create Release
################################################################################

create_release() {
    local project_dir="$1"
    local version="$2"
    local skip_checks="${3:-false}"
    
    cd "$project_dir"
    
    print_section "Creating Release $version"
    
    # Pre-release checks
    if [[ "$skip_checks" != "true" ]]; then
        if ! run_prerelease_checks "$project_dir"; then
            read -p "Pre-release checks failed. Continue anyway? (y/n): " continue_choice
            if [[ "$continue_choice" != "y" ]]; then
                print_error "Release cancelled"
                return 1
            fi
        fi
    fi
    
    # Update version files
    print_info "Updating version to $version..."
    update_version_files "$project_dir" "$version"
    
    # Update changelog
    print_info "Updating changelog..."
    update_changelog "$project_dir" "$version"
    
    # Generate release notes
    print_info "Generating release notes..."
    local release_notes_file=".release-notes-$version.md"
    generate_release_notes "$project_dir" "$version" > "$release_notes_file"
    print_success "Release notes: $release_notes_file"
    
    # Commit changes
    print_info "Committing release changes..."
    git add .
    git commit -m "chore(release): $version"
    print_success "Changes committed"
    
    # Create git tag
    print_info "Creating git tag v$version..."
    git tag -a "v$version" -m "Release $version"
    print_success "Tag created"
    
    print_section "Release $version Created! 🎉"
    
    echo ""
    echo "Next steps:"
    echo "  1. Review release notes: $release_notes_file"
    echo "  2. Push to remote: git push origin main && git push origin v$version"
    echo "  3. Create GitHub/GitLab release"
    echo "  4. Deploy: cd '$project_dir' && dev-master deploy"
}

################################################################################
# Quick Release (bump + create)
################################################################################

quick_release() {
    local project_dir="$1"
    local bump_type="$2"
    
    cd "$project_dir"
    
    local current_version=$(get_current_version "$project_dir")
    print_info "Current version: $current_version"
    
    local new_version=$(bump_version "$current_version" "$bump_type")
    print_info "New version: $new_version"
    
    echo ""
    read -p "Create release $new_version? (y/n): " confirm
    
    if [[ "$confirm" == "y" ]]; then
        create_release "$project_dir" "$new_version" "false"
    else
        print_info "Release cancelled"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    local project_dir="${1:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    print_header
    
    local current_version=$(get_current_version "$project_dir")
    
    print_info "Project: $(basename "$project_dir")"
    print_info "Current version: $current_version"
    echo ""
    
    echo -e "${CYAN}Release Options:${NC}"
    echo "  1) Quick patch release ($current_version → $(bump_version "$current_version" "patch"))"
    echo "  2) Quick minor release ($current_version → $(bump_version "$current_version" "minor"))"
    echo "  3) Quick major release ($current_version → $(bump_version "$current_version" "major"))"
    echo "  4) Custom version release"
    echo "  5) Run pre-release checks"
    echo "  6) View current changelog"
    echo "  7) Show release history"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            quick_release "$project_dir" "patch"
            ;;
        2)
            quick_release "$project_dir" "minor"
            ;;
        3)
            quick_release "$project_dir" "major"
            ;;
        4)
            read -p "Enter version (e.g., 1.2.3): " custom_version
            create_release "$project_dir" "$custom_version" "false"
            ;;
        5)
            run_prerelease_checks "$project_dir"
            ;;
        6)
            if [[ -f "$project_dir/CHANGELOG.md" ]]; then
                head -n 50 "$project_dir/CHANGELOG.md"
            else
                print_warning "No CHANGELOG.md found"
            fi
            ;;
        7)
            cd "$project_dir"
            git tag -l --sort=-v:refname | head -n 10
            ;;
        q|Q)
            print_info "Goodbye! 👋"
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
    echo "Usage: $0 [COMMAND] [PROJECT_DIR] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  version [DIR]             Show current version"
    echo "  bump [DIR] <TYPE>         Bump version (patch/minor/major)"
    echo "  check [DIR]               Run pre-release checks"
    echo "  changelog [DIR]           Update changelog"
    echo "  create [DIR] <VERSION>    Create release"
    echo "  quick [DIR] <TYPE>        Quick release with bump"
    echo "  history [DIR]             Show release history"
    echo "  interactive [DIR]         Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 version"
    echo "  $0 quick . patch"
    echo "  $0 create . 1.2.3"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    local project_dir="${2:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    case $command in
        version)
            print_header
            local version=$(get_current_version "$project_dir")
            print_info "Current version: $version"
            ;;
        bump)
            local bump_type="$3"
            if [[ -z "$bump_type" ]]; then
                print_error "Bump type required (patch/minor/major)"
                exit 1
            fi
            
            print_header
            local current=$(get_current_version "$project_dir")
            local new=$(bump_version "$current" "$bump_type")
            update_version_files "$project_dir" "$new"
            print_success "Version bumped: $current → $new"
            ;;
        check)
            print_header
            run_prerelease_checks "$project_dir"
            ;;
        changelog)
            print_header
            local version="$3"
            if [[ -z "$version" ]]; then
                version=$(get_current_version "$project_dir")
            fi
            update_changelog "$project_dir" "$version"
            ;;
        create)
            local version="$3"
            if [[ -z "$version" ]]; then
                print_error "Version required"
                exit 1
            fi
            print_header
            create_release "$project_dir" "$version" "false"
            ;;
        quick)
            local bump_type="$3"
            if [[ -z "$bump_type" ]]; then
                print_error "Bump type required (patch/minor/major)"
                exit 1
            fi
            print_header
            quick_release "$project_dir" "$bump_type"
            ;;
        history)
            print_header
            cd "$project_dir"
            print_section "Release History"
            git tag -l --sort=-v:refname --format='%(refname:short) - %(creatordate:short) - %(subject)' | head -n 20
            ;;
        interactive)
            interactive_mode "$project_dir"
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
