# Battlecard Outreach — Deployment Funnel

You are running the CustomGPT proactive deployment outreach workflow. A trial user has been identified as stuck — they built an agent, tested it, but never deployed. Your job is to turn the battlecard into a personalised Gmail draft that gets them to reply or book a call.

Execute all steps autonomously without waiting for confirmation between steps (except the confirm in Step 2).

---

## Input

The user will paste a battlecard from Slack. Extract the following fields:

| Field | What to look for |
|-------|-----------------|
| `email` | The email address at the top |
| `priority` | URGENT / HIGH / MEDIUM |
| `days_left` | Number after the hourglass emoji |
| `agent_name` | Text after the robot emoji |
| `pages_ok` | Number before "ok" in the Pages line |
| `pages_failed` | Number before "failed" in the Pages line |
| `query_count` | Number in the Queries line |
| `sorry_rate` | Percentage in the Sorry Rate line |
| `root_cause` | Full text of the Root Cause section |

---

## Step 1 — Research (run in parallel)

Simultaneously:
- Search HubSpot for the contact (`mcp__claude_ai_HubSpot__search_crm_objects`, objectType: contacts, query: `email`) — get: firstname, lastname, company, jobtitle

---

## Step 2 — Confirm (one message, fast)

Show the user a single confirmation block:

```
Name:     [firstname lastname]
Email:    [email]
Company:  [company]
Role:     [jobtitle]

Agent:    [agent_name]
Queries:  [query_count] | Sorry rate: [sorry_rate]% | [days_left] days left
Variant:  HEALTHY (ship it) OR BROKEN (fix it)
```

**Variant logic:**
- `sorry_rate ≤ 20%` → **HEALTHY** — agent works, just needs deployment push
- `sorry_rate > 20%` → **BROKEN** — agent has quality issues, call is a fix session

Ask: "Good to go?"

Wait for confirmation before proceeding.

---

## Step 3 — Write the Email

Apply all three frameworks simultaneously:

**30MPC:** Open with a specific, data-backed observation about *them* (use their actual numbers — queries, sorry rate). One ask. 5–7 sentences total. Give them an easy reply option alongside the Calendly link.

**Hormozi:** Lead with the result they already have. Name what they're leaving on the table. Make the next step feel inevitable — not salesy.

**Gestalt:** One idea per sentence. Short paragraphs. CTA stands alone on its own line. No filler words, no pleasantries.

---

### HEALTHY Variant (sorry_rate ≤ 20%)

Tone: They built something genuinely good. The only step left is shipping it. Frame the call as getting it live — not as a sales conversation.

**Structure:**
```
Hi [First Name],

[Agent name] has [query_count] queries with a [sorry_rate]% sorry rate — [one sentence on what that signals: real user engagement, advisors will use it, it's actually working, etc. Pull from root_cause for specifics].

[One sentence on the gap: what they're missing by not deploying. Be concrete — reference the use case from root_cause if it helps. Don't be vague.]

[Only include this line if days_left ≤ 3: "Trial ends in [days_left] days — "] Worth 15 minutes this week to get it live?
[Calendly link]

Or just reply yes and I'll send a time.

Best,
Rishabh
```

**Subject line options (pick the sharpest one, ≤ 5 words):**
- "Let's get it live" (4 words)
- "Ready to go live?" (4 words)
- "[Agent name] is ready" — only if agent name is 1–2 words, otherwise skip

---

### BROKEN Variant (sorry_rate > 20%)

Tone: They tried, hit a wall, probably gave up. You found the issue and it's fixable. Frame the call as a quick fix — not a sales call. They need to believe this is solvable before they'll engage.

Reference `pages_failed` if it's more than 15% of total pages — failed indexing is often the culprit.

**Structure:**
```
Hi [First Name],

[Agent name] has [query_count] queries but a [sorry_rate]% sorry rate — [one-sentence diagnosis drawn from root_cause: content gap, failed page indexing, persona/config issue, etc.].

[One sentence on what fixing looks like: specific, quick, doable in one call. Make it feel like a small lift.]

[Only include this line if days_left ≤ 3: "Trial ends in [days_left] days — "] Worth 15 minutes to go through it together?
[Calendly link]

Or just reply yes and I'll send a time.

Best,
Rishabh
```

**Subject line options (pick the sharpest one, ≤ 5 words):**
- "Found the issue" (3 words)
- "Quick fix, then ship" (4 words)
- "Let's fix this" (3 words)

---

### Rules (non-negotiable)

- Subject line: **5 words maximum** — no exceptions, ever
- No bold, no bullet points, no headers in email body
- Sign-off: `Best,\nRishabh` — no full name, no "Warm regards", nothing else
- Calendly link on its own line, plain text:
  `https://calendly.com/d/cssp-nwq-6hf/ai-expert-consultation/?utm_source=battlecard&utm_medium=email&utm_campaign=deployment_outreach`
- "Or just reply yes and I'll send a time." on its own line, directly after Calendly
- Do NOT manufacture urgency — only mention trial expiry if `days_left ≤ 3`
- Do NOT use the outreach script from the battlecard verbatim — write fresh using the frameworks
- Do NOT add a P.S., no extra CTAs, no attachments mentioned

---

## Step 4 — Save Gmail Draft

Use `mcp__claude_ai_Gmail__create_draft`:
- `to`: contact's email
- `subject`: subject line from Step 3
- `body`: full email body, plain text

If that tool is unavailable, use `mcp__gmail__draft_email` instead.

---

## Step 5 — Confirm to User

Say:
> Draft saved in Gmail — ready to send to [Name] <email>.

Then say: "Ready for the next battlecard."
