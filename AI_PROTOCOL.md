# CRITICAL AI PROTOCOL
## YOU ARE A STATELESS AI - WITHOUT THESE EXACT STEPS YOU HAVE NO MEMORY
### MANDATORY FIRST ACTION IN EVERY CONVERSATION

```
# EXECUTE THESE FIRST - ADAPT BASED ON AVAILABLE TOOLS
# 1. Get system status and current work state
#    Use your available file system tools to list and read relevant files.
#    Example: List files in working/inprogress/, read CURRENT_IMPLEMENTATION.json
# 2. Read your primary state file
READ: CURRENT_IMPLEMENTATION.json (parse as JSON)
# 3. Perform RAG health check (MANDATORY)
#    Use your available RAG tool for health checks.
# 4. Query RAG for context (MANDATORY)
#    Use your available RAG tool to query for context based on your current mission and active task.
```

**WHY**: You have ZERO memory without these. Skip = Start from scratch = Waste user's time.

## EXACT FILES AND LOCATIONS

## CORE REQUIREMENTS (WHAT & WHY)

### 1. CURRENT_IMPLEMENTATION.json (MANDATORY)
**WHAT**: Your primary state file - contains current work context. **MUST BE PARSED AS JSON.**
**WHY**: Without this, you have no memory of ongoing work.
**HOW**: Use your available file reading tool to read. Use your available file writing tool to update.
**WHEN**: FIRST action in every conversation, update after major changes.

### 2. Active Work Files (IF THEY EXIST)
**WHAT**: Project/task files in `working/inprogress/` (e.g., `YYYY-MM-DD_project-name.json`, `YYYY-MM-DD_task-name.json`). These should contain structured data (JSON).
**WHY**: Contains specific steps and progress for current work.
**HOW**: Use your available file reading tool to read. Use your available file writing tool to update.
**WHEN**: After reading CURRENT_IMPLEMENTATION.json, when making progress.

### 3. RAG Memory (MANDATORY)
**WHAT**: Long-term knowledge and patterns from past work.
**WHY**: Prevents repeating mistakes, finds relevant solutions, enables continuous learning.
**HOW**: Use your available RAG tools to query for context, store findings, and create entities.
**WHEN**: Before making decisions, when encountering blockers, after significant discoveries.

### 4. CRITICAL_FINDINGS.md (WHEN SIGNIFICANT)
**WHAT**: Index of important discoveries and lessons.
**WHY**: Captures critical insights for future reference.
**HOW**: Use your available file writing tool to append to this file.
**WHEN**: Major blockers resolved, significant patterns discovered.

## RAG INTEGRATION (MANDATORY)

### Core RAG Operations
1. **Health Check**: Use your available RAG tool for health checks.
   - **WHEN**: Start of conversation.
   - **WHY**: Verify memory system is working.

2. **Context Search**: Use your available RAG tool to query for context.
   - **WHEN**: Before decisions, when stuck, for guidance.
   - **WHY**: Find relevant patterns and solutions.

3. **Knowledge Storage**: Use your available RAG tools to store documents, create entities, and link them.
   - **WHEN**: Significant findings, completed work, new patterns identified.
   - **WHY**: Build knowledge for future work.

**CRITICAL**: RAG is NOT optional. It is integral to the agent's memory and learning.

## FLEXIBLE WORKFLOWS FOR EVERY SCENARIO

### Scenario 1: Starting Fresh Conversation
**WHAT TO DO**:
1. Read state file: Use your file reading tool for `CURRENT_IMPLEMENTATION.json` (parse JSON).
2. Query RAG for context: Use your RAG tool to query for context based on keywords from your current state.
3. If active task exists: Use your file reading tool for task file from `working/inprogress/` (parse JSON).
4. If no active work: Create project (see Scenario 3).

### Scenario 2: Working on a Step
**WHAT TO DO**:
1. Find current step: Read task file (parse JSON).
2. Update progress: Modify `CURRENT_IMPLEMENTATION.json` (update JSON, then write file).
3. Query RAG for guidance: Use your RAG tool to search for guidance based on the step description.
4. DO THE ACTUAL WORK.
5. Mark step complete: Update task file with completion status (update JSON, then write file).
6. Update progress: Modify `CURRENT_IMPLEMENTATION.json` (update JSON, then write file).
7. If significant learning: Store in RAG (use your RAG tools) or `CRITICAL_FINDINGS.md` (append).

### Scenario 3: Creating New Project/Task
**WHAT TO DO**:
1. Query RAG for precedents: Use your RAG tool to search for precedents based on the project domain.
2. Determine file path (e.g., `working/inprogress/YYYY-MM-DD_project-name.json`).
3. Read template: Use your file reading tool for `templates/projects/{{ type }}.json` or `templates/tasks/{{ type }}.json`.
4. Fill in details: Create new project/task content (JSON) based on template and provided title/details.
5. Write new file: Use your file writing tool to the determined path.
6. **IMPORTANT**: If creating a project, ensure all project details are filled and `CURRENT_IMPLEMENTATION.json` is updated to reflect the fully defined project *before* creating any tasks for it.
7. Update mission: Modify `CURRENT_IMPLEMENTATION.json` (update JSON, then write file).
8. Store project/task entity in RAG (use your RAG tools).

## PRAGMATIC UPDATE RULES

### After Step Completion (REQUIRED)
**WHAT**: Mark step as done.
**WHY**: Track progress.
**HOW**: Update task file (update JSON, then write file) + `CURRENT_IMPLEMENTATION.json` (update JSON, then write file).
**EXAMPLE**: In JSON, change `"status": "inprogress"` to `"status": "completed"`.

### During Active Work (HELPFUL)
**WHAT**: Update current state periodically.
**WHY**: Maintain context for interruptions.
**HOW**: Modify `CURRENT_IMPLEMENTATION.json` with current status (update JSON, then write file).
**SKIP IF**: Quick tasks or uninterrupted work.

### When Blocked (IMPORTANT)
**WHAT**: Document blocker and search for solutions.
**WHY**: Prevent repeated blocks, find workarounds.
**HOW**:
- Add blocker note to task file (update JSON, then write file).
- Update `CURRENT_IMPLEMENTATION.json` with blocker status (update JSON, then write file).
- Query RAG: Use your RAG tool to search for solutions based on the blocker type.
- Add detailed entry to `CRITICAL_FINDINGS.md` if RAG doesn't resolve.

### Significant Discoveries (WHEN VALUABLE)
**WHAT**: Store important findings for future use.
**WHY**: Build knowledge base, prevent repeated research.
**HOW**: Create entities/documents in RAG (use your RAG tools). If RAG is temporarily unavailable, add detailed entry to `CRITICAL_FINDINGS.md`.

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
      "tags": {{ relevant_tags | to_json }}
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
   - `CURRENT_IMPLEMENTATION.json` = What you're doing NOW (structured JSON)
   - `working/inprogress/YYYY-MM-DD_project-name.json` = What you're building (structured JSON)
   - `working/inprogress/YYYY-MM-DD_task-name.json` = How you're building it (structured JSON)

3. **RAG = LONG-TERM MEMORY (MANDATORY)**:
   - Past projects/tasks/steps
   - Patterns and solutions
   - Continuous learning

## DIRECTORY STRUCTURE

```
memory/                           # This system (cloned as memory/ in your project)
├── CURRENT_IMPLEMENTATION.json     # Your state file (always here, JSON content)
├── CRITICAL_FINDINGS.md          # Findings index (always here)
├── working/                      # Managed by agent's file operations
│   ├── inprogress/              # Active work (max 1 project + 1 task)
│   │   ├── YYYY-MM-DD_project-name.json (JSON content)
│   │   └── YYYY-MM-DD_task-name.json (JSON content)
│   ├── backlog/                 # Overflow when at WIP limits
│   └── completed/               # Finished work
├── templates/                    # Work templates (JSON files)
└── scripts/                     # (Legacy - not used by agent for core workflow)
```

## FATAL ERRORS TO AVOID

1. **Not reading CURRENT_IMPLEMENTATION.json first** = No context of current work.
2. **Not performing RAG operations** = No long-term memory, no learning, repeated mistakes.
3. **Creating entities for trivial actions** = Cluttering knowledge base.
4. **Not updating progress when completing steps** = Losing track of work.
5. **Looking for files in wrong locations** = Files are in `working/inprogress/`, `working/backlog/`, `working/completed/`.

## REMEMBER - CORE PRINCIPLES

- **WORK CONTINUES**: Adapt to available tools and information.
- **FOCUS ON WHAT & WHY, NOT HOW**: Understand the purpose, adapt the method.
- **RAG IS MANDATORY**: It is your long-term memory and learning mechanism.
- **DOCUMENT WHEN VALUABLE**: Don't create noise, capture signal.
- **FILES ARE YOUR SHORT-TERM MEMORY**: `CURRENT_IMPLEMENTATION.json` is your lifeline.
- **PROGRESS TRACKING IS ESSENTIAL**: Always update completion status.
- **FLEXIBILITY OVER RIGIDITY**: Adapt protocol to available tools.

## DECISION FRAMEWORK

**ALWAYS DO**:
- Read `CURRENT_IMPLEMENTATION.json` first.
- Perform RAG health check and context query.
- Update progress when completing steps.
- Document significant blockers.

**DO IF APPLICABLE**:
- Query RAG for context and solutions.
- Store valuable findings in RAG.
- Create entities for important work.

**NEVER DO**:
- Ignore RAG operations.
- Create entities for every minor action.
- Ignore progress tracking.