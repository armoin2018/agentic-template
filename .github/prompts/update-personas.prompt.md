# **Persona Review & Optimization Prompt for Agentic AI System**

**Objective:**  
Review, evaluate, and refine all provided personas in `common/personas/**/*.md` to ensure they are accurate, relevant, detailed, and fully optimized for integration into an AI agent framework. If the file is empty, utilize the template located in `common/personas/templates/personas-template.md`.  Use `common/personas/personas-index.md` to prioritize or resume work on which personas need the most attention or to detect new personas added, removed or renamed.  If the the `common/personas/personas-index.md` file is empty, create a new index file with a summary of all existing personas with the quality scores. 

---

## **Instructions**

For each persona:

1. **Verify Accuracy**

   - Cross-check all descriptions, skills, and context against current, real-world domain knowledge.
   - Remove or revise any outdated, misleading, or factually incorrect content.

2. **Assess Relevance**

   - Ensure every detail directly supports the persona’s role in AI-driven decision-making, interactions, or problem-solving.
   - Remove redundant or non-essential information.

3. **Enhance Detail**

   - Expand vague sections with specific goals, workflows, decision-making methods, and domain-relevant terminology.
   - Include concrete example scenarios where this persona would be applied.

4. **Optimize for AI Performance**

   - Ensure the description is unambiguous, structured, and machine-readable.
   - Use a consistent tone that matches the persona’s intended role.
   - Avoid subjective or overly creative phrasing that may cause unpredictable outputs.

5. **Consistency & Formatting**

   - Standardize field names, formatting, and structural order across all personas.
   - Follow the template file `common/personas/templates/personas-template.md`

6. **Scoring & Evaluation**

   - Rate each persona from 1–5 in the following categories:
     - **Accuracy**
     - **Relevance**
     - **Detail Completeness**
     - **AI Usability**
   - Identify which personas require the most improvement.

7. **Suggestions for Further Improvement**

   - After refining each persona, propose at least **3 actionable enhancements** to make it even more effective.

8. **Index Structure** 
   - Index is intended to aid in the quick retrieval and understanding of instruction files. 
   - Optimize structure to file path hierarchy under the instructions folder.
   - Output each file as in the following structure:
```markdown
# **File Name:** {folder-name}/{file-name}.md
**Score:** {Score}/5.0
**Summary:**{Summary}
**Keywords:** {Key words}
**Extensions:** {Extensions}
```
---

**Output Format:**

   - Update the refined persona files.
   - Track scoring, suggestions, and changes in a markdown file under `common/personas-CHANGES.md`.
   - Index files with summary and track quality scores under `common/personas/personas-index.md`.
