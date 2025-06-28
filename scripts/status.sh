#!/bin/bash

# status.sh - Show current work status

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
echo "   Completed: $(find working/completed -name "*.json" 2>/dev/null | wc -l) plans"