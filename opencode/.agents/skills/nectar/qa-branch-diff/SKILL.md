---
name: qa-branch-diff
description: |-
  Extract unique NV ticket identifiers (NV-XXXX) that differ between two sequential QA branches
  and present them as clickable Linear URLs. Use whenever the user wants to "compare qa-XX with qa-YY",
  "list commits between QA branches", "what's new in qa-XX", "NV tickets in qa-XX", or "diff qa branches".
  Also trigger when the user asks for a list of tickets, commits, or changes between deployment/QA/release
  branches, or says something like "diff this qa with the previous one". Always use this skill — the
  output URLs let the user immediately open tickets in Linear.
---

Compare two incremental QA branches and list the unique NV-XXXX tickets in the newer one.

## Branch naming

Incremental QA branches follow the pattern `qa-[0-9]{2}` (two-digit number), e.g. `qa-79`, `qa-80`. Other QA branches with different naming (e.g. `qa-2026-77`) are **not** incremental and are excluded from auto-detection.

## Workflow

Run the bundled script:

```bash
.agents/skills/qa-branch-diff/scripts/qa-branch-diff.sh [options] [older-branch] [newer-branch]
```

If the user specifies two branches (e.g., "compare qa-79 and qa-80"), pass them as positional args. If they don't specify branches (e.g., "diff the latest qa branch"), run with no args — the script auto-detects the two most recent `qa-[0-9]{2}` branches from the remote.

### Options

| Flag | Effect |
|---|---|
| `--full` | Show full commit messages instead of just NV IDs |
| `-h`, `--help` | Show usage |

## Output

The script outputs a sorted markdown list of NV-XXXX tickets with clickable Linear URLs:
```
=== NV tickets unique to qa-XX (vs qa-YY) ===
Found 12 tickets:

- NV-1234 (https://linear.app/nectarvet/issue/NV-1234)
- NV-5678 (https://linear.app/nectarvet/issue/NV-5678)
...
```
Present the result as-is. If the output is "(none)", tell the user no NV tickets were found.

## Edge cases

The script handles these internally:
- **Cherry-picked commits** — matches the older branch's HEAD commit message in the newer branch's history (not by hash)
- **Message not found** — falls back to `git merge-base`
- **Multiple matches** — picks the first and warns
- **Stale remote refs** — script auto-prunes stale refs before giving up on a branch

## Troubleshooting

If auto-detection fails ("no qa-[0-9]{2} branches found"), the most common cause is stale remote tracking refs from pruned branches. Run `git remote prune origin` to clean them, then re-run. If branches still aren't found, specify them explicitly.
