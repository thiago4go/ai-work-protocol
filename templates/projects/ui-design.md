---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: UI Design PROJECT with MCP tools integration
---

# PROJECT: {{TITLE}}

## Goal
{{PROJECT_GOAL}}

## Context
- **Design Challenge**: {{DESIGN_CHALLENGE}}
- **Target Users**: {{TARGET_USERS}}
- **Brand Guidelines**: {{BRAND_CONSTRAINTS}}
- **Technical Stack**: React + Shadcn/UI + Tailwind

## Success Criteria
1. **Visual**: Consistent design system following brand guidelines
2. **Usability**: {{TARGET_USER}} can complete {{KEY_TASKS}} without confusion
3. **Accessibility**: WCAG 2.1 AA compliance verified with Selenium
4. **Performance**: < 3s load time, smooth interactions
5. **Responsive**: Works on mobile, tablet, desktop

## UI/UX Task Sequence
- [ ] **Research & Wireframing**: Analyze competitors, create low-fi designs (1-2 days)
  - Use Selenium to capture competitor screenshots
  - Document UI patterns in RAG
- [ ] **Component Selection**: Choose shadcn/ui components (0.5 days)
  - Use shadcn MCP to explore options
  - Document decisions in RAG
- [ ] **Prototype**: Build interactive prototype (2-3 days)
  - Implement with shadcn components
  - Create Selenium test scenarios
- [ ] **User Testing**: Validate with target users (1-2 days)
  - Automate test flows with Selenium
  - Capture visual evidence
- [ ] **Refinement**: Iterate based on feedback (1-2 days)
  - Update components
  - Re-run visual regression tests

## MCP Tool Integration
- **Selenium**: Visual testing, user flow automation, screenshot documentation
- **Shadcn/UI**: Component library, rapid prototyping, consistent design

## Constraints
- **Timeline**: {{TIMELINE}}
- **Budget**: {{BUDGET}}
- **Tech Limitations**: {{TECH_CONSTRAINTS}}

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<project_specific>
For UI Design projects:
- Always start with competitor analysis using Selenium screenshots
- Document every design decision in RAG with rationale
- Use shadcn/ui components as foundation, customize as needed
- Create automated visual tests for each major feature
- Store screenshots and test results in RAG for future reference

MCP Usage Patterns:
```bash
# Competitor Research
mcp__selenium__start_browser browser=firefox
mcp__selenium__navigate url="competitor-site.com"
mcp__selenium__take_screenshot outputPath="screenshots/competitor_{{DATE}}.png"

# Component Research  
mcp__shadcn-ui__search_components query="navigation menu"
mcp__shadcn-ui__get_component_examples componentName="navigation-menu"
```
</project_specific>
---END-INSTRUCTIONS---