---WORKFLOW-BASE---
<project_workflow>

<project_creation>
When creating this project:
1. Query for similar projects:
   ```
   rag_memory___hybridSearch query="{{TITLE}} similar projects outcomes"
   rag_memory___searchNodes query="type:project status:completed"
   ```

2. Create project entity:
   ```
   rag_memory___createEntities entities=[{
     "name": "project_{{TITLE}}",
     "type": "project",
     "properties": {
       "goal": "{{PROJECT_GOAL}}",
       "created": "{{DATE}}",
       "status": "active",
       "success_criteria": ["criterion1", "criterion2", "criterion3"]
     }
   }]
   ```

3. Store and process initial state:
   ```
   # Store document
   rag_memory___storeDocument id="project_{{TITLE}}_init" content="[project definition]"
   
   # Process for search
   rag_memory___chunkDocument documentId="project_{{TITLE}}_init"
   rag_memory___embedChunks documentId="project_{{TITLE}}_init"
   rag_memory___extractTerms documentId="project_{{TITLE}}_init"
   rag_memory___linkEntitiesToDocument documentId="project_{{TITLE}}_init" entityNames=["project_{{TITLE}}"]
   ```
</project_creation>

<daily_startup>
Every session with this PROJECT:
```bash
make status
cat CURRENT_IMPLEMENTATION.md

# Load full project context
rag_memory___hybridSearch query="{{TITLE}} progress decisions blockers"
rag_memory___getRelatedNodes nodeNames=["project_{{TITLE}}"]

# Check completed tasks
rag_memory___searchNodes query="parent_project:{{TITLE}} type:task status:completed"
```
</daily_startup>

<task_planning>
Before creating new task:
1. Review what's been done:
   ```
   rag_memory___hybridSearch query="{{TITLE}} completed tasks outcomes"
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
---END-WORKFLOW-BASE---