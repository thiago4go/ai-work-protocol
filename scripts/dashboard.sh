#!/bin/bash

# dashboard.sh - Visual progress dashboard

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Progress bar function
progress_bar() {
    local percent=$1
    local width=30
    local filled=$((percent * width / 100))
    local empty=$((width - filled))
    
    printf "["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%%" "$percent"
}

clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    MEMORY SYSTEM DASHBOARD                   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"

# Find active work (now looking for .json files)
PROJECT=$(find working/inprogress -name "*.json" -exec jq -e '.metadata.type == "project"' {} >/dev/null \; -print | head -1)
TASK=$(find working/inprogress -name "*.json" -exec jq -e '.metadata.type == "task"' {} >/dev/null \; -print | head -1)

# PROJECT Progress
if [ -n "$PROJECT" ]; then
    echo ""
    echo -e "${GREEN}🎯 ACTIVE PROJECT${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    
    PROJECT_TITLE=$(jq -r '.metadata.title' "$PROJECT")
    
    # For projects, value_driven_task_sequence is an array of strings, not objects with status.
    # So, we'll just show the total number of planned tasks for now.
    TOTAL_TASKS=$(jq '.details.value_driven_task_sequence | length' "$PROJECT" 2>/dev/null || echo 0)
    DONE_TASKS=0 # Cannot determine from string array without more complex parsing
    
    PERCENT=0
    if [ "$TOTAL_TASKS" -gt 0 ]; then
        PERCENT=$((DONE_TASKS * 100 / TOTAL_TASKS))
    fi
    
    echo "Title: $PROJECT_TITLE"
    echo -n "Progress: "
    progress_bar $PERCENT
    echo " ($DONE_TASKS/$TOTAL_TASKS tasks)"
fi

# TASK Progress
if [ -n "$TASK" ]; then
    echo ""
    echo -e "${BLUE}📋 ACTIVE TASK${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    
    TASK_TITLE=$(jq -r '.metadata.title' "$TASK")
    
    # Steps are objects with a status field, so we can calculate progress
    TOTAL_STEPS=$(jq '.details.steps | length' "$TASK" 2>/dev/null || echo 0)
    DONE_STEPS=$(jq '.details.steps | map(select(.status == "completed")) | length' "$TASK" 2>/dev/null || echo 0)
    
    PERCENT=0
    if [ "$TOTAL_STEPS" -gt 0 ]; then
        PERCENT=$((DONE_STEPS * 100 / TOTAL_STEPS))
    fi
    
    echo "Title: $TASK_TITLE"
    echo -n "Progress: "
    progress_bar $PERCENT
    echo " ($DONE_STEPS/$TOTAL_STEPS steps)"
    
    # Current step
    CURRENT_STEP_DESC=$(jq -r '.details.steps[] | select(.status == "pending") | .description' "$TASK" | head -1)
    [ -n "$CURRENT_STEP_DESC" ] && echo "Current: $CURRENT_STEP_DESC"
fi

# Statistics
echo ""
echo -e "${YELLOW}📊 STATISTICS${NC}"
echo "═══════════════════════════════════════════════════════════════"
TOTAL_TASKS=$(find working -name "*.json" -print0 | xargs -0 jq -r '.metadata.type' | grep -c "task")
COMPLETED=$(find working/completed -name "*.json" 2>/dev/null | wc -l)
ACTIVE=$(find working/inprogress -name "*.json" 2>/dev/null | wc -l)

echo "Total Tasks: $TOTAL_TASKS"
echo "Completed: $COMPLETED"
echo "Active: $ACTIVE/2 (limit)"

# Git status
if git rev-parse --git-dir >/dev/null 2>&1; then
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l)
    [ $CHANGES -gt 0 ] && echo -e "${YELLOW}Uncommitted changes: $CHANGES${NC}"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"