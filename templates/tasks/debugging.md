---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Systematic debugging task
---

# TASK: {{TITLE}}

## Objective & Value
**What**: Find why {{SYSTEM/FEATURE}} is {{PROBLEM_BEHAVIOR}}
**Why**: {{USER_IMPACT}}
**Done When**: Root cause identified + fix validated

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Symptoms**: {{WHAT_IS_BROKEN}}
- **Started**: {{WHEN_STARTED}}
- **Frequency**: {{HOW_OFTEN}}

## Debugging Strategy & RAG Queries
```
# Find similar issues
rag_memory___hybridSearch query="{{PROBLEM_BEHAVIOR}} {{SYSTEM}} debug"
rag_memory___searchNodes query="type:bug symptoms:{{SYMPTOMS}}"

# Check recent changes
rag_memory___hybridSearch query="{{SYSTEM}} recent changes commits"
```

## Steps
- [ ] Reproduce locally with minimal test case #status:pending #est:30m
- [ ] Binary search: Find last working version #status:pending #est:45m
- [ ] Isolate variables: What exactly triggers it? #status:pending #est:1h
- [ ] Form hypothesis → Test → Document results #status:pending #est:2h
- [ ] Implement fix → Verify → Add regression test #status:pending #est:1h

## Debug Toolkit
- **Logs**: Check {{LOG_LOCATION}} for patterns
- **Metrics**: Compare {{METRIC}} before/after
- **Git Bisect**: Between {{LAST_KNOWN_GOOD}} and {{FIRST_BROKEN}}
- **Debugger**: Breakpoints at {{KEY_FUNCTIONS}}

## Success Criteria & Gates
- **GATE 1** (after step 2): Can reproduce consistently?
- **GATE 2** (after step 3): Understand trigger conditions?
- **GATE 3** (after step 4): Have working hypothesis?
- **Output**: Root cause doc + tested fix

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<debugging_specific>
For DEBUGGING tasks:
- Reproduce before attempting fix
- Change one variable at a time
- Document failed hypotheses too
- Use binary search to isolate
- Keep debug log of what tried

<debugging_queries>
Essential queries:
```
# Find similar bugs
rag_memory___hybridSearch query="{{SYMPTOMS}} root cause fix"

# Find workarounds
rag_memory___searchNodes query="type:workaround component:{{SYSTEM}}"

# After finding cause, check for similar code
rag_memory___hybridSearch query="{{ROOT_CAUSE_PATTERN}} potential bugs"
```
</debugging_queries>

<debugging_antipatterns>
AVOID:
- Fixing symptoms not causes
- Making multiple changes at once
- Not documenting the journey
- Skipping regression test
</debugging_antipatterns>
</debugging_specific>
---END-INSTRUCTIONS---