---
name: sequential-thinking
description: Structured problem-solving and reasoning. ALWAYS use for complex tasks, multi-step problems, debugging, or when you need to think through issues systematically.
---

# Sequential Thinking

## When to Use This Skill

**CRITICAL: This is the DEFAULT thinking tool for complex tasks.**

Use the `sequential-thinking_sequentialthinking` tool when:

- Complex multi-step problems
- Debugging issues with unknown causes
- Planning implementations or architectural decisions
- Analyzing trade-offs between approaches
- Reasoning through requirements before implementation
- Problems that need tracked reasoning (not just "jump to answer")
- When user asks "how do I approach..." or "think through..."
- Any task where jumping to conclusions might lead you astray

**DO NOT use for:**
- Simple questions with obvious answers (e.g., "what is 2+2?")
- Routine file operations (read, write, edit single files)
- Tasks that are truly one-step

## Tool Reference

```javascript
sequential-thinking_sequentialthinking({
  thought: "Your current thinking step",
  nextThoughtNeeded: boolean,        // true if more thinking needed
  thoughtNumber: number,              // Current step number
  totalThoughts: number,              // Estimated total steps
  isRevision: boolean,               // Optional: revising previous thought
  revisesThought: number,            // Optional: which thought number
  branchFromThought: number,         // Optional: branching point
  branchId: string,                  // Optional: branch identifier
  needsMoreThoughts: boolean          // Optional: realized more steps needed
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
thought: "The error is 'connection refused' on port 5432. This typically means..."
nextThoughtNeeded: true
thoughtNumber: 1
totalThoughts: 5

// Step 2: List possible causes
thought: "Possible causes: 1) PostgreSQL not running, 2) Wrong port, 3) Firewall, 4) Connection string"
nextThoughtNeeded: true
thoughtNumber: 2
totalThoughts: 5

// Step 3: Systematic check
thought: "Checking each cause... First, verify if PostgreSQL process is running"
nextThoughtNeeded: true
thoughtNumber: 3
totalThoughts: 5

// Step 4: Narrow down
thought: "PostgreSQL is running but port 5432 is blocked. Firewall issue confirmed."
nextThoughtNeeded: true
thoughtNumber: 4
totalThoughts: 5

// Step 5: Conclusion
thought: "Solution: Add firewall rule to allow port 5432. Run: sudo ufw allow 5432"
nextThoughtNeeded: false
thoughtNumber: 5
totalThoughts: 5
```

### Workflow B: Planning Implementation

```javascript
// Step 1: Gather requirements
thought: "User wants to add user authentication. Requirements: login, logout, session management, password reset"
nextThoughtNeeded: true
thoughtNumber: 1
totalThoughts: 6

// Step 2: Evaluate options
thought: "Options: 1) Roll own auth (not recommended), 2) Auth0/Okta (SaaS), 3) Firebase Auth, 4) Keycloak (self-hosted)"
nextThoughtNeeded: true
thoughtNumber: 2
totalThoughts: 6

// Step 3: Consider constraints
thought: "User has 'no external services' preference. So Auth0/Okta/Firebase ruled out. Keycloak or self-rolled."
nextThoughtNeeded: true
thoughtNumber: 3
totalThoughts: 6

// Step 4: Make recommendation
thought: "Recommend Keycloak - established solution, self-hosted, handles OAuth/OIDC, session management built-in"
nextThoughtNeeded: true
thoughtNumber: 4
totalThoughts: 6

// Step 5: Outline steps
thought: "Implementation: 1) Deploy Keycloak, 2) Create realm, 3) Add client to app, 4) Implement login/logout flows"
nextThoughtNeeded: true
thoughtNumber: 5
totalThoughts: 6

// Step 6: Next actions
thought: "Next: Ask user if Keycloak is acceptable, then create implementation plan with specific files to modify"
nextThoughtNeeded: false
thoughtNumber: 6
totalThoughts: 6
```

### Workflow C: Code Analysis

```javascript
// Step 1: Understand structure
thought: "Repository has Node.js backend and React frontend. Monorepo with packages/ directory"
nextThoughtNeeded: true
thoughtNumber: 1
totalThoughts: 4

// Step 2: Trace data flow
thought: "API endpoints in /api, React components in /src, shared types in /packages/types"
nextThoughtNeeded: true
thoughtNumber: 2
totalThoughts: 4

// Step 3: Identify issues
thought: "Found issue: API calls not authenticated. Auth middleware missing on /api routes"
nextThoughtNeeded: false
thoughtNumber: 3
totalThoughts: 4

// Step 4: Recommend fix
thought: "Fix: Add auth middleware to Express app, implement JWT verification before routes"
nextThoughtNeeded: false
thoughtNumber: 4
totalThoughts: 4
```

## Best Practices

1. **Start with understanding** - First thought should always restate/clarify the problem
2. **Be explicit about uncertainty** - Say "I don't know X" rather than guessing
3. **Track your position** - Always know which thought number you're on
4. **Adjust totalThoughts** - If you realize you need more steps, use `needsMoreThoughts: true`
5. **Mark revisions** - If you realize a previous thought was wrong, use `isRevision: true`
6. **Branch for alternatives** - If exploring multiple approaches, use `branchId` to track them
7. **End with action** - Final thought should be a clear conclusion or next action

## Output Format

When concluding a thinking session:

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