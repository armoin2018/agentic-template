#!/bin/bash

# Auto-populate empty persona files based on their path and filename
# Usage: ./populate_personas.sh

set -e

PERSONAS_DIR="/Users/blainemcdonnell/git/agentic-template/common/personas"
TEMPLATE_FILE="/Users/blainemcdonnell/git/agentic-template/common/personas/templates/personas-template.md"

# Function to extract persona name from filename
get_persona_name() {
    local file_path="$1"
    local filename=$(basename "$file_path" .md)
    
    # Convert hyphens and underscores to spaces and capitalize
    echo "$filename" | sed 's/[-_]/ /g' | sed 's/\b\w/\u&/g'
}

# Function to determine persona type from path
get_persona_type() {
    local file_path="$1"
    
    if [[ "$file_path" == *"/ai/"* ]]; then
        echo "AI/ML Specialist"
    elif [[ "$file_path" == *"/security/"* ]]; then
        echo "Security Professional"
    elif [[ "$file_path" == *"/developer/"* ]]; then
        echo "Software Developer"
    elif [[ "$file_path" == *"/architect/"* ]]; then
        echo "System Architect"
    elif [[ "$file_path" == *"/devops/"* ]]; then
        echo "DevOps Engineer"
    elif [[ "$file_path" == *"/blockchain/"* ]]; then
        echo "Blockchain Specialist"
    elif [[ "$file_path" == *"/marketing/"* ]]; then
        echo "Marketing Professional"
    elif [[ "$file_path" == *"/administrator/"* ]]; then
        echo "System Administrator"
    elif [[ "$file_path" == *"/analyst/"* ]]; then
        echo "Data Analyst"
    elif [[ "$file_path" == *"/design/"* ]]; then
        echo "Design Professional"
    elif [[ "$file_path" == *"/engineer/"* ]]; then
        echo "Software Engineer"
    elif [[ "$file_path" == *"/project/"* ]]; then
        echo "Project Management Professional"
    elif [[ "$file_path" == *"/technical-writer/"* ]]; then
        echo "Technical Writer"
    else
        echo "Professional"
    fi
}

# Function to generate role summary based on persona name and type
get_role_summary() {
    local name="$1"
    local type="$2"
    local file_path="$3"
    
    case "$type" in
        "AI/ML Specialist")
            echo "A specialized AI/ML professional focused on $name technologies, responsible for implementing, optimizing, and maintaining AI/ML systems and workflows."
            ;;
        "Security Professional")
            echo "A cybersecurity expert specializing in $name, responsible for protecting systems, identifying threats, and implementing security best practices."
            ;;
        "Software Developer")
            echo "A software developer specializing in $name development, responsible for building robust, scalable applications and maintaining code quality."
            ;;
        "System Architect")
            echo "A system architect specializing in $name architecture design, responsible for creating scalable, maintainable system designs and technical strategy."
            ;;
        "DevOps Engineer")
            echo "A DevOps engineer specializing in $name practices, responsible for automating deployment pipelines and maintaining infrastructure."
            ;;
        "Blockchain Specialist")
            echo "A blockchain specialist focused on $name technologies, responsible for developing decentralized applications and smart contract systems."
            ;;
        "Marketing Professional")
            echo "A marketing professional specializing in $name strategies, responsible for driving growth and optimizing marketing campaigns."
            ;;
        *)
            echo "A professional specializing in $name, responsible for delivering high-quality solutions and maintaining industry best practices."
            ;;
    esac
}

# Function to generate goals based on persona type
get_goals() {
    local type="$1"
    local name="$2"
    
    case "$type" in
        "AI/ML Specialist")
            echo "- Develop and optimize AI/ML models and pipelines
- Implement best practices for model deployment and monitoring
- Research and apply cutting-edge AI/ML techniques
- Collaborate with data teams to improve model performance"
            ;;
        "Security Professional")
            echo "- Identify and mitigate security vulnerabilities
- Implement comprehensive security policies and procedures
- Monitor and respond to security threats and incidents
- Ensure compliance with security standards and regulations"
            ;;
        "Software Developer")
            echo "- Write clean, maintainable, and efficient code
- Implement features according to specifications and requirements
- Participate in code reviews and maintain code quality standards
- Collaborate with cross-functional teams on project delivery"
            ;;
        "System Architect")
            echo "- Design scalable and maintainable system architectures
- Define technical standards and best practices
- Guide technical decisions and technology selection
- Ensure system performance, security, and reliability"
            ;;
        "DevOps Engineer")
            echo "- Automate deployment and infrastructure management processes
- Maintain and optimize CI/CD pipelines
- Monitor system performance and reliability
- Implement infrastructure as code and configuration management"
            ;;
        "Blockchain Specialist")
            echo "- Develop and audit smart contracts and DeFi protocols
- Design tokenomics and governance mechanisms
- Implement blockchain security best practices
- Stay current with blockchain technology developments"
            ;;
        "Marketing Professional")
            echo "- Develop and execute marketing strategies and campaigns
- Analyze marketing performance and optimize ROI
- Research market trends and customer behavior
- Collaborate with product and sales teams on go-to-market strategies"
            ;;
        *)
            echo "- Deliver high-quality professional services
- Maintain expertise in relevant technologies and practices
- Collaborate effectively with team members and stakeholders
- Contribute to project success and organizational goals"
            ;;
    esac
}

# Function to generate tools and capabilities
get_tools_capabilities() {
    local name="$1"
    local type="$2"
    local file_path="$3"
    
    if [[ "$file_path" == *"ai/"* ]]; then
        if [[ "$name" == *"LLM"* || "$name" == *"Language"* ]]; then
            echo "- **Languages**: Python, R
- **Frameworks**: Transformers, PyTorch, TensorFlow, LangChain
- **Utilities**: Hugging Face, OpenAI API, Weights & Biases
- **Special Skills**: Model fine-tuning, prompt engineering, evaluation metrics"
        elif [[ "$name" == *"Computer Vision"* || "$name" == *"OCR"* ]]; then
            echo "- **Languages**: Python, CUDA
- **Frameworks**: OpenCV, PyTorch, TensorFlow, YOLO
- **Utilities**: Albumentations, PIL, scikit-image
- **Special Skills**: Image processing, object detection, model optimization"
        else
            echo "- **Languages**: Python, R, SQL
- **Frameworks**: scikit-learn, PyTorch, TensorFlow
- **Utilities**: MLflow, Weights & Biases, Docker
- **Special Skills**: Model development, data preprocessing, performance optimization"
        fi
    elif [[ "$file_path" == *"security/"* ]]; then
        echo "- **Languages**: Python, Bash, PowerShell
- **Frameworks**: MITRE ATT&CK, NIST, ISO 27001
- **Utilities**: Wireshark, Metasploit, Burp Suite, SIEM tools
- **Special Skills**: Threat analysis, vulnerability assessment, incident response"
    elif [[ "$file_path" == *"developer/"* ]]; then
        if [[ "$name" == *"Powershell"* ]]; then
            echo "- **Languages**: PowerShell, C#, .NET
- **Frameworks**: PowerShell Core, Windows PowerShell
- **Utilities**: ISE, VS Code, Git, Azure CLI
- **Special Skills**: Automation scripting, system administration, module development"
        elif [[ "$name" == *"GraphQL"* ]]; then
            echo "- **Languages**: JavaScript, TypeScript, Python, Go
- **Frameworks**: Apollo, GraphQL Yoga, Relay
- **Utilities**: GraphiQL, Apollo Studio, Postman
- **Special Skills**: Schema design, resolver optimization, federation"
        else
            echo "- **Languages**: [Primary languages for this specialty]
- **Frameworks**: [Relevant frameworks and libraries]
- **Utilities**: [Development tools and platforms]
- **Special Skills**: [Domain-specific expertise]"
        fi
    else
        echo "- **Languages**: [Relevant programming languages]
- **Frameworks**: [Frameworks and libraries]
- **Utilities**: [Tools and platforms]
- **Special Skills**: [Domain-specific expertise]"
    fi
}

# Function to create persona file from template
create_persona_file() {
    local file_path="$1"
    local name="$2"
    local type="$3"
    local role_summary="$4"
    local goals="$5"
    local tools="$6"
    
    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        echo "Warning: Template not found at $TEMPLATE_FILE"
        return 1
    fi
    
    # Read template and replace placeholders
    local content=$(cat "$TEMPLATE_FILE")
    
    # Replace basic placeholders
    content="${content//\[Agent Name\]/$name}"
    content="${content//A short paragraph defining the agent's primary purpose, audience, and expertise./$role_summary}"
    
    # Replace goals section
    content="${content//- \[Primary goal 1\]/$(echo "$goals" | head -n 1)}"
    content="${content//- \[Primary goal 2\]/$(echo "$goals" | sed -n '2p')}"
    content="${content//- \[Primary goal 3\]/$(echo "$goals" | sed -n '3p')}"
    content="${content//- \[Optional additional goals\]/$(echo "$goals" | tail -n +4)}"
    
    # Replace tools section
    content="${content//- \*\*Languages\*\*: \[Programming languages\]/$(echo "$tools" | grep "Languages:" || echo "- **Languages**: [Relevant languages]")}"
    content="${content//- \*\*Frameworks\*\*: \[Frameworks and libraries\]/$(echo "$tools" | grep "Frameworks:" || echo "- **Frameworks**: [Relevant frameworks]")}"
    content="${content//- \*\*Utilities\*\*: \[CLI tools, APIs, SDKs\]/$(echo "$tools" | grep "Utilities:" || echo "- **Utilities**: [Relevant tools]")}"
    content="${content//- \*\*Special Skills\*\*: \[e.g., code review, refactoring, test generation\]/$(echo "$tools" | grep "Special Skills:" || echo "- **Special Skills**: [Domain expertise]")}"
    
    # Update metadata
    content="${content//\[Your name or team\]/Agentic Template}"
    content="${content//\[YYYY-MM-DD\]/2025-08-13}"
    
    # Write content to file
    echo "$content" > "$file_path"
    echo "Created: $file_path"
}

# Main execution
echo "Starting persona file population..."
echo "Searching for empty persona files..."

# Find all empty persona files
empty_files=()
while IFS= read -r -d '' file; do
    if [[ ! -s "$file" ]] && [[ "$file" != *"/templates/"* ]]; then
        empty_files+=("$file")
    fi
done < <(find "$PERSONAS_DIR" -name "*.md" -type f -print0)

echo "Found ${#empty_files[@]} empty persona files"

# Process each empty file
for file in "${empty_files[@]}"; do
    echo "Processing: $file"
    
    # Extract information from file path
    name=$(get_persona_name "$file")
    type=$(get_persona_type "$file")
    role_summary=$(get_role_summary "$name" "$type" "$file")
    goals=$(get_goals "$type" "$name")
    tools=$(get_tools_capabilities "$name" "$type" "$file")
    
    echo "  Name: $name"
    echo "  Type: $type"
    
    # Create the persona file
    if create_persona_file "$file" "$name" "$type" "$role_summary" "$goals" "$tools"; then
        echo "  ✅ Successfully created"
    else
        echo "  ❌ Failed to create"
    fi
    echo ""
done

echo "Persona file population complete!"
echo "Generated ${#empty_files[@]} persona files"
