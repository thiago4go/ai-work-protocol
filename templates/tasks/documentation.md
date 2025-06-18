---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Documentation creation task
---

# TASK: {{TITLE}}

## Objective & Value
**What**: Document {{SYSTEM/FEATURE}} for {{AUDIENCE}}
**Why**: Enable {{AUDIENCE}} to {{USER_GOAL}} independently
**Done When**: {{AUDIENCE}} successfully completes {{TASK}} using only docs

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Audience**: {{TECHNICAL_LEVEL}} users who need to {{USE_CASE}}
- **Format**: {{README/API/TUTORIAL/GUIDE}}
- **Location**: {{WHERE_PUBLISHED}}

## Documentation Plan & RAG Queries
```
# Find existing docs to reference
rag_memory___hybridSearch query="{{SYSTEM}} documentation examples"
rag_memory___searchNodes query="type:documentation audience:{{AUDIENCE}}"

# Find common questions
rag_memory___searchNodes query="type:support_ticket component:{{SYSTEM}}"
```

## Steps
- [ ] Outline: List all questions docs must answer #status:pending #est:30m
- [ ] Quick Start: Minimal working example #status:pending #est:1h
- [ ] Core Concepts: Explain key ideas simply #status:pending #est:1h
- [ ] Reference: Complete API/configuration #status:pending #est:2h
- [ ] Troubleshooting: Common issues + solutions #status:pending #est:1h
- [ ] Test: Have someone follow the docs #status:pending #est:30m

## Documentation Structure
1. **Overview**: What is this? (1 paragraph)
2. **Quick Start**: Copy-paste to success (5 min)
3. **Concepts**: Mental model needed
4. **How-To**: Common tasks step-by-step
5. **Reference**: Every option explained
6. **Troubleshooting**: When things go wrong

## Success Criteria & Gates
- **GATE 1**: Can newcomer get started in <15 min?
- **GATE 2**: Are all parameters documented?
- **GATE 3**: Do examples actually work?
- **Output**: Published docs + positive test feedback

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<documentation_specific>
For DOCUMENTATION tasks:
- Write for your audience's level
- Show, don't just tell (examples!)
- Test every code sample
- Include "why" not just "how"
- Add diagrams where helpful

<documentation_queries>
Key queries:
```
# Find what confuses users
rag_memory___hybridSearch query="{{SYSTEM}} confusion question help"

# Find good doc examples
rag_memory___searchNodes query="type:documentation rating:high"

# Store doc feedback
rag_memory___createEntities entities=[{
  "name": "doc_feedback_{{DATE}}",
  "type": "documentation_feedback",
  "properties": {
    "helpful": "[what worked]",
    "confusing": "[what didn't]",
    "missing": "[what to add]"
  }
}]
```
</documentation_queries>

<documentation_checklist>
Every doc needs:
- [ ] Clear purpose statement
- [ ] Working examples
- [ ] Common pitfalls section
- [ ] Links to related docs
- [ ] Update date
</documentation_checklist>
</documentation_specific>
---END-INSTRUCTIONS---