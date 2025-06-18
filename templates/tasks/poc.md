---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Proof of concept task
---

# TASK: {{TITLE}}

## Objective & Value
**What**: Prove {{CONCEPT/APPROACH}} is feasible
**Why**: De-risk before committing to full implementation
**Done When**: Clear yes/no answer with working prototype

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Risk**: {{WHAT_WERE_UNSURE_ABOUT}}
- **Investment**: {{WHAT_FULL_IMPLEMENTATION_COSTS}}
- **Alternative**: {{WHAT_HAPPENS_IF_NOT_FEASIBLE}}

## POC Scope & RAG Queries
```
# Find similar POCs
rag_memory___hybridSearch query="POC {{CONCEPT}} feasibility prototype"
rag_memory___searchNodes query="type:poc outcome:*"

# Find technical constraints
rag_memory___hybridSearch query="{{TECHNOLOGY}} limitations constraints"
```

## Steps
- [ ] Define success criteria: What proves it works? #status:pending #est:30m
- [ ] Minimal setup: Simplest test environment #status:pending #est:30m
- [ ] Core technical challenge: Can we {{KEY_CHALLENGE}}? #status:pending #est:2h
- [ ] Performance check: Fast enough for {{USE_CASE}}? #status:pending #est:1h
- [ ] Integration test: Works with {{EXISTING_SYSTEM}}? #status:pending #est:1h
- [ ] Document findings + demo #status:pending #est:30m

## Proof Points
**Must Prove**:
1. **Technical**: {{TECHNICAL_REQUIREMENT}} is achievable
2. **Performance**: Can handle {{LOAD_REQUIREMENT}}
3. **Integration**: Compatible with {{SYSTEM}}

**Out of Scope** (for now):
- Production readiness
- Error handling  
- Security hardening
- Full test coverage

## Success Criteria
- **Go Decision**: All proof points demonstrated
- **No-Go Decision**: Clear blocker identified
- **Pivot Decision**: Partial success, try {{ALTERNATIVE}}

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<poc_specific>
For POC tasks:
- Timebox ruthlessly
- Focus on biggest risk first
- Quick and dirty is OK
- Document what won't work too
- Keep code throwaway

<poc_queries>
Essential queries:
```
# Find similar attempts
rag_memory___hybridSearch query="{{CONCEPT}} attempted failed succeeded"

# After POC completes
rag_memory___createEntities entities=[{
  "name": "poc_{{CONCEPT}}",
  "type": "poc_result",
  "properties": {
    "feasible": true/false,
    "blockers": ["list", "of", "issues"],
    "performance": "{{METRICS}}",
    "effort_estimate": "{{DAYS_FOR_REAL}}",
    "demo_link": "{{URL}}"
  }
}]
```
</poc_queries>

<poc_deliverables>
Must produce:
1. Working demo (video/live)
2. Yes/no recommendation
3. List of technical blockers (if any)
4. Effort estimate for real implementation
5. Alternative approaches (if needed)
</poc_deliverables>
</poc_specific>
---END-INSTRUCTIONS---