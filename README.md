# Agentic Template

A comprehensive template system for AI-powered development workflows supporting multiple AI coding assistants including Claude Code, GitHub Copilot, Windsurf, and Cursor.

## Overview

This template provides a unified structure for AI agent development workflows with:

- **Shared Common Resources**: Instructions, personas, and prompts that work across all AI tools
- **AI-Specific Configurations**: Tailored setups for each AI coding assistant
- **Project Management Structure**: Epic/Story/Task/Bug hierarchy for organized development
- **Template Provisioning**: Easy setup and configuration for your preferred AI tools

## Structure

```
├── common/                     # Shared resources across all AI tools
│   ├── instructions/          # Language, framework, and tool instructions
│   ├── personas/             # Role-based development personas
│   ├── prompts/              # Reusable prompts and templates
│   └── docs/                 # Common documentation
├── templates/                 # AI-specific configurations
│   ├── claude-code/          # Claude Code specific files
│   ├── copilot/              # GitHub Copilot specific files
│   ├── windsurf/             # Windsurf specific files
│   └── cursor/               # Cursor specific files
├── project/                   # Project management and planning
│   ├── plan/                 # Epic/Story/Task structure
│   │   └── {Epic}/
│   │       ├── {Epic}.md     # Epic documentation
│   │       └── {Story}/
│   │           ├── {Story}.md # Story documentation
│   │           ├── {Task}.md  # Task files
│   │           └── {Bug}.md   # Bug files
│   ├── REQUIREMENTS.md       # Project requirements
│   ├── PLAN.md              # Project plan
│   └── ...                  # Other project files
└── provision.py             # Template provisioning script
```

## Quick Start

1. **List available templates:**
   ```bash
   ./provision.py list
   ```

2. **Provision a project type:**
   ```bash
   # Create a Docusaurus documentation site
   ./provision.py provision --project-type docusaurus --project-name my-docs --project-title "My Documentation"
   
   # Create an MkDocs documentation site
   ./provision.py provision --project-type mkdocs --project-name my-docs --project-title "My Documentation"
   
   # Create a minimal project
   ./provision.py provision --project-type minimal --project-name my-project
   ```

3. **Provision AI tool configuration:**
   ```bash
   ./provision.py provision --ai-tool claude-code
   ./provision.py provision --ai-tool copilot
   ./provision.py provision --ai-tool windsurf
   ./provision.py provision --ai-tool cursor
   ```

4. **Provision both project type and AI tool:**
   ```bash
   ./provision.py provision --project-type docusaurus --ai-tool claude-code --project-name my-docs
   ```

5. **Clean up provisioned files:**
   ```bash
   ./provision.py clean --ai-tool claude-code
   ```

## Project Types

The template system supports multiple project types for different use cases:

### Docusaurus Documentation Site
- **Technology**: React-based with TypeScript
- **Features**: MDX support, versioning, search, i18n
- **Generated Files**: Complete Docusaurus project with customizable themes
- **Use Cases**: API documentation, technical guides, product documentation
- **Commands**:
  ```bash
  npm install    # Install dependencies
  npm start      # Development server
  npm run build  # Production build
  ```

### MkDocs Documentation Site  
- **Technology**: Python-based with Material theme
- **Features**: Markdown support, search, navigation, themes
- **Generated Files**: Complete MkDocs project with Material theme
- **Use Cases**: User guides, technical documentation, project wikis
- **Commands**:
  ```bash
  pip install -r requirements.txt  # Install dependencies
  mkdocs serve                     # Development server
  mkdocs build                     # Production build
  ```

### Minimal Project
- **Technology**: Framework-agnostic
- **Features**: Basic project structure with essential files
- **Generated Files**: README, .gitignore, basic project skeleton
- **Use Cases**: Starting point for any type of project
- **Customization**: Add your own build tools and dependencies

## AI Tool Support

### Claude Code
- Configuration: `.claude/` directory
- Instructions: Template-specific commands and settings
- Integration: Automatic reference to common resources

### GitHub Copilot
- Configuration: `.github/copilot-instructions.md` and `.copilot/` directory
- Features: Skillsets, chat modes, and custom prompts
- Integration: Context-aware suggestions using shared personas

### Windsurf
- Configuration: `.windsurf/config.json`
- Features: Auto-completion and code generation
- Integration: Template-based workflow support

### Cursor
- Configuration: `.cursor/config.json`
- Features: AI chat and code completion
- Integration: Contextual help with shared instructions

## Project Planning

The template includes a structured approach to project management:

### Epic Structure
- **Location**: `project/plan/{Epic}/`
- **Documentation**: `{Epic}.md` contains epic details
- **Stories**: Subdirectories for each story

### Story Structure
- **Location**: `project/plan/{Epic}/{Story}/`
- **Documentation**: `{Story}.md` contains story details
- **Tasks**: Individual task files `{Task}.md`
- **Bugs**: Individual bug files `{Bug}.md`

### Example
```
project/plan/
├── template-system/
│   ├── template-system.md
│   ├── story-001/
│   │   ├── story-001.md
│   │   ├── task-001-consolidate-instructions.md
│   │   └── task-002-consolidate-personas.md
│   └── story-002/
│       └── story-002.md
```

## Common Resources

### Instructions
Language and framework-specific guidance:
- **Languages**: C, C++, C#, Go, Java, JavaScript, Python, Rust, Swift, etc.
- **Frameworks**: Node.js, Express, Azure Functions, Terraform, etc.
- **Tools**: CMS, Infrastructure as Code, development workflows

### Personas
Role-based development personas:
- Senior developers (Python, Go, Java, etc.)
- Architects (AWS, Azure, Solution, etc.)
- Specialists (Security, DevOps, Data Engineer, etc.)
- Domain experts (Blockchain, AI/ML, Game Development, etc.)

### Prompts
Reusable prompts for:
- AI development tasks
- PRD creation
- Task execution and generation
- Code review and analysis

## Customization

### Adding New AI Tools
1. Create a new directory in `templates/{new-tool}/`
2. Add configuration files specific to the tool
3. Update `map.yaml` with copy instructions
4. Test with `./provision.py provision --tool new-tool`

### Extending Common Resources
- Add new instructions to `common/instructions/`
- Create new personas in `common/personas/`
- Add reusable prompts to `common/prompts/`

### Project Structure
- Create new epics in `project/plan/{Epic}/`
- Follow the Epic/Story/Task/Bug hierarchy
- Use markdown for documentation

## Contributing

Contributions are welcome! Please see individual persona and instruction files for specific guidelines.

## Acknowledgments

Thanks to the contributions of:
- [Awesome Copilot Instructions](https://github.com/Code-and-Sorts/awesome-copilot-instructions)

## License

[Add your license information here]