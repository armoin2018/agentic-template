````instructions
# Turbo Build System Instructions

## Tool Overview
- **Tool Name**: Turbo (Turborepo)
- **Version**: 1.10+ (stable), 1.13+ (latest with enhanced features)
- **Category**: Build Tools & Monorepo Management
- **Purpose**: High-performance build system for JavaScript and TypeScript monorepos
- **Prerequisites**: Node.js 16+ (18+ recommended), npm/yarn/pnpm

## Installation & Setup
### Package Manager Installation
```bash
# npm installation
npm install -g turbo
npx create-turbo@latest

# yarn installation
yarn global add turbo
yarn create turbo

# pnpm installation
pnpm add -g turbo
pnpm create turbo

# Initialize existing monorepo
cd my-monorepo
npx turbo init

# Verify installation
turbo --version
```

### Project Integration
```bash
# Create new monorepo
npx create-turbo@latest my-monorepo
cd my-monorepo

# Project structure created:
my-monorepo/
├── turbo.json
├── package.json
├── packages/
│   ├── ui/
│   └── eslint-config-custom/
├── apps/
│   ├── web/
│   └── docs/
└── README.md

# Install dependencies
npm install
# or
yarn install
# or
pnpm install
```

### Basic Configuration (turbo.json)
```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "lint": {
      "outputs": []
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

## Core Features

### Intelligent Build Caching
- **Purpose**: Cache build outputs and skip rebuilding unchanged packages
- **Usage**: Automatic caching based on file content and dependencies
- **Example**:
```json
// turbo.json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [
        "dist/**",
        ".next/**",
        "!.next/cache/**"
      ],
      "env": ["NODE_ENV", "CUSTOM_KEY"]
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"],
      "inputs": ["src/**/*.tsx", "src/**/*.ts", "test/**/*.ts"]
    }
  }
}
```

```bash
# Build with caching
turbo build

# Force rebuild (skip cache)
turbo build --force

# Check cache status
turbo build --dry-run

# Clear cache
turbo prune

# Cache information
turbo build --summarize
```

### Parallel Task Execution
- **Purpose**: Run tasks across packages in parallel with dependency awareness
- **Usage**: Define task dependencies and let Turbo optimize execution
- **Example**:
```json
// turbo.json - Advanced pipeline
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", "build/**"]
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "test:unit": {
      "dependsOn": ["build"]
    },
    "test:e2e": {
      "dependsOn": ["build", "^build"]
    },
    "lint": {
      "outputs": []
    },
    "typecheck": {
      "dependsOn": ["^build"],
      "outputs": []
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

```bash
# Run tasks in parallel
turbo build test lint

# Run with specific concurrency
turbo build --parallel

# Run single package
turbo build --filter=my-app

# Run with scope
turbo build --filter="@my-org/*"
```

### Remote Caching
- **Purpose**: Share build caches across team members and CI/CD
- **Usage**: Connect to Vercel or custom remote cache
- **Example**:
```bash
# Login to Vercel for remote caching
npx turbo login

# Link to remote cache
npx turbo link

# Build with remote cache
turbo build

# Remote cache configuration in turbo.json
{
  "remoteCache": {
    "signature": true
  }
}

# Custom remote cache endpoint
turbo build --api="https://my-cache-server.com" --token="my-token"
```

## Common Commands
```bash
# Build commands
turbo build                             # Build all packages
turbo build --filter=my-app            # Build specific package
turbo build --filter="@scope/*"        # Build packages matching pattern
turbo build --since=HEAD~1             # Build changed packages since commit

# Development
turbo dev                               # Start development servers
turbo dev --filter=web                 # Start specific app
turbo dev --parallel                   # Force parallel execution

# Testing
turbo test                              # Run all tests
turbo test --filter=ui                 # Test specific package
turbo test --continue                  # Continue on test failures

# Linting and type checking
turbo lint                              # Lint all packages
turbo typecheck                        # Type check all packages
turbo lint typecheck --parallel        # Run multiple tasks

# Cache management
turbo prune                             # Clear local cache
turbo prune --scope=my-app             # Clear cache for specific package
turbo build --force                    # Skip cache, force rebuild

# Information and debugging
turbo build --dry-run                  # Show what would be built
turbo build --graph                    # Show dependency graph
turbo build --summarize                # Show build summary
turbo build --profile                  # Profile build performance

# Filtering and scoping
turbo build --filter="web..."          # Build web and its dependencies
turbo build --filter="...ui"           # Build ui and its dependents
turbo build --filter="!@scope/internal" # Exclude specific packages
```

## Advanced Features

### Workspace Configuration
```json
// package.json (root)
{
  "name": "my-monorepo",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "build": "turbo build",
    "dev": "turbo dev",
    "test": "turbo test",
    "lint": "turbo lint",
    "clean": "turbo clean"
  },
  "devDependencies": {
    "turbo": "^1.13.0"
  }
}

// turbo.json - Complex configuration
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": [
    "**/.env.*local",
    ".github/workflows/**",
    "turbo.json"
  ],
  "globalEnv": [
    "NODE_ENV",
    "CI",
    "VERCEL",
    "NEXT_PUBLIC_*"
  ],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "env": ["NODE_ENV"],
      "outputs": [
        "dist/**",
        ".next/**",
        "!.next/cache/**",
        "build/**",
        "storybook-static/**"
      ]
    },
    "test": {
      "dependsOn": ["^build"],
      "env": ["NODE_ENV"],
      "outputs": ["coverage/**", "test-results/**"],
      "inputs": [
        "src/**/*.tsx",
        "src/**/*.ts",
        "test/**/*.ts",
        "jest.config.js"
      ]
    },
    "lint": {
      "outputs": ["eslint-report.json"]
    },
    "typecheck": {
      "dependsOn": ["^build"],
      "outputs": ["tsconfig.tsbuildinfo"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "clean": {
      "cache": false
    }
  }
}
```

### Package.json Scripts Integration
```json
// apps/web/package.json
{
  "name": "web",
  "scripts": {
    "build": "next build",
    "dev": "next dev",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint . --ext .ts,.tsx",
    "typecheck": "tsc --noEmit",
    "clean": "rm -rf .next dist"
  },
  "dependencies": {
    "next": "13.4.0",
    "react": "18.2.0",
    "ui": "*"
  },
  "devDependencies": {
    "@types/react": "18.2.0",
    "eslint-config-custom": "*",
    "typescript": "5.0.0"
  }
}

// packages/ui/package.json
{
  "name": "ui",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "scripts": {
    "build": "tsup src/index.ts --format cjs,esm --dts",
    "dev": "tsup src/index.ts --format cjs,esm --dts --watch",
    "test": "jest",
    "lint": "eslint . --ext .ts,.tsx",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "react": "18.2.0"
  },
  "devDependencies": {
    "tsup": "6.7.0",
    "typescript": "5.0.0",
    "eslint-config-custom": "*"
  }
}
```

### Environment Variables
```bash
# .env.local (global)
NODE_ENV=development
DATABASE_URL=postgresql://localhost:5432/mydb
NEXT_PUBLIC_API_URL=http://localhost:3000/api

# apps/web/.env.local
NEXT_PUBLIC_SITE_URL=http://localhost:3000
ANALYTICS_ID=GA-123456789

# apps/api/.env.local
PORT=3001
JWT_SECRET=my-secret-key
```

```json
// turbo.json - Environment variable configuration
{
  "globalEnv": [
    "NODE_ENV",
    "CI",
    "VERCEL_*"
  ],
  "pipeline": {
    "build": {
      "env": [
        "NEXT_PUBLIC_*",
        "DATABASE_URL"
      ],
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"]
    }
  }
}
```

## Monorepo Patterns

### Shared Component Library
```typescript
// packages/ui/src/Button.tsx
import React from 'react'
import { cn } from './utils'

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline'
  size?: 'sm' | 'md' | 'lg'
  children: React.ReactNode
}

export function Button({
  variant = 'primary',
  size = 'md',
  className,
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center rounded-md font-medium transition-colors',
        {
          'bg-blue-600 text-white hover:bg-blue-700': variant === 'primary',
          'bg-gray-600 text-white hover:bg-gray-700': variant === 'secondary',
          'border border-gray-300 bg-white hover:bg-gray-50': variant === 'outline'
        },
        {
          'h-8 px-3 text-sm': size === 'sm',
          'h-10 px-4': size === 'md',
          'h-12 px-6 text-lg': size === 'lg'
        },
        className
      )}
      {...props}
    >
      {children}
    </button>
  )
}

// packages/ui/src/index.ts
export { Button } from './Button'
export { Input } from './Input'
export { Card } from './Card'
export * from './types'
```

### Shared Configuration
```javascript
// packages/eslint-config-custom/index.js
module.exports = {
  extends: [
    'next',
    'turbo',
    'prettier'
  ],
  rules: {
    '@next/next/no-html-link-for-pages': 'off',
    'react/jsx-key': 'off'
  },
  parserOptions: {
    babelOptions: {
      presets: [require.resolve('next/babel')]
    }
  }
}

// packages/tsconfig/base.json
{
  "compilerOptions": {
    "target": "es2017",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}

// packages/tsconfig/nextjs.json
{
  "extends": "./base.json",
  "compilerOptions": {
    "plugins": [{ "name": "next" }]
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### Cross-Package Dependencies
```typescript
// apps/web/src/pages/index.tsx
import { Button, Card } from 'ui'
import { formatDate } from 'utils'
import { api } from 'api-client'

export default function HomePage() {
  const [data, setData] = React.useState(null)

  React.useEffect(() => {
    api.getData().then(setData)
  }, [])

  return (
    <div className="p-8">
      <Card>
        <h1 className="text-2xl font-bold mb-4">
          Welcome to Turbo Monorepo
        </h1>
        <p className="mb-4">
          Last updated: {formatDate(new Date())}
        </p>
        <Button onClick={() => window.location.reload()}>
          Refresh Data
        </Button>
      </Card>
    </div>
  )
}

// packages/utils/src/index.ts
export function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(date)
}

export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout
  return (...args: Parameters<T>) => {
    clearTimeout(timeout)
    timeout = setTimeout(() => func(...args), wait)
  }
}

// packages/api-client/src/index.ts
const BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'

export const api = {
  async getData() {
    const response = await fetch(`${BASE_URL}/data`)
    return response.json()
  },

  async postData(data: any) {
    const response = await fetch(`${BASE_URL}/data`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
    return response.json()
  }
}
```

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
  TURBO_TEAM: ${{ secrets.TURBO_TEAM }}

jobs:
  build:
    name: Build and Test
    timeout-minutes: 15
    runs-on: ubuntu-latest

    steps:
      - name: Check out code
        uses: actions/checkout@v4
        with:
          fetch-depth: 2

      - name: Setup Node.js environment
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npx turbo build

      - name: Test
        run: npx turbo test

      - name: Lint
        run: npx turbo lint

      - name: Type check
        run: npx turbo typecheck

  deploy:
    name: Deploy
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Setup Node.js environment
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npx turbo build --filter=web

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          working-directory: ./apps/web
```

### Docker Integration
```dockerfile
# Dockerfile
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the project
RUN npx turbo build --filter=web

# Production image, copy all files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/apps/web/public ./apps/web/public

# Automatically leverage output traces to reduce image size
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static

USER nextjs

EXPOSE 3000
ENV PORT 3000

CMD ["node", "apps/web/server.js"]
```

## Performance Optimization

### Build Performance
```json
// turbo.json - Optimized for performance
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "!.next/cache/**"],
      "env": ["NODE_ENV", "NEXT_PUBLIC_*"],
      "inputs": [
        "src/**",
        "pages/**",
        "components/**",
        "public/**",
        "package.json",
        "next.config.js",
        "tsconfig.json"
      ]
    },
    "test": {
      "dependsOn": ["^build"],
      "outputs": ["coverage/**"],
      "inputs": [
        "src/**/*.{ts,tsx,js,jsx}",
        "test/**/*.{ts,tsx,js,jsx}",
        "jest.config.js",
        "package.json"
      ]
    }
  }
}
```

```bash
# Performance monitoring
turbo build --profile
turbo build --summarize

# Parallel execution optimization
turbo build --parallel --concurrency=10

# Cache optimization
turbo prune --scope=changed-package
turbo build --filter="...[HEAD^]"  # Build only changed packages
```

### Memory Management
```bash
# Increase Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=4096"
turbo build

# Or in package.json
{
  "scripts": {
    "build": "NODE_OPTIONS='--max-old-space-size=4096' turbo build"
  }
}

# Monitor memory usage
turbo build --profile | grep memory
```

## Common Issues & Solutions

### Cache Issues
**Problem**: Builds not using cache when they should
**Solution**: Check cache configuration and inputs
```json
// Ensure proper inputs and outputs
{
  "pipeline": {
    "build": {
      "inputs": [
        "src/**",
        "package.json",
        "tsconfig.json"
      ],
      "outputs": ["dist/**"]
    }
  }
}
```

### Dependency Issues
**Problem**: Package dependencies not resolving correctly
**Solution**: Use workspace protocol and proper dependency management
```json
// Use workspace protocol
{
  "dependencies": {
    "ui": "workspace:*",
    "utils": "workspace:^1.0.0"
  }
}
```

### Performance Issues
**Problem**: Slow builds in large monorepos
**Solution**: Optimize task dependencies and use filtering
```bash
# Build only affected packages
turbo build --filter="[HEAD^]"

# Use concurrency limits
turbo build --concurrency=4

# Optimize with remote caching
turbo login && turbo link
```

## Useful Resources
- **Official Documentation**: https://turbo.build/repo
- **API Reference**: https://turbo.build/repo/docs/reference/configuration
- **Examples**: https://github.com/vercel/turbo/tree/main/examples
- **Discord Community**: https://turbo.build/discord
- **Migration Guide**: https://turbo.build/repo/docs/getting-started/existing-monorepo

## Tool-Specific Guidelines

### Best Practices
- Define clear task dependencies in pipeline configuration
- Use descriptive task names that match package.json scripts
- Leverage remote caching for team collaboration
- Implement proper filtering for CI/CD optimization
- Keep turbo.json configuration simple and focused

### Performance Tips
- Use specific inputs and outputs for better cache hits
- Implement incremental builds with dependency tracking
- Optimize concurrent task execution
- Use remote caching to share artifacts across team
- Profile builds to identify bottlenecks

### Security Considerations
- Secure remote cache tokens and authentication
- Validate environment variables before caching
- Use proper access controls for monorepo packages
- Implement security scanning in CI pipeline
- Keep dependencies updated across all packages

## Version Compatibility
- **Node.js**: 16+ (18+ recommended)
- **npm**: 7+ (comes with Node.js 16+)
- **Yarn**: 1.22+ (Classic) or 3.0+ (Berry)
- **pnpm**: 7.0+

## Troubleshooting

### Debug Mode
```bash
# Enable verbose logging
turbo build --verbosity=2

# Show dependency graph
turbo build --graph

# Dry run to see what would execute
turbo build --dry-run

# Show task summary
turbo build --summarize
```

### Common Error Messages
- **Error**: `Could not find package.json`
  **Cause**: Not in a monorepo root or invalid workspace configuration
  **Solution**: Ensure you're in the root directory with proper package.json

- **Error**: `Task not found in pipeline`
  **Cause**: Task defined in package.json but not in turbo.json pipeline
  **Solution**: Add task to turbo.json pipeline configuration

- **Error**: `Cache miss`
  **Cause**: Inputs changed or cache configuration incorrect
  **Solution**: Review inputs/outputs configuration in turbo.json
````
