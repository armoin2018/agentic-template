# Copilot Command: Build Implementation Plan from Requirements

## Goal
Given:
- A requirements specification (`REQUIREMENTS.md`)
- Project Standards reference file (`.github/copilot-instructions.md`)
- Reference Personas (`.github/personas/*.md`)
- Reference Instructions (`.github/instructions/*.md`)

Produce:
- A detailed step-by-step, actionable (`PLAN.md`)
- Organized into **phases, milestones, and tasks**
- Utilize Agile methodology with Epics, Stories and Sprints
- Each Step should reference the necessary Personas and Instruction files needed to complete the tasks.
- With **clear mapping** between requirements and tasks

## Command
```copilot
You are a senior solutions architect and project planner.

1. **Refine `REQUIREMENTS.md` to inlcude `SUGGESTIONS.md` and `BUGS.md`
   - If any `*SUGGESTIONS.md` file exists, integrate it into the `REQUIREMENTS.md`
   - If any `BUGS.md` file exists, refine the details in the `REQUIREMENTS.md` to account for the BUG
   - Once items are integrated into the `REQUIREMENTS.md` remove them from the `BUGS.md` or `*SUGGESTIONS.md`
   - Ensure Traceability of the bugs and suggestions using references and logging them to the `HISTORY.md`

2. **Load core requirements** from:
   - `REQUIREMENTS.md`

3. **Summarize Reference materials** 
   - CREATE or UPDATE a `.github/instructions-index.md` that will be used ot summarize All `.md` files under `.github/instructions/`
   - CREATE or UPDATE a `.github/personas-index.md` that will be used ot summarize All `.md` files under `.github/personas/`

4. **Load supplemental reference materials**:
   - If any `.github/copilot-instructions.md` exists, treat it as a mandatory compliance guide
   - If any `.github/instructions-index.md` exits, use it as a memory efficient way to map the instructions to the task 
   - If any `.github/personas-index.md` exits, use it as a memory efficient way to map the personas to the task

5. **Parse and map**:
   - Identify functional, non-functional, and compliance requirements
   - Match them with relevant instruction and persona guidance 
   - If any missing personas generate them under `.github/personas/` following the template under `.github/personas/persona-template.md`
   - If any missing instructions generate them under `.github/instructions/` using industry best practices
   - If any recommendations for enhancements please add them to `SUGGESTIONS.md`
   - If any bugs are found for remediation please update `BUGS.md`
   - Utilize the `WHITELIST.md` for trusted dependencies
   - Avoid use of `BLACKLIST.md` items for untrusted dependencies
   - Log new dependencies to `REVIEW.md` for requested items
   
6. **Plan output format example**:
   - Create Epics, Stories and Tasks in the following format

```markdown
## EPIC 1: PROJECT INFRASTRUCTURE & COMPLIANCE

**Priority**: High  
**Estimated Effort**: 16 Story Points  
**Dependencies**: None
**Acceptance Criteria**: All universal standard files created and project structure complies with framework

### Story 1.1: Project Management Files
**Priority**: High
**Effort**: 3 SP
**Personas**: `technical-writer.md`
**Instructions**: `php-instructions.md`

**User Story**: As a developer, I need proper project tracking files so I can maintain version history and manage changes effectively.

**Tasks**:
- [ ] Create `HISTORY.md` with version tracking format (YYYY.MM.DD-#####)
- [ ] Create `SUGGESTIONS.md` for code review enhancement logging
- [ ] Set up `diff/` directory structure for patch/rollback management
- [ ] Initialize version tracking system with current state (2025.08.10-00001)

**Acceptance Criteria**:
- HISTORY.md follows YYYY.MM.DD-##### format with build references
- SUGGESTIONS.md has structured template for enhancement tracking
- diff/ directory contains versioning infrastructure
- All files referenced in .github/copilot-instructions.md exist
```

7. **Validation**:
   - Ensure no requirement is left unmapped
   - Flag any requirement with unclear implementation path

8. **Deliver**:
   - One detailed and actionable step-by-step plan in a markdown document (`PLAN.md`)
   - Keep each task small enough to be deliverable in 1–3 days
   - Additional suggestions captured in (`SUGGESTIONS.md`)
   - Additional bugs capture in (`BUGS.md`) 
   - Updates to `.github/copilot-instructions.md`, `.github/personas/*.md`, or `.github/instructions/*.md` when needed
   - Updated `CHANGELOG.md` for tracking progress for major updates for users
   - Updated `HISTORY.md` for tracking the progress through the project to allow for continue and resume of `PLAN.md`
