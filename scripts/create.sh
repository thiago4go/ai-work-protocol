#!/bin/bash

# create.sh - Create new work from templates

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
    ACTIVE_COUNT=$(find working/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | wc -l || echo 0)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  PROJECT limit reached (1 active). Creating in backlog instead."
        echo "   Complete current project or use 'make activate' to swap."
        OUTPUT_DIR="working/backlog"
    fi
elif [ "$TYPE" == "task" ]; then
    ACTIVE_COUNT=$(find working/inprogress -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | wc -l || echo 0)
    if [ "$ACTIVE_COUNT" -ge 1 ]; then
        echo "⚠️  TASK limit reached (1 active). Creating in backlog instead."
        echo "   Complete current task or use 'make activate' to swap."
        OUTPUT_DIR="working/backlog"
    fi
    
    # Auto-detect parent if not provided
    if [ -z "$PARENT_PROJECT" ]; then
        PARENT_PROJECT=$(find working/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | head -1 | xargs basename 2>/dev/null)
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
OUTPUT_DIR=${OUTPUT_DIR:-"working/inprogress"}
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

# Critical AI Instructions
echo "🤖 CRITICAL AI NEXT ACTIONS:"
echo "═══════════════════════════"
if [ "$TYPE" == "project" ]; then
    echo "1. READ the template: Use any available method to read $OUTPUT"
    echo "   Options: cat, less, fs_read, text editor, file viewer"
    echo "2. IF RAG available: rag_memory___hybridSearch query=\"$TITLE similar projects patterns requirements\""
    echo "3. FILL project details using any available method:"
    echo "   - Define clear objectives and deliverables"
    echo "   - Set success criteria and constraints"
    echo "   - Identify required resources and timeline"
    echo "4. UPDATE file: Use any method (fs_write, text editor, sed, etc.)"
    echo "5. UPDATE state: Modify CURRENT_IMPLEMENTATION.md (any method)"
    echo "6. IF RAG available: rag_memory___createEntities (store project context)"
    echo ""
    echo "⚠️  TEMPLATE IS EMPTY - YOU MUST FILL IT WITH ACTUAL PROJECT CONTENT!"
elif [ "$TYPE" == "task" ]; then
    # Get parent project info
    if [ -n "$PARENT_PROJECT" ]; then
        PROJECT_PATH="working/inprogress/$PARENT_PROJECT"
        echo "1. READ parent project: Use any method to read $PROJECT_PATH"
        echo "2. READ task template: Use any method to read $OUTPUT"
        echo "3. IF RAG available: rag_memory___hybridSearch query=\"$TITLE $(basename $PARENT_PROJECT .md) task breakdown steps\""
        echo "4. ALIGN task with project using any available editing method:"
        echo "   - Ensure task contributes to project objectives"
        echo "   - Break down into 3-7 concrete steps"
        echo "   - Set realistic time estimates per step"
        echo "   - Define clear completion criteria"
        echo "5. UPDATE task file: Use any method (fs_write, editor, sed, etc.)"
        echo "6. UPDATE state: Modify CURRENT_IMPLEMENTATION.md (any method)"
        echo "7. IF RAG available: rag_memory___createEntities (link task to project)"
    else
        echo "1. READ task template: Use any method to read $OUTPUT"
        echo "2. IF RAG available: rag_memory___hybridSearch query=\"$TITLE task breakdown best practices\""
        echo "3. DEFINE task steps and estimates (any editing method)"
        echo "4. UPDATE task file: Use any available method"
    fi
    echo ""
    echo "⚠️  TEMPLATE IS EMPTY - YOU MUST FILL IT WITH ACTUAL TASK STEPS!"
fi
echo ""
echo "🔧 TOOL FLEXIBILITY:"
echo "• File Reading: cat, less, fs_read, nano, vim, text editors"
echo "• File Writing: fs_write, sed, echo >>, nano, vim, text editors"
echo "• Use whatever tools are available - the work must continue!"
echo ""
echo "🚨 REMEMBER: Templates are just starting points - the AI must create the actual content!"

# Remove only instructions section from file (keep workflow)
sed -i '/^---INSTRUCTIONS---$/,/^---END-INSTRUCTIONS---$/d' "$OUTPUT"

# Auto-commit
if [ "${AUTO_COMMIT:-true}" == "true" ] && git rev-parse --git-dir > /dev/null 2>&1; then
    git add "$OUTPUT" 2>/dev/null
    git commit -m "Create $TYPE: $TITLE" >/dev/null 2>&1 && echo "✅ Auto-committed"
fi