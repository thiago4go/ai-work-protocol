---
type: task
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Wireframing TASK for low-fidelity design exploration
parent_project: {{PARENT_PROJECT}}
---

# TASK: {{TITLE}}

## Summary
Create low-fidelity wireframes to explore layout options and user flows before high-fidelity design.

## Context
- **Feature/Page**: {{FEATURE_NAME}}
- **User Goals**: {{USER_GOALS}}
- **Content Requirements**: {{CONTENT_TYPES}}
- **Inspiration Sources**: {{REFERENCE_SITES}}

## Pre-conditions
- [ ] User requirements gathered
- [ ] Content inventory complete
- [ ] Competitor research done
- [ ] Device targets defined

## Steps
1. **Competitor Analysis** #estimate:2h #status:pending
   - Use Selenium to capture competitor layouts:
     ```javascript
     const competitors = ["site1.com", "site2.com"];
     for (const site of competitors) {
       await mcp__selenium__navigate({url: site});
       await mcp__selenium__take_screenshot({
         outputPath: `research/competitor_${site.replace('.', '_')}.png`
       });
     }
     ```
   - Document patterns in RAG

2. **Information Architecture** #estimate:2h #status:pending
   - Define content hierarchy
   - Map user flows
   - Create sitemap/navigation structure
   - Consider mobile-first organization

3. **Sketch Exploration** #estimate:3h #status:pending
   - Quick paper/digital sketches
   - Multiple layout variations
   - Focus on structure, not style
   - Test different component arrangements

4. **Digital Wireframes** #estimate:4h #status:pending
   - Create in Figma/Sketch/Excalidraw
   - Use shadcn/ui components as reference:
     ```bash
     # Research component options
     mcp__shadcn-ui__list_shadcn_components
     mcp__shadcn-ui__get_component_details componentName="card"
     ```
   - Maintain consistent grid system
   - Add annotations for functionality

5. **Responsive Variations** #estimate:3h #status:pending
   - Mobile (320-768px)
   - Tablet (768-1024px)
   - Desktop (1024px+)
   - Document breakpoint decisions

6. **Flow Documentation** #estimate:2h #status:pending
   - Create user flow diagrams
   - Annotate interactions
   - Note state changes
   - Store in RAG:
     ```
     rag_memory___createEntities entities=[{
       "name": "wireframe_{{FEATURE}}_v1",
       "type": "DESIGN_ARTIFACT",
       "properties": {
         "type": "wireframe",
         "feature": "{{FEATURE}}",
         "variations": ["mobile", "desktop"],
         "keyDecisions": ["single column mobile", "3-col desktop"]
       }
     }]
     ```

## Definition of Done
- [ ] All key screens wireframed
- [ ] Mobile and desktop versions complete
- [ ] User flows documented
- [ ] Annotations explain functionality
- [ ] Team feedback incorporated
- [ ] Ready for high-fidelity design

## Deliverables
- Wireframe files (Figma/Sketch)
- Exported PNGs/PDFs
- User flow diagrams
- Annotation documentation
- Decision rationale in RAG

---INSTRUCTIONS---
This template inherits from base_task.md workflow.

<task_specific>
For Wireframing tasks:
- Keep it low-fidelity - no colors, fonts, or styling
- Focus on layout, hierarchy, and flow
- Create multiple options for A/B testing
- Always annotate your thinking
- Test ideas quickly before investing in details

Tools & Techniques:
1. **Competitive Research**:
   - Use Selenium to screenshot competitors
   - Identify common patterns
   - Note unique solutions

2. **Component Planning**:
   - Reference shadcn/ui for realistic components
   - Don't design impossible interactions
   - Consider implementation effort

3. **Rapid Iteration**:
   - Time-box explorations (30min max)
   - Share early and often
   - Get feedback before refining

Documentation Pattern:
```
For each wireframe:
1. Screenshot/export the design
2. List key decisions made
3. Note questions/concerns
4. Store context in RAG
5. Link to user stories
```

Common Patterns:
- F-pattern for content scanning
- Z-pattern for landing pages
- Mobile hamburger vs tab bar
- Progressive disclosure for complex forms
</task_specific>
---END-INSTRUCTIONS---