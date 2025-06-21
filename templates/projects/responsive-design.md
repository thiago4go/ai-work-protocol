---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Responsive Design PROJECT for multi-device optimization
---

# PROJECT: {{TITLE}}

## Goal
{{PROJECT_GOAL}}

## Context
- **Current State**: {{CURRENT_RESPONSIVE_ISSUES}}
- **Target Devices**: {{DEVICE_MATRIX}}
- **User Distribution**: {{DEVICE_USAGE_STATS}}
- **Performance Budget**: {{PERFORMANCE_TARGETS}}

## Success Criteria
1. **Device Coverage**: Works on {{DEVICE_COUNT}} target devices
2. **Performance**: < {{LOAD_TIME}}s on 3G mobile
3. **Usability**: Touch targets ≥ 44px on mobile
4. **Content Parity**: All features available on all devices
5. **Testing**: Automated tests for all breakpoints

## Responsive Design Task Sequence
- [ ] **Device Audit**: Analyze current state across devices (1-2 days)
  - Use Selenium at different viewports
  - Document broken layouts
  - Measure performance
- [ ] **Breakpoint Strategy**: Define responsive system (1 day)
  - Mobile-first approach
  - Major breakpoints: {{BREAKPOINTS}}
  - Container queries where needed
- [ ] **Component Adaptation**: Make components responsive (3-4 days)
  - Update shadcn/ui component usage
  - Create responsive variants
  - Test touch interactions
- [ ] **Layout Optimization**: Improve layouts per device (2-3 days)
  - Progressive disclosure
  - Adaptive navigation
  - Optimized images
- [ ] **Performance Tuning**: Optimize for mobile (2-3 days)
  - Code splitting
  - Lazy loading
  - Resource hints
- [ ] **Cross-Device Testing**: Validate on real devices (2-3 days)
  - Automated Selenium tests
  - Manual device testing
  - Performance monitoring

## Technical Approach
- **CSS Strategy**: {{CSS_APPROACH}}
- **Grid System**: {{GRID_FRAMEWORK}}
- **Image Strategy**: {{IMAGE_OPTIMIZATION}}
- **Font Loading**: {{FONT_STRATEGY}}

## Testing Matrix
| Device Category | Viewport | Test Coverage |
|----------------|----------|---------------|
| Mobile Small | 320-375px | Selenium automated |
| Mobile Large | 376-414px | Selenium automated |
| Tablet | 768-1024px | Selenium automated |
| Desktop | 1025px+ | Selenium automated |

## Constraints
- **Legacy Support**: {{LEGACY_REQUIREMENTS}}
- **Framework Limits**: {{FRAMEWORK_CONSTRAINTS}}
- **Timeline**: {{TIMELINE}}

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<project_specific>
For Responsive Design projects:
- Always start mobile-first
- Test on real devices, not just browser DevTools
- Consider touch, mouse, and keyboard inputs
- Performance is part of responsive design
- Document breakpoint decisions in RAG

Selenium Responsive Testing:
```javascript
// Test across viewports
const viewports = [
  { width: 375, height: 667, name: "iPhone-8" },
  { width: 768, height: 1024, name: "iPad" },
  { width: 1920, height: 1080, name: "Desktop" }
];

for (const viewport of viewports) {
  // Set viewport
  await driver.manage().window().setRect({
    width: viewport.width,
    height: viewport.height
  });
  
  // Test each page
  for (const page of pages) {
    await mcp__selenium__navigate({url: page.url});
    
    // Visual test
    await mcp__selenium__take_screenshot({
      outputPath: `responsive/${page.name}_${viewport.name}.png`
    });
    
    // Interaction test
    if (viewport.width < 768) {
      // Test mobile menu
      await mcp__selenium__click_element({
        by: "css",
        value: "[data-mobile-menu]"
      });
    }
  }
}

// Store results
rag_memory___createEntities entities=[{
  "name": "responsive_test_{{DATE}}",
  "type": "VISUAL_TEST",
  "properties": {
    "viewports": viewports,
    "issues": ["nav overflow at 375px", "image too large"],
    "passed": false
  }
}]
```

Performance Monitoring:
- First Contentful Paint per device
- Time to Interactive on 3G
- Bundle size impact
- Image optimization savings
</project_specific>
---END-INSTRUCTIONS---