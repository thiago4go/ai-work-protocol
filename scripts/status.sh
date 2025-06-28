#!/bin/bash

# status.sh - Show current work status with AI guidance

echo "📊 Memory System Status"
echo "═══════════════════════"

# Check active work - fix directory paths
PROJECT=$(find working/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | head -1)
TASK=$(find working/inprogress -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | head -1)

# Show current state
echo ""
if [ -n "$PROJECT" ]; then
    PROJECT_TITLE=$(grep "^title:" "$PROJECT" | cut -d' ' -f2-)
    echo "🎯 PROJECT: $PROJECT_TITLE"
    echo "   File: $(basename "$PROJECT")"
    
    # Check if project content is filled
    OBJECTIVES=$(grep -c "^## Objectives" "$PROJECT" 2>/dev/null || echo 0)
    DELIVERABLES=$(grep -c "^## Deliverables" "$PROJECT" 2>/dev/null || echo 0)
    if [ "$OBJECTIVES" -eq 0 ] || [ "$DELIVERABLES" -eq 0 ]; then
        echo "   ⚠️  PROJECT TEMPLATE NOT FILLED - Needs actual content!"
    fi
else
    echo "❌ No active PROJECT"
fi

if [ -n "$TASK" ]; then
    TASK_TITLE=$(grep "^title:" "$TASK" | cut -d' ' -f2-)
    echo "📋 TASK: $TASK_TITLE"
    echo "   File: $(basename "$TASK")"
    
    # Show progress
    TOTAL=$(grep -c "^- \[" "$TASK" 2>/dev/null || echo 0)
    DONE=$(grep -c "^- \[x\]" "$TASK" 2>/dev/null || echo 0)
    echo "   Progress: $DONE/$TOTAL steps completed"
    
    # Check if task has actual steps
    if [ "$TOTAL" -eq 0 ]; then
        echo "   ⚠️  TASK TEMPLATE NOT FILLED - Needs actual steps!"
    fi
    
    # Show current step
    CURRENT=$(grep -n "#status:inprogress" "$TASK" 2>/dev/null | head -1)
    if [ -n "$CURRENT" ]; then
        echo "   Current: $(echo "$CURRENT" | cut -d: -f3- | sed 's/^- \[.\] //')"
    fi
else
    echo "❌ No active TASK"
fi

# Quick stats
echo ""
echo "📈 Stats:"
echo "   Active: $(find working/inprogress -name "*.md" 2>/dev/null | wc -l)/2 (max)"
echo "   Backlog: $(find working/backlog -name "*.md" 2>/dev/null | wc -l) items"
echo "   Completed: $(find working/completed -name "*.md" 2>/dev/null | wc -l) plans"

# Enhanced AI Guidance
echo ""
echo "🤖 AI NEXT ACTIONS:"
echo "══════════════════"

if [ -z "$PROJECT" ] && [ -z "$TASK" ]; then
    echo "🚀 NO ACTIVE WORK - Start fresh:"
    echo "1. Read state: Use any method to read CURRENT_IMPLEMENTATION.md"
    echo "2. IF RAG available: rag_memory___hybridSearch query='recent projects patterns successful'"
    echo "3. Create project: make project title='Your Project Name'"
    echo "4. CRITICAL: Fill project template with actual content!"
    
elif [ -n "$PROJECT" ] && [ -z "$TASK" ]; then
    echo "📋 PROJECT EXISTS, NO TASK:"
    echo "1. Read project: Use any method to read $PROJECT"
    
    # Check if project is filled
    OBJECTIVES=$(grep -c "^## Objectives" "$PROJECT" 2>/dev/null || echo 0)
    if [ "$OBJECTIVES" -eq 0 ]; then
        echo "2. ⚠️  FILL PROJECT CONTENT FIRST:"
        echo "   - Define objectives and deliverables"
        echo "   - Set success criteria and timeline"
        echo "   - Update file: Use any available editing method"
        echo "3. THEN create first task aligned with project"
    else
        echo "2. IF RAG available: rag_memory___hybridSearch query='$PROJECT_TITLE next tasks breakdown'"
        echo "3. Create aligned task: make task title='Specific Task Name'"
        echo "4. CRITICAL: Ensure task contributes to project objectives!"
    fi
    
elif [ -n "$PROJECT" ] && [ -n "$TASK" ]; then
    # Check if task has content
    TOTAL=$(grep -c "^- \[" "$TASK" 2>/dev/null || echo 0)
    if [ "$TOTAL" -eq 0 ]; then
        echo "📝 TASK EXISTS BUT EMPTY:"
        echo "1. Read project context: Use any method to read $PROJECT"
        echo "2. Read task template: Use any method to read $TASK"
        echo "3. IF RAG available: rag_memory___hybridSearch query='$TASK_TITLE $PROJECT_TITLE task breakdown'"
        echo "4. FILL TASK with actual steps using any editing method:"
        echo "   - Break into 3-7 concrete steps"
        echo "   - Align with project objectives"
        echo "   - Set realistic time estimates"
    elif [ -n "$CURRENT" ]; then
        STEP_DESC=$(echo "$CURRENT" | cut -d: -f3- | sed 's/^- \[.\] //' | cut -d'→' -f1 | xargs)
        echo "🔄 ACTIVE STEP IN PROGRESS:"
        echo "1. Current step: '$STEP_DESC'"
        echo "2. IF RAG available: rag_memory___hybridSearch query='$STEP_DESC best practices patterns'"
        echo "3. Work on step and update progress"
        echo "4. When done: mark #status:completed #duration:XXm"
        echo "5. Update: Use any available method to modify $TASK"
    else
        echo "✅ ALL STEPS COMPLETE:"
        echo "1. Review completed work in: $TASK"
        echo "2. Update metrics in CURRENT_IMPLEMENTATION.md (any method)"
        echo "3. IF valuable findings: document in CRITICAL_FINDINGS.md (any method)"
        echo "4. Complete task: make done"
        echo "5. IF RAG available: store lessons learned"
    fi
fi

echo ""
echo "🔥 CRITICAL REMINDERS:"
echo "• Templates are EMPTY - AI must fill with actual content"
echo "• Tasks must ALIGN with project objectives"
echo "• Always update CURRENT_IMPLEMENTATION.md after changes"
echo "• Use ANY available file tools - work must continue!"
echo "• File reading: cat, less, fs_read, editors, viewers"
echo "• File writing: fs_write, sed, echo >>, editors"
