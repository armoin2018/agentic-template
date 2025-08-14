#!/bin/bash

# Auto-populate empty instruction files based on their path and filename
# Usage: ./populate_instructions.sh

set -e

INSTRUCTIONS_DIR="/Users/blainemcdonnell/git/agentic-template/common/instructions"
TEMPLATES_DIR="/Users/blainemcdonnell/git/agentic-template/common/instructions/templates"

# Function to get template path based on instruction file path
get_template_path() {
    local file_path="$1"
    
    if [[ "$file_path" == *"/frameworks/"* ]]; then
        echo "$TEMPLATES_DIR/frameworks.instructions.md"
    elif [[ "$file_path" == *"/languages/"* ]]; then
        echo "$TEMPLATES_DIR/language.instructions.md"
    elif [[ "$file_path" == *"/tools/"* ]]; then
        echo "$TEMPLATES_DIR/tools.instructions.md"
    elif [[ "$file_path" == *"/workflows/"* ]]; then
        echo "$TEMPLATES_DIR/workflows.instructions.md"
    elif [[ "$file_path" == *"/best-practices/"* ]]; then
        echo "$TEMPLATES_DIR/best-practices.instructions.md"
    else
        echo "$TEMPLATES_DIR/tools.instructions.md"  # Default to tools template
    fi
}

# Function to extract tool/framework name from filename
get_name_from_path() {
    local file_path="$1"
    local filename=$(basename "$file_path" .instructions.md)
    
    # Convert hyphens and underscores to spaces and capitalize
    echo "$filename" | sed 's/[-_]/ /g' | sed 's/\b\w/\u&/g'
}

# Function to determine tool type from path
get_tool_type() {
    local file_path="$1"
    
    if [[ "$file_path" == *"/containerization/"* ]]; then
        echo "Containerization Platform"
    elif [[ "$file_path" == *"/ci-cd/"* ]]; then
        echo "CI/CD Platform"
    elif [[ "$file_path" == *"/databases/"* ]]; then
        echo "Database System"
    elif [[ "$file_path" == *"/testing/"* ]]; then
        echo "Testing Framework"
    elif [[ "$file_path" == *"/version-control/"* ]]; then
        echo "Version Control System"
    elif [[ "$file_path" == *"/package-managers/"* ]]; then
        echo "Package Manager"
    elif [[ "$file_path" == *"/build-tools/"* ]]; then
        echo "Build Tool"
    elif [[ "$file_path" == *"/ide/"* ]]; then
        echo "Integrated Development Environment"
    elif [[ "$file_path" == *"/frameworks/"* ]]; then
        echo "Framework"
    elif [[ "$file_path" == *"/languages/"* ]]; then
        echo "Programming Language"
    else
        echo "Development Tool"
    fi
}

# Function to generate use cases based on tool name and type
get_use_cases() {
    local name="$1"
    local type="$2"
    local file_path="$3"
    
    case "$type" in
        "Testing Framework")
            echo "unit testing, integration testing, test automation, code coverage analysis"
            ;;
        "Framework")
            echo "web applications, API development, single-page applications, full-stack development"
            ;;
        "Programming Language")
            echo "software development, scripting, system programming, web development"
            ;;
        "Database System")
            echo "data storage, data retrieval, data modeling, transaction management"
            ;;
        "CI/CD Platform")
            echo "continuous integration, continuous deployment, automated testing, release management"
            ;;
        "Containerization Platform")
            echo "application deployment, microservices, development environments, container orchestration"
            ;;
        "Version Control System")
            echo "source code management, collaboration, version tracking, branching strategies"
            ;;
        "Package Manager")
            echo "dependency management, package installation, version management, project setup"
            ;;
        "Build Tool")
            echo "project compilation, asset bundling, build automation, optimization"
            ;;
        *)
            echo "development workflow, project management, code quality, automation"
            ;;
    esac
}

# Function to create instruction file from template
create_instruction_file() {
    local file_path="$1"
    local template_path="$2"
    local name="$3"
    local type="$4"
    local use_cases="$5"
    
    if [[ ! -f "$template_path" ]]; then
        echo "Warning: Template not found at $template_path"
        return 1
    fi
    
    # Read template and replace placeholders
    local content=$(cat "$template_path")
    
    # Replace placeholders based on template type
    if [[ "$template_path" == *"tools.instructions.md" ]]; then
        content="${content//\{\{TOOL_NAME\}\}/$name}"
        content="${content//\{\{TOOL_TYPE\}\}/$type}"
        content="${content//\{\{USE_CASES\}\}/$use_cases}"
    elif [[ "$template_path" == *"frameworks.instructions.md" ]]; then
        content="${content//\{\{FRAMEWORK_NAME\}\}/$name}"
        content="${content//\{\{FRAMEWORK_TYPE\}\}/$type}"
        content="${content//\{\{USE_CASES\}\}/$use_cases}"
    elif [[ "$template_path" == *"language.instructions.md" ]]; then
        content="${content//\{\{LANGUAGE_NAME\}\}/$name}"
        content="${content//\{\{LANGUAGE_TYPE\}\}/$type}"
        content="${content//\{\{USE_CASES\}\}/$use_cases}"
    fi
    
    # Write content to file
    echo "$content" > "$file_path"
    echo "Created: $file_path"
}

# Main execution
echo "Starting instruction file population..."
echo "Searching for empty instruction files..."

# Find all empty instruction files
empty_files=()
while IFS= read -r -d '' file; do
    if [[ ! -s "$file" ]]; then
        empty_files+=("$file")
    fi
done < <(find "$INSTRUCTIONS_DIR" -name "*.instructions.md" -type f -print0)

echo "Found ${#empty_files[@]} empty instruction files"

# Process each empty file
for file in "${empty_files[@]}"; do
    echo "Processing: $file"
    
    # Extract information from file path
    name=$(get_name_from_path "$file")
    type=$(get_tool_type "$file")
    use_cases=$(get_use_cases "$name" "$type" "$file")
    template_path=$(get_template_path "$file")
    
    echo "  Name: $name"
    echo "  Type: $type"
    echo "  Template: $template_path"
    
    # Create the instruction file
    if create_instruction_file "$file" "$template_path" "$name" "$type" "$use_cases"; then
        echo "  ✅ Successfully created"
    else
        echo "  ❌ Failed to create"
    fi
    echo ""
done

echo "Instruction file population complete!"
echo "Generated ${#empty_files[@]} instruction files"
