#!/bin/bash

# complete.sh - Complete and archive current task

# Source git utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/git_utils.sh"

# Get task file
TASK_FILE="$1"
if [ -z "$TASK_FILE" ]; then
    # Auto-detect current task
    TASK_FILE=$(find working/inprogress -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | head -1 | xargs basename 2>/dev/null)
    if [ -z "$TASK_FILE" ]; then
        echo "❌ No active task found"
        exit 1
    fi
fi

SOURCE="working/inprogress/$TASK_FILE"
DEST="working/completed/$TASK_FILE"

# Verify task exists
if [ ! -f "$SOURCE" ]; then
    echo "❌ Task not found: $SOURCE"
    exit 1
fi

# Get task info
TASK_TITLE=$(grep "^title:" "$SOURCE" | cut -d' ' -f2-)
PARENT_PROJECT=$(grep "^parent_project:" "$SOURCE" | cut -d' ' -f2-)

# Move to completed
mv "$SOURCE" "$DEST"

# Update status
sed -i 's/status: active/status: completed/' "$DEST"
sed -i "s/updated: .*/completed: $(date -u +"%Y-%m-%dT%H:%M:%SZ")/" "$DEST"

echo "✅ Completed task: $TASK_TITLE"
echo "   Archived to: working/completed/"

# Update parent PROJECT if exists
if [ -n "$PARENT_PROJECT" ] && [ -f "working/inprogress/$PARENT_PROJECT" ]; then
    # Find and mark the corresponding task
    sed -i "0,/\[ \].*$TASK_TITLE/{s/\[ \]/[x]/}" "working/inprogress/$PARENT_PROJECT"
    echo "   Updated task in: $PARENT_PROJECT"
fi

# Auto-commit
auto_commit "Complete task: $TASK_TITLE"

# Prompt for reflection
echo ""
echo "📝 REFLECTION TIME"
echo "══════════════════"
echo "Add a lesson learned to CRITICAL_FINDINGS.md:"
echo ""
echo "## $(date +%Y-%m-%d) - $TASK_TITLE"
echo "**What worked:** "
echo "**Challenge:** "
echo "**Learning:** "
echo ""
echo "This helps future work!"