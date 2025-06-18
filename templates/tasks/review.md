---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Code or design review task
---

# TASK: {{TITLE}}

## Objective & Value
**What**: Review {{WHAT_TO_REVIEW}} for {{PURPOSE}}
**Why**: Ensure {{QUALITY_ASPECT}} before {{DEADLINE}}
**Done When**: Feedback provided + critical issues resolved

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Type**: {{CODE/DESIGN/ARCHITECTURE}} review
- **Scope**: {{FILES/COMPONENTS/SYSTEMS}}
- **Author**: {{AUTHOR}}

## Review Focus & RAG Queries
```
# Find standards and patterns
rag_memory___hybridSearch query="{{COMPONENT}} coding standards patterns"
rag_memory___searchNodes query="type:standard category:{{REVIEW_TYPE}}"

# Find common issues
rag_memory___searchNodes query="type:review_finding component:{{COMPONENT}}"
```

## Steps
- [ ] Understand context: Why was this built? #status:pending #est:20m
- [ ] Functionality: Does it meet requirements? #status:pending #est:45m
- [ ] Edge cases: What could break this? #status:pending #est:45m
- [ ] Quality: Performance, security, maintainability #status:pending #est:1h
- [ ] Document findings + discuss with author #status:pending #est:30m

## Review Checklist
**Functionality**
- [ ] Solves stated problem
- [ ] Handles error cases
- [ ] Has appropriate tests

**Code Quality**
- [ ] Follows team standards
- [ ] Clear naming and structure
- [ ] No obvious performance issues

**Security**
- [ ] Input validation
- [ ] Auth/permissions correct
- [ ] No sensitive data exposed

## Success Criteria
- **Must Fix**: All blockers addressed
- **Should Fix**: Plan for important issues
- **Documented**: Review feedback in writing

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<review_specific>
For REVIEW tasks:
- Understand intent before critiquing
- Focus on significant issues
- Provide specific examples
- Suggest improvements, not just problems
- Be constructive and respectful

<review_queries>
Key queries:
```
# Find team standards
rag_memory___searchNodes query="type:standard team:{{TEAM}}"

# Find similar reviews
rag_memory___hybridSearch query="review {{COMPONENT}} feedback findings"

# After review, store learnings
rag_memory___createEntities entities=[{
  "name": "review_finding_{{DATE}}",
  "type": "review_finding",
  "properties": {
    "issue": "[what found]",
    "impact": "[why matters]",
    "pattern": "[is this common?]"
  }
}]
```
</review_queries>

<review_output_format>
Structure feedback as:
1. **Overall**: General impression
2. **Must Fix**: Blockers
3. **Should Fix**: Important improvements  
4. **Consider**: Nice-to-haves
5. **Good**: What worked well
</review_output_format>
</review_specific>
---END-INSTRUCTIONS---