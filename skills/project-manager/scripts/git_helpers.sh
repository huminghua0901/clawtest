#!/bin/bash
#
# Git helpers for Linear integration
# Manages commits with Linear issue references
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        return 1
    fi
    return 0
}

# Create feature branch
create_branch() {
    local linear_id="$1"
    local branch_name="linear-${linear_id}"

    if git show-ref --verify --quiet "refs/heads/${branch_name}"; then
        log_warn "Branch ${branch_name} already exists"
        git checkout "${branch_name}"
        return 0
    fi

    log_info "Creating branch: ${branch_name}"
    git checkout -b "${branch_name}"
}

# Commit changes with Linear reference
commit_with_linear() {
    local linear_id="$1"
    local task_description="$2"
    local files="${3:-.}"  # Default to all files

    # Validate Linear ID format (e.g., PROJ-123)
    if [[ ! "$linear_id" =~ ^[A-Z]+-[0-9]+$ ]]; then
        log_error "Invalid Linear ID format. Expected: PROJ-123"
        return 1
    fi

    # Stage files
    log_info "Staging files: ${files}"
    git add ${files}

    # Check if there are staged changes
    if git diff --cached --quiet; then
        log_warn "No changes to commit"
        return 0
    fi

    # Create commit message
    local commit_message="[${linear_id}] ${task_description}"
    log_info "Committing: ${commit_message}"
    git commit -m "${commit_message}"
}

# Commit with extended message (includes task details)
commit_with_details() {
    local linear_id="$1"
    local task_description="$2"
    local acceptance_criteria="$3"
    local files="${4:-.}"

    local commit_message="[${linear_id}] ${task_description}

${acceptance_criteria}
"

    log_info "Staging files: ${files}"
    git add ${files}

    if git diff --cached --quiet; then
        log_warn "No changes to commit"
        return 0
    fi

    log_info "Committing with details"
    git commit -m "${commit_message}"
}

# Get current task from branch name
get_current_task() {
    local branch_name=$(git branch --show-current)
    if [[ "$branch_name" =~ linear-([A-Z]+-[0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo ""
    fi
}

# Create PR body with Linear integration
create_pr_body() {
    local linear_id="$1"
    local task_description="$2"

    cat <<EOF
## Task
${task_description}

**Linear Issue:** [${linear_id}](https://linear.app/issue/${linear_id})

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
EOF
}

# Complete workflow: create branch, commit, prepare for merge
complete_task_workflow() {
    local linear_id="$1"
    local task_description="$2"
    local branch_type="${3:-feature}"  # feature or direct

    check_git_repo || return 1

    if [ "$branch_type" = "feature" ]; then
        create_branch "$linear_id"
        log_info "Branch created. Make your changes, then run:"
        log_info "  git_helpers commit ${linear_id} \"${task_description}\""
    else
        log_info "Working on main. Make your changes, then run:"
        log_info "  git_helpers commit ${linear_id} \"${task_description}\""
    fi
}

# Push to remote with tracking
push_to_remote() {
    local branch_name="${1:-$(git branch --show-current)}"

    log_info "Pushing branch: ${branch_name}"
    if ! git push -u origin "${branch_name}" 2>/dev/null; then
        log_error "Failed to push to remote"
        log_info "To set up remote, run: git remote add origin <url>"
        return 1
    fi
    log_info "Push successful"
}

# Show project status (recent commits with Linear references)
show_status() {
    check_git_repo || return 1

    local current_task=$(get_current_task)
    if [ -n "$current_task" ]; then
        log_info "Current task: ${current_task}"
    fi

    echo ""
    log_info "Recent Linear-related commits:"
    echo ""
    git log --oneline --grep='\[[A-Z]\+-[0-9]\+\]' -10 | while read line; do
        if [[ "$line" =~ \[([A-Z]+-[0-9]+)\] ]]; then
            echo -e "  ${GREEN}${BASH_REMATCH[1]}${NC} ${line#*] }"
        else
            echo "  $line"
        fi
    done
}

# Undo last commit (soft reset)
undo_commit() {
    log_warn "Undoing last commit (keeping changes staged)"
    git reset --soft HEAD~1
    log_info "Changes are still staged. Re-commit or use 'git reset' to unstage."
}

# CLI dispatcher
case "${1:-}" in
    "branch")
        check_git_repo || exit 1
        if [ -z "$2" ]; then
            log_error "Usage: $0 branch <linear_id>"
            exit 1
        fi
        create_branch "$2"
        ;;
    "commit")
        check_git_repo || exit 1
        if [ -z "$2" ] || [ -z "$3" ]; then
            log_error "Usage: $0 commit <linear_id> <description> [files]"
            exit 1
        fi
        commit_with_linear "$2" "$3" "${4:-.}"
        ;;
    "commit-details")
        check_git_repo || exit 1
        if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
            log_error "Usage: $0 commit-details <linear_id> <description> <acceptance_criteria> [files]"
            exit 1
        fi
        commit_with_details "$2" "$3" "$4" "${5:-.}"
        ;;
    "workflow")
        if [ -z "$2" ] || [ -z "$3" ]; then
            log_error "Usage: $0 workflow <linear_id> <description> [feature|direct]"
            exit 1
        fi
        complete_task_workflow "$2" "$3" "${4:-feature}"
        ;;
    "push")
        push_to_remote "$2"
        ;;
    "status")
        show_status
        ;;
    "undo")
        undo_commit
        ;;
    "pr-body")
        if [ -z "$2" ] || [ -z "$3" ]; then
            log_error "Usage: $0 pr-body <linear_id> <description>"
            exit 1
        fi
        create_pr_body "$2" "$3"
        ;;
    *)
        echo "Git helpers for Linear integration"
        echo ""
        echo "Usage: $0 <command> [args]"
        echo ""
        echo "Commands:"
        echo "  branch <linear_id>           - Create/checkout feature branch"
        echo "  commit <linear_id> <desc>    - Commit changes with Linear ref"
        echo "  commit-details <id> <desc> <criteria> [files] - Commit with details"
        echo "  workflow <id> <desc> [type]  - Full workflow (branch + commit prep)"
        echo "  push [branch]                - Push current branch to remote"
        echo "  status                       - Show current task and recent commits"
        echo "  undo                         - Undo last commit (keep changes)"
        echo "  pr-body <id> <desc>          - Generate PR body template"
        ;;
esac
