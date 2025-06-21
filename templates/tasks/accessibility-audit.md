---
type: task
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Accessibility Audit TASK for WCAG compliance testing
parent_project: {{PARENT_PROJECT}}
---

# TASK: {{TITLE}}

## Summary
Comprehensive accessibility audit to ensure WCAG 2.1 compliance and inclusive design for all users.

## Context
- **Audit Scope**: {{PAGES_OR_FEATURES}}
- **Target Level**: WCAG 2.1 Level {{AA_OR_AAA}}
- **User Groups**: {{DISABILITY_CONSIDERATIONS}}
- **Legal Requirements**: {{COMPLIANCE_NEEDS}}

## Pre-conditions
- [ ] WCAG checklist prepared
- [ ] Testing tools installed
- [ ] Screen reader configured
- [ ] Keyboard testing ready

## Steps
1. **Automated Testing** #estimate:3h #status:pending
   - Run axe DevTools scan
   - Use Selenium for automated checks:
     ```javascript
     // Check focus indicators
     await mcp__selenium__press_key("Tab");
     const focused = await driver.switchTo().activeElement();
     await mcp__selenium__take_screenshot({
       outputPath: `a11y/focus_indicator_${elementName}.png`
     });
     
     // Test without mouse
     await driver.executeScript("document.body.style.cursor = 'none';");
     ```
   - Document violations by severity

2. **Keyboard Navigation** #estimate:2h #status:pending
   - Test all interactive elements
   - Verify tab order
   - Check skip links
   - Test keyboard traps:
     ```javascript
     // Systematic keyboard test
     const elements = await driver.findElements(By.css('a, button, input, select, textarea'));
     for (const element of elements) {
       await mcp__selenium__press_key("Tab");
       // Verify focus moved correctly
       const activeElement = await driver.switchTo().activeElement();
       // Check if element is reachable
     }
     ```

3. **Screen Reader Testing** #estimate:3h #status:pending
   - NVDA (Windows)
   - JAWS (Windows)
   - VoiceOver (Mac/iOS)
   - Document announcements:
     ```
     Page: "Welcome to GetCertifyToday, main navigation"
     Button: "Sign up, button"
     Form: "Contact form, 3 fields required"
     ```

4. **Visual Testing** #estimate:2h #status:pending
   - Color contrast ratios
   - Text sizing and zoom (up to 200%)
   - Focus indicators visibility
   - Motion and animation controls:
     ```javascript
     // Test with reduced motion
     await driver.executeScript(`
       window.matchMedia('(prefers-reduced-motion: reduce)').matches = true;
     `);
     await mcp__selenium__take_screenshot({
       outputPath: `a11y/reduced_motion_test.png`
     });
     ```

5. **Form Accessibility** #estimate:2h #status:pending
   - Label associations
   - Error message clarity
   - Required field indicators
   - Inline validation:
     ```javascript
     // Test form errors
     await mcp__selenium__click_element({by: "id", value: "submit"});
     // Check error announcement
     const errorText = await mcp__selenium__get_element_text({
       by: "css", 
       value: "[role='alert']"
     });
     ```

6. **Documentation & Fixes** #estimate:3h #status:pending
   - Create issue tickets by component
   - Prioritize by severity
   - Provide fix recommendations
   - Store audit results:
     ```
     rag_memory___createEntities entities=[{
       "name": "a11y_audit_{{DATE}}",
       "type": "ACCESSIBILITY_FINDING",
       "properties": {
         "wcagLevel": "AA",
         "criticalIssues": 3,
         "majorIssues": 7,
         "minorIssues": 12,
         "topIssues": [
           "Missing alt text",
           "Low contrast buttons",
           "No focus indicators"
         ],
         "passRate": "82%"
       }
     }]
     ```

## WCAG Checklist
### Perceivable
- [ ] Images have alt text
- [ ] Videos have captions
- [ ] Color not sole indicator
- [ ] Contrast ratios meet standards

### Operable
- [ ] Keyboard accessible
- [ ] No keyboard traps
- [ ] Skip links present
- [ ] Sufficient time limits

### Understandable
- [ ] Clear labels
- [ ] Consistent navigation
- [ ] Error identification
- [ ] Help available

### Robust
- [ ] Valid HTML
- [ ] ARIA used correctly
- [ ] Works with assistive tech

## Definition of Done
- [ ] All WCAG criteria tested
- [ ] Issues documented with severity
- [ ] Fix recommendations provided
- [ ] Remediation plan created
- [ ] Report delivered to team
- [ ] Findings stored in RAG

## Deliverables
- Accessibility audit report
- Issue tracker tickets
- Screenshot evidence
- Remediation timeline
- Automated test suite

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<task_specific>
For Accessibility Audit tasks:
- Test with real assistive technologies
- Include users with disabilities if possible
- Document everything - legal compliance matters
- Prioritize fixes by user impact
- Automate what you can for regression prevention

Testing Tools Setup:
```javascript
// Accessibility testing utilities
const a11yTest = {
  // Check element visibility
  isVisibleToScreenReader: async (selector) => {
    return await driver.executeScript(`
      const el = document.querySelector('${selector}');
      return !el.hasAttribute('aria-hidden') && 
             el.offsetWidth > 0 && 
             el.offsetHeight > 0;
    `);
  },
  
  // Get computed ARIA label
  getAccessibleName: async (selector) => {
    return await driver.executeScript(`
      const el = document.querySelector('${selector}');
      return el.getAttribute('aria-label') || 
             el.getAttribute('aria-labelledby') || 
             el.textContent;
    `);
  },
  
  // Check contrast ratio
  checkContrast: async (selector) => {
    // Use axe-core or similar
  }
};
```

Common A11y Issues:
1. **Critical**: Keyboard traps, missing form labels
2. **Major**: Low contrast, missing alt text
3. **Minor**: Missing landmarks, decorative images

Remember: Accessibility is not just compliance - it's about including everyone.
</task_specific>
---END-INSTRUCTIONS---