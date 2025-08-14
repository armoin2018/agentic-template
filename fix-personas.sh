#!/bin/bash

# List of files to fix
files=(
  "common/personas/administrator/sharepoint-administrator.md"
  "common/personas/administrator/databricks-adminsitrator.md"
  "common/personas/administrator/confluent-administrator.md"
  "common/personas/administrator/snowflake-administrator.md"
  "common/personas/architect/api-architect.md"
  "common/personas/architect/microservices-architect.md"
  "common/personas/architect/serverless-architect.md"
  "common/personas/architect/distributed-systems-architect.md"
  "common/personas/architect/salesforce-architect.md"
  "common/personas/architect/servicenow-architect.md"
  "common/personas/developer/java-streaming-developer.md"
  "common/personas/developer/python-streaming-developer.md"
  "common/personas/security/protocol-expert.md"
  "common/personas/security/encryption-expert.md"
  "common/personas/design/product.md"
  "common/personas/design/graphic.md"
)

# Fix each file
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "Fixing $file"
    sed -i '' '1s/^````markdown$//' "$file"
    sed -i '' '$s/````$//' "$file"
  fi
done

echo "All files fixed!"
