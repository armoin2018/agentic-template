````instructions
# Docker Containerization Instructions

## Tool Overview
- **Tool Name**: Docker
- **Version**: 24.0+ (stable), 25.0+ (latest with enhanced features)
- **Category**: Containerization
- **Purpose**: Platform for developing, shipping, and running applications in containers
- **Prerequisites**: Linux/macOS/Windows 10+ with WSL2, virtualization support

## Installation & Setup
### Package Manager Installation
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# CentOS/RHEL/Fedora
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# macOS (Homebrew)
brew install --cask docker

# macOS (Official installer)
# Download Docker Desktop from https://docker.com

# Windows 10/11
# Download Docker Desktop from https://docker.com
# Requires WSL2 or Hyper-V

# Verify installation
docker --version
docker-compose --version
docker info
```

### Initial Configuration
```bash
# Configure Docker daemon
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Docker service
sudo systemctl restart docker
sudo systemctl enable docker

# Test installation
docker run hello-world
```

### Project Integration
```bash
# Initialize Docker files in project
touch Dockerfile
touch .dockerignore
touch docker-compose.yml
touch docker-compose.override.yml

# Create Docker-related directories
mkdir -p docker/
mkdir -p .docker/
mkdir -p scripts/docker/
```

## Core Features

### Dockerfile Creation
- **Purpose**: Define how to build container images
- **Usage**: Specify base image, dependencies, and application setup
- **Example**:

```dockerfile
# Node.js application Dockerfile
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy package files
COPY package*.json ./
COPY yarn.lock* ./

# Install dependencies
FROM base AS dependencies
RUN apk add --no-cache libc6-compat
RUN npm ci --only=production && npm cache clean --force

# Development stage
FROM base AS development
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
USER nextjs
CMD ["npm", "run", "dev"]

# Build stage
FROM base AS builder
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Production stage
FROM base AS production
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public

# Copy configuration files
COPY --chown=nextjs:nodejs package.json ./

USER nextjs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["npm", "start"]
```

### Multi-language Dockerfiles
```dockerfile
# Python application
FROM python:3.11-slim AS base

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN useradd --create-home --shell /bin/bash app
USER app

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
```

```dockerfile
# Go application
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Production stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]
```

```dockerfile
# Java/Spring Boot application
FROM openjdk:17-jdk-slim AS builder

WORKDIR /app

# Copy Maven files
COPY pom.xml .
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Production stage
FROM openjdk:17-jre-slim

WORKDIR /app

# Copy the jar file
COPY --from=builder /app/target/*.jar app.jar

# Create non-root user
RUN useradd --create-home --shell /bin/bash spring
USER spring

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Container Operations
- **Purpose**: Manage container lifecycle and operations
- **Usage**: Build, run, stop, and maintain containers
- **Example**:

```bash
# Build images
docker build -t myapp:latest .
docker build -t myapp:v1.0 --target production .
docker build --no-cache -t myapp:latest .

# Run containers
docker run -d --name myapp -p 3000:3000 myapp:latest
docker run -it --rm myapp:latest /bin/sh
docker run -d --name myapp \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -v $(pwd)/logs:/app/logs \
  myapp:latest

# Container management
docker ps                          # List running containers
docker ps -a                       # List all containers
docker stop myapp                  # Stop container
docker start myapp                 # Start container
docker restart myapp               # Restart container
docker rm myapp                    # Remove container
docker logs myapp                  # View logs
docker logs -f myapp               # Follow logs
docker exec -it myapp /bin/sh      # Execute commands in container

# Image management
docker images                      # List images
docker rmi myapp:latest           # Remove image
docker pull nginx:latest         # Pull image
docker push myapp:latest         # Push image
docker tag myapp:latest myapp:v1.0  # Tag image
```

### Docker Compose Configuration
- **Purpose**: Define and run multi-container applications
- **Usage**: Orchestrate services, networks, and volumes
- **Example**:

```yaml
# docker-compose.yml - Complete application stack
version: '3.8'

services:
  # Web application
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    container_name: myapp
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      - DB_PORT=5432
      - DB_NAME=myapp
      - DB_USER=postgres
      - DB_PASSWORD=password
      - REDIS_URL=redis://redis:6379
    volumes:
      - ./logs:/app/logs
      - /app/node_modules  # Anonymous volume for node_modules
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    restart: unless-stopped
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  # Database
  db:
    image: postgres:15-alpine
    container_name: myapp-db
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./docker/postgres/init:/docker-entrypoint-initdb.d
    ports:
      - "5432:5432"
    restart: unless-stopped
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis cache
  redis:
    image: redis:7-alpine
    container_name: myapp-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
      - ./docker/redis/redis.conf:/usr/local/etc/redis/redis.conf
    command: redis-server /usr/local/etc/redis/redis.conf
    restart: unless-stopped
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3

  # Nginx reverse proxy
  nginx:
    image: nginx:alpine
    container_name: myapp-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/default.conf:/etc/nginx/conf.d/default.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped
    networks:
      - app-network

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  app-network:
    driver: bridge
```

### Development Override Configuration
```yaml
# docker-compose.override.yml - Development overrides
version: '3.8'

services:
  app:
    build:
      target: development
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=*
    ports:
      - "3000:3000"
      - "9229:9229"  # Node.js debugging port
    command: npm run dev

  db:
    ports:
      - "5432:5432"
    volumes:
      - ./docker/postgres/dev-data:/docker-entrypoint-initdb.d

  redis:
    ports:
      - "6379:6379"
```

## Advanced Features

### Multi-stage Builds
- **Purpose**: Optimize image size and separate build/runtime concerns
- **Usage**: Use multiple FROM statements for different stages
- **Example**:

```dockerfile
# Multi-stage React application build
FROM node:18-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS build-dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM build-dependencies AS build
COPY . .
RUN npm run build

FROM nginx:alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Docker Networking
- **Purpose**: Enable communication between containers
- **Usage**: Create and manage networks for container isolation
- **Example**:

```bash
# Network management
docker network create app-network
docker network ls
docker network inspect app-network
docker network rm app-network

# Connect containers to networks
docker run -d --name app1 --network app-network myapp:latest
docker run -d --name app2 --network app-network myapp:latest

# Custom network with specific subnet
docker network create --driver bridge \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  custom-network
```

```yaml
# docker-compose.yml - Custom networks
version: '3.8'

services:
  frontend:
    build: ./frontend
    networks:
      - frontend-network
      - backend-network

  backend:
    build: ./backend
    networks:
      - backend-network
      - database-network

  database:
    image: postgres:15
    networks:
      - database-network

networks:
  frontend-network:
    driver: bridge
  backend-network:
    driver: bridge
  database-network:
    driver: bridge
    internal: true  # No external access
```

### Volume Management
- **Purpose**: Persist data and share files between containers and host
- **Usage**: Store databases, configuration, and application data
- **Example**:

```bash
# Volume operations
docker volume create myapp-data
docker volume ls
docker volume inspect myapp-data
docker volume rm myapp-data

# Bind mounts vs volumes
docker run -v /host/path:/container/path myapp:latest     # Bind mount
docker run -v myapp-data:/container/path myapp:latest     # Named volume
docker run --tmpfs /tmp myapp:latest                      # Temporary filesystem
```

```yaml
# docker-compose.yml - Volume configurations
version: '3.8'

services:
  app:
    image: myapp:latest
    volumes:
      # Named volume
      - app-data:/app/data
      # Bind mount
      - ./config:/app/config:ro
      # Anonymous volume
      - /app/cache
      # Temporary filesystem
      - type: tmpfs
        target: /tmp
        tmpfs:
          size: 100M

volumes:
  app-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /opt/myapp/data
```

### Security Configuration
- **Purpose**: Secure container runtime and limit access
- **Usage**: Apply security policies and access controls
- **Example**:

```dockerfile
# Security-focused Dockerfile
FROM node:18-alpine

# Create non-root user early
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodeuser -u 1001 -G nodejs

# Set ownership and permissions
WORKDIR /app
COPY --chown=nodeuser:nodejs package*.json ./

# Install dependencies as root, then switch to non-root
RUN npm ci --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/*

# Copy application code with proper ownership
COPY --chown=nodeuser:nodejs . .

# Switch to non-root user
USER nodeuser

# Use specific port and protocol
EXPOSE 3000/tcp

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Use exec form for better signal handling
CMD ["node", "index.js"]
```

```yaml
# docker-compose.yml - Security configurations
version: '3.8'

services:
  app:
    image: myapp:latest
    user: "1001:1001"
    read_only: true
    tmpfs:
      - /tmp
      - /app/cache
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    security_opt:
      - no-new-privileges:true
      - apparmor:docker-default
    sysctls:
      - net.ipv4.ip_unprivileged_port_start=0
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
      memlock:
        soft: -1
        hard: -1
```

## Docker Ignore Configuration

### Comprehensive .dockerignore
```bash
# .dockerignore - Optimize build context
# Development files
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build outputs
build/
dist/
out/
.next/
.nuxt/
.vuepress/dist/

# Testing
coverage/
.nyc_output/
test-results/
playwright-report/

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~
.sublime-*

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Version control
.git/
.gitignore
.gitattributes
.gitmodules

# Docker files
Dockerfile*
docker-compose*.yml
.dockerignore

# Documentation
*.md
docs/
LICENSE
CHANGELOG.md

# Configuration files
.eslintrc*
.prettierrc*
tsconfig.json
jsconfig.json
webpack.config.js
rollup.config.js

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
.tmp/

# Package manager files
package-lock.json
yarn.lock
pnpm-lock.yaml

# Application specific
uploads/
storage/
cache/
```

## Common Commands & Operations

### Docker CLI Commands
```bash
# Container lifecycle
docker create --name myapp myapp:latest     # Create container
docker start myapp                          # Start container
docker stop myapp                           # Stop container
docker restart myapp                        # Restart container
docker pause myapp                          # Pause container
docker unpause myapp                        # Unpause container
docker kill myapp                           # Kill container
docker rm myapp                             # Remove container

# Image operations
docker build -t myapp:latest .              # Build image
docker pull nginx:latest                    # Pull image
docker push myapp:latest                    # Push image
docker tag myapp:latest myapp:v1.0         # Tag image
docker rmi myapp:latest                     # Remove image
docker save myapp:latest > myapp.tar       # Save image
docker load < myapp.tar                    # Load image

# System operations
docker system df                            # Show disk usage
docker system prune                         # Clean up unused resources
docker system prune -a                     # Clean up all unused resources
docker system info                         # Show system information

# Debugging and inspection
docker exec -it myapp /bin/sh              # Interactive shell
docker logs myapp                          # Show logs
docker logs -f --tail 100 myapp           # Follow logs with tail
docker inspect myapp                       # Inspect container
docker stats myapp                         # Show resource usage
docker top myapp                           # Show running processes
```

### Docker Compose Commands
```bash
# Service management
docker-compose up                           # Start services
docker-compose up -d                        # Start in background
docker-compose up --build                   # Build and start
docker-compose down                         # Stop and remove
docker-compose down -v                      # Stop and remove volumes
docker-compose restart                      # Restart services
docker-compose stop                         # Stop services
docker-compose start                        # Start stopped services

# Service operations
docker-compose build                        # Build services
docker-compose build --no-cache            # Build without cache
docker-compose pull                         # Pull service images
docker-compose push                         # Push service images

# Logs and debugging
docker-compose logs                         # Show all logs
docker-compose logs -f app                 # Follow app logs
docker-compose exec app /bin/sh           # Execute in service
docker-compose ps                          # Show service status
docker-compose top                         # Show running processes

# Configuration
docker-compose config                       # Validate and view config
docker-compose config --services          # List services
docker-compose config --volumes           # List volumes
```

## Performance Optimization

### Image Size Optimization
```dockerfile
# Optimized Node.js Dockerfile
FROM node:18-alpine AS base

# Install only production dependencies
FROM base AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Build stage
FROM base AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage - minimal image
FROM node:18-alpine AS production
RUN apk add --no-cache dumb-init
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package.json ./

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodeuser -u 1001 -G nodejs
USER nodeuser

EXPOSE 3000
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/index.js"]
```

### Build Cache Optimization
```dockerfile
# Layer caching optimization
FROM node:18-alpine

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./
RUN npm ci --only=production

# Copy source code last (changes frequently)
COPY . .

# Multi-stage with shared base
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

FROM base AS development
RUN npm ci
COPY . .
CMD ["npm", "run", "dev"]

FROM base AS production
RUN npm ci --only=production
COPY . .
CMD ["npm", "start"]
```

### Runtime Performance
```yaml
# docker-compose.yml - Performance tuning
version: '3.8'

services:
  app:
    image: myapp:latest
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
        reservations:
          memory: 256M
          cpus: '0.25'
    environment:
      - NODE_OPTIONS=--max-old-space-size=400
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Development Workflows

### Development Environment
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  app:
    build:
      context: .
      target: development
    volumes:
      - .:/app
      - /app/node_modules
      - /app/.next
    environment:
      - NODE_ENV=development
      - CHOKIDAR_USEPOLLING=true
    ports:
      - "3000:3000"
      - "9229:9229"  # Node.js debugging
    stdin_open: true
    tty: true

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp_dev
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
    ports:
      - "5432:5432"
    volumes:
      - dev_db_data:/var/lib/postgresql/data

volumes:
  dev_db_data:
```

### Testing Environment
```yaml
# docker-compose.test.yml
version: '3.8'

services:
  test:
    build:
      context: .
      target: test
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=test
      - CI=true
    command: npm test

  test-db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp_test
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
    tmpfs:
      - /var/lib/postgresql/data
```

### CI/CD Integration
```bash
#!/bin/bash
# scripts/docker-build.sh

set -e

# Build arguments
VERSION=${1:-latest}
ENVIRONMENT=${2:-production}

echo "Building Docker image for $ENVIRONMENT environment..."

# Build multi-stage image
docker build \
  --target $ENVIRONMENT \
  --build-arg VERSION=$VERSION \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  -t myapp:$VERSION \
  -t myapp:latest \
  .

# Run security scan
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/Library/Caches:/root/.cache/ \
  aquasec/trivy:latest image myapp:$VERSION

# Push to registry
if [ "$CI" = "true" ]; then
  docker push myapp:$VERSION
  docker push myapp:latest
fi

echo "Build completed successfully!"
```

## Security Best Practices

### Dockerfile Security
```dockerfile
# Security-hardened Dockerfile
FROM node:18-alpine@sha256:specific-hash AS base

# Install security updates
RUN apk update && apk upgrade && apk add --no-cache dumb-init

# Create non-root user with specific UID/GID
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app

# Copy with specific ownership
COPY --chown=appuser:appgroup package*.json ./

# Install dependencies and clean up
RUN npm ci --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/* /var/cache/apk/*

# Copy application code
COPY --chown=appuser:appgroup . .

# Remove write permissions from application directory
RUN chmod -R 555 /app

# Switch to non-root user
USER appuser

# Use specific port
EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js || exit 1

# Use exec form and init system
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "index.js"]
```

### Secret Management
```yaml
# docker-compose.yml - Secret management
version: '3.8'

services:
  app:
    image: myapp:latest
    environment:
      - DB_HOST=db
    secrets:
      - db_password
      - api_key
    deploy:
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3

secrets:
  db_password:
    file: ./secrets/db_password.txt
  api_key:
    external: true
    external_name: myapp_api_key
```

### Runtime Security
```bash
# Run with security options
docker run -d \
  --name secure-app \
  --user 1001:1001 \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /app/cache \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  --security-opt no-new-privileges:true \
  --security-opt apparmor:docker-default \
  --ulimit nofile=1024:1024 \
  --memory 512m \
  --cpus 0.5 \
  myapp:latest
```

## Monitoring and Logging

### Health Checks
```dockerfile
# Application health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

```javascript
// healthcheck.js
const http = require('http');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/health',
  timeout: 5000
};

const req = http.request(options, (res) => {
  if (res.statusCode === 200) {
    process.exit(0);
  } else {
    process.exit(1);
  }
});

req.on('error', () => {
  process.exit(1);
});

req.on('timeout', () => {
  req.destroy();
  process.exit(1);
});

req.end();
```

### Logging Configuration
```yaml
# docker-compose.yml - Centralized logging
version: '3.8'

services:
  app:
    image: myapp:latest
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
        labels: "service=app,environment=production"

  nginx:
    image: nginx:alpine
    logging:
      driver: "syslog"
      options:
        syslog-address: "tcp://logserver:514"
        tag: "nginx"

  db:
    image: postgres:15
    logging:
      driver: "fluentd"
      options:
        fluentd-address: "localhost:24224"
        tag: "database"
```

## Troubleshooting

### Common Issues & Solutions

**Issue**: Container exits immediately
**Cause**: Application crashes or incorrect CMD/ENTRYPOINT
**Solution**:
```bash
# Debug the container
docker run -it --entrypoint /bin/sh myapp:latest

# Check logs
docker logs myapp

# Run with different command
docker run -it myapp:latest /bin/sh
```

**Issue**: Port binding fails
**Cause**: Port already in use or permission issues
**Solution**:
```bash
# Check port usage
netstat -tulpn | grep :3000
lsof -i :3000

# Use different port
docker run -p 3001:3000 myapp:latest

# Check Docker daemon
sudo systemctl status docker
```

**Issue**: Permission denied in container
**Cause**: User/group ID mismatch or file permissions
**Solution**:
```bash
# Check user in container
docker exec -it myapp id

# Fix ownership
docker exec -it myapp chown -R appuser:appgroup /app

# Run as specific user
docker run --user $(id -u):$(id -g) myapp:latest
```

**Issue**: Out of disk space
**Cause**: Too many images/containers or large volumes
**Solution**:
```bash
# Clean up Docker resources
docker system prune -a
docker volume prune
docker image prune -a

# Check disk usage
docker system df
du -sh /var/lib/docker/
```

### Debug Commands
```bash
# Container debugging
docker exec -it myapp /bin/sh          # Interactive shell
docker exec myapp ps aux               # Process list
docker exec myapp netstat -tulpn       # Network connections
docker exec myapp df -h                # Disk usage

# Image inspection
docker history myapp:latest            # Image layers
docker inspect myapp:latest            # Detailed information
docker dive myapp:latest              # Layer analysis (with dive tool)

# Network debugging
docker network inspect bridge          # Network details
docker exec myapp nslookup google.com  # DNS resolution
docker exec myapp ping db             # Connectivity test

# Performance monitoring
docker stats                          # Real-time stats
docker events                         # Docker events
docker exec myapp top                 # Process monitoring
```

## Best Practices

### Development Guidelines
- Use multi-stage builds to optimize image size
- Pin base image versions with specific tags or digests
- Run containers as non-root users
- Use .dockerignore to exclude unnecessary files
- Implement proper health checks
- Use init systems for proper signal handling

### Security Guidelines
- Regularly update base images and dependencies
- Scan images for vulnerabilities
- Use secrets management for sensitive data
- Apply resource limits and security constraints
- Enable security features like AppArmor/SELinux
- Follow principle of least privilege

### Performance Guidelines
- Optimize layer caching in Dockerfiles
- Use appropriate base images (alpine for smaller size)
- Implement proper logging strategies
- Monitor resource usage and set limits
- Use Docker BuildKit for faster builds
- Leverage multi-platform builds when needed

### Production Guidelines
- Use specific image tags in production
- Implement comprehensive monitoring and alerting
- Use orchestration platforms (Docker Swarm/Kubernetes)
- Implement proper backup strategies for volumes
- Use registry scanning and admission controllers
- Maintain disaster recovery procedures

## Useful Resources
- **Official Documentation**: https://docs.docker.com/
- **Docker Hub**: https://hub.docker.com/
- **Best Practices**: https://docs.docker.com/develop/dev-best-practices/
- **Security Guide**: https://docs.docker.com/engine/security/
- **Dockerfile Reference**: https://docs.docker.com/engine/reference/builder/
- **Compose File Reference**: https://docs.docker.com/compose/compose-file/

## Tool-Specific Guidelines

### Version Compatibility
- **Docker Engine**: 24.0+ for latest features and security updates
- **Docker Compose**: 2.20+ for modern compose file format
- **Container Runtime**: containerd 1.6+ or equivalent

### Integration Patterns
- Use with CI/CD pipelines for automated builds and deployments
- Integrate with orchestration platforms for production deployments
- Combine with monitoring tools for observability
- Use with service mesh for advanced networking
- Leverage with secrets management systems for security
````
