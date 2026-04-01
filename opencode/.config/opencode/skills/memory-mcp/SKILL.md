---
name: memory-mcp
description: Memory MCP reference - MANDATORY auto-inject at conversation start. Use to retrieve user preferences, project context, and past decisions before any task.
---

# Memory MCP Reference

## MANDATORY: Query Memory FIRST

Before doing ANYTHING else in any conversation, you MUST query memory:

```
search_nodes(query="user preferences current context")
```

This is not optional. See `docs/memory-auto-inject.md` for full requirements.

## When to Use This Skill

Activate this skill when you need:
- Quick reference for Memory MCP tools
- Patterns for storing/retrieving entities and relations
- Understanding Memory MCP capabilities
- Manual lookup instead of invoking the memory agent

## Memory MCP Tools

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `search_nodes` | Find entities by query | `query` string |
| `read_graph` | Get entire knowledge graph | none |
| `create_entities` | Store new entities | `entities` array |
| `create_relations` | Connect entities | `relations` array |
| `add_observations` | Add facts to entities | `observations` array |
| `delete_entities` | Remove entities | `entityNames` array |
| `delete_relations` | Remove connections | `relations` array |
| `delete_observations` | Remove facts | `deletions` array |

## Entity Types

| Type | Use For | Example |
|------|---------|---------|
| `user` | User profiles, preferences | `{name: "user_jane", entityType: "user", observations: ["Prefers dark mode", "Works at Acme"]}` |
| `project` | Projects, repositories | `{name: "project_webapp", entityType: "project", observations: ["React frontend", "Node backend"]}` |
| `conversation` | Conversation summaries | `{name: "conv_setup", entityType: "conversation", observations: ["Discussed OAuth flow"]}` |
| `decision` | Important decisions | `{name: "decision_auth", entityType: "decision", observations: ["Chose JWT over session"]}` |
| `preference` | User preferences | `{name: "pref_theme", entityType: "preference", observations: ["theme: dark"]}` |

## Relation Types

| Type | Meaning | Example |
|------|---------|---------|
| `discussed` | Conversation covered topic | `{from: "conv_1", relationType: "discussed", to: "topic_auth"}` |
| `decided` | Decision made about topic | `{from: "decision_1", relationType: "decided", to: "topic_auth"}` |
| `prefers` | User preference for something | `{from: "user_jane", relationType: "prefers", to: "dark_mode"}` |
| `created` | User created something | `{from: "user_jane", relationType: "created", to: "project_webapp"}` |
| `references` | Entity references another | `{from: "conv_1", relationType: "references", to: "project_webapp"}` |

## Common Workflows

### Workflow A: Query Memory at Conversation Start

```markdown
# Auto-inject relevant context
search_nodes(query="current_user preferences project")

# Or get full graph
read_graph()
```

### Workflow B: Store a Decision

```markdown
# Create decision entity
create_entities([{
  name: "decision_auth_method",
  entityType: "decision",
  observations: ["Chose JWT tokens over session-based auth", "Decision made: 2024-01-15"]
}])

# Link to relevant entities
create_relations([{
  from: "decision_auth_method",
  relationType: "decided",
  to: "topic_authentication"
}])
```

### Workflow C: Store User Preferences

```markdown
# Store preference
create_entities([{
  name: "pref_code_style",
  entityType: "preference",
  observations: ["indent: 2 spaces", "semi: true"]
}])

# Link to user
create_relations([{
  from: "user_jane",
  relationType: "prefers",
  to: "pref_code_style"
}])
```

### Workflow D: Find Related Context

```markdown
# Search for relevant entities
search_nodes(query="project_webapp decisions")

# Search for user's preferences
search_nodes(query="jane prefers")
```

## Agent vs. Skill

| Use Case | Use Agent | Use Skill |
|----------|-----------|-----------|
| Autonomous memory management | ✅ `task(subagent_type="memory")` | |
| Quick reference lookup | | ✅ `skill(name="memory-mcp")` |
| Remembering decisions | Agent handles automatically | Reference patterns here |
| Manual entity creation | | ✅ Reference tool syntax |

## Error Handling

| Error | Meaning | Solution |
|-------|---------|----------|
| `Entity not found` | Trying to relate non-existent entity | Create entity first with `create_entities` |
| `Invalid entityType` | Type must be one of: user, project, conversation, decision, preference | Use valid type |
| `Invalid relationType` | Type must be one of: discussed, decided, prefers, created, references | Use valid type |

## Best Practices

1. **[MANDATORY] Always query at start** - Use `search_nodes` or `read_graph` BEFORE any other action
2. **Store user preferences proactively** - When user states a preference, immediately store it
3. **Use descriptive names** - `decision_auth_jwt` not `d1`
4. **Add timestamps** - Include dates in observations for traceability
5. **Link related entities** - Use relations to create connected knowledge graph
6. **Be specific in searches** - "user_jane project_webapp" not just "jane"

## Example: Complete Session Memory Flow

```markdown
# 1. Start: Query relevant memory
search_nodes(query="current_project decisions")

# 2. During conversation: Store key decision
create_entities([{
  name: "decision_2024_02_15",
  entityType: "decision",
  observations: ["Selected PostgreSQL over MongoDB", "Rationale: ACID compliance needed"]
}])

# 3. Link to project
create_relations([{
  from: "decision_2024_02_15",
  relationType: "decided",
  to: "project_current"
}])

# 4. Store user preference noticed
create_entities([{
  name: "obs_preference_quick_responses",
  entityType: "preference",
  observations: ["User prefers concise responses"]
}])
```

## Reference

- **Agent**: Use `task(subagent_type="memory")` for autonomous memory operations
- **MCP Tools**: Full tool documentation in agent file `@opencode/.config/opencode/agent/memory.md`