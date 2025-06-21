---
type: task
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Style Guide Documentation TASK for design system consistency
parent_project: {{PARENT_PROJECT}}
---

# TASK: {{TITLE}}

## Summary
Create comprehensive style guide documentation to ensure design consistency across all products and teams.

## Context
- **Brand Guidelines**: {{BRAND_REFERENCE}}
- **Target Audience**: {{DEVELOPERS_DESIGNERS_PMS}}
- **Scope**: {{VISUAL_COMPONENTS_PATTERNS}}
- **Format**: {{WEB_PDF_FIGMA}}

## Pre-conditions
- [ ] Design system defined
- [ ] Components built
- [ ] Brand assets collected
- [ ] Shadcn/ui customizations documented

## Steps
1. **Foundation Documentation** #estimate:3h #status:pending
   - Color palette with use cases:
     ```javascript
     // Capture color swatches
     const colors = ['primary', 'secondary', 'accent', 'neutral'];
     for (const color of colors) {
       await mcp__selenium__navigate({url: `${styleGuideUrl}#colors`});
       await mcp__selenium__take_screenshot({
         outputPath: `style-guide/colors_${color}.png`
       });
     }
     ```
   - Typography scale and usage
   - Spacing system (4px/8px grid)
   - Border radius, shadows, elevation

2. **Component Catalog** #estimate:4h #status:pending
   - Inventory all UI components
   - Document shadcn/ui customizations:
     ```bash
     # Get component details
     mcp__shadcn-ui__get_component_details componentName="button"
     mcp__shadcn-ui__get_component_examples componentName="button"
     ```
   - Show all variants and states
   - Include do's and don'ts

3. **Pattern Library** #estimate:3h #status:pending
   - Common UI patterns (forms, cards, navigation)
   - Interaction patterns
   - Responsive behaviors
   - Error handling patterns

4. **Visual Examples** #estimate:4h #status:pending
   - Create live examples
   - Screenshot all variations:
     ```javascript
     // Capture component states
     const states = ['default', 'hover', 'active', 'disabled'];
     for (const state of states) {
       // Trigger state
       if (state === 'hover') {
         await mcp__selenium__hover({by: "css", value: ".btn-primary"});
       }
       await mcp__selenium__take_screenshot({
         outputPath: `style-guide/button_${state}.png`
       });
     }
     ```
   - Before/after comparisons
   - Real-world usage examples

5. **Code Guidelines** #estimate:2h #status:pending
   - CSS/Tailwind conventions
   - Component usage patterns
   - Naming conventions
   - Example implementations:
     ```tsx
     // ✅ DO: Use semantic variants
     <Button variant="primary" size="lg">
       Get Started
     </Button>
     
     // ❌ DON'T: Override with inline styles
     <Button style={{background: 'blue'}}>
       Get Started
     </Button>
     ```

6. **Documentation Site** #estimate:3h #status:pending
   - Build interactive guide
   - Add search functionality
   - Version control
   - Store in RAG:
     ```
     rag_memory___createEntities entities=[{
       "name": "style_guide_v{{VERSION}}",
       "type": "DESIGN_SYSTEM",
       "properties": {
         "version": "1.0.0",
         "components": ["buttons", "forms", "cards"],
         "lastUpdated": "{{DATE}}",
         "changes": ["added dark mode", "updated colors"]
       }
     }]
     ```

## Style Guide Sections
1. **Introduction**
   - Design principles
   - How to use this guide

2. **Foundations**
   - Colors
   - Typography
   - Spacing
   - Icons

3. **Components**
   - Buttons
   - Forms
   - Navigation
   - Data display

4. **Patterns**
   - Page layouts
   - Common flows
   - Responsive patterns

5. **Resources**
   - Design files
   - Code snippets
   - Tools & plugins

## Definition of Done
- [ ] All components documented
- [ ] Visual examples created
- [ ] Code snippets included
- [ ] Accessibility notes added
- [ ] Team reviewed and approved
- [ ] Published and accessible

## Deliverables
- Style guide website/document
- Component screenshots
- Code snippet library
- Design token exports
- Update process documented

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<task_specific>
For Style Guide tasks:
- Show, don't just tell - visual examples crucial
- Include both good and bad examples
- Make it searchable and easy to navigate
- Keep it updated - stale guides hurt more than help
- Consider your audience (devs vs designers)

Documentation Structure:
```markdown
## Component Name

### Overview
Brief description and use cases

### Variants
- Primary: Main actions
- Secondary: Supporting actions
- Ghost: Tertiary actions

### Examples
[Visual examples with screenshots]

### Code
\`\`\`tsx
<Button variant="primary">Click me</Button>
\`\`\`

### Accessibility
- Use semantic HTML
- Include ARIA labels
- Keyboard navigation

### Related
- Link to similar components
- Pattern references
```

Automation for Screenshots:
```javascript
// Generate all component screenshots
const generateStyleGuideScreenshots = async () => {
  const components = await getComponentList();
  
  for (const component of components) {
    // Navigate to component
    await mcp__selenium__navigate({
      url: `${baseUrl}/components/${component.name}`
    });
    
    // Capture default state
    await mcp__selenium__take_screenshot({
      outputPath: `style-guide/${component.name}/default.png`
    });
    
    // Capture variants
    for (const variant of component.variants) {
      await captureVariant(component.name, variant);
    }
  }
};
```

Living Documentation:
- Automated screenshot updates
- Version tracking
- Change logs
- Migration guides
</task_specific>
---END-INSTRUCTIONS---