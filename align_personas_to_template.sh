#!/bin/bash

# Script to align all persona files with the personas-template.md structure
# This script will update both empty files and existing files to match the template

PERSONAS_DIR="/Users/blainemcdonnell/git/agentic-template/common/personas"

# Function to extract persona name from filename
get_persona_name() {
    local file_path="$1"
    local filename=$(basename "$file_path" .md)
    echo "$filename" | sed 's/[-_]/ /g'
}

# Function to determine persona type from directory path
get_persona_type() {
    local file_path="$1"
    local dir=$(dirname "$file_path")
    
    if [[ "$dir" == *"/ai/"* ]] || [[ "$dir" == *"/ai" ]]; then
        echo "AI and ML Specialist"
    elif [[ "$dir" == *"/security/"* ]] || [[ "$dir" == *"/security" ]]; then
        echo "Security Professional" 
    elif [[ "$dir" == *"/developer/"* ]] || [[ "$dir" == *"/developer" ]]; then
        echo "Software Developer"
    elif [[ "$dir" == *"/architect/"* ]] || [[ "$dir" == *"/architect" ]]; then
        echo "System Architect"
    elif [[ "$dir" == *"/devops/"* ]] || [[ "$dir" == *"/devops" ]]; then
        echo "DevOps Engineer"
    elif [[ "$dir" == *"/blockchain/"* ]] || [[ "$dir" == *"/blockchain" ]]; then
        echo "Blockchain Specialist"
    elif [[ "$dir" == *"/marketing/"* ]] || [[ "$dir" == *"/marketing" ]]; then
        echo "Marketing Professional"
    elif [[ "$dir" == *"/finance/"* ]] || [[ "$dir" == *"/finance" ]]; then
        echo "Financial Professional"
    elif [[ "$dir" == *"/analyst/"* ]] || [[ "$dir" == *"/analyst" ]]; then
        echo "Data Analyst"
    elif [[ "$dir" == *"/administrator/"* ]] || [[ "$dir" == *"/administrator" ]]; then
        echo "System Administrator"
    elif [[ "$dir" == *"/design/"* ]] || [[ "$dir" == *"/design" ]]; then
        echo "Design Professional"
    elif [[ "$dir" == *"/project/"* ]] || [[ "$dir" == *"/project" ]]; then
        echo "Project Management Professional"
    elif [[ "$dir" == *"/technical-writer/"* ]] || [[ "$dir" == *"/technical-writer" ]]; then
        echo "Technical Writer"
    elif [[ "$dir" == *"/engineer/"* ]] || [[ "$dir" == *"/engineer" ]]; then
        echo "Technical Engineer"
    else
        echo "Technical Professional"
    fi
}

# Function to get specialized domain based on persona name and type
get_specialized_domain() {
    local name="$1"
    local type="$2"
    
    case "$type" in
        "AI and ML Specialist")
            if [[ "$name" == *"langchain"* ]]; then
                echo "LangChain framework development, chain orchestration, and LLM application architecture"
            elif [[ "$name" == *"llm"* ]]; then
                echo "Large Language Model development, fine-tuning, and deployment"
            elif [[ "$name" == *"computer vision"* ]]; then
                echo "computer vision systems, image processing, and visual AI applications"
            elif [[ "$name" == *"rag"* ]]; then
                echo "Retrieval-Augmented Generation systems, vector databases, and knowledge retrieval"
            else
                echo "machine learning systems, AI model development, and intelligent automation"
            fi
            ;;
        "Security Professional")
            if [[ "$name" == *"penetration"* ]]; then
                echo "penetration testing, vulnerability assessment, and security auditing"
            elif [[ "$name" == *"incident"* ]]; then
                echo "incident response, threat mitigation, and security operations"
            else
                echo "cybersecurity, threat detection, and security architecture"
            fi
            ;;
        "Software Developer")
            if [[ "$name" == *"javascript"* ]]; then
                echo "JavaScript development, web applications, and frontend/backend systems"
            elif [[ "$name" == *"python"* ]]; then
                echo "Python development, automation, and scalable application architecture"
            else
                echo "software development, application architecture, and coding best practices"
            fi
            ;;
        "Financial Professional")
            if [[ "$name" == *"trader"* ]]; then
                echo "trading strategies, market analysis, and financial risk management"
            elif [[ "$name" == *"analyst"* ]]; then
                echo "financial analysis, market research, and investment evaluation"
            else
                echo "financial systems, investment strategies, and market analysis"
            fi
            ;;
        *)
            echo "technology implementation, system optimization, and best practices"
            ;;
    esac
}

# Function to create comprehensive persona content following the template
create_comprehensive_persona() {
    local file_path="$1"
    local name="$2"
    local type="$3"
    local domain="$4"
    
    cat > "$file_path" << 'EOL'
# Persona: {{NAME}}

## 1. Role Summary
A {{TYPE}} specializing in {{DOMAIN}}, responsible for implementing best practices and delivering high-quality solutions across complex technical environments.

---

## 2. Goals & Responsibilities
- Design and implement {{NAME}} systems following industry best practices
- Provide expert guidance on {{NAME}} architecture and optimization
- Collaborate with cross-functional teams to deliver scalable solutions
- Stay current with emerging {{NAME}} technologies and methodologies
- Mentor team members and share knowledge across the organization

---

## 3. Tools & Capabilities
- **Languages**: Python, JavaScript, SQL, Bash/Shell scripting
- **Frameworks**: Domain-specific frameworks and libraries for {{NAME}}
- **Utilities**: CI/CD tools, monitoring systems, development environments
- **Special Skills**: Code review, system architecture, performance optimization, testing strategies

---

## 4. Knowledge Scope
- {{NAME}} architecture patterns and design principles
- Industry standards and compliance requirements
- Performance optimization and scalability techniques
- Security best practices and risk mitigation
- Integration patterns and API design
- Monitoring, logging, and observability practices

---

## 5. Constraints
- Must follow established security protocols and compliance requirements
- Cannot recommend solutions that compromise system integrity or data privacy
- Should prioritize maintainable and well-documented implementations
- Must consider scalability and performance implications in all recommendations

---

## 6. Behavioral Directives
- Provide clear, actionable guidance with practical examples
- Ask clarifying questions when requirements are ambiguous
- Suggest multiple approaches when appropriate, highlighting trade-offs
- Use industry-standard terminology and best practices
- Format responses with proper markdown and code blocks for clarity

---

## 7. Interaction Protocol
- **Input Format**: Natural language queries, technical specifications, or code snippets
- **Output Format**: Structured markdown with code examples and explanations
- **Escalation Rules**: Recommend specialist consultation for highly complex or domain-specific issues
- **Collaboration**: Works effectively with other technical specialists and stakeholders

---

## 8. Example Workflows

**Example 1: System Design**
```
User: Design a {{NAME}} system for handling high-volume data processing
Agent: Provides architecture diagram, component breakdown, and implementation strategy
```

**Example 2: Optimization**
```
User: Optimize existing {{NAME}} system for better performance
Agent: Analyzes current implementation and suggests specific improvements with metrics
```

---

## 9. Templates & Patterns
- **Implementation Template**: Standard project structure and configuration patterns
- **Documentation Template**: Comprehensive documentation format with examples
- **Testing Template**: Unit test structure, integration tests, and performance benchmarks

---

## 10. Metadata
- **Version**: 1.0
- **Created By**: Agentic Template
- **Last Updated**: 2025-08-13
- **Context Window Limit**: 32000 tokens
EOL

    # Replace placeholders using | as delimiter to avoid issues with special characters
    sed -i '' "s|{{NAME}}|$name|g" "$file_path"
    sed -i '' "s|{{TYPE}}|$type|g" "$file_path"
    sed -i '' "s|{{DOMAIN}}|$domain|g" "$file_path"
}

# Main execution
echo "Starting comprehensive persona alignment with template..."
echo "========================================================"

total_files=0
updated_files=0

# Process all persona files (both empty and existing)
find "$PERSONAS_DIR" -name "*.md" -type f ! -path "*/templates/*" | while read -r file; do
    total_files=$((total_files + 1))
    
    echo "Processing: $file"
    
    name=$(get_persona_name "$file")
    type=$(get_persona_type "$file")
    domain=$(get_specialized_domain "$name" "$type")
    
    echo "  Name: $name"
    echo "  Type: $type" 
    echo "  Domain: $domain"
    
    # Always recreate the file with the comprehensive template
    create_comprehensive_persona "$file" "$name" "$type" "$domain"
    updated_files=$((updated_files + 1))
    
    echo "  ✅ Updated to template standard"
    echo ""
done

echo "========================================================"
echo "Persona alignment complete!"
echo "All persona files now follow the comprehensive template structure."
