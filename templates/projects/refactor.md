---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Technical debt and refactoring project
---

# PROJECT: {{TITLE}}

## Goal
Improve {{SYSTEM_COMPONENT}} without changing external behavior

## Context
- **Tech Debt**: {{SPECIFIC_DEBT}}
- **Pain Points**: {{CURRENT_PROBLEMS}}
- **Impact**: Affects {{WHO_AFFECTED}} when {{WHEN_AFFECTED}}

## Success Criteria
1. **Performance**: {{METRIC}} improves by {{TARGET}}% (measure before/after)
2. **Maintainability**: {{SPECIFIC_IMPROVEMENT}} (e.g., reduce complexity from X to Y)
3. **No Regressions**: All existing tests pass + no new bugs

## Refactor Strategy
- [ ] **Measure Baseline**: Document current metrics + pain points (1 day)
- [ ] **Safety Net**: Create/improve test coverage to 80%+ (2 days)
- [ ] **Incremental Changes**: Refactor in small, safe steps (3-4 days)
- [ ] **Validate Each Step**: Run tests + check metrics (ongoing)
- [ ] **Document Changes**: Update docs + team knowledge (1 day)

## Constraints
- **No Breaking Changes**: API/behavior must remain identical
- **Incremental**: Must be able to stop at any point
- **Reversible**: Each change must be revertable

## Risk Mitigation
- Feature flag for gradual rollout
- Automated performance benchmarks
- Canary deployment strategy

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<refactor_specific>
For REFACTOR projects:
- Always measure before changing
- Create comprehensive tests FIRST
- Make smallest possible changes
- Commit after each green test run
- Document why, not just what

<refactor_queries>
Before starting:
```
# Find previous refactors
rag_memory___hybridSearch query="refactor {{SYSTEM_COMPONENT}} lessons learned"
rag_memory___searchNodes query="type:project category:refactor outcome:successful"

# Find related issues
rag_memory___searchNodes query="type:bug component:{{SYSTEM_COMPONENT}}"
```
</refactor_queries>

<refactor_antipatterns>
AVOID:
- Big bang refactors
- Refactoring without tests
- Changing behavior "while we're at it"
- Not measuring improvement
</refactor_antipatterns>
</refactor_specific>
---END-INSTRUCTIONS---