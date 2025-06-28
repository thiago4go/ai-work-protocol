#!/bin/bash

# activate.sh - Move item from backlog to active, with WIP limit swapping

FILE_PATTERN_RAW=$1

if [ -z "$FILE_PATTERN_RAW" ]; then
    echo "❌ No file specified"
    exit 1
fi

# Slugify the input pattern to match filenames
FILE_PATTERN=$(echo "$FILE_PATTERN_RAW" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

# Find matching file in backlog
BACKLOG_FILE=$(find working/backlog -name "*${FILE_PATTERN}*.json" -type f | head -1)

if [ -z "$BACKLOG_FILE" ]; then
    echo "❌ No file matching '$FILE_PATTERN_RAW' found in backlog"
    exit 1
fi

# Determine type and title using jq
TYPE=$(jq -r '.metadata.type' "$BACKLOG_FILE")
TITLE=$(jq -r '.metadata.title' "$BACKLOG_FILE")

echo "🔄 Activating $TYPE: $TITLE"

# Check for existing active item of same type
ACTIVE_FILE=""
for file in $(find working/inprogress -name "*.json"); do
    if jq -e '.metadata.type == "'"$TYPE"'"' "$file" >/dev/null 2>&1; then
        ACTIVE_FILE="$file"
        break
    fi
done

if [ -n "$ACTIVE_FILE" ]; then
    ACTIVE_TITLE=$(jq -r '.metadata.title' "$ACTIVE_FILE")
    echo "   Swapping with current $TYPE: $ACTIVE_TITLE"
    
    # Move current active to backlog
    mv "$ACTIVE_FILE" working/backlog/
    echo "   → Moved '$ACTIVE_TITLE' to backlog"
fi

# Special check for tasks - need active project
if [ "$TYPE" == "task" ]; then
    PROJECT_EXISTS=""
    for file in $(find working/inprogress -name "*.json"); do
        if jq -e '.metadata.type == "project"' "$file" >/dev/null 2>&1; then
            PROJECT_EXISTS="$file"
            break
        fi
    done

    if [ -z "$PROJECT_EXISTS" ]; then
        echo "❌ Cannot activate task without active project"
        exit 1
    fi
fi

# Move backlog item to active
mv "$BACKLOG_FILE" working/inprogress/
echo "✅ Activated: $(basename "$BACKLOG_FILE")"