#!/bin/bash

################################################################################
# Deploy to Docker Registry
# Automated Docker build and push workflow
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default registry
DEFAULT_REGISTRY="docker.io"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🐳 Docker Registry Deployment${NC}"
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
# Docker Check
################################################################################

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker not found"
        print_info "Install from: https://www.docker.com/get-started"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon not running"
        print_info "Start Docker Desktop or Docker daemon"
        exit 1
    fi
    
    print_success "Docker found and running"
}

################################################################################
# Registry Management
################################################################################

docker_login() {
    local registry="${1:-$DEFAULT_REGISTRY}"
    local username="$2"
    
    print_info "Logging into registry: $registry"
    
    if [[ -n "$username" ]]; then
        if docker login "$registry" -u "$username"; then
            print_success "Logged in as: $username"
        else
            print_error "Login failed"
            exit 1
        fi
    else
        if docker login "$registry"; then
            print_success "Logged into $registry"
        else
            print_error "Login failed"
            exit 1
        fi
    fi
}

################################################################################
# Project Detection
################################################################################

detect_dockerfile() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/Dockerfile" ]]; then
        echo "$project_dir/Dockerfile"
    elif [[ -f "$project_dir/docker/Dockerfile" ]]; then
        echo "$project_dir/docker/Dockerfile"
    else
        echo ""
    fi
}

get_image_name() {
    local project_dir="$1"
    
    if [[ -f "$project_dir/package.json" ]]; then
        local name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$project_dir/package.json" | sed 's/"name"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')
        echo "$name"
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        local name=$(grep -o 'name[[:space:]]*=[[:space:]]*"[^"]*"' "$project_dir/pyproject.toml" | head -1 | sed 's/name[[:space:]]*=[[:space:]]*"\([^"]*\)"/\1/')
        echo "$name"
    else
        basename "$project_dir"
    fi
}

get_version_tag() {
    local project_dir="$1"
    
    cd "$project_dir" || return
    
    # Try git tag first
    if git describe --tags --abbrev=0 2>/dev/null; then
        return
    fi
    
    # Try package.json version
    if [[ -f "package.json" ]]; then
        grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | sed 's/"version"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/'
        return
    fi
    
    # Try pyproject.toml version
    if [[ -f "pyproject.toml" ]]; then
        grep -o 'version[[:space:]]*=[[:space:]]*"[^"]*"' pyproject.toml | head -1 | sed 's/version[[:space:]]*=[[:space:]]*"\([^"]*\)"/\1/'
        return
    fi
    
    # Default to timestamp
    date +%Y%m%d-%H%M%S
}

################################################################################
# Dockerfile Generation
################################################################################

create_nodejs_dockerfile() {
    local project_dir="$1"
    
    cat > "$project_dir/Dockerfile" << 'EOF'
# Multi-stage build for Node.js application

# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build application (if needed)
RUN if grep -q '"build"' package.json; then npm run build; fi

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copy dependencies from builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy application
COPY --chown=nodejs:nodejs . .

# Copy built files if they exist
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist 2>/dev/null || true
COPY --from=builder --chown=nodejs:nodejs /app/build ./build 2>/dev/null || true

USER nodejs

EXPOSE 3000

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "index.js"]
EOF
    
    print_success "Created Dockerfile for Node.js"
}

create_python_dockerfile() {
    local project_dir="$1"
    
    cat > "$project_dir/Dockerfile" << 'EOF'
# Multi-stage build for Python application

# Build stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt* pyproject.toml* poetry.lock* ./

# Install dependencies
RUN if [ -f requirements.txt ]; then \
        pip install --user --no-cache-dir -r requirements.txt; \
    elif [ -f pyproject.toml ]; then \
        pip install --user --no-cache-dir poetry && \
        poetry config virtualenvs.create false && \
        poetry install --no-dev; \
    fi

# Production stage
FROM python:3.11-slim

WORKDIR /app

# Copy Python packages
COPY --from=builder /root/.local /root/.local

# Copy application
COPY . .

# Create non-root user
RUN useradd -m -u 1001 appuser && \
    chown -R appuser:appuser /app

USER appuser

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000

CMD ["python", "main.py"]
EOF
    
    print_success "Created Dockerfile for Python"
}

create_dockerfile_interactive() {
    local project_dir="$1"
    
    print_info "Dockerfile not found"
    echo ""
    echo "Select project type:"
    echo "  1) Node.js"
    echo "  2) Python"
    echo "  3) Cancel"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            create_nodejs_dockerfile "$project_dir"
            ;;
        2)
            create_python_dockerfile "$project_dir"
            ;;
        *)
            print_info "Cancelled"
            exit 0
            ;;
    esac
}

################################################################################
# Build Functions
################################################################################

build_image() {
    local project_dir="$1"
    local image_name="$2"
    local tag="${3:-latest}"
    local dockerfile="$4"
    
    cd "$project_dir" || exit 1
    
    print_info "Building image: $image_name:$tag"
    
    local build_args=()
    
    if [[ -n "$dockerfile" && "$dockerfile" != "Dockerfile" ]]; then
        build_args+=(-f "$dockerfile")
    fi
    
    if docker build "${build_args[@]}" -t "$image_name:$tag" .; then
        print_success "Image built: $image_name:$tag"
        
        # Show image size
        local size=$(docker images "$image_name:$tag" --format "{{.Size}}")
        print_info "Image size: $size"
    else
        print_error "Build failed"
        exit 1
    fi
}

build_multi_platform() {
    local project_dir="$1"
    local image_name="$2"
    local tag="${3:-latest}"
    local dockerfile="${4:-Dockerfile}"
    
    cd "$project_dir" || exit 1
    
    print_info "Building multi-platform image: $image_name:$tag"
    print_info "Platforms: linux/amd64, linux/arm64"
    
    if docker buildx build \
        --platform linux/amd64,linux/arm64 \
        -f "$dockerfile" \
        -t "$image_name:$tag" \
        --push \
        .; then
        print_success "Multi-platform image built and pushed"
    else
        print_error "Build failed"
        exit 1
    fi
}

################################################################################
# Push Functions
################################################################################

tag_and_push() {
    local image_name="$1"
    local local_tag="$2"
    local registry="$3"
    local remote_tag="${4:-$local_tag}"
    
    local full_image="$registry/$image_name:$remote_tag"
    
    print_info "Tagging: $image_name:$local_tag → $full_image"
    
    if docker tag "$image_name:$local_tag" "$full_image"; then
        print_success "Tagged: $full_image"
    else
        print_error "Tagging failed"
        exit 1
    fi
    
    print_info "Pushing: $full_image"
    
    if docker push "$full_image"; then
        print_success "Pushed: $full_image"
    else
        print_error "Push failed"
        exit 1
    fi
}

push_multiple_tags() {
    local image_name="$1"
    local registry="$2"
    local version_tag="$3"
    
    # Push version tag
    tag_and_push "$image_name" "latest" "$registry" "$version_tag"
    
    # Push latest tag
    tag_and_push "$image_name" "latest" "$registry" "latest"
    
    print_success "Pushed multiple tags"
}

################################################################################
# Test Functions
################################################################################

test_image() {
    local image_name="$1"
    local tag="${2:-latest}"
    local port="${3:-3000}"
    
    print_info "Testing image: $image_name:$tag"
    
    local container_name="test-$(basename "$image_name")-$$"
    
    print_info "Starting container: $container_name"
    
    if docker run -d \
        --name "$container_name" \
        -p "$port:$port" \
        "$image_name:$tag"; then
        
        print_success "Container started"
        print_info "Container ID: $(docker ps -q -f name=$container_name)"
        print_info "Test at: http://localhost:$port"
        echo ""
        print_warning "Stop with: docker stop $container_name && docker rm $container_name"
    else
        print_error "Container failed to start"
        docker logs "$container_name" 2>&1 | tail -20
        docker rm -f "$container_name" 2>/dev/null
        exit 1
    fi
}

################################################################################
# Image Management
################################################################################

list_local_images() {
    local image_pattern="${1:-*}"
    
    print_info "Local Docker images:"
    docker images "$image_pattern"
}

prune_images() {
    print_warning "This will remove unused images"
    read -p "Continue? (y/n): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker image prune -a -f
        print_success "Unused images removed"
    else
        print_info "Cancelled"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_deploy() {
    local project_dir="${1:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local dockerfile=$(detect_dockerfile "$project_dir")
    local image_name=$(get_image_name "$project_dir")
    local version=$(get_version_tag "$project_dir")
    
    print_info "Project: $(basename "$project_dir")"
    print_info "Image name: $image_name"
    print_info "Version: $version"
    
    if [[ -z "$dockerfile" ]]; then
        print_warning "No Dockerfile found"
        create_dockerfile_interactive "$project_dir"
        dockerfile="$project_dir/Dockerfile"
    else
        print_info "Dockerfile: $dockerfile"
    fi
    
    echo ""
    echo -e "${CYAN}Deployment Options:${NC}"
    echo "  1) Build image"
    echo "  2) Build and push to registry"
    echo "  3) Build multi-platform image"
    echo "  4) Test image locally"
    echo "  5) List local images"
    echo "  6) Login to registry"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            build_image "$project_dir" "$image_name" "$version" "$dockerfile"
            ;;
        2)
            read -p "Registry (default: docker.io): " registry
            registry="${registry:-docker.io}"
            read -p "Registry username: " username
            
            docker_login "$registry" "$username"
            build_image "$project_dir" "$image_name" "$version" "$dockerfile"
            push_multiple_tags "$image_name" "$registry/$username" "$version"
            ;;
        3)
            read -p "Registry (default: docker.io): " registry
            registry="${registry:-docker.io}"
            read -p "Registry username: " username
            
            docker_login "$registry" "$username"
            build_multi_platform "$project_dir" "$registry/$username/$image_name" "$version" "$dockerfile"
            ;;
        4)
            build_image "$project_dir" "$image_name" "$version" "$dockerfile"
            read -p "Test port (default: 3000): " port
            port="${port:-3000}"
            test_image "$image_name" "$version" "$port"
            ;;
        5)
            list_local_images "$image_name"
            ;;
        6)
            read -p "Registry (default: docker.io): " registry
            registry="${registry:-docker.io}"
            docker_login "$registry"
            ;;
        q|Q)
            print_info "Cancelled"
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
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build [DIR]              Build Docker image"
    echo "  push [IMAGE] [REGISTRY]  Push image to registry"
    echo "  test [IMAGE]             Test image locally"
    echo "  login [REGISTRY]         Login to registry"
    echo "  list                     List local images"
    echo "  interactive [DIR]        Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 build"
    echo "  $0 push my-app docker.io/username"
    echo "  $0 test my-app:latest"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    
    print_header
    
    check_docker
    
    echo ""
    
    case $command in
        build)
            local project_dir="${2:-.}"
            project_dir=$(cd "$project_dir" && pwd)
            
            local dockerfile=$(detect_dockerfile "$project_dir")
            local image_name=$(get_image_name "$project_dir")
            local version=$(get_version_tag "$project_dir")
            
            if [[ -z "$dockerfile" ]]; then
                create_dockerfile_interactive "$project_dir"
                dockerfile="$project_dir/Dockerfile"
            fi
            
            build_image "$project_dir" "$image_name" "$version" "$dockerfile"
            ;;
        push)
            local image="${2}"
            local registry="${3:-docker.io}"
            
            if [[ -z "$image" ]]; then
                print_error "Image name required"
                show_usage
                exit 1
            fi
            
            docker_login "$registry"
            tag_and_push "$image" "latest" "$registry"
            ;;
        test)
            local image="${2}"
            local port="${3:-3000}"
            
            if [[ -z "$image" ]]; then
                print_error "Image name required"
                show_usage
                exit 1
            fi
            
            test_image "$image" "latest" "$port"
            ;;
        login)
            local registry="${2:-docker.io}"
            docker_login "$registry"
            ;;
        list)
            list_local_images
            ;;
        interactive)
            local project_dir="${2:-.}"
            interactive_deploy "$project_dir"
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
