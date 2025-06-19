#!/bin/bash

# create.sh - Create new work from templates

TEMPLATES_DIR="templates"

# Ensure necessary directories exist
mkdir -p plans/inprogress
mkdir -p plans/backlog
mkdir -p plans/completed

# List templates if requested
if [ "$1" == "list" ] || [ -z "$1" ]; then
    echo "📚 Templates Available:"
    echo "══════════════════════"
    echo ""
    echo "PROJECTs:"
    ls -1 $TEMPLATES_DIR/projects/*.md 2>/dev/null | xargs -I {} basename {} .md | sed 's/^/  - /'
    echo ""
    echo "TASKs:"
    ls -1 $TEMPLATES_DIR/tasks/*.md 2>/dev/null | xargs -I {} basename {} .md | sed 's/^/  - /'
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
    ACTIVE_COUNT=$(find plans/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | wc -l || echo 0)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  PROJECT limit reached (1 active). Creating in backlog instead."
        echo "   Complete current project or use 'make activate' to swap."
        OUTPUT_DIR="plans/backlog"
    fi
elif [ "$TYPE" == "task" ]; then
    ACTIVE_COUNT=$(find plans/inprogress -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | wc -l || echo 0)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  TASK limit reached (1 active). Creating in backlog instead."
        echo "   Complete current task or use 'make activate' to swap."
        OUTPUT_DIR="plans/backlog"
    fi
    
    # Auto-detect parent if not provided
    if [ -z "$PARENT_PROJECT" ]; then
        PARENT_PROJECT=$(find plans/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | head -1 | xargs basename 2>/dev/null)
        if [ -z "$PARENT_PROJECT" ]; then
            echo "❌ No PROJECT found. Create a PROJECT first."
            exit 1
        fi
    fi
fi

# Generate filename
DATE=$(date +"%Y-%m-%d")
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
FILENAME="${DATE}_${SLUG}.md"

# Set output directory (may have been changed to backlog)
OUTPUT_DIR=${OUTPUT_DIR:-"plans/inprogress"}
OUTPUT="$OUTPUT_DIR/$FILENAME"

# Check template exists
TEMPLATE_PATH="$TEMPLATES_DIR/${TYPE}s/${TEMPLATE}.md"
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "❌ Template not found: $TEMPLATE_PATH"
    create.sh list
    exit 1
fi

# Check for base template
BASE_TEMPLATE="$TEMPLATES_DIR/base_${TYPE}.md"
TEMP_FILE="/tmp/merged_template_$$.md"

# If base template exists, merge it with specific template
if [ -f "$BASE_TEMPLATE" ]; then
    # Copy template first
    cp "$TEMPLATE_PATH" "$TEMP_FILE"
    
    # Extract workflow from base template and insert at end of file
    if [ -f "$BASE_TEMPLATE" ]; then
        # Extract base workflow (without markers)
        awk '/^---WORKFLOW-BASE---$/,/^---END-WORKFLOW-BASE---$/' "$BASE_TEMPLATE" | grep -v "^---WORKFLOW-BASE---$" | grep -v "^---END-WORKFLOW-BASE---$" > /tmp/base_workflow_$$.md
        
        # Append base workflow at end of file
        echo "" >> "$TEMP_FILE"
        echo "## Workflow from Base Template" >> "$TEMP_FILE"
        cat /tmp/base_workflow_$$.md >> "$TEMP_FILE"
        
        # Clean up temp file
        rm -f /tmp/base_workflow_$$.md
    fi
    
    # Use merged template
    cp "$TEMP_FILE" "$OUTPUT"
    rm -f "$TEMP_FILE"
else
    # No base template, use as-is
    cp "$TEMPLATE_PATH" "$OUTPUT"
fi

# Replace variables
sed -i "s/{{DATE}}/$(date -u +"%Y-%m-%dT%H:%M:%SZ")/g" "$OUTPUT"
sed -i "s/{{TITLE}}/$TITLE/g" "$OUTPUT"
[ -n "$PARENT_PROJECT" ] && sed -i "s/{{PARENT_PROJECT}}/$PARENT_PROJECT/g" "$OUTPUT"

echo "✅ Created $TYPE: $FILENAME"
echo ""

# Show template instructions
echo "📋 Template Instructions:"
echo "════════════════════════"
awk '/^---INSTRUCTIONS---$/,/^---END-INSTRUCTIONS---$/' "$OUTPUT" | grep -v "^---" | head -20
echo ""
echo "Open $OUTPUT to see full instructions and begin work."

# Remove only instructions section from file (keep workflow)
sed -i '/^---INSTRUCTIONS---$/,/^---END-INSTRUCTIONS---$/d' "$OUTPUT"

# Auto-commit
if [ "${AUTO_COMMIT:-true}" == "true" ] && git rev-parse --git-dir > /dev/null 2>&1; then
    git add "$OUTPUT" 2>/dev/null
    git commit -m "Create $TYPE: $TITLE" >/dev/null 2>&1 && echo "✅ Auto-committed"
fi