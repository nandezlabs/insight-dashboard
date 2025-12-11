#!/bin/bash

################################################################################
# iOS/Swift Project Creator
# Creates iOS/macOS projects with Swift Package Manager and Xcode integration
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECTS_DIR="$HOME/Developer/projects"
GAMES_DIR="$HOME/Developer/games"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  📱 iOS/Swift Project Creator${NC}"
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

check_requirements() {
    print_info "Checking requirements..."
    
    # Check for Swift
    if ! command -v swift &> /dev/null; then
        print_error "Swift not found. Install Xcode Command Line Tools:"
        echo "  xcode-select --install"
        exit 1
    fi
    
    # Check for Xcode
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode build tools not found. Please install Xcode from the App Store."
        exit 1
    fi
    
    print_success "Swift $(swift --version | head -1 | awk '{print $4}')"
    print_success "Xcode $(xcodebuild -version | head -1 | awk '{print $2}')"
}

validate_project_name() {
    local name="$1"
    
    # Check if name is empty
    if [[ -z "$name" ]]; then
        print_error "Project name cannot be empty"
        return 1
    fi
    
    # Check if name contains only valid characters (letters, numbers, hyphens, no spaces)
    if [[ ! "$name" =~ ^[A-Za-z][A-Za-z0-9-]*$ ]]; then
        print_error "Project name must start with a letter and contain only letters, numbers, and hyphens"
        return 1
    fi
    
    return 0
}

validate_bundle_id() {
    local bundle_id="$1"
    
    # Check reverse domain notation (com.company.appname)
    if [[ ! "$bundle_id" =~ ^[a-z]+\.[a-z0-9]+(\.[a-z0-9]+)*$ ]]; then
        print_error "Bundle ID must be in reverse domain notation (e.g., com.company.appname)"
        return 1
    fi
    
    return 0
}

################################################################################
# Project Type Selection
################################################################################

select_project_type() {
    echo -e "${BLUE}Select project type:${NC}" >&2
    echo "1) SwiftUI App (iOS)" >&2
    echo "2) SwiftUI App (macOS)" >&2
    echo "3) SwiftUI App (Multiplatform - iOS + macOS)" >&2
    echo "4) UIKit App (iOS)" >&2
    echo "5) Swift Package Library" >&2
    echo "6) SpriteKit Game (iOS)" >&2
    echo "" >&2
    
    while true; do
        read -p "Enter choice (1-6): " choice
        case $choice in
            1) echo "swiftui-ios"; return 0 ;;
            2) echo "swiftui-macos"; return 0 ;;
            3) echo "swiftui-multiplatform"; return 0 ;;
            4) echo "uikit-ios"; return 0 ;;
            5) echo "library"; return 0 ;;
            6) echo "spritekit-game"; return 0 ;;
            *) print_error "Invalid choice. Please select 1-6." ;;
        esac
    done
}

################################################################################
# Directory Structure Creation
################################################################################

create_directory_structure() {
    local project_path="$1"
    local project_type="$2"
    
    print_info "Creating directory structure..."
    
    mkdir -p "$project_path"
    
    # Note: We don't cd here; parent function will cd after calling this
    
    case $project_type in
        swiftui-ios|swiftui-macos|swiftui-multiplatform|uikit-ios)
            mkdir -p "$project_path/Sources"
            mkdir -p "$project_path/Tests"
            mkdir -p "$project_path/Resources"
            mkdir -p "$project_path/.vscode"
            ;;
        library)
            mkdir -p "$project_path/Sources"
            mkdir -p "$project_path/Tests"
            mkdir -p "$project_path/.vscode"
            ;;
        spritekit-game)
            mkdir -p "$project_path/Sources/Scenes"
            mkdir -p "$project_path/Sources/Entities"
            mkdir -p "$project_path/Sources/Components"
            mkdir -p "$project_path/Resources/Assets"
            mkdir -p "$project_path/Resources/Sounds"
            mkdir -p "$project_path/Tests"
            mkdir -p "$project_path/.vscode"
            ;;
    esac
    
    print_success "Directory structure created"
}

################################################################################
# Swift Package Manager Setup
################################################################################

create_package_swift() {
    local project_name="$1"
    local project_type="$2"
    local bundle_id="$3"
    local ios_version="$4"
    local macos_version="$5"
    
    print_info "Creating Package.swift..."
    
    case $project_type in
        swiftui-ios)
            cat > Package.swift << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$project_name",
    platforms: [
        .iOS(.v${ios_version})
    ],
    products: [
        .library(
            name: "$project_name",
            targets: ["$project_name"]
        )
    ],
    dependencies: [
        // Add your dependencies here
    ],
    targets: [
        .target(
            name: "$project_name",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "${project_name}Tests",
            dependencies: ["$project_name"],
            path: "Tests"
        )
    ]
)
EOF
            ;;
        swiftui-macos)
            cat > Package.swift << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$project_name",
    platforms: [
        .macOS(.v${macos_version})
    ],
    products: [
        .library(
            name: "$project_name",
            targets: ["$project_name"]
        )
    ],
    dependencies: [
        // Add your dependencies here
    ],
    targets: [
        .target(
            name: "$project_name",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "${project_name}Tests",
            dependencies: ["$project_name"],
            path: "Tests"
        )
    ]
)
EOF
            ;;
        swiftui-multiplatform)
            cat > Package.swift << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$project_name",
    platforms: [
        .iOS(.v${ios_version}),
        .macOS(.v${macos_version})
    ],
    products: [
        .library(
            name: "$project_name",
            targets: ["$project_name"]
        )
    ],
    dependencies: [
        // Add your dependencies here
    ],
    targets: [
        .target(
            name: "$project_name",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "${project_name}Tests",
            dependencies: ["$project_name"],
            path: "Tests"
        )
    ]
)
EOF
            ;;
        uikit-ios)
            cat > Package.swift << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$project_name",
    platforms: [
        .iOS(.v${ios_version})
    ],
    products: [
        .library(
            name: "$project_name",
            targets: ["$project_name"]
        )
    ],
    dependencies: [
        // Add your dependencies here
    ],
    targets: [
        .target(
            name: "$project_name",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "${project_name}Tests",
            dependencies: ["$project_name"],
            path: "Tests"
        )
    ]
)
EOF
            ;;
        library)
            cat > Package.swift << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$project_name",
    platforms: [
        .iOS(.v${ios_version}),
        .macOS(.v${macos_version})
    ],
    products: [
        .library(
            name: "$project_name",
            targets: ["$project_name"]
        )
    ],
    dependencies: [
        // Add your dependencies here
        // .package(url: "https://github.com/...", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "$project_name",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "${project_name}Tests",
            dependencies: ["$project_name"],
            path: "Tests"
        )
    ]
)
EOF
            ;;
        spritekit-game)
            cat > Package.swift << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "$project_name",
    platforms: [
        .iOS(.v${ios_version})
    ],
    products: [
        .library(
            name: "$project_name",
            targets: ["$project_name"]
        )
    ],
    dependencies: [
        // Add your dependencies here
    ],
    targets: [
        .target(
            name: "$project_name",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "${project_name}Tests",
            dependencies: ["$project_name"],
            path: "Tests"
        )
    ]
)
EOF
            ;;
    esac
    
    print_success "Package.swift created"
}

################################################################################
# Source Files Creation
################################################################################

create_swift_files() {
    local project_name="$1"
    local project_type="$2"
    local bundle_id="$3"
    
    print_info "Creating Swift source files..."
    
    case $project_type in
        swiftui-ios|swiftui-macos|swiftui-multiplatform)
            # Main App file
            cat > "Sources/${project_name}App.swift" << EOF
import SwiftUI

@main
struct ${project_name}App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

            # ContentView
            cat > "Sources/ContentView.swift" << EOF
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Welcome to $project_name!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Built with SwiftUI")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
EOF
            ;;
            
        uikit-ios)
            # AppDelegate
            cat > "Sources/AppDelegate.swift" << EOF
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
EOF

            # ViewController
            cat > "Sources/ViewController.swift" << EOF
import UIKit

class ViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "$project_name"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Built with UIKit"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
        ])
    }
}
EOF
            ;;
            
        library)
            cat > "Sources/${project_name}.swift" << EOF
/// $project_name Library
///
/// A Swift library for...
public struct ${project_name} {
    public init() {}
    
    /// Example function
    public func hello(name: String = "World") -> String {
        return "Hello, \\(name)!"
    }
}
EOF
            ;;
            
        spritekit-game)
            # Game Scene
            cat > "Sources/Scenes/GameScene.swift" << EOF
import SpriteKit

class GameScene: SKScene {
    private var player: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        setupScene()
        createPlayer()
    }
    
    private func setupScene() {
        backgroundColor = .black
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    private func createPlayer() {
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player?.physicsBody = SKPhysicsBody(rectangleOf: player!.size)
        addChild(player!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        player?.run(SKAction.move(to: location, duration: 0.5))
    }
}
EOF

            # Game View Controller
            cat > "Sources/GameViewController.swift" << EOF
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
EOF
            ;;
    esac
    
    # Create test file
    mkdir -p Tests
    cat > "Tests/${project_name}Tests.swift" << EOF
import XCTest
@testable import $project_name

final class ${project_name}Tests: XCTestCase {
    func testExample() throws {
        // Write your tests here
        XCTAssertTrue(true)
    }
}
EOF
    
    print_success "Swift source files created"
}

################################################################################
# Xcode Project Generation
################################################################################

generate_xcode_project() {
    local project_name="$1"
    local project_type="$2"
    
    print_info "Generating Xcode project..."
    
    # Swift Package Manager can generate Xcode projects
    if [[ "$project_type" == "library" ]]; then
        swift package generate-xcodeproj 2>/dev/null || true
    fi
    
    print_success "Use 'open Package.swift' to open in Xcode"
}

################################################################################
# Configuration Files
################################################################################

create_gitignore() {
    print_info "Creating .gitignore..."
    
    cat > .gitignore << 'EOF'
# Xcode
xcuserdata/
*.xcscmblueprint
*.xccheckout
DerivedData/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3

# Swift Package Manager
.build/
Packages/
Package.resolved
*.swiftpm

# CocoaPods
Pods/
*.xcworkspace
!default.xcworkspace

# Carthage
Carthage/Build/

# Build artifacts
*.ipa
*.dSYM.zip
*.dSYM

# macOS
.DS_Store
.AppleDouble
.LSOverride

# VS Code
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json

# Thumbnails
._*

# Files that might appear on external disks
.Spotlight-V100
.Trashes

# Timeline
timeline.xctimeline

# Playground
playground.xcworkspace

# Swift
*.swp
*~.nib
EOF
    
    print_success ".gitignore created"
}

create_readme() {
    local project_name="$1"
    local description="$2"
    local project_type="$3"
    local bundle_id="$4"
    local ios_version="$5"
    
    print_info "Creating README.md..."
    
    local platform_badge=""
    case $project_type in
        swiftui-ios|uikit-ios|spritekit-game)
            platform_badge="![Platform](https://img.shields.io/badge/platform-iOS%20${ios_version}+-blue.svg)"
            ;;
        swiftui-macos)
            platform_badge="![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)"
            ;;
        swiftui-multiplatform)
            platform_badge="![Platform](https://img.shields.io/badge/platform-iOS%20|%20macOS-blue.svg)"
            ;;
        library)
            platform_badge="![Platform](https://img.shields.io/badge/platform-iOS%20|%20macOS-blue.svg)"
            ;;
    esac
    
    cat > README.md << EOF
# $project_name

$description

$platform_badge
![Swift](https://img.shields.io/badge/swift-5.9+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 📱 Requirements

- iOS ${ios_version}+ / macOS 13+
- Xcode 15.0+
- Swift 5.9+

## 🚀 Quick Start

### Open in Xcode

\`\`\`bash
open Package.swift
\`\`\`

### Open in VS Code with SweetPad

\`\`\`bash
code .
\`\`\`

Then use SweetPad commands:
- \`Cmd+Shift+P\` → "SweetPad: Select Device"
- \`Cmd+Shift+P\` → "SweetPad: Run"

### Build from Command Line

\`\`\`bash
# Build
swift build

# Run tests
swift test

# Generate Xcode project (optional)
swift package generate-xcodeproj
\`\`\`

## 📦 Project Structure

\`\`\`
$project_name/
├── Sources/           # Swift source files
├── Tests/             # Unit tests
├── Resources/         # Assets, sounds, etc.
├── Package.swift      # Swift Package Manager manifest
└── README.md
\`\`\`

## 🛠️ Development

### Adding Dependencies

Edit \`Package.swift\`:

\`\`\`swift
dependencies: [
    .package(url: "https://github.com/...", from: "1.0.0")
]
\`\`\`

### Running Tests

\`\`\`bash
swift test
\`\`\`

## 📝 Bundle ID

\`$bundle_id\`

## 📄 License

MIT License - See LICENSE file for details

---

**Created with**: iOS/Swift Project Creator
**Date**: $(date +%Y-%m-%d)
EOF
    
    print_success "README.md created"
}

create_license() {
    print_info "Creating LICENSE..."
    
    cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
    
    print_success "LICENSE created"
}

################################################################################
# VS Code Integration (SweetPad)
################################################################################

create_vscode_workspace() {
    local project_name="$1"
    local project_type="$2"
    
    print_info "Creating VS Code workspace..."
    
    # Ensure .vscode directory exists
    mkdir -p .vscode
    
    # Create settings.json
    cat > .vscode/settings.json << EOF
{
  "files.exclude": {
    "**/.DS_Store": true,
    "**/.build": true,
    "**/xcuserdata": true,
    "**/*.xcworkspace": true,
    "**/DerivedData": true
  },
  "search.exclude": {
    "**/.build": true,
    "**/Pods": true,
    "**/xcuserdata": true
  },
  "swift.path": "/usr/bin/swift",
  "sweetpad.projectPath": "\${workspaceFolder}",
  "sweetpad.buildOnSave": false,
  "sweetpad.showBuildStatus": true,
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "vknabel.vscode-apple-swift-format",
  "editor.rulers": [100],
  "[swift]": {
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "editor.formatOnSave": true
  }
}
EOF
    
    # Create tasks.json for build tasks
    cat > .vscode/tasks.json << EOF
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Swift Build",
      "type": "shell",
      "command": "swift build",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": []
    },
    {
      "label": "Swift Test",
      "type": "shell",
      "command": "swift test",
      "group": {
        "kind": "test",
        "isDefault": true
      },
      "problemMatcher": []
    },
    {
      "label": "Open in Xcode",
      "type": "shell",
      "command": "open Package.swift",
      "problemMatcher": []
    }
  ]
}
EOF
    
    # Create workspace file
    cat > "${project_name}.code-workspace" << EOF
{
  "folders": [
    {
      "path": "."
    }
  ],
  "settings": {
    "swift.path": "/usr/bin/swift",
    "sweetpad.projectPath": "\${workspaceFolder}",
    "files.exclude": {
      "**/.DS_Store": true,
      "**/.build": true,
      "**/xcuserdata": true
    }
  },
  "extensions": {
    "recommendations": [
      "sweetpad.sweetpad",
      "vknabel.vscode-apple-swift-format",
      "sswg.swift-lang"
    ]
  }
}
EOF
    
    print_success "VS Code workspace configured for SweetPad"
}

################################################################################
# Git Initialization
################################################################################

init_git_repository() {
    local project_name="$1"
    
    print_info "Initializing Git repository..."
    
    git init -q
    git add .
    git commit -q -m "Initial commit: $project_name project setup"
    
    # Create main branch
    git branch -M main
    
    print_success "Git repository initialized"
}

################################################################################
# GitHub Integration
################################################################################

setup_github_repo() {
    local project_name="$1"
    local description="$2"
    local visibility="$3"
    
    print_info "Setting up GitHub repository..."
    
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) not found. Install with: brew install gh"
        return 1
    fi
    
    # Check if user is authenticated
    if ! gh auth status &> /dev/null; then
        print_error "Not authenticated with GitHub. Run: gh auth login"
        return 1
    fi
    
    # Create repository
    local visibility_flag=""
    if [[ "$visibility" == "private" ]]; then
        visibility_flag="--private"
    else
        visibility_flag="--public"
    fi
    
    if gh repo create "nandezlabs/$project_name" \
        --description "$description" \
        $visibility_flag \
        --source=. \
        --remote=origin; then
        
        # Add topics
        gh repo edit "nandezlabs/$project_name" \
            --add-topic "swift" \
            --add-topic "ios" \
            --add-topic "swiftui" 2>/dev/null || true
        
        # Push code
        git push -u origin main
        
        print_success "GitHub repository created and code pushed"
        print_info "Repository: https://github.com/nandezlabs/$project_name"
    else
        print_error "Failed to create GitHub repository"
        return 1
    fi
}

################################################################################
# Main Function
################################################################################

main() {
    print_header
    check_requirements
    
    # Get project details
    echo -e "${BLUE}Project Configuration:${NC}\n"
    
    read -p "Project name: " project_name
    validate_project_name "$project_name" || exit 1
    
    read -p "Description: " description
    
    # Select project type
    project_type=$(select_project_type)
    
    # Determine base directory
    if [[ "$project_type" == "spritekit-game" ]]; then
        base_dir="$GAMES_DIR"
    else
        base_dir="$PROJECTS_DIR"
    fi
    
    project_path="$base_dir/$project_name"
    
    # Check if directory exists
    if [[ -d "$project_path" ]]; then
        print_error "Project directory already exists: $project_path"
        exit 1
    fi
    
    # Bundle ID
    echo ""
    local lowercase_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    read -p "Bundle ID (e.g., com.nandezlabs.$lowercase_name): " bundle_id
    while ! validate_bundle_id "$bundle_id"; do
        read -p "Bundle ID: " bundle_id
    done
    
    # Platform versions
    if [[ "$project_type" =~ ios|spritekit|uikit|multiplatform ]]; then
        read -p "Minimum iOS version (default: 17): " ios_version
        ios_version=${ios_version:-17}
    else
        ios_version="17"
    fi
    
    if [[ "$project_type" =~ macos|multiplatform|library ]]; then
        read -p "Minimum macOS version (default: 13): " macos_version
        macos_version=${macos_version:-13}
    else
        macos_version="13"
    fi
    
    # GitHub integration
    echo ""
    read -p "Create GitHub repository? (y/n): " create_github
    github_visibility="public"
    if [[ "$create_github" =~ ^[Yy]$ ]]; then
        create_github="true"
        read -p "Repository visibility (public/private) [public]: " github_visibility
        github_visibility=${github_visibility:-public}
    else
        create_github="false"
    fi
    
    # Create project
    echo -e "\n${BLUE}Creating project...${NC}\n"
    
    create_directory_structure "$project_path" "$project_type"
    
    # Change to project directory for remaining operations
    cd "$project_path" || exit 1
    
    create_package_swift "$project_name" "$project_type" "$bundle_id" "$ios_version" "$macos_version"
    create_swift_files "$project_name" "$project_type" "$bundle_id"
    create_gitignore
    create_readme "$project_name" "$description" "$project_type" "$bundle_id" "$ios_version"
    create_license
    create_vscode_workspace "$project_name" "$project_type"
    
    # Git initialization
    init_git_repository "$project_name"
    
    # GitHub setup
    if [[ "$create_github" == "true" ]]; then
        setup_github_repo "$project_name" "$description" "$github_visibility"
    fi
    
    # Summary
    echo -e "\n${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✓ Project Created Successfully!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${BLUE}Project Details:${NC}"
    echo "  Name: $project_name"
    echo "  Type: $project_type"
    echo "  Path: $project_path"
    echo "  Bundle ID: $bundle_id"
    echo ""
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo "  1. cd $project_path"
    echo "  2. open Package.swift  # Open in Xcode"
    echo "     OR"
    echo "     code .  # Open in VS Code with SweetPad"
    echo ""
    echo "  3. Use SweetPad in VS Code:"
    echo "     • Cmd+Shift+P → 'SweetPad: Select Device'"
    echo "     • Cmd+Shift+P → 'SweetPad: Run'"
    echo ""
    echo "  4. Build from terminal:"
    echo "     • swift build"
    echo "     • swift test"
    echo ""
    
    if [[ "$create_github" == "true" ]]; then
        echo "  GitHub: https://github.com/nandezlabs/$project_name"
        echo ""
    fi
    
    print_success "Happy coding! 🚀"
    echo ""
}

# Run main function
main "$@"
