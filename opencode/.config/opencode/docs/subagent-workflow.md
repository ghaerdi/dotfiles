# Subagent Workflow Coordination

This document defines how agents should coordinate and when to invoke custom subagents.

## Agent Registry

### Core Subagents (invoke via `task(subagent_type="...")`)

| Agent | Purpose | Model | When to Use |
|-------|---------|-------|-------------|
| `researcher` | Web research, browser automation | gemini-3.1-pro-preview | Live web search, documentation lookup, data extraction |
| `librarian` | Official documentation, code examples | minimax-m2.7:cloud | API references, framework guides, Context7 queries |
| `code-reviewer` | Code validation, pattern consistency | deepseek-v3.2:cloud | After writing/modifying code, before finalization |
| `tester` | Bug finding, test writing, test execution | devstral-2:cloud | After review passes, for comprehensive testing |
| `infra-ops` | DevOps, databases, containers | minimax-m2.7:cloud | Docker, Kubernetes, database operations, cloud infra |
| `oracle` | High-IQ consultant for complex problems | glm-5:cloud | Architecture decisions, debugging after 2+ failures |
| `metis` | Pre-planning consultant | qwen3.5:cloud | Complex task scoping, ambiguity resolution |
| `momus` | Work plan reviewer | qwen3.5:397b-cloud | Evaluate plans for clarity, verifiability, completeness |
| `explore` | Codebase pattern discovery | minimax-m2.7:cloud | Find existing patterns, file structures, implementations |
| `architect-designer` | High-level system design | gemini-3.1-pro-preview | Architecture planning, pattern selection, trade-off analysis |
| `implementation-specialist` | Precise code implementation | devstral-2:cloud | Execute delegated coding tasks following existing patterns |
| `requirements-clarifier` | Requirements gathering | gemini-2.5-pro | Transform vague tasks into actionable specifications |
| `brainstormer` | Creative ideation | qwen3.5:397b-cloud | Idea generation, divergent thinking, creative problem-solving |
| `tech-lead` | Orchestrator/coordinator | qwen3.5:397b-cloud | Complex workflows requiring multiple specialists |

### Skills (invoke via `skill()` tool)

| Skill | Purpose | Trigger |
|-------|---------|---------|
| `context7-mcp` | Fetch current library docs | Library/framework API questions |
| `find-docs` | Documentation lookup | General technology documentation |
| `gh-cli` | GitHub CLI operations | PRs, issues, repo operations |
| `time-mcp` | Timezone conversion | Cross-timezone scheduling |
| `find-skills` | Skill discovery | "Find a skill for X" requests |

---

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

---

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

---

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

---

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

---

## Architecture & Design Workflow

### When to Use architect-designer

Call `architect-designer` (via Task tool with `subagent_type="architect-designer"`) for:
- High-level system design before implementation
- Technology selection with trade-off analysis
- Directory structure and module boundary planning
- Pattern selection (CQRS, Event Sourcing, Hexagonal, etc.)
- Refactoring strategy for complex systems

**DO NOT use for**: Implementation details, configuration files, or deployment scripts.

<example>
Context: User needs to design a real-time notification system.

assistant: "I'll use the architect-designer agent to create the high-level design and technical decisions for this system."

<commentary>
The user needs architectural planning before any code is written. The architect-designer produces design documents and pattern selection without implementation code.
</commentary>
</example>

---

## Requirements Clarification Workflow

### When to Use requirements-clarifier

Call `requirements-clarifier` (via Task tool with `subagent_type="requirements-clarifier"`) when:
- User request is vague or ambiguous ("Build me a notification system")
- Edge cases are not specified
- User stories need formalization
- Business logic needs clarification
- Acceptance criteria are missing

**Output**: User stories, acceptance criteria, edge cases, open questions - NO CODE.

<example>
Context: User asks for a feature but requirements are vague.

user: "Add a payment feature"

assistant: "I'll delegate this to the requirements-clarifier agent to define the payment feature specifications"

<commentary>
Since the payment feature description is too broad, use the requirements-clarifier to break it down into user stories, acceptance criteria, and edge cases.
</commentary>
</example>

---

## Implementation Workflow

### When to Use implementation-specialist

Call `implementation-specialist` (via Task tool with `subagent_type="implementation-specialist"`) when:
- Requirements are clear and approved
- Architecture decisions are complete
- You need precise code implementation following existing patterns
- The task is well-scoped and bounded

**STRICT SCOPE**: Only implement what is delegated. No refactoring, no architecture changes.

<example>
Context: User has approved a design and wants it built exactly as specified.

user: "Build the API endpoint for /users/{id}/profile exactly as designed in the spec"

assistant: "I'll use the implementation-specialist agent to implement this endpoint precisely per the specification."

<commentary>
The task is to implement a pre-approved design exactly as specified. The implementation-specialist follows the spec closely and matches project conventions.
</commentary>
</example>

---

## Complex Workflow Orchestration (tech-lead)

### When to Use tech-lead

Call `tech-lead` (via Task tool with `subagent_type="tech-lead"`) for:
- Multi-phase projects requiring coordination
- Ambiguous requests needing decomposition
- Workflows requiring multiple specialists in sequence
- Quality gate management across specialists

**Delegation Chain**: requirements-clarifier → architect-designer → implementation-specialist → code-reviewer → tester

<example>
Context: User has a complex feature request requiring multiple phases.

user: "I need a new user authentication system with OAuth2, MFA, and session management"

assistant: "I'll use the tech-lead agent to orchestrate this complex request across multiple specialists"

<commentary>
This is a complex multi-phase request requiring requirements clarification, architecture design, implementation, and testing. The tech-lead coordinates the full workflow.
</commentary>
</example>

---

## Creative & Exploratory Workflows

### When to Use brainstormer

Call `brainstormer` (via Task tool with `subagent_type="brainstormer"`) for:
- Creative idea generation (gifts, themes, story concepts)
- Problem-solving with divergent thinking
- When user expresses feeling stuck or needs a "spark"
- Weekend activities, event planning, creative solutions

**Output**: 10-15 varied ideas organized by category, with 3-5 standout suggestions.

<example>
Context: User needs creative inspiration.

user: "I need story concepts for a mystery set in Victorian England"

assistant: "I'll use the brainstormer agent to generate creative story concepts and plot ideas."

<commentary>
The user needs divergent thinking and creative exploration. The brainstormer generates varied options across different angles.
</commentary>
</example>

---

## Consultation Agents (oracle, metis, momus)

### When to Consult oracle

Call `oracle` (via Task tool with `subagent_type="oracle"`) for:
- Complex architecture decisions with multi-system tradeoffs
- Debugging after 2+ failed fix attempts
- Unfamiliar code patterns requiring deep analysis
- Security/performance concerns
- High-IQ reasoning for hairy problems

**Read-only**: Oracle provides consultation, not implementation.

### When to Consult metis

Call `metis` (via Task tool with `subagent_type="metis"`) for:
- Pre-planning analysis of complex tasks
- Identifying hidden intentions and ambiguities
- AI failure point prediction
- Scope clarification before implementation

### When to Consult momus

Call `momus` (via Task tool with `subagent_type="momus"`) for:
- Work plan review before implementation
- Evaluating plans for clarity, verifiability, completeness
- Catching gaps and ambiguities in planned work
- Post-implementation quality assurance

---

## Exploration & Discovery (explore, librarian)

### When to Use explore

Call `explore` (via Task tool with `subagent_type="explore"`) for:
- Finding existing codebase patterns and conventions
- Cross-layer pattern discovery
- Unfamiliar module structure exploration
- File structure and implementation location

**Contextual grep**: Searches OUR codebase, project-specific logic.

### When to Use librarian

Call `librarian` (via Task tool with `subagent_type="librarian"`) for:
- External reference lookup (docs, OSS, web)
- Official API documentation
- Library best practices
- GitHub implementation examples

**Reference grep**: Searches EXTERNAL resources, official docs, community patterns.

---

## Parallel Execution Pattern

**Parallelize independent agents** for maximum throughput:

```typescript
// CORRECT: Parallel exploration
task(subagent_type="explore", run_in_background=true, ...)
task(subagent_type="librarian", run_in_background=true, ...)

// CORRECT: Parallel research
task(subagent_type="librarian", run_in_background=true, prompt="Find JWT security docs")
task(subagent_type="researcher", run_in_background=true, prompt="Find Express auth patterns")

// WRONG: Sequential when parallel is possible
task(subagent_type="explore", run_in_background=false, ...)  // Waits
task(subagent_type="librarian", run_in_background=false, ...) // Then starts
```

**End your response** after launching parallel background tasks. System notifies on completion.

---

## Quality Gates

**Mandatory sequence for code changes**:

```
Implementation → code-reviewer → tester → (iterate) → Delivery
```

**Gate rules**:
- code-reviewer must PASS before calling tester
- tester must PASS before delivery
- Fix issues → re-review → re-test until both pass
- Never deliver with failing tests or review issues

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