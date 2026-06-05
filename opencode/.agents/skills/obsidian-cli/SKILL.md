---
name: obsidian-cli
description: >
  Interact with Obsidian vaults using the Obsidian CLI to search, read, write,
  and organize notes. Use this skill when you need to perform programmatic operations 
  on any Obsidian vault, such as searching for context, managing notes, or updating 
  metadata via the CLI.
---

# Obsidian CLI

This skill provides instructions for using the [Obsidian CLI](https://obsidian.md/cli) to interact with Obsidian vaults. The CLI requires the Obsidian app to be running.

**Important:** `obsidian` in PATH typically launches the GUI app. Use the CLI binary directly:

```bash
obsidian-cli
```

If the path is not found (e.g., after a NixOS rebuild), you can find the current path with:

```bash
readlink -f ~/.nix-profile/bin/obsidian | xargs dirname | xargs -I{} ls {}/obsidian-cli
```

If Obsidian is not running, the CLI will print an error — you may need to launch the app first.

## Commands Reference

### Search & Read

```bash
# Search the vault
obsidian-cli vault=<vault-name> search query="query text"
obsidian-cli vault=<vault-name> search:context query="query text" format=json

# Read a note by name (resolves like wikilinks, no path needed)
obsidian-cli vault=<vault-name> read file=<filename>

# Read a note by exact path
obsidian-cli vault=<vault-name> read path="Folder/File.md"

# Read a specific property from a note
obsidian-cli vault=<vault-name> property:read name=<property-name> file=<filename>

# List all tags
obsidian-cli vault=<vault-name> tags counts format=json

# Get backlinks to a note
obsidian-cli vault=<vault-name> backlinks file=<filename> format=json
```

### Create & Write

```bash
# Create a note with content (use \n for newlines)
obsidian-cli vault=<vault-name> create path="Folder/File.md" content="Content here..."

# Append to an existing note
obsidian-cli vault=<vault-name> append file=<filename> content="\nNew content"

# Prepend after frontmatter
obsidian-cli vault=<vault-name> prepend file=<filename> content="Prepended content"

# Set a property (updates frontmatter)
obsidian-cli vault=<vault-name> property:set name=<property-name> value="value" file=<filename>
```

### Tasks

```bash
# List incomplete tasks from a note
obsidian-cli vault=<vault-name> tasks file=<filename> todo

# Mark a task as done
obsidian-cli vault=<vault-name> task file=<filename> line=<line-number> done
```

### Other Useful Commands

```bash
# List all files in a folder
obsidian-cli vault=<vault-name> files folder="Folder/Subfolder"

# Get headings/outline of a note
obsidian-cli vault=<vault-name> outline file=<filename> format=json

# Check unresolved links (broken references)
obsidian-cli vault=<vault-name> unresolved
```

## Tips

- **Use `format=json` when piping output** to other commands or when you need structured data.
- **The `file=` parameter resolves like wikilinks** — you can reference a note without the path or extension.
- **When creating a note**, use `path=` to ensure it is placed in the correct directory.
- **Link notes with wikilinks** (`[[Note Name]]`) to create connections that can be discovered via `backlinks`.
