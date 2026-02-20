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

## Data Integrity Rules

- Never commit PII (names, emails, phone numbers) to git
- BigQuery is source of truth — verify counts cross-system before reporting
- Always cite evidence when making a claim about data
