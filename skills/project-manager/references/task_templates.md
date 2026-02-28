# Task Templates

Common task templates and patterns for project management.

## Task Breakdown Patterns

### Feature Implementation

When adding a new feature:

```
[P0] Set up project structure
[P1] Implement core functionality
[P1] Add error handling
[P1] Write unit tests
[P2] Add logging and monitoring
[P2] Update documentation
[P2] Style UI components
```

**Acceptance Criteria:**
- Feature works as specified in requirements
- Edge cases handled
- Tests pass
- Documentation updated

### Bug Fix

When fixing a bug:

```
[P0] Reproduce and verify bug
[P0] Identify root cause
[P1] Implement fix
[P1] Add regression tests
[P1] Verify fix
[P2] Update related documentation
```

**Acceptance Criteria:**
- Bug no longer occurs
- No regressions introduced
- Tests prevent future occurrence

### Refactoring

When improving code quality:

```
[P1] Identify code to refactor
[P1] Write tests (if missing)
[P1] Refactor code
[P1] Run existing tests
[P2] Update documentation
```

**Acceptance Criteria:**
- Code is cleaner/more maintainable
- All tests pass
- Behavior unchanged

## Task Descriptions

### Good Task Descriptions

**Specific:**
```
[P0] Add markdown preview to note editor
- Show live preview of markdown
- Support headings, lists, code blocks
- Auto-scroll preview
```

**Actionable:**
```
[P1] Implement user authentication
- Add login form
- Implement JWT token handling
- Add logout functionality
```

**Testable:**
```
[P2] Add search performance optimization
- Index notes for faster search
- Cache search results
- Reduce search time to < 100ms
```

### Avoid

**Too vague:**
```
Fix the issue
Make it better
Add features
```

**Too large:**
```
[P0] Build the entire notes app
```

**No acceptance criteria:**
```
Add search
```

## Task Priority Guidelines

### P0 (Critical) - Blockers

- Security vulnerabilities
- Data loss risks
- Production outages
- Critical bugs blocking progress

**Timeline:** Fix immediately or within hours

### P1 (High) - Important

- Core features not working
- Performance issues affecting users
- Important bugs
- Feature deadlines

**Timeline:** Fix within 1-2 days

### P2 (Medium) - Nice to Have

- Minor bugs with workarounds
- Performance improvements
- Feature enhancements
- Code cleanup

**Timeline:** Fix within 1 week

### P3 (Low) - Future

- Nice-to-have features
- Nice-to-have improvements
- Technical debt (non-urgent)
- Documentation improvements

**Timeline:** When time permits

## Common Task Categories

### Setup & Infrastructure

```
[P0] Initialize project
[P0] Set up build pipeline
[P0] Configure CI/CD
[P1] Set up monitoring
[P1] Configure error tracking
[P2] Add performance monitoring
```

### Backend Development

```
[P0] Design database schema
[P0] Implement API endpoints
[P1] Add input validation
[P1] Implement caching
[P2] Optimize queries
[P2] Add rate limiting
```

### Frontend Development

```
[P1] Create component library
[P1] Implement user interface
[P1] Add responsive design
[P2] Add animations
[P2] Improve accessibility
```

### Testing

```
[P1] Write unit tests
[P1] Write integration tests
[P2] Add E2E tests
[P2] Set up test coverage reporting
```

### Documentation

```
[P2] Write API documentation
[P2] Create user guides
[P2] Add inline code comments
[P3] Update README
```

## Task Dependencies

### Sequential Dependencies

```
[P0] Set up database
  └── [P0] Create data models
      └── [P1] Implement CRUD operations
          └── [P1] Add API endpoints
```

**Example:**
```
[P0] Initialize git repository
[P0] Set up project structure
[P0] Configure build tools
[P1] Create base components
[P1] Implement core features
```

### Parallel Tasks

```
[P0] Set up database
[P0] Set up frontend framework (parallel)
```

**Example:**
```
[P0] Backend API
[P0] Frontend UI (can work in parallel)
[P1] Integration
```

### Cross-Functional Dependencies

```
[P0] Backend API endpoint
  [P1] Frontend integration
    [P1] UI updates
```

## Task Estimation

### Time Estimates

| Priority | Size | Time Estimate |
|----------|------|---------------|
| P0 | Small | 1-2 hours |
| P0 | Medium | 2-4 hours |
| P0 | Large | 4-8 hours |
| P1 | Small | 2-4 hours |
| P1 | Medium | 4-8 hours |
| P1 | Large | 1-2 days |
| P2 | Any | As time permits |

**Rule:** If a task is estimated > 8 hours, break it down further.

### Breaking Down Large Tasks

**Original:**
```
[P0] Build authentication system
```

**Broken down:**
```
[P0] Set up user model in database
[P0] Implement password hashing
[P1] Create login API endpoint
[P1] Create registration API endpoint
[P1] Implement JWT token generation
[P1] Add token validation middleware
[P2] Add password reset flow
[P2] Add email verification
```

## Task Acceptance Criteria Templates

### Code Feature

```
Acceptance Criteria:
- Feature works as specified in requirements
- Edge cases handled (null, empty, invalid input)
- Error messages are clear and actionable
- Code follows project style guidelines
- Unit tests pass
- Documentation updated

Verification:
- [ ] Manual testing completed
- [ ] Unit tests written and passing
- [ ] Code review completed
```

### Bug Fix

```
Acceptance Criteria:
- Bug no longer occurs
- No regressions introduced
- Root cause addressed (not just symptoms)
- Tests added to prevent future occurrence
- Related documentation updated

Verification:
- [ ] Bug reproduction test added
- [ ] All existing tests pass
- [ ] Manual verification completed
```

### Performance Improvement

```
Acceptance Criteria:
- Performance target met (e.g., < 100ms response time)
- No functionality broken
- Monitoring/logging added
- Baseline documented

Verification:
- [ ] Performance benchmarks run
- [ ] Before/after metrics compared
- [ ] Load testing completed
```

## Label Strategies

### By Component

```
frontend, backend, database, api, ui, utils
```

### By Type

```
feature, bug, refactor, chore, docs, test
```

### By Impact

```
critical, important, minor
```

### Example Label Set

```
component: frontend
component: backend
type: feature
type: bug
priority: p0
priority: p1
status: in-progress
```

## Task Naming Conventions

### Format

```
[Priority] Action object context
```

### Examples

```
[P0] Add user authentication
[P1] Fix login bug
[P1] Implement search feature
[P2] Improve page load performance
[P2] Update API documentation
[P3] Add unit tests for auth module
```

### Verbs to Use

- **Create:** New features/components
- **Implement:** Functionality implementation
- **Add:** Adding features/elements
- **Fix:** Bug fixes
- **Refactor:** Code restructuring
- **Update:** Updating existing code/docs
- **Remove:** Deleting code/features
- **Improve:** Enhancements
- **Optimize:** Performance improvements

## Task Review Checklist

Before marking a task complete:

- [ ] Acceptance criteria met
- [ ] Code tested (manual + automated)
- [ ] No regressions
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No hardcoded credentials
- [ ] Error handling implemented
- [ ] Logging added (if needed)
- [ ] Git commit message is clear
- [ ] Linear issue updated
