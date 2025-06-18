---WORKFLOW-BASE---
<task_workflow>

<before_starting>
# Load context from similar tasks
rag_memory___hybridSearch query="{{TITLE}} similar tasks patterns"
rag_memory___searchNodes query="type:task status:completed similar:{{TITLE}}"

# Create task entity and link to project
rag_memory___createEntities entities=[{
  "name": "task_{{TITLE}}",
  "type": "task",
  "properties": {
    "created": "{{DATE}}",
    "objective": "{{TASK_OBJECTIVE}}",
    "parent_project": "{{PARENT_PROJECT}}"
  }
}]
rag_memory___createRelations relations=[{
  "from": "project_{{PARENT_PROJECT}}",
  "to": "task_{{TITLE}}",
  "type": "contains"
}]
</before_starting>

<step_execution>
For EVERY step:

1. BEFORE starting:
   - Note time: Update CURRENT_IMPLEMENTATION.md with step start time
   - Query patterns: rag_memory___hybridSearch query="[step description] best practices"
   - Create step entity in RAG with estimated duration

2. DURING execution:
   - Update CURRENT_IMPLEMENTATION.md every 30 minutes
   - Document blockers immediately in task file
   - If blocked >1hr: Query RAG for similar blockers and solutions

3. AFTER completion:
   - Calculate duration: Note in step as #duration:45m
   - Update step: Mark #status:completed
   - Store results:
     ```
     rag_memory___createEntities entities=[{
       "name": "step_{{DATE}}_[step_num]",
       "type": "completed_step",
       "properties": {
         "duration": "[actual]",
         "estimate": "[estimated]",
         "blockers": "[any blockers]",
         "output": "[deliverable]",
         "lessons": "[key learning]"
       }
     }]
     ```
   - If duration >2x estimate: Add to CRITICAL_FINDINGS.md
</step_execution>

<progress_check>
After completing 3 steps:
- Query: rag_memory___hybridSearch query="my recent steps velocity blockers"
- Identify patterns in execution
- Adjust approach if needed
- Update estimates for remaining steps
</progress_check>

<task_completion>
When all steps complete:
1. Calculate total metrics (duration, velocity, blockers)
2. Document key outcomes in CURRENT_IMPLEMENTATION.md
3. Store and process complete task:
   ```
   # Store document
   rag_memory___storeDocument id="task_{{TITLE}}_complete" content="[full task content]"
   
   # Process for search
   rag_memory___chunkDocument documentId="task_{{TITLE}}_complete"
   rag_memory___embedChunks documentId="task_{{TITLE}}_complete"
   rag_memory___extractTerms documentId="task_{{TITLE}}_complete"
   rag_memory___linkEntitiesToDocument documentId="task_{{TITLE}}_complete" entityNames=["task_{{TITLE}}"]
   
   # Update entity
   rag_memory___updateEntity name="task_{{TITLE}}" properties={"status": "completed", "duration": "[total]"}
   ```
4. For each critical finding:
   - Add 1-line to CRITICAL_FINDINGS.md: "Finding description → keywords"
   - Execute FULL PIPELINE in CRITICAL_FINDINGS.md protocol
5. Run: make done
</task_completion>

<common_pitfalls>
AVOID these patterns:
- Starting step without clear success criteria
- Skipping RAG queries "to save time" 
- Not documenting blockers immediately
- Batching commits (commit after each working step)
- Estimating without checking historical data
- Working >2hrs without updating CURRENT_IMPLEMENTATION.md
</common_pitfalls>

</task_workflow>
---END-WORKFLOW-BASE---