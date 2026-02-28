# Git Workflow with Linear Integration

## Overview

This workflow integrates Linear issue tracking with Git version control, ensuring every task completion is properly tracked in both systems.

## Prerequisites

1. Git repository initialized
2. Linear account with API access
3. Linear API key configured

## Workflow Patterns

### Pattern 1: Feature Branch (Recommended)

Best for teams and projects requiring code review.

```
main
└── feature/linear-ABC-123
    ├── Implement feature
    ├── Write tests
    └── Create PR
```

**Steps:**

1. Start task:
   ```bash
   ./scripts/git_helpers.sh workflow ABC-123 "Implement markdown editor"
   ```

2. Make changes in branch `linear-ABC-123`

3. Commit when ready:
   ```bash
   ./scripts/git_helpers.sh commit ABC-123 "Implement basic editor" src/
   ```

4. Push and create PR:
   ```bash
   ./scripts/git_helpers.sh push
   # Create PR in GitHub/GitLab with Linear issue link
   ```

5. After PR merge:
   - Update Linear issue to "Done"
   - Delete feature branch locally and remotely

### Pattern 2: Direct Main

Best for solo projects or rapid prototyping.

```
main (with commits referencing Linear issues)
```

**Steps:**

1. Start task (stay on main):
   ```bash
   # No branch creation
   # Just start working
   ```

2. Commit with Linear reference:
   ```bash
   ./scripts/git_helpers.sh commit ABC-123 "Add markdown support"
   ```

3. Push to main:
   ```bash
   git push origin main
   ```

4. Update Linear issue to "Done"

## Commit Message Format

### Standard Format

```
[Linear-XXX] Task description

Optional additional context...
```

**Examples:**
```
[Linear-ABC-123] Set up project structure
[Linear-ABC-124] Initialize database schema
[Linear-ABC-125] Implement search functionality
```

### Extended Format (with acceptance criteria)

```
[Linear-XXX] Task description

Acceptance Criteria:
- Requirement 1
- Requirement 2
- Requirement 3

Closes XXX
```

## Git Commands Integration

### Start a Task

**Feature branch:**
```bash
./scripts/git_helpers.sh workflow ABC-123 "Task description" feature
```

**Direct main:**
```bash
# Just start working, no branch needed
```

### Commit Changes

**Simple commit:**
```bash
./scripts/git_helpers.sh commit ABC-123 "What you did" path/to/files
```

**Detailed commit:**
```bash
./scripts/git_helpers.sh commit-details ABC-123 "Task title" \
  "Acceptance criteria:
   - Must work with markdown
   - Support basic formatting" \
  path/to/files
```

**Commit all changes:**
```bash
./scripts/git_helpers.sh commit ABC-123 "Task description"
```

### Push Changes

```bash
./scripts/git_helpers.sh push
```

### View Status

```bash
./scripts/git_helpers.sh status
```

Shows:
- Current task (if on feature branch)
- Recent Linear-related commits

## Handling Multiple Tasks

### Switching Between Tasks

```bash
# Finish task ABC-123
./scripts/git_helpers.sh commit ABC-123 "Complete first part"

# Switch to ABC-124
git checkout linear-ABC-124
# Or create new branch
git checkout -b linear-ABC-124
```

### Parallel Work on Same Branch

If multiple small tasks for one Linear issue:

```bash
# First part
./scripts/git_helpers.sh commit ABC-123 "Add basic UI"

# Second part
./scripts/git_helpers.sh commit ABC-123 "Add validation"

# Third part
./scripts/git_helpers.sh commit ABC-123 "Add tests"

# Final commit
./scripts/git_helpers.sh commit ABC-123 "Complete integration tests"
```

## Undo and Recovery

### Undo Last Commit (keep changes)

```bash
./scripts/git_helpers.sh undo
# Changes are still staged
```

### Undo Last Commit (discard changes)

```bash
git reset --hard HEAD~1
```

### Fix Last Commit

```bash
# Make changes
git add modified_file.py

# Amend last commit
git commit --amend --no-edit
```

## Pull Request Integration

### Generate PR Body

```bash
./scripts/git_helpers.sh pr-body ABC-123 "Task description"
```

**Output:**
```markdown
## Task
Task description

**Linear Issue:** [ABC-123](https://linear.app/issue/ABC-123)

## Changes
- Describe what was changed
- Add technical details if relevant

## Testing
- How was this tested?
- Include test commands or procedures

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated if needed
```

## Best Practices

### Commit Granularity

**Good:**
```
[Linear-ABC-123] Add markdown parser library
[Linear-ABC-123] Implement basic editor UI
[Linear-ABC-123] Add syntax highlighting
[Linear-ABC-123] Write unit tests
```

**Avoid:**
```
[Linear-ABC-123] Do everything (too broad)
```

### Commit Messages

**Good:**
```
[Linear-ABC-123] Implement markdown editor
- Added react-markdown dependency
- Created Editor component
- Integrated with state management
```

**Avoid:**
```
[Linear-ABC-123] fixed stuff
[Linear-ABC-123] wip
```

### Branch Naming

**Good:**
```
linear-ABC-123
feature/linear-ABC-123
bugfix/linear-ABC-124
```

**Avoid:**
```
stuff
temp
new-branch
```

## Troubleshooting

### "No changes to commit"

- Make sure you've actually modified files
- Check if changes are already committed: `git status`

### "Not a git repository"

- Initialize git: `git init`
- Navigate to project directory

### "Branch already exists"

- Checkout existing branch: `git checkout linear-ABC-123`
- Or create different name: `git checkout -b linear-ABC-123-alt`

### "Failed to push to remote"

- Check remote configuration: `git remote -v`
- Add remote if needed: `git remote add origin <url>`

## Integration with Linear

### Suggested Linear Workflow States

1. **Backlog** - Initial state after issue creation
2. **In Progress** - When you start working (branch created)
3. **In Review** - When PR is created
4. **Done** - After merge and commit

### Updating Linear from Git

After completing a task:

1. Commit changes with Linear reference
2. Push (if using feature branch pattern)
3. Update Linear issue status to "Done"
4. Add commit hash to Linear issue (as comment)

### Finding Issues in Git

Search git log for Linear references:
```bash
git log --oneline --grep='ABC-123'
```

Show all Linear-related commits:
```bash
git log --oneline --grep='\[[A-Z]\+-[0-9]\+\]'
```
