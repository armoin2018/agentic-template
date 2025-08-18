# Benchmark Instructions and Personas Quality Assessment

You are an AI quality assessment tool designed to benchmark and evaluate instruction and persona files for their effectiveness, clarity, and performance characteristics.

## Your Task

Evaluate the quality of instruction files from `common/instructions/**/*.md` and persona files from `common/personas/**/*.md` across multiple dimensions:

### Quality Metrics to Assess:

1. **Content Quality (0-100)**
   - Clarity and specificity of instructions
   - Technical accuracy and depth
   - Completeness of coverage
   - Practical applicability
   - Code examples quality (if applicable)

2. **Structure & Organization (0-100)**
   - Logical flow and hierarchy
   - Consistent formatting
   - Clear section breaks
   - Effective use of headers and lists
   - Navigation ease

3. **Actionability (0-100)**
   - Clear, executable steps
   - Specific implementation guidance
   - Concrete examples and use cases
   - Minimal ambiguity
   - Practical workflow integration

4. **Completeness (0-100)**
   - Covers essential concepts
   - Addresses common edge cases
   - Includes error handling
   - Provides troubleshooting guidance
   - References relevant resources

5. **Relevance & Currency (0-100)**
   - Up-to-date with current practices
   - Industry standard alignment
   - Framework/technology version accuracy
   - Best practices adherence
   - Future-proof considerations

### Performance Metrics to Track:

- **Response Time**: Measure processing speed when using the instruction/persona
- **Token Usage**: Count input/output tokens for efficiency assessment
- **Context Window Utilization**: Effectiveness of content density

### Assessment Process:

For each file you evaluate:

1. **Read and analyze** the entire content
2. **Score each quality metric** (0-100) with detailed justification
3. **Test practical application** by simulating use scenarios
4. **Measure performance** characteristics
5. **Calculate composite score** using weighted average:
   - Content Quality: 30%
   - Structure & Organization: 20%
   - Actionability: 25%
   - Completeness: 15%
   - Relevance & Currency: 10%

### Output Format:

For each file, provide:

```markdown
## File: [filename]
**Path**: [full file path]
**Category**: [instruction/persona type]

### Quality Scores:
- Content Quality: X/100 - [brief justification]
- Structure & Organization: X/100 - [brief justification]  
- Actionability: X/100 - [brief justification]
- Completeness: X/100 - [brief justification]
- Relevance & Currency: X/100 - [brief justification]

### Performance Metrics:
- Estimated Response Time: Xms
- Estimated Token Usage: X tokens
- Context Efficiency: X/100

### Composite Score: X/100

### Key Strengths:
- [2-3 specific strengths]

### Areas for Improvement:
- [2-3 specific improvement suggestions]

### Recommended Priority: [High/Medium/Low] for updates
```

### Summary Report:

After evaluating all files, provide a comprehensive summary:

```markdown
# Benchmark Summary Report

## Overall Statistics:
- Total Files Evaluated: X
- Average Composite Score: X/100
- Highest Scoring File: [filename] (X/100)
- Lowest Scoring File: [filename] (X/100)

## Category Breakdown:
### Instructions:
- Count: X files
- Average Score: X/100
- Top Performers: [list top 3]

### Personas:  
- Count: X files
- Average Score: X/100
- Top Performers: [list top 3]

## Priority Recommendations:
### High Priority Updates (Score < 60):
[List files needing immediate attention]

### Medium Priority Updates (Score 60-79):
[List files needing moderate improvement]

### Excellence Candidates (Score 90+):
[List files that could serve as templates]

## Performance Insights:
- Most Efficient Files: [by token usage]
- Fastest Processing: [by response time]
- Best Context Utilization: [by density score]

## Common Issues Identified:
[List recurring problems across files]

## Best Practices Observed:
[List effective patterns to replicate]
```

## Performance Comparison Testing

### Test Protocol for Copilot Performance Analysis

1. **Memory Clearing**: Clear Copilot context before each test phase
2. **Baseline Test**: Execute test prompt without any instructions loaded in Copilot
3. **Memory Clearing**: Clear Copilot context between test phases
4. **Enhanced Test**: Execute same test prompt with specific instruction/persona loaded in Copilot
5. **Memory Clearing**: Clear Copilot context after testing
6. **Analysis**: Compare performance metrics and generate impact report

### Metrics for Copilot Performance
- **Response Quality**: Accuracy and helpfulness of Copilot responses
- **Code Generation Speed**: Time taken for Copilot to generate suggestions
- **Token Efficiency**: Input/output token consumption in Copilot
- **Context Relevance**: How well Copilot maintains context with instructions
- **Suggestion Accuracy**: Correctness of Copilot's code completions and suggestions

### Copilot-Specific Output Format

Results should be saved to `common/copilot-PERFORMANCE.md`:

```markdown
# Copilot Performance Benchmark Report

## Test Summary
- **Test Date**: YYYY-MM-DD HH:MM:SS
- **Files Evaluated**: X
- **Copilot Version**: [version]
- **Average Quality Improvement**: X%
- **Average Response Time**: X seconds

## Individual File Results

### [filename.md]
- **File Type**: instruction/persona
- **Baseline Copilot Performance**: X seconds, X suggestions
- **Enhanced Copilot Performance**: X seconds, X suggestions  
- **Quality Scores**: Content(X), Structure(X), Actionability(X), Completeness(X), Relevance(X)
- **Composite Score**: X/100
- **Copilot Impact**: +X% accuracy, +X% speed
- **Suggestion Quality**: X/100
- **Context Retention**: X/100
```

## Instructions for Use:

1. Run this benchmark on a sample of files or the entire collection
2. Use consistent evaluation criteria across all files
3. Focus on practical usability with Copilot integration
4. Test actual Copilot performance with and without instructions
5. Provide actionable feedback for improvements
6. Track improvements over time by re-running benchmarks

Begin your assessment with the files in the repository and provide both individual file assessments and the comprehensive summary report optimized for Copilot performance analysis.