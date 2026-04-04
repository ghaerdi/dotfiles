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

## Sequential Thinking Workflow

### When to Use Sequential Thinking

Call `sequential-thinking` (via `skill(name="sequential-thinking")`) for:
- Complex multi-step problem-solving
- Debugging issues requiring systematic analysis
- Planning and design with room for revision
- Problems where the full scope isn't clear initially
- Tasks requiring context maintenance across multiple steps
- Situations requiring filtering of irrelevant information

### How It Works

Sequential thinking provides structured problem-solving through iterative thoughts:
1. **Break down** complex problems into manageable steps
2. **Track progress** with thought numbering and totals
3. **Revise and branch** - Question previous thoughts, explore alternative paths
4. **Generate hypotheses** and verify them systematically
5. **Express uncertainty** - Mark when more analysis is needed

### Usage Pattern

```typescript
// Load the skill for complex tasks
skill(name="sequential-thinking")

// Or delegate to a task with the skill loaded
task(
  category="ultrabrain",
  load_skills=["sequential-thinking"],
  description="Debug race condition",
  prompt="..."
)
```

### Thought Management

- **Adjust totals**: `totalThoughts` can be increased/decreased as understanding evolves
- **Revision support**: Mark thoughts with `isRevision: true` and `revisesThought: N`
- **Branching**: Use `branchFromThought` and `branchId` for alternative paths
- **Completion**: Only set `nextThoughtNeeded: false` when truly satisfied with the answer

<example>
Context: Debugging intermittent test failures that may involve race conditions.

assistant: "I'll use sequential thinking to systematically analyze this race condition."

skill(name="sequential-thinking")

[Thought 1/5]: Initial hypothesis - async operations not properly awaited
[Thought 2/5]: Need to check test setup - are mocks properly isolated?
[Thought 3/5, revision of 1]: Actually, looking at stack traces, the issue is in cleanup phase
[Thought 4/5]: Verify cleanup order matches resource creation order
[Thought 5/5]: Confirmed - event listener removed before async flush completes. Fix: reorder cleanup.

<commentary>
Sequential thinking allows revising hypotheses mid-analysis and tracking the reasoning chain.
</commentary>
</example>

### When NOT to Use

- Simple, single-step tasks
- Direct lookups (use `librarian` or `find-docs`)
- Trivial file modifications
- Questions with straightforward answers