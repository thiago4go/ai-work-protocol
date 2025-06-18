---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Research spike or investigation project
---

# PROJECT: {{TITLE}}

## Goal
Answer: {{KEY_QUESTION}}

## Context
- **Unknown**: {{WHAT_WE_DONT_KNOW}}
- **Why It Matters**: {{BUSINESS_IMPACT}}
- **Decisions Blocked**: {{WAITING_DECISIONS}}

## Success Criteria
1. **Clear Answer**: Definitive yes/no/recommendation on {{KEY_QUESTION}}
2. **Evidence**: Data, benchmarks, or POC supporting conclusion
3. **Actionable**: Clear next steps with effort estimates

## Investigation Plan
- [ ] **Form Hypotheses**: List 3 possible answers + implications (0.5 day)
- [ ] **Design Experiments**: How to test each hypothesis (0.5 day)
- [ ] **Gather Evidence**: Run experiments, collect data (2-3 days)
- [ ] **Analyze Results**: Compare findings, identify patterns (1 day)
- [ ] **Document Decision**: Clear recommendation + rationale (0.5 day)

## Hypotheses to Test
1. **H1**: {{HYPOTHESIS_1}} → Test by: {{TEST_METHOD_1}}
2. **H2**: {{HYPOTHESIS_2}} → Test by: {{TEST_METHOD_2}}
3. **H3**: {{HYPOTHESIS_3}} → Test by: {{TEST_METHOD_3}}

## Constraints
- **Timebox**: Max {{MAX_DAYS}} days (spike, not production)
- **Scope**: Answer the question, don't build the solution
- **Output**: Decision document, not working code

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<investigation_specific>
For INVESTIGATION projects:
- Define success as "question answered" not "code built"
- Timebox ruthlessly - perfect answer too late has no value
- Document negative results (what doesn't work is valuable)
- Create artifacts (benchmarks, POCs) for future reference
- Focus on decision enablement

<investigation_queries>
Before starting:
```
# Find similar investigations
rag_memory___hybridSearch query="investigation {{KEY_QUESTION}} spike research"
rag_memory___searchNodes query="type:project category:investigation"

# Find prior art
rag_memory___hybridSearch query="{{TECHNOLOGY}} evaluation comparison"
```
</investigation_queries>

<investigation_outputs>
Must produce:
1. Decision matrix comparing options
2. POC code (if applicable) 
3. Benchmark data
4. Recommendation with confidence level
5. Effort estimates for each option
</investigation_outputs>
</investigation_specific>
---END-INSTRUCTIONS---