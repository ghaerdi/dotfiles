# Subagent Workflow Coordination

This document defines how agents should coordinate and when to invoke custom subagents.

## Research Workflow

### When to Use librarian vs researcher

**Use `librarian` (via Task tool with `subagent_type="librarian"`) for**:
- Documentation lookup (API references, library docs)
- Static content (framework guides, package docs)
- Code examples from official sources
- Context7 queries for library information

**Use `researcher` (via Task tool with `subagent_type="researcher"`) for**:
- Live web search (current events, recent articles)
- Browser automation (navigating websites, filling forms, screenshots)
- Dynamic content (pricing, availability, time-sensitive data)
- Multi-step web workflows (login, download, scrape)

**Call BOTH together for complex investigations** requiring documentation + live web sources.

<example>
Context: User needs current information about a library version.

assistant: "I'll query librarian for the official documentation and researcher for recent discussions and examples."

<commentary>
For version-specific queries, call both to get docs + community examples.
</commentary>
</example>

## Code Review Workflow

### Automatic Review After Code Changes

ALWAYS call `code-reviewer` (via Task tool with `subagent_type="code-reviewer"`) after:
1. Writing new code
2. Modifying existing code
3. Fixing bugs or issues

### Review Iteration Loop

1. **Initial review** - Call code-reviewer after code changes
2. **Fix issues** - If issues found, fix them
3. **Re-review** - Call code-reviewer again
4. **Repeat** - Continue until code-reviewer passes

<example>
Context: Code has been written.

assistant: "Now I'll call the code-reviewer agent to validate the code against our standards."

<commentary>
Always call code-reviewer after completing code changes. Iterate until pass.
</commentary>
</example>

## Testing Workflow

### Call tester After review passes

Call `tester` (via Task tool with `subagent_type="tester"`) after:
1. Code-reviewer has validated the code
2. Implementation is complete
3. You need bug/edge case detection

### Test-Review Iteration Loop

1. **Initial test** - Call tester after code-reviewer passes
2. **Fix bugs** - If bugs found, fix them
3. **Re-review** - Call code-reviewer to validate fixes
4. **Re-test** - Call tester to verify fixes
5. **Repeat** - Continue until both pass

<example>
Context: Code-reviewer has approved the code.

assistant: "The code-reviewer has validated the code. Now I'll call the tester agent to find bugs and edge cases."

<commentary>
The workflow is: implement → code-review → test → iterate.
</commentary>
</example>

## Infrastructure Operations

### When to Use infra-ops

Call `infra-ops` (via Task tool with `subagent_type="infra-ops"`) for:
- Docker operations (containers, images, compose)
- Kubernetes operations (pods, deployments, services)
- Database operations (migrations, queries, backups)
- Cloud infrastructure (AWS, GCP, Azure)

<example>
Context: User needs to check Docker container status.

assistant: "I'll use the infra-ops agent to manage the Docker containers."

<commentary>
Infra-ops has specialized knowledge for DevOps tasks.
</commentary>
</example>