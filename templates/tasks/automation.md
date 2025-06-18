---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Process automation task
---

# TASK: {{TITLE}}

## Objective & Value
**What**: Automate {{MANUAL_PROCESS}}
**Why**: Save {{TIME_SAVED}}/week + reduce {{ERROR_TYPE}} errors
**Done When**: Process runs without human intervention

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Current Process**: {{MANUAL_STEPS}} taking {{CURRENT_TIME}}
- **Target**: Reduce to {{TARGET_TIME}} with {{AUTOMATION_LEVEL}}% automation
- **Triggers**: {{WHEN_RUNS}}

## Automation Plan & RAG Queries
```
# Find similar automations
rag_memory___hybridSearch query="automate {{PROCESS_TYPE}} script workflow"
rag_memory___searchNodes query="type:automation category:{{PROCESS_TYPE}}"

# Find failure patterns
rag_memory___searchNodes query="type:automation_failure"
```

## Steps
- [ ] Document current manual process in detail #status:pending #est:30m
- [ ] Identify automation boundaries + exceptions #status:pending #est:30m
- [ ] Build core automation for happy path #status:pending #est:2h
- [ ] Add error handling + alerting #status:pending #est:1h
- [ ] Test with real data + edge cases #status:pending #est:1h
- [ ] Create runbook for failures #status:pending #est:30m

## Process Mapping
**Current Manual Steps**:
1. {{MANUAL_STEP_1}} → Automate via {{METHOD_1}}
2. {{MANUAL_STEP_2}} → Automate via {{METHOD_2}}
3. {{MANUAL_STEP_3}} → Automate via {{METHOD_3}}

**Exceptions Requiring Human**:
- {{EXCEPTION_1}}
- {{EXCEPTION_2}}

## Success Metrics
- **Time**: From {{CURRENT_TIME}} to {{TARGET_TIME}}
- **Accuracy**: Error rate from {{CURRENT_ERROR}}% to <{{TARGET_ERROR}}%
- **Reliability**: Runs successfully {{SUCCESS_TARGET}}% of time
- **ROI**: Pays back in {{PAYBACK_PERIOD}}

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<automation_specific>
For AUTOMATION tasks:
- Map process completely first
- Start simple, enhance iteratively  
- Plan for failures from day one
- Make it observable (logs/metrics)
- Document for operators

<automation_queries>
Key queries:
```
# Find automation patterns
rag_memory___hybridSearch query="automation patterns {{TOOL/LANGUAGE}}"

# Find common failures
rag_memory___searchNodes query="type:automation_failure reason:*"

# Store automation details
rag_memory___createEntities entities=[{
  "name": "automation_{{PROCESS}}",
  "type": "automation",
  "properties": {
    "saves_time": "{{TIME_SAVED}}/week",
    "handles": ["case1", "case2"],
    "fails_on": ["exception1", "exception2"],
    "runbook": "link_to_runbook"
  }
}]
```
</automation_queries>

<automation_checklist>
Before going live:
- [ ] Handles all common cases
- [ ] Fails gracefully
- [ ] Alerts on failures
- [ ] Easy to pause/resume
- [ ] Runbook complete
- [ ] Rollback plan ready
</automation_checklist>
</automation_specific>
---END-INSTRUCTIONS---