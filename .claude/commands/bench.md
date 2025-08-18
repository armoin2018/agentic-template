# Benchmark Instructions and Personas

Run comprehensive quality assessment and performance benchmarking for all instruction and persona files in the repository with comparative analysis.

## Usage

This command evaluates all files in `common/instructions/**/*.md` and `common/personas/**/*.md` to assess:

- **Quality metrics**: Content quality, structure, actionability, completeness, relevance
- **Performance metrics**: Response time, token usage, context efficiency  
- **Comparative analysis**: Performance with and without instructions loaded
- **Composite scoring**: Weighted average across all quality dimensions
- **Improvement recommendations**: Specific suggestions for enhancing files

## Commands

### Full Benchmark Assessment
```bash
# Load and apply the benchmark prompt to evaluate all instruction and persona files
cat .github/prompts/bench-instructions.prompt.md
```

### Performance Comparison Testing
```bash
# Clear memory before testing
# Test baseline performance without instructions
# Clear memory between tests
# Test performance with instructions loaded
# Clear memory after testing
# Generate comparative performance report
```

## Expected Output

The benchmark will generate:

1. **Individual file assessments** with detailed scores and recommendations
2. **Comparative performance analysis** showing impact of each instruction/persona file
3. **Performance report** saved to `common/claude-PERFORMANCE.md` containing:
   - Filename and file type
   - Time taken (with vs without instructions)
   - Token usage (with vs without instructions) 
   - Quality scores across all 5 dimensions
   - Composite score (0-100)
   - Performance impact analysis
4. **Summary report** with overall statistics and priority recommendations
5. **Performance insights** for optimization opportunities
6. **Best practices** identified across high-performing files

## Performance Comparison Methodology

### Test Protocol
1. **Memory Clearing**: Clear context before each test phase
2. **Baseline Test**: Execute test prompt without any instructions loaded
3. **Memory Clearing**: Clear context between test phases
4. **Enhanced Test**: Execute same test prompt with specific instruction/persona loaded
5. **Memory Clearing**: Clear context after testing
6. **Analysis**: Compare performance metrics and generate impact report

### Metrics Tracked
- **Response Time**: Actual time taken for generation (milliseconds)
- **Token Usage**: Input and output token consumption
- **Quality Assessment**: Content accuracy, completeness, and usefulness
- **Performance Impact**: Percentage improvement/degradation with instructions
- **Efficiency Score**: Quality improvement per token cost

## Use Cases

- **Quality assurance**: Ensure consistent quality across all instruction/persona files
- **Performance optimization**: Identify files that provide best quality-to-cost ratio
- **Content improvement**: Get specific recommendations for enhancing documentation
- **Template identification**: Find high-quality files to use as templates for new content
- **Priority planning**: Focus improvement efforts on files with the highest impact
- **ROI Analysis**: Determine which instructions provide most value per token cost

## Output Format

Results are automatically saved to `common/claude-PERFORMANCE.md` in the following format:

```markdown
# Claude Performance Benchmark Report

## Test Summary
- **Test Date**: YYYY-MM-DD HH:MM:SS
- **Files Evaluated**: X
- **Total Test Duration**: X minutes
- **Average Quality Improvement**: X%
- **Average Token Overhead**: X tokens

## Individual File Results

### [filename.md]
- **File Type**: instruction/persona
- **Baseline Performance**: Xms, X tokens
- **Enhanced Performance**: Xms, X tokens 
- **Quality Scores**: Content(X), Structure(X), Actionability(X), Completeness(X), Relevance(X)
- **Composite Score**: X/100
- **Performance Impact**: +X% quality, +X% tokens
- **Efficiency Score**: X (quality/token ratio)
- **Recommendation**: High/Medium/Low priority for optimization

## Performance Rankings
1. [Best performing files by efficiency score]
2. [Files with highest quality improvement]
3. [Most token-efficient files]
```

## Integration

This benchmark can be run:
- **Manually**: To assess current state and plan improvements
- **In CI/CD**: As part of quality gates for content changes with performance tracking
- **Periodically**: To track improvement trends over time with historical comparison
- **Before releases**: To ensure all content meets quality and performance standards
- **A/B Testing**: Compare different versions of instructions for optimization

Run this command whenever you want to assess the overall quality and performance characteristics of your instruction and persona files, with detailed impact analysis saved to `common/claude-PERFORMANCE.md`.