#!/bin/zsh

# Apply Planning Configuration
# Reads PLANNING-MASTER.md and sets up project based on specified tech stack

# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}            Apply Planning Configuration to Project               ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if PLANNING-MASTER.md exists
if [[ ! -f "PLANNING-MASTER.md" ]]; then
  echo "${RED}✗${NC} No PLANNING-MASTER.md found in current directory"
  exit 1
fi

# Extract configuration from planning file
extract_config() {
  local key=$1
  grep -A 5 "^${key}:" PLANNING-MASTER.md | sed -n 's/^- \(.*\)/\1/p' | head -1
}

# Parse tech stack configuration
echo "${YELLOW}Reading configuration from PLANNING-MASTER.md...${NC}"
echo ""

# Extract frontend framework
FRONTEND=$(grep -A 10 "\*\*Frontend:\*\*" PLANNING-MASTER.md | grep "Framework:" | sed 's/.*Framework: \[\(.*\)\]/\1/' | head -1)
FRONTEND_LANG=$(grep -A 10 "\*\*Frontend:\*\*" PLANNING-MASTER.md | grep "Language:" | sed 's/.*Language: \[\(.*\)\]/\1/' | head -1)
BUILD_TOOL=$(grep -A 10 "\*\*Frontend:\*\*" PLANNING-MASTER.md | grep "Build Tool:" | sed 's/.*Build Tool: \[\(.*\)\]/\1/' | head -1)

# Extract backend framework  
BACKEND=$(grep -A 10 "\*\*Backend/API:\*\*" PLANNING-MASTER.md | grep "Framework:" | sed 's/.*Framework: \[\(.*\)\]/\1/' | head -1)
BACKEND_LANG=$(grep -A 10 "\*\*Backend/API:\*\*" PLANNING-MASTER.md | grep "Language:" | sed 's/.*Language: \[\(.*\)\]/\1/' | head -1)

# Extract database
DATABASE=$(grep -A 10 "\*\*Backend/API:\*\*" PLANNING-MASTER.md | grep "Database:" | sed 's/.*Database: \[\(.*\)\]/\1/' | head -1)

echo "Frontend: ${FRONTEND:-Not specified}"
echo "Language: ${FRONTEND_LANG:-Not specified}"
echo "Build Tool: ${BUILD_TOOL:-Not specified}"
echo "Backend: ${BACKEND:-Not specified}"
echo "Database: ${DATABASE:-Not specified}"
echo ""

# Determine project type and apply appropriate setup
PROJECT_TYPE="unknown"

# Detect React + Vite
if [[ "$FRONTEND" =~ "React" ]] && [[ "$BUILD_TOOL" =~ "Vite" ]]; then
  PROJECT_TYPE="react-vite"
fi

# Detect Next.js
if [[ "$FRONTEND" =~ "Next" ]] || [[ "$BUILD_TOOL" =~ "Next" ]]; then
  PROJECT_TYPE="nextjs"
fi

# Detect Node API
if [[ "$BACKEND" =~ "Express" ]] || [[ "$BACKEND_LANG" =~ "Node" ]]; then
  PROJECT_TYPE="node-api"
fi

echo "${YELLOW}Detected project type: ${PROJECT_TYPE}${NC}"
echo ""

# Apply configuration based on type
case $PROJECT_TYPE in
  "react-vite")
    echo "${BLUE}Setting up React + Vite project...${NC}"
    
    # Initialize package.json
    cat > package.json << 'PACKAGE'
{
  "name": "project",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint .",
    "format": "prettier --write ."
  }
}
PACKAGE
    echo "${GREEN}✓${NC} Created package.json"
    
    # Create vite config
    cat > vite.config.ts << 'VITE'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000
  }
})
VITE
    echo "${GREEN}✓${NC} Created vite.config.ts"
    
    # Create tsconfig
    cat > tsconfig.json << 'TSCONFIG'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}
TSCONFIG
    echo "${GREEN}✓${NC} Created tsconfig.json"
    
    # Create src structure
    mkdir -p src/{components,features,services,types,utils}
    
    cat > src/main.tsx << 'MAIN'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
MAIN
    
    cat > src/App.tsx << 'APP'
function App() {
  return (
    <div>
      <h1>Project Initialized</h1>
      <p>See PLANNING-MASTER.md for roadmap</p>
    </div>
  )
}

export default App
APP
    
    cat > src/index.css << 'CSS'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
CSS
    
    echo "${GREEN}✓${NC} Created src/ structure"
    
    cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Project</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
HTML
    echo "${GREEN}✓${NC} Created index.html"
    
    # List dependencies to install
    echo ""
    echo "${YELLOW}Install dependencies:${NC}"
    echo "npm install react react-dom"
    echo "npm install -D vite @vitejs/plugin-react typescript @types/react @types/react-dom"
    ;;
    
  "nextjs")
    echo "${BLUE}Setting up Next.js project...${NC}"
    echo "Run: npx create-next-app@latest . --typescript --tailwind --app --src-dir"
    ;;
    
  "node-api")
    echo "${BLUE}Setting up Node.js API project...${NC}"
    
    cat > package.json << 'PACKAGE'
{
  "name": "api",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
}
PACKAGE
    echo "${GREEN}✓${NC} Created package.json"
    
    mkdir -p src/{routes,middleware,models,services}
    
    cat > src/index.ts << 'INDEX'
import express from 'express'

const app = express()
const PORT = process.env.PORT || 3000

app.use(express.json())

app.get('/health', (req, res) => {
  res.json({ status: 'ok' })
})

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
INDEX
    
    echo "${GREEN}✓${NC} Created src/ structure"
    
    echo ""
    echo "${YELLOW}Install dependencies:${NC}"
    echo "npm install express"
    echo "npm install -D typescript tsx @types/express @types/node"
    ;;
    
  *)
    echo "${YELLOW}Project type not auto-detected.${NC}"
    echo "Create project structure based on PLANNING-MASTER.md manually."
    ;;
esac

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}✓ Planning configuration applied${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
