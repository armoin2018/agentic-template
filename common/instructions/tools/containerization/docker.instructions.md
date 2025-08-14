````instructions
# Docker Instructions

## Tool Overview
- **Tool Name**: Docker
- **Version**: 20.10+ (supports Docker Desktop and Docker Engine)
- **Category**: Containerization
- **Purpose**: Package applications into portable containers for consistent deployment across environments
- **Prerequisites**: Linux, macOS, or Windows with WSL2

## Installation & Setup
### Package Manager Installation
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# macOS (Homebrew)
brew install --cask docker

# Windows
# Download Docker Desktop from docker.com

# Verify installation
docker --version
docker-compose --version
```

### Project Integration
```bash
# Initialize Dockerfile in project
touch Dockerfile
touch .dockerignore
touch docker-compose.yml
```

## Configuration
### Dockerfile
```dockerfile
# Example Dockerfile for Node.js application
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

USER nextjs

# Start application
CMD ["npm", "start"]
```

### .dockerignore
```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.nyc_output
coverage
.vscode
.idea
```

### docker-compose.yml
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    volumes:
      - ./logs:/app/logs
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

## Core Features
### Container Management
- **Purpose**: Create, run, and manage application containers
- **Usage**: Isolate applications with their dependencies
- **Example**:
```bash
docker run -d -p 3000:3000 --name myapp myapp:latest
```

### Image Building
- **Purpose**: Create reusable container images
- **Usage**: Package applications for deployment
- **Example**:
```bash
docker build -t myapp:latest .
docker build -t myapp:v1.2.3 --build-arg NODE_ENV=production .
```

### Multi-stage Builds
- **Purpose**: Optimize image size and security
- **Usage**: Separate build and runtime environments
- **Example**:
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Runtime stage
FROM node:18-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

## Common Commands
```bash
# Essential daily commands
docker ps                              # List running containers
docker images                          # List available images
docker logs <container-id>             # View container logs
docker exec -it <container-id> /bin/sh # Access container shell

# Advanced operations
docker system prune                    # Clean up unused resources
docker build --no-cache -t app:latest . # Build without cache
docker run --rm -it app:latest /bin/sh  # Run temporary interactive container
```

## Workflow Integration
### Development Workflow
1. **Setup**: Create Dockerfile and docker-compose.yml
2. **Development**: Use docker-compose for local development
3. **Testing**: Run tests in containers for consistency
4. **Pre-commit**: Build and test images before committing
5. **CI/CD**: Build and push images in CI pipeline

### Automation Scripts
```json
{
  "scripts": {
    "docker:build": "docker build -t myapp:latest .",
    "docker:run": "docker-compose up",
    "docker:test": "docker-compose -f docker-compose.test.yml up --abort-on-container-exit",
    "docker:clean": "docker system prune -f"
  }
}
```

### Git Hooks Integration
```bash
# Pre-commit hook example
#!/bin/sh
docker build -t myapp:test . && docker run --rm myapp:test npm test
```

## Best Practices
### Configuration Best Practices
- Use multi-stage builds to reduce image size
- Run containers as non-root users for security
- Use specific image tags instead of 'latest' in production
- Keep images small by minimizing layers and removing unnecessary files

### Usage Patterns
- Use .dockerignore to exclude unnecessary files from build context
- Leverage Docker layer caching for faster builds
- Use environment variables for configuration instead of hardcoding values

### Performance Optimization
- Use Alpine Linux base images for smaller size
- Combine RUN commands to reduce layers
- Use BuildKit for improved build performance

## Common Use Cases
### Web Application Deployment
**Scenario**: Deploy a Node.js web application with database
**Implementation**:
```bash
docker-compose up -d
docker-compose logs -f app
```
**Expected Result**: Application running on specified port with database connection

### Development Environment
**Scenario**: Consistent development environment across team
**Implementation**:
```bash
docker-compose -f docker-compose.dev.yml up
docker-compose exec app npm run dev
```
**Expected Result**: Hot-reloaded development server with all dependencies

### Testing Pipeline
**Scenario**: Run tests in isolated environment
**Implementation**:
```bash
docker build -t myapp:test --target test .
docker run --rm myapp:test
```
**Expected Result**: All tests pass in clean environment

## Integration with Other Tools
### Kubernetes
- **Integration Purpose**: Deploy Docker images to Kubernetes clusters
- **Setup**: Create Kubernetes manifests referencing Docker images
- **Usage**: Use kubectl to deploy containerized applications

### CI/CD Pipelines
- **Integration Purpose**: Automate building and deployment of images
- **Setup**: Configure pipeline to build, test, and push images
- **Usage**: Trigger builds on code changes

## Troubleshooting
### Common Issues
#### Container Won't Start
**Problem**: Container exits immediately after starting
**Symptoms**: Container shows "Exited (1)" status
**Solution**: Check logs with `docker logs <container>` and fix application errors

#### Port Already in Use
**Problem**: Cannot bind to port (port already allocated)
**Symptoms**: Error message about port binding
**Solution**: Stop conflicting services or use different port mapping

#### Out of Disk Space
**Problem**: No space left on device
**Symptoms**: Build failures or container start failures
**Solution**: Run `docker system prune -a` to clean up unused resources

### Debug Mode
```bash
# Enable verbose/debug output
docker build --progress=plain --no-cache .
docker run --rm -it --entrypoint=/bin/sh myapp:latest

# Log analysis
docker logs --details <container>
docker inspect <container>
```

### Performance Issues
- Monitor resource usage with `docker stats`
- Limit container resources with `--memory` and `--cpus` flags
- Use health checks to monitor container health

## Security Considerations
### Security Best Practices
- Never store secrets in images or environment variables
- Use official base images from trusted sources
- Regularly update base images for security patches

### Sensitive Data Handling
- Use Docker secrets or external secret management
- Mount sensitive files as volumes instead of copying into images
- Use multi-stage builds to avoid including build-time secrets

### Network Security
- Use custom networks instead of default bridge
- Limit exposed ports to only what's necessary
- Use reverse proxies for external access

## Advanced Configuration
### Docker Buildx
```bash
# Multi-platform builds
docker buildx create --name multiarch
docker buildx use multiarch
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```

### Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

### Resource Limits
```yaml
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
```

## Version Management
### Version Compatibility
- **Docker Engine**: 20.10+
- **Docker Compose**: 2.0+
- **OS Support**: Linux, macOS, Windows 10/11

### Migration Guides
- **From Docker Compose v1**: Update to v2 syntax and commands
- **Breaking Changes**: Review changelog for version-specific changes
- **Deprecation Notices**: Monitor for deprecated features

## Useful Resources
- **Official Documentation**: https://docs.docker.com/
- **Docker Hub**: https://hub.docker.com/
- **Best Practices Guide**: https://docs.docker.com/develop/dev-best-practices/
- **Security Guidelines**: https://docs.docker.com/engine/security/
- **Community Forum**: https://forums.docker.com/

## AI Assistant Guidelines
When helping with Docker:

1. **Always suggest the most current stable version**
2. **Provide working Dockerfile and docker-compose examples**
3. **Include security considerations in configurations**
4. **Mention resource limits and optimization opportunities**
5. **Suggest multi-stage builds for production images**
6. **Provide troubleshooting steps for common issues**
7. **Include health checks and monitoring guidance**
8. **Reference official documentation and best practices**

### Code Generation Rules
- Generate Dockerfiles that follow best practices
- Include comments explaining important steps
- Use specific image tags instead of 'latest'
- Include security measures like non-root users
- Follow the project's existing patterns and conventions
- Provide both development and production configurations
````
