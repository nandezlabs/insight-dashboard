#!/bin/bash

################################################################################
# Next.js Project Creator
# Creates Next.js 14+ projects with TypeScript, Tailwind CSS, and modern tooling
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

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  ⚡ Next.js Project Creator${NC}"
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
    
    # Check for Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js not found. Install with: brew install node"
        exit 1
    fi
    
    # Check for npm
    if ! command -v npm &> /dev/null; then
        print_error "npm not found. Please install Node.js."
        exit 1
    fi
    
    print_success "Node.js $(node --version)"
    print_success "npm $(npm --version)"
}

validate_project_name() {
    local name="$1"
    
    # Check if name is empty
    if [[ -z "$name" ]]; then
        print_error "Project name cannot be empty"
        return 1
    fi
    
    # Check if name contains only valid characters (lowercase, numbers, hyphens)
    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        print_error "Project name can only contain lowercase letters, numbers, and hyphens"
        return 1
    fi
    
    # Check if directory already exists
    if [[ -d "$PROJECTS_DIR/$name" ]]; then
        print_error "Project directory already exists: $PROJECTS_DIR/$name"
        return 1
    fi
    
    return 0
}

################################################################################
# Project Type Selection
################################################################################

select_project_type() {
    echo -e "${BLUE}Select project type:${NC}" >&2
    echo "1) Basic App (Landing page, blog, documentation)" >&2
    echo "2) Full-stack App (with API routes + database setup)" >&2
    echo "3) E-commerce (with products, cart, checkout flow)" >&2
    echo "4) Dashboard (with auth, charts, tables)" >&2
    echo "" >&2
    
    while true; do
        read -p "Enter choice (1-4): " choice
        case $choice in
            1) echo "basic"; return 0 ;;
            2) echo "fullstack"; return 0 ;;
            3) echo "ecommerce"; return 0 ;;
            4) echo "dashboard"; return 0 ;;
            *) print_error "Invalid choice. Please select 1-4." ;;
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
    
    # Base structure for all types
    mkdir -p "$project_path/src/app"
    mkdir -p "$project_path/src/components/ui"
    mkdir -p "$project_path/src/lib"
    mkdir -p "$project_path/public/images"
    mkdir -p "$project_path/.vscode"
    
    # Type-specific directories
    case $project_type in
        basic)
            mkdir -p "$project_path/src/app/(marketing)"
            mkdir -p "$project_path/src/components/layout"
            ;;
        fullstack)
            mkdir -p "$project_path/src/app/api"
            mkdir -p "$project_path/src/app/(auth)"
            mkdir -p "$project_path/src/lib/db"
            mkdir -p "$project_path/src/lib/auth"
            mkdir -p "$project_path/prisma"
            ;;
        ecommerce)
            mkdir -p "$project_path/src/app/(shop)/products"
            mkdir -p "$project_path/src/app/(shop)/cart"
            mkdir -p "$project_path/src/app/(shop)/checkout"
            mkdir -p "$project_path/src/app/api/products"
            mkdir -p "$project_path/src/app/api/orders"
            mkdir -p "$project_path/src/lib/db"
            mkdir -p "$project_path/prisma"
            ;;
        dashboard)
            mkdir -p "$project_path/src/app/(dashboard)"
            mkdir -p "$project_path/src/app/api"
            mkdir -p "$project_path/src/components/charts"
            mkdir -p "$project_path/src/lib/auth"
            ;;
    esac
    
    print_success "Directory structure created"
}

################################################################################
# Configuration Files
################################################################################

create_package_json() {
    local project_name="$1"
    local description="$2"
    local project_type="$3"
    
    print_info "Creating package.json..."
    
    local dependencies='"next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"'
    
    # Add type-specific dependencies
    case $project_type in
        fullstack|ecommerce)
            dependencies+=',
    "@prisma/client": "^5.7.0",
    "zod": "^3.22.0"'
            ;;
        dashboard)
            dependencies+=',
    "recharts": "^2.10.0",
    "@radix-ui/react-icons": "^1.3.0"'
            ;;
    esac
    
    cat > package.json << EOF
{
  "name": "$project_name",
  "version": "0.1.0",
  "description": "$description",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "format": "prettier --write \"./**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    $dependencies
  },
  "devDependencies": {
    "@types/node": "^20.10.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.3.0",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.4.0",
    "autoprefixer": "^10.4.0",
    "eslint": "^8.55.0",
    "eslint-config-next": "^14.0.0",
    "prettier": "^3.1.0",
    "prettier-plugin-tailwindcss": "^0.5.0"
  },
  "engines": {
    "node": ">=18.17.0",
    "npm": ">=9.0.0"
  }
}
EOF
    
    # Add Prisma for database projects
    if [[ "$project_type" == "fullstack" || "$project_type" == "ecommerce" ]]; then
        cat >> package.json.tmp << 'EOF'
,
  "prisma": {
    "seed": "ts-node --compiler-options {\"module\":\"CommonJS\"} prisma/seed.ts"
  }
}
EOF
        # Insert before closing brace
        head -n -1 package.json > package.json.tmp
        cat >> package.json.tmp << 'EOF'
  },
  "prisma": {
    "seed": "ts-node --compiler-options {\"module\":\"CommonJS\"} prisma/seed.ts"
  }
}
EOF
        mv package.json.tmp package.json
    fi
    
    print_success "package.json created"
}

create_tsconfig() {
    print_info "Creating tsconfig.json..."
    
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
    
    print_success "tsconfig.json created"
}

create_tailwind_config() {
    print_info "Creating Tailwind CSS configuration..."
    
    cat > tailwind.config.ts << 'EOF'
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
    },
  },
  plugins: [],
}

export default config
EOF
    
    cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    
    print_success "Tailwind CSS configured"
}

create_next_config() {
    print_info "Creating next.config.js..."
    
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['images.unsplash.com', 'localhost'],
  },
  experimental: {
    serverActions: {
      bodySizeLimit: '2mb',
    },
  },
}

module.exports = nextConfig
EOF
    
    print_success "next.config.js created"
}

create_env_files() {
    local project_type="$1"
    
    print_info "Creating environment files..."
    
    cat > .env.local << 'EOF'
# App
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Database (if using Prisma)
# DATABASE_URL="postgresql://user:password@localhost:5432/mydb"

# Auth (if using NextAuth.js)
# NEXTAUTH_URL=http://localhost:3000
# NEXTAUTH_SECRET=your-secret-here
EOF
    
    cat > .env.example << 'EOF'
# App
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Database
DATABASE_URL="postgresql://user:password@localhost:5432/mydb"

# Auth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=generate-a-secret-key
EOF
    
    print_success "Environment files created"
}

################################################################################
# Source Files Creation
################################################################################

create_app_files() {
    local project_type="$1"
    
    print_info "Creating app files..."
    
    # Root layout
    cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Next.js App',
  description: 'Built with Next.js 14, TypeScript, and Tailwind CSS',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
EOF
    
    # Global styles
    cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
EOF
    
    # Type-specific pages
    case $project_type in
        basic)
            create_basic_app_files
            ;;
        fullstack)
            create_fullstack_app_files
            ;;
        ecommerce)
            create_ecommerce_app_files
            ;;
        dashboard)
            create_dashboard_app_files
            ;;
    esac
    
    print_success "App files created"
}

create_basic_app_files() {
    cat > src/app/page.tsx << 'EOF'
import Link from 'next/link'

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="max-w-5xl w-full space-y-8 text-center">
        <h1 className="text-4xl font-bold tracking-tight sm:text-6xl">
          Welcome to Next.js 14
        </h1>
        
        <p className="text-xl text-muted-foreground">
          Get started by editing <code className="font-mono">src/app/page.tsx</code>
        </p>
        
        <div className="flex gap-4 justify-center">
          <Link
            href="/about"
            className="rounded-lg bg-primary px-6 py-3 text-primary-foreground hover:bg-primary/90"
          >
            Learn More
          </Link>
          <Link
            href="https://nextjs.org/docs"
            target="_blank"
            rel="noopener noreferrer"
            className="rounded-lg border border-border px-6 py-3 hover:bg-secondary"
          >
            Documentation
          </Link>
        </div>
      </div>
    </main>
  )
}
EOF

    mkdir -p src/app/about
    cat > src/app/about/page.tsx << 'EOF'
export default function AboutPage() {
  return (
    <main className="container mx-auto px-4 py-16">
      <h1 className="text-4xl font-bold mb-6">About</h1>
      <p className="text-lg text-muted-foreground">
        This is a Next.js 14 application with TypeScript and Tailwind CSS.
      </p>
    </main>
  )
}
EOF
}

create_fullstack_app_files() {
    cat > src/app/page.tsx << 'EOF'
export default function Home() {
  return (
    <main className="container mx-auto px-4 py-16">
      <h1 className="text-4xl font-bold mb-6">Full-stack Next.js App</h1>
      <p className="text-lg text-muted-foreground">
        Built with Next.js 14, TypeScript, Prisma, and Tailwind CSS.
      </p>
    </main>
  )
}
EOF

    mkdir -p src/app/api/health
    cat > src/app/api/health/route.ts << 'EOF'
import { NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
  })
}
EOF
}

create_ecommerce_app_files() {
    cat > src/app/page.tsx << 'EOF'
export default function Home() {
  return (
    <main className="container mx-auto px-4 py-16">
      <h1 className="text-4xl font-bold mb-6">E-commerce Store</h1>
      <p className="text-lg text-muted-foreground">
        Your Next.js e-commerce platform.
      </p>
    </main>
  )
}
EOF

    mkdir -p "src/app/(shop)/products"
    cat > "src/app/(shop)/products/page.tsx" << 'EOF'
export default function ProductsPage() {
  return (
    <div className="container mx-auto px-4 py-16">
      <h1 className="text-3xl font-bold mb-8">Products</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Product grid will go here */}
      </div>
    </div>
  )
}
EOF
}

create_dashboard_app_files() {
    cat > src/app/page.tsx << 'EOF'
import { redirect } from 'next/navigation'

export default function Home() {
  redirect('/dashboard')
}
EOF

    mkdir -p "src/app/(dashboard)/dashboard"
    cat > "src/app/(dashboard)/dashboard/page.tsx" << 'EOF'
export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Dashboard cards will go here */}
      </div>
    </div>
  )
}
EOF
}

create_components() {
    print_info "Creating components..."
    
    # UI Button component
    cat > src/components/ui/button.tsx << 'EOF'
import { ButtonHTMLAttributes, forwardRef } from 'react'
import { cn } from '@/lib/utils'

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'outline' | 'ghost'
  size?: 'default' | 'sm' | 'lg'
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'default', size = 'default', ...props }, ref) => {
    return (
      <button
        className={cn(
          'inline-flex items-center justify-center rounded-md font-medium transition-colors',
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
          'disabled:pointer-events-none disabled:opacity-50',
          {
            'bg-primary text-primary-foreground hover:bg-primary/90':
              variant === 'default',
            'border border-input bg-background hover:bg-secondary':
              variant === 'outline',
            'hover:bg-secondary': variant === 'ghost',
          },
          {
            'h-10 px-4 py-2': size === 'default',
            'h-9 px-3': size === 'sm',
            'h-11 px-8': size === 'lg',
          },
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)

Button.displayName = 'Button'

export { Button }
EOF
    
    # Utils
    cat > src/lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF
    
    print_success "Components created"
}

################################################################################
# Configuration Files
################################################################################

create_eslint_config() {
    print_info "Creating ESLint configuration..."
    
    cat > .eslintrc.json << 'EOF'
{
  "extends": ["next/core-web-vitals", "next/typescript"],
  "rules": {
    "@typescript-eslint/no-unused-vars": "warn",
    "@typescript-eslint/no-explicit-any": "warn"
  }
}
EOF
    
    print_success "ESLint configured"
}

create_prettier_config() {
    print_info "Creating Prettier configuration..."
    
    cat > .prettierrc << 'EOF'
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "plugins": ["prettier-plugin-tailwindcss"]
}
EOF
    
    cat > .prettierignore << 'EOF'
node_modules
.next
.vercel
out
build
dist
*.lock
EOF
    
    print_success "Prettier configured"
}

create_gitignore() {
    print_info "Creating .gitignore..."
    
    cat > .gitignore << 'EOF'
# Dependencies
node_modules
/.pnp
.pnp.js

# Testing
/coverage

# Next.js
/.next/
/out/

# Production
/build

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env*.local
.env

# Vercel
.vercel

# TypeScript
*.tsbuildinfo
next-env.d.ts

# IDEs
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/extensions.json
.idea
EOF
    
    print_success ".gitignore created"
}

create_readme() {
    local project_name="$1"
    local description="$2"
    local project_type="$3"
    
    print_info "Creating README.md..."
    
    cat > README.md << EOF
# $project_name

$description

![Next.js](https://img.shields.io/badge/Next.js-14-black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.4-38bdf8)

## 🚀 Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Linting**: ESLint
- **Formatting**: Prettier

## 📦 Getting Started

### Prerequisites

- Node.js 18.17 or later
- npm 9.0 or later

### Installation

\`\`\`bash
# Install dependencies
npm install

# Run development server
npm run dev
\`\`\`

Open [http://localhost:3000](http://localhost:3000) in your browser.

## 📜 Available Scripts

- \`npm run dev\` - Start development server
- \`npm run build\` - Build for production
- \`npm start\` - Start production server
- \`npm run lint\` - Run ESLint
- \`npm run format\` - Format code with Prettier
- \`npm run type-check\` - Run TypeScript type checking

## 📁 Project Structure

\`\`\`
$project_name/
├── src/
│   ├── app/              # App Router pages
│   ├── components/       # React components
│   └── lib/              # Utility functions
├── public/               # Static assets
├── .env.example          # Environment variables template
└── package.json
\`\`\`

## 🚢 Deployment

### Vercel (Recommended)

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new)

The easiest way to deploy is using [Vercel](https://vercel.com):

\`\`\`bash
npm install -g vercel
vercel
\`\`\`

## 📄 License

MIT

---

**Created with**: Next.js Project Creator
**Date**: $(date +%Y-%m-%d)
EOF
    
    print_success "README.md created"
}

################################################################################
# VS Code Integration
################################################################################

create_vscode_workspace() {
    local project_name="$1"
    
    print_info "Creating VS Code workspace..."
    
    cat > .vscode/settings.json << 'EOF'
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "files.exclude": {
    "**/.next": true,
    "**/node_modules": true,
    "**/.git": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/.next": true,
    "**/package-lock.json": true
  },
  "emmet.includeLanguages": {
    "typescript": "html",
    "typescriptreact": "html"
  },
  "tailwindCSS.experimental.classRegex": [
    ["cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"]
  ]
}
EOF
    
    cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "dsznajder.es7-react-js-snippets",
    "formulahendry.auto-rename-tag",
    "ms-vscode.vscode-typescript-next"
  ]
}
EOF
    
    cat > "${project_name}.code-workspace" << 'EOF'
{
  "folders": [
    {
      "path": "."
    }
  ],
  "settings": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true,
    "typescript.tsdk": "node_modules/typescript/lib"
  }
}
EOF
    
    print_success "VS Code workspace configured"
}

################################################################################
# Git Initialization
################################################################################

init_git_repository() {
    local project_name="$1"
    
    print_info "Initializing Git repository..."
    
    git init -q
    git add .
    git commit -q -m "Initial commit: $project_name Next.js project"
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
    
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) not found. Install with: brew install gh"
        return 1
    fi
    
    if ! gh auth status &> /dev/null; then
        print_error "Not authenticated with GitHub. Run: gh auth login"
        return 1
    fi
    
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
        
        gh repo edit "nandezlabs/$project_name" \
            --add-topic "nextjs" \
            --add-topic "typescript" \
            --add-topic "tailwindcss" 2>/dev/null || true
        
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
    
    echo -e "${BLUE}Project Configuration:${NC}\n"
    
    read -p "Project name: " project_name
    validate_project_name "$project_name" || exit 1
    
    read -p "Description: " description
    
    project_type=$(select_project_type)
    
    project_path="$PROJECTS_DIR/$project_name"
    
    if [[ -d "$project_path" ]]; then
        print_error "Project directory already exists: $project_path"
        exit 1
    fi
    
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
    
    echo -e "\n${BLUE}Creating project...${NC}\n"
    
    create_directory_structure "$project_path" "$project_type"
    
    cd "$project_path" || exit 1
    
    create_package_json "$project_name" "$description" "$project_type"
    create_tsconfig
    create_tailwind_config
    create_next_config
    create_env_files "$project_type"
    create_app_files "$project_type"
    create_components
    create_eslint_config
    create_prettier_config
    create_gitignore
    create_readme "$project_name" "$description" "$project_type"
    create_vscode_workspace "$project_name"
    
    init_git_repository "$project_name"
    
    if [[ "$create_github" == "true" ]]; then
        setup_github_repo "$project_name" "$description" "$github_visibility"
    fi
    
    echo -e "\n${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✓ Project Created Successfully!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${BLUE}Project Details:${NC}"
    echo "  Name: $project_name"
    echo "  Type: $project_type"
    echo "  Path: $project_path"
    echo ""
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo "  1. cd $project_path"
    echo "  2. npm install  # Install dependencies"
    echo "  3. npm run dev  # Start development server"
    echo ""
    echo "  Open http://localhost:3000 in your browser"
    echo ""
    echo -e "${BLUE}Available Commands:${NC}"
    echo "  • npm run dev       - Start dev server"
    echo "  • npm run build     - Build for production"
    echo "  • npm run lint      - Run ESLint"
    echo "  • npm run format    - Format with Prettier"
    echo ""
    
    if [[ "$create_github" == "true" ]]; then
        echo "  GitHub: https://github.com/nandezlabs/$project_name"
        echo ""
    fi
    
    print_success "Happy coding! ⚡"
    echo ""
}

main "$@"
