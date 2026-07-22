# CustomGPT Persona Drafter

Build a client-specific persona for a CustomGPT AI agent from: a call transcript with the client, the CustomGPT persona playbook, and a reference persona that's already proven to work well.

## Repo location
`/Users/riahabharora/customgpt-persona-drafter/`

## Inputs needed (ask if not provided)
1. Call transcript/recording with the client (Granola link, Google Doc, or pasted text)
2. Reference persona — existing persona text already confirmed to give good results for a similar business
3. Client name, what they sell, and where the bot deploys (Shopify, website, YouTube, etc.)

Don't guess at missing inputs — ask for what's missing.

## How it works

1. **Extract requirements from the call.** List every explicit instruction the client gave — tone, response length rules, required behaviors, guardrails, things NOT to do. Quote specifics rather than paraphrasing (e.g. an exact rule like "one-breath rule," a required closing phrase, a hard character limit).
2. **Pull the matching CustomGPT playbook template(s)** from https://docs.customgpt.ai/docs/persona-playbook — pick whichever sub-page (Customer Support Agent, Sales Assistant, E-Commerce Digital Manager, Inside Sales Rep, etc.) is the closest structural fit.
3. **Mirror the reference persona's structure** — same section headers, same level of specificity (hard character limits stated flatly, required verbatim phrases, explicit fallback rules). The reference already works; match its shape, don't invent a new one.
4. **Draft the persona**, folding in every requirement extracted from the call.
5. **Run the `critic` agent on the draft before presenting it as final.** Check: every explicit call requirement captured, no internal contradictions, structural match to the reference, and no claim that something is "solved" when the call shows it was left undecided or was only one party's preference. This step is required (global Critic Gate rule) — don't skip it.
6. **Log the case** in `clients/{client-slug}/`:
   - `call-notes.md` — requirements extracted from the call, with quotes/timestamps
   - `reference-persona-used.md` — the proven persona this draft was modeled on
   - `persona-final.md` — the final persona text, ready to paste into CustomGPT
   - `open-items.md` — anything unresolved/unconfirmed, to raise on the next call
7. **Present the final persona** plus a short "what changed / what's still open" summary.

## Non-negotiables
- Never claim a requirement is implemented if the call shows it was left undecided — flag it as open instead.
- State hard constraints (char limits, required phrases) flatly, no hedge words, unless the client explicitly wants flexibility.
- Always run the critic pass before calling a draft final.

## Output location
`clients/{client-slug}/persona-final.md`
