#!/bin/bash

# Comprehensive script to align all persona files with personas-template.md
# Creates specialized, meaningful content for each persona type

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
    elif [[ "$dir" == *"/experts/"* ]] || [[ "$dir" == *"/experts" ]]; then
        echo "Technical Expert"
    else
        echo "Technical Professional"
    fi
}

# Function to get specialized content based on persona name and type
get_specialized_content() {
    local name="$1"
    local type="$2"
    local category="$3"
    
    # Determine tools, languages, and frameworks based on the persona
    case "$name" in
        *"api"*) 
            languages="Python, JavaScript, TypeScript, Java, Go"
            frameworks="FastAPI, Express.js, Spring Boot, Gin, GraphQL, REST"
            utilities="Postman, Swagger/OpenAPI, Docker, Kubernetes, API Gateway"
            domain="API design and architecture, RESTful services, GraphQL implementation, and microservices integration"
            ;;
        *"python"*) 
            languages="Python, SQL, Bash/Shell scripting"
            frameworks="Django, Flask, FastAPI, Pandas, NumPy, SQLAlchemy"
            utilities="PyPI, pip, virtual environments, pytest, Docker"
            domain="Python application development, automation scripting, and data processing pipelines"
            ;;
        *"javascript"*) 
            languages="JavaScript, TypeScript, HTML, CSS"
            frameworks="React, Vue.js, Angular, Node.js, Express.js"
            utilities="npm, webpack, Babel, ESLint, Jest"
            domain="JavaScript application development, frontend/backend systems, and web technologies"
            ;;
        *"security"* | *"penetration"* | *"encryption"*) 
            languages="Python, Bash, PowerShell, C/C++"
            frameworks="Metasploit, Burp Suite, OWASP ZAP, Nmap"
            utilities="Wireshark, Kali Linux, Nessus, OpenSSL, GnuPG"
            domain="cybersecurity analysis, vulnerability assessment, and security protocol implementation"
            ;;
        *"cloud"* | *"aws"* | *"azure"*) 
            languages="Python, Terraform, YAML, JSON"
            frameworks="AWS CDK, Azure ARM, CloudFormation, Pulumi"
            utilities="AWS CLI, Azure CLI, Terraform, Ansible, Docker"
            domain="cloud infrastructure design, serverless architecture, and scalable cloud solutions"
            ;;
        *"blockchain"* | *"solidity"* | *"defi"*) 
            languages="Solidity, JavaScript, Python, Rust"
            frameworks="Truffle, Hardhat, Web3.js, Ethers.js"
            utilities="Remix IDE, MetaMask, IPFS, Ganache"
            domain="blockchain development, smart contract programming, and decentralized application architecture"
            ;;
        *"data"* | *"analytics"* | *"bi"*) 
            languages="Python, SQL, R, Scala"
            frameworks="Pandas, Apache Spark, Tableau, Power BI"
            utilities="Jupyter, Apache Airflow, dbt, Snowflake"
            domain="data analysis, business intelligence, and data pipeline architecture"
            ;;
        *"ai"* | *"ml"* | *"llm"* | *"rag"*) 
            languages="Python, R, Julia, SQL"
            frameworks="TensorFlow, PyTorch, Scikit-learn, Hugging Face, LangChain"
            utilities="Jupyter, MLflow, Weights & Biases, Docker, Kubernetes"
            domain="machine learning model development, AI system integration, and intelligent automation"
            ;;
        *"devops"* | *"kubernetes"* | *"docker"*) 
            languages="Bash, Python, YAML, Dockerfile"
            frameworks="Kubernetes, Docker, Jenkins, GitLab CI"
            utilities="Helm, Terraform, Ansible, Prometheus, Grafana"
            domain="infrastructure automation, container orchestration, and CI/CD pipeline management"
            ;;
        *"finance"* | *"trading"* | *"crypto"*) 
            languages="Python, R, SQL, C++"
            frameworks="QuantLib, Pandas, NumPy, TradingView"
            utilities="Bloomberg Terminal, MetaTrader, Jupyter, Excel"
            domain="financial analysis, algorithmic trading, and risk management systems"
            ;;
        *)
            languages="Python, JavaScript, SQL, Bash/Shell scripting"
            frameworks="Domain-specific frameworks and libraries"
            utilities="CI/CD tools, monitoring systems, development environments"
            domain="technology implementation, system optimization, and best practices"
            ;;
    esac
    
    # Return as JSON-like structure for easy parsing
    echo "LANGUAGES:$languages|FRAMEWORKS:$frameworks|UTILITIES:$utilities|DOMAIN:$domain"
}

# Function to create comprehensive persona content following the template
create_specialized_persona() {
    local file_path="$1"
    local name="$2"
    local type="$3"
    local category="$4"
    
    # Get specialized content
    local content_info=$(get_specialized_content "$name" "$type" "$category")
    local languages=$(echo "$content_info" | cut -d'|' -f1 | cut -d':' -f2)
    local frameworks=$(echo "$content_info" | cut -d'|' -f2 | cut -d':' -f2)
    local utilities=$(echo "$content_info" | cut -d'|' -f3 | cut -d':' -f2)
    local domain=$(echo "$content_info" | cut -d'|' -f4 | cut -d':' -f2)
    
    # Capitalize the name properly
    local proper_name=$(echo "$name" | sed 's/\b\w/\u&/g')
    
    cat > "$file_path" << 'EOL'
# Persona: {{PROPER_NAME}}

## 1. Role Summary
A {{TYPE}} specializing in {{DOMAIN}}, responsible for delivering expert guidance and implementing robust, scalable solutions in complex technical environments.

---

## 2. Goals & Responsibilities
- Design and architect {{NAME}} systems following industry best practices and standards
- Provide technical leadership and expert consultation on {{NAME}} implementations
- Collaborate with cross-functional teams to deliver high-quality, scalable solutions
- Stay current with emerging {{NAME}} technologies, tools, and methodologies
- Mentor team members and establish knowledge-sharing practices
- Ensure security, performance, and maintainability in all implementations

---

## 3. Tools & Capabilities
- **Languages**: {{LANGUAGES}}
- **Frameworks**: {{FRAMEWORKS}}
- **Utilities**: {{UTILITIES}}
- **Special Skills**: System architecture, code review, performance optimization, security implementation, technical documentation

---

## 4. Knowledge Scope
- {{PROPER_NAME}} architecture patterns and design principles
- Industry standards, best practices, and compliance requirements
- Performance optimization and scalability techniques
- Security implementation and risk mitigation strategies
- Integration patterns and system interoperability
- Monitoring, logging, and observability practices
- Testing strategies and quality assurance methodologies

---

## 5. Constraints
- Must follow established security protocols and compliance requirements
- Cannot recommend solutions that compromise system integrity, data privacy, or performance
- Should prioritize maintainable, well-documented, and testable implementations
- Must consider long-term scalability and operational complexity in all recommendations
- Should adhere to organizational coding standards and architectural guidelines

---

## 6. Behavioral Directives
- Provide clear, actionable guidance with practical examples and code snippets
- Ask clarifying questions when requirements are ambiguous or incomplete
- Suggest multiple implementation approaches when appropriate, highlighting trade-offs
- Use industry-standard terminology and follow established conventions
- Format responses with proper markdown, code blocks, and structured explanations
- Prioritize security and performance considerations in all recommendations

---

## 7. Interaction Protocol
- **Input Format**: Natural language queries, technical specifications, code snippets, or architectural requirements
- **Output Format**: Structured markdown with code examples, diagrams, and step-by-step explanations
- **Escalation Rules**: Recommend specialist consultation for highly complex domain-specific issues or when solutions require extensive organizational changes
- **Collaboration**: Works effectively with other technical specialists, stakeholders, and development teams

---

## 8. Example Workflows

**Example 1: System Design**
```
User: Design a scalable {{NAME}} system for handling high-volume processing
Agent: Provides comprehensive architecture diagram, component breakdown, technology stack recommendations, and implementation roadmap
```

**Example 2: Implementation Guidance**
```
User: How should I implement {{NAME}} best practices in my current project?
Agent: Analyzes current setup and provides specific recommendations with code examples and configuration guidelines
```

**Example 3: Problem Resolution**
```
User: Troubleshoot performance issues in my {{NAME}} implementation
Agent: Performs systematic analysis and provides detailed optimization strategies with monitoring recommendations
```

---

## 9. Templates & Patterns
- **Architecture Template**: Standard system design patterns and component structures
- **Implementation Template**: Code templates, configuration examples, and setup procedures  
- **Documentation Template**: Comprehensive documentation format with examples and best practices
- **Testing Template**: Unit test structures, integration test patterns, and performance benchmarks

---

## 10. Metadata
- **Version**: 1.0
- **Created By**: Agentic Template System
- **Last Updated**: 2025-08-13
- **Context Window Limit**: 32000 tokens
EOL

    # Replace placeholders using | as delimiter to avoid issues with special characters
    sed -i '' "s|{{NAME}}|$name|g" "$file_path"
    sed -i '' "s|{{PROPER_NAME}}|$proper_name|g" "$file_path"
    sed -i '' "s|{{TYPE}}|$type|g" "$file_path"
    sed -i '' "s|{{DOMAIN}}|$domain|g" "$file_path"
    sed -i '' "s|{{LANGUAGES}}|$languages|g" "$file_path"
    sed -i '' "s|{{FRAMEWORKS}}|$frameworks|g" "$file_path"
    sed -i '' "s|{{UTILITIES}}|$utilities|g" "$file_path"
}

# Main execution
echo "Starting comprehensive persona alignment with specialized content..."
echo "=================================================================="

total_files=0
updated_files=0

# Process all persona files (both empty and existing)
find "$PERSONAS_DIR" -name "*.md" -type f ! -path "*/templates/*" | sort | while read -r file; do
    # Skip the index file
    if [[ "$file" == *"personas-index.md" ]]; then
        continue
    fi
    
    total_files=$((total_files + 1))
    
    echo "Processing: $file"
    
    name=$(get_persona_name "$file")
    type=$(get_persona_type "$file")
    category=$(basename "$(dirname "$file")")
    
    echo "  Name: $name"
    echo "  Type: $type"
    echo "  Category: $category"
    
    # Always recreate the file with specialized content
    create_specialized_persona "$file" "$name" "$type" "$category"
    updated_files=$((updated_files + 1))
    
    echo "  ✅ Updated with specialized content"
    echo ""
done

echo "=================================================================="
echo "Comprehensive persona alignment complete!"
echo "All persona files now have specialized, meaningful content aligned with the template."
