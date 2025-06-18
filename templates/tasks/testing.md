---
type: task
status: active
priority: high
parent_project: {{PARENT_PROJECT}}
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Test creation or improvement task
---

# TASK: {{TITLE}}

## Objective & Value
**What**: Add tests for {{COMPONENT/FEATURE}}
**Why**: Prevent {{SPECIFIC_REGRESSION}} + enable confident changes
**Done When**: Coverage >{{TARGET_COVERAGE}}% + edge cases tested

## Context
- **PROJECT**: {{PARENT_PROJECT}}
- **Current Coverage**: {{CURRENT_COVERAGE}}%
- **Test Framework**: {{FRAMEWORK}}
- **Focus**: {{UNIT/INTEGRATION/E2E}}

## Testing Strategy & RAG Queries
```
# Find test patterns
rag_memory___hybridSearch query="{{COMPONENT}} test patterns edge cases"
rag_memory___searchNodes query="type:test component:{{COMPONENT}}"

# Find bugs to prevent
rag_memory___searchNodes query="type:bug component:{{COMPONENT}} regression"
```

## Steps
- [ ] Map input space: List all possible inputs/states #status:pending #est:30m
- [ ] Happy paths: Basic success scenarios #status:pending #est:1h
- [ ] Edge cases: Boundaries, nulls, empty, huge #status:pending #est:1h
- [ ] Error paths: What should fail gracefully #status:pending #est:1h
- [ ] Performance tests: Add benchmarks if needed #status:pending #est:30m
- [ ] Run with coverage: Verify we hit targets #status:pending #est:20m

## Test Categories
**Unit Tests** ({{UNIT_TARGET}}% coverage)
- {{FUNCTION_1}}: Test {{BEHAVIOR_1}}
- {{FUNCTION_2}}: Test {{BEHAVIOR_2}}
- Edge: {{EDGE_CASE_1}}

**Integration Tests**
- {{WORKFLOW_1}}: Verify {{INTEGRATION_1}}
- {{WORKFLOW_2}}: Verify {{INTEGRATION_2}}

**E2E Tests** (only critical paths)
- {{USER_JOURNEY_1}}
- {{USER_JOURNEY_2}}

## Success Criteria
- **Coverage**: Reaches {{TARGET_COVERAGE}}%
- **Fast**: Unit tests run in <{{TIME_LIMIT}}
- **Reliable**: No flaky tests
- **Valuable**: Each test could catch real bugs

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<testing_specific>
For TESTING tasks:
- Test behavior, not implementation
- Name tests clearly: test_what_when_then
- One assertion per test preferred
- Mock external dependencies
- Test edge cases thoroughly

<testing_queries>
Essential queries:
```
# Find what breaks
rag_memory___hybridSearch query="{{COMPONENT}} common failures bugs"

# Find test examples
rag_memory___searchNodes query="type:test high_value examples"

# After writing tests
rag_memory___createEntities entities=[{
  "name": "test_suite_{{COMPONENT}}",
  "type": "test_suite",
  "properties": {
    "coverage": "{{FINAL_COVERAGE}}",
    "edge_cases": ["list", "of", "edges"],
    "prevents": ["regression1", "regression2"]
  }
}]
```
</testing_queries>

<testing_principles>
Good tests are:
- **Fast**: Run quickly
- **Isolated**: No dependencies
- **Repeatable**: Same result every time
- **Self-Validating**: Clear pass/fail
- **Timely**: Written with code
</testing_principles>
</testing_specific>
---END-INSTRUCTIONS---