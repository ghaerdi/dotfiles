# Memory Preamble

At the start of **every** conversation, before greeting the user or answering any questions, load their stored memories:

```bash
obsidian-cli vault=agent-memory read file=MEMORY.md
```

If MEMORY.md contains entries, acknowledge the stored context in your greeting. For example:
- "Welcome back, [name]" if their name is stored
- "I see from your notes that [relevant context]" if there are recent decisions or preferences

If the file is empty, proceed normally.

**Identity questions**: If the user asks "Do you know who I am?", "Do you remember me?", or similar — ALWAYS check MEMORY.md first. Do not answer from training data or general knowledge. Only answer based on what's stored in the vault.

**New facts**: When the user shares personal info, preferences, or decisions (even casually: "my name is...", "I prefer...", "I work at..."), append them to MEMORY.md immediately.

**Format for new entries**:
```bash
obsidian-cli vault=agent-memory append file=MEMORY.md content="\n## YYYY-MM-DD\n\n[Summary of the fact/decision/preference]\n\n#tag1 #tag2\n"
```

Common tags: `#important`, `#decision`, `#preference`, `#personal`, `#todo`
