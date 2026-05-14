Run the full post-call workflow for a contact. The contact is: $ARGUMENTS

## Step 1 — Confirm the last call on Google Calendar

Search Google Calendar for the most recent event involving the contact ($ARGUMENTS). Confirm the date, time, and meeting title. If multiple events exist, use the most recent one.

## Step 2 — Find the transcript in Google Drive

Search Google Drive for the meeting notes or transcript associated with that call. Look for documents with the contact's name or meeting date in the title (Gemini notes format: "[Name] and Rishabh Arora - [date] - Notes by Gemini"). Read the full document and extract:
- Contact's name, company, role
- Their core use case and problem they're trying to solve
- Any specific features they asked about (e.g. accuracy, security, pricing, integrations)
- Any commitments Rishabh made on the call
- Key objections or concerns raised
- Timeline or urgency signals

## Step 3 — Write the follow-up email

Write a personalised follow-up email based on the transcript. Rules:
- Subject line: 5 words max — no exceptions
- Open with their first name and a specific callback to something real from the call
- One paragraph max per section — keep it tight
- Mention the specific use case back to them (shows you listened)
- Include the trial link if relevant: app.customgpt.ai/extra/14-day-trial/standard
- Include docs link if relevant: https://docs.customgpt.ai/docs/welcome
- If a deck/one-pager is relevant, include a placeholder: [INSERT DECK LINK]
- Close soft: "happy to hop on a quick call, just reply" style
- Sign off: "Best,\nRishabh" only
- No bold, no bullets, no Calendly link in body, no em dashes

Show the draft email for review before proceeding.

## Step 4 — Save to Gmail draft

Create a Gmail draft with:
- To: the contact's email
- Subject: (5 words max)
- Body: the email from Step 3
- From: rishabh@customgpt.ai

Confirm the draft ID once created.

## Step 5 — Create HubSpot deal

Look up the contact in HubSpot by email. If not found, note it and skip association.

Create a deal with:
- Deal name: "[Company] — [Use Case short label]"
- Pipeline: Free Trial Signup Pipeline (ID: 791312162)
- Deal stage: Under Consideration (ID: 1158235413)
- Owner: Rishabh Arora (owner ID: 81355478)
- Associate with the contact record

## Step 6 — Summary

Report back with:
- Call confirmed: date + title
- Transcript found: doc title + link
- Gmail draft: ID + subject line
- HubSpot deal: name + link
- Any placeholders in the email that still need filling in (e.g. [INSERT DECK LINK])
