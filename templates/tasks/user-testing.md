---
type: task
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: User Testing TASK with Selenium automation support
parent_project: {{PARENT_PROJECT}}
---

# TASK: {{TITLE}}

## Summary
Conduct user testing to validate designs and identify usability issues using both manual and automated methods.

## Context
- **Test Type**: {{TEST_TYPE}} (moderated/unmoderated/automated)
- **Feature Under Test**: {{FEATURE_NAME}}
- **Target Users**: {{USER_DEMOGRAPHICS}}
- **Sample Size**: {{PARTICIPANT_COUNT}}

## Pre-conditions
- [ ] Prototype/product ready for testing
- [ ] Test scenarios defined
- [ ] Participant recruitment complete
- [ ] Testing environment prepared

## Steps
1. **Test Planning** #estimate:2h #status:pending
   - Define success metrics
   - Create test scenarios
   - Prepare test scripts
   - Set up recording tools:
     ```javascript
     // Selenium session recording setup
     const testSession = {
       participant: "user_001",
       startTime: Date.now(),
       screenshots: [],
       actions: []
     };
     ```

2. **Environment Setup** #estimate:1h #status:pending
   - Configure test URLs
   - Reset test data
   - Prepare Selenium automation:
     ```javascript
     await mcp__selenium__start_browser({browser: "firefox"});
     await mcp__selenium__navigate({url: testEnvironmentUrl});
     ```
   - Set up screen recording

3. **Pilot Testing** #estimate:2h #status:pending
   - Run through with internal user
   - Time each task
   - Identify setup issues
   - Refine test script

4. **User Sessions** #estimate:6h #status:pending
   - Welcome and briefing
   - Task execution with think-aloud
   - Capture with Selenium:
     ```javascript
     // Record each interaction
     testSession.actions.push({
       timestamp: Date.now(),
       action: "clicked",
       element: "signup-button",
       success: true
     });
     
     // Screenshot key moments
     await mcp__selenium__take_screenshot({
       outputPath: `tests/${participant}/task_${taskNum}.png`
     });
     ```
   - Post-test interview
   - Satisfaction survey

5. **Automated Testing** #estimate:3h #status:pending
   - Create Selenium scripts for common paths
   - Test error scenarios
   - Measure task completion times
   - Verify accessibility:
     ```javascript
     // Test keyboard navigation
     await mcp__selenium__press_key("Tab");
     await mcp__selenium__press_key("Enter");
     ```

6. **Analysis & Reporting** #estimate:4h #status:pending
   - Compile success rates
   - Identify failure patterns
   - Create highlight reel
   - Store findings:
     ```
     rag_memory___createEntities entities=[{
       "name": "user_test_{{DATE}}_{{FEATURE}}",
       "type": "USER_TEST_RESULT",
       "properties": {
         "participants": 8,
         "taskSuccess": "75%",
         "avgTime": "3m 45s",
         "issues": ["confusing CTA", "form validation unclear"],
         "recommendations": ["clarify button text", "inline validation"]
       }
     }]
     ```

## Test Scenarios
1. **Task 1**: {{TASK_DESCRIPTION}}
   - Success criteria: {{SUCCESS_METRIC}}
   - Time limit: {{TIME_LIMIT}}

2. **Task 2**: {{TASK_DESCRIPTION}}
   - Success criteria: {{SUCCESS_METRIC}}
   - Time limit: {{TIME_LIMIT}}

## Definition of Done
- [ ] All participants tested
- [ ] Data compiled and analyzed
- [ ] Issues prioritized by severity
- [ ] Recommendations documented
- [ ] Stakeholders briefed
- [ ] Findings stored in RAG

## Deliverables
- Test recordings/screenshots
- Findings report with severity ratings
- Recommendation priority list
- Success metrics summary
- Automated test scripts

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<task_specific>
For User Testing tasks:
- Keep sessions under 60 minutes
- Test one thing at a time
- Don't lead the participant
- Document everything, even small issues
- Use both qualitative and quantitative data

Testing Best Practices:
1. **Before Testing**:
   - Do pilot run to catch issues
   - Have backup participants
   - Prepare neutral prompts

2. **During Testing**:
   - Stay neutral - don't help unless stuck
   - Ask "What are you thinking?"
   - Note body language and frustration

3. **Automation Support**:
   ```javascript
   // Replay user paths automatically
   const replayUserJourney = async (journey) => {
     for (const action of journey) {
       switch(action.type) {
         case 'click':
           await mcp__selenium__click_element({
             by: action.by,
             value: action.selector
           });
           break;
         case 'type':
           await mcp__selenium__send_keys({
             by: action.by,
             value: action.selector,
             text: action.text
           });
           break;
       }
       // Screenshot after each action
       await mcp__selenium__take_screenshot({
         outputPath: `replay/${action.timestamp}.png`
       });
     }
   };
   ```

Common Issues to Watch:
- Confusing navigation
- Unclear CTAs
- Form validation problems
- Mobile touch target size
- Accessibility barriers
</task_specific>
---END-INSTRUCTIONS---