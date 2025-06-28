---
type: index
category: critical_findings
status: active
updated: {{DATE}}
---
<never-edit-these-rules>
# Critical Findings Index

This file is an INDEX ONLY. Full findings MUST be stored in RAG.

## Format: Structured JSON Entries

## Usage Protocol (FULL PIPELINE)
1. Add a new JSON object to the `index_entries` array within the `<ai-input>` section.
2. Ensure the `rag_id` is unique and links to the full finding stored in RAG.
3. Store complete finding document in RAG:
   ```
   # Example RAG call (replace with actual tool call)
   rag_memory___createEntities entities=[{
     "name": "[unique_finding_id]",
     "type": "critical_finding",
     "properties": {
       "title": "[Brief finding description]",
       "context": "[when/where occurred]",
       "impact": "[why it matters]",
       "solution": "[how to handle]",
       "keywords": ["keyword1", "keyword2"]
     }
   }]
   rag_memory___storeDocument id="[unique_finding_id]" content="[FULL FINDING WITH CONTEXT AND EXAMPLES]"
   rag_memory___extractTerms documentId="[unique_finding_id]"
   rag_memory___linkEntitiesToDocument documentId="[unique_finding_id]" entityNames=["[unique_finding_id]"]
   ```

4. Query findings: Use your RAG tool: `rag_memory___searchNodes query="type:critical_finding [keyword]"`
</never-edit-these-rules>

<ai-input>
```json
{
  "index_entries": [
    {
      "date": "2025-06-16",
      "title": "System needs initialization sequence",
      "keywords": ["bootstrap", "initialization", "state"],
      "rag_id": "finding_2025-06-16_system-init"
    },
    {
      "date": "2025-06-18",
      "title": "WIP limits prevent idea capture",
      "keywords": ["backlog", "limits", "overflow"],
      "rag_id": "finding_2025-06-18_wip-limits"
    }
  ]
}
```
</ai-input>