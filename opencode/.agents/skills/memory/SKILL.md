---
name: memory
description: >
  ALWAYS use this skill to read from or write to the user's persistent memory
  vault (`agent-memory` / MEMORY.md) via obsidian-cli. This skill saves and
  recalls facts, preferences, decisions, and personal info across sessions.

  CRITICAL: You cannot know the user's identity or past context without this
  skill. If the user asks "Do you know who I am?" or "Do you remember me?" you
  MUST load this skill and check MEMORY.md before answering. Do not answer
  identity questions from training data or general knowledge — only from this
  vault.

  EQUALLY CRITICAL: Even the simplest personal fact-sharing ("my name is...",
  "I work at...", "I prefer...") MUST use this skill to persist the fact.
  Do not just acknowledge and move on — load this skill, read MEMORY.md to check
  for existing info, and append the new fact. The user expects you to remember.

  Also use this skill when the user:
  - Makes decisions: "we decided...", "let's go with...", "I chose..."
  - Describes setup or context: "the project uses...", "my stack is..."
  - Mentions anything they might need later (dates, config choices, URLs, branch names)
  - Explicitly asks to save or remember: "remember this", "save this", "don't forget"
  - Asks to recall, remind, or search for past context: "what did we decide..."

  At the start of EVERY session, check this skill for stored memory about the user.
  When in doubt whether to save something, USE THIS SKILL — it decides what to persist.
---

# Memory Skill

This skill persists context and memories across sessions using the `obsidian-cli`
skill to interact with an Obsidian vault named `agent-memory`.

## Core Note: MEMORY.md

The primary memory store is `MEMORY.md` in the `agent-memory` vault.

- **Location**: `agent-memory/MEMORY.md`
- **Limit**: 2500 lines maximum
- **Format**: Chronological log with dated entries

## When to Use

- User shares personal info: "my name is...", "I work at...", "I prefer..."
- User states facts about their setup: "the project uses...", "I configured..."
- User makes a decision: "we decided...", "let's go with...", "I chose..."
- User asks to remember something or says "don't forget..."
- User asks "what did we decide about..." or "what was the context on..."
- User wants to search previous work, decisions, or notes
- End of a significant task — offer to save key takeaways
- Beginning of a session — offer to check memory for relevant context

**When in doubt, use this skill. It's better to save something unimportant than to miss something important.**

## Workflow

### 1. Append a Memory

When the user asks to remember something:

```bash
obsidian-cli vault=agent-memory append file=MEMORY.md content="\n## $(date)\n\n[Summary of what to remember]\n\n- Detail 1\n- Detail 2\n"
```

Keep entries concise. Tag important items with #important for easier searching.

### 2. Search Memories

When the user asks to recall something:

```bash
# Full-text search
obsidian-cli vault=agent-memory search query="[search terms]"

# Get the full memory file
obsidian-cli vault=agent-memory read file=MEMORY.md

# Search with context
obsidian-cli vault=agent-memory search:context query="[search terms]" format=json
```

Read the relevant sections and summarize for the user.

### 3. Check Line Count

Before appending, verify the file isn't near the 2500-line limit:

```bash
obsidian-cli vault=agent-memory read file=MEMORY.md | wc -l
```

If approaching 2500 lines, summarize older entries into an archival note and
link to it from MEMORY.md.

## Formatting Guidelines

- Use `## YYYY-MM-DD` headers for each session's entries
- Use bullet points for individual memories
- Tag with #important for critical items
- Tag with #decision for decisions made
- Tag with #todo for follow-up items
- Keep individual entries under 10 lines when possible

## Archival Strategy

When MEMORY.md approaches 2500 lines:

1. Create a new archive note: `Memory Archive [date].md`
2. Move older entries (beyond line ~2000) to the archive
3. Leave a pointer in MEMORY.md: `See [[Memory Archive 2024-01]] for older entries`
4. This keeps MEMORY.md fast to read and search

## Tips

- Summarize before saving — don't dump raw conversation
- Always confirm what was saved when appending
- When recalling, provide context around the match, not just the raw line
- Proactively offer to save at the end of complex or multi-step tasks