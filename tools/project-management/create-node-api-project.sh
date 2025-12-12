#!/bin/bash

################################################################################
# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# Node.js API Project Creator
# Creates Node.js API projects with Express/Fastify, TypeScript, and Docker
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
    echo -e "${BLUE}  🚀 Node.js API Project Creator${NC}"
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
    echo -e "${BLUE}Select API type:${NC}" >&2
    echo "1) Express REST API" >&2
    echo "2) Fastify REST API" >&2
    echo "3) Express GraphQL API" >&2
    echo "4) Express with Auth (JWT + Database)" >&2
    echo "" >&2
    
    while true; do
        read -p "Enter choice (1-4): " choice
        case $choice in
            1) echo "express-rest"; return 0 ;;
            2) echo "fastify-rest"; return 0 ;;
            3) echo "express-graphql"; return 0 ;;
            4) echo "express-auth"; return 0 ;;
            *) print_error "Invalid choice. Please select 1-4." ;;
        esac
    done
}

select_database() {
    echo -e "\n${BLUE}Select database:${NC}" >&2
    echo "1) PostgreSQL (with Prisma ORM)" >&2
    echo "2) MongoDB (with Mongoose)" >&2
    echo "3) None" >&2
    echo "" >&2
    
    while true; do
        read -p "Enter choice (1-3): " choice
        case $choice in
            1) echo "postgresql"; return 0 ;;
            2) echo "mongodb"; return 0 ;;
            3) echo "none"; return 0 ;;
            *) print_error "Invalid choice. Please select 1-3." ;;
        esac
    done
}

################################################################################
# Directory Structure
################################################################################

create_directory_structure() {
    local project_type="$1"
    
    print_info "Creating directory structure..."
    
    mkdir -p "$PROJECTS_DIR/$project_name"
    cd "$PROJECTS_DIR/$project_name"
    
    # Common directories
    mkdir -p src/{routes,controllers,middleware,models,services,types,utils}
    mkdir -p src/config
    mkdir -p tests/{unit,integration}
    mkdir -p .vscode
    
    # Type-specific directories
    case $project_type in
        express-graphql)
            mkdir -p src/{schema,resolvers}
            ;;
        express-auth)
            mkdir -p src/auth
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
    local database="$4"
    
    print_info "Creating package.json..."
    
    local dependencies='"express": "^4.18.2"'
    local dev_dependencies='"@types/node": "^20.10.0",
    "typescript": "^5.3.0",
    "tsx": "^4.7.0",
    "nodemon": "^3.0.2",
    "@types/express": "^4.17.21",
    "eslint": "^8.55.0",
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "prettier": "^3.1.0",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.11",
    "ts-jest": "^29.1.1",
    "supertest": "^6.3.3",
    "@types/supertest": "^6.0.2"'
    
    # Add type-specific dependencies
    case $project_type in
        fastify-rest)
            dependencies='"fastify": "^4.25.0",
    "@fastify/cors": "^8.5.0",
    "@fastify/helmet": "^11.1.1",
    "@fastify/swagger": "^8.13.0",
    "@fastify/swagger-ui": "^2.1.0"'
            dev_dependencies+=',
    "@types/fastify": "^4.0.0"'
            ;;
        express-rest)
            dependencies+=',
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "express-validator": "^7.0.1",
    "swagger-ui-express": "^5.0.0",
    "swagger-jsdoc": "^6.2.8"'
            dev_dependencies+=',
    "@types/cors": "^2.8.17",
    "@types/morgan": "^1.9.9",
    "@types/swagger-ui-express": "^4.1.6",
    "@types/swagger-jsdoc": "^6.0.4"'
            ;;
        express-graphql)
            dependencies+=',
    "graphql": "^16.8.1",
    "express-graphql": "^0.12.0",
    "@graphql-tools/schema": "^10.0.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0"'
            dev_dependencies+=',
    "@types/cors": "^2.8.17"'
            ;;
        express-auth)
            dependencies+=',
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "bcrypt": "^5.1.1",
    "jsonwebtoken": "^9.0.2",
    "express-validator": "^7.0.1",
    "dotenv": "^16.3.1"'
            dev_dependencies+=',
    "@types/cors": "^2.8.17",
    "@types/morgan": "^1.9.9",
    "@types/bcrypt": "^5.0.2",
    "@types/jsonwebtoken": "^9.0.5"'
            ;;
    esac
    
    # Add database dependencies
    case $database in
        postgresql)
            dependencies+=',
    "@prisma/client": "^5.7.0",
    "dotenv": "^16.3.1"'
            dev_dependencies+=',
    "prisma": "^5.7.0"'
            ;;
        mongodb)
            dependencies+=',
    "mongoose": "^8.0.3",
    "dotenv": "^16.3.1"'
            dev_dependencies+=',
    "@types/mongoose": "^5.11.97"'
            ;;
    esac
    
    cat > package.json << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "description": "$description",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon --exec tsx src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src --ext .ts",
    "lint:fix": "eslint src --ext .ts --fix",
    "format": "prettier --write \"src/**/*.ts\" \"tests/**/*.ts\"",
    "type-check": "tsc --noEmit"
  },
  "keywords": ["api", "rest", "typescript", "node"],
  "author": "",
  "license": "MIT",
  "dependencies": {
    $dependencies
  },
  "devDependencies": {
    $dev_dependencies
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
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
EOF
    
    print_success "tsconfig.json created"
}

################################################################################
# Source Files Creation
################################################################################

create_express_rest_files() {
    print_info "Creating Express REST API files..."
    
    # Main entry point
    cat > src/index.ts << 'EOF'
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from './config';
import { errorHandler } from './middleware/errorHandler';
import healthRouter from './routes/health';
import apiRouter from './routes/api';

const app: Application = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/health', healthRouter);
app.use('/api', apiRouter);

// Error handling
app.use(errorHandler);

// Start server
const PORT = config.port;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📝 Environment: ${config.env}`);
});

export default app;
EOF

    # Config
    cat > src/config/index.ts << 'EOF'
export const config = {
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  database: {
    url: process.env.DATABASE_URL || '',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'dev-secret-change-in-production',
    expiresIn: '24h',
  },
};
EOF

    # Health route
    cat > src/routes/health.ts << 'EOF'
import { Router, Request, Response } from 'express';

const router = Router();

router.get('/', (req: Request, res: Response) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

export default router;
EOF

    # API routes
    cat > src/routes/api.ts << 'EOF'
import { Router } from 'express';
import itemsRouter from './items';

const router = Router();

router.use('/items', itemsRouter);

export default router;
EOF

    # Items routes
    cat > src/routes/items.ts << 'EOF'
import { Router } from 'express';
import { getItems, getItemById, createItem, updateItem, deleteItem } from '../controllers/itemController';
import { validateItem } from '../middleware/validation';

const router = Router();

router.get('/', getItems);
router.get('/:id', getItemById);
router.post('/', validateItem, createItem);
router.put('/:id', validateItem, updateItem);
router.delete('/:id', deleteItem);

export default router;
EOF

    # Item controller
    cat > src/controllers/itemController.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import { itemService } from '../services/itemService';

export const getItems = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const items = await itemService.findAll();
    res.json({ data: items });
  } catch (error) {
    next(error);
  }
};

export const getItemById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const item = await itemService.findById(req.params.id);
    if (!item) {
      return res.status(404).json({ error: 'Item not found' });
    }
    res.json({ data: item });
  } catch (error) {
    next(error);
  }
};

export const createItem = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const item = await itemService.create(req.body);
    res.status(201).json({ data: item });
  } catch (error) {
    next(error);
  }
};

export const updateItem = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const item = await itemService.update(req.params.id, req.body);
    if (!item) {
      return res.status(404).json({ error: 'Item not found' });
    }
    res.json({ data: item });
  } catch (error) {
    next(error);
  }
};

export const deleteItem = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await itemService.delete(req.params.id);
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};
EOF

    # Item service
    cat > src/services/itemService.ts << 'EOF'
import { Item } from '../types';

// In-memory storage (replace with database in production)
let items: Item[] = [
  { id: '1', name: 'Item 1', description: 'First item', createdAt: new Date() },
  { id: '2', name: 'Item 2', description: 'Second item', createdAt: new Date() },
];

class ItemService {
  async findAll(): Promise<Item[]> {
    return items;
  }

  async findById(id: string): Promise<Item | undefined> {
    return items.find(item => item.id === id);
  }

  async create(data: Omit<Item, 'id' | 'createdAt'>): Promise<Item> {
    const item: Item = {
      id: Date.now().toString(),
      ...data,
      createdAt: new Date(),
    };
    items.push(item);
    return item;
  }

  async update(id: string, data: Partial<Omit<Item, 'id' | 'createdAt'>>): Promise<Item | undefined> {
    const index = items.findIndex(item => item.id === id);
    if (index === -1) return undefined;
    
    items[index] = { ...items[index], ...data };
    return items[index];
  }

  async delete(id: string): Promise<void> {
    items = items.filter(item => item.id !== id);
  }
}

export const itemService = new ItemService();
EOF

    # Types
    cat > src/types/index.ts << 'EOF'
export interface Item {
  id: string;
  name: string;
  description: string;
  createdAt: Date;
}

export interface ApiResponse<T> {
  data?: T;
  error?: string;
  message?: string;
}
EOF

    # Validation middleware
    cat > src/middleware/validation.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import { body, validationResult } from 'express-validator';

export const validateItem = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('description').trim().notEmpty().withMessage('Description is required'),
  (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  },
];
EOF

    # Error handler
    cat > src/middleware/errorHandler.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  console.error('Error:', err);

  res.status(500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined,
  });
};
EOF

    print_success "Express REST API files created"
}

create_fastify_rest_files() {
    print_info "Creating Fastify REST API files..."
    
    cat > src/index.ts << 'EOF'
import Fastify from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import { config } from './config';
import healthRoutes from './routes/health';
import itemRoutes from './routes/items';

const fastify = Fastify({
  logger: true,
});

// Register plugins
fastify.register(cors);
fastify.register(helmet);

// Register Swagger
fastify.register(swagger, {
  openapi: {
    info: {
      title: 'API Documentation',
      version: '1.0.0',
    },
  },
});

fastify.register(swaggerUi, {
  routePrefix: '/docs',
});

// Register routes
fastify.register(healthRoutes, { prefix: '/health' });
fastify.register(itemRoutes, { prefix: '/api/items' });

// Start server
const start = async () => {
  try {
    await fastify.listen({ port: config.port, host: '0.0.0.0' });
    console.log(`🚀 Server running on port ${config.port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
EOF

    cat > src/config/index.ts << 'EOF'
export const config = {
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
};
EOF

    cat > src/routes/health.ts << 'EOF'
import { FastifyPluginAsync } from 'fastify';

const healthRoutes: FastifyPluginAsync = async (fastify) => {
  fastify.get('/', async (request, reply) => {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    };
  });
};

export default healthRoutes;
EOF

    cat > src/routes/items.ts << 'EOF'
import { FastifyPluginAsync } from 'fastify';
import { itemService } from '../services/itemService';

const itemRoutes: FastifyPluginAsync = async (fastify) => {
  fastify.get('/', async (request, reply) => {
    const items = await itemService.findAll();
    return { data: items };
  });

  fastify.get('/:id', async (request, reply) => {
    const { id } = request.params as { id: string };
    const item = await itemService.findById(id);
    if (!item) {
      return reply.status(404).send({ error: 'Item not found' });
    }
    return { data: item };
  });

  fastify.post('/', async (request, reply) => {
    const item = await itemService.create(request.body as any);
    return reply.status(201).send({ data: item });
  });

  fastify.put('/:id', async (request, reply) => {
    const { id } = request.params as { id: string };
    const item = await itemService.update(id, request.body as any);
    if (!item) {
      return reply.status(404).send({ error: 'Item not found' });
    }
    return { data: item };
  });

  fastify.delete('/:id', async (request, reply) => {
    const { id } = request.params as { id: string };
    await itemService.delete(id);
    return reply.status(204).send();
  });
};

export default itemRoutes;
EOF

    cat > src/services/itemService.ts << 'EOF'
import { Item } from '../types';

let items: Item[] = [
  { id: '1', name: 'Item 1', description: 'First item', createdAt: new Date() },
  { id: '2', name: 'Item 2', description: 'Second item', createdAt: new Date() },
];

class ItemService {
  async findAll(): Promise<Item[]> {
    return items;
  }

  async findById(id: string): Promise<Item | undefined> {
    return items.find(item => item.id === id);
  }

  async create(data: Omit<Item, 'id' | 'createdAt'>): Promise<Item> {
    const item: Item = {
      id: Date.now().toString(),
      ...data,
      createdAt: new Date(),
    };
    items.push(item);
    return item;
  }

  async update(id: string, data: Partial<Omit<Item, 'id' | 'createdAt'>>): Promise<Item | undefined> {
    const index = items.findIndex(item => item.id === id);
    if (index === -1) return undefined;
    
    items[index] = { ...items[index], ...data };
    return items[index];
  }

  async delete(id: string): Promise<void> {
    items = items.filter(item => item.id !== id);
  }
}

export const itemService = new ItemService();
EOF

    cat > src/types/index.ts << 'EOF'
export interface Item {
  id: string;
  name: string;
  description: string;
  createdAt: Date;
}
EOF

    print_success "Fastify REST API files created"
}

create_express_graphql_files() {
    print_info "Creating Express GraphQL API files..."
    
    cat > src/index.ts << 'EOF'
import express from 'express';
import { graphqlHTTP } from 'express-graphql';
import cors from 'cors';
import helmet from 'helmet';
import { schema } from './schema';
import { config } from './config';

const app = express();

app.use(helmet({ contentSecurityPolicy: false }));
app.use(cors());
app.use(express.json());

app.use('/graphql', graphqlHTTP({
  schema,
  graphiql: config.env === 'development',
}));

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

const PORT = config.port;
app.listen(PORT, () => {
  console.log(`🚀 GraphQL server running on port ${PORT}`);
  console.log(`📊 GraphiQL: http://localhost:${PORT}/graphql`);
});

export default app;
EOF

    cat > src/config/index.ts << 'EOF'
export const config = {
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
};
EOF

    cat > src/schema/index.ts << 'EOF'
import { GraphQLSchema, GraphQLObjectType, GraphQLString, GraphQLList, GraphQLNonNull } from 'graphql';
import { ItemType } from './types';
import * as itemResolvers from '../resolvers/itemResolvers';

const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  fields: {
    items: {
      type: new GraphQLList(ItemType),
      resolve: itemResolvers.getItems,
    },
    item: {
      type: ItemType,
      args: { id: { type: new GraphQLNonNull(GraphQLString) } },
      resolve: itemResolvers.getItem,
    },
  },
});

const Mutation = new GraphQLObjectType({
  name: 'Mutation',
  fields: {
    createItem: {
      type: ItemType,
      args: {
        name: { type: new GraphQLNonNull(GraphQLString) },
        description: { type: new GraphQLNonNull(GraphQLString) },
      },
      resolve: itemResolvers.createItem,
    },
    updateItem: {
      type: ItemType,
      args: {
        id: { type: new GraphQLNonNull(GraphQLString) },
        name: { type: GraphQLString },
        description: { type: GraphQLString },
      },
      resolve: itemResolvers.updateItem,
    },
    deleteItem: {
      type: GraphQLString,
      args: { id: { type: new GraphQLNonNull(GraphQLString) } },
      resolve: itemResolvers.deleteItem,
    },
  },
});

export const schema = new GraphQLSchema({
  query: RootQuery,
  mutation: Mutation,
});
EOF

    cat > src/schema/types.ts << 'EOF'
import { GraphQLObjectType, GraphQLString, GraphQLID } from 'graphql';

export const ItemType = new GraphQLObjectType({
  name: 'Item',
  fields: () => ({
    id: { type: GraphQLID },
    name: { type: GraphQLString },
    description: { type: GraphQLString },
    createdAt: { type: GraphQLString },
  }),
});
EOF

    cat > src/resolvers/itemResolvers.ts << 'EOF'
import { itemService } from '../services/itemService';

export const getItems = async () => {
  return await itemService.findAll();
};

export const getItem = async (_: any, args: { id: string }) => {
  return await itemService.findById(args.id);
};

export const createItem = async (_: any, args: { name: string; description: string }) => {
  return await itemService.create(args);
};

export const updateItem = async (_: any, args: { id: string; name?: string; description?: string }) => {
  const { id, ...data } = args;
  return await itemService.update(id, data);
};

export const deleteItem = async (_: any, args: { id: string }) => {
  await itemService.delete(args.id);
  return 'Item deleted successfully';
};
EOF

    cat > src/services/itemService.ts << 'EOF'
import { Item } from '../types';

let items: Item[] = [
  { id: '1', name: 'Item 1', description: 'First item', createdAt: new Date() },
  { id: '2', name: 'Item 2', description: 'Second item', createdAt: new Date() },
];

class ItemService {
  async findAll(): Promise<Item[]> {
    return items;
  }

  async findById(id: string): Promise<Item | undefined> {
    return items.find(item => item.id === id);
  }

  async create(data: Omit<Item, 'id' | 'createdAt'>): Promise<Item> {
    const item: Item = {
      id: Date.now().toString(),
      ...data,
      createdAt: new Date(),
    };
    items.push(item);
    return item;
  }

  async update(id: string, data: Partial<Omit<Item, 'id' | 'createdAt'>>): Promise<Item | undefined> {
    const index = items.findIndex(item => item.id === id);
    if (index === -1) return undefined;
    
    items[index] = { ...items[index], ...data };
    return items[index];
  }

  async delete(id: string): Promise<void> {
    items = items.filter(item => item.id !== id);
  }
}

export const itemService = new ItemService();
EOF

    cat > src/types/index.ts << 'EOF'
export interface Item {
  id: string;
  name: string;
  description: string;
  createdAt: Date;
}
EOF

    print_success "Express GraphQL API files created"
}

create_express_auth_files() {
    print_info "Creating Express with Auth files..."
    
    create_express_rest_files
    
    # Auth routes
    cat > src/routes/auth.ts << 'EOF'
import { Router } from 'express';
import { register, login, getProfile } from '../controllers/authController';
import { authenticate } from '../middleware/authenticate';

const router = Router();

router.post('/register', register);
router.post('/login', login);
router.get('/profile', authenticate, getProfile);

export default router;
EOF

    # Auth controller
    cat > src/controllers/authController.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { config } from '../config';

// In-memory user storage (replace with database)
interface User {
  id: string;
  email: string;
  password: string;
  name: string;
}

const users: User[] = [];

export const register = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password, name } = req.body;

    // Check if user exists
    if (users.find(u => u.email === email)) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user: User = {
      id: Date.now().toString(),
      email,
      password: hashedPassword,
      name,
    };

    users.push(user);

    // Generate token
    const token = jwt.sign({ id: user.id, email: user.email }, config.jwt.secret, {
      expiresIn: config.jwt.expiresIn,
    });

    res.status(201).json({
      data: {
        user: { id: user.id, email: user.email, name: user.name },
        token,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const login = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password } = req.body;

    // Find user
    const user = users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Verify password
    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign({ id: user.id, email: user.email }, config.jwt.secret, {
      expiresIn: config.jwt.expiresIn,
    });

    res.json({
      data: {
        user: { id: user.id, email: user.email, name: user.name },
        token,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const getProfile = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const userId = (req as any).user.id;
    const user = users.find(u => u.id === userId);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      data: {
        user: { id: user.id, email: user.email, name: user.name },
      },
    });
  } catch (error) {
    next(error);
  }
};
EOF

    # Auth middleware
    cat > src/middleware/authenticate.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../config';

export const authenticate = (req: Request, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, config.jwt.secret);
    (req as any).user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};
EOF

    # Update main index.ts to include auth routes
    cat > src/index.ts << 'EOF'
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from './config';
import { errorHandler } from './middleware/errorHandler';
import healthRouter from './routes/health';
import authRouter from './routes/auth';
import apiRouter from './routes/api';

const app: Application = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/health', healthRouter);
app.use('/auth', authRouter);
app.use('/api', apiRouter);

// Error handling
app.use(errorHandler);

// Start server
const PORT = config.port;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📝 Environment: ${config.env}`);
  console.log(`🔐 Auth endpoints: POST /auth/register, POST /auth/login`);
});

export default app;
EOF

    print_success "Express with Auth files created"
}

################################################################################
# Additional Configuration Files
################################################################################

create_env_files() {
    print_info "Creating environment files..."
    
    cat > .env.example << 'EOF'
# Application
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
# DATABASE_URL=mongodb://localhost:27017/dbname

# JWT
JWT_SECRET=your-secret-key-change-in-production

# Cors
CORS_ORIGIN=http://localhost:3000
EOF

    cat > .env << 'EOF'
NODE_ENV=development
PORT=3000
JWT_SECRET=dev-secret-change-in-production
EOF

    print_success "Environment files created"
}

create_docker_files() {
    print_info "Creating Docker configuration..."
    
    cat > Dockerfile << 'EOF'
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.js"]
EOF

    cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
dist
.env
.env.local
.git
.gitignore
README.md
tests
*.md
EOF

    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
    env_file:
      - .env
    restart: unless-stopped

  # Uncomment for PostgreSQL
  # postgres:
  #   image: postgres:15-alpine
  #   environment:
  #     POSTGRES_DB: mydb
  #     POSTGRES_USER: user
  #     POSTGRES_PASSWORD: password
  #   volumes:
  #     - postgres_data:/var/lib/postgresql/data
  #   ports:
  #     - "5432:5432"

  # Uncomment for MongoDB
  # mongodb:
  #   image: mongo:7-jammy
  #   environment:
  #     MONGO_INITDB_ROOT_USERNAME: admin
  #     MONGO_INITDB_ROOT_PASSWORD: password
  #   volumes:
  #     - mongo_data:/data/db
  #   ports:
  #     - "27017:27017"

# volumes:
#   postgres_data:
#   mongo_data:
EOF

    print_success "Docker configuration created"
}

create_eslint_config() {
    print_info "Creating ESLint configuration..."
    
    cat > .eslintrc.json << 'EOF'
{
  "parser": "@typescript-eslint/parser",
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module"
  },
  "rules": {
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }],
    "no-console": "off"
  },
  "env": {
    "node": true,
    "es2022": true
  }
}
EOF

    print_success "ESLint configured"
}

create_prettier_config() {
    print_info "Creating Prettier configuration..."
    
    cat > .prettierrc << 'EOF'
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "arrowParens": "avoid"
}
EOF

    cat > .prettierignore << 'EOF'
node_modules
dist
coverage
*.log
EOF

    print_success "Prettier configured"
}

create_jest_config() {
    print_info "Creating Jest configuration..."
    
    cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  testMatch: ['**/*.test.ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/types/**',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
};
EOF

    # Create sample test
    cat > tests/unit/health.test.ts << 'EOF'
describe('Health Check', () => {
  it('should return ok status', () => {
    expect(true).toBe(true);
  });
});
EOF

    print_success "Jest configured"
}

create_gitignore() {
    print_info "Creating .gitignore..."
    
    cat > .gitignore << 'EOF'
# Dependencies
node_modules
/.pnp
.pnp.js

# Testing
coverage
*.test.ts.snap

# Production
dist
build

# Environment
.env
.env.local
.env.*.local

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS
.DS_Store
*.pem

# IDEs
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.idea
*.swp
*.swo

# Docker
*.pid
*.seed
*.pid.lock

# Misc
.cache
EOF

    print_success ".gitignore created"
}

create_readme() {
    local project_name="$1"
    local description="$2"
    local project_type="$3"
    local database="$4"
    
    print_info "Creating README.md..."
    
    local framework_badge=""
    local api_type=""
    
    case $project_type in
        express-rest)
            framework_badge="![Express](https://img.shields.io/badge/Express-4.18-green)"
            api_type="REST API"
            ;;
        fastify-rest)
            framework_badge="![Fastify](https://img.shields.io/badge/Fastify-4.25-blue)"
            api_type="REST API"
            ;;
        express-graphql)
            framework_badge="![GraphQL](https://img.shields.io/badge/GraphQL-16.8-E10098)"
            api_type="GraphQL API"
            ;;
        express-auth)
            framework_badge="![Express](https://img.shields.io/badge/Express-4.18-green)"
            api_type="REST API with Authentication"
            ;;
    esac
    
    cat > README.md << EOF
# $project_name

$description

![Node.js](https://img.shields.io/badge/Node.js-18+-339933)
![TypeScript](https://img.shields.io/badge/TypeScript-5.3-blue)
$framework_badge
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED)

## 🚀 Tech Stack

- **Runtime**: Node.js 18+
- **Language**: TypeScript
- **Type**: $api_type
- **Testing**: Jest
- **Linting**: ESLint
- **Formatting**: Prettier
- **Container**: Docker

## 📦 Getting Started

### Prerequisites

- Node.js 18.17 or later
- npm 9.0 or later
- Docker (optional)

### Installation

\`\`\`bash
# Install dependencies
npm install

# Set up environment
cp .env.example .env
# Edit .env with your configuration

# Run development server
npm run dev
\`\`\`

The API will be available at \`http://localhost:3000\`

## 📜 Available Scripts

- \`npm run dev\` - Start development server with hot reload
- \`npm run build\` - Build for production
- \`npm start\` - Start production server
- \`npm test\` - Run tests
- \`npm run test:watch\` - Run tests in watch mode
- \`npm run test:coverage\` - Run tests with coverage
- \`npm run lint\` - Run ESLint
- \`npm run lint:fix\` - Fix ESLint errors
- \`npm run format\` - Format code with Prettier
- \`npm run type-check\` - Run TypeScript type checking

## 📁 Project Structure

\`\`\`
$project_name/
├── src/
│   ├── routes/          # API routes
│   ├── controllers/     # Request handlers
│   ├── services/        # Business logic
│   ├── middleware/      # Custom middleware
│   ├── models/          # Data models
│   ├── types/           # TypeScript types
│   ├── config/          # Configuration
│   └── index.ts         # Entry point
├── tests/
│   ├── unit/            # Unit tests
│   └── integration/     # Integration tests
├── Dockerfile
├── docker-compose.yml
└── package.json
\`\`\`

## 🔌 API Endpoints

### Health Check

\`\`\`
GET /health
\`\`\`

Response:
\`\`\`json
{
  "status": "ok",
  "timestamp": "2025-12-11T00:00:00.000Z",
  "uptime": 123.456
}
\`\`\`

### Items

\`\`\`
GET    /api/items     # List all items
GET    /api/items/:id # Get item by ID
POST   /api/items     # Create new item
PUT    /api/items/:id # Update item
DELETE /api/items/:id # Delete item
\`\`\`

EOF

    if [[ "$project_type" == "express-auth" ]]; then
        cat >> README.md << 'EOF'

### Authentication

```
POST /auth/register  # Register new user
POST /auth/login     # Login user
GET  /auth/profile   # Get user profile (requires token)
```

**Register/Login Request:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

**Response:**
```json
{
  "data": {
    "user": {
      "id": "1",
      "email": "user@example.com",
      "name": "John Doe"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Using the token:**
```bash
curl -H "Authorization: Bearer <token>" http://localhost:3000/auth/profile
```

EOF
    fi

    if [[ "$project_type" == "express-graphql" ]]; then
        cat >> README.md << 'EOF'

### GraphQL

Access GraphiQL at: `http://localhost:3000/graphql`

**Example Queries:**

```graphql
# Get all items
query {
  items {
    id
    name
    description
    createdAt
  }
}

# Get single item
query {
  item(id: "1") {
    id
    name
    description
  }
}

# Create item
mutation {
  createItem(name: "New Item", description: "Item description") {
    id
    name
    description
  }
}

# Update item
mutation {
  updateItem(id: "1", name: "Updated Name") {
    id
    name
    description
  }
}

# Delete item
mutation {
  deleteItem(id: "1")
}
```

EOF
    fi

    cat >> README.md << 'EOF'

## 🐳 Docker

### Build and Run

```bash
# Build image
docker build -t api-server .

# Run container
docker run -p 3000:3000 --env-file .env api-server

# Or use Docker Compose
docker-compose up -d
```

### Docker Compose Services

- `api` - API server (port 3000)
- `postgres` - PostgreSQL database (optional, uncomment in docker-compose.yml)
- `mongodb` - MongoDB database (optional, uncomment in docker-compose.yml)

## 🧪 Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

Coverage reports are generated in the `coverage/` directory.

## 🚢 Deployment

### Environment Variables

Required environment variables:

```env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@host:5432/db
JWT_SECRET=your-secret-key
```

### Production Build

```bash
# Build
npm run build

# Start
NODE_ENV=production npm start
```

### Deployment Options

- **Docker**: Use provided Dockerfile and docker-compose.yml
- **Cloud**: Deploy to AWS, GCP, Azure, DigitalOcean
- **PaaS**: Heroku, Railway, Render, Fly.io
- **Serverless**: AWS Lambda, Google Cloud Functions (requires adapter)

## 📝 Best Practices

- ✅ TypeScript for type safety
- ✅ ESLint for code quality
- ✅ Prettier for consistent formatting
- ✅ Jest for comprehensive testing
- ✅ Environment-based configuration
- ✅ Error handling middleware
- ✅ Request validation
- ✅ Security headers (Helmet)
- ✅ CORS configuration
- ✅ Structured logging
- ✅ Docker support

## 🔒 Security

- Helmet.js for security headers
- CORS configured
- JWT for authentication
- Password hashing with bcrypt
- Environment variables for secrets
- Input validation

## 📄 License

MIT

---

**Created with**: Node.js API Project Creator
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
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/.git": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/coverage": true
  },
  "typescript.preferences.importModuleSpecifier": "relative"
}
EOF

    cat > .vscode/launch.json << 'EOF'
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug Server",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "skipFiles": ["<node_internals>/**"]
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Jest Tests",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--runInBand"],
      "console": "integratedTerminal"
    }
  ]
}
EOF

    cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-typescript-next",
    "rangav.vscode-thunder-client",
    "humao.rest-client"
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
    git commit -q -m "Initial commit: $project_name Node.js API project"
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
            --add-topic "nodejs" \
            --add-topic "typescript" \
            --add-topic "api" \
            --add-topic "rest" 2>/dev/null || true
        
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
    database=$(select_database)
    
    # Summary
    echo -e "\n${BLUE}Project Summary:${NC}\n"
    echo "  Name:        $project_name"
    echo "  Description: $description"
    echo "  Type:        $project_type"
    echo "  Database:    $database"
    echo "  Location:    $PROJECTS_DIR/$project_name"
    echo ""
    
    read -p "Create project? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_error "Project creation cancelled"
        exit 0
    fi
    
    # Create project
    create_directory_structure "$project_type"
    create_package_json "$project_name" "$description" "$project_type" "$database"
    create_tsconfig
    
    # Create source files based on type
    case $project_type in
        express-rest)
            create_express_rest_files
            ;;
        fastify-rest)
            create_fastify_rest_files
            ;;
        express-graphql)
            create_express_graphql_files
            ;;
        express-auth)
            create_express_auth_files
            ;;
    esac
    
    # Additional configurations
    create_env_files
    create_docker_files
    create_eslint_config
    create_prettier_config
    create_jest_config
    create_gitignore
    create_readme "$project_name" "$description" "$project_type" "$database"
    create_vscode_workspace "$project_name"
    
    # Git
    init_git_repository "$project_name"
    
    # GitHub (optional)
    echo ""
    read -p "Create GitHub repository? (y/n): " create_gh
    if [[ "$create_gh" =~ ^[Yy]$ ]]; then
        read -p "Repository visibility (public/private): " visibility
        setup_github_repo "$project_name" "$description" "$visibility"
    fi
    
    # Install dependencies
    echo ""
    read -p "Install dependencies now? (y/n): " install_deps
    if [[ "$install_deps" =~ ^[Yy]$ ]]; then
        print_info "Installing dependencies..."
        npm install
        print_success "Dependencies installed"
    fi
    
    # Success message
    echo -e "\n${GREEN}════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✓ Project Created Successfully!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════${NC}\n"
    
    print_success "Project created at: $PROJECTS_DIR/$project_name"
    
    echo -e "\n${BLUE}Next Steps:${NC}"
    echo "  1. cd $PROJECTS_DIR/$project_name"
    
    if [[ "$install_deps" != [Yy] ]]; then
        echo "  2. npm install"
        echo "  3. Edit .env with your configuration"
        echo "  4. npm run dev"
    else
        echo "  2. Edit .env with your configuration"
        echo "  3. npm run dev"
    fi
    
    echo -e "\n${BLUE}Available Commands:${NC}"
    echo "  npm run dev         - Start development server"
    echo "  npm run build       - Build for production"
    echo "  npm test           - Run tests"
    echo "  npm run lint       - Check code quality"
    
    echo ""
}

main "$@"
