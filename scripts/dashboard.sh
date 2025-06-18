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

# Find active work
PROJECT=$(find plans/inprogress -name "*.md" -exec grep -l "^type: project" {} \; 2>/dev/null | head -1)
TASK=$(find plans/inprogress -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | head -1)

# PROJECT Progress
if [ -n "$PROJECT" ]; then
    echo ""
    echo -e "${GREEN}🎯 ACTIVE PROJECT${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    
    PROJECT_TITLE=$(grep "^title:" "$PROJECT" | cut -d' ' -f2-)
    TOTAL_TASKS=$(grep -c "^- \[.\]" "$PROJECT")
    DONE_TASKS=$(grep -c "^- \[x\]" "$PROJECT")
    PERCENT=$((DONE_TASKS * 100 / (TOTAL_TASKS + 1)))
    
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
    
    TASK_TITLE=$(grep "^title:" "$TASK" | cut -d' ' -f2-)
    TOTAL_STEPS=$(grep -c "^- \[" "$TASK")
    DONE_STEPS=$(grep -c "^- \[x\]" "$TASK")
    PERCENT=$((DONE_STEPS * 100 / (TOTAL_STEPS + 1)))
    
    echo "Title: $TASK_TITLE"
    echo -n "Progress: "
    progress_bar $PERCENT
    echo " ($DONE_STEPS/$TOTAL_STEPS steps)"
    
    # Current step
    CURRENT=$(grep "#status:inprogress" "$TASK" | head -1 | sed 's/.*- \[.\] //' | cut -d'#' -f1)
    [ -n "$CURRENT" ] && echo "Current: $CURRENT"
fi

# Statistics
echo ""
echo -e "${YELLOW}📊 STATISTICS${NC}"
echo "═══════════════════════════════════════════════════════════════"
TOTAL_TASKS=$(find plans -name "*.md" -exec grep -l "^type: task" {} \; 2>/dev/null | wc -l)
COMPLETED=$(find plans/completed -name "*.md" 2>/dev/null | wc -l)
ACTIVE=$(find plans/inprogress -name "*.md" 2>/dev/null | wc -l)

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