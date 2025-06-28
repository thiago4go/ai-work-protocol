#!/bin/bash

# create.sh - Create new work from templates (JSON-based)

TEMPLATES_DIR="templates"

# Ensure necessary directories exist
mkdir -p working/inprogress
mkdir -p working/backlog
mkdir -p working/completed

# List templates if requested
if [ "$1" == "list" ] || [ -z "$1" ]; then
    echo "📚 Templates Available:"
    echo "══════════════════════"
    echo ""
    echo "PROJECTs:"
    ls -1 $TEMPLATES_DIR/projects/*.json 2>/dev/null | xargs -I {} basename {} .json | sed 's/^/  - /'
    echo ""
    echo "TASKs:"
    ls -1 $TEMPLATES_DIR/tasks/*.json 2>/dev/null | xargs -I {} basename {} .json | sed 's/^/  - /'
    exit 0
fi

# Parse arguments
TYPE=$1
TEMPLATE=$2
TITLE=$3
PARENT_PROJECT=$4

# Validate inputs
if [ -z "$TYPE" ] || [ -z "$TEMPLATE" ] || [ -z "$TITLE" ]; then
    echo "❌ Usage: create.sh [type] [template] \"title\" [parent]"
    echo "Example: create.sh project standard \"Build Feature X\""
    echo "Example: create.sh task discovery \"Research Options\""
    exit 1
fi

# Check WIP limits
if [ "$TYPE" == "project" ]; then
    ACTIVE_COUNT=$(find working/inprogress -name "*.json" -exec jq -e '.metadata.type == "project"' {} >/dev/null \; -print | wc -l || echo 0)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  PROJECT limit reached (1 active). Creating in backlog instead."
        OUTPUT_DIR="working/backlog"
    fi
elif [ "$TYPE" == "task" ]; then
    ACTIVE_COUNT=$(find working/inprogress -name "*.json" -exec jq -e '.metadata.type == "task"' {} >/dev/null \; -print | wc -l || echo 0)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  TASK limit reached (1 active). Creating in backlog instead."
        OUTPUT_DIR="working/backlog"
    fi
    
    # Auto-detect parent if not provided
    if [ -z "$PARENT_PROJECT" ]; then
        PARENT_PROJECT_FILE=""
        for file in $(find working/inprogress -name "*.json"); do
            if jq -e '.metadata.type == "project"' "$file" >/dev/null 2>&1; then
                PARENT_PROJECT_FILE="$file"
                break
            fi
        done

        if [ -z "$PARENT_PROJECT_FILE" ]; then
            echo "❌ No active PROJECT found. Create a PROJECT first."
            exit 1
        fi
        PARENT_PROJECT=$(basename "$PARENT_PROJECT_FILE" .json)
    fi
fi

# Generate filename
DATE_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE_FILE=$(date +"%Y-%m-%d")
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
FILENAME="${DATE_FILE}_${SLUG}.json"

# Set output directory (may have been changed to backlog)
OUTPUT_DIR=${OUTPUT_DIR:-"working/inprogress"}
OUTPUT="$OUTPUT_DIR/$FILENAME"

# Check template exists
TEMPLATE_PATH="$TEMPLATES_DIR/${TYPE}s/${TEMPLATE}.json"
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "❌ Template not found: $TEMPLATE_PATH"
    create.sh list
    exit 1
fi

# Read base and specific templates
BASE_TEMPLATE_PATH="$TEMPLATES_DIR/base_${TYPE}.json"

# Start with specific template content
TEMPLATE_CONTENT=$(cat "$TEMPLATE_PATH")

# Merge with base template if it exists
if [ -f "$BASE_TEMPLATE_PATH" ]; then
    BASE_CONTENT=$(cat "$BASE_TEMPLATE_PATH")
    # Merge specific template content with base workflow guidance
    # This assumes specific template has metadata and details, and base has workflow_guidance
    MERGED_CONTENT=$(echo "$TEMPLATE_CONTENT" | jq --argjson base_wf "$BASE_CONTENT" '. + $base_wf')
else
    MERGED_CONTENT="$TEMPLATE_CONTENT"
fi

# Perform variable replacements using jq
# This is done in a separate step for clarity and robustness
FINAL_CONTENT=$(echo "$MERGED_CONTENT" | \
    jq --arg date_iso "$DATE_ISO" \
       --arg title "$TITLE" \
       --arg parent_project "$PARENT_PROJECT" \
       '.metadata.created = $date_iso | .metadata.updated = $date_iso | .metadata.title = $title | .details.project_name = ($title | select(. != null)) | .details.task_name = ($title | select(. != null)) | .metadata.parent_project = ($parent_project | select(. != null))')

# Write the final JSON content to the output file
echo "$FINAL_CONTENT" > "$OUTPUT"

echo "✅ Created $TYPE: $FILENAME"

# Auto-commit
if [ "${AUTO_COMMIT:-true}" == "true" ] && git rev-parse --git-dir > /dev/null 2>&1; then
    git add "$OUTPUT" 2>/dev/null
    git commit -m "Create $TYPE: $TITLE" >/dev/null 2>&1 && echo "✅ Auto-committed"
fi