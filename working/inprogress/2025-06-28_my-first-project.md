---
type: project
status: active
priority: high
created: 2025-06-28T06:04:13Z
updated: 2025-06-28T06:04:13Z
title: My First Project
description: Standard PROJECT template
---

# PROJECT: My First Project

## Goal
{{PROJECT_GOAL}}

## Context
- **Problem**: {{PROBLEM_DESCRIPTION}}
- **Solution**: {{PROPOSED_SOLUTION}}
- **Users**: {{TARGET_USERS}}

## Success Criteria
1. **Functionality**: {{CORE_FEATURE}} works for {{TARGET_USER}}
2. **Quality**: Zero critical bugs, <2s response time
3. **Adoption**: {{TARGET_USER}} can complete {{KEY_TASK}} without help

## Value-Driven Task Sequence
- [x] **Discovery**: What's the smallest thing that proves value? (1-2 days)
- [x] **MVP**: Build just that → Get feedback (2-3 days)
- [x] **Iterate**: Fix top 3 issues from feedback (1-2 days)
- [x] **Scale**: Only after MVP validated (2-3 days)
- [x] **Polish**: Documentation, edge cases, performance (1-2 days)

## Constraints
- **Timeline**: {{TIMELINE}}
- **Resources**: {{RESOURCES}}
- **Dependencies**: {{DEPENDENCIES}}

## Workflow from Base Template
<project_workflow>

<project_creation>
When creating this project:
1. Query for similar projects:
   ```
   rag_memory___hybridSearch query="My First Project similar projects outcomes"
   rag_memory___searchNodes query="type:project status:completed"
   ```

2. Create project entity:
   ```
   rag_memory___createEntities entities=[{
     "name": "project_My First Project",
     "type": "project",
     "properties": {
       "goal": "{{PROJECT_GOAL}}",
       "created": "2025-06-28T06:04:13Z",
       "status": "active",
       "success_criteria": ["criterion1", "criterion2", "criterion3"]
     }
   }]
   ```

3. Store and process initial state:
   ```
   # Store document
   rag_memory___storeDocument id="project_My First Project_init" content="[project definition]"
   
   # Process for search
   rag_memory___chunkDocument documentId="project_My First Project_init"
   rag_memory___embedChunks documentId="project_My First Project_init"
   rag_memory___extractTerms documentId="project_My First Project_init"
   rag_memory___linkEntitiesToDocument documentId="project_My First Project_init" entityNames=["project_My First Project"]
   ```
</project_creation>

<daily_startup>
Every session with this PROJECT:
```bash
make status
cat CURRENT_IMPLEMENTATION.md

# Load full project context
rag_memory___hybridSearch query="My First Project progress decisions blockers"
rag_memory___getRelatedNodes nodeNames=["project_My First Project"]

# Check completed tasks
rag_memory___searchNodes query="parent_project:My First Project type:task status:completed"
```
</daily_startup>

<task_planning>
Before creating new task:
1. Review what's been done:
   ```
   rag_memory___hybridSearch query="My First Project completed tasks outcomes"
   ```

2. Identify next logical step based on:
   - Success criteria progress
   - Dependencies completed
   - Lessons from previous tasks

3. Create informed task:
   ```bash
   make task template="[appropriate]" title="[specific goal]"
   ```
</task_planning>

<progress_tracking>
- Update CURRENT_IMPLEMENTATION.md after each work session
- Track completion % against success criteria
- Document major decisions with rationale
- Capture assumptions that change
</progress_tracking>

<project_patterns>
Common patterns to watch for:
- Morning sessions more productive → Schedule complex work AM
- External dependencies cause delays → Front-load these tasks
- Discovery tasks often exceed estimates → Buffer accordingly
- Implementation goes faster with good discovery → Invest in research
</project_patterns>

</project_workflow>
