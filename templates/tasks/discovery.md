---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Research and discovery task template
---

# TASK: {{TITLE}}

## Objective
{{TASK_OBJECTIVE}}

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Purpose**: Understanding the problem before building
- **Deliverable**: Clear approach and recommendations

## Research Plan & RAG Queries
```
# Find similar problems & solutions
rag_memory___hybridSearch query="{{TITLE}} problem solution pattern"
rag_memory___searchNodes query="type:discovery outcome:successful similar:{{TITLE}}"

# Find failures to avoid
rag_memory___searchNodes query="type:blocker category:{{RESEARCH_TOPIC}}"
```

## Steps
- [ ] Query RAG for "{{TITLE}}" patterns → Document what exists #status:pending #est:30m
- [ ] Define problem constraints → List must-haves vs nice-to-haves #status:pending #est:45m
- [ ] Research 2-3 solution approaches → Create comparison matrix #status:pending #est:1h
- [ ] Test riskiest assumption → Validate feasibility #status:pending #est:1h
- [ ] Document decision + rationale → Update project with clear next steps #status:pending #est:30m

## Success Criteria & Decision Gates
- **GATE 1** (after step 2): Can we clearly state the problem in 1 sentence?
- **GATE 2** (after step 3): Do we have 2+ viable approaches?
- **GATE 3** (after step 4): Is the risk acceptable? (Go/No-Go)
- **Output**: Decision doc with rationale + next task ready to create

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<discovery_specific>
For DISCOVERY tasks:
- Heavy RAG querying before each step
- Document ALL findings, even negative results
- Create entities for key discoveries
- Link findings to project goals
- If no prior art found, document that explicitly

<discovery_queries>
Essential queries for this task type:
```
# Before starting
rag_memory___hybridSearch query="{{RESEARCH_TOPIC}} existing implementations"
rag_memory___searchNodes query="type:solution category:{{RESEARCH_TOPIC}}"

# For each finding
rag_memory___createEntities entities=[{
  "name": "finding_{{TIMESTAMP}}",
  "type": "discovery",
  "properties": {"insight": "[what learned]", "source": "[where found]"}
}]
```
</discovery_queries>

<discovery_validation>
After 3 steps, validate:
- Is the problem well-defined?
- Do we have 2+ solution approaches?
- Are risks identified?
- Is there enough info to proceed?
</discovery_validation>
</discovery_specific>
---END-INSTRUCTIONS---