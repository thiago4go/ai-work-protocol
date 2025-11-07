# AI Work Protocol with RAG Memory

A proven system for AI-assisted development with persistent memory and knowledge graphs.

**🎯 Proven Results**: Turned a 2-4 hour project into 25 minutes (9-18x faster) by forcing planning before implementation.

**🆕 Game Changer**: Now supports **database context switching** for isolated RAG memory per project/client/environment!

## What Makes This Work

This RAG-integrated work system uses PROJECT → TASK → STEP hierarchy with:
- **Persistent Memory**: Knowledge graph survives across sessions
- **Context Switching**: Isolated databases per project (NEW!)
- **Velocity Tracking**: Learn from actual vs estimated time
- **Forced Planning**: Think first, code second = 5-10x faster

Built on [rag-memory-mcp-postgresql](https://github.com/thiago4go/rag-memory-mcp-postgresql) with database switching support.

## Quick Start

```bash
# Clone into your project as memory/ directory
git clone https://github.com/thiago4go/ai-work-protocol.git memory/
```

**AI Prompt to start**:
```
You are a stateless AI powered by RAG Knowledge Graph.
Without RAG = No memory = No context = No learning.

READ THIS FIRST:
Scan all memory/ directories
THIS MUST BE FOLLOWED:
memory/CORE_PROTOCOL.json
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

## 🆕 Database Context Switching (Game Changer!)

Switch between isolated RAG memories without restarting:

```bash
# Multi-Project Isolation
project_a_memory → Project A knowledge
project_b_memory → Project B knowledge

# Multi-Tenant
client_acme_memory → ACME Corp data
client_globex_memory → Globex Inc data

# Multi-Environment
rag-memory-dev → Development
rag-memory-prod → Production
```

**Why it matters**: Each database is a completely isolated knowledge graph. Switch contexts in ~500ms. No data mixing. Perfect for agencies, consultants, or multi-project developers.

See [rag-memory-mcp-postgresql](https://github.com/thiago4go/rag-memory-mcp-postgresql) for setup.

## Hierarchy
```
PROJECT (goal) → TASK (1-3 days) → STEP (measurable)
├── working/inprogress/  (1 project + 1 task max)
├── working/backlog/     (overflow queue)
└── RAG memory          (all knowledge, per database)
```

## Key Rules (What Actually Works)

### ✅ DO THIS
- **Plan First**: 10 min analysis → hours saved
- **RAG at Phase Boundaries**: Not every step (too slow)
- **Track Velocity**: Actual vs estimated time
- **Update CURRENT_IMPLEMENTATION.json**: Single source of truth
- **Batch RAG Operations**: Entity→Document→Extract→Link together

### ❌ DON'T DO THIS
- Don't skip planning phase (you'll code slower)
- Don't query RAG every step (batching is faster)
- Don't use for <30min tasks (overhead not worth it)
- Don't follow protocol blindly (adapt to your needs)

## When to Use This Protocol

**✅ YES for:**
- Multi-session projects (>1 hour)
- Complex features requiring planning
- Projects with multiple phases
- When learning/documentation matters
- Multi-project/client work (with DB switching)

**❌ NO for:**
- Quick fixes (<30 min)
- Simple bug fixes
- Exploratory coding
- Prototyping

## Proven Results

**Real Project**: Database Context Switching Feature
- **Estimated**: 2-4 hours
- **Actual**: 25 minutes
- **Velocity**: 9-18x faster
- **Why**: Forced planning phase identified simplest approach

**Key Insight**: The protocol doesn't just help you build faster—it helps you build better by forcing you to think before coding.

## Sacred Files

```bash
CORE_PROTOCOL.json              # Main protocol (read first)
CURRENT_IMPLEMENTATION.json     # Single source of truth
CRITICAL_FINDINGS.md           # Index to RAG findings
templates/TEMPLATE_GUIDE.md    # Template selection
```

## Credits

- RAG Memory: [rag-memory-mcp-postgresql](https://github.com/thiago4go/rag-memory-mcp-postgresql) by [@thiago4go](https://github.com/thiago4go)
- Original MCP: [ttommyth/rag-memory-mcp](https://github.com/ttommyth/rag-memory-mcp)
- UI/UX MCPs: [@angiejones](https://github.com/angiejones/mcp-selenium), [@ymadd](https://github.com/ymadd/shadcn-ui-mcp-server)

## License

MIT - Use freely, improve openly