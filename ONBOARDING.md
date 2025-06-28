# Onboarding Guide

Welcome to the AI-powered work protocol system! This guide will walk you through the process of completing a simple project.

## 1. System Overview

The system is designed to help you manage your work in a structured and efficient way. It uses a combination of short-term file-based memory and a long-term knowledge graph (powered by a RAG system) to provide context and guidance.

## 2. Your First Project

Let's walk through a simple project to get you familiar with the system.

### Step 1: Create a Project

First, you'll need to create a project. You can do this by using the `create.sh` script:

```bash
./scripts/create.sh project "My First AI Project"
```

This will create a new project file in the `working/inprogress/` directory.

### Step 2: Create a Task

Next, you'll need to create a task within your project. You can do this with the same script:

```bash
./scripts/create.sh task "Define project requirements"
```

This will create a new task file.

### Step 3: Complete the Task

Now, you can open the task file and add the specific steps required to complete the task. Once you've completed the steps, you can mark the task as complete using the `complete.sh` script:

```bash
./memory/scripts/complete.sh
```

### Step 4: Query the RAG

At any point, you can query the RAG system for information or guidance. For example, to find information about the AI protocol, you could use a tool to call the `hybridSearch` function:

```python
hybridSearch(query="AI protocol")
```

## 3. Further Exploration

This is just a brief overview. For more detailed information, please refer to the following documents:

*   `memory/AI_PROTOCOL.md`: The core protocol for interacting with the system.
*   `memory/README.md`: General information about the memory system.
*   `rag-mcp/README.md`: Information about the RAG MCP server.
