---
type: task
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Interactive Prototyping TASK with shadcn/ui components
parent_project: {{PARENT_PROJECT}}
---

# TASK: {{TITLE}}

## Summary
Build interactive prototype using shadcn/ui components with automated testing via Selenium.

## Context
- **Feature**: {{FEATURE_NAME}}
- **User Story**: As a {{USER_TYPE}}, I want to {{USER_GOAL}} so that {{USER_BENEFIT}}
- **Design Specs**: {{DESIGN_REFERENCE}}

## Pre-conditions
- [ ] Wireframes approved
- [ ] Shadcn/ui components identified
- [ ] Test scenarios defined

## Steps
1. **Component Research** #estimate:2h #status:pending
   - Use `mcp__shadcn-ui__list_shadcn_components` to explore options
   - Document component choices:
     ```
     rag_memory___createEntities entities=[{
       "name": "prototype_{{FEATURE}}_components",
       "type": "design_decision",
       "properties": {
         "components": ["button", "card", "form"],
         "rationale": "{{RATIONALE}}"
       }
     }]
     ```

2. **Build Layout Structure** #estimate:3h #status:pending
   - Create main container components
   - Implement responsive grid
   - Test on multiple viewports with Selenium

3. **Add Interactivity** #estimate:4h #status:pending
   - Wire up component interactions
   - Add state management
   - Implement form validations

4. **Visual Polish** #estimate:2h #status:pending
   - Apply theme customizations
   - Add animations/transitions
   - Ensure brand consistency

5. **Automated Testing Setup** #estimate:3h #status:pending
   - Create Selenium test script:
     ```javascript
     // Test user flow
     await mcp__selenium__start_browser({browser: "firefox"})
     await mcp__selenium__navigate({url: "localhost:3000"})
     await mcp__selenium__click_element({by: "css", value: "[data-testid='cta-button']"})
     await mcp__selenium__take_screenshot({outputPath: "tests/flow_step1.png"})
     ```
   - Document test results in RAG

6. **User Flow Documentation** #estimate:2h #status:pending
   - Record video walkthrough
   - Capture screenshots at each step
   - Create interaction map

## Definition of Done
- [ ] All components render correctly
- [ ] Interactions work as designed
- [ ] Responsive on all target devices
- [ ] Automated tests pass
- [ ] Screenshots captured and stored
- [ ] Design decisions documented in RAG

## Deliverables
- Working prototype URL
- Component documentation
- Test automation scripts
- Visual regression baseline
- User flow screenshots

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<task_specific>
For Prototyping tasks:
- Always start by researching existing shadcn components
- Build incrementally - layout first, then interactions
- Test each component in isolation before integration
- Use Selenium to verify all interactions work
- Document component customizations for reuse

Selenium Testing Pattern:
```bash
# For each major interaction:
1. Start browser session
2. Navigate to prototype
3. Execute user action
4. Capture screenshot
5. Verify expected result
6. Store evidence in RAG
```

Component Selection Pattern:
```bash
# For each UI need:
1. Search shadcn components: mcp__shadcn-ui__search_components
2. Get examples: mcp__shadcn-ui__get_component_examples
3. Test in isolation
4. Customize if needed
5. Document modifications
```
</task_specific>
---END-INSTRUCTIONS---