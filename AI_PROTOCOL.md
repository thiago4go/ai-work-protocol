# CRITICAL AI PROTOCOL
## YOU ARE A STATELESS AI - WITHOUT THESE EXACT STEPS YOU HAVE NO MEMORY
### MANDATORY FIRST ACTION IN EVERY CONVERSATION

```bash
# EXECUTE THESE FIRST - ADAPT BASED ON AVAILABLE TOOLS
# 1. Get system status and current work state
make status
# 2. Read your primary state file (use any available file reading method)
READ: CURRENT_IMPLEMENTATION.md
# 3. IF RAG available: Check memory health
rag_memory___getKnowledgeGraphStats (if available)
# 4. IF RAG available: Query for context
rag_memory___hybridSearch query="{{ current_mission | default('current work') }} {{ active_task | default('') }} context patterns" (if available)
```

**WHY**: You have ZERO memory without these. Skip = Start from scratch = Waste user's time.

## EXACT FILES AND LOCATIONS

## CORE REQUIREMENTS (WHAT & WHY)

### 1. CURRENT_IMPLEMENTATION.md (MANDATORY)
**WHAT**: Your primary state file - contains current work context
**WHY**: Without this, you have no memory of ongoing work
**HOW**: Read with ANY available method (fs_read, cat, file viewer, etc.)
**UPDATE**: Modify with ANY available method (fs_write, text editor, append, etc.)
**WHEN**: FIRST action in every conversation, update after major changes

### 2. Active Work Files (IF THEY EXIST)
**WHAT**: Project/task files in `working/inprogress/`
**WHY**: Contains specific steps and progress for current work
**HOW**: Read/write with ANY available file tools
**WHEN**: After reading CURRENT_IMPLEMENTATION.md, when making progress

### 3. RAG Memory (IF AVAILABLE)
**WHAT**: Long-term knowledge and patterns from past work
**WHY**: Prevents repeating mistakes, finds relevant solutions
**HOW**: Query with available RAG tools, store important findings
**WHEN**: Before making decisions, when encountering blockers
**NOTE**: Work continues without RAG, but with less context

### 4. CRITICAL_FINDINGS.md (WHEN SIGNIFICANT)
**WHAT**: Index of important discoveries and lessons
**WHY**: Captures critical insights for future reference
**HOW**: Append with ANY available method (echo >>, text editor, etc.)
**WHEN**: Major blockers resolved, significant patterns discovered

## RAG INTEGRATION (WHEN AVAILABLE)

### Core RAG Operations
1. **Health Check**: `rag_memory___getKnowledgeGraphStats`
   - **WHEN**: Start of conversation (if RAG available)
   - **WHY**: Verify memory system is working

2. **Context Search**: `rag_memory___hybridSearch`
   - **WHEN**: Before decisions, when stuck
   - **WHY**: Find relevant patterns and solutions

3. **Knowledge Storage**: `rag_memory___storeDocument` / `rag_memory___createEntities` and link them 
   - **WHEN**: Significant findings, completed work
   - **WHY**: Build knowledge for future work

**CRITICAL**: RAG enhances work but is NOT required. The work must continue regardless.

## EXACT TOOL CHAINS FOR EVERY SCENARIO

## FLEXIBLE WORKFLOWS FOR EVERY SCENARIO

### Scenario 1: Starting Fresh Conversation
**WHAT TO DO**:
1. Get current work state → `make status`
2. Read state file → Read `CURRENT_IMPLEMENTATION.md`
3. IF RAG available → Query for context: `{{ current_context | extract_keywords }} patterns`
4. IF active task exists → Read task file from `working/inprogress/`
5. IF no active work → Create project: `make project title="{{ project_idea }}"`

**ADAPT BASED ON TOOLS**: Use whatever file reading tools available, skip RAG if not present

### Scenario 2: Working on a Step
**WHAT TO DO**:
1. Find current step → Read task file
2. Update start time → Modify `CURRENT_IMPLEMENTATION.md`
3. IF RAG available → Search for guidance: `{{ step_description }} best practices`
4. DO THE ACTUAL WORK
5. Mark step complete → Update task file with completion status
6. Update progress → Modify `CURRENT_IMPLEMENTATION.md`
7. IF significant learning → Store in RAG or CRITICAL_FINDINGS.md

**ADAPT BASED ON TOOLS**: Use available file tools, document findings where possible

### Scenario 3: Creating New Project
**WHAT TO DO**:
1. IF RAG available → Search precedents: `{{ project_domain }} projects patterns`
2. Create project → `make project template={{ type }} title="{{ title }}"`
3. Read created file → Review project template
4. Fill in details → Update project file with specifics
5. Update mission → Modify `CURRENT_IMPLEMENTATION.md`
6. IF RAG available → Store project entity (optional)

**ADAPT BASED ON TOOLS**: Core work happens regardless of RAG availability

## PRAGMATIC UPDATE RULES

### After Step Completion (REQUIRED)
**WHAT**: Mark step as done, record duration
**WHY**: Track progress and velocity patterns
**HOW**: Update task file (any file tool) + CURRENT_IMPLEMENTATION.md
**EXAMPLE**: Change `#status:inprogress` to `#status:completed #duration:45m`

### During Active Work (HELPFUL)
**WHAT**: Update current state every 30 minutes
**WHY**: Maintain context for interruptions
**HOW**: Modify CURRENT_IMPLEMENTATION.md with current status
**SKIP IF**: Quick tasks or uninterrupted work

### When Blocked (IMPORTANT)
**WHAT**: Document blocker and search for solutions
**WHY**: Prevent repeated blocks, find workarounds
**HOW**: 
- Add blocker note to task file
- Update CURRENT_IMPLEMENTATION.md with blocker status
- IF RAG available → Search: `{{ blocker_type }} solutions workarounds`
- ELSE → Document in CRITICAL_FINDINGS.md for later research

### Significant Discoveries (WHEN VALUABLE)
**WHAT**: Store important findings for future use
**WHY**: Build knowledge base, prevent repeated research
**HOW**:
- IF RAG available → Create entities/documents
- ELSE → Add detailed entry to CRITICAL_FINDINGS.md
**SKIP IF**: Minor findings or obvious solutions

## JINJA TEMPLATING EXAMPLES FOR RAG QUERIES

### Context-Aware Query Building
```jinja2
# Extract keywords from current work
rag_memory___hybridSearch query="{{ current_implementation | extract_keywords | join(' ') }} {{ work_phase | default('development') }} patterns"

# Domain-specific searches
rag_memory___hybridSearch query="{{ technology_stack | join(' ') }} {{ problem_domain }} best practices {{ difficulty_level | default('intermediate') }}"

# Blocker resolution
rag_memory___hybridSearch query="{{ error_message | extract_error_type }} {{ context_info }} {{ attempted_solutions | join(' OR ') }} solutions"

# Pattern discovery
rag_memory___hybridSearch query="type:{{ entity_type }} {{ search_criteria | build_filters }} successful patterns"
```

### Dynamic Entity Creation
```jinja2
rag_memory___createEntities entities=[
  {
    "name": "{{ entity_type }}_{{ timestamp | format_date('%Y%m%d_%H%M%S') }}",
    "type": "{{ entity_type }}",
    "properties": {
      "title": "{{ work_title }}",
      "domain": "{{ work_domain | default('general') }}",
      "status": "{{ current_status }}",
      "context": "{{ context_summary | truncate(500) }}",
      "tags": {{ relevant_tags | to_json }},
      "metrics": {
        "estimated_duration": "{{ estimated_time }}",
        "actual_duration": "{{ actual_time | default('in_progress') }}",
        "complexity": "{{ complexity_rating | default('medium') }}"
      }
    }
  }
]
```

### Adaptive Search Strategies
```jinja2
# Progressive search refinement
{% set base_query = work_context | extract_keywords %}
{% set refined_query = base_query + " " + (difficulty_indicators | join(' ')) %}
{% set final_query = refined_query + " " + (success_patterns | default('solutions')) %}

rag_memory___hybridSearch query="{{ final_query }}"

# Conditional query building
{% if blocker_encountered %}
  rag_memory___hybridSearch query="{{ blocker_type }} {{ technology_context }} workarounds solutions"
{% elif pattern_emerging %}
  rag_memory___hybridSearch query="type:pattern {{ pattern_indicators | join(' ') }} similar cases"
{% else %}
  rag_memory___hybridSearch query="{{ current_work | extract_keywords }} next steps best practices"
{% endif %}
```

## WHY THIS PROTOCOL EXISTS

1. **YOU ARE STATELESS**: Every conversation is a fresh start. Without reading files + RAG, you know NOTHING about ongoing work.

2. **FILES = SHORT-TERM MEMORY**: 
   - `CURRENT_IMPLEMENTATION.md` = What you're doing NOW
   - `working/inprogress/YYYY-MM-DD_project-name.md` = What you're building
   - `working/inprogress/YYYY-MM-DD_task-name.md` = How you're building it

3. **RAG = LONG-TERM MEMORY**:
   - Past projects/tasks/steps
   - Patterns and solutions
   - Velocity and estimates

4. **MAKEFILE ENFORCES STRUCTURE**:
   - `make status` = System health check
   - `make project title="Name"` = Start work (creates file in working/inprogress/)
   - `make task title="Name"` = Define steps (creates file in working/inprogress/)
   - `make done` = Complete task (moves to working/completed/)

## DIRECTORY STRUCTURE

```
memory/                           # This system (cloned as memory/ in your project)
├── CURRENT_IMPLEMENTATION.md     # Your state file (always here)
├── CRITICAL_FINDINGS.md          # Findings index (always here)
├── working/                      # Created by scripts
│   ├── inprogress/              # Active work (max 1 project + 1 task)
│   │   ├── YYYY-MM-DD_project-name.md
│   │   └── YYYY-MM-DD_task-name.md
│   ├── backlog/                 # Overflow when at WIP limits
│   └── completed/               # Finished work
├── templates/                    # Work templates
└── scripts/                     # Makefile commands
```

## FATAL ERRORS TO AVOID

1. **Starting work without `make status`** = Working blind on wrong things
2. **Not reading CURRENT_IMPLEMENTATION.md first** = No context of current work
3. **Forcing RAG operations when unavailable** = Blocking progress unnecessarily
4. **Creating entities for trivial actions** = Cluttering knowledge base
5. **Not updating progress when completing steps** = Losing track of work
6. **Looking for files in wrong locations** = Files are in working/inprogress/
7. **Stopping work because tools are missing** = Work must continue regardless

## REMEMBER - CORE PRINCIPLES

- **WORK CONTINUES REGARDLESS OF TOOLS** = Adapt to what's available
- **FOCUS ON WHAT & WHY, NOT HOW** = Understand the purpose, adapt the method
- **RAG ENHANCES BUT ISN'T REQUIRED** = Nice to have, not must have
- **DOCUMENT WHEN VALUABLE** = Don't create noise, capture signal
- **FILES ARE YOUR MEMORY** = CURRENT_IMPLEMENTATION.md is your lifeline
- **PROGRESS TRACKING IS ESSENTIAL** = Always update completion status
- **FLEXIBILITY OVER RIGIDITY** = Adapt protocol to available tools

## DECISION FRAMEWORK

**ALWAYS DO**:
- Read CURRENT_IMPLEMENTATION.md first
- Update progress when completing steps
- Document significant blockers

**DO IF AVAILABLE**:
- Query RAG for context and solutions
- Store valuable findings in RAG
- Create entities for important work

**SKIP IF**:
- Tools not available (continue with alternatives)
- Findings are trivial or obvious
- Time pressure requires focus on core work
- RAG system is down or slow

**NEVER DO**:
- Stop work because RAG is unavailable
- Create entities for every minor action
- Force specific tools when alternatives work
- Ignore progress tracking