````instructions
# Docker Compose Instructions

## Tool Overview
- **Tool Name**: Docker Compose
- **Version**: v2.20+ (Compose V2 integrated with Docker Desktop)
- **Category**: Containerization & Orchestration
- **Purpose**: Define and run multi-container Docker applications with YAML configuration
- **Prerequisites**: Docker Engine 20.10+, Docker Desktop, or standalone Docker Compose

## Installation & Setup
### Docker Compose V2 (Recommended)
```bash
# Verify Docker Compose is installed (comes with Docker Desktop)
docker compose version

# Linux standalone installation
curl -SL https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Alternative: Install via pip
pip install docker-compose

# macOS with Homebrew (if not using Docker Desktop)
brew install docker-compose
```

### Project Integration
```bash
# Initialize Compose in existing project
touch docker-compose.yml
touch .dockerignore
touch .env

# Create development override
touch docker-compose.override.yml

# Create production configuration
touch docker-compose.prod.yml
```

## Configuration

### Basic docker-compose.yml
```yaml
version: '3.8'

services:
  # Web application service
  web:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://user:password@db:5432/myapp
    volumes:
      - .:/app
      - /app/node_modules  # Anonymous volume for node_modules
    depends_on:
      - db
      - redis
    networks:
      - app-network

  # Database service
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks:
      - app-network

  # Redis cache service
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - app-network

# Named volumes
volumes:
  postgres_data:
  redis_data:

# Custom networks
networks:
  app-network:
    driver: bridge
```

### Environment Variables (.env)
```bash
# Application settings
NODE_ENV=development
PORT=3000
JWT_SECRET=your-secret-key

# Database configuration
POSTGRES_DB=myapp
POSTGRES_USER=user
POSTGRES_PASSWORD=password
DATABASE_URL=postgresql://user:password@localhost:5432/myapp

# Redis configuration
REDIS_URL=redis://localhost:6379

# External service APIs
API_KEY=your-api-key
EXTERNAL_SERVICE_URL=https://api.example.com
```

### Development Override (docker-compose.override.yml)
```yaml
version: '3.8'

services:
  web:
    environment:
      - DEBUG=true
      - LOG_LEVEL=debug
    volumes:
      - .:/app:cached  # Cached mount for better performance on macOS
    command: npm run dev  # Development command with hot reload

  db:
    ports:
      - "5432:5432"  # Expose database port for local development

  # Development tools
  adminer:
    image: adminer:latest
    ports:
      - "8080:8080"
    depends_on:
      - db
    networks:
      - app-network
```

### Production Configuration (docker-compose.prod.yml)
```yaml
version: '3.8'

services:
  web:
    build:
      context: .
      target: production  # Multi-stage build target
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=info
    restart: unless-stopped
    # Remove volume mounts and dev dependencies

  db:
    # Remove port exposure for security
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    secrets:
      - db_password
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - web
    restart: unless-stopped

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

## Core Features

### Service Management
- **Purpose**: Define and orchestrate multiple containers as a single application
- **Usage**: Manage complex applications with databases, caches, and multiple services
- **Example**:
```bash
# Start all services
docker compose up -d

# Start specific services
docker compose up web db

# Scale services
docker compose up --scale web=3

# Stop all services
docker compose down

# Stop and remove volumes
docker compose down -v
```

### Building and Rebuilding
- **Purpose**: Build custom images and handle code changes
- **Usage**: Development workflow with automatic rebuilds
- **Example**:
```bash
# Build all services
docker compose build

# Build specific service
docker compose build web

# Build without cache
docker compose build --no-cache

# Rebuild and restart
docker compose up --build
```

### Logs and Monitoring
- **Purpose**: Debug and monitor multi-container applications
- **Usage**: View logs from all or specific services
- **Example**:
```bash
# View logs from all services
docker compose logs

# Follow logs in real-time
docker compose logs -f

# View logs from specific service
docker compose logs web

# View last 100 lines
docker compose logs --tail=100
```

## Common Commands
```bash
# Lifecycle management
docker compose up                    # Start services in foreground
docker compose up -d                 # Start services in background
docker compose down                  # Stop and remove containers
docker compose restart              # Restart all services
docker compose stop                 # Stop services without removing

# Service management
docker compose ps                    # List running services
docker compose top                  # Display running processes
docker compose exec web bash        # Execute command in running container
docker compose run web npm test     # Run one-off command

# Building and images
docker compose build                 # Build all services
docker compose pull                 # Pull latest images
docker compose push                 # Push images to registry

# Configuration and debugging
docker compose config               # Validate and view configuration
docker compose version             # Show version information
docker compose images              # List images used by services

# Logs and monitoring
docker compose logs -f web          # Follow logs for specific service
docker compose events              # Show real-time events
```

## Advanced Patterns

### Multi-Stage Development Setup
```yaml
version: '3.8'

services:
  # Development environment
  web-dev:
    build:
      context: .
      target: development
    profiles: ["dev"]
    volumes:
      - .:/app
    environment:
      - NODE_ENV=development

  # Testing environment
  web-test:
    build:
      context: .
      target: test
    profiles: ["test"]
    command: npm test
    environment:
      - NODE_ENV=test

  # Production environment
  web-prod:
    build:
      context: .
      target: production
    profiles: ["prod"]
    environment:
      - NODE_ENV=production
```

### Health Checks and Dependencies
```yaml
version: '3.8'

services:
  web:
    build: .
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  db:
    image: postgres:15-alpine
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### Secrets and Security
```yaml
version: '3.8'

services:
  web:
    image: myapp:latest
    secrets:
      - db_password
      - api_key
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
      - API_KEY_FILE=/run/secrets/api_key

  db:
    image: postgres:15-alpine
    secrets:
      - db_password
    environment:
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    external: true
    name: myapp_api_key
```

### Service Discovery and Networking
```yaml
version: '3.8'

services:
  web:
    build: .
    networks:
      - frontend
      - backend
    ports:
      - "3000:3000"

  api:
    build: ./api
    networks:
      - backend
    # Internal communication only, no exposed ports

  db:
    image: postgres:15-alpine
    networks:
      - backend
    # Database only accessible from backend network

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # No external access
```

## Development Workflow

### Local Development Setup
```bash
# Clone project
git clone https://github.com/user/project.git
cd project

# Copy environment template
cp .env.example .env

# Start development environment
docker compose up -d

# View logs
docker compose logs -f

# Execute commands in running containers
docker compose exec web npm install
docker compose exec web npm run migrate

# Run tests
docker compose run --rm web npm test

# Clean up
docker compose down -v
```

### Hot Reload Development
```yaml
# docker-compose.override.yml for development
version: '3.8'

services:
  web:
    volumes:
      - .:/app:cached
      - /app/node_modules  # Prevent overwriting node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true  # For file watching on some systems
    command: npm run dev

  # Development database with persistent data
  db:
    volumes:
      - ./dev-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"  # Expose for database tools
```

### Testing Pipeline
```yaml
# docker-compose.test.yml
version: '3.8'

services:
  test:
    build:
      context: .
      target: test
    environment:
      - NODE_ENV=test
      - DATABASE_URL=postgresql://test:test@test-db:5432/testdb
    depends_on:
      - test-db
    command: npm run test:ci

  test-db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
    tmpfs:
      - /var/lib/postgresql/data  # Use tmpfs for faster tests

  integration-test:
    build: .
    environment:
      - NODE_ENV=test
    depends_on:
      - test
    command: npm run test:integration
```

## Common Issues & Solutions

### Port Conflicts
**Problem**: Port already in use error
**Solution**: Check for conflicting services or change ports
```bash
# Find what's using the port
lsof -i :3000

# Kill process using port
kill -9 $(lsof -t -i:3000)

# Or change port in docker-compose.yml
ports:
  - "3001:3000"  # Map different host port
```

### Volume Permission Issues
**Problem**: Permission denied when accessing mounted volumes
**Solution**: Fix user permissions or use proper volume configuration
```yaml
services:
  web:
    user: "${UID}:${GID}"  # Use host user ID
    volumes:
      - .:/app:cached
```

```bash
# Set UID and GID in .env
echo "UID=$(id -u)" >> .env
echo "GID=$(id -g)" >> .env
```

### Database Connection Issues
**Problem**: Cannot connect to database
**Solution**: Ensure services are on same network and use service names
```yaml
# Use service name as hostname
environment:
  - DATABASE_URL=postgresql://user:pass@db:5432/myapp

# Ensure services are on same network
networks:
  - app-network
```

### Memory and Resource Issues
**Problem**: Containers running out of memory
**Solution**: Set resource limits and optimize images
```yaml
services:
  web:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
        reservations:
          memory: 256M
          cpus: '0.25'
```

## Performance Optimization

### Efficient Image Building
```dockerfile
# Multi-stage Dockerfile for smaller production images
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

FROM base AS dependencies
RUN npm ci --only=production

FROM base AS build
RUN npm ci
COPY . .
RUN npm run build

FROM base AS production
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package*.json ./
CMD ["npm", "start"]
```

### Volume Optimization
```yaml
services:
  web:
    volumes:
      # Use cached mount for better performance on macOS
      - .:/app:cached

      # Use delegated mount for write-heavy workloads
      - ./logs:/app/logs:delegated

      # Use anonymous volumes for dependency directories
      - /app/node_modules
      - /app/.next
```

### Network Optimization
```yaml
# Use custom networks for better isolation and performance
networks:
  frontend:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
```

## Integration with CI/CD

### GitHub Actions
```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build and test
        run: |
          docker compose -f docker-compose.test.yml build
          docker compose -f docker-compose.test.yml run --rm test

      - name: Cleanup
        if: always()
        run: docker compose -f docker-compose.test.yml down -v
```

### Production Deployment
```bash
# Deploy to production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Health check
docker compose ps
docker compose logs web

# Zero-downtime deployment
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d --no-deps web
```

## Useful Resources
- **Official Documentation**: https://docs.docker.com/compose/
- **Compose File Reference**: https://docs.docker.com/compose/compose-file/
- **Best Practices**: https://docs.docker.com/develop/best-practices/
- **Awesome Compose Examples**: https://github.com/docker/awesome-compose
- **Docker Compose Migration**: https://docs.docker.com/compose/migrate/

## Version Compatibility
- **Docker Compose**: v2.20+ (recommended), v1.x deprecated
- **Docker Engine**: 20.10+ required for Compose v2
- **Compose File Format**: v3.8+ recommended, v2.x legacy
- **Platform Support**: Linux, macOS, Windows with WSL2

## Troubleshooting

### Debug Mode
```bash
# Enable verbose output
docker compose --verbose up

# Check configuration
docker compose config

# Validate file syntax
docker compose -f docker-compose.yml config

# Debug networking
docker compose exec web ping db
```

### Common Error Messages
- **Error**: `yaml: line X: found character that cannot start any token`
  **Cause**: YAML syntax error, usually indentation issues
  **Solution**: Validate YAML syntax and fix indentation

- **Error**: `network myapp_default not found`
  **Cause**: Network was removed or not created
  **Solution**: Run `docker compose up` to recreate networks

- **Error**: `pull access denied`
  **Cause**: Trying to pull private image without authentication
  **Solution**: Run `docker login` or use public images for development
````

1. **Setup**: [Initial setup steps]
2. **Development**: [How to use during development]
3. **Testing**: [Integration with testing process]
4. **Pre-commit**: [Pre-commit hooks or checks]
5. **CI/CD**: [Continuous integration usage]

### Automation Scripts

```bash
# Package.json scripts (if applicable)
{
  "scripts": {
    "[script-name]": "[tool] [command]",
    "[workflow-script]": "[tool] [workflow-command]"
  }
}
```

### Git Hooks Integration

```bash
# Pre-commit hook example
#!/bin/sh
[tool] [validation-command]
```

## Best Practices

### Configuration Best Practices

- [Best practice 1 with explanation]
- [Best practice 2 with explanation]
- [Best practice 3 with explanation]

### Usage Patterns

- [Pattern 1: When and how to use]
- [Pattern 2: When and how to use]
- [Pattern 3: When and how to use]

### Performance Optimization

- [Optimization tip 1]
- [Optimization tip 2]
- [Optimization tip 3]

## Common Use Cases

### [Use Case 1]

**Scenario**: [Description of the scenario]
**Implementation**:

```bash
[tool] [specific-commands]
```

**Expected Result**: [What should happen]

### [Use Case 2]

**Scenario**: [Description of the scenario]
**Implementation**:

```bash
[tool] [specific-commands]
```

**Expected Result**: [What should happen]

### [Use Case 3]

**Scenario**: [Description of the scenario]
**Implementation**:

```bash
[tool] [specific-commands]
```

**Expected Result**: [What should happen]

## Integration with Other Tools

### [Related Tool 1]

- **Integration Purpose**: [Why integrate]
- **Setup**: [How to configure integration]
- **Usage**: [How they work together]

### [Related Tool 2]

- **Integration Purpose**: [Why integrate]
- **Setup**: [How to configure integration]
- **Usage**: [How they work together]

## Troubleshooting

### Common Issues

#### [Issue 1]

**Problem**: [Description of the problem]
**Symptoms**: [How to identify this issue]
**Solution**: [Step-by-step fix]

#### [Issue 2]

**Problem**: [Description of the problem]
**Symptoms**: [How to identify this issue]
**Solution**: [Step-by-step fix]

#### [Issue 3]

**Problem**: [Description of the problem]
**Symptoms**: [How to identify this issue]
**Solution**: [Step-by-step fix]

### Debug Mode

```bash
# Enable verbose/debug output
[tool] --verbose [command]
[tool] --debug [command]

# Log analysis
[tool] logs
[tool] status --detailed
```

### Performance Issues

- [Performance issue 1 and solution]
- [Performance issue 2 and solution]
- [Performance issue 3 and solution]

## Security Considerations

### Security Best Practices

- [Security practice 1]
- [Security practice 2]
- [Security practice 3]

### Sensitive Data Handling

- [How the tool handles secrets]
- [Configuration for secure usage]
- [Best practices for credentials]

### Network Security

- [Network-related security considerations]
- [Proxy and firewall configurations]
- [Certificate and SSL handling]

## Advanced Configuration

### Custom Plugins/Extensions

```[config-format]
# Plugin configuration
[plugin-config-example]
```

### Scripting and Automation

```bash
# Advanced scripting examples
[automation-script-example]
```

### Performance Tuning

```[config-format]
# Performance optimization settings
[performance-config-example]
```

## Version Management

### Version Compatibility

- **Tool Version**: [Version requirements]
- **Node.js**: [If applicable]
- **Python**: [If applicable]
- **OS Support**: [Supported operating systems]

### Migration Guides

- **From [Old Version]**: [Migration steps]
- **Breaking Changes**: [Important changes to note]
- **Deprecation Notices**: [Features being deprecated]

## Useful Resources

- **Official Documentation**: [URL]
- **GitHub Repository**: [URL]
- **Community Resources**: [URLs]
- **Tutorials**: [URLs]
- **Plugin/Extension Registry**: [URL]
- **Stack Overflow Tag**: [Tag name]

## Tool-Specific Guidelines

### Code Organization

- [How the tool affects code structure]
- [File organization recommendations]
- [Naming conventions]

### Maintenance

- [Regular maintenance tasks]
- [Update procedures]
- [Cleanup and optimization]

## Examples and Templates

### Basic Example

```[language]
// Example usage in context
[practical-example]
```

### Advanced Example

```[language]
// Advanced usage pattern
[advanced-example]
```

### Template Files

```[format]
# Template configuration
[template-example]
```

## AI Assistant Guidelines

When helping with [Tool Name]:

1. **Always suggest the most current stable version**
2. **Provide working configuration examples**
3. **Include error handling in scripts**
4. **Mention security implications when relevant**
5. **Suggest integration with development workflow**
6. **Provide troubleshooting steps for common issues**
7. **Include performance considerations**
8. **Reference official documentation**

### Code Generation Rules

- Generate configurations that follow tool best practices
- Include comments explaining important settings
- Provide multiple options when appropriate
- Include validation and error checking
- Follow the project's existing patterns and conventions

```

```
