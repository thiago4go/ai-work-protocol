---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Implementation task template
---

# TASK: {{TITLE}}

## Objective & Value
**What**: {{IMPLEMENTATION_GOAL}}
**Why**: Enables {{TARGET_USER}} to {{USER_GOAL}}
**Done When**: User can {{SPECIFIC_ACTION}} without errors

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **User Story**: As {{TARGET_USER}}, I want to {{USER_GOAL}} so that {{BENEFIT}}
- **Deliverable**: Working code that {{MEASURABLE_OUTCOME}}

## Implementation Plan
- **Approach**: {{APPROACH}}
- **Dependencies**: {{DEPENDENCIES}}
- **Testing**: {{TEST_STRATEGY}}

## Steps
- [ ] Setup: Load design from RAG + verify dependencies #status:pending #est:20m
- [ ] Core logic: Implement main functionality (no edge cases) #status:pending #est:2h
- [ ] Happy path test: Verify basic functionality works #status:pending #est:30m
- [ ] Edge cases: Handle errors + validate inputs #status:pending #est:1h
- [ ] Integration: Connect to existing code + full test suite #status:pending #est:1h
- [ ] Polish: Refactor + document + commit working code #status:pending #est:30m

## Success Criteria
- Feature works as designed
- Tests pass
- Code is clean and documented
- User can use the feature

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<implementation_specific>
For IMPLEMENTATION tasks:
- Load design decisions before starting
- Follow existing code patterns
- Test each step before moving on
- Commit working code frequently
- Document technical debt immediately

<implementation_queries>
Before implementing:
```
# Load design and requirements
rag_memory___hybridSearch query="{{PARENT_PROJECT}} design architecture decisions"
rag_memory___searchNodes query="type:design parent:{{PARENT_PROJECT}}"
```

After each step:
```
# Record implementation details
rag_memory___createEntities entities=[{
  "name": "impl_step_{{TIMESTAMP}}",
  "type": "implementation_detail",
  "properties": {
    "feature": "[what built]",
    "pattern": "[pattern used]",
    "debt": "[any shortcuts]"
  }
}]
```
</implementation_queries>

<quality_gates>
Before completing task:
- All tests pass
- Code reviewed against standards
- No critical TODOs
- Performance validated
- Documentation complete
</quality_gates>
</implementation_specific>
---END-INSTRUCTIONS---