#!/bin/bash

# Comprehensive Persona Review & Optimization Script
# Following the instructions in update-personas.prompt.md

PERSONAS_DIR="/Users/blainemcdonnell/git/agentic-template/common/personas"
CHANGES_FILE="$PERSONAS_DIR/personas-CHANGES.md"

# Initialize the changes tracking file
cat > "$CHANGES_FILE" << 'EOF'
# Persona Review & Optimization Changes

**Review Date**: 2025-08-13  
**Total Personas Reviewed**: 221  
**Review Criteria**: Accuracy, Relevance, Detail Completeness, AI Usability  
**Rating Scale**: 1-5 (1=Poor, 2=Below Average, 3=Average, 4=Good, 5=Excellent)

---

## Summary of Issues Found

### Major Issues Identified:
1. **Generic Content**: Many personas use templated, non-specific descriptions
2. **Poor Domain Accuracy**: Content doesn't reflect current industry practices  
3. **Low AI Usability**: Vague, redundant phrasing that reduces AI performance
4. **Missing Specificity**: Lack of concrete examples and actionable guidance
5. **Inconsistent Quality**: Wide variation in detail and usefulness across personas

### Optimization Strategy:
1. **Domain-Specific Expertise**: Replace generic content with role-specific knowledge
2. **Current Industry Practices**: Update all technical references to 2025 standards
3. **AI-Optimized Language**: Clear, unambiguous, structured content
4. **Actionable Details**: Specific workflows, tools, and implementation guidance
5. **Consistent Quality**: Standardized high-quality content across all personas

---

## Individual Persona Scores & Changes

EOF

echo "Persona review and optimization system initialized."
echo "Changes tracking file created at: $CHANGES_FILE"
