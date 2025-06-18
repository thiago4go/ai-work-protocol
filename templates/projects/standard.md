---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Standard PROJECT template
---

# PROJECT: {{TITLE}}

## Goal
{{PROJECT_GOAL}}

## Context
- **Problem**: {{PROBLEM_DESCRIPTION}}
- **Solution**: {{PROPOSED_SOLUTION}}
- **Users**: {{TARGET_USERS}}

## Success Criteria
1. **Functionality**: {{CORE_FEATURE}} works for {{TARGET_USER}}
2. **Quality**: Zero critical bugs, <2s response time
3. **Adoption**: {{TARGET_USER}} can complete {{KEY_TASK}} without help

## Value-Driven Task Sequence
- [ ] **Discovery**: What's the smallest thing that proves value? (1-2 days)
- [ ] **MVP**: Build just that → Get feedback (2-3 days)
- [ ] **Iterate**: Fix top 3 issues from feedback (1-2 days)
- [ ] **Scale**: Only after MVP validated (2-3 days)
- [ ] **Polish**: Documentation, edge cases, performance (1-2 days)

## Constraints
- **Timeline**: {{TIMELINE}}
- **Resources**: {{RESOURCES}}
- **Dependencies**: {{DEPENDENCIES}}

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<project_specific>
For this PROJECT type:
- Focus on clear problem definition before solution
- Break down into discrete, testable features
- Each task should produce working code or clear decisions
</project_specific>
---END-INSTRUCTIONS---