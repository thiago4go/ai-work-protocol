#!/bin/bash

# git_utils.sh - Shared git utilities for auto-commit functionality

# Function to check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir > /dev/null 2>&1
    return $?
}

# Function to check if there are changes to commit
has_changes() {
    if [ -n "$(git status --porcelain)" ]; then
        return 0
    else
        return 1
    fi
}

# Function to generate commit message based on action
generate_commit_msg() {
    local action="$1"
    local file="$2"
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    
    case "$action" in
        "complete_plan")
            echo "✅ Completed plan: $(basename "$file" .md) - $timestamp"
            ;;
        "new_epic")
            echo "🎯 Created new EPIC: $(basename "$file" .md) - $timestamp"
            ;;
        "new_plan")
            echo "📋 Created new plan: $(basename "$file" .md) - $timestamp"
            ;;
        "update_status")
            echo "📊 Updated status: $file - $timestamp"
            ;;
        *)
            echo "🔄 Memory system update: $action - $timestamp"
            ;;
    esac
}

# Function to perform auto-commit
auto_commit() {
    local action="$1"
    local file="$2"
    local push_enabled="${AUTO_PUSH:-false}"
    
    if ! is_git_repo; then
        echo "⚠️  Not in a git repository. Skipping auto-commit."
        return 1
    fi
    
    if ! has_changes; then
        echo "ℹ️  No changes to commit."
        return 0
    fi
    
    # Stage all changes in the memory directory
    git add -A .
    
    # Generate and apply commit message
    local commit_msg=$(generate_commit_msg "$action" "$file")
    git commit -m "$commit_msg" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "🔄 Auto-committed: $commit_msg"
        
        # Push if enabled
        if [ "$push_enabled" = "true" ]; then
            git push > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "☁️  Changes pushed to remote"
            else
                echo "⚠️  Failed to push to remote"
            fi
        fi
        
        return 0
    else
        echo "⚠️  Auto-commit failed"
        return 1
    fi
}

# Function to create a checkpoint commit
checkpoint_commit() {
    local message="$1"
    
    if ! is_git_repo; then
        return 1
    fi
    
    if has_changes; then
        git add -A .
        git commit -m "🔖 Checkpoint: $message - $(date -u +"%Y-%m-%d %H:%M:%S UTC")" > /dev/null 2>&1
        echo "🔖 Created checkpoint: $message"
    fi
}