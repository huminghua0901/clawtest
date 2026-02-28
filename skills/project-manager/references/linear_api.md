# Linear GraphQL API Reference

## Authentication

```bash
Authorization: Bearer <YOUR_API_KEY>
Content-Type: application/json
```

API Endpoint: `https://api.linear.app/graphql`

## Common Queries

### Get Teams

```graphql
query {
  teams {
    nodes {
      id
      name
      key
      url
    }
  }
}
```

### Get Projects

```graphql
query GetProjects($teamId: String!) {
  team(id: $teamId) {
    projects {
      nodes {
        id
        name
        description
        state
        url
      }
    }
  }
}
```

### Get Workflow States

```graphql
query GetStates($teamId: String!) {
  team(id: $teamId) {
    states {
      nodes {
        id
        name
        type
        color
      }
    }
  }
}
```

**State Types:**
- `backlog` - Initial state
- `unstarted` - Ready to start
- `started` - In progress
- `completed` - Done
- `cancelled` - Cancelled

### Get Issue by Identifier

```graphql
query GetIssue($identifier: String!) {
  issue(identifier: $identifier) {
    id
    identifier
    title
    description
    priority
    state {
      id
      name
    }
    labels {
      nodes {
        name
        color
      }
    }
    url
    createdAt
    updatedAt
  }
}
```

### Search Issues

```graphql
query SearchIssues($teamId: String!, $query: String!) {
  team(id: $teamId) {
    issues(filter: {query: $query}) {
      nodes {
        id
        identifier
        title
        description
        priority
        state {
          name
        }
        url
      }
    }
  }
}
```

## Mutations

### Create Issue

```graphql
mutation CreateIssue(
  $teamId: String!
  $title: String!
  $description: String
  $priority: Int
  $projectId: String
  $stateId: String
  $labelIds: [String!]
) {
  issueCreate(
    input: {
      teamId: $teamId
      title: $title
      description: $description
      priority: $priority
      projectId: $projectId
      stateId: $stateId
      labelIds: $labelIds
    }
  ) {
    success
    issue {
      id
      identifier
      title
      url
    }
  }
}
```

**Priority Values:**
- `0` - No priority
- `1` - Urgent (P0)
- `2` - High (P1)
- `3` - Medium (P2)
- `4` - Low (P3)

### Update Issue

```graphql
mutation UpdateIssue(
  $issueId: String!
  $stateId: String
  $title: String
  $description: String
  $priority: Int
) {
  issueUpdate(
    id: $issueId
    input: {
      stateId: $stateId
      title: $title
      description: $description
      priority: $priority
    }
  ) {
    success
    issue {
      id
      identifier
      title
      state {
        name
      }
      url
    }
  }
}
```

### Create Label

```graphql
mutation CreateLabel(
  $teamId: String!
  $name: String!
  $color: String
) {
  labelCreate(
    input: {
      teamId: $teamId
      name: $name
      color: $color
    }
  ) {
    success
    label {
      id
      name
      color
    }
  }
}
```

## Variables Reference

### IssueCreateInput

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| teamId | String | Yes | Team ID to create issue in |
| title | String | Yes | Issue title |
| description | String | No | Markdown description |
| priority | Int | No | 0-4, higher = more urgent |
| projectId | String | No | Project ID to associate with |
| stateId | String | No | Initial state ID |
| labelIds | [String!] | No | Array of label IDs |

### IssueUpdateInput

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Issue ID |
| stateId | String | No | New state ID |
| title | String | No | New title |
| description | String | No | New description |
| priority | Int | No | New priority (0-4) |

## Error Handling

**Common Errors:**

```json
{
  "errors": [
    {
      "message": "Team not found",
      "extensions": { "code": "TEAM_NOT_FOUND" }
    }
  ]
}
```

**Rate Limiting:**
- 200 requests per minute
- Rate limit headers in response

## Best Practices

1. **Caching:** Cache team/project/state IDs locally
2. **Batching:** Use batch queries when fetching multiple issues
3. **Pagination:** Use cursor-based pagination for large datasets
4. **Validation:** Validate issue identifiers before API calls

## Examples

### Complete Issue Creation Flow

```python
# 1. Get teams
teams = client.get_teams()
team_id = teams[0]['id']

# 2. Get states
states = client.get_workflow_states(team_id)
backlog_state = next(s for s in states if s['name'] == 'Backlog')

# 3. Create issue
issue = client.create_issue(
    team_id=team_id,
    title="Implement new feature",
    description="Details...",
    priority=2,  # High priority
    state_id=backlog_state['id'],
    labels=["frontend", "enhancement"]
)
```

### Update Issue to Done

```python
# 1. Get issue to find current state
issue = client.get_issue("PROJ-123")

# 2. Find done state
states = client.get_workflow_states(issue['teamId'])
done_state = next(s for s in states if s['type'] == 'completed')

# 3. Update issue
updated = client.update_issue(
    issue_id=issue['id'],
    state_id=done_state['id']
)
```
