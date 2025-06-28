# SCRIPTS AS MEMORY CONTROL PROTOCOLS (MCPs)

This document outlines the available shell scripts as if they were direct tool calls for the AI agent. The AI agent should use the `run_shell_command` tool to execute these scripts, providing the necessary arguments.

## Core Workflow Scripts

### 1. `status.sh`

**Description**: Displays the current status of active projects and tasks, including WIP limits and basic statistics. Provides high-level guidance on next actions based on the current state.

**Usage**: `run_shell_command(command='scripts/status.sh', description='Get current memory system status.')`

**Arguments**: None

**Expected Output**: Human-readable text output detailing active project/task, progress, and general next steps.

**AI Usage**: Call this at the beginning of a session or when needing an overview of the current work state.

### 2. `create.sh`

**Description**: Creates a new project or task file from a specified template. Handles WIP limits by moving new items to the backlog if limits are reached. Populates the new JSON file with initial metadata and performs variable substitutions.

**Usage**: `run_shell_command(command='scripts/create.sh <type> <template> "<title>" [parent_project]', description='Create a new project or task.')`

**Arguments**:
- `<type>` (string, required): `project` or `task`.
- `<template>` (string, required): The name of the template (e.g., `standard`, `bugfix`, `implementation`, `discovery`). Corresponds to a `.json` file in `templates/projects/` or `templates/tasks/`.
- `"<title>"` (string, required): The title of the new project or task. Must be enclosed in quotes if it contains spaces.
- `[parent_project]` (string, optional): For tasks, the slug (filename without `.json`) of the parent project. If omitted for a task, the script attempts to auto-detect the active project.

**Expected Output**: Confirmation message of creation, including the filename. May include warnings if WIP limits are hit.

**AI Usage**: Call this when a new project or task needs to be initiated. After creation, the AI should read the newly created JSON file to fill in detailed content.

### 3. `activate.sh`

**Description**: Moves a specified project or task from the `working/backlog/` directory to `working/inprogress/`. If an item of the same type is already active, it will be swapped (moved to `working/backlog/`). Ensures only one project and one task are active at a time.

**Usage**: `run_shell_command(command='scripts/activate.sh <file_pattern>', description='Activate a project or task from backlog.')`

**Arguments**:
- `<file_pattern>` (string, required): A pattern to match the filename (or part of it) of the project/task in the backlog. Example: `2025-06-28_my-project`.

**Expected Output**: Confirmation of activation and any swaps that occurred. Warnings if an active project is required for a task.

**AI Usage**: Call this when a new project/task needs to be brought into active work, or when swapping between backlog items.

### 4. `complete.sh`

**Description**: Marks the current active task as completed and moves its JSON file from `working/inprogress/` to `working/completed/`. Updates the task's status within its JSON content.

**Usage**: `run_shell_command(command='scripts/complete.sh [task_filename]', description='Complete the current active task.')`

**Arguments**:
- `[task_filename]` (string, optional): The filename (e.g., `2025-06-28_my-task.json`) of the task to complete. If omitted, the script attempts to auto-detect the currently active task.

**Expected Output**: Confirmation of task completion and archiving. Provides guidance for the AI to update `CURRENT_IMPLEMENTATION.json` and store lessons learned in RAG.

**AI Usage**: Call this when all steps of an active task are finished. Follow the output guidance to update state and RAG.

### 5. `dashboard.sh`

**Description**: Provides a visual, human-readable dashboard of the current work progress, including active project/task titles, progress bars, and overall statistics. Primarily for human consumption.

**Usage**: `run_shell_command(command='scripts/dashboard.sh', description='Display visual progress dashboard.')`

**Arguments**: None

**Expected Output**: Formatted text output representing the dashboard.

**AI Usage**: Infrequently, for a high-level overview, or if specifically requested by a human user to display progress.

### 6. `git_utils.sh`

**Description**: This script contains utility functions for Git operations (e.g., `auto_commit`, `checkpoint_commit`). It is primarily *sourced* by other scripts (`create.sh`, `activate.sh`, `complete.sh`) and not intended for direct execution as a standalone command by the AI.

**Usage**: Not for direct `run_shell_command` by the AI. Its functions are called internally by other workflow scripts.

**AI Usage**: The AI should be aware that other scripts handle Git commits automatically. It does not need to call this directly.

---

**AI Interaction Principle**: The AI should use these scripts as its primary interface for managing the workflow. After executing a script, the AI should always read `CURRENT_IMPLEMENTATION.json` and query RAG to re-establish its full context and determine the next logical step, as per `AI_PROTOCOL.md`.
