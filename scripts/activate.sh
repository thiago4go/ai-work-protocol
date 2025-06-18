#!/bin/bash

# activate.sh - Move item from backlog to active, with WIP limit swapping

FILE_PATTERN=$1

if [ -z "$FILE_PATTERN" ]; then
    echo "❌ No file specified"
    exit 1
fi

# Find matching file in backlog
BACKLOG_FILE=$(find plans/backlog -name "*${FILE_PATTERN}*" -type f | head -1)

if [ -z "$BACKLOG_FILE" ]; then
    echo "❌ No file matching '$FILE_PATTERN' found in backlog"
    echo "   Run 'make backlog' to see available files"
    exit 1
fi

# Determine type
TYPE=$(grep "^type:" "$BACKLOG_FILE" | awk '{print $2}')
TITLE=$(grep "^title:" "$BACKLOG_FILE" | cut -d' ' -f2-)

echo "🔄 Activating $TYPE: $TITLE"

# Check for existing active item of same type
ACTIVE_FILE=$(find plans/inprogress -name "*.md" -exec grep -l "^type: $TYPE" {} \; 2>/dev/null | head -1)

if [ -n "$ACTIVE_FILE" ]; then
    ACTIVE_TITLE=$(grep "^title:" "$ACTIVE_FILE" | cut -d' ' -f2-)
    echo "   Swapping with current $TYPE: $ACTIVE_TITLE"
    
    # Move current active to backlog
    mv "$ACTIVE_FILE" plans/backlog/
    echo "   → Moved '$ACTIVE_TITLE' to backlog"
fi

# Special check for tasks - need active project
if [ "$TYPE" == "task" ]; then
    PROJECT_EXISTS=$(find plans/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | head -1)
    if [ -z "$PROJECT_EXISTS" ]; then
        echo "❌ Cannot activate task without active project"
        echo "   Activate a project first: make activate file=<project>"
        exit 1
    fi
fi

# Move backlog item to active
mv "$BACKLOG_FILE" plans/inprogress/
echo "✅ Activated: $(basename "$BACKLOG_FILE")"

# Update CURRENT_IMPLEMENTATION.md
echo ""
echo "📝 Next steps:"
echo "1. Update CURRENT_IMPLEMENTATION.md with new active work"
echo "2. Query RAG for context: rag_memory___hybridSearch query='$TITLE context'"
echo "3. Run 'make status' to see current state"

# Auto-commit if enabled
if [ "${AUTO_COMMIT:-true}" == "true" ]; then
    git add plans/backlog plans/inprogress 2>/dev/null
    git commit -m "Activate $TYPE: $TITLE" >/dev/null 2>&1 && echo "✅ Auto-committed"
fi