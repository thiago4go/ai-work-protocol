#!/bin/bash

# status.sh - Show current work status

# Get the directory where the script is located to resolve all paths correctly.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
MEMORY_DIR=$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)

echo "📊 Memory System Status"
echo "═══════════════════════"

# List active work files
ACTIVE_PROJECT_FILES=$(find working/inprogress -name "*.json" 2>/dev/null)

if [ -z "$ACTIVE_PROJECT_FILES" ]; then
    echo "❌ No active work found."
else
    echo "✅ Active work files:"
    echo "$ACTIVE_PROJECT_FILES"
fi

# Quick stats
echo ""
echo "📈 Stats:"
# Correctly count active files: use grep -c . to count non-empty lines
ACTIVE_COUNT=$(find working/inprogress -name "*.json" 2>/dev/null | grep -c .)
echo "   Active: $ACTIVE_COUNT/2 (max)"
echo "   Backlog: $(find working/backlog -name "*.json" 2>/dev/null | wc -l) items"
echo "   Completed: $(find "$MEMORY_DIR/working/completed" -name "*.json" 2>/dev/null | wc -l) plans"

echo ""
echo "💡 Next Steps:"
echo "   - Use 'make project' or 'make task' to create new work."
echo "   - Use 'make activate' to move items from backlog to active."
echo "   - Use 'make done' to complete the current task."
   echo "   - Use 'make status' to check progress."
echo "   - Use 'make backlog' to view queued work."
echo "   - Consult AI_PROTOCOL.md for detailed guidance."