---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Bug fixing project
---

# PROJECT: {{TITLE}}

## Goal
Fix: {{BUG_DESCRIPTION}}

## Context
- **Severity**: {{SEVERITY_LEVEL}} - {{USERS_AFFECTED}} users affected
- **Symptoms**: {{WHAT_USERS_SEE}}
- **First Reported**: {{WHEN_STARTED}}
- **Frequency**: {{HOW_OFTEN}}

## Success Criteria
1. **Fixed**: Bug no longer reproducible with original steps
2. **Tested**: Automated test prevents regression
3. **Root Cause**: Documented to prevent similar bugs

## Fix Strategy
- [ ] **Reproduce Reliably**: Document exact steps (0.5 day)
- [ ] **Isolate Root Cause**: Debug to find actual problem (1-2 days)
- [ ] **Implement Fix**: Minimal change that solves issue (1 day)
- [ ] **Add Regression Test**: Automated test for this case (0.5 day)
- [ ] **Verify Fix**: Test in multiple scenarios (0.5 day)

## Bug Details
- **Steps to Reproduce**:
  1. {{STEP_1}}
  2. {{STEP_2}}
  3. {{STEP_3}}
- **Expected**: {{EXPECTED_BEHAVIOR}}
- **Actual**: {{ACTUAL_BEHAVIOR}}

## Constraints
- **Minimal Change**: Fix only this bug, no "improvements"
- **Backward Compatible**: Don't break existing functionality
- **Performance**: Fix shouldn't degrade performance

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<bugfix_specific>
For BUGFIX projects:
- Reproduce before attempting fix
- Find root cause, not just symptoms
- Write test that fails before fix
- Make minimal necessary change
- Document for future prevention

<bugfix_queries>
Before starting:
```
# Find similar bugs
rag_memory___hybridSearch query="bug {{SYMPTOMS}} {{COMPONENT}}"
rag_memory___searchNodes query="type:bug status:fixed similar:{{BUG_DESCRIPTION}}"

# Find related code changes
rag_memory___hybridSearch query="{{COMPONENT}} recent changes commits"
```
</bugfix_queries>

<bugfix_checklist>
Before marking complete:
- [ ] Original reporter confirms fix
- [ ] No new bugs introduced
- [ ] Test covers the exact case
- [ ] Root cause documented
- [ ] Similar code reviewed
</bugfix_checklist>
</bugfix_specific>
---END-INSTRUCTIONS---