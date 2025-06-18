# Template Selection Guide

## Quick Reference
```
make list  # See all templates
```

## Project Templates (What to build)
- **standard** → Building features with clear requirements
- **refactor** → Improve code without changing behavior  
- **investigation** → Answer specific technical question
- **bugfix** → Fix production issue
- **integration** → Connect two systems
- **optimization** → Make something faster
- **migration** → Move data/system

## Task Templates (How to execute)
- **discovery** → Research before building
- **implementation** → Build defined solution
- **deep-analysis** → Complex technical investigation
- **debugging** → Find root cause systematically
- **review** → Code/design review
- **documentation** → Create user/dev docs
- **testing** → Add test coverage
- **automation** → Replace manual process
- **poc** → Prove concept feasibility

## Selection Rules
1. Query RAG first: `rag_memory___searchNodes query="similar:[your work]"`
2. If similar exists → use same template
3. If new → start with discovery/investigation
4. If failed before → try different approach

## Success Pattern
Discovery → Implementation → Discovery → Implementation...
(1-3 day cycles, deliver value each cycle)