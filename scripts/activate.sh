#!/bin/bash

# activate.sh - Move item from backlog to active, with WIP limit swapping

FILE_PATTERN=$1

if [ -z "$FILE_PATTERN" ]; then
    echo "❌ No file specified"
    exit 1
fi

# Find matching file in backlog
BACKLOG_FILE=$(find working/backlog -name "*${FILE_PATTERN}*.json" -type f | head -1)

if [ -z "$BACKLOG_FILE" ]; then
    echo "❌ No file matching '$FILE_PATTERN' found in backlog"
    exit 1
fi

# Determine type and title using jq
TYPE=$(jq -r '.metadata.type' "$BACKLOG_FILE")
TITLE=$(jq -r '.metadata.title' "$BACKLOG_FILE")

echo "🔄 Activating $TYPE: $TITLE"

# Check for existing active item of same type
ACTIVE_FILE=$(find working/inprogress -name "*.json" -exec jq -e '.metadata.type == "'"$TYPE"'"' {} >/dev/null \; -print | head -1)

if [ -n "$ACTIVE_FILE" ]; then
    ACTIVE_TITLE=$(jq -r '.metadata.title' "$ACTIVE_FILE")
    echo "   Swapping with current $TYPE: $ACTIVE_TITLE"
    
    # Move current active to backlog
    mv "$ACTIVE_FILE" working/backlog/
    echo "   → Moved '$ACTIVE_TITLE' to backlog"
fi

# Special check for tasks - need active project
if [ "$TYPE" == "task" ]; then
    PROJECT_EXISTS=$(find working/inprogress -name "*.json" -exec jq -e '.metadata.type == "project"' {} >/dev/null \; -print | head -1)
    if [ -z "$PROJECT_EXISTS" ]; then
        echo "❌ Cannot activate task without active project"
        exit 1
    fi
fi

# Move backlog item to active
mv "$BACKLOG_FILE" working/inprogress/
echo "✅ Activated: $(basename "$BACKLOG_FILE")"