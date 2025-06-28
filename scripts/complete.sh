#!/bin/bash

# complete.sh - Complete and archive current task

# Source git utilities (if still needed, otherwise remove)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/git_utils.sh"

# Get task file
TASK_FILE_PATH=$1
if [ -z "$TASK_FILE_PATH" ]; then
    # Auto-detect current task (looking for .json)
    TASK_FILE_PATH=""
    for file in $(find working/inprogress -name "*.json"); do
        if jq -e '.metadata.type == "task"' "$file" >/dev/null 2>&1; then
            TASK_FILE_PATH="$file"
            break
        fi
    done

    if [ -z "$TASK_FILE_PATH" ]; then
        echo "❌ No active task found"
        exit 1
    fi
fi

SOURCE="$TASK_FILE_PATH"
DEST="working/completed/$(basename "$TASK_FILE_PATH")"

# Verify task exists
if [ ! -f "$SOURCE" ]; then
    echo "❌ Task not found: $SOURCE"
    exit 1
fi

# Read task JSON, update status and completed timestamp
TASK_CONTENT=$(cat "$SOURCE")
DATE_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
UPDATED_TASK_CONTENT=$(echo "$TASK_CONTENT" | jq --arg date_iso "$DATE_ISO" '.metadata.status = "completed" | .metadata.updated = $date_iso')

# Get task info for messages
TASK_TITLE=$(echo "$TASK_CONTENT" | jq -r '.metadata.title')
PARENT_PROJECT_SLUG=$(echo "$TASK_CONTENT" | jq -r '.metadata.parent_project')

# Move to completed
mv "$SOURCE" "$DEST"

# Write updated content to destination
echo "$UPDATED_TASK_CONTENT" > "$DEST"

echo "✅ Completed task: $TASK_TITLE"
echo "   Archived to: working/completed/"

# Auto-commit
auto_commit "Complete task: $TASK_TITLE"
