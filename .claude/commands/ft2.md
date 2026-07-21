# ft2$ — Free Trial Label Tagger + Deal Creator

Tag HubSpot free-trial contacts with the `ft2__dollar` label and create a matching deal in the
Free Trial Signup Pipeline. Use when Rishabh pastes a list of free-trial contacts to label and
open deals for.

---

## Repo Location
`/Users/riahabharora/Desktop/shreegansh om kaali/customgpt-marketing-free-trial-funnel/`

Tracker file (source of truth for run history), relative to the repo above:
`campaigns/deployment-outreach/ft2-tracker.md`

This file is gitignored — it accumulates contact names/emails, which must never be committed
(see that repo's `CLAUDE.md`, "No PII in git"). It stays local per machine.

If it doesn't exist yet, create it with this structure:

```markdown
# ft2$ Tracker

| Date Received | # Contacts | # Updated | # Not Found | # Deals Created | Notes |
|---|---|---|---|---|---|
```

(If an existing tracker has an older header missing a column, add the column rather than
recreating the file.)

Part 1 (built) + Part 2 (built) of a multi-part flow.
- **Part 1:** take a list of contacts, log when the list was received, find each contact in
  HubSpot, and flip their `ft2__dollar` (label: "ft2__dollar$") checkbox property to `true`.
- **Part 2:** for every contact just labeled `ft2__dollar = true`, create a deal in the Free
  Trial Signup Pipeline, named per a specific date-based convention.
- **Parts 3+:** not yet defined.

---

## Input

Rishabh will paste a list of contacts (names and/or emails, any format — comma-separated,
newline-separated, copy-pasted from Slack/email/sheet).

He supplies the trial end date per contact separately (format still TBD — ask him for it when
he hasn't already included it inline with a contact). Don't assume or calculate a trial length
yourself; HubSpot has no stored trial-end-date field, only a start date, and Rishabh wants to
provide the real end date himself each time.

---

## Step 1 — Reminder check

Read the tracker file. If a previous entry exists, tell Rishabh how long it's been since the
last list:

> Last list was given on [date] ([X days ago]).

If the tracker is empty or missing, skip this and just note it's the first run.

---

## Step 2 — Log receipt

Parse the pasted list into individual contacts. Append a new row to the tracker with today's
date and the contact count (leave # Updated / # Not Found / # Deals Created blank for now —
filled in later steps).

---

## Step 3 — Find each contact in HubSpot

For each contact, search HubSpot (`mcp__claude_ai_HubSpot__search_crm_objects`, objectType:
contacts, query: email or name) to get their contact ID. Batch this efficiently rather than
one-by-one search calls where possible.

---

## Step 4 — Update the label

For every contact found, set `ft2__dollar` = `"true"` via
`mcp__claude_ai_HubSpot__manage_crm_objects` (`updateRequest`, `confirmationStatus: CONFIRMED`).

**Note:** HubSpot batch updates cap at 10 objects per call — chunk accordingly.

Update the tracker row from Step 2 with the final # Updated and # Not Found counts. List any
not-found contacts by name/email in the Notes column so they can be re-checked next time.

---

## Step 5 — Create the deal

For every contact that was successfully labeled `ft2__dollar = true` in Step 4:

### Get what you need
- **First name** — from the contact record (`firstname`)
- **Company** — from the contact's associated company (or the contact's `company` property if
  no associated company record)
- **Date created** — today's date (the date this run happens)
- **Date trial ends** — supplied by Rishabh per contact (do NOT calculate this yourself — ask if
  it wasn't given)

### Build the deal name

Format: `{dateCreated}_{firstname+company}_{dateTrialEnds}`

Example: `14thJuly_julio+procad_27thJuly`

Rules:
- **Date segments** (`dateCreated`, `dateTrialEnds`): `{day}{ordinal-suffix}{FullMonthName}` — no
  space, no year, month name capitalized (e.g. `14thJuly`, `1stJune`, `3rdMarch`, `22ndAugust`).
  - Ordinal suffix rule: 1,21,31→"st"; 2,22→"nd"; 3,23→"rd"; 11,12,13→"th" (exception);
    everything else→"th".
- **Middle segment**: `{firstname}+{company}`, both lowercase, joined by a literal `+`, no
  spaces. If the company name itself has spaces, collapse them (e.g. "Procad Inc" →
  "procadinc") — ask Rishabh once if unsure rather than guessing on ambiguous company names.
- Full name is exactly these 3 segments joined by `_` — nothing else appended.

### Create the deal

Use `mcp__claude_ai_HubSpot__manage_crm_objects` with `createRequest`:
- `objectType`: `deals`
- `properties`:
  - `dealname`: the constructed name above
  - `pipeline`: `791312162` (Free Trial Signup Pipeline)
  - `dealstage`: `1364415045` (In Free Trial)
  - `hubspot_owner_id`: `81355478` (Rishabh)
- `associations`: `[{"targetObjectId": <contactId>, "targetObjectType": "CONTACT"}]`

Follow the tool's mandatory confirmation flow (show the proposed deal names in a table, get
explicit approval before creating) unless Rishabh has already waived confirmations for the
session.

Update the tracker row with the # Deals Created count.

---

## Step 6 — Confirm to Rishabh

Report:
- How many contacts were found and labeled `ft2__dollar = true`
- Any contacts that couldn't be matched in HubSpot (so he can double check spelling/email)
- How many deals were created, with their exact names, in the Free Trial Signup Pipeline / In
  Free Trial stage
- The reminder from Step 1

Then say: "Parts 1 and 2 done — ready when you are for the last step."
