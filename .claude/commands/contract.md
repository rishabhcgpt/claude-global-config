# CustomGPT Contract Drafter

Generate a completed CustomGPT Service Order (.docx) from a guided Q&A.

## Repo location
`/Users/riahabharora/customgpt-contract-drafter/`

## How it works
1. Ask the intake questions in 3 batches (see below)
2. Validate inputs (net = list − discount, totals add up, required fields present)
3. Run `node generate_contract.js '<JSON>'` from the repo directory
4. Output lands in `./outputs/CustomerName_Service_Order_YYYY-MM-DD.docx`

If the user provides info upfront, only ask for what's missing.

---

## Batch 1 — Customer & deal basics
- Customer legal entity name
- Customer billing address
- Customer signer name + title
- Edition: Premium or Enterprise
- Service Term (e.g. "1 Year", "2 Years")
- Service Start Date (calculate end date, ask user to confirm)
- Order Date (default: today)

## Batch 2 — Allocations
- Queries per month
- Words synced per month
- Documents synced per month
- Agents (number or "Unlimited")
- Seats (number or "Unlimited")

## Batch 3 — Pricing & billing
For each line item (Platform Subscription, Usage Credits, Professional Services):
- Include this line? If yes → list price + discount amount + discount reason

Then:
- Payment cadence: Annual / Quarterly / Monthly (default: Annual)
- PO Required? (Yes + PO number, or No)
- Billing contact email or vendor portal URL
- Any additional legal terms? (default: "None")

---

## Defaults & smart behavior
- Order Date defaults to today if not provided
- Calculate net price per line: `net = list − discount`
- Calculate discount %: `pct = round((discount / list) × 100, 1)`
- Calculate Total Contract Value = sum of all included line item nets
- Premium edition → Standard Support block
- Enterprise edition → Enterprise Support block (3 subsections)

## Generating the file
```bash
cd /Users/riahabharora/customgpt-contract-drafter
node generate_contract.js '<JSON_INPUT>'
```

## After delivery
1. Tell user the file is ready and where it was saved
2. Remind them to review before exporting to PDF
3. Remind them to attach signed PDF to the HubSpot deal record
4. Upload the .docx to Google Drive folder: https://drive.google.com/drive/folders/1OG062poPye8ALgZRo_ST6Ty-yGmyVdIy
