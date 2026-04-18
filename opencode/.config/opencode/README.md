# OpenCode Configuration

Global configuration for OpenCode AI assistant.

## Structure

```
~/.config/opencode/
├── opencode.json     # Main configuration
├── agent/            # Agent definitions
│   ├── memory.md
│   ├── researcher.md
│   ├── time.md
│   └── ...
├── skills/           # Skill definitions
│   ├── context7-mcp/
│   ├── find-docs/
│   ├── gh-cli/
│   ├── memory-mcp/
│   └── time-mcp/
└── docs/             # Instruction files
```

## Agents

Agents are specialized subagents for specific task types.

| Agent | Purpose | Use |
|-------|---------|-----|
| `researcher` | Web research, documentation lookup | `task(subagent_type="researcher")` |
| `code-reviewer` | Code validation, pattern consistency | `task(subagent_type="code-reviewer")` |
| `tester` | Bug finding, test writing | `task(subagent_type="tester")` |
| `infra-ops` | Database, Docker, Kubernetes | `task(subagent_type="infra-ops")` |

## Skills

Skills provide specialized instructions loaded via `skill()` tool.

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `context7-mcp` | Library/framework questions | Fetch library docs via Context7 |
| `find-docs` | Technology documentation | General docs lookup |
| `gh-cli` | GitHub URLs, PRs, issues | GitHub CLI operations |
| `memory-mcp` | Memory MCP tools | Knowledge graph patterns |
| `time-mcp` | Timezone conversion | Timezone patterns |

## MCPs

Configured in `opencode.json`:

| MCP | Type | Purpose |
|-----|------|---------|
| `sequential-thinking` | Local | Structured problem-solving |
| `context7` | Remote | Code documentation |
| `github` | Remote | GitHub operations |
| `memory` | Local | Knowledge graph storage |
| `time` | Local | Timezone conversion |
| `chrome-devtools` | Local | Browser automation |

## Key Guidelines

1. **Memory auto-inject**: Query `search_nodes` or `read_graph` at conversation start
2. **Use question tool**: Ask clarifying questions rather than assuming
3. **Sequential thinking**: Use for complex problem-solving
4. **Context7 first**: Don't rely on training data for library APIs