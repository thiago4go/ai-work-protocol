#!/bin/bash

# status.sh - Show current work status

echo "📊 Memory System Status"
echo "═══════════════════════"

# Check active work
PROJECT=$(find plans/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | head -1)
TASK=$(find plans/inprogress -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | head -1)

# Show current state
echo ""
if [ -n "$PROJECT" ]; then
    PROJECT_TITLE=$(grep "^title:" "$PROJECT" | cut -d' ' -f2-)
    echo "🎯 PROJECT: $PROJECT_TITLE"
    echo "   File: $(basename "$PROJECT")"
fi

if [ -n "$TASK" ]; then
    TASK_TITLE=$(grep "^title:" "$TASK" | cut -d' ' -f2-)
    echo "📋 TASK: $TASK_TITLE"
    echo "   File: $(basename "$TASK")"
    
    # Show progress
    TOTAL=$(grep -c "^- \[" "$TASK" 2>/dev/null || echo 0)
    DONE=$(grep -c "^- \[x\]" "$TASK" 2>/dev/null || echo 0)
    echo "   Progress: $DONE/$TOTAL steps completed"
    
    # Show current step
    CURRENT=$(grep -n "#status:inprogress" "$TASK" 2>/dev/null | head -1)
    if [ -n "$CURRENT" ]; then
        echo "   Current: $(echo "$CURRENT" | cut -d: -f3- | sed 's/^- \[.\] //')"
    fi
fi

# Next action
echo ""
echo "🔮 Next Action:"
if [ -z "$PROJECT" ] && [ -z "$TASK" ]; then
    echo "   → make project title=\"Your Project\""
elif [ -n "$PROJECT" ] && [ -z "$TASK" ]; then
    echo "   → make task title=\"First Task\""
elif [ -n "$TASK" ]; then
    echo "   → Continue working on current task"
    echo "   → When done: make done"
fi

# Quick stats
echo ""
echo "📈 Stats:"
echo "   Active: $(find plans/inprogress -name "*.md" 2>/dev/null | wc -l)/2 (max)"
echo "   Backlog: $(find plans/backlog -name "*.md" 2>/dev/null | wc -l) items"
echo "   Completed: $(find plans/completed -name "*.md" 2>/dev/null | wc -l) plans"

# AI Guidance
echo ""
echo "🤖 AI NEXT ACTIONS:"
if [ -z "$PROJECT" ] && [ -z "$TASK" ]; then
    echo "1. Query RAG for similar projects: rag_memory___hybridSearch query='project patterns successful'"
    echo "2. Review any prior work: rag_memory___listDocuments"
    echo "3. Create informed project: make project title='Your Project Name'"
elif [ -n "$PROJECT" ] && [ -z "$TASK" ]; then
    echo "1. Load project context: rag_memory___getRelatedNodes nodeNames=['project_$PROJECT_TITLE']"
    echo "2. Query what's needed: rag_memory___hybridSearch query='$PROJECT_TITLE next steps'"
    echo "3. Create task based on findings: make task title='Specific Goal'"
elif [ -n "$TASK" ]; then
    if [ -n "$CURRENT" ]; then
        STEP_DESC=$(echo "$CURRENT" | cut -d: -f3- | sed 's/^- \[.\] //' | cut -d'→' -f1 | xargs)
        echo "1. Load step context: rag_memory___hybridSearch query='$STEP_DESC patterns'"
        echo "2. Work on current step (started at: check CURRENT_IMPLEMENTATION.md)"
        echo "3. Update step when done: mark #status:completed #duration:XXm"
    else
        echo "1. All steps complete! Calculate metrics in CURRENT_IMPLEMENTATION.md"
        echo "2. Store lessons: rag_memory___createEntities entities=[{...lessons...}]"
        echo "3. Complete task: make done"
    fi
fi
echo ""
echo "⚡ REMEMBER: Update CURRENT_IMPLEMENTATION.md after EVERY action!"