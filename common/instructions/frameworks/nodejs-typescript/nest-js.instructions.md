---
applyTo: 'nestjs, nest.js, nest'
agentMode: 'framework-specific'
instructionType: 'guide'
guidelines: 'Focus on NestJS 10+ with TypeScript, decorators, and enterprise patterns'
---

# NestJS Framework Instructions for AI Agents

## When to Use NestJS

Use NestJS when you need:

- Large-scale enterprise applications with complex business logic
- Strong TypeScript support with decorators and metadata
- Built-in dependency injection and modular architecture
- GraphQL, WebSocket, and microservices support
- Automatic API documentation with Swagger
- Enterprise-grade security and authentication
- Team scaling with consistent architecture patterns
- Integration with databases and external services

## When to Avoid NestJS

Consider alternatives when:

- Building simple REST APIs (use Express.js, Fastify)
- Need minimal overhead and fast startup (use Express.js)
- Working with functional programming paradigms
- Building serverless functions (use lightweight frameworks)
- Team unfamiliar with decorators and dependency injection
- Prototyping or small applications (NestJS is opinionated)

## Framework Overview

- **Framework**: NestJS 10.x
- **Type**: Progressive Node.js framework for building scalable server-side applications
- **Architecture**: Modular with dependency injection, inspired by Angular
- **Language**: TypeScript (primary), JavaScript (supported)
- **Use Cases**: Enterprise APIs, microservices, GraphQL servers, real-time applications

## Installation & Setup

### ✅ Recommended: NestJS CLI with TypeScript

```bash
# Install NestJS CLI globally
npm install -g @nestjs/cli

# Create new project
nest new my-app

# Navigate to project
cd my-app

# Start development server
npm run start:dev
```

### ✅ Alternative: Manual Setup

```bash
# Initialize project
npm init -y

# Install core dependencies
npm install @nestjs/core @nestjs/common @nestjs/platform-express
npm install reflect-metadata rxjs

# Install TypeScript dependencies
npm install -D @nestjs/cli typescript @types/node
```

### ✅ Production Dependencies

```bash
# Database and ORM
npm install @nestjs/typeorm typeorm mysql2
# or
npm install @nestjs/mongoose mongoose

# Validation and security
npm install class-validator class-transformer
npm install @nestjs/passport passport passport-jwt
npm install bcryptjs @types/bcryptjs

# Configuration and utilities
npm install @nestjs/config @nestjs/swagger
```

### AI Agent Decision Tree

- **For enterprise APIs**: NestJS + TypeORM + PostgreSQL
- **For microservices**: NestJS + Redis + message queues
- **For GraphQL**: NestJS + GraphQL + Apollo
- **For real-time**: NestJS + WebSockets + Socket.io

### [Pattern Name]

```[language]
// Example implementation
[code example]
```

### [Pattern Name]

```[language]
// Example implementation
[code example]
```

## Configuration

### [Config File 1]

```[format]
# Configuration options
[example configuration]
```

### [Config File 2]

```[format]
# Configuration options
[example configuration]
```

## Essential Commands

```bash
# Development
[dev server command]

# Testing
[test command]

# Building
[build command]

# Linting
[lint command]

# Package management
[install dependencies]
[add new package]
[update packages]
```

## Common Issues & Solutions

### [Issue 1]

**Problem**: [Description of the problem]
**Solution**: [How to solve it]

### [Issue 2]

**Problem**: [Description of the problem]
**Solution**: [How to solve it]

## Performance Optimization

- [Optimization technique 1]
- [Optimization technique 2]
- [Optimization technique 3]

## Security Considerations

- [Security best practice 1]
- [Security best practice 2]
- [Security best practice 3]

## Useful Resources

- **Official Documentation**: [URL]
- **Community Resources**: [URLs]
- **Learning Materials**: [URLs]
- **Tools & Extensions**: [List of helpful tools]

## Framework-Specific Guidelines

### Code Style

- [Coding conventions specific to this framework]
- [Naming conventions]
- [File organization patterns]

### Architecture Patterns

- [Recommended architectural patterns]
- [State management approaches]
- [Component/module organization]

## Integration Points

### [External Service/Tool 1]

- **Purpose**: [What it integrates with]
- **Setup**: [How to configure]
- **Usage**: [Implementation examples]

### [External Service/Tool 2]

- **Purpose**: [What it integrates with]
- **Setup**: [How to configure]
- **Usage**: [Implementation examples]

## Version Compatibility

- **Node.js**: [Supported versions]
- **Dependencies**: [Key dependency versions]
- **Browser Support**: [If applicable]
- **OS Support**: [If applicable]

## Troubleshooting

### Debug Mode

```bash
[debug commands]
```

### Log Analysis

- [Where to find logs]
- [How to interpret common error messages]

### Common Error Messages

- **Error**: `[error message]`
  **Cause**: [Why this happens]
  **Solution**: [How to fix]
