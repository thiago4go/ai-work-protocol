# Memory System Makefile - Work Management Commands
# =====================================================
# This Makefile provides commands for managing work using the PROJECT→TASK→STEP hierarchy.
# All commands integrate with RAG memory for persistent context and learning.

.PHONY: status list project task done dashboard help

# Show current work status
# ------------------------
# Displays active project/task, progress, and AI guidance for next actions.
# Always run this first to understand current state.
#
# Usage:
#   make status
#
# Example output:
#   📊 Memory System Status
#   🎯 PROJECT: Build User Auth
#   📋 TASK: Implement Login Flow
#      Progress: 3/5 steps completed
#      Current: Add password validation
#   🤖 AI NEXT ACTIONS:
#      1. Load step context: rag_memory___hybridSearch query='password validation patterns'
#      2. Work on current step...
status:
	@scripts/status.sh

# List available templates
# ------------------------
# Shows all project and task templates with descriptions.
# Use this to see what types of work are supported.
#
# Usage:
#   make list
#
# Example output:
#   📚 Templates Available:
#   PROJECTs:
#     - standard      → Building features
#     - refactor      → Improve code quality
#     - bugfix        → Fix production issues
#   TASKs:
#     - discovery     → Research before building
#     - implementation → Build defined solution
list:
	@scripts/create.sh list

# Create new project
# ------------------
# Starts a new high-level project. Only one project can be active at a time.
# Default template is 'standard'. See 'make list' for all templates.
#
# Usage:
#   make project title="Your Project Name"
#   make project template=bugfix title="Fix Login Error"
#
# Examples:
#   make project title="Build User Authentication"
#   make project template=refactor title="Improve Database Layer"
#   make project template=investigation title="Should we use GraphQL?"
#
# Note: Query RAG first to see if similar projects exist:
#   rag_memory___searchNodes query="type:project similar:authentication"
project:
	@scripts/create.sh project $(or $(template),standard) "$(title)"

# Create new task
# ---------------
# Creates a task within the current project. Only one task can be active at a time.
# Default template is 'discovery'. Tasks should complete in 1-3 days.
#
# Usage:
#   make task title="Your Task Name"
#   make task template=implementation title="Build Login Form"
#
# Examples:
#   make task title="Research Auth Libraries"
#   make task template=debugging title="Find Memory Leak"
#   make task template=poc title="Test Redis Performance"
#   make task template=documentation title="Write API Docs"
#
# Note: Task will auto-link to current project. Query RAG for context:
#   rag_memory___hybridSearch query="login form best practices"
task:
	@scripts/create.sh task $(or $(template),discovery) "$(title)"

# Complete current task
# ---------------------
# Marks the current task as complete, moves to completed/, and updates project.
# Run this only when ALL steps in the task are done.
#
# Usage:
#   make done
#   make done name=specific-task.md
#
# Before running:
#   - Ensure all steps show #status:completed
#   - Update CURRENT_IMPLEMENTATION.md with final metrics
#   - Add findings to CRITICAL_FINDINGS.md index (1 line each)
#   - Store full findings in RAG per protocol:
#     rag_memory___createEntities entities=[{
#       "name": "finding_[date]_[slug]",
#       "type": "critical_finding",
#       "properties": {"finding": "...", "context": "...", "impact": "...", "solution": "..."}
#     }]
done:
	@scripts/complete.sh $(name)

# Show visual dashboard
# ---------------------
# Displays progress visualization, metrics, and work history.
# Useful for understanding patterns and velocity.
#
# Usage:
#   make dashboard
#   make dashboard days=30  # Show last 30 days
#
# Shows:
#   - Current sprint progress
#   - Velocity trends
#   - Common blockers
#   - Time estimates vs actuals
dashboard:
	@scripts/dashboard.sh

# Show backlog items
# ------------------
# Lists all projects and tasks waiting in the backlog.
# Items are automatically added to backlog when WIP limit is reached.
#
# Usage:
#   make backlog
#
# Example output:
#   📋 Backlog (3 items)
#   ════════════════════
#   PROJECTS:
#     - 2024-01-15_refactor-auth.md: "Refactor Authentication"
#   TASKS:
#     - 2024-01-16_add-logging.md: "Add Debug Logging"
#     - 2024-01-16_update-docs.md: "Update API Documentation"
#
# To activate: make activate file=2024-01-15_refactor-auth.md
backlog:
	@echo "📋 Backlog Items"
	@echo "════════════════"
	@echo ""
	@if [ -d "plans/backlog" ] && [ "$$(ls -A plans/backlog 2>/dev/null)" ]; then \
		echo "PROJECTS:"; \
		find plans/backlog -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | while read f; do \
			title=$$(grep "^title:" "$$f" | cut -d' ' -f2-); \
			echo "  - $$(basename $$f): \"$$title\""; \
		done; \
		echo ""; \
		echo "TASKS:"; \
		find plans/backlog -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | while read f; do \
			title=$$(grep "^title:" "$$f" | cut -d' ' -f2-); \
			echo "  - $$(basename $$f): \"$$title\""; \
		done; \
		echo ""; \
		echo "To activate: make activate file=<filename>"; \
	else \
		echo "🎉 Backlog is empty!"; \
	fi

# Activate item from backlog
# --------------------------
# Moves a backlog item to active (inprogress), respecting WIP limits.
# Will swap with current active item if at limit.
#
# Usage:
#   make activate file=2024-01-15_refactor-auth.md
#   make activate file=refactor-auth  # partial match ok
#
# Rules:
#   - Only 1 project and 1 task can be active
#   - Activating a project when one exists will swap them
#   - Activating a task when one exists will swap them
#   - Cannot activate a task without an active project
#
# Example:
#   # Current: "Build Auth" project active
#   make activate file=fix-bug-project
#   # Result: "Build Auth" → backlog, "Fix Bug" → active
activate:
	@if [ -z "$(file)" ]; then \
		echo "❌ Usage: make activate file=<filename>"; \
		echo "   Run 'make backlog' to see available files"; \
		exit 1; \
	fi
	@scripts/activate.sh "$(file)"

# AI suggestions for next action
# -------------------------------
# Provides intelligent suggestions based on current state and RAG memory.
# Analyzes patterns, blockers, and successful approaches.
#
# Usage:
#   make suggest
#
# The AI will:
#   1. Query RAG for relevant patterns and past solutions
#   2. Analyze current blockers and progress
#   3. Suggest specific next actions
#   4. Provide relevant RAG queries to execute
#
# Example suggestions:
#   - "Similar task took 2x estimate due to API complexity"
#   - "Pattern detected: Morning sessions more productive"
#   - "Blocker 'auth timeout' solved previously with retry logic"
suggest:
	@echo "🤔 Analyzing current state for suggestions..."
	@echo ""
	@echo "AI: Execute these commands in sequence:"
	@echo "1. rag_memory___hybridSearch query='current work next best action patterns'"
	@echo "2. rag_memory___searchNodes query='type:pattern status:successful'"
	@echo "3. Review CRITICAL_FINDINGS.md for recent lessons"
	@echo "4. Check CURRENT_IMPLEMENTATION.md for blockers"
	@echo ""
	@echo "Based on findings, determine:"
	@echo "- If blocked: Query similar blockers and solutions"
	@echo "- If task complete: Run 'make done'"
	@echo "- If no task: Create next logical task"
	@echo "- If struggling: Review successful patterns"

# Create checkpoint of current state
# ----------------------------------
# Saves complete work state to RAG for recovery or context switching.
# Use before stopping work, switching tasks, or at natural break points.
#
# Usage:
#   make checkpoint
#   make checkpoint reason="Switching to urgent bug"
#
# Creates:
#   - RAG document with full context
#   - Entity tracking checkpoint metadata
#   - Git commit for version control
#
# To restore from checkpoint:
#   rag_memory___searchNodes query="type:checkpoint" 
#   rag_memory___getDocument id="checkpoint_[timestamp]"
checkpoint:
	@echo "💾 Creating checkpoint..."
	@echo ""
	@echo "AI: Execute these actions:"
	@echo "1. Update CURRENT_IMPLEMENTATION.md with current exact state"
	@echo "2. Note any partial work or thoughts"
	@echo "3. Store and process checkpoint in RAG:"
	@echo "   # Store document"
	@echo "   rag_memory___storeDocument id='checkpoint_$(shell date +%Y%m%d_%H%M%S)' \\"
	@echo "   content='[Full content of CURRENT_IMPLEMENTATION.md + active files]'"
	@echo "   "
	@echo "4. Create checkpoint entity:"
	@echo "   rag_memory___createEntities entities=[{"
	@echo "     \"name\": \"checkpoint_$(shell date +%Y%m%d_%H%M%S)\","
	@echo "     \"type\": \"checkpoint\","
	@echo "     \"properties\": {\"reason\": \"$(or $(reason),Manual checkpoint)\"}"
	@echo "   }]"
	@echo "5. Commit current state: git commit -am 'Checkpoint: $(or $(reason),Manual save)'"

# Extract and store learnings
# ---------------------------
# Analyzes recent work to identify patterns, estimate accuracy, and solutions.
# Run after completing tasks or when patterns emerge.
#
# Usage:
#   make learn
#   make learn focus="estimation accuracy"
#
# Extracts:
#   - Duration patterns (estimated vs actual)
#   - Common blockers and solutions
#   - Successful approaches to reuse
#   - Meta-patterns across similar work
#
# Example learnings:
#   - "Database migrations take 2.5x estimate on average"
#   - "Integration tests fail when run in parallel"
#   - "POCs with UI mockups get approved 80% vs 30%"
learn:
	@echo "🧠 Extracting learnings from recent work..."
	@echo ""
	@echo "AI: Analyze and store patterns:"
	@echo "1. Review completed steps in current task"
	@echo "2. Identify patterns:"
	@echo "   - Duration variance from estimates"
	@echo "   - Common blockers encountered"
	@echo "   - Successful problem solutions"
	@echo "3. For each pattern found:"
	@echo "   rag_memory___createEntities entities=[{"
	@echo "     \"name\": \"lesson_$(shell date +%Y%m%d_%H%M%S)\","
	@echo "     \"type\": \"lesson\","
	@echo "     \"properties\": {"
	@echo "       \"pattern\": \"[what observed]\","
	@echo "       \"context\": \"[when it happens]\","
	@echo "       \"solution\": \"[what worked]\","
	@echo "       \"focus\": \"$(or $(focus),general)\""
	@echo "     }"
	@echo "   }]"
	@echo "4. Add 1-line entries to CRITICAL_FINDINGS.md index"
	@echo "5. Store full findings in RAG as critical_finding entities"
	@echo "6. Query similar lessons to find meta-patterns:"
	@echo "   rag_memory___searchNodes query='type:lesson similar:[current lesson]'"

# Query findings from RAG
# -----------------------
# Searches for critical findings and lessons learned.
# The CRITICAL_FINDINGS.md file only contains an index - full data is in RAG.
#
# Usage:
#   make findings                    # Show all recent findings
#   make findings keyword=bootstrap  # Search specific topic
#   make findings type=blocker      # Filter by type
#
# Examples:
#   make findings keyword=estimation
#   make findings keyword="test failures"
#   make findings type=pattern
#
# Finding types:
#   - critical_finding: Major discoveries or issues
#   - lesson: Patterns and learnings
#   - blocker: Things that stopped progress
#   - pattern: Recurring behaviors
findings:
	@echo "🔍 Querying findings from RAG..."
	@echo ""
	@echo "AI: Execute these queries:"
	@if [ -z "$(keyword)" ]; then \
		echo "1. Recent findings: rag_memory___searchNodes query='type:critical_finding'"; \
		echo "2. Recent lessons: rag_memory___searchNodes query='type:lesson'"; \
		echo "3. View index: cat CRITICAL_FINDINGS.md"; \
	else \
		echo "1. Search findings: rag_memory___searchNodes query='type:critical_finding $(keyword)'"; \
		echo "2. Search lessons: rag_memory___searchNodes query='type:lesson $(keyword)'"; \
		echo "3. Related patterns: rag_memory___hybridSearch query='$(keyword) pattern solution'"; \
	fi
	@echo ""
	@echo "To add new finding:"
	@echo "1. Add to index: echo '$(shell date +%Y-%m-%d): Description → keywords' >> CRITICAL_FINDINGS.md"
	@echo "2. Execute FULL PIPELINE from CRITICAL_FINDINGS.md:"
	@echo "   - Create entity"
	@echo "   - Store document"
	@echo "   - Extract terms"
	@echo "   - Link entity to document"

# Show help information
# ---------------------
# Displays all available commands with brief descriptions.
# For detailed help on any command, see the comments above each target.
#
# Usage:
#   make help
#   make         # (same as help)
#
# Workflow example:
#   1. make status                          # Check current state
#   2. make project title="Build Feature"   # Start project
#   3. make task title="Research Options"   # Start discovery
#   4. [work on steps...]
#   5. make checkpoint                      # Save progress
#   6. make done                           # Complete task
#   7. make learn                          # Extract patterns
help:
	@echo "Memory System Commands:"
	@echo "═══════════════════════"
	@echo ""
	@echo "Core Workflow:"
	@echo "  make status     - Show current work & AI guidance"
	@echo "  make list       - List all available templates" 
	@echo "  make project    - Create new project (→ backlog if at limit)"
	@echo "  make task       - Create new task (→ backlog if at limit)"
	@echo "  make done       - Complete current task"
	@echo "  make dashboard  - Visual progress & metrics"
	@echo ""
	@echo "Backlog Management:"
	@echo "  make backlog    - Show items waiting in backlog"
	@echo "  make activate   - Move backlog item to active (with swap)"
	@echo ""
	@echo "Enhanced Commands:"
	@echo "  make suggest    - Get AI suggestions based on context"
	@echo "  make checkpoint - Save complete state to RAG"
	@echo "  make learn      - Extract & store work patterns"
	@echo "  make findings   - Query critical findings from RAG"
	@echo ""
	@echo "Quick Start:"
	@echo "  make project title=\"Your Project Name\""
	@echo "  make task title=\"First Task\""
	@echo ""
	@echo "For detailed help: See Makefile comments"