---
type: task
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Visual Regression Testing TASK using Selenium MCP
parent_project: {{PARENT_PROJECT}}
---

# TASK: {{TITLE}}

## Summary
Implement visual regression testing to catch unintended UI changes using Selenium automation.

## Context
- **Test Scope**: {{TEST_SCOPE}}
- **Baseline Version**: {{BASELINE_VERSION}}
- **Critical Paths**: {{CRITICAL_USER_PATHS}}

## Pre-conditions
- [ ] Selenium MCP available
- [ ] Baseline screenshots exist or need creation
- [ ] Test environments accessible

## Steps
1. **Setup Test Environment** #estimate:1h #status:pending
   - Configure Selenium browser options
   - Set consistent viewport sizes
   - Define screenshot directories:
     ```bash
     mkdir -p visual-tests/baseline
     mkdir -p visual-tests/current
     mkdir -p visual-tests/diff
     ```

2. **Create/Update Baseline** #estimate:3h #status:pending
   - Capture baseline screenshots:
     ```javascript
     const pages = ["home", "dashboard", "settings"];
     for (const page of pages) {
       await mcp__selenium__navigate({url: `${baseUrl}/${page}`});
       await mcp__selenium__take_screenshot({
         outputPath: `visual-tests/baseline/${page}.png`
       });
     }
     ```
   - Store baseline metadata in RAG

3. **Implement Test Suite** #estimate:4h #status:pending
   - Create reusable test functions
   - Add wait conditions for dynamic content
   - Handle responsive breakpoints:
     ```javascript
     const viewports = [
       {width: 375, height: 667},   // Mobile
       {width: 768, height: 1024},  // Tablet
       {width: 1920, height: 1080}  // Desktop
     ];
     ```

4. **Run Regression Tests** #estimate:2h #status:pending
   - Execute test suite
   - Capture current state screenshots
   - Compare with baselines
   - Generate diff reports

5. **Document Findings** #estimate:2h #status:pending
   - Categorize differences:
     - Intentional changes ✅
     - Regressions 🚨
     - Improvements 📈
   - Store results in RAG:
     ```
     rag_memory___createEntities entities=[{
       "name": "visual_test_{{DATE}}",
       "type": "test_result",
       "properties": {
         "passed": false,
         "regressions": ["header spacing", "button colors"],
         "screenshots": ["diff/header.png", "diff/buttons.png"]
       }
     }]
     ```

6. **Update Test Coverage** #estimate:1h #status:pending
   - Add tests for new features
   - Remove obsolete tests
   - Update documentation

## Definition of Done
- [ ] All critical paths have visual tests
- [ ] Baseline screenshots are current
- [ ] Test suite runs automatically
- [ ] Differences are documented
- [ ] No unintended regressions
- [ ] Results stored in RAG

## Deliverables
- Visual test suite scripts
- Baseline screenshot library
- Regression test reports
- Coverage documentation
- CI/CD integration plan

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<task_specific>
For Visual Regression tasks:
- Always test multiple viewports
- Include hover/focus states
- Test both light/dark themes if applicable
- Document why each baseline was approved
- Keep history of visual changes in RAG

Critical Testing Areas:
1. Navigation elements
2. Form components
3. Data displays
4. Call-to-action buttons
5. Modal/dialog states
6. Error messages
7. Loading states

Selenium Best Practices:
```javascript
// Wait for content before screenshot
await mcp__selenium__find_element({
  by: "css",
  value: "[data-loaded='true']",
  timeout: 5000
});

// Consistent screenshot naming
`${component}_${viewport}_${state}_${theme}.png`

// Example: button_mobile_hover_dark.png
```

RAG Storage Pattern:
- Store test results immediately
- Link screenshots to test runs
- Track regression patterns over time
- Query historical data for trends
</task_specific>
---END-INSTRUCTIONS---