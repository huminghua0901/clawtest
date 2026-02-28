#!/usr/bin/env python3
"""
Linear API integration for project management
Handles issue creation, updates, and queries via GraphQL API
"""

import os
import sys
import json
import requests
from typing import List, Dict, Optional


class LinearClient:
    """Linear GraphQL API client"""

    def __init__(self, api_key: str):
        self.api_key = api_key
        self.endpoint = "https://api.linear.app/graphql"
        self.headers = {
            "Authorization": api_key,
            "Content-Type": "application/json"
        }

    def query(self, query: str, variables: Dict = None) -> Dict:
        """Execute GraphQL query"""
        response = requests.post(
            self.endpoint,
            headers=self.headers,
            json={"query": query, "variables": variables or {}}
        )
        response.raise_for_status()
        data = response.json()
        if "errors" in data:
            raise Exception(f"GraphQL Error: {data['errors']}")
        return data.get("data")

    def get_teams(self) -> List[Dict]:
        """Get all teams"""
        query = """
        query {
            teams {
                nodes {
                    id
                    name
                    key
                }
            }
        }
        """
        data = self.query(query)
        return data["teams"]["nodes"]

    def get_projects(self, team_id: str) -> List[Dict]:
        """Get projects for a team"""
        query = """
        query GetProjects($teamId: String!) {
            team(id: $teamId) {
                projects {
                    nodes {
                        id
                        name
                        description
                        state
                    }
                }
            }
        }
        """
        data = self.query(query, {"teamId": team_id})
        return data["team"]["projects"]["nodes"]

    def get_workflow_states(self, team_id: str) -> List[Dict]:
        """Get workflow states for a team"""
        query = """
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
        """
        data = self.query(query, {"teamId": team_id})
        return data["team"]["states"]["nodes"]

    def create_issue(
        self,
        team_id: str,
        title: str,
        description: str = "",
        priority: int = 0,
        project_id: Optional[str] = None,
        state_id: Optional[str] = None,
        labels: Optional[List[str]] = None
    ) -> Dict:
        """Create a new issue"""
        labels_input = []
        if labels:
            # Find or create label IDs
            labels_input = [{"name": name} for name in labels]

        mutation = """
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
                    description
                    priority
                    url
                    state {
                        name
                    }
                }
            }
        }
        """

        variables = {
            "teamId": team_id,
            "title": title,
            "description": description,
            "priority": priority
        }
        if project_id:
            variables["projectId"] = project_id
        if state_id:
            variables["stateId"] = state_id

        data = self.query(mutation, variables)
        if not data["issueCreate"]["success"]:
            raise Exception("Failed to create issue")
        return data["issueCreate"]["issue"]

    def update_issue(
        self,
        issue_id: str,
        state_id: Optional[str] = None,
        title: Optional[str] = None,
        description: Optional[str] = None
    ) -> Dict:
        """Update an issue"""
        mutation = """
        mutation UpdateIssue(
            $issueId: String!
            $stateId: String
            $title: String
            $description: String
        ) {
            issueUpdate(
                id: $issueId
                input: {
                    stateId: $stateId
                    title: $title
                    description: $description
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
        """

        variables = {"issueId": issue_id}
        if state_id:
            variables["stateId"] = state_id
        if title:
            variables["title"] = title
        if description:
            variables["description"] = description

        data = self.query(mutation, variables)
        if not data["issueUpdate"]["success"]:
            raise Exception("Failed to update issue")
        return data["issueUpdate"]["issue"]

    def get_issue(self, identifier: str) -> Dict:
        """Get issue by identifier (e.g., "PROJ-123")"""
        query = """
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
                url
                labels {
                    nodes {
                        name
                    }
                }
            }
        }
        """
        data = self.query(query, {"identifier": identifier})
        return data["issue"]

    def search_issues(self, team_id: str, query: str = "") -> List[Dict]:
        """Search issues in a team"""
        query_str = """
        query SearchIssues($teamId: String!, $query: String!) {
            team(id: $teamId) {
                issues(filter: {query: $query}) {
                    nodes {
                        id
                        identifier
                        title
                        state {
                            name
                        }
                        priority
                        url
                    }
                }
            }
        }
        """
        data = self.query(query_str, {"teamId": team_id, "query": query})
        return data["team"]["issues"]["nodes"]


def main():
    """CLI interface for testing"""
    if len(sys.argv) < 2:
        print("Usage: python linear_sync.py <command> [args]")
        print("Commands:")
        print("  teams - List all teams")
        print("  projects <team_id> - List projects")
        print("  create <team_id> <title> - Create issue")
        sys.exit(1)

    api_key = os.environ.get("LINEAR_API_KEY")
    if not api_key:
        print("Error: LINEAR_API_KEY environment variable not set")
        sys.exit(1)

    client = LinearClient(api_key)
    command = sys.argv[1]

    if command == "teams":
        teams = client.get_teams()
        print("Teams:")
        for team in teams:
            print(f"  {team['name']} ({team['id']}) - Key: {team['key']}")

    elif command == "projects":
        if len(sys.argv) < 3:
            print("Usage: python linear_sync.py projects <team_id>")
            sys.exit(1)
        projects = client.get_projects(sys.argv[2])
        print("Projects:")
        for project in projects:
            print(f"  {project['name']} ({project['id']})")

    elif command == "create":
        if len(sys.argv) < 4:
            print("Usage: python linear_sync.py create <team_id> <title>")
            sys.exit(1)
        issue = client.create_issue(sys.argv[2], sys.argv[3], "Created via API")
        print(f"Created issue: {issue['identifier']}")
        print(f"URL: {issue['url']}")

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
