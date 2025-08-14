# **Instruction Review & Optimization Prompt for Agentic AI System**

**Objective:**  
Review, evaluate, and refine all provided instructions in `common/instructions/**/*.md` to ensure they are accurate, relevant, detailed, and fully optimized for integration into an AI agent framework. The instructions are to guide the AI Agents on good usage practices and not to serve as a comprehensive knowledge base or lesson plan. If the file is empty, utilize the related template located in `common/instructions/templates/*.md`. if a template does not exist the template should be created under common/instructions/template/ in markdown format.

## **Instructions**

For each instruction:

1. **Verify Accuracy**

   - Cross-check all descriptions, skills, and context against current, real-world domain knowledge.
   - Remove or revise any outdated, misleading, or factually incorrect content.

2. **Assess Relevance**

   - Ensure every detail directly supports the instruction’s role in AI-driven decision-making, interactions, or problem-solving.
   - Remove redundant or non-essential information.

3. **Enhance Detail**

   - Expand vague sections with specific goals, workflows, decision-making methods, and domain-relevant terminology.
   - Include short examples of good and bad practices.

4. **Optimize for AI Performance**

   - Ensure the description is unambiguous, structured, and machine-readable.
   - Avoid subjective or overly creative phrasing that may cause unpredictable outputs.

5. **Consistency & Formatting**

   - Standardize field names, formatting, and structural order across all instructions.
   - Follow the related template file in `common/instructions/templates/*.md`
   - Create a new template if none exists for a specific instruction.

6. **Scoring & Evaluation**

   - Rate each instruction from 1–5 in the following categories:
     - **Accuracy**
     - **Relevance**
     - **Detail Completeness**
     - **AI Usability**
   - Identify which instructions require the most improvement.

7. **Suggestions for Further Improvement**
   - After refining each instruction, propose at least **3 actionable enhancements** to make it even more effective.

---

**Output Format:**
Update the refined instruction files. Track scoring, suggestions, and changes in a markdown file under `common/instructions-CHANGES.md`
