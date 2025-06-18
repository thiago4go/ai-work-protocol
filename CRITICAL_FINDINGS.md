---
type: index
category: critical_findings
status: active
updated: 2025-06-18
---
<never-edit-these-rules>
# Critical Findings Index

This file is an INDEX ONLY. Full findings MUST be stored in RAG.

## Format: Finding → Keywords
Each line: Brief finding description → keywords for RAG search

## Usage Protocol (FULL PIPELINE)
1. Add 1-line entry here with keywords
2. Create finding entity:
   ```
   rag_memory___createEntities entities=[{
     "name": "finding_[date]_[slug]",
     "type": "critical_finding",
     "properties": {
       "finding": "[what discovered]",
       "context": "[when/where occurred]",
       "impact": "[why it matters]",
       "solution": "[how to handle]",
       "keywords": ["keyword1", "keyword2"]
     }
   }]
   ```
3. Store complete finding document:
   ```
   rag_memory___storeDocument id="finding_[date]_[slug]" content="[FULL FINDING WITH CONTEXT AND EXAMPLES]"
   ```
4. Process for semantic search:
   ```
   rag_memory___extractTerms documentId="finding_[date]_[slug]"
   rag_memory___linkEntitiesToDocument documentId="finding_[date]_[slug]" entityNames=["finding_[date]_[slug]"]
   ```
5. Query findings: `rag_memory___searchNodes query="type:critical_finding [keyword]"`
</never-edit-these-rules>

<ai-input>
## Index Entries

2025-06-16: System needs initialization sequence → bootstrap, initialization, state
2025-06-18: WIP limits prevent idea capture → backlog, limits, overflow

</ai-input>