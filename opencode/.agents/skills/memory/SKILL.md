---
name: memory
description: >
  Use jrnl as a persistent memory store to remember user information, preferences, project context, and facts across conversations. This skill should trigger whenever: the user shares personal information, preferences, or project details that would be useful to remember later; when you need to recall prior context about the user, their setup, or their work; when the user asks "do you remember..." or similar recall questions; when the user mentions storing, saving, or noting something for later; when discussing projects, tools, or workflows where knowing the user's history would improve your assistance. Always query relevant memories before answering questions about the user's projects, preferences, setup, or past conversations — even if you think you remember, the journal may have more current information.
---

# Memory Skill

Use `jrnl` (a CLI journal tool) as a persistent memory store. This gives you continuity across conversations — facts written in one session are available in future ones.

## Setup

A dedicated memory journal is configured at:

```
Config:  /home/ghaerdi/.local/share/jrnl/memory-config.yaml
Journal: /home/ghaerdi/.local/share/jrnl/memory.txt
```

If the files don't exist, create them by running:

```bash
cat > /home/ghaerdi/.local/share/jrnl/memory-config.yaml << 'CONF'
colors:
  body: none
  date: black
  tags: yellow
  title: cyan
default_hour: 9
default_minute: 0
editor: nvim
encrypt: false
highlight: true
indent_character: '|'
journals:
  default:
    journal: /home/ghaerdi/.local/share/jrnl/memory.txt
linewrap: 79
tagsymbols: '#@'
template: false
timeformat: '%F %r'
version: v4.2
CONF

touch /home/ghaerdi/.local/share/jrnl/memory.txt
```

Then test it:

```bash
echo "@memory @fact setup_test: ok" | jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml --import 2>/dev/null
```

All jrnl operations in this skill use `--config-file <config-path>` so the memory journal stays separate from any personal journal the user may have.

## Memory Conventions

Every memory entry starts with `@memory` plus a **category tag** that describes what kind of information it is. Use key-value pairs or natural language within the entry.

### Categories

| Tag | Purpose | Examples |
|---|---|---|
| `@fact` | Factual information about the user | `@memory @fact name: Alex` / `@memory @fact location: Berlin, Germany` |
| `@pref` | User preferences and tastes | `@memory @pref editor: nvim` / `@memory @pref prefers Go over Python for new projects` |
| `@ctx` | Project or work context | `@memory @ctx project:nectar topic:zustand-state-skill status:active` |
| `@note` | General notes the user asked you to remember | `@memory @note user wants commit messages in conventional commit format` |

### Writing Style

Use whichever format fits the information best:

- **Key-value** for structured data: `@memory @fact key: value`
- **Natural language** for nuanced info: `@memory @pref prefers dark mode in all editors and terminals`
- **Mixed** for context: `@memory @ctx project:blog-tech-stack status:planning wants to use Astro with MDX`

Include enough context in the entry that it makes sense on its own when retrieved later. If the information is time-sensitive, note the timeframe.

## When to Write Memories

Write a memory whenever you learn something that would be useful across conversations:

- **User shares personal info**: name, location, job, tools, tech stack
- **User states a preference**: "I like X", "I prefer Y", "Z doesn't work for me"
- **User describes a project**: project name, goals, tech choices, status
- **User asks you to remember something**: "note this", "remember that", "save this"
- **User corrects you**: corrections about their preferences or setup are especially valuable

**Don't** write memories for:
- Transient conversation state (what you're currently working on in this session)
- Information the user explicitly says not to save
- Things that are obviously one-off (a single file path they're editing)

## When to Read Memories

Before answering questions about the user, their work, or their preferences, query the memory journal for relevant entries. Specifically:

- **Any time you'd benefit from knowing the user**: Before giving advice on tools, projects, or code patterns
- **User asks "do you remember..."**: Query for the topic they mention
- **User references a past conversation**: Search for context
- **User starts a new topic that overlaps with known context**: e.g., if you know they use NixOS and they ask about a package, check for related preferences
- **User mentions a project name**: Check if there's context about that project
- **First response in a conversation**: Do a broad query for recent/relevant memories

## Query Patterns

Use `-tagged` with the category and/or `-contains` with keywords. Keep queries focused — don't load everything.

### By category (get all facts)
```bash
jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml -tagged @fact --format text
```

### By keyword
```bash
jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml -contains "project:nectar" --format text
```

### Combined (category + keyword)
```bash
jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml -tagged @pref -contains "language" --format text
```

### Recent entries
```bash
jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml -n 10 --format text
```

### Date range
```bash
jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml -from "2026-01-01" --format text
```

### All @memory entries (use sparingly — only when you need broad context)
```bash
jrnl --config-file /home/ghaerdi/.local/share/jrnl/memory-config.yaml -tagged @memory --format text
```

## Parsing Retrieved Memories

jrnl's plain text format outputs entries like:
```
[2026-06-11 09:41:20 PM] @memory @fact name: Alex
[2026-06-11 09:41:25 PM] @memory @pref prefers verbose explanations
```

Parse these by looking at the text after the timestamp. The tags (`@memory`, `@fact`, etc.) and key-value pairs are the structured data. Include relevant memories in your context when responding.

## Important Principles

1. **Be selective with reads.** Don't dump all memories every time. Query only what's relevant to the current conversation. Broad queries (`-tagged @memory` without filters) should be rare.
2. **Be thorough with writes.** If the user shares multiple pieces of info, write multiple entries or one well-structured entry. Don't skip details because they seem small — those are often the most useful later.
3. **Don't rewrite history.** Each memory is a new entry with a timestamp. If information changes (e.g., user changes jobs), write a new entry rather than trying to find and update the old one. The user can clean up stale entries with `jrnl --delete` if they want.
4. **Stay useful.** The point is to make future conversations smoother. If a piece of info wouldn't matter in a future conversation, don't store it.
5. **Acknowledge when using memory.** When you retrieve relevant memories, briefly reference them so the user knows the system is working: "I remember from our last chat that you prefer Go — based on that, I'd recommend..."
