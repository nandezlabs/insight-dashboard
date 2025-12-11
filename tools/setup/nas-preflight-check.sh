#!/bin/bash

################################################################################
# NAS Setup Pre-Flight Check
# Verifies Mac is ready for NAS setup and deployment
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🚀 NAS Setup Pre-Flight Check${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_section() {
    echo -e "\n${BLUE}▸ $1${NC}"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

print_info() {
    echo -e "  ${YELLOW}ℹ${NC} $1"
}

# Check counters
checks_passed=0
checks_failed=0
checks_warning=0

check_ssh_key() {
    print_section "SSH Key Setup"
    
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        print_success "SSH key exists"
        print_info "Public key: $(cat ~/.ssh/id_ed25519.pub)"
        ((checks_passed++))
    else
        print_error "SSH key not found"
        print_info "Run: ssh-keygen -t ed25519 -C 'nandez@mac'"
        ((checks_failed++))
    fi
}

check_network_tools() {
    print_section "Network Tools"
    
    local tools=("ping" "ssh" "scp" "nc" "arp")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_success "$tool available"
            ((checks_passed++))
        else
            print_error "$tool not found"
            ((checks_failed++))
        fi
    done
}

check_homebrew() {
    print_section "Homebrew Packages"
    
    if command -v brew &> /dev/null; then
        print_success "Homebrew installed"
        ((checks_passed++))
        
        # Check for useful packages
        local packages=("wget" "curl" "jq")
        for pkg in "${packages[@]}"; do
            if brew list "$pkg" &> /dev/null 2>&1; then
                print_success "$pkg installed"
                ((checks_passed++))
            else
                print_warning "$pkg not installed (optional)"
                ((checks_warning++))
            fi
        done
    else
        print_error "Homebrew not installed"
        ((checks_failed++))
    fi
}

check_docker() {
    print_section "Docker"
    
    if command -v docker &> /dev/null; then
        if docker ps &> /dev/null; then
            print_success "Docker running"
            ((checks_passed++))
        else
            print_warning "Docker installed but not running"
            print_info "Start Docker Desktop"
            ((checks_warning++))
        fi
    else
        print_warning "Docker not installed (needed for local testing)"
        ((checks_warning++))
    fi
}

check_nas_configs() {
    print_section "NAS Configuration Files"
    
    local config_dir="$HOME/Developer/temp-workspace/nas-configs"
    
    if [[ -d "$config_dir" ]]; then
        print_success "Config directory exists"
        ((checks_passed++))
        
        local configs=("docker-compose.yml" "setup-nas-dirs.sh" "deploy-to-nas.sh")
        for config in "${configs[@]}"; do
            if [[ -f "$config_dir/$config" ]]; then
                print_success "$config ready"
                ((checks_passed++))
            else
                print_warning "$config not found"
                ((checks_warning++))
            fi
        done
    else
        print_error "Config directory not found: $config_dir"
        ((checks_failed++))
    fi
}

check_setup_scripts() {
    print_section "Setup Scripts"
    
    local scripts=(
        "$HOME/Developer/temp-workspace/nas-setup-prep.sh"
        "$HOME/Developer/tools/setup/setup-nas.sh"
        "$HOME/Developer/tools/deployment/nas-deploy.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            if [[ -x "$script" ]]; then
                print_success "$(basename "$script") ready"
                ((checks_passed++))
            else
                print_warning "$(basename "$script") not executable"
                print_info "Run: chmod +x $script"
                ((checks_warning++))
            fi
        else
            print_error "$(basename "$script") not found"
            ((checks_failed++))
        fi
    done
}

check_nas_connection() {
    print_section "NAS Connection"
    
    echo -n "  Enter NAS IP address (or press Enter to skip): "
    read -r nas_ip
    
    if [[ -n "$nas_ip" ]]; then
        if ping -c 1 -W 2 "$nas_ip" &> /dev/null; then
            print_success "NAS is reachable at $nas_ip"
            ((checks_passed++))
            
            # Try web interface
            if curl -s -o /dev/null -w "%{http_code}" "http://$nas_ip" --connect-timeout 2 | grep -q "200\|301\|302"; then
                print_success "Web interface accessible"
                print_info "Open: http://$nas_ip"
                ((checks_passed++))
            else
                print_warning "Web interface not responding"
                print_info "Try: http://$nas_ip:5000 or http://$nas_ip:9999"
                ((checks_warning++))
            fi
        else
            print_error "Cannot reach NAS at $nas_ip"
            print_info "Check physical connection and NAS power"
            ((checks_failed++))
        fi
    else
        print_info "Skipped NAS connection check"
    fi
}

show_next_steps() {
    print_section "Next Steps"
    
    if [[ $checks_failed -eq 0 ]]; then
        print_success "All critical checks passed!"
        echo ""
        print_info "Ready to proceed with NAS setup. Choose one:"
        echo ""
        echo "  1️⃣  First-time setup (follow guide):"
        echo "      code ~/Developer/temp-workspace/NAS-First-Time-Setup.md"
        echo ""
        echo "  2️⃣  Run Mac preparation script:"
        echo "      bash ~/Developer/temp-workspace/nas-setup-prep.sh"
        echo ""
        echo "  3️⃣  Automated NAS configuration:"
        echo "      bash ~/Developer/tools/setup/setup-nas.sh"
        echo ""
        echo "  4️⃣  Deploy services to NAS:"
        echo "      bash ~/Developer/tools/deployment/nas-deploy.sh"
    else
        print_error "Some critical checks failed!"
        echo ""
        print_info "Fix the issues above before proceeding."
    fi
}

show_summary() {
    print_section "Summary"
    
    echo -e "  ${GREEN}✓ Passed:${NC}  $checks_passed"
    echo -e "  ${YELLOW}⚠ Warnings:${NC} $checks_warning"
    echo -e "  ${RED}✗ Failed:${NC}  $checks_failed"
}

main() {
    print_header
    
    check_ssh_key
    check_network_tools
    check_homebrew
    check_docker
    check_nas_configs
    check_setup_scripts
    check_nas_connection
    
    show_summary
    show_next_steps
    
    echo ""
}

main "$@"
