# Sequential Thinking MCP Tool Guide

Comprehensive documentation for the `sequential-thinking_sequentialthinking` MCP tool.

## When to Use

**CRITICAL: This is the DEFAULT thinking tool for complex tasks.**

Use the `sequential-thinking_sequentialthinking` tool when:

- Complex multi-step problem-solving
- Debugging issues with unknown causes
- Planning implementations or architectural decisions
- Analyzing trade-offs between approaches
- Reasoning through requirements before implementation
- Problems that need tracked reasoning (not just "jump to answer")
- When user asks "how do I approach..." or "think through..."
- Any task where jumping to conclusions might lead you astray
- Complex multi-step problem-solving
- Debugging issues requiring systematic analysis
- Planning and design with room for revision
- Problems where the full scope isn't clear initially
- Tasks requiring context maintenance across multiple steps
- Situations requiring filtering of irrelevant information

## MCP Tool Usage

### Tool Reference

```javascript
sequential-thinking_sequentialthinking({
  thought: "Your current thinking step",
  nextThoughtNeeded: boolean,        // true if more thinking needed
  thoughtNumber: number,             // Current step number
  totalThoughts: number,            // Estimated total steps
  isRevision: boolean,              // Optional: revising previous thought
  revisesThought: number,          // Optional: which thought number
  branchFromThought: number,       // Optional: branching point
  branchId: string,                // Optional: branch identifier
  needsMoreThoughts: boolean        // Optional: realized more steps needed
})
```

### Basic Invocation

```javascript
// Start a thinking session for complex debugging
sequential-thinking_sequentialthinking({
  thought: "The error is 'connection refused' on port 5432. This typically means...",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5
})
```

### With Revision

```javascript
// Realize initial hypothesis was wrong, revise
sequential-thinking_sequentialthinking({
  thought: "Actually, looking at stack traces, the issue is in cleanup phase, not the async setup",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 5,
  isRevision: true,
  revisesThought: 1
})
```

### With Branching

```javascript
// Explore alternative approach
sequential-thinking_sequentialthinking({
  thought: "What if we use a different caching strategy? Let me explore that path.",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 6,
  branchFromThought: 2,
  branchId: "alt-cache-approach"
})
```

## Core Thinking Patterns

### Pattern 1: Linear Problem Solving

```
1. Understand the problem
2. Break into components
3. Analyze each component
4. Plan approach
5. Execute and verify
6. Conclude
```

### Pattern 2: Planning with Revision

```
1. Initial assessment
2. Identify gaps in understanding
3. Revise initial assessment
4. Continue planning
5. Execute
```

### Pattern 3: Hypothesis Testing

```
1. Observe situation
2. Generate hypothesis
3. Verify hypothesis
4. If wrong: revise and test again
5. If correct: build on it
```

### Pattern 4: Multi-Perspective Analysis

```
1. First perspective
2. Alternative perspective
3. Trade-offs
4. Decision
```

## Common Workflows

### Workflow A: Complex Debugging

```javascript
// Step 1: Understand the error
sequential-thinking_sequentialthinking({
  thought: "The error is 'connection refused' on port 5432. This typically means the service isn't reachable.",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5
})

// Step 2: List possible causes
sequential-thinking_sequentialthinking({
  thought: "Possible causes: 1) PostgreSQL not running, 2) Wrong port, 3) Firewall blocking, 4) Connection string misconfiguration",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 5
})

// Step 3: Systematic check
sequential-thinking_sequentialthinking({
  thought: "Checking each cause... First, verify if PostgreSQL process is running",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 5
})

// Step 4: Narrow down
sequential-thinking_sequentialthinking({
  thought: "PostgreSQL is running but port 5432 is blocked. Firewall issue confirmed.",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 5
})

// Step 5: Conclusion
sequential-thinking_sequentialthinking({
  thought: "Solution: Add firewall rule to allow port 5432. Run: sudo ufw allow 5432",
  nextThoughtNeeded: false,
  thoughtNumber: 5,
  totalThoughts: 5
})
```

### Workflow B: Planning Implementation

```javascript
// Step 1: Gather requirements
sequential-thinking_sequentialthinking({
  thought: "User wants to add user authentication. Requirements: login, logout, session management, password reset",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 6
})

// Step 2: Evaluate options
sequential-thinking_sequentialthinking({
  thought: "Options: 1) Roll own auth (not recommended), 2) Auth0/Okta (SaaS), 3) Firebase Auth, 4) Keycloak (self-hosted)",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 6
})

// Step 3: Consider constraints
sequential-thinking_sequentialthinking({
  thought: "User has 'no external services' preference. So Auth0/Okta/Firebase ruled out. Keycloak or self-rolled.",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 6
})

// Step 4: Make recommendation
sequential-thinking_sequentialthinking({
  thought: "Recommend Keycloak - established solution, self-hosted, handles OAuth/OIDC, session management built-in",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 6
})

// Step 5: Outline steps
sequential-thinking_sequentialthinking({
  thought: "Implementation: 1) Deploy Keycloak, 2) Create realm, 3) Add client to app, 4) Implement login/logout flows",
  nextThoughtNeeded: true,
  thoughtNumber: 5,
  totalThoughts: 6
})

// Step 6: Next actions
sequential-thinking_sequentialthinking({
  thought: "Next: Confirm with user if Keycloak is acceptable, then create implementation plan with specific files to modify",
  nextThoughtNeeded: false,
  thoughtNumber: 6,
  totalThoughts: 6
})
```

### Workflow C: Code Analysis

```javascript
// Step 1: Understand structure
sequential-thinking_sequentialthinking({
  thought: "Repository has Node.js backend and React frontend. Monorepo with packages/ directory",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 4
})

// Step 2: Trace data flow
sequential-thinking_sequentialthinking({
  thought: "API endpoints in /api, React components in /src, shared types in /packages/types",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 4
})

// Step 3: Identify issues
sequential-thinking_sequentialthinking({
  thought: "Found issue: API calls not authenticated. Auth middleware missing on /api routes",
  nextThoughtNeeded: false,
  thoughtNumber: 3,
  totalThoughts: 4
})

// Step 4: Recommend fix
sequential-thinking_sequentialthinking({
  thought: "Fix: Add auth middleware to Express app, implement JWT verification before routes",
  nextThoughtNeeded: false,
  thoughtNumber: 4,
  totalThoughts: 4
})
```

### Workflow D: Race Condition Debugging

```javascript
// Step 1: Initial hypothesis
sequential-thinking_sequentialthinking({
  thought: "Initial hypothesis - async operations not properly awaited",
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5
})

// Step 2: Check test setup
sequential-thinking_sequentialthinking({
  thought: "Need to check test setup - are mocks properly isolated?",
  nextThoughtNeeded: true,
  thoughtNumber: 2,
  totalThoughts: 5
})

// Step 3: Revise based on evidence
sequential-thinking_sequentialthinking({
  thought: "Actually, looking at stack traces, the issue is in cleanup phase - resources not properly released before next test",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 5,
  isRevision: true,
  revisesThought: 1
})

// Step 4: Verify hypothesis
sequential-thinking_sequentialthinking({
  thought: "Verify cleanup order matches resource creation order - event listeners removed before async flush completes",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 5
})

// Step 5: Conclude with fix
sequential-thinking_sequentialthinking({
  thought: "Confirmed - event listener removed before async flush completes. Fix: reorder cleanup to await all async operations first",
  nextThoughtNeeded: false,
  thoughtNumber: 5,
  totalThoughts: 5
})
```

## Thought Management

### Tracking Progress

Always know your position:
- `thoughtNumber`: Current step (1, 2, 3, etc.)
- `totalThoughts`: Estimated total steps needed

### Adjusting Estimates

If you realize you need more steps:

```javascript
sequential-thinking_sequentialthinking({
  thought: "This is more complex than initially thought - need to consider edge cases",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 7,
  needsMoreThoughts: true
})
```

### Revision Support

When you realize a previous thought was wrong:

```javascript
sequential-thinking_sequentialthinking({
  thought: "My earlier assumption about X was incorrect because...",
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 6,
  isRevision: true,
  revisesThought: 2
})
```

### Branching for Alternatives

When exploring multiple approaches:

```javascript
sequential-thinking_sequentialthinking({
  thought: "What if we approach this differently? Let me explore the cache-first strategy.",
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 5,
  branchFromThought: 2,
  branchId: "cache-first-exploration"
})
```

### Completion Criteria

Only set `nextThoughtNeeded: false` when:
- You have a clear conclusion or answer
- All major paths have been considered
- You're confident in the recommendation

## Best Practices

1. **Start with understanding** - First thought should always restate/clarify the problem
2. **Be explicit about uncertainty** - Say "I don't know X" rather than guessing
3. **Track your position** - Always know which thought number you're on
4. **Adjust totalThoughts** - If you realize you need more steps, use `needsMoreThoughts: true`
5. **Mark revisions** - If you realize a previous thought was wrong, use `isRevision: true`
6. **Branch for alternatives** - If exploring multiple approaches, use `branchId` to track them
7. **End with action** - Final thought should be a clear conclusion or next action

## Output Format

When concluding a thinking session, provide a summary:

```
## Summary

**Problem**: [restated problem]
**Analysis**: [key findings]
**Solution/Recommendation**: [clear next steps]
**Confidence**: High/Medium/Low
```

## Tips

- **Keep thoughts focused** - One idea per thought works best
- **Don't over-think** - If totalThoughts = 3 is enough, don't make it 10
- **Use numbers** - `thoughtNumber` and `totalThoughts` help track progress
- **Revisions are healthy** - Better to revise than to double down on wrong thinking
- **Parallel branches** - Use `branchId` when exploring "what if" scenarios

## When NOT to Use

- Simple questions with obvious answers (e.g., "what is 2+2?")
- Routine file operations (read, write, edit single files)
- Tasks that are truly one-step
- Direct lookups (use librarian or find-docs for documentation lookup)
- Trivial file modifications
- Questions with straightforward answers