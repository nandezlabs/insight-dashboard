#!/bin/bash

################################################################################
# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# React + Vite Project Creator
# Creates modern React applications with Vite, TypeScript, and Tailwind CSS
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
    echo -e "${BLUE}  ⚛️  React + Vite Project Creator${NC}"
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
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js not found. Install with: brew install node"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm not found. Please install Node.js."
        exit 1
    fi
    
    print_success "Node.js $(node --version)"
    print_success "npm $(npm --version)"
}

validate_project_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        print_error "Project name cannot be empty"
        return 1
    fi
    
    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        print_error "Project name can only contain lowercase letters, numbers, and hyphens"
        return 1
    fi
    
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
    echo "1) Basic SPA (Single Page Application)" >&2
    echo "2) With React Router (Multi-page SPA)" >&2
    echo "3) With State Management (Zustand)" >&2
    echo "4) Full-featured (Router + Zustand + React Query)" >&2
    echo "" >&2
    
    while true; do
        read -p "Enter choice (1-4): " choice
        case $choice in
            1) echo "basic"; return 0 ;;
            2) echo "with-router"; return 0 ;;
            3) echo "with-state"; return 0 ;;
            4) echo "full"; return 0 ;;
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
    
    # Base structure
    mkdir -p "$project_path/src/components"
    mkdir -p "$project_path/src/assets"
    mkdir -p "$project_path/src/styles"
    mkdir -p "$project_path/src/utils"
    mkdir -p "$project_path/public"
    mkdir -p "$project_path/.vscode"
    
    # Type-specific directories
    case $project_type in
        with-router|full)
            mkdir -p "$project_path/src/pages"
            mkdir -p "$project_path/src/layouts"
            ;;
        with-state|full)
            mkdir -p "$project_path/src/store"
            ;;
    esac
    
    if [[ "$project_type" == "full" ]]; then
        mkdir -p "$project_path/src/hooks"
        mkdir -p "$project_path/src/lib"
        mkdir -p "$project_path/src/types"
    fi
    
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
    
    local dependencies='"react": "^18.2.0",
    "react-dom": "^18.2.0"'
    
    case $project_type in
        with-router|full)
            dependencies+=',
    "react-router-dom": "^6.20.0"'
            ;;
    esac
    
    case $project_type in
        with-state|full)
            dependencies+=',
    "zustand": "^4.4.0"'
            ;;
    esac
    
    if [[ "$project_type" == "full" ]]; then
        dependencies+=',
    "@tanstack/react-query": "^5.12.0",
    "axios": "^1.6.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.1.0"'
    fi
    
    cat > package.json << EOF
{
  "name": "$project_name",
  "version": "0.1.0",
  "description": "$description",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "format": "prettier --write \"./**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    $dependencies
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0",
    "@vitejs/plugin-react": "^4.2.0",
    "autoprefixer": "^10.4.0",
    "eslint": "^8.55.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.0",
    "postcss": "^8.4.0",
    "prettier": "^3.1.0",
    "prettier-plugin-tailwindcss": "^0.5.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0"
  },
  "engines": {
    "node": ">=18.17.0",
    "npm": ">=9.0.0"
  }
}
EOF
    
    print_success "package.json created"
}

create_tsconfig() {
    print_info "Creating tsconfig.json..."
    
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,

    /* Path aliases */
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF
    
    cat > tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF
    
    print_success "TypeScript configured"
}

create_vite_config() {
    print_info "Creating vite.config.ts..."
    
    cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 3000,
    open: true,
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
  },
})
EOF
    
    print_success "Vite configured"
}

create_tailwind_config() {
    print_info "Creating Tailwind CSS configuration..."
    
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: 'hsl(221.2 83.2% 53.3%)',
          foreground: 'hsl(210 40% 98%)',
        },
        secondary: {
          DEFAULT: 'hsl(210 40% 96.1%)',
          foreground: 'hsl(222.2 47.4% 11.2%)',
        },
      },
    },
  },
  plugins: [],
}
EOF
    
    cat > postcss.config.js << 'EOF'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    
    print_success "Tailwind CSS configured"
}

create_env_files() {
    print_info "Creating environment files..."
    
    cat > .env << 'EOF'
# App Configuration
VITE_APP_TITLE=My React App
VITE_API_URL=http://localhost:3000/api
EOF
    
    cat > .env.example << 'EOF'
# App Configuration
VITE_APP_TITLE=My React App
VITE_API_URL=http://localhost:3000/api
EOF
    
    print_success "Environment files created"
}

################################################################################
# Source Files Creation
################################################################################

create_index_html() {
    local project_name="$1"
    
    print_info "Creating index.html..."
    
    cat > index.html << EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$project_name</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
    
    print_success "index.html created"
}

create_app_files() {
    local project_type="$1"
    
    print_info "Creating app files..."
    
    # Main entry point
    cat > src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './styles/index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF
    
    # Global styles
    cat > src/styles/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
  }
  
  body {
    @apply bg-background text-foreground;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
      'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
      sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
}
EOF
    
    # Type-specific App component
    case $project_type in
        basic)
            create_basic_app
            ;;
        with-router)
            create_router_app
            ;;
        with-state)
            create_state_app
            ;;
        full)
            create_full_app
            ;;
    esac
    
    print_success "App files created"
}

create_basic_app() {
    cat > src/App.tsx << 'EOF'
import { useState } from 'react'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="text-center space-y-8 p-8">
        <h1 className="text-6xl font-bold text-gray-900">
          Welcome to React + Vite
        </h1>
        
        <p className="text-xl text-gray-600">
          Built with TypeScript and Tailwind CSS
        </p>
        
        <div className="flex gap-4 justify-center items-center">
          <button
            onClick={() => setCount((count) => count + 1)}
            className="px-6 py-3 bg-primary text-primary-foreground rounded-lg font-semibold hover:opacity-90 transition-opacity"
          >
            Count: {count}
          </button>
          
          <button
            onClick={() => setCount(0)}
            className="px-6 py-3 bg-secondary text-secondary-foreground rounded-lg font-semibold hover:bg-gray-300 transition-colors"
          >
            Reset
          </button>
        </div>
        
        <div className="pt-8 text-gray-500 text-sm">
          <p>Edit <code className="bg-gray-200 px-2 py-1 rounded">src/App.tsx</code> and save to reload</p>
        </div>
      </div>
    </div>
  )
}

export default App
EOF
}

create_router_app() {
    cat > src/App.tsx << 'EOF'
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom'
import Home from './pages/Home'
import About from './pages/About'

function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-gray-50">
        <nav className="bg-white shadow-sm">
          <div className="container mx-auto px-4 py-4">
            <div className="flex gap-6">
              <Link to="/" className="text-blue-600 hover:text-blue-800 font-semibold">
                Home
              </Link>
              <Link to="/about" className="text-blue-600 hover:text-blue-800 font-semibold">
                About
              </Link>
            </div>
          </div>
        </nav>
        
        <main className="container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/about" element={<About />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

    mkdir -p src/pages
    cat > src/pages/Home.tsx << 'EOF'
export default function Home() {
  return (
    <div className="space-y-6">
      <h1 className="text-4xl font-bold text-gray-900">Home</h1>
      <p className="text-lg text-gray-600">
        Welcome to your React + Vite application with React Router!
      </p>
    </div>
  )
}
EOF

    cat > src/pages/About.tsx << 'EOF'
export default function About() {
  return (
    <div className="space-y-6">
      <h1 className="text-4xl font-bold text-gray-900">About</h1>
      <p className="text-lg text-gray-600">
        This is a React application built with Vite, TypeScript, Tailwind CSS, and React Router.
      </p>
    </div>
  )
}
EOF
}

create_state_app() {
    cat > src/App.tsx << 'EOF'
import { useCountStore } from './store/countStore'

function App() {
  const { count, increment, decrement, reset } = useCountStore()

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-purple-50 to-pink-100">
      <div className="text-center space-y-8 p-8">
        <h1 className="text-6xl font-bold text-gray-900">
          React + Vite + Zustand
        </h1>
        
        <div className="text-7xl font-bold text-purple-600">
          {count}
        </div>
        
        <div className="flex gap-4 justify-center">
          <button
            onClick={increment}
            className="px-6 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition-colors"
          >
            Increment
          </button>
          
          <button
            onClick={decrement}
            className="px-6 py-3 bg-pink-600 text-white rounded-lg font-semibold hover:bg-pink-700 transition-colors"
          >
            Decrement
          </button>
          
          <button
            onClick={reset}
            className="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg font-semibold hover:bg-gray-300 transition-colors"
          >
            Reset
          </button>
        </div>
      </div>
    </div>
  )
}

export default App
EOF

    mkdir -p src/store
    cat > src/store/countStore.ts << 'EOF'
import { create } from 'zustand'

interface CountState {
  count: number
  increment: () => void
  decrement: () => void
  reset: () => void
}

export const useCountStore = create<CountState>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
  decrement: () => set((state) => ({ count: state.count - 1 })),
  reset: () => set({ count: 0 }),
}))
EOF
}

create_full_app() {
    cat > src/App.tsx << 'EOF'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import Layout from './layouts/Layout'
import Home from './pages/Home'
import About from './pages/About'

const queryClient = new QueryClient()

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Layout />}>
            <Route index element={<Home />} />
            <Route path="about" element={<About />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  )
}

export default App
EOF

    mkdir -p src/layouts
    cat > src/layouts/Layout.tsx << 'EOF'
import { Outlet, Link } from 'react-router-dom'

export default function Layout() {
  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm">
        <div className="container mx-auto px-4 py-4">
          <div className="flex gap-6">
            <Link to="/" className="text-blue-600 hover:text-blue-800 font-semibold">
              Home
            </Link>
            <Link to="/about" className="text-blue-600 hover:text-blue-800 font-semibold">
              About
            </Link>
          </div>
        </div>
      </nav>
      
      <main className="container mx-auto px-4 py-8">
        <Outlet />
      </main>
    </div>
  )
}
EOF

    mkdir -p src/pages
    cat > src/pages/Home.tsx << 'EOF'
import { useCountStore } from '../store/countStore'

export default function Home() {
  const { count, increment, reset } = useCountStore()

  return (
    <div className="space-y-6">
      <h1 className="text-4xl font-bold text-gray-900">Home</h1>
      <p className="text-lg text-gray-600">
        Full-featured React app with Router, Zustand, and React Query!
      </p>
      
      <div className="bg-white p-6 rounded-lg shadow-sm">
        <div className="text-4xl font-bold text-center mb-4">{count}</div>
        <div className="flex gap-4 justify-center">
          <button
            onClick={increment}
            className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
          >
            Increment
          </button>
          <button
            onClick={reset}
            className="px-4 py-2 bg-gray-200 text-gray-800 rounded hover:bg-gray-300"
          >
            Reset
          </button>
        </div>
      </div>
    </div>
  )
}
EOF

    cat > src/pages/About.tsx << 'EOF'
export default function About() {
  return (
    <div className="space-y-6">
      <h1 className="text-4xl font-bold text-gray-900">About</h1>
      <div className="bg-white p-6 rounded-lg shadow-sm">
        <h2 className="text-2xl font-semibold mb-4">Tech Stack</h2>
        <ul className="space-y-2 text-gray-600">
          <li>⚡ Vite - Fast build tool</li>
          <li>⚛️ React 18 - UI library</li>
          <li>📘 TypeScript - Type safety</li>
          <li>🎨 Tailwind CSS - Styling</li>
          <li>🔀 React Router - Routing</li>
          <li>🐻 Zustand - State management</li>
          <li>🔄 React Query - Data fetching</li>
        </ul>
      </div>
    </div>
  )
}
EOF

    mkdir -p src/store
    cat > src/store/countStore.ts << 'EOF'
import { create } from 'zustand'

interface CountState {
  count: number
  increment: () => void
  decrement: () => void
  reset: () => void
}

export const useCountStore = create<CountState>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
  decrement: () => set((state) => ({ count: state.count - 1 })),
  reset: () => set({ count: 0 }),
}))
EOF

    mkdir -p src/lib
    cat > src/lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF
}

create_components() {
    print_info "Creating components..."
    
    cat > src/components/Button.tsx << 'EOF'
import { ButtonHTMLAttributes, ReactNode } from 'react'

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode
  variant?: 'primary' | 'secondary' | 'outline'
}

export default function Button({ 
  children, 
  variant = 'primary', 
  className = '',
  ...props 
}: ButtonProps) {
  const baseStyles = 'px-4 py-2 rounded-lg font-semibold transition-colors'
  
  const variants = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300',
    outline: 'border-2 border-blue-600 text-blue-600 hover:bg-blue-50',
  }
  
  return (
    <button 
      className={`${baseStyles} ${variants[variant]} ${className}`}
      {...props}
    >
      {children}
    </button>
  )
}
EOF
    
    print_success "Components created"
}

create_public_assets() {
    print_info "Creating public assets..."
    
    cat > public/vite.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" class="iconify iconify--logos" width="31.88" height="32" preserveAspectRatio="xMidYMid meet" viewBox="0 0 256 257"><defs><linearGradient id="IconifyId1813088fe1fbc01fb466" x1="-.828%" x2="57.636%" y1="7.652%" y2="78.411%"><stop offset="0%" stop-color="#41D1FF"></stop><stop offset="100%" stop-color="#BD34FE"></stop></linearGradient><linearGradient id="IconifyId1813088fe1fbc01fb467" x1="43.376%" x2="50.316%" y1="2.242%" y2="89.03%"><stop offset="0%" stop-color="#FFEA83"></stop><stop offset="8.333%" stop-color="#FFDD35"></stop><stop offset="100%" stop-color="#FFA800"></stop></linearGradient></defs><path fill="url(#IconifyId1813088fe1fbc01fb466)" d="M255.153 37.938L134.897 252.976c-2.483 4.44-8.862 4.466-11.382.048L.875 37.958c-2.746-4.814 1.371-10.646 6.827-9.67l120.385 21.517a6.537 6.537 0 0 0 2.322-.004l117.867-21.483c5.438-.991 9.574 4.796 6.877 9.62Z"></path><path fill="url(#IconifyId1813088fe1fbc01fb467)" d="M185.432.063L96.44 17.501a3.268 3.268 0 0 0-2.634 3.014l-5.474 92.456a3.268 3.268 0 0 0 3.997 3.378l24.777-5.718c2.318-.535 4.413 1.507 3.936 3.838l-7.361 36.047c-.495 2.426 1.782 4.5 4.151 3.78l15.304-4.649c2.372-.72 4.652 1.36 4.15 3.788l-11.698 56.621c-.732 3.542 3.979 5.473 5.943 2.437l1.313-2.028l72.516-144.72c1.215-2.423-.88-5.186-3.54-4.672l-25.505 4.922c-2.396.462-4.435-1.77-3.759-4.114l16.646-57.705c.677-2.35-1.37-4.583-3.769-4.113Z"></path></svg>
EOF
    
    print_success "Public assets created"
}

################################################################################
# Configuration Files
################################################################################

create_eslint_config() {
    print_info "Creating ESLint configuration..."
    
    cat > .eslintrc.cjs << 'EOF'
module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: ['react-refresh'],
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
    '@typescript-eslint/no-unused-vars': 'warn',
  },
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
dist
build
.vite
*.lock
EOF
    
    print_success "Prettier configured"
}

create_gitignore() {
    print_info "Creating .gitignore..."
    
    cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
dist
dist-ssr
*.local

# Editor
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Environment
.env
.env.local
.env.production
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

![React](https://img.shields.io/badge/React-18-61dafb)
![Vite](https://img.shields.io/badge/Vite-5-646cff)
![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.4-38bdf8)

## 🚀 Tech Stack

- **Build Tool**: Vite 5
- **Framework**: React 18
- **Language**: TypeScript 5.3
- **Styling**: Tailwind CSS 3.4
- **Linting**: ESLint
- **Formatting**: Prettier
EOF

    if [[ "$project_type" == "with-router" || "$project_type" == "full" ]]; then
        cat >> README.md << 'EOF'
- **Routing**: React Router 6
EOF
    fi
    
    if [[ "$project_type" == "with-state" || "$project_type" == "full" ]]; then
        cat >> README.md << 'EOF'
- **State Management**: Zustand
EOF
    fi
    
    if [[ "$project_type" == "full" ]]; then
        cat >> README.md << 'EOF'
- **Data Fetching**: React Query (TanStack Query)
EOF
    fi

    cat >> README.md << EOF

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

The app will open at [http://localhost:3000](http://localhost:3000)

## 📜 Available Scripts

- \`npm run dev\` - Start development server with hot reload
- \`npm run build\` - Build for production (TypeScript + Vite)
- \`npm run preview\` - Preview production build locally
- \`npm run lint\` - Run ESLint
- \`npm run format\` - Format code with Prettier
- \`npm run type-check\` - Run TypeScript type checking

## 📁 Project Structure

\`\`\`
$project_name/
├── src/
│   ├── assets/         # Images, fonts, etc.
│   ├── components/     # Reusable components
│   ├── styles/         # Global styles
│   ├── App.tsx         # Root component
│   └── main.tsx        # Entry point
├── public/             # Static assets
├── index.html          # HTML template
└── package.json
\`\`\`

## 🚢 Deployment

### Vercel

\`\`\`bash
npm install -g vercel
vercel
\`\`\`

### Netlify

\`\`\`bash
npm run build
# Upload dist/ folder to Netlify
\`\`\`

## 📄 License

MIT

---

**Created with**: React + Vite Project Creator
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
    "**/node_modules": true,
    "**/dist": true,
    "**/.git": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true,
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
    "formulahendry.auto-rename-tag"
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
    git commit -q -m "Initial commit: $project_name React + Vite project"
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
            --add-topic "react" \
            --add-topic "vite" \
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
    create_vite_config
    create_tailwind_config
    create_env_files
    create_index_html "$project_name"
    create_app_files "$project_type"
    create_components
    create_public_assets
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
    echo "  • npm run dev       - Start Vite dev server with HMR"
    echo "  • npm run build     - Build for production"
    echo "  • npm run preview   - Preview production build"
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
