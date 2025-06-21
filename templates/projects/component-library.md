---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Component Library PROJECT for reusable UI components
---

# PROJECT: {{TITLE}}

## Goal
{{PROJECT_GOAL}}

## Context
- **Design System**: {{DESIGN_SYSTEM_NAME}}
- **Tech Stack**: React + TypeScript + Shadcn/UI + Storybook
- **Target Projects**: {{TARGET_PROJECTS}}
- **Component Scope**: {{COMPONENT_CATEGORIES}}

## Success Criteria
1. **Coverage**: {{COMPONENT_COUNT}} reusable components documented
2. **Adoption**: Used in {{PROJECT_COUNT}} projects
3. **Consistency**: 100% design token compliance
4. **Documentation**: All components have examples and API docs
5. **Testing**: 100% visual regression coverage with Selenium

## Component Development Sequence
- [ ] **Foundation Setup**: Design tokens, themes, utilities (1-2 days)
  - Color system
  - Typography scale
  - Spacing system
  - Base shadcn/ui config
- [ ] **Core Components**: Buttons, forms, cards (3-4 days)
  - Extend shadcn/ui components
  - Add custom variants
  - Document with Storybook
- [ ] **Layout Components**: Grid, containers, navigation (2-3 days)
  - Responsive patterns
  - Accessibility built-in
- [ ] **Complex Components**: Data tables, modals, wizards (3-4 days)
  - Composite patterns
  - State management
- [ ] **Documentation Site**: Usage guide and examples (2-3 days)
  - Live demos
  - Code snippets
  - Integration guides

## Component Standards
- **Naming**: {{NAMING_CONVENTION}}
- **Props**: TypeScript interfaces required
- **Styling**: Tailwind + CSS variables
- **Testing**: Unit + Visual regression
- **A11y**: ARIA compliant, keyboard navigable

## Integration Strategy
- NPM package publishing
- Version management
- Migration guides
- Breaking change policy

## Constraints
- **Browser Support**: {{BROWSER_MATRIX}}
- **Performance**: < 50kb per component
- **Dependencies**: Minimize external deps

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<project_specific>
For Component Library projects:
- Start with most-used components based on audit
- Extend shadcn/ui rather than rebuilding from scratch
- Document everything - props, examples, edge cases
- Version carefully - breaking changes hurt adoption
- Test across all target projects

Component Development Flow:
```typescript
// 1. Research existing usage
mcp__shadcn-ui__get_component_details componentName="button"
mcp__shadcn-ui__get_component_examples componentName="button"

// 2. Extend with custom needs
export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = "primary", size = "md", ...props }, ref) => {
    // Custom logic here
  }
);

// 3. Visual test all variants
const variants = ["primary", "secondary", "danger"];
for (const variant of variants) {
  render(<Button variant={variant}>Test</Button>);
  await mcp__selenium__take_screenshot({
    outputPath: `components/button/${variant}.png`
  });
}

// 4. Document in RAG
rag_memory___createEntities entities=[{
  "name": "component_button_v1",
  "type": "UI_COMPONENT",
  "properties": {
    "variants": variants,
    "props": ButtonProps,
    "usage": "Primary CTA across all apps"
  }
}]
```

Quality Checklist:
- [ ] TypeScript types exported
- [ ] All variants documented
- [ ] Accessibility tested
- [ ] Visual regression baseline
- [ ] Performance benchmarked
- [ ] Migration guide written
</project_specific>
---END-INSTRUCTIONS---