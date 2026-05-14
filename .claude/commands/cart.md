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
2. Their Stripe resume link

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

Hi [First Name], this is not an automated message (real person here, I promise =) )
saw you started a CustomGPT account but didn't finish. This is where I come in!

I made a one-pager showing how [Company] could use CustomGPT, 30s to read (attached).

Here's how I can help:
Get on extended 14 day free trial here (I'll extend it to 2 weeks from the backend): [STRIPE_RESUME_LINK]

If it helps, I'm also happy to hop on a quick 15-min call as well, if you have queries or you'd like to set it up together: https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation/?utm_source=website&utm_medium=remarketing&utm_campaign=abandoned_cart&utm_content=recovery

P.S. (We use Stripe to filter spam signups, you can remove your card right after activating. Zero chance of accidental billing.)

Best,
Rishabh
```

**Rules (non-negotiable):**
- Subject: "Made this for [Company]" — always this format
- Opener: two lines exactly as shown — comma after first name, no em dash
- No pain line — go straight to one-pager line
- One-pager line uses "CustomGPT" not "it"
- ONE CTA: Stripe resume link, two lines ("Here's how I can help:" then the link line)
- Calendly link is plain text at end of the soft close line — NOT hyperlinked (Rishabh hyperlinks manually in Gmail)
- P.S. Stripe reassurance below soft close on its own line
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
- `body`: full email text with actual Stripe link embedded (plain text, contentType: text/plain)
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
- Replace Stripe resume links with `[REDACTED]`
- Remove last names
- Keep: first names, company names, one-pager HTML/PDF, workflow docs
