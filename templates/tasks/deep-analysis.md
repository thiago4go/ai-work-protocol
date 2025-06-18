---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Deep analysis task with 5W1H framework and comprehensive research
---

# TASK: {{TITLE}}

## Objective
**Goal**: {{ANALYSIS_GOAL}}
**Success**: Comprehensive understanding with actionable insights
**Deliverable**: Detailed analysis report with recommendations

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Phase**: Deep Analysis/Research
- **Value**: Thorough understanding before implementation

## Research Foundation
- **What**: {{WHAT_ANALYZING}}
- **Why**: {{WHY_IMPORTANT}}
- **Who**: {{WHO_STAKEHOLDERS}}
- **When**: {{WHEN_TIMELINE}}
- **Where**: {{WHERE_SCOPE}}
- **How**: 5W1H + RAG + Web Research methodology

## Steps (Validate every 3)

- [ ] STEP 1: Explore File System & Document Structure #status:pending
  - **Foundation (5W1H)**:
    - What: Map relevant directories and files
    - Why: Understand existing codebase/documentation
    - How: `tree -L 3`, `find . -name "*.md"`, `grep -r "pattern"`
  - **RAG Queries**:
    1. `rag_memory___hybridSearch query="{{TITLE}} existing documentation"`
    2. `rag_memory___hybridSearch query="project structure conventions"`
    3. `rag_memory___hybridSearch query="similar analysis patterns"`
  - **Web Search**: 
    1. `"{{TECH_STACK}} project structure best practices 2025"` (fetch 3 sources)
    2. `"documentation standards for {{PROJECT_TYPE}}"` (fetch 3 sources)
  - **Deliverable**: Directory map and file inventory in CURRENT_IMPLEMENTATION.md

- [ ] STEP 2: Analyze Core Components #status:pending
  - **Foundation (5W1H)**:
    - What: {{COMPONENT_TO_ANALYZE}}
    - Why: {{ANALYSIS_REASON}}
    - How: Read files, trace dependencies, understand flow
  - **RAG Queries**:
    1. `rag_memory___hybridSearch query="{{COMPONENT}} architecture patterns"`
    2. `rag_memory___hybridSearch query="{{COMPONENT}} implementation examples"`
    3. `rag_memory___hybridSearch query="{{COMPONENT}} common issues"`
  - **Web Search**:
    1. `"{{COMPONENT}} best practices 2025"` (fetch 3 sources)
    2. `"{{COMPONENT}} performance optimization"` (fetch 3 sources)
  - **Deliverable**: Component analysis document with diagrams

- [ ] STEP 3: Synthesize Findings & Patterns #status:pending
  - **Foundation (5W1H)**:
    - What: Patterns and insights from analysis
    - Why: Create actionable recommendations
    - How: Compare findings, identify gaps, propose solutions
  - **RAG Queries**:
    1. `rag_memory___hybridSearch query="synthesis techniques for technical analysis"`
    2. `rag_memory___hybridSearch query="{{DOMAIN}} decision frameworks"`
    3. `rag_memory___hybridSearch query="technical recommendation templates"`
  - **Web Search**:
    1. `"technical decision records {{TECH_STACK}} 2025"` (fetch 3 sources)
    2. `"{{PROBLEM_DOMAIN}} solution patterns"` (fetch 3 sources)
  - **Deliverable**: Synthesis report with clear recommendations

- [ ] **VALIDATION**: Review analysis completeness → All questions answered? → Actionable insights?

- [ ] STEP 4: Create Knowledge Artifacts #status:pending
  - **Foundation (5W1H)**:
    - What: Entities, relationships, and documentation
    - Why: Preserve knowledge for future use
    - How: RAG storage, entity creation, relationship mapping
  - **Actions**:
    ```bash
    # Store analysis document
    rag_memory___storeDocument id="analysis_{{TITLE}}" content="[synthesis]"
    rag_memory___chunkDocument documentId="analysis_{{TITLE}}"
    rag_memory___embedChunks documentId="analysis_{{TITLE}}"
    
    # Create entities for key concepts
    rag_memory___createEntities entities=[
      {"name": "{{KEY_CONCEPT_1}}", "type": "concept", "properties": {...}},
      {"name": "{{KEY_CONCEPT_2}}", "type": "pattern", "properties": {...}}
    ]
    
    # Build relationships
    rag_memory___createRelations relations=[
      {"from": "{{CONCEPT_1}}", "to": "{{CONCEPT_2}}", "type": "implements"}
    ]
    ```
  - **Deliverable**: Knowledge graph with entities and relationships

## Outcomes
- **User**: Clear understanding and actionable plan
- **Business**: Informed decisions based on thorough analysis
- **Technical**: Documented patterns and reusable knowledge

## Pivot Triggers
- Cannot access necessary files/documentation
- Analysis reveals fundamentally different problem
- Time investment exceeds value

---INSTRUCTIONS---
<deep_analysis_protocol>

<methodology>
Every step MUST follow this pattern:
1. **Foundation**: Use 5W1H to establish clear context
2. **RAG Research**: 3 queries minimum for existing knowledge
3. **Web Research**: 2 searches, fetch and read 3 sources each
4. **Synthesis**: Assimilate findings into coherent insights
5. **Storage**: Create entities and relationships in RAG
</methodology>

<execution_pattern>
For EACH step:
```bash
# 1. Explore (What/Where)
tree -L 3 relevant/directory
find . -name "*.relevant" -type f
grep -r "pattern" --include="*.md"

# 2. RAG Query (Why/How from memory)
rag_memory___hybridSearch query="[step-specific query]"
rag_memory___getDetailedContext chunkIds=[...]

# 3. Web Research (Why/How from external)
rag_memory___webSearch query="[topic] best practices 2025"
# Fetch and analyze top 3 results

# 4. Document (deliverable)
# Update CURRENT_IMPLEMENTATION.md with findings

# 5. Store Knowledge
rag_memory___createEntities entities=[{...}]
rag_memory___createRelations relations=[{...}]
```
</execution_pattern>

<quality_checks>
Before marking step complete:
- Did you use 5W1H framework?
- Did you run 3 RAG queries?
- Did you perform 2 web searches?
- Did you read 3 sources per search?
- Did you create entities/relationships?
- Is the deliverable clear and actionable?
</quality_checks>

<remember>
This template is for DEEP understanding, not quick implementation.
Take time to research thoroughly - the insights guide everything else.
</remember>

</deep_analysis_protocol>
---END-INSTRUCTIONS---