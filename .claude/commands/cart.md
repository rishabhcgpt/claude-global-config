# Abandon Cart Lead — Full Automated Flow

You are running the CustomGPT abandon cart recovery workflow. Execute all steps below autonomously without waiting for confirmation between steps (except the data confirm in Step 2).

---

## Repo Location
`/Users/riahabharora/Desktop/shreegansh om kaali/hot-vs-cold-abandon-carts/`

All campaign files go in: `examples/{company-slug-firstname}/`
Done campaigns go in: `examples/done/{company-slug-firstname}/`

---

## Input
The user will provide:
1. The lead's email address
2. (Optional, no longer required) A Stripe resume link — as of 2026-07-20 the email CTA no longer uses a Stripe link at all, so this is not needed. If one is pasted anyway, ignore it for the email body.

---

## Step 1 — Research (run in parallel)

Extract the email from the input. Then simultaneously:
- Search HubSpot for the contact (`mcp__claude_ai_HubSpot__search_crm_objects`, objectType: contacts, query: email) — get: firstname, lastname, email, company, jobtitle, hs_linkedin_url, website
- Search the web (`mcp__perplexity__perplexity_search`) for the company name + "what do they do"
- Fetch the company website (`WebFetch`) for business details: what they do, target customers, pain points

---

## Step 2 — Confirm Data (one message, 30 seconds)

Show the user:
- Name, email, role, company, LinkedIn
- 2-sentence company summary
- 6 proposed one-pager bullet points

Ask: "Good to go, or any changes?"

Wait for confirmation before proceeding.

---

## Step 3 — Create Campaign Folder + Files

Create folder: `examples/{company-slug-firstname}/`

### email.md

Use this EXACT template — no variations:

```
# Email — [Name] / [Company]

**Subject:** Made this for [Company]

---

Hi [First Name], saw you started a CustomGPT account but didn't finish.

I'd love to get a quick sense of what [Company] is looking to do with AI — here's a 15 min slot if you're up for it: https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation?utm_source=abandoned_cart&utm_medium=email&utm_campaign=recovery_v2&utm_content=day1_15min

After that, I'll get you set up on a free trial, no card required.

I made a one-pager showing how [Company] could use CustomGPT, 30s to read (attached).

Best,
Rishabh
```

**Rules (non-negotiable):**
- Subject: "Made this for [Company]" — always this format
- Opener: one line — "Hi [First Name], saw you started a CustomGPT account but didn't finish." — comma after first name, no em dash, no "real person here" line, no "This is where I come in!", no "Here's how I can help-" (all removed 2026-07-28)
- No pain line
- One-pager line uses "CustomGPT" not "it" — sits last, right before the sign-off (moved 2026-07-28)
- **Funnel goal changed 2026-07-28: the call is now the primary ask (to understand the lead's AI vision), and the free trial is framed as the post-call next step — NOT a self-serve reply-to-get-a-trial offer anymore.**
- CTA line: `"I'd love to get a quick sense of what [Company] is looking to do with AI — here's a 15 min slot if you're up for it: [CALENDLY_LINK]"` — this is the segue + the one clickable ask, replacing the old "Get you on an extended 14 day free trial, just reply..." line entirely
- Calendly link is plain text inline in the CTA line — NOT hyperlinked (Rishabh hyperlinks manually in Gmail); always use the `recovery_v2`/`day1_15min` UTM, never the old `website`/`remarketing` UTM
- Post-call line: `"After that, I'll get you set up on a free trial, no card required."` — states the trial as the payoff of the call, not an independent offer. This is a benefit statement, not a second CTA.
- No P.S. Stripe reassurance line — removed 2026-07-20 since there's no longer a Stripe link/card flow in the email to reassure about
- Sign-off: "Best,\nRishabh" only
- No bold, no bullets, no extra CTAs

### one-pager.html

Rules:
- Exactly 1 page
- `@page { margin: 0.35in; size: letter; }`
- `body { width: 750px; padding: 18px 32px; font-size: 11.5px; }`
- Header: left (h1 in purple + subtitle) | right (📅 Book a 15-Min Call button + "with Rishabh @ CustomGPT")
- Book button href: `https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation?utm_source=abandoned_cart&utm_medium=email&utm_campaign=recovery_v2&utm_content=day1_15min`
- 6 bullets (border-left purple, → prefix, one sentence each, human-sounding)
- CTA box at bottom: 3 bullet points only (extended trial, 15-min call, no credit card needed) — NO button in CTA box
- No raw URLs visible, no Stripe link in PDF
- Footer: "CustomGPT.ai · Prepared for [First Name] @ [Company]"

CSS for bullets:
```css
.bullets li { padding: 8px 12px 8px 38px; position: relative; border-left: 3px solid #6366f1; margin-bottom: 7px; background: #fafafa; border-radius: 0 6px 6px 0; font-size: 11.5px; color: #1f2937; line-height: 1.4; }
.bullets li::before { content: "→"; position: absolute; left: 12px; color: #6366f1; font-weight: 700; }
```

### prospect-data.md

Include: name, email, role, company, website, LinkedIn, company research summary, use cases used, campaign status (Touch 1 sent today, rest pending).

---

## Step 4 — Generate PDF

Run this exact command (update folder and company name):
```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --print-to-pdf="/Users/riahabharora/Desktop/shreegansh om kaali/hot-vs-cold-abandon-carts/examples/{folder}/{Company} x CustomGPT.pdf" "/Users/riahabharora/Desktop/shreegansh om kaali/hot-vs-cold-abandon-carts/examples/{folder}/one-pager.html"
```

---

## Step 5 — Save Gmail Draft

Use `mcp__claude_ai_Gmail__gmail_create_draft`:
- `to`: lead's email
- `subject`: "Made this for [Company]"
- `body`: full email text (plain text, contentType: text/plain) — no Stripe link embedded
- Note: Calendly link in body is plain text — Rishabh hyperlinks it manually in Gmail

---

## Step 6 — Confirm to User

Say:
> Draft saved in Gmail — ready to send to [Name] <email>. Attach the PDF before hitting send.

Then say: "Ready for the next lead."

---

## GitHub Push Reminder (when user pushes)

Before any `git push`, scrub `email.md` and `prospect-data.md`:
- Replace email addresses with `[REDACTED]`
- Remove last names
- Keep: first names, company names, one-pager HTML/PDF, workflow docs

(No Stripe links exist in the funnel anymore — removed 2026-07-20 — so there's nothing Stripe-related left to scrub.)
