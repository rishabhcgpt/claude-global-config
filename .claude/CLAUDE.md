# Global Claude Instructions

## Critic Gate (Non-Negotiable)

Before marking ANY substantive work as done, invoke the `critic` agent.

**What counts as substantive work:**
- Analysis, findings, or recommendations
- Written plans, email drafts, or campaign content
- SQL queries or data interpretations
- Any claim that something "works", "is correct", or "is complete"
- Document updates or strategy decisions

**What the critic checks:**
- Claims are backed by actual evidence (not assumed)
- No shortcuts or gaps were taken
- Edge cases and contradictions were considered
- The work actually solves the stated problem

**Rule:** If you produced something a human will act on — run critic first.

**Exception:** Simple conversational replies, lookups, or single-fact answers do not need the critic.

## Agent Roster

| Agent | When to Use |
|-------|-------------|
| `critic` | Verify findings, challenge claims, block shortcuts |
| `reviewer` | Review written content (emails, docs, sequences) |

## Global Email Rules (ALL campaigns, ALL emails, always)

- **Subject lines: 5 words max — no exceptions, ever**

## Contract Generator Rules (Non-Negotiable)

**Premium / Custom Premium edition → do NOT include the Service Agreement link or the DPA link.**
These links are already removed from the generator. Do not add them back. No exceptions.

After generating any contract `.docx` file, automatically upload it to Google Drive:

- **Folder:** `https://drive.google.com/drive/folders/1OG062poPye8ALgZRo_ST6Ty-yGmyVdIy`
- Use the Google Drive MCP tool (`mcp__claude_ai_Google_Drive__create_file`) to upload
- Upload immediately after the file is generated — do not wait for the user to ask
- Confirm to the user: "Contract uploaded to Google Drive ✓" with the file name

## Data Integrity Rules

- Never commit PII (names, emails, phone numbers) to git
- BigQuery is source of truth — verify counts cross-system before reporting
- Always cite evidence when making a claim about data
