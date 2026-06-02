# CustomGPT Demo Creator — Full Automated Flow

You are running the CustomGPT demo creator outreach workflow. Execute all steps autonomously without waiting for confirmation between steps (except the use-case confirm in Step 2).

---

## Repo Location
`/Users/riahabharora/marketing-customgpt-demo-creator/`

All campaign files go in: `examples/{company-slug}/`
Done campaigns go in: `examples/done/{company-slug}/`

---

## Input
The user will provide:
1. The lead's email address
2. The demo link (if the bot was built successfully)

If no demo link is provided, treat as **failure track**.

---

## Track Determination

| Track | Condition | Template |
|-------|-----------|----------|
| Success | Demo link provided, pages crawled >= 15 | `emails/t1-success.md` |
| Failure | No demo link, or bot errored | `emails/t1-failure.md` |
| Partial | Pages crawled < 15 | `emails/t1-failure.md` — treat as failure |

For **failure/partial**: flag to Rishabh that a manual demo build is needed before generating the email. Do not save the Gmail draft until Rishabh provides `[MANUAL_DEMO_LINK]`.

---

## Step 1 — Research (run in parallel)

Extract the email from the input. Then simultaneously:
- Search HubSpot (`mcp__claude_ai_HubSpot__search_crm_objects`, objectType: contacts, query: email) — get: firstname, lastname, email, company, jobtitle, hs_linkedin_url
- Search the web (`mcp__perplexity__perplexity_search`) for the company name + "what do they do"

Flag any HubSpot LinkedIn mismatches (wrong name on the LinkedIn URL) — ignore the URL, use the email-derived name.

---

## Step 2 — Confirm Data (one message, 30 seconds)

Show the user:

```
Company: [Name]
Contact: [First Name] [Last Name], [Title]
Track: [Success / Failure / Partial]
Demo link: [link or "needs manual build"]

3 use cases I'm planning to build around:
1. [use case 1]
2. [use case 2]
3. [use case 3]

Good to go? Or any corrections?
```

Wait for confirmation before generating any files.

---

## Step 3 — Generate email.md

### Success track body (non-negotiable):

```
Hi [First Name], this is not an automated message (real person here, I promise =) )

saw you just built a demo for your [Company] website, and I wanted to reach out personally.

I made a one-pager showing how [Company] could take this further, 30s to read (attached).

Here's your demo, test it out here
[DEMO_LINK]

if you'd like, we can also hop on a quick 15 min call:
[CALENDLY_LINK]

We are happy to extend a priority free trial for you, just let me know if you would be interested to explore and we can set you up.

Best,
Rishabh
```

Subject: `Your [Company] AI is live` — 5 words max. If company name is long, abbreviate so total stays ≤ 5 words.

### Failure track body (non-negotiable):

```
Hi [First Name], this is not an automated message (real person here, I promise =) )

saw the demo didn't build properly for [Company], that's on us, not you.

I went ahead and built one manually. You can test it here
[MANUAL_DEMO_LINK]

Also made a quick one-pager on how [Company] could use this, 30s (attached).

if it looks useful, happy to hop on a 15 min call and walk you through it.
[CALENDLY_LINK]

Happy to provide an extended free trial of the platform for [company-short], just say the word and I'll make it happen from the backend.

Best,
Rishabh
```

Subject: `Rebuilt this for [Company]` — 5 words max.

**[company-short]** — short name or abbreviation, lowercase (e.g. "css" for Contact Centre Specialists).

### Shared rules:
- No Stripe link — ever. These leads have not seen the payment page.
- No bold, no bullet points in the email body.
- Sign-off: "Best,\nRishabh" only — no "Warm regards", no full name.
- **CALENDLY_LINK** always: `https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation/?utm_source=website&utm_medium=remarketing&utm_campaign=demo_creator&utm_content=recovery`
- Links are provided as plain text on their own line — Rishabh hyperlinks them manually in Gmail.
- If the lead's language is not English (e.g. Spanish, French), write the entire email in their language. Subject line still ≤ 5 words.

Save to: `examples/{company-slug}/email.md`

---

## Step 4 — Generate one-pager.html

Layout rules (non-negotiable):
- `@page { margin: 0; size: letter; }`
- `body { width: 750px; padding: 28px 36px; font-size: 13px; }`
- Header: left (h1 purple + subtitle tagline) | right (📅 Book a 15-Min Call button)
- Book button href: `https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation?utm_source=abandoned_cart&utm_medium=email&utm_campaign=recovery_v2&utm_content=day1_15min`
- 6 bullets: `border-left: 3px solid #6366f1`, `→` prefix, one sentence each, specific to this company
- CTA box at bottom: extended trial, train on everything, reply to get set up
- No raw URLs visible anywhere
- No Stripe link in the PDF
- If email is in another language, write the one-pager in that same language

Canonical reference: `/Users/riahabharora/hot-vs-cold-abandon-carts/examples/done/little-big-tiny-house-harm/one-pager.html`

Save to: `examples/{company-slug}/one-pager.html`

---

## Step 5 — Generate PDF

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --print-to-pdf="/Users/riahabharora/marketing-customgpt-demo-creator/examples/{folder}/{CompanyName} x CustomGPT.pdf" /Users/riahabharora/marketing-customgpt-demo-creator/examples/{folder}/one-pager.html
```

---

## Step 6 — Save Gmail Draft

Use `mcp__claude_ai_Gmail__create_draft`:
- `to`: lead's email
- `subject`: as defined above
- `body`: full email text with actual demo link embedded (plain text)

Do NOT include the PDF — Rishabh attaches it manually before sending.

---

## Step 7 — Confirm to User

```
Draft saved in Gmail — ready to send to [First Name] <email>.
Attach the PDF before hitting send: examples/{folder}/{CompanyName} x CustomGPT.pdf
```

Then remind: "After sending, enroll in HubSpot sequence: **Demo Creator — Follow-up (T2 + LinkedIn + T3)**. Set `demo_creator_link` on the contact first."

For failure/partial leads: "Before enrolling, confirm `demo_creator_link` is set to [MANUAL_DEMO_LINK] — T2 and T3 will fire blank without it."

---

## After Rishabh Confirms Send

1. Move folder to `examples/done/{company-slug}/`
2. Create `examples/done/{company-slug}/email-sent.md` with date and notes

---

## GitHub Push Rules

Never commit email.md files — they contain PII (email addresses, demo links).
Only commit: `one-pager.html`, docs, and template changes.
