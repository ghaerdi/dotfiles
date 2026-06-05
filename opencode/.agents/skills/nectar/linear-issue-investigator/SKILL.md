---
name: linear-issue-investigator
description: |
  Automatically investigate a Linear issue by fetching its details, attachments,
  comments, Jam sessions, Notion documents, and investigate linked Nectar
  application data via MongoDB.

  Use this skill whenever the user asks to "check a linear issue",
  "look at a linear issue", "investigate a linear issue", or references a Linear
  issue ID (e.g. "NV-1234") or URL. Also use when reviewing bug reports,
  feature requests, or any Linear ticket that might have screenshots, videos,
  Jam recordings, or external documentation attached.

  This skill is project-local and tailored for teams that attach Jam bug reports
  and Notion docs to Linear issues.
---

## Goal
When the user mentions a Linear issue, perform a thorough automated investigation:
1. Fetch the issue details from Linear.
2. Inspect all attachments (screenshots, files).
3. List comments for embedded links (Jam, Notion, Loom, etc.).
4. If a Jam session URL/ID is found, fetch its metadata, transcript, console logs,
   network requests, and screenshots.
5. If a Notion document URL is found, fetch its content and include a summary.
6. If a Nectar app URL is found, investigate the linked MongoDB data.
7. Summarize everything in a concise report.

## Workflow

### 1. Identify the issue
Extract the Linear issue ID or URL from the user's message.  
Examples: `NV-9186`, `https://linear.app/nectar/issue/NV-9186`

If the user only gave an ID without a team key (e.g. `9186`), prompt them for the
full identifier.

### 2. Fetch issue details
Use `linear_get_issue` with the issue ID/identifier.  
Request `includeRelations=true` and `includeReleases=true` so the report is
complete.

Capture:
- Title, description, state, priority, assignee
- Labels, project, milestone
- Attachments (URLs and IDs)
- Related / blocking issues

### 3. Inspect attachments
For every attachment returned by `linear_get_issue`:
- If it is an image, fetch it with `linear_get_attachment` and describe what you
  see (or present it if possible).
- If it is a file, note its filename and URL.

### 4. Read comments
Call `linear_list_comments` on the same issue ID.  
Scan every comment body for links:
- **Jam** – URLs matching `jam.dev/c/{uuid}` or `https://jam.dev/...`  
  → extract the Jam ID and proceed to step 5.
- **Notion** – URLs matching `notion.so`  
  → extract the Notion page ID from the URL and proceed to step 5B.
- **Nectar App** – URLs matching `*.app.prod.nectar.vet/`  
  → extract the clinic name, collection, and document ID, then proceed to step 4B.
- **Other** – Loom, Figma, Sentry, etc.  
  → note the URL for reference.

### 4B. Investigate Nectar application data via MongoDB
If a Nectar app URL was found (e.g. `https://epicvet.app.prod.nectar.vet/patients/69f2782be56082d4c9bdf962?view=history`):
1. Parse the URL to extract:
   - **Clinic name** — the first subdomain (e.g. `epicvet`). This is the MongoDB database name.
   - **Collection** — the path segment after the domain (e.g. `patients`).
   - **Document ID** — the ObjectId or UUID in the path (e.g. `69f2782be56082d4c9bdf962`).
2. Use the `mongo-prod` MCP to connect and run queries:
   - `mongo-prod_find` the document by `_id` in the identified collection and database.
   - If the collection is `patients`, also query related collections such as `patientHistory` or `patientVisits` using the patient `_id` as a foreign key.
   - If the URL includes a `view` or `tab` parameter (e.g. `?view=history`), prioritize fetching documents related to that context.
3. Summarize the MongoDB findings:
   - Document fields, especially any that look like they might be corrupted, missing, or recently changed.
   - Related documents and their counts.
   - Any obvious data inconsistencies that could explain the issue.

If the clinic name cannot be determined or the document is not found, clearly state that and provide the URL for manual review.

### 5B. Investigate Notion documents
If a Notion URL was found:
1. Extract the Notion page ID from the URL (the 32-character UUID in the path).
2. Use the `notion` MCP to fetch the page content and metadata (title, last edited, author).
3. Extract the most relevant information: key text blocks, bullet lists, tables, and any action items.
4. If the page contains links to other Notion pages or databases, note those as well.

Summarize the Notion findings:
- Page title and URL
- Last edited time and author
- Key content excerpts or action items relevant to the Linear issue
- Any linked databases or sub-pages

### 5. Investigate Jam sessions
If a Jam link/ID was found:
1. `jam_fetch` or `jam_getDetails` to get metadata (title, author, type,
   timestamps).
2. `jam_getScreenshots` if the Jam is a screenshot type.
3. `jam_getVideoTranscript` if it is a video Jam with captions.
4. `jam_getConsoleLogs` (limit 100) – look for JavaScript errors.
5. `jam_getNetworkRequests` (limit 100) – look for failed requests (5xx, 4xx).
6. `jam_getUserEvents` – trace the exact user interaction sequence.

Summarize the Jam findings:
- What the user did
- Any console errors or failed network calls
- Visual observations from screenshots

### 6. Compile the report
Use this template:

```
# Linear Issue: {IDENTIFIER} — {TITLE}

## Issue Details
- **State**: {state}
- **Priority**: {priority}
- **Assignee**: {assignee}
- **Description**: {shortened description or key excerpt}

## Attachments
- {list or "None"}

## External Links Found in Comments
- Jam: {link or "None"}
- Notion: {link or "None"}
- Other: {list or "None"}

## Nectar Application Data Summary
- **URL**: {url or "None"}
- **Clinic (DB)**: {clinic or "None"}
- **Collection**: {collection or "None"}
- **Document ID**: {id or "None"}
- **Document fields**: {key fields or "None"}
- **Related documents**: {list or "None"}
- **Data anomalies / observations**: {notes or "None"}

## Notion Document Summary
- **Title**: {title or "None"}
- **URL**: {url or "None"}
- **Last edited**: {timestamp or "None"}
- **Key content**: {brief excerpts or "None"}
- **Action items**: {list or "None"}

## Jam Session Summary
- **Type**: video | screenshot | replay
- **Author**: {author}
- **Key events**: {brief sequence}
- **Console errors**: {count + snippets or "None"}
- **Failed requests**: {count or "None"}
- **Screenshots**: {count or "None"}

## Initial Observations / Hypotheses
{Your analysis of what might be wrong based on the gathered evidence}
```

## Constraints
- Do NOT modify the Linear issue (no status changes, no comments) unless the
  user explicitly asks.
- Do NOT create new issues or attachments.
- If Notion docs or Nectar app data are referenced but inaccessible, clearly state that and provide
  the URL for manual review.
- Keep the report concise; include full logs/transcripts only when they are
  clearly relevant.
