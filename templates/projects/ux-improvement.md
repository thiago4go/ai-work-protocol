---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: UX Improvement PROJECT focusing on user experience optimization
---

# PROJECT: {{TITLE}}

## Goal
{{PROJECT_GOAL}}

## Context
- **Current State**: {{CURRENT_UX_ISSUES}}
- **Target State**: {{DESIRED_UX_IMPROVEMENTS}}
- **User Pain Points**: {{USER_PAIN_POINTS}}
- **Success Metrics**: {{UX_METRICS}}

## Success Criteria
1. **Usability**: {{USABILITY_METRIC}} improvement (measured via user testing)
2. **Task Completion**: Reduce time to complete {{KEY_TASK}} by {{PERCENTAGE}}%
3. **Error Rate**: Decrease user errors by {{ERROR_REDUCTION}}%
4. **Satisfaction**: Achieve {{SATISFACTION_SCORE}}/10 user satisfaction score
5. **Accessibility**: Meet WCAG 2.1 {{LEVEL}} standards

## UX Improvement Task Sequence
- [ ] **User Research**: Understand current pain points (2-3 days)
  - User interviews with Selenium session recording
  - Analytics review
  - Heatmap analysis
- [ ] **Journey Mapping**: Document current vs ideal flows (1-2 days)
  - Use Selenium to capture actual user paths
  - Identify friction points
- [ ] **Design Solutions**: Create improved workflows (2-3 days)
  - Wireframe alternatives
  - A/B test designs
- [ ] **Prototype Testing**: Validate improvements (2-3 days)
  - Build with shadcn/ui components
  - Run user tests with Selenium
- [ ] **Implementation**: Roll out improvements (3-4 days)
  - Gradual rollout
  - Monitor metrics

## Research Methods
- **Quantitative**: Analytics, A/B tests, performance metrics
- **Qualitative**: User interviews, usability tests, surveys
- **Automated**: Selenium journey recording, heatmaps

## Constraints
- **User Disruption**: {{DISRUPTION_TOLERANCE}}
- **Technical Debt**: {{TECH_CONSTRAINTS}}
- **Timeline**: {{TIMELINE}}

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<project_specific>
For UX Improvement projects:
- Always start with data - don't assume you know the problems
- Test with real users, not just internal team
- Measure before and after to prove improvements
- Consider gradual rollout to minimize disruption
- Document all user feedback in RAG

Selenium Usage for UX:
```javascript
// Record user sessions
const recordUserJourney = async () => {
  const screenshots = [];
  // Capture at each major interaction
  await mcp__selenium__click_element({by: "id", value: "nav-menu"});
  screenshots.push(await mcp__selenium__take_screenshot({
    outputPath: `ux-research/journey_step_${screenshots.length}.png`
  }));
  // Store journey in RAG
  rag_memory___createEntities entities=[{
    "name": "user_journey_{{DATE}}",
    "type": "USER_FLOW",
    "properties": {
      "screenshots": screenshots,
      "painPoints": ["slow load", "confusing nav"],
      "duration": "5m 32s"
    }
  }];
};
```

Success Measurement:
- Task completion time
- Error frequency
- User satisfaction scores
- Accessibility compliance
- Performance metrics
</project_specific>
---END-INSTRUCTIONS---