---
name: project-manager
description: End-to-end project management workflow: idea input → AI task breakdown → user confirmation → Linear issue creation → task execution → Git sync. Use when managing development projects through conversation, integrating with Linear for task tracking and Git for version control.
---

# Project Manager

## Overview

This skill provides a complete project management workflow from initial idea to Git commits, with Linear as the task tracking system and Git for version control.

## Setup Requirements

Before using this skill, ensure you have:

1. **Linear Account & API Key**
   - Create a free account at https://linear.app
   - Generate API key in Settings → API → Create personal API key
   - Store securely (do not commit to Git)

2. **Git Repository**
   - Initialized git repository in your project directory
   - Remote configured (GitHub/GitLab/etc.)

3. **Configuration**
   - Provide Linear API key when prompted
   - Confirm Linear workspace ID and project ID

## Workflow

### Phase 1: Idea Input & Task Breakdown

**User Action:** Input a project idea or feature request

**AI Action:**
- Analyze the idea
- Break down into actionable tasks
- Estimate priorities and dependencies
- Present structured task list

**Example User Request:**
> "I want to build a notes app with search, tags, and markdown support"

**AI Response Structure:**
```markdown
## Task Breakdown

1. [P0] Set up project structure
2. [P0] Initialize database schema
3. [P1] Create markdown editor component
4. [P1] Implement search functionality
5. [P2] Add tagging system
6. [P2] Style UI components
```

### Phase 2: Task Confirmation

**User Action:** Review and approve tasks

**AI Action:**
- Wait for user confirmation/modifications
- Incorporate user feedback
- Finalize task list

**Confirmation Prompt:**
> "Are these tasks correct? Reply:
> - `y` to proceed to Linear
> - `edit <changes>` to modify
> - `add <new task>` to add tasks"

### Phase 3: Linear Sync

**AI Action:**
- Create issues in Linear via GraphQL API
- Assign appropriate labels and priorities
- Set dependencies where needed
- Provide confirmation with issue URLs

**Linear Issue Template:**
- Title: Task description
- Description: Detailed requirements + acceptance criteria
- Priority: P0/P1/P2/P3
- Labels: project-name, component, type
- Status: Backlog

**Script:** `scripts/linear_sync.py`

### Phase 4: Task Execution

**User Action:** Select task to work on

**Commands:**
- `/task start <issue-id>` - Begin working on a task
- `/task status` - Show current task context
- `/task notes <note>` - Add notes to current task

**AI Action:**
- Retrieve task details from Linear
- Provide context and starting point
- Help with implementation guidance

### Phase 5: Completion & Git Sync

**User Action:** Mark task as complete

**Command:** `/task done`

**AI Action:**
1. Update Linear issue status to "Done"
2. Create descriptive Git commit:
   - Commit message format: `[Linear-XXX] Task description`
   - Include task ID in message
3. Stage and commit relevant files
4. Optional: Push to remote
5. Notify with commit hash and issue URL

**Git Commit Message Template:**
```
[Linear-ABC-123] Implement markdown editor

- Added React editor component
- Integrated markdown parsing library
- Added basic styling

Closes ABC-123
```

## Commands Reference

### `/project start <idea>`
- Start a new project or add features to existing one
- Triggers full workflow from idea to Linear issues

### `/task start <issue-id>`
- Begin working on specific Linear issue
- Loads task context and provides guidance

### `/task done`
- Mark current task as complete
- Updates Linear + creates Git commit

### `/task status`
- Show current working task and project status

### `/project status`
- Summary of all project tasks, their Linear status, and recent commits

### `/project sync`
- Re-sync tasks from Linear to local state
- Useful if manual changes were made in Linear

## Linear API Integration

The skill uses Linear's GraphQL API for:

- **Creating issues:** `issueCreate` mutation
- **Updating issues:** `issueUpdate` mutation
- **Querying:** Get issue details, project status
- **Search:** Find issues by title or ID

**Authentication:** Bearer token in Authorization header

**Key Fields:**
- `teamId`: Required for issue creation
- `projectId`: Optional, groups issues under project
- `stateId`: Maps to workflow states (Backlog, In Progress, Done)
- `labels`: Array of label objects for organization

**Rate Limits:** Linear allows 200 requests/minute, which is sufficient for typical project workflows.

## Git Integration Patterns

### Branching Strategy

**Option 1: Feature Branches**
```
main
  └── feature/markdown-editor
```
- Each task gets its own branch
- Merge back to main via pull request
- Best for collaborative teams

**Option 2: Direct Main**
```
main (linear-task-ABC-123)
```
- Work directly on main with descriptive commits
- Faster for solo projects
- Each commit references Linear issue

### Commit Naming

**Format:** `[Linear-XXX] Task description`

**Examples:**
- `[Linear-ABC-123] Set up project structure`
- `[Linear-ABC-124] Initialize database schema`
- `[Linear-ABC-125] Implement search functionality`

### Commit Content

For each task completion, commit includes:
- All changed files related to task
- Clear commit message referencing Linear issue
- No sensitive credentials or API keys

## Task Priority Guidelines

- **P0 (Critical):** Blocking, must do immediately
- **P1 (High):** Important, should do soon
- **P2 (Medium):** Nice to have, can wait
- **P3 (Low):** Future consideration, low value

## Best Practices

1. **Small, Focused Tasks**
   - Each task should be completable in 1-2 hours
   - Split large tasks into smaller subtasks

2. **Clear Acceptance Criteria**
   - Each task should have defined "done" conditions
   - Include test requirements when applicable

3. **Consistent Workflow**
   - Always sync to Linear before starting work
   - Always mark tasks done in Linear after completion
   - Always commit with Linear issue reference

4. **Context Preservation**
   - Use task notes for context during long work sessions
   - Reference related issues for dependencies

## Resources

### scripts/
- `linear_sync.py` - Create and manage Linear issues via GraphQL API
- `git_helpers.sh` - Git operations with Linear integration

### references/
- `linear_api.md` - Complete Linear GraphQL API reference
- `git_workflow.md` - Detailed Git workflow documentation
- `task_templates.md` - Common task templates and patterns
