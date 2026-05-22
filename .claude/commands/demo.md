# Demo Creator Lead — Full Automated Flow

You are running the CustomGPT demo creator follow-up workflow. Execute all steps below autonomously without waiting for confirmation between steps (except the use-case confirm in Step 4).

---

## Repo Location
`/Users/riahabharora/Sites/marketing-customgpt-demo-creator/`

All campaign files go in: `examples/{company-name}/`
Done campaigns go in: `examples/done/{company-name}/`

---

## Input
The user will paste a Slack demo creator ping. It will look like one of these:

**Success ping:**
```
Demo created for: john@example.com
Website: https://example.com
Demo link: https://app.customgpt.ai/projects/XXXX/...
Pages crawled: 147
```

**Failure ping:**
```
Demo FAILED for: john@example.com
Website: https://example.com
Error: [reason]
```

**Partial ping (treat same as failure):**
```
Demo created for: john@example.com
Website: https://example.com
Demo link: https://app.customgpt.ai/projects/XXXX/...
Pages crawled: 4
```
If pages crawled < 15, treat as partial/failure — the demo is effectively useless and needs a manual rebuild.

---

## Step 1 — Extract from Slack ping

Extract:
- Email address
- Website URL
- Demo link (if present)
- Pages crawled
- Determine track: **success** (≥15 pages + demo link), **failure** (error, no demo link), or **partial** (<15 pages — treat as failure)

---

## Step 2 — Search HubSpot

Use HubSpot MCP (account ID: 47243993) to search for the contact by email.
Pull: first name, last name, company name, job title, LinkedIn URL.
If no record exists, note it — still proceed using website data.

---

## Step 3 — Research the company website

Visit the website URL. Look for:
- What the company does (one sentence)
- Their audience / customer type
- 3 specific CustomGPT use cases tailored to their actual product/service/audience
- One or two relevant pain points

Be specific. Generic use cases ("you could use an AI chatbot") are worse than nothing. Name their actual product, audience, workflow.

---

## Step 4 — Confirm with Rishabh (one message, 30 seconds)

Show:
```
Company: [Name]
Contact: [First Name] [Last Name], [Title]
Track: [Success / Failure / Partial]
Demo link: [link or "needs manual build"]
Pages crawled: [N]

3 use cases I'm planning to build around:
1. [use case 1]
2. [use case 2]
3. [use case 3]

Good to go? Or any corrections?
```

**Do not generate any files until Rishabh confirms.**

For partial/failure: flag before confirming — "This is a partial/failure — a manual demo build is needed. Once you've built it in the CustomGPT admin panel, share the [MANUAL_DEMO_LINK] and I'll generate the email."

---

## Step 5 — Generate email.md

Use the correct template from the repo:
- **Success** → `emails/t1-success.md`
- **Failure or Partial** → `emails/t1-failure.md`

Fill in all placeholders: [First Name], [Company], [DEMO_LINK], [MANUAL_DEMO_LINK], [SIGNUP_LINK], [CALENDLY_LINK].

Constants:
- `CALENDLY_LINK`: `https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation/?utm_source=website&utm_medium=remarketing&utm_campaign=demo_creator&utm_content=recovery`
- `SIGNUP_LINK`: `https://app.customgpt.ai/register`

Save to: `examples/{company-name}/email.md`

Rules (non-negotiable):
- Never include a Stripe link — these leads have never seen the payment page
- Never bold, never bullets in body
- Sign-off: "Best,\nRishabh" only
- Calendly link is plain text in body — Rishabh hyperlinks it manually in Gmail

---

## Step 6 — Generate one-pager.html

Build an HTML one-pager. CSS rules (non-negotiable):
```css
@page { margin: 0; size: letter; }
body { width: 750px; padding: 28px 36px; font-size: 13px; }
.bullets li { padding: 8px 12px 8px 38px; position: relative; border-left: 3px solid #6366f1; margin-bottom: 7px; background: #fafafa; border-radius: 0 6px 6px 0; font-size: 13px; color: #1f2937; line-height: 1.4; }
.bullets li::before { content: "→"; position: absolute; left: 12px; color: #6366f1; font-weight: 700; }
```

Layout:
- Header: company name + subtitle left | "📅 Book a 15-Min Call" button top right (href = Calendly link, no raw URL visible)
- 6 bullets with purple left border, `→` prefix, one tailored sentence each
- CTA box at bottom: 3 bullets only (extended trial, 15-min call, no credit card needed) — NO button in CTA box
- Footer: "CustomGPT.ai · Prepared for [First Name] @ [Company]"
- No Stripe link, no raw URLs visible

Save to: `examples/{company-name}/one-pager.html`

---

## Step 7 — Generate PDF

Run this exact command (fill in `{folder}` and `{CompanyName}`):
```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --print-to-pdf="/Users/riahabharora/Sites/marketing-customgpt-demo-creator/examples/{folder}/{CompanyName} x CustomGPT.pdf" "/Users/riahabharora/Sites/marketing-customgpt-demo-creator/examples/{folder}/one-pager.html"
```

Critical: `@page { margin: 0; }` must be in the CSS — any other margin value causes Chrome to print the file path as a header in the PDF.

---

## Step 8 — Save Gmail Draft

Use `mcp__claude_ai_Gmail__create_draft`:
- `to`: lead's email
- `subject`: as defined in the template (5 words max)
- `body`: full email text from email.md (plain text, contentType: text/plain)

Do NOT attach the PDF — Rishabh attaches it manually before sending.

---

## Step 9 — Confirm to Rishabh

Say:
> Draft saved in Gmail — ready to send to [First Name] <email>. Attach the PDF before hitting send: `examples/{folder}/{CompanyName} x CustomGPT.pdf`

Then say: "Ready for the next lead."

---

## Step 10 — After Rishabh confirms it was sent

1. Move `examples/{company-name}/` → `examples/done/{company-name}/`
2. Create `examples/done/{company-name}/email-sent.md` with date sent + any notes
3. For **failure/partial only:** confirm `demo_creator_link` HubSpot property is set to `[MANUAL_DEMO_LINK]` before HubSpot enrollment — T2/T3 use this token. Prompt: "Before enrolling: make sure `demo_creator_link` is set to [MANUAL_DEMO_LINK] for this contact."
4. Remind Rishabh to enroll in HubSpot sequence: **"Demo Creator — Follow-up (T2 + LinkedIn + T3)"**

---

## Track Reference

| Track | Condition | Template |
|-------|-----------|----------|
| Success | Pages ≥ 15, demo link works | `emails/t1-success.md` |
| Failure | Bot errored, no demo link | `emails/t1-failure.md` |
| Partial | Pages < 15 (demo weak) | `emails/t1-failure.md` — manual rebuild needed first |

---

## What Not To Do

- Never include a Stripe link — these leads have never seen the payment page
- Never use the cart abandon Calendly UTM (`utm_campaign=abandoned_cart`) — always use `utm_campaign=demo_creator`
- Never generate files before Rishabh confirms use cases in Step 4
- Never enroll in HubSpot sequence before T1 is confirmed sent
- Never commit PII to git (names, emails)
- Never create `email-tone-a.md` / `email-tone-b.md` — one email per contact

---

## GitHub Push Reminder (when user pushes)

Before any `git push`, scrub `email.md`:
- Replace email addresses with `[REDACTED]`
- Remove last names
- Keep: first names, company names, one-pager HTML/PDF, workflow docs
