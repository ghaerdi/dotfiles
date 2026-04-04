---
name: gh-cli
description: GitHub CLI (gh) operations for PRs, issues, repositories. Use when user provides GitHub URLs or asks about GitHub content.
---

# GitHub CLI Operations

## When to Use This Skill

Activate this skill when the user:
- Provides a GitHub URL (PR, issue, repo, commit, branch)
- Asks to check/view/review GitHub content
- Asks about PR comments, reviews, files changed, check status
- Asks about issues, assignees, labels, milestones
- Asks about repository structure, branches, recent commits
- Wants to verify GitHub access or authentication

## URL Parsing

Extract from GitHub URLs:

| URL Pattern | Extracts |
|-------------|----------|
| `https://github.com/<owner>/<repo>/pull/<number>` | owner, repo, type=pr, number |
| `https://github.com/<owner>/<repo>/issues/<number>` | owner, repo, type=issue, number |
| `https://github.com/<owner>/<repo>` | owner, repo |
| `https://github.com/<owner>/<repo>/tree/<branch>` | owner, repo, branch |
| `https://github.com/<owner>/<repo>/commit/<sha>` | owner, repo, type=commit, sha |

## Command Mappings

### Pull Requests

| Request | Command |
|---------|---------|
| View PR details | `gh pr view <owner>/<repo>/<number>` |
| PR with comments | `gh pr view <number> --comments` |
| PR diff/files | `gh pr diff <number>` |
| PR check status | `gh pr checks <number>` |
| PR reviews | `gh api repos/<owner>/<repo>/pulls/<number>/reviews` |
| PR files changed | `gh pr diff <number> --name-only` |
| PR check runs | `gh api repos/<owner>/<repo>/commits/<sha>/check-runs` |

### Issues

| Request | Command |
|---------|---------|
| View issue | `gh issue view <number>` |
| Issue with comments | `gh issue view <number> --comments` |
| Issue details (JSON) | `gh issue view <number> --json assignees,labels,milestone` |

### Repositories

| Request | Command |
|---------|---------|
| List org repos | `gh repo list <org> --limit 100` |
| Repo info | `gh repo view <owner>/<repo>` |
| List branches | `gh branch list -R <owner>/<repo>` |
| Recent commits | `gh log -R <owner>/<repo> --oneline -n 10` |
| Repo permissions | `gh api repos/<owner>/<repo> --jq '.permissions'` |

### Search Across Organizations

| Request | Command |
|---------|---------|
| PRs needing your review | `gh search prs --review-requested=@me --state=open` |
| Issues assigned to you | `gh search issues --assignee=@me --state=open --owner=<org>` |
| Your authored PRs | `gh search prs --author=@me --state=open --owner=<org>` |

## Common Workflows

### Workflow A: "Can the code review agent look at this PR?"

```bash
# 1. Parse URL to extract owner, repo, number
# 2. Check if PR exists and is accessible
gh pr view <owner>/<repo>/<number> --json title,body,state,author

# 3. If accessible, summarize:
echo "✅ PR #<number> is accessible"
echo "Title: <title>"
echo "State: <state>"
echo "Author: <author>"

# Check PR status
gh pr checks <number>

# Ask: "Should I invoke the code-reviewer agent?"
```

**If 404 error:**
```bash
# Check authentication
gh auth status

# Check org membership
gh api user/orgs --jq '.[].login' | grep <org>

# Report: "Cannot access - may need SSO authorization or token scope"
```

### Workflow B: "Check the comments in this PR"

```bash
# 1. Get PR comments
gh pr view <number> --comments

# 2. Get review comments
gh api repos/<owner>/<repo>/pulls/<number>/comments

# 3. Get review threads
gh api repos/<owner>/<repo>/pulls/<number>/reviews

# 4. Summarize:
#    - Number of comments
#    - Key discussion points
#    - Unresolved threads
#    - Reviewer feedback (APPROVE/REQUEST_CHANGES/COMMENT)
```

### Workflow C: "What's the status of this PR?"

```bash
# Check combined status
gh pr status <number>

# Check CI/CD runs
gh pr checks <number>

# Check mergeability
gh pr view <number> --json mergeable,commits,additions,deletions

# Report:
# - Check status (passing/failing)
# - Merge conflicts (yes/no)
# - Review status (approved/changes requested)
```

### Workflow D: "Show me issues assigned to me in <org>"

```bash
gh search issues --assignee=@me --state=open --owner=<org>
```

## Authentication Requirements

### Before Any Operation

```bash
# Always verify authentication first
gh auth status
```

### Required Scopes

| Scope | Purpose |
|-------|---------|
| `repo` | Full access to private repositories |
| `read:org` | Read organization membership |
| `gist` | Gist operations (optional) |

### SSO Authorization

If organization requires SAML SSO:

1. **Check SSO status:**
   ```bash
   gh auth status
   ```

2. **Authorize token for org:**
   - Navigate to: `https://github.com/orgs/<ORG>/sso`
   - Or click SSO link from `gh auth status` output

3. **Verify access:**
   ```bash
   gh repo list <org> --visibility private
   ```

## Error Handling

| Error | Meaning | Solution |
|-------|---------|----------|
| `404 Not Found` | No access or doesn't exist | Check auth, verify SSO, confirm repo name |
| `403 Forbidden` | Authenticated but no permission | Token needs `repo` scope or org access |
| `Requires authentication` | Not logged in | Run `gh auth login` |
| `Resource not accessible by integration` | Token lacks scope | Recreate token with proper scopes |
| SSO session expired | SSO token expired | Re-authorize at org SSO portal |

## Output Formatting

When presenting results:

1. **Summary first** (1-2 sentences)
2. **Key details** (state, author, date, status)
3. **Relevant links** (direct URLs to comments/files)
4. **Flag issues** (failing checks, requested changes, conflicts)
5. **Quote important comments** (reviewer feedback, blocking concerns)
6. **Suggest next actions** (e.g., "Should I invoke the code-reviewer agent?")

## Guidelines

- **Always check auth first** before assuming access issues
- **Parse URLs carefully** - extract correct owner/repo/number
- **Use JSON output** for programmatic access: `--json <fields>`
- **Handle rate limits** - GitHub API has limits (5000/hr authenticated)
- **Respect privacy** - don't expose sensitive repo information
- **Verify before acting** - confirm PR/issue exists before invoking agents