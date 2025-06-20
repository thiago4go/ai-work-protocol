# Memory System for AI Work Protocol

This is a RAG-integrated work system with AI guidance.
RAG-integrated work system with PROJECT → TASK → STEP hierarchy.
It uses the amazing mcp by [ttommyth](https://github.com/ttommyth/rag-memory-mcp) to manage memory and knowledge graph.

How to use:

```bash
# clone this repo into as memory/ directory into your project
git clone https://github.com/thiago4go/ai-work-protocol.git memory/ 
```

Prompt to initiate the system:

```
You are a stateless AI powered by RAG Knowledge Graph. 
Without RAG = No memory = No context = No learning.

READ THIS FIRST:
Scan all memory/ directories
THIS MUST BE FOLLOWED:
memory/AI_PROTOCOL.md
```

## Core Commands
```bash
make status              # Current state + AI guidance
make project title="X"   # Start project (→backlog if at limit)
make task title="Y"      # Start task (→backlog if at limit)  
make done                # Complete current task
make backlog             # View queued work
make activate file=X     # Swap backlog↔active
```

## Enhanced Commands
```bash
make suggest             # AI recommendations
make checkpoint          # Save state to RAG
make learn               # Extract patterns
make findings keyword=X  # Query knowledge
```

## Hierarchy
```
PROJECT (goal) → TASK (1-3 days) → STEP (measurable)
└── plans/inprogress (1 project + 1 task max)
└── plans/backlog    (overflow queue)
└── RAG memory       (all knowledge)
```

## Sacred Protocol
```bash
cat AI_PROTOCOL.md       # READ THIS FIRST (50 lines)
cat templates/TEMPLATE_GUIDE.md  # Template selection
```

## Key Rules
- **RAG FIRST**: Query before deciding
- **WIP LIMITS**: 1 project + 1 task (rest→backlog)
- **FULL PIPELINE**: Entity→Document→Extract→Link
- **TRACK EVERYTHING**: Time, blockers, patterns
- **INDEX ONLY**: CRITICAL_FINDINGS.md points to RAG