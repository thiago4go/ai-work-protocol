---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Performance optimization project
---

# PROJECT: {{TITLE}}

## Goal
Make {{FEATURE/SYSTEM}} {{TARGET_MULTIPLIER}}x faster

## Context
- **Current Performance**: {{CURRENT_METRIC}} (P50/P95/P99)
- **Target Performance**: {{TARGET_METRIC}}
- **User Impact**: {{HOW_SLOWNESS_AFFECTS_USERS}}

## Success Criteria
1. **Speed**: Achieve {{TARGET_METRIC}} for {{USE_CASE}}
2. **Consistent**: P95 latency < {{P95_TARGET}}
3. **Sustainable**: No increase in resource usage/cost

## Optimization Strategy
- [ ] **Profile Current**: Where is time actually spent? (1 day)
- [ ] **Quick Wins**: Cache, indexes, obvious fixes (1 day)
- [ ] **Measure Impact**: Did quick wins help? How much? (0.5 day)
- [ ] **Deep Changes**: Algorithm/architecture if needed (2-3 days)
- [ ] **Validate**: Load test, measure, tune (1 day)

## Performance Baseline
- **Metric**: {{METRIC_NAME}}
- **Current P50**: {{CURRENT_P50}}
- **Current P95**: {{CURRENT_P95}}
- **Current P99**: {{CURRENT_P99}}

## Suspected Bottlenecks
1. {{BOTTLENECK_1}} - Impact: {{IMPACT_1}}
2. {{BOTTLENECK_2}} - Impact: {{IMPACT_2}}
3. {{BOTTLENECK_3}} - Impact: {{IMPACT_3}}

## Constraints
- **Budget**: Stay within current infrastructure costs
- **Compatibility**: Don't break existing functionality
- **Complexity**: Keep code maintainable

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<optimization_specific>
For OPTIMIZATION projects:
- MEASURE before optimizing
- Profile with real data/load
- Start with algorithmic improvements
- Optimize the right metric (user-facing)
- Document why each change helps

<optimization_queries>
Before starting:
```
# Find previous optimizations
rag_memory___hybridSearch query="optimization performance {{FEATURE}}"
rag_memory___searchNodes query="type:project category:optimization outcome:successful"

# Find performance patterns
rag_memory___hybridSearch query="performance bottleneck {{SUSPECTED_CAUSE}}"
```
</optimization_queries>

<optimization_rules>
1. Measure → Optimize → Measure
2. One change at a time
3. Keep old code (feature flag)
4. Load test with real patterns
5. Watch for edge cases getting slower
</optimization_rules>
</optimization_specific>
---END-INSTRUCTIONS---