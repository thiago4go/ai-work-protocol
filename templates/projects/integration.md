---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: System integration project
---

# PROJECT: {{TITLE}}

## Goal
Connect {{SYSTEM_A}} with {{SYSTEM_B}} for {{PURPOSE}}

## Context
- **Data Flow**: {{SYSTEM_A}} → {{DATA_TYPE}} → {{SYSTEM_B}}
- **Volume**: {{EXPECTED_TRANSACTIONS}}/day, {{DATA_SIZE}}/transaction
- **Latency Requirements**: {{MAX_LATENCY}}ms

## Success Criteria
1. **Functional**: Data flows correctly end-to-end
2. **Reliable**: 99.9% uptime, automatic retry on failure
3. **Observable**: Monitoring, alerting, and debugging tools ready

## Integration Plan
- [ ] **Define Contract**: API spec, data schema, error codes (1 day)
- [ ] **Build Mock**: Fake integration for testing (1 day)
- [ ] **Implement Core**: Basic happy path working (2 days)
- [ ] **Add Resilience**: Retries, circuit breakers, backpressure (2 days)
- [ ] **Production Ready**: Monitoring, alerts, runbooks (1 day)

## Technical Design
- **Protocol**: {{REST/GraphQL/gRPC/Message Queue}}
- **Authentication**: {{AUTH_METHOD}}
- **Data Format**: {{JSON/XML/Protobuf}}
- **Error Handling**: {{RETRY_STRATEGY}}

## Constraints
- **No Downtime**: Must deploy without affecting either system
- **Backward Compatible**: Support existing integrations
- **Rate Limits**: Respect {{SYSTEM_B}} limit of {{RATE_LIMIT}}

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<integration_specific>
For INTEGRATION projects:
- Start with contract/interface definition
- Build with mocks before real systems
- Test failure modes extensively
- Add monitoring from day one
- Document everything (runbooks!)

<integration_queries>
Before starting:
```
# Find similar integrations
rag_memory___hybridSearch query="integration {{SYSTEM_A}} {{SYSTEM_B}}"
rag_memory___searchNodes query="type:project category:integration"

# Find common issues
rag_memory___searchNodes query="type:bug category:integration"
```
</integration_queries>

<integration_testing>
Must test:
- Happy path (normal flow)
- System A down
- System B down
- Network issues
- Malformed data
- Rate limit exceeded
- Auth failures
- Concurrent requests
</integration_testing>
</integration_specific>
---END-INSTRUCTIONS---