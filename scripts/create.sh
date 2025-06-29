#!/bin/bash

# create.sh - Create new work from templates (JSON-based)
# This script is designed to be run from any directory.

# --- Setup and Validation ---

# Get the directory where the script is located to resolve all paths correctly.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
MEMORY_DIR=$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)

# Check for dependencies.
if ! command -v jq &>/dev/null; then
    echo "❌ Error: 'jq' is not installed. Please install it to continue." >&2
    echo "   (e.g., 'sudo apt-get install jq' or 'brew install jq')" >&2
    exit 1
fi

# --- Configuration ---

TEMPLATES_DIR="$MEMORY_DIR/templates"
WORKING_DIR="$MEMORY_DIR/working"

# --- Directory Initialization ---

# Ensure necessary working directories exist.
mkdir -p "$WORKING_DIR/inprogress"
mkdir -p "$WORKING_DIR/backlog"
mkdir -p "$WORKING_DIR/completed"

# --- Functions ---

# Function to list available templates.
list_templates() {
    echo "📚 Templates Available:"
    echo "══════════════════════"
    echo ""
    echo "PROJECTs:"
    ls -1 "$TEMPLATES_DIR/projects/"*.json 2>/dev/null | xargs -I {} basename {} .json | sed 's/^/  - /'
    echo ""
    echo "TASKs:"
    ls -1 "$TEMPLATES_DIR/tasks/"*.json 2>/dev/null | xargs -I {} basename {} .json | sed 's/^/  - /'
    exit 0
}

# --- Main Logic ---

# Handle 'list' command or no arguments.
if [ "$1" == "list" ] || [ -z "$1" ]; then
    list_templates
fi

# Parse arguments.
TYPE=$1
TEMPLATE=$2
TITLE=$3
PARENT_PROJECT=$4

# Validate required inputs.
if [ -z "$TYPE" ] || [ -z "$TEMPLATE" ] || [ -z "$TITLE" ]; then
    echo "❌ Usage: $0 [type] [template] "title" [parent]" >&2
    echo "Example: $0 project standard "Build Feature X"" >&2
    echo "Example: $0 task discovery "Research Options"" >&2
    exit 1
    exit 1
fi

# --- WIP Limit and Parent Project Handling ---

OUTPUT_DIR="$WORKING_DIR/inprogress" # Default output directory.

if [ "$TYPE" == "project" ]; then
    # Check project WIP limit.
    ACTIVE_COUNT=$(find "$WORKING_DIR/inprogress" -name "*.json" -print0 | xargs -0 jq -r '.metadata.type' | grep -c "project")
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  PROJECT limit reached (1 active). Creating in backlog instead."
        OUTPUT_DIR="$WORKING_DIR/backlog"
    fi
elif [ "$TYPE" == "task" ]; then
    # Check task WIP limit.
    ACTIVE_COUNT=$(find "$WORKING_DIR/inprogress" -name "*.json" -exec jq -e '.metadata.type == "task"' {} >/dev/null \; -print 2>/dev/null | wc -l)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  TASK limit reached (1 active). Creating in backlog instead."
        OUTPUT_DIR="$WORKING_DIR/backlog"
    fi

    # Auto-detect parent project if not provided.
    if [ -z "$PARENT_PROJECT" ]; then
        PARENT_PROJECT_FILE=$(find "$WORKING_DIR/inprogress" -name "*.json" -print -quit)
        if [ -z "$PARENT_PROJECT_FILE" ]; then
            echo "❌ No active PROJECT found in '$WORKING_DIR/inprogress'. Create a PROJECT first." >&2
            exit 1
        fi
        PARENT_PROJECT=$(basename "$PARENT_PROJECT_FILE" .json)
    fi
fi

# --- File and Content Generation ---

# Generate a clean filename.
DATE_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE_FILE=$(date +"%Y-%m-%d")
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9]/-/g' -e 's/--*/-/g' -e 's/^-\|-$//g')
FILENAME="${DATE_FILE}_${SLUG}.json"
OUTPUT_PATH="$OUTPUT_DIR/$FILENAME"

# Check if the template file exists.
TEMPLATE_PATH="$TEMPLATES_DIR/${TYPE}s/${TEMPLATE}.json"
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "❌ Template not found: $TEMPLATE_PATH" >&2
    # Use $0 for robust recursive call.
    "$0" list
    exit 1
fi

# Read base and specific templates.
BASE_TEMPLATE_PATH="$TEMPLATES_DIR/base_${TYPE}.json"
TEMPLATE_CONTENT=$(cat "$TEMPLATE_PATH")

# Merge with base template if it exists.
if [ -f "$BASE_TEMPLATE_PATH" ]; then
    BASE_CONTENT=$(cat "$BASE_TEMPLATE_PATH")
    MERGED_CONTENT=$(echo "$TEMPLATE_CONTENT" | jq --argjson base_wf "$BASE_CONTENT" '. + $base_wf')
else
    MERGED_CONTENT="$TEMPLATE_CONTENT"
fi

# Perform variable replacements using jq.
FINAL_CONTENT=$(echo "$MERGED_CONTENT" | jq --arg date_iso "$DATE_ISO" --arg title "$TITLE" --arg parent_project "$PARENT_PROJECT" --arg type "$TYPE" '.metadata.created = $date_iso | .metadata.updated = $date_iso | .metadata.title = $title | .metadata.type = $type | .details.project_name = ($title | select(. != null)) | .details.task_name = ($title | select(. != null)) | .metadata.parent_project = ($parent_project | select(. != null))')

# --- Final Actions ---

# Write the final JSON content to the output file.
echo "$FINAL_CONTENT" >"$OUTPUT_PATH"

echo "✅ Created $TYPE: $FILENAME (in $OUTPUT_DIR)"

# Auto-commit if in a git repository.
if [ "${AUTO_COMMIT:-true}" == "true" ] && git -C "$MEMORY_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$MEMORY_DIR" add "$OUTPUT_PATH"
    if git -C "$MEMORY_DIR" commit -m "Create $TYPE: $TITLE" >/dev/null 2>&1; then
        echo "✅ Auto-committed"
    fi
fi
