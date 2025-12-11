#!/bin/bash

################################################################################
# Deploy to App Store
# Automated iOS app deployment workflow
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📱 App Store Deployment${NC}"
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
# Xcode Check
################################################################################

check_xcode() {
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode not found"
        print_info "Install from: https://developer.apple.com/xcode/"
        exit 1
    fi
    
    local version=$(xcodebuild -version | head -1)
    print_success "Xcode found: $version"
}

check_signing() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    print_info "Checking code signing..."
    
    # Find the workspace or project file
    local workspace=$(find . -maxdepth 1 -name "*.xcworkspace" | head -1)
    local project=$(find . -maxdepth 1 -name "*.xcodeproj" | head -1)
    
    if [[ -n "$workspace" ]]; then
        xcodebuild -workspace "$workspace" -list | grep -A 3 "Schemes:" || true
    elif [[ -n "$project" ]]; then
        xcodebuild -project "$project" -list | grep -A 3 "Schemes:" || true
    fi
    
    print_success "Code signing check complete"
}

################################################################################
# Project Detection
################################################################################

find_xcworkspace() {
    local project_dir="$1"
    find "$project_dir" -maxdepth 1 -name "*.xcworkspace" | head -1
}

find_xcodeproj() {
    local project_dir="$1"
    find "$project_dir" -maxdepth 1 -name "*.xcodeproj" | head -1
}

get_schemes() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    local workspace=$(find_xcworkspace "$project_dir")
    local project=$(find_xcodeproj "$project_dir")
    
    if [[ -n "$workspace" ]]; then
        xcodebuild -workspace "$workspace" -list 2>/dev/null | awk '/Schemes:/,/^$/ {if ($0 !~ /Schemes:/ && $0 !~ /^$/) print $0}'
    elif [[ -n "$project" ]]; then
        xcodebuild -project "$project" -list 2>/dev/null | awk '/Schemes:/,/^$/ {if ($0 !~ /Schemes:/ && $0 !~ /^$/) print $0}'
    fi
}

get_app_version() {
    local project_dir="$1"
    
    # Try to find Info.plist
    local info_plist=$(find "$project_dir" -name "Info.plist" | head -1)
    
    if [[ -f "$info_plist" ]]; then
        /usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$info_plist" 2>/dev/null || echo "1.0.0"
    else
        echo "1.0.0"
    fi
}

get_bundle_id() {
    local project_dir="$1"
    
    local info_plist=$(find "$project_dir" -name "Info.plist" | head -1)
    
    if [[ -f "$info_plist" ]]; then
        /usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$info_plist" 2>/dev/null || echo ""
    else
        echo ""
    fi
}

################################################################################
# Build Functions
################################################################################

clean_build() {
    local project_dir="$1"
    local scheme="$2"
    
    cd "$project_dir" || exit 1
    
    print_info "Cleaning build..."
    
    local workspace=$(find_xcworkspace "$project_dir")
    local project=$(find_xcodeproj "$project_dir")
    
    if [[ -n "$workspace" ]]; then
        xcodebuild clean -workspace "$workspace" -scheme "$scheme"
    elif [[ -n "$project" ]]; then
        xcodebuild clean -project "$project" -scheme "$scheme"
    fi
    
    print_success "Build cleaned"
}

build_archive() {
    local project_dir="$1"
    local scheme="$2"
    local configuration="${3:-Release}"
    
    cd "$project_dir" || exit 1
    
    print_info "Building archive for scheme: $scheme"
    
    local workspace=$(find_xcworkspace "$project_dir")
    local project=$(find_xcodeproj "$project_dir")
    local archive_path="$project_dir/build/${scheme}.xcarchive"
    
    mkdir -p "$project_dir/build"
    
    local build_args=(
        -configuration "$configuration"
        -scheme "$scheme"
        -archivePath "$archive_path"
        -destination "generic/platform=iOS"
        archive
    )
    
    if [[ -n "$workspace" ]]; then
        xcodebuild -workspace "$workspace" "${build_args[@]}"
    elif [[ -n "$project" ]]; then
        xcodebuild -project "$project" "${build_args[@]}"
    else
        print_error "No workspace or project found"
        exit 1
    fi
    
    if [[ $? -eq 0 ]]; then
        print_success "Archive created: $archive_path"
        echo "$archive_path"
    else
        print_error "Archive failed"
        exit 1
    fi
}

################################################################################
# Export Functions
################################################################################

create_export_options() {
    local project_dir="$1"
    local method="${2:-app-store}"  # app-store, ad-hoc, development, enterprise
    local bundle_id="$3"
    
    local export_options="$project_dir/build/ExportOptions.plist"
    
    cat > "$export_options" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>$method</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
EOF
    
    print_info "Created export options at: $export_options"
    print_warning "Edit ExportOptions.plist to set your Team ID"
    echo "$export_options"
}

export_ipa() {
    local archive_path="$1"
    local export_options="$2"
    local output_dir="${3:-build/ipa}"
    
    local project_dir=$(dirname "$(dirname "$archive_path")")
    
    cd "$project_dir" || exit 1
    
    print_info "Exporting IPA..."
    
    mkdir -p "$output_dir"
    
    if xcodebuild -exportArchive \
        -archivePath "$archive_path" \
        -exportOptionsPlist "$export_options" \
        -exportPath "$output_dir" \
        -allowProvisioningUpdates; then
        
        local ipa_file=$(find "$output_dir" -name "*.ipa" | head -1)
        print_success "IPA exported: $ipa_file"
        echo "$ipa_file"
    else
        print_error "Export failed"
        exit 1
    fi
}

################################################################################
# Upload Functions
################################################################################

validate_ipa() {
    local ipa_path="$1"
    local username="$2"
    local password="$3"
    
    print_info "Validating IPA..."
    
    if xcrun altool --validate-app \
        -f "$ipa_path" \
        -t ios \
        -u "$username" \
        -p "$password"; then
        
        print_success "IPA validation passed"
    else
        print_error "IPA validation failed"
        exit 1
    fi
}

upload_ipa() {
    local ipa_path="$1"
    local username="$2"
    local password="$3"
    
    print_info "Uploading to App Store Connect..."
    print_warning "This may take several minutes"
    
    if xcrun altool --upload-app \
        -f "$ipa_path" \
        -t ios \
        -u "$username" \
        -p "$password"; then
        
        print_success "Upload complete!"
        print_info "Check App Store Connect for processing status"
        print_info "https://appstoreconnect.apple.com"
    else
        print_error "Upload failed"
        exit 1
    fi
}

################################################################################
# TestFlight
################################################################################

upload_to_testflight() {
    local ipa_path="$1"
    local username="$2"
    local password="$3"
    
    print_info "Uploading to TestFlight..."
    
    validate_ipa "$ipa_path" "$username" "$password"
    upload_ipa "$ipa_path" "$username" "$password"
    
    print_success "Uploaded to TestFlight!"
    print_info "Build will be available for testing shortly"
}

################################################################################
# Certificate Management
################################################################################

list_certificates() {
    print_info "Developer certificates:"
    security find-identity -v -p codesigning
}

list_provisioning_profiles() {
    print_info "Provisioning profiles:"
    local profiles_dir="$HOME/Library/MobileDevice/Provisioning Profiles"
    
    if [[ -d "$profiles_dir" ]]; then
        ls -1 "$profiles_dir" | head -10
    else
        print_warning "No provisioning profiles found"
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_deploy() {
    local project_dir="${1:-.}"
    
    project_dir=$(cd "$project_dir" && pwd)
    
    local workspace=$(find_xcworkspace "$project_dir")
    local project=$(find_xcodeproj "$project_dir")
    
    if [[ -z "$workspace" && -z "$project" ]]; then
        print_error "No Xcode project or workspace found"
        exit 1
    fi
    
    local project_name=$(basename "$project_dir")
    local version=$(get_app_version "$project_dir")
    local bundle_id=$(get_bundle_id "$project_dir")
    
    print_info "Project: $project_name"
    print_info "Version: $version"
    print_info "Bundle ID: $bundle_id"
    echo ""
    
    print_info "Available schemes:"
    local schemes=($(get_schemes "$project_dir"))
    local index=1
    for scheme in "${schemes[@]}"; do
        echo "  $index) $scheme"
        ((index++))
    done
    echo ""
    
    read -p "Select scheme (1-${#schemes[@]}): " scheme_choice
    
    if [[ $scheme_choice -lt 1 || $scheme_choice -gt ${#schemes[@]} ]]; then
        print_error "Invalid selection"
        exit 1
    fi
    
    local selected_scheme="${schemes[$((scheme_choice-1))]}"
    print_info "Selected: $selected_scheme"
    echo ""
    
    echo -e "${CYAN}Deployment Options:${NC}"
    echo "  1) Build archive"
    echo "  2) Build and export IPA"
    echo "  3) Build, export, and upload to TestFlight"
    echo "  4) Build, export, and upload to App Store"
    echo "  5) Clean build"
    echo "  6) List certificates"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            clean_build "$project_dir" "$selected_scheme"
            build_archive "$project_dir" "$selected_scheme"
            ;;
        2)
            clean_build "$project_dir" "$selected_scheme"
            local archive_path=$(build_archive "$project_dir" "$selected_scheme")
            local export_options=$(create_export_options "$project_dir" "app-store" "$bundle_id")
            export_ipa "$archive_path" "$export_options"
            ;;
        3)
            read -p "Apple ID: " apple_id
            read -sp "App-specific password: " app_password
            echo ""
            
            clean_build "$project_dir" "$selected_scheme"
            local archive_path=$(build_archive "$project_dir" "$selected_scheme")
            local export_options=$(create_export_options "$project_dir" "app-store" "$bundle_id")
            local ipa_path=$(export_ipa "$archive_path" "$export_options")
            upload_to_testflight "$ipa_path" "$apple_id" "$app_password"
            ;;
        4)
            read -p "Apple ID: " apple_id
            read -sp "App-specific password: " app_password
            echo ""
            
            clean_build "$project_dir" "$selected_scheme"
            local archive_path=$(build_archive "$project_dir" "$selected_scheme")
            local export_options=$(create_export_options "$project_dir" "app-store" "$bundle_id")
            local ipa_path=$(export_ipa "$archive_path" "$export_options")
            upload_ipa "$ipa_path" "$apple_id" "$app_password"
            ;;
        5)
            clean_build "$project_dir" "$selected_scheme"
            ;;
        6)
            list_certificates
            list_provisioning_profiles
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
    echo "Usage: $0 [COMMAND] [PROJECT_DIR]"
    echo ""
    echo "Commands:"
    echo "  build [DIR] [SCHEME]     Build archive"
    echo "  export [ARCHIVE]         Export IPA from archive"
    echo "  upload [IPA]             Upload IPA to App Store"
    echo "  testflight [IPA]         Upload to TestFlight"
    echo "  certificates             List certificates"
    echo "  interactive [DIR]        Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 interactive"
    echo "  $0 build . MyApp"
    echo "  $0 certificates"
}

main() {
    local command="${1:-interactive}"
    
    print_header
    
    check_xcode
    
    echo ""
    
    case $command in
        build)
            local project_dir="${2:-.}"
            local scheme="$3"
            
            if [[ -z "$scheme" ]]; then
                print_error "Scheme required"
                show_usage
                exit 1
            fi
            
            build_archive "$project_dir" "$scheme"
            ;;
        export)
            local archive_path="$2"
            
            if [[ -z "$archive_path" ]]; then
                print_error "Archive path required"
                show_usage
                exit 1
            fi
            
            local project_dir=$(dirname "$(dirname "$archive_path")")
            local export_options=$(create_export_options "$project_dir")
            export_ipa "$archive_path" "$export_options"
            ;;
        upload)
            local ipa_path="$2"
            
            if [[ -z "$ipa_path" ]]; then
                print_error "IPA path required"
                show_usage
                exit 1
            fi
            
            read -p "Apple ID: " apple_id
            read -sp "App-specific password: " app_password
            echo ""
            
            upload_ipa "$ipa_path" "$apple_id" "$app_password"
            ;;
        testflight)
            local ipa_path="$2"
            
            if [[ -z "$ipa_path" ]]; then
                print_error "IPA path required"
                show_usage
                exit 1
            fi
            
            read -p "Apple ID: " apple_id
            read -sp "App-specific password: " app_password
            echo ""
            
            upload_to_testflight "$ipa_path" "$apple_id" "$app_password"
            ;;
        certificates)
            list_certificates
            list_provisioning_profiles
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
