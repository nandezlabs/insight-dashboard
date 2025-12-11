#!/bin/bash

################################################################################
# Development Master Orchestrator
# Unified interface to all development automation tools
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

# Tool paths
TOOLS_DIR="$HOME/Developer/tools"
PROJECT_CREATORS_DIR="$TOOLS_DIR/project-management"
WORKFLOW_DIR="$TOOLS_DIR/setup"
DEPLOYMENT_DIR="$TOOLS_DIR/deployment"
MAINTENANCE_DIR="$TOOLS_DIR/maintenance"
CICD_DIR="$TOOLS_DIR/ci-cd"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🎯  Development Master Orchestrator${NC}"
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
# Tool Discovery
################################################################################

discover_tools() {
    echo -e "${CYAN}Available Tools:${NC}"
    echo ""
    
    echo -e "${MAGENTA}Phase 1: Project Creation${NC}"
    echo "  create-godot          Create Godot game project"
    echo "  create-python         Create Python project"
    echo "  create-ios            Create iOS/Swift app"
    echo "  create-nextjs         Create Next.js project"
    echo "  create-react          Create React/Vite project"
    echo "  create-general        Create general project"
    echo "  create-node-api       Create Node.js API"
    echo ""
    
    echo -e "${MAGENTA}Phase 2: Development Workflows${NC}"
    echo "  switch                Switch between projects"
    echo "  env                   Manage development environments"
    echo "  server                Manage dev servers"
    echo "  deps                  Update dependencies"
    echo ""
    
    echo -e "${MAGENTA}Phase 3: Deployment${NC}"
    echo "  deploy-hostinger      Deploy to Hostinger"
    echo "  deploy-vercel         Deploy to Vercel"
    echo "  deploy-netlify        Deploy to Netlify"
    echo "  deploy-docker         Build & push Docker images"
    echo "  deploy-appstore       Deploy to App Store"
    echo ""
    
    echo -e "${MAGENTA}Phase 4: Maintenance & Monitoring${NC}"
    echo "  backup                Manage backups"
    echo "  health                Check system health"
    echo "  logs                  Rotate & analyze logs"
    echo "  db                    Maintain databases"
    echo ""
    
    echo -e "${MAGENTA}Phase 5: CI/CD & Quality${NC}"
    echo "  ci                    Generate GitHub Actions"
    echo "  hooks                 Manage pre-commit hooks"
    echo "  test                  Run tests"
    echo "  quality               Check code quality"
    echo ""
    
    echo -e "${MAGENTA}Phase 6: Orchestration${NC}"
    echo "  workflow              Run end-to-end workflows"
    echo "  release               Manage releases"
    echo "  dashboard             View project status"
    echo ""
}

################################################################################
# Tool Execution
################################################################################

run_tool() {
    local tool="$1"
    shift
    local args="$@"
    
    case $tool in
        # Phase 1: Project Creation
        create-godot)
            "$PROJECT_CREATORS_DIR/create-godot-project.sh" $args
            ;;
        create-python)
            "$PROJECT_CREATORS_DIR/create-python-project.sh" $args
            ;;
        create-ios)
            "$PROJECT_CREATORS_DIR/create-ios-project.sh" $args
            ;;
        create-nextjs)
            "$PROJECT_CREATORS_DIR/create-nextjs-project.sh" $args
            ;;
        create-react)
            "$PROJECT_CREATORS_DIR/create-react-project.sh" $args
            ;;
        create-general)
            "$PROJECT_CREATORS_DIR/create-general-project.sh" $args
            ;;
        create-node-api)
            "$PROJECT_CREATORS_DIR/create-node-api-project.sh" $args
            ;;
        
        # Phase 2: Development Workflows
        switch)
            "$WORKFLOW_DIR/project-switcher.sh" $args
            ;;
        env)
            "$WORKFLOW_DIR/environment-manager.sh" $args
            ;;
        server)
            "$WORKFLOW_DIR/dev-server-manager.sh" $args
            ;;
        deps)
            "$WORKFLOW_DIR/dependency-updater.sh" $args
            ;;
        
        # Phase 3: Deployment
        deploy-hostinger)
            "$DEPLOYMENT_DIR/deploy-to-hostinger.sh" $args
            ;;
        deploy-vercel)
            "$DEPLOYMENT_DIR/deploy-to-vercel.sh" $args
            ;;
        deploy-netlify)
            "$DEPLOYMENT_DIR/deploy-to-netlify.sh" $args
            ;;
        deploy-docker)
            "$DEPLOYMENT_DIR/deploy-to-docker.sh" $args
            ;;
        deploy-appstore)
            "$DEPLOYMENT_DIR/deploy-to-appstore.sh" $args
            ;;
        
        # Phase 4: Maintenance
        backup)
            "$MAINTENANCE_DIR/backup-manager.sh" $args
            ;;
        health)
            "$MAINTENANCE_DIR/health-checker.sh" $args
            ;;
        logs)
            "$MAINTENANCE_DIR/log-rotator.sh" $args
            ;;
        db)
            "$MAINTENANCE_DIR/db-maintainer.sh" $args
            ;;
        
        # Phase 5: CI/CD
        ci)
            "$CICD_DIR/github-actions-generator.sh" $args
            ;;
        hooks)
            "$CICD_DIR/precommit-manager.sh" $args
            ;;
        test)
            "$CICD_DIR/test-runner.sh" $args
            ;;
        quality)
            "$CICD_DIR/code-quality-checker.sh" $args
            ;;
        
        # Phase 6: Orchestration
        workflow)
            run_workflow $args
            ;;
        release)
            run_release $args
            ;;
        dashboard)
            show_dashboard
            ;;
        
        *)
            print_error "Unknown tool: $tool"
            echo ""
            echo "Run 'dev-master list' to see all available tools"
            return 1
            ;;
    esac
}

################################################################################
# Workflow Automation
################################################################################

run_workflow() {
    local workflow_type="$1"
    local project_dir="${2:-.}"
    
    case $workflow_type in
        new)
            workflow_new_project
            ;;
        deploy)
            workflow_deploy_project "$project_dir"
            ;;
        quality)
            workflow_quality_check "$project_dir"
            ;;
        maintain)
            workflow_maintenance
            ;;
        *)
            print_error "Unknown workflow: $workflow_type"
            echo ""
            echo "Available workflows:"
            echo "  new      Create new project with full setup"
            echo "  deploy   Quality check → Test → Deploy"
            echo "  quality  Code quality → Tests → Security"
            echo "  maintain Run all maintenance tasks"
            return 1
            ;;
    esac
}

workflow_new_project() {
    print_section "New Project Workflow"
    
    echo "Select project type:"
    echo "  1) Godot Game"
    echo "  2) Python Project"
    echo "  3) iOS/Swift App"
    echo "  4) Next.js Web App"
    echo "  5) React/Vite App"
    echo "  6) Node.js API"
    echo "  7) General Project"
    echo ""
    
    read -p "Selection: " choice
    
    local creator=""
    case $choice in
        1) creator="create-godot" ;;
        2) creator="create-python" ;;
        3) creator="create-ios" ;;
        4) creator="create-nextjs" ;;
        5) creator="create-react" ;;
        6) creator="create-node-api" ;;
        7) creator="create-general" ;;
        *) print_error "Invalid selection"; return 1 ;;
    esac
    
    # Step 1: Create project
    print_info "Step 1/4: Creating project..."
    run_tool "$creator"
    
    # Get project directory (last created project)
    local project_dir=$(ls -td ~/Developer/projects/* | head -n 1)
    
    if [[ ! -d "$project_dir" ]]; then
        print_error "Project directory not found"
        return 1
    fi
    
    print_success "Project created: $project_dir"
    
    # Step 2: Initialize Git if not already
    if [[ ! -d "$project_dir/.git" ]]; then
        print_info "Step 2/4: Initializing Git repository..."
        cd "$project_dir"
        git init
        git add .
        git commit -m "Initial commit"
        print_success "Git repository initialized"
    else
        print_info "Step 2/4: Git repository already initialized"
    fi
    
    # Step 3: Setup CI/CD
    print_info "Step 3/4: Setting up CI/CD pipelines..."
    run_tool ci all "$project_dir"
    print_success "CI/CD configured"
    
    # Step 4: Setup pre-commit hooks
    print_info "Step 4/4: Installing pre-commit hooks..."
    run_tool hooks init "$project_dir"
    print_success "Pre-commit hooks installed"
    
    print_section "Project Setup Complete! 🎉"
    print_info "Project location: $project_dir"
    print_info "Next steps:"
    echo "  1. cd $project_dir"
    echo "  2. Open in your IDE"
    echo "  3. Start coding!"
    echo "  4. Run 'dev-master deploy' when ready to deploy"
}

workflow_deploy_project() {
    local project_dir="$1"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    print_section "Deployment Workflow"
    print_info "Project: $(basename "$project_dir")"
    echo ""
    
    # Step 1: Code quality check
    print_info "Step 1/4: Running code quality checks..."
    if run_tool quality check "$project_dir"; then
        print_success "Code quality checks passed"
    else
        print_warning "Code quality issues found"
        read -p "Continue anyway? (y/n): " continue_choice
        if [[ "$continue_choice" != "y" ]]; then
            print_error "Deployment cancelled"
            return 1
        fi
    fi
    
    # Step 2: Run tests
    print_info "Step 2/4: Running tests..."
    if run_tool test run "$project_dir"; then
        print_success "Tests passed"
    else
        print_error "Tests failed"
        read -p "Continue anyway? (y/n): " continue_choice
        if [[ "$continue_choice" != "y" ]]; then
            print_error "Deployment cancelled"
            return 1
        fi
    fi
    
    # Step 3: Build (if applicable)
    print_info "Step 3/4: Building project..."
    cd "$project_dir"
    
    if [[ -f "package.json" ]] && grep -q '"build"' package.json; then
        npm run build
        print_success "Build completed"
    elif [[ -f "Cargo.toml" ]]; then
        cargo build --release
        print_success "Build completed"
    elif [[ -f "go.mod" ]]; then
        go build
        print_success "Build completed"
    else
        print_info "No build step required"
    fi
    
    # Step 4: Deploy
    print_info "Step 4/4: Deploying..."
    echo ""
    echo "Select deployment target:"
    echo "  1) Hostinger (SFTP)"
    echo "  2) Vercel"
    echo "  3) Netlify"
    echo "  4) Docker Registry"
    echo "  5) App Store"
    echo ""
    
    read -p "Selection: " deploy_choice
    
    case $deploy_choice in
        1) run_tool deploy-hostinger --deploy "$project_dir" ;;
        2) run_tool deploy-vercel --deploy "$project_dir" ;;
        3) run_tool deploy-netlify --deploy "$project_dir" ;;
        4) run_tool deploy-docker --push "$project_dir" ;;
        5) run_tool deploy-appstore --appstore "$project_dir" ;;
        *) print_error "Invalid selection"; return 1 ;;
    esac
    
    print_section "Deployment Complete! 🚀"
}

workflow_quality_check() {
    local project_dir="$1"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    print_section "Quality Check Workflow"
    print_info "Project: $(basename "$project_dir")"
    echo ""
    
    local issues=0
    
    # Step 1: Code quality
    print_info "Step 1/3: Checking code quality..."
    if run_tool quality check "$project_dir"; then
        print_success "Code quality passed"
    else
        print_error "Code quality issues found"
        ((issues++))
    fi
    
    # Step 2: Tests
    print_info "Step 2/3: Running tests..."
    if run_tool test coverage "$project_dir"; then
        print_success "Tests passed"
    else
        print_error "Tests failed"
        ((issues++))
    fi
    
    # Step 3: Security scan (if applicable)
    print_info "Step 3/3: Security scan..."
    cd "$project_dir"
    
    if [[ -f "package.json" ]]; then
        if npm audit --audit-level=moderate; then
            print_success "No security vulnerabilities"
        else
            print_warning "Security vulnerabilities found"
            ((issues++))
        fi
    elif [[ -f "Cargo.toml" ]]; then
        if command -v cargo-audit >/dev/null 2>&1; then
            if cargo audit; then
                print_success "No security vulnerabilities"
            else
                print_warning "Security vulnerabilities found"
                ((issues++))
            fi
        else
            print_info "cargo-audit not installed, skipping"
        fi
    else
        print_info "No security scan available for this project type"
    fi
    
    # Summary
    print_section "Quality Check Summary"
    if [[ $issues -eq 0 ]]; then
        print_success "All checks passed! ✨"
    else
        print_warning "Found $issues issue(s)"
        echo "Run 'dev-master quality fix' to auto-fix some issues"
    fi
}

workflow_maintenance() {
    print_section "Maintenance Workflow"
    
    # Step 1: Backup
    print_info "Step 1/4: Creating backups..."
    run_tool backup --backup ~/Developer
    
    # Step 2: Health check
    print_info "Step 2/4: Checking system health..."
    run_tool health --check
    
    # Step 3: Log rotation
    print_info "Step 3/4: Rotating logs..."
    run_tool logs --rotate
    
    # Step 4: Database maintenance
    print_info "Step 4/4: Maintaining databases..."
    run_tool db --optimize
    
    print_section "Maintenance Complete! ✨"
}

################################################################################
# Release Management
################################################################################

run_release() {
    local version="$1"
    local project_dir="${2:-.}"
    
    if [[ -z "$version" ]]; then
        print_error "Version required"
        echo "Usage: dev-master release <version> [project_dir]"
        echo "Example: dev-master release 1.2.0"
        return 1
    fi
    
    project_dir=$(cd "$project_dir" && pwd)
    
    print_section "Release $version"
    print_info "Project: $(basename "$project_dir")"
    echo ""
    
    cd "$project_dir"
    
    # Verify git is clean
    if [[ -n $(git status --porcelain) ]]; then
        print_error "Working directory not clean. Commit or stash changes first."
        return 1
    fi
    
    # Step 1: Quality checks
    print_info "Step 1/6: Running quality checks..."
    workflow_quality_check "$project_dir"
    
    # Step 2: Update version
    print_info "Step 2/6: Updating version..."
    
    if [[ -f "package.json" ]]; then
        npm version "$version" --no-git-tag-version
    elif [[ -f "pyproject.toml" ]]; then
        sed -i '' "s/^version = .*/version = \"$version\"/" pyproject.toml
    elif [[ -f "Cargo.toml" ]]; then
        sed -i '' "s/^version = .*/version = \"$version\"/" Cargo.toml
    fi
    
    print_success "Version updated to $version"
    
    # Step 3: Update changelog
    print_info "Step 3/6: Updating changelog..."
    
    if [[ ! -f "CHANGELOG.md" ]]; then
        cat > CHANGELOG.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

## [$version] - $(date +%Y-%m-%d)

### Added
- Initial release

EOF
    else
        # Add new section to changelog
        sed -i '' "3i\\
\\
## [$version] - $(date +%Y-%m-%d)\\
\\
### Added\\
- Release $version\\
" CHANGELOG.md
    fi
    
    print_success "Changelog updated"
    
    # Step 4: Commit changes
    print_info "Step 4/6: Committing release..."
    git add .
    git commit -m "Release $version"
    print_success "Changes committed"
    
    # Step 5: Create tag
    print_info "Step 5/6: Creating git tag..."
    git tag -a "v$version" -m "Release $version"
    print_success "Tag created: v$version"
    
    # Step 6: Push
    print_info "Step 6/6: Pushing to remote..."
    read -p "Push to remote? (y/n): " push_choice
    
    if [[ "$push_choice" == "y" ]]; then
        git push origin main
        git push origin "v$version"
        print_success "Pushed to remote"
    else
        print_info "Skipped push. Run manually: git push origin main && git push origin v$version"
    fi
    
    print_section "Release $version Complete! 🎉"
    echo "Next steps:"
    echo "  1. Create GitHub/GitLab release from tag v$version"
    echo "  2. Deploy with: dev-master deploy"
    echo "  3. Announce release to team"
}

################################################################################
# Development Dashboard
################################################################################

show_dashboard() {
    print_section "Development Dashboard"
    
    local workspace_dir="$HOME/Developer"
    
    # Project count
    local project_count=$(find "$workspace_dir" -name ".git" -type d -maxdepth 3 | wc -l | tr -d ' ')
    print_info "Total projects: $project_count"
    echo ""
    
    # Recent projects
    echo -e "${CYAN}Recent Projects:${NC}"
    find "$workspace_dir/projects" -type d -maxdepth 1 -mindepth 1 -not -name ".*" | \
        xargs ls -dt | head -n 5 | while read dir; do
        echo "  • $(basename "$dir")"
    done
    echo ""
    
    # Running dev servers
    echo -e "${CYAN}Active Dev Servers:${NC}"
    if pgrep -f "next dev\|vite\|npm run dev" >/dev/null; then
        pgrep -lf "next dev\|vite\|npm run dev" | while read pid cmd; do
            echo "  • PID $pid: $(echo "$cmd" | cut -d' ' -f1-3)"
        done
    else
        echo "  No active dev servers"
    fi
    echo ""
    
    # System health
    echo -e "${CYAN}System Health:${NC}"
    
    # Disk space
    local disk_usage=$(df -h ~ | tail -n 1 | awk '{print $5}' | tr -d '%')
    if [[ $disk_usage -lt 80 ]]; then
        print_success "Disk space: ${disk_usage}% used"
    else
        print_warning "Disk space: ${disk_usage}% used (getting full)"
    fi
    
    # Memory
    local memory_pressure=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%')
    if [[ -n "$memory_pressure" ]] && [[ $memory_pressure -gt 20 ]]; then
        print_success "Memory: ${memory_pressure}% free"
    else
        print_warning "Memory pressure detected"
    fi
    
    echo ""
    
    # Quick actions
    echo -e "${CYAN}Quick Actions:${NC}"
    echo "  dev-master workflow new      Create new project"
    echo "  dev-master workflow deploy   Deploy current project"
    echo "  dev-master quality fix       Fix code quality issues"
    echo "  dev-master test run          Run tests"
    echo "  dev-master backup --backup   Backup projects"
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    clear
    print_header
    
    echo -e "${CYAN}Main Menu:${NC}"
    echo "  1) Show all tools"
    echo "  2) Create new project"
    echo "  3) Deploy project"
    echo "  4) Run quality checks"
    echo "  5) Run tests"
    echo "  6) Maintenance tasks"
    echo "  7) Create release"
    echo "  8) Show dashboard"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            discover_tools
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode
            ;;
        2)
            workflow_new_project
            ;;
        3)
            read -p "Project directory [current]: " proj_dir
            proj_dir="${proj_dir:-.}"
            workflow_deploy_project "$proj_dir"
            ;;
        4)
            read -p "Project directory [current]: " proj_dir
            proj_dir="${proj_dir:-.}"
            workflow_quality_check "$proj_dir"
            ;;
        5)
            read -p "Project directory [current]: " proj_dir
            proj_dir="${proj_dir:-.}"
            run_tool test interactive "$proj_dir"
            ;;
        6)
            workflow_maintenance
            ;;
        7)
            read -p "Version (e.g., 1.2.0): " version
            read -p "Project directory [current]: " proj_dir
            proj_dir="${proj_dir:-.}"
            run_release "$version" "$proj_dir"
            ;;
        8)
            show_dashboard
            echo ""
            read -p "Press Enter to continue..."
            interactive_mode
            ;;
        q|Q)
            print_info "Goodbye! 👋"
            exit 0
            ;;
        *)
            print_error "Invalid selection"
            sleep 1
            interactive_mode
            ;;
    esac
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: dev-master [COMMAND] [ARGS...]"
    echo ""
    echo "Commands:"
    echo "  list                 List all available tools"
    echo "  <tool> [args]        Run specific tool (see list)"
    echo "  workflow <type>      Run automated workflow"
    echo "  release <version>    Create and tag release"
    echo "  dashboard            Show development dashboard"
    echo "  interactive          Interactive mode"
    echo ""
    echo "Workflows:"
    echo "  workflow new         Create new project with full setup"
    echo "  workflow deploy      Quality → Test → Deploy"
    echo "  workflow quality     Full quality check"
    echo "  workflow maintain    Run all maintenance tasks"
    echo ""
    echo "Examples:"
    echo "  dev-master list"
    echo "  dev-master create-nextjs"
    echo "  dev-master workflow deploy"
    echo "  dev-master release 1.2.0"
    echo "  dev-master dashboard"
    echo "  dev-master interactive"
}

main() {
    if [[ $# -eq 0 ]]; then
        interactive_mode
        return
    fi
    
    local command="$1"
    shift
    
    print_header
    
    case $command in
        list)
            discover_tools
            ;;
        workflow)
            run_workflow "$@"
            ;;
        release)
            run_release "$@"
            ;;
        dashboard)
            show_dashboard
            ;;
        interactive)
            interactive_mode
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            run_tool "$command" "$@"
            ;;
    esac
}

main "$@"
