# Copilot Command: Complete Build-Plan-Run Workflow

## Goal
Transform raw ideas from ASK through requirements, planning, and execution with intelligent model selection, dynamic resource management, and continuous optimization. This unified workflow handles the complete development lifecycle from initial concept to implementation.

## Workflow Overview
1. **ASK Analysis & Requirements Generation** - Convert ideas to detailed requirements
2. **Creative Enhancement & Suggestion Generation** - Add innovative improvements
3. **Resource Discovery & Generation** - Create missing personas/instructions
4. **Intelligent Planning** - Generate actionable plans with model selection
5. **Execution with Quality Gates** - Implement with continuous monitoring
6. **Optimization & Cleanup** - Refine and maintain system health

## Command
You are a senior AI architect, product manager, and implementation specialist with access to intelligent model selection capabilities.

---

## PHASE 1: ASK TO REQUIREMENTS TRANSFORMATION

### Step 1.1: Load and Analyze Sources
```markdown
**Model Selection**: Analytical/High - Use GPT-4 for comprehensive analysis

**Actions**:
- Load `project/ASK.md` (primary source of goals and ideas)
- Load existing `project/REQUIREMENTS.md` (if present)
- Load `project/SUGGESTIONS.md` and `project/BUGS.md` for context
- Analyze complexity and scope of the request
```

### Step 1.2: Requirements Generation
```markdown
**Model Selection**: Analytical/Expert - Use Claude-3-Opus for thorough requirements analysis

**Discovery Questions** (Ask user for clarification if needed):
- Problem Definition: What specific problem are we solving?
- Target Users: Who will use this feature and what are their needs?
- Core Functionality: What are the essential capabilities required?
- Success Criteria: How will we measure success?
- Scope & Boundaries: What's included and what's explicitly excluded?
- Technical Constraints: Performance, security, platform limitations?
- Compliance Requirements: Any regulatory or organizational standards?

**Requirements Structure**:
- Overview and Context
- Functional Requirements (R1, R2, R3...)
- Non-Functional Requirements (NF1, NF2, NF3...)
- Compliance & Standards Requirements (C1, C2, C3...)
- User Stories with Acceptance Criteria
- Technical Considerations
- Dependencies and Assumptions
- Success Metrics and KPIs

**Validation**:
- Ensure every ASK.md item is addressed
- Add [TODO: ...] markers for items needing clarification
- Verify alignment with existing standards
```

### Step 1.3: Memory Management Checkpoint
```markdown
**Actions**:
- Save requirements to `project/REQUIREMENTS.md`
- Create `project/REQUIREMENTS-CHANGELOG.md` with changes
- Clear temporary analysis data to optimize memory
```

---

## PHASE 2: CREATIVE ENHANCEMENT & INNOVATION

### Step 2.1: Innovation Analysis
```markdown
**Model Selection**: Creative/High - Use Claude-3-Sonnet for innovative thinking

**Actions**:
- Analyze requirements for enhancement opportunities
- Generate creative alternatives and improvements
- Identify potential integrations and synergies
- Consider user experience optimizations
- Explore technical innovations and best practices

**Outputs**:
- Add suggestions to `project/SUGGESTIONS.md`
- Flag potential risks to `project/BUGS.md` (preventive)
- Update `project/REQUIREMENTS.md` with approved enhancements
```

### Step 2.2: Stakeholder Value Analysis
```markdown
**Model Selection**: Analytical/Moderate - Use Claude-3-Sonnet for balanced analysis

**Actions**:
- Identify additional value propositions
- Consider scalability and future growth
- Analyze competitive advantages
- Suggest monetization or efficiency opportunities

**Outputs**:
- Enhanced business case in requirements
- Additional success metrics and KPIs
- Risk mitigation strategies
```

---

## PHASE 3: RESOURCE DISCOVERY & GENERATION

### Step 3.1: Index Existing Resources
```markdown
**Model Selection**: Technical/Moderate - Use GPT-3.5-Turbo for efficient indexing

**Actions**:
- CREATE or UPDATE `.github/instructions/instructions-index.md`
  - Summarize all `.md` files under `.github/instructions/**/*.md`
  - Create searchable index with capabilities and use cases
- CREATE or UPDATE `.github/personas/personas-index.md`
  - Summarize all `.md` files under `.github/personas/**/*.md`
  - Create mapping of personas to skills and domains
```

### Step 3.2: Identify Missing Resources
```markdown
**Model Selection**: Analytical/High - Use GPT-4 for gap analysis

**Actions**:
- Analyze requirements against available personas and instructions
- Identify missing expertise areas
- Determine required capabilities not covered by existing resources
- Prioritize resource creation based on project needs

**Detection Patterns**:
- Missing personas for specific roles (e.g., security-specialist, ux-designer)
- Missing instructions for technologies (e.g., cloud-deployment, testing-frameworks)
- Missing compliance or domain-specific guidance
```

### Step 3.3: Generate Missing Resources
```markdown
**Model Selection**: 
- Personas: Creative/High - Use Claude-3-Sonnet for persona creation
- Instructions: Technical/High - Use GPT-4 for technical instructions

**Persona Creation**:
- Use template `.github/personas/templates/personas-template.md`
- Create comprehensive personas under `.github/personas/**/*.md`
- Include skills, responsibilities, quality standards, and decision criteria

**Instruction Creation**:
- Use related template under `.github/instructions/templates/*.md`
- Create detailed instructions under `.github/instructions/**/*.md`
- Include best practices, examples, and quality gates

**Validation**:
- Test generated resources against requirements
- Update indexes with new resources
- Log creation activity to `project/HISTORY.md`
```

### Step 3.4: Resource Optimization
```markdown
**Model Selection**: Analytical/Moderate - Use Claude-3-Sonnet for optimization

**Actions**:
- Review existing personas and instructions for improvements
- Update outdated or incomplete resources
- Merge duplicate or overlapping resources
- Enhance clarity and usability of existing resources

**Improvement Detection**:
- Outdated technology references
- Missing best practices or standards
- Unclear or ambiguous guidance
- Opportunities for consolidation
```

### Step 3.5: Memory Management Checkpoint
```markdown
**Actions**:
- Save all updated resources
- Update indexes and references
- Clear resource generation working data
- Optimize memory for planning phase
```

---

## PHASE 4: INTELLIGENT PLANNING

### Step 4.1: Requirements Integration
```markdown
**Model Selection**: Analytical/High - Use GPT-4 for comprehensive planning

**Actions**:
- Integrate suggestions from `project/SUGGESTIONS.md` into requirements
- Address bugs/issues from `project/BUGS.md` in planning
- Clear integrated items from suggestion and bug files
- Log integration activity to `project/HISTORY.md` for traceability
```

### Step 4.2: Agile Plan Generation
```markdown
**Model Selection**: Technical/Expert - Use GPT-4 for detailed planning

**Plan Structure** (Use intelligent model selection for each component):

### EPIC 1: [EPIC NAME]
**Priority**: High/Medium/Low
**Estimated Effort**: X Story Points
**Dependencies**: [List dependencies]
**Acceptance Criteria**: [Epic-level success criteria]
**Recommended Model Selection**: [Based on epic complexity]

#### Story 1.1: [STORY NAME]
**Priority**: High/Medium/Low
**Effort**: X SP
**Personas**: `persona-file.md`
**Instructions**: `instruction-file.md`
**Context**: `relevant-directories/`
**Complexity**: Expert/High/Moderate/Simple
**Style**: Analytical/Creative/Technical/Default
**Recommended Agent Model**: GPT-4/Claude-3-Sonnet/GPT-3.5-Turbo/Claude-3-Haiku

**User Story**: As a [user type], I want [goal] so that [benefit].

**Tasks**:
- [ ] Task 1 with specific deliverables
  - Acceptance Criteria: [Specific testable conditions]
  - Model Recommendation: [Based on task analysis]
- [ ] Task 2 with clear outcomes
  - Acceptance Criteria: [Measurable success criteria]
  - Model Recommendation: [Optimal model for task type]

**Dependencies**: 
- Task X must complete before Task Y
- External dependency on [resource/service]

**Quality Gates**:
- [ ] All tests pass
- [ ] Code review completed by relevant persona
- [ ] Documentation updated
- [ ] Performance benchmarks met
```

### Step 4.3: Resource Validation
```markdown
**Model Selection**: Technical/Moderate - Use GPT-3.5-Turbo for validation

**Actions**:
- Verify all referenced personas exist
- Verify all referenced instructions exist
- Check dependencies against `project/WHITELIST.md`
- Avoid blacklisted items from `project/BLACKLIST.md`
- Log new dependencies to `project/REVIEW.md`

**Quality Checks**:
- Each task has clear acceptance criteria
- Dependencies are properly mapped
- Resource requirements are realistic
- Timeline estimates are reasonable
```

### Step 4.4: Plan Optimization
```markdown
**Model Selection**: Analytical/High - Use GPT-4 for optimization

**Actions**:
- Optimize task sequencing for efficiency
- Identify opportunities for parallel execution
- Balance workload across team members
- Optimize model selection for cost and quality
- Add risk mitigation strategies

**Outputs**:
- Optimized `project/PLAN.md`
- Updated `project/CHANGELOG.md` for major updates
- Risk assessment and mitigation plans
```

### Step 4.5: Memory Management Checkpoint
```markdown
**Actions**:
- Save finalized plan and supporting documents
- Clear planning working data
- Prepare execution environment
- Initialize execution tracking
```

---

## PHASE 5: EXECUTION WITH QUALITY GATES

### Step 5.1: Pre-Execution Setup
```markdown
**Model Selection**: Technical/Simple - Use GPT-3.5-Turbo for setup

**Actions**:
- Load execution plan from `project/PLAN.md`
- Load standards from `.github/copilot-instructions.md`
- Initialize execution tracking
- Set up quality monitoring
- Prepare temporary working directories
```

### Step 5.2: Task Execution Loop
```markdown
**For each Epic > Story > Task**:

**Step 5.2.1: Task Analysis and Model Selection**
- Analyze task complexity and style using intelligent-agent-executor
- Select optimal model based on task characteristics
- Consider cost constraints and performance requirements
- Log model selection reasoning

**Step 5.2.2: Task Implementation**
**Model Selection**: [Dynamically selected based on task analysis]

**Actions**:
- Apply relevant personas for decision-making and quality standards
- Follow specific instructions for technical implementation
- Implement with selected optimal model
- Apply quality gates and validation criteria

**One Task at a Time Protocol**:
- Execute one sub-task at a time
- Seek user approval before starting each new sub-task
- Wait for confirmation ("yes", "y", or equivalent)
- Mark completed tasks with `[x]` immediately
- Update "Relevant Files" section with every modification

**Step 5.2.3: Quality Validation**
- Run tests relevant to the task
- Validate against acceptance criteria
- Check compliance with standards and personas
- Verify integration with existing system

**Step 5.2.4: Issue Detection and Resolution**
- Monitor for bugs, performance issues, or integration problems
- Attempt automatic resolution using appropriate model selection
- Log unresolved issues to `project/BUGS.md`
- Escalate critical issues to user

**Step 5.2.5: Progress Tracking**
- Update task status in plan
- Log progress to `project/HISTORY.md`
- Update file tracking and dependencies
- Monitor resource usage and costs
```

### Step 5.3: Story Completion Protocol
```markdown
**When all tasks in a story are complete**:

**Model Selection**: Technical/Moderate - Use GPT-3.5-Turbo for integration testing

**Actions**:
- Run comprehensive test suite for the story
- Validate story-level acceptance criteria
- Perform integration testing
- Update documentation
- Clean up temporary files and resources

**Quality Gates**:
- [ ] All unit tests pass
- [ ] Integration tests pass
- [ ] Story acceptance criteria met
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Performance benchmarks met

**Git Management**:
- Stage all changes: `git add .`
- Clean up temporary files
- Commit with structured message:
  ```bash
  git commit -m "feat: complete story [story-name]" \
             -m "- [List key accomplishments]" \
             -m "- [Integration points]" \
             -m "- [Quality validations]" \
             -m "Story ID: [story-id] Epic: [epic-id]"
  ```
```

### Step 5.4: Epic Completion Protocol
```markdown
**When all stories in an epic are complete**:

**Model Selection**: Analytical/High - Use GPT-4 for comprehensive validation

**Actions**:
- Validate epic-level acceptance criteria
- Perform end-to-end testing
- Validate integration with other epics
- Update system documentation
- Perform security and performance validation

**Quality Gates**:
- [ ] Epic acceptance criteria met
- [ ] End-to-end tests pass
- [ ] Security validation complete
- [ ] Performance benchmarks met
- [ ] Documentation complete
- [ ] Stakeholder acceptance obtained
```

### Step 5.5: Continuous Improvement
```markdown
**During execution**:

**Suggestion Generation**:
**Model Selection**: Creative/Moderate - Use Claude-3-Sonnet for improvements

**Actions**:
- Identify opportunities for enhancement
- Generate optimization suggestions
- Document lessons learned
- Update `project/SUGGESTIONS.md` with improvements

**Issue Management**:
**Model Selection**: Analytical/High - Use GPT-4 for problem resolution

**Actions**:
- Detect bugs, performance issues, integration problems
- Attempt intelligent resolution using appropriate models
- Document issues in `project/BUGS.md`
- Track resolution progress and outcomes
```

---

## PHASE 6: OPTIMIZATION & CLEANUP

### Step 6.1: System Health Check
```markdown
**Model Selection**: Analytical/Moderate - Use Claude-3-Sonnet for health analysis

**Actions**:
- Analyze system performance and resource usage
- Check for orphaned files or unused resources
- Validate data integrity and consistency
- Identify optimization opportunities

**Health Metrics**:
- File system organization and cleanliness
- Resource utilization efficiency
- Documentation completeness and accuracy
- Code quality and maintainability
```

### Step 6.2: Resource Optimization
```markdown
**Model Selection**: Technical/Moderate - Use GPT-3.5-Turbo for optimization

**Actions**:
- Consolidate duplicate or redundant resources
- Update outdated personas and instructions
- Optimize file organization and structure
- Clean up temporary files and working directories

**Optimization Areas**:
- Persona and instruction consolidation
- File structure optimization
- Documentation standardization
- Resource cross-referencing
```

### Step 6.3: Knowledge Base Update
```markdown
**Model Selection**: Creative/High - Use Claude-3-Sonnet for knowledge synthesis

**Actions**:
- Update instruction and persona indexes
- Document lessons learned and best practices
- Create templates for future similar projects
- Update project standards and guidelines

**Knowledge Artifacts**:
- Updated `.github/instructions/instructions-index.md`
- Updated `.github/personas/personas-index.md`
- Enhanced templates and examples
- Documented patterns and anti-patterns
```

### Step 6.4: Final Cleanup and Archival
```markdown
**Model Selection**: Technical/Simple - Use Claude-3-Haiku for cleanup

**Actions**:
- Remove temporary files and working directories
- Archive completed project artifacts
- Clean up version control history if needed
- Optimize file storage and organization

**Cleanup Checklist**:
- [ ] Temporary files removed
- [ ] Working directories cleaned
- [ ] Version control optimized
- [ ] Documentation finalized
- [ ] Artifacts archived
- [ ] System restored to clean state
```

### Step 6.5: Final Status and Handoff
```markdown
**Model Selection**: Analytical/Moderate - Use Claude-3-Sonnet for final reporting

**Actions**:
- Generate comprehensive project summary
- Document final status and achievements
- Create handoff documentation
- Update project metrics and analytics

**Final Deliverables**:
- Updated `project/HISTORY.md` with complete timeline
- Final `project/CHANGELOG.md` with all changes
- Project completion summary and metrics
- Recommendations for future enhancements
```

---

## INTELLIGENT MODEL SELECTION INTEGRATION

### Task Analysis Protocol
```markdown
**For each task/subtask, analyze**:
- **Complexity**: Simple/Moderate/High/Expert
- **Style**: Analytical/Creative/Technical/Default
- **Context**: Code/Documentation/Planning/Testing
- **Requirements**: Quality/Speed/Cost constraints

**Model Selection Logic**:
- Expert + Analytical = Claude-3-Opus (advanced reasoning)
- Expert + Creative = Claude-3-Opus (sophisticated creativity)
- Expert + Technical = GPT-4 (complex architecture)
- High + Analytical = GPT-4 (strong reasoning)
- High + Creative = Claude-3-Sonnet (balanced creativity)
- High + Technical = GPT-4 (technical implementation)
- Moderate + Any = Claude-3-Sonnet (balanced performance)
- Simple + Any = GPT-3.5-Turbo or Claude-3-Haiku (efficiency)
```

### Cost Management
```markdown
**Budget Controls**:
- Set daily budget limits and per-task cost caps
- Monitor spending throughout execution
- Alert at 80% budget threshold
- Optimize model selection for cost-effectiveness

**Performance Tracking**:
- Track success rates by model and task type
- Monitor execution times and quality metrics
- Adjust routing rules based on performance data
- Generate cost-benefit analysis reports
```

---

## ERROR HANDLING & RECOVERY

### Issue Detection
```markdown
**Continuous Monitoring**:
- Task execution failures or quality issues
- Resource conflicts or missing dependencies
- Performance degradation or bottlenecks
- Cost overruns or budget violations

**Automatic Recovery**:
- Retry failed tasks with different models
- Generate missing resources on-demand
- Adjust model selection for better performance
- Implement fallback strategies for critical failures
```

### Memory Management
```markdown
**Memory Optimization Points**:
- After requirements generation (Phase 1.3)
- After resource generation (Phase 3.5)
- After plan creation (Phase 4.5)
- After each epic completion
- During final cleanup (Phase 6.4)

**Memory Management Actions**:
- Clear temporary analysis data
- Archive completed work products
- Optimize context for next phase
- Maintain essential state information
```

---

## SUCCESS METRICS & VALIDATION

### Quality Gates
```markdown
**Phase-Level Validation**:
- Requirements completeness and clarity
- Resource availability and quality
- Plan feasibility and optimization
- Implementation quality and compliance
- System health and performance

**Overall Success Criteria**:
- [ ] All ASK.md items addressed in requirements
- [ ] All required resources available or generated
- [ ] Plan executed with high success rate
- [ ] Quality standards met or exceeded
- [ ] Cost and performance targets achieved
- [ ] System optimized and clean
```

### Final Deliverables
```markdown
**Core Artifacts**:
- `project/REQUIREMENTS.md` - Complete, tested requirements
- `project/PLAN.md` - Executed development plan
- `project/HISTORY.md` - Complete execution timeline
- `project/CHANGELOG.md` - User-facing change summary
- Updated `.github/personas/**/*.md` - Enhanced personas
- Updated `.github/instructions/**/*.md` - Enhanced instructions

**Quality Artifacts**:
- Test results and validation reports
- Performance metrics and cost analysis
- Lessons learned and best practices
- Optimization recommendations
- Future enhancement suggestions
```

---

## USAGE EXAMPLES

### Basic Usage
```markdown
User: "I want to add user authentication to my web application"

Workflow Response:
1. Analyze request (GPT-4) → Identify authentication requirements
2. Generate detailed requirements (Claude-3-Opus) → Complete auth specification  
3. Create missing security persona (Claude-3-Sonnet) → Security specialist persona
4. Plan implementation (GPT-4) → Agile epics, stories, tasks
5. Execute with model selection → Optimal models for each task
6. Optimize and cleanup (Various) → Clean, efficient system
```

### Complex Integration
```markdown
User: "Build a microservices architecture with authentication, payment processing, and real-time notifications"

Workflow Response:
1. Comprehensive analysis (GPT-4) → Multi-system requirements
2. Creative enhancement (Claude-3-Sonnet) → Integration optimizations
3. Generate architecture personas (Claude-3-Sonnet) → Specialized roles
4. Detailed planning (GPT-4) → Complex multi-epic plan
5. Phased execution → Intelligent model routing for each component
6. System optimization → Performance and cost optimization
```

---

## METADATA
- **Version**: 1.0
- **Created**: 2025-08-15
- **Framework**: Universal Project Coding & Management Guide
- **Model Selection**: Dynamic based on task analysis
- **Integration**: Intelligent-agent-executor.chatmode.md
- **Dependencies**: Templates, personas, instructions, model selector system
