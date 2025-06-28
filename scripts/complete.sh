#!/bin/bash

# complete.sh - Complete and archive current task

# Get the directory where the script is located to resolve all paths correctly.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
MEMORY_DIR=$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)

# Check for dependencies.
if ! command -v jq &>/dev/null; then
    echo "❌ Error: 'jq' is not installed. Please install it to continue." >&2
    echo "   (e.g., 'sudo apt-get install jq' or 'brew install jq')" >&2
    exit 1
fi

# Source git utilities (if still needed, otherwise remove)
source "$SCRIPT_DIR/git_utils.sh"

# Get task file
TASK_FILE_PATH=$1
if [ -z "$TASK_FILE_PATH" ]; then
    # Auto-detect current task (looking for .json)
    TASK_FILE_PATH=""
    for file in $(find "$MEMORY_DIR/working/inprogress" -name "*.json"); do
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
DEST="$MEMORY_DIR/working/completed/$(basename "$TASK_FILE_PATH")"

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
echo "   Archived to: $MEMORY_DIR/working/completed/"

# Auto-commit
auto_commit "Complete task: $TASK_TITLE"