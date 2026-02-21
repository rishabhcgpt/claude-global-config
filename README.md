# Claude Global Config

Global Claude Code configuration for Rishabh Arora — applies across every project and folder.

## What's Here

```
.claude/
├── CLAUDE.md              ← Standing instructions loaded into every session
├── agents/
│   └── critic.md          ← Critic agent (skeptical verifier, anti-sycophancy gate)
├── hooks/
│   └── critic-gate.sh     ← Stop hook: blocks Claude from finishing if critic hasn't run
└── settings.json          ← Registers the Stop hook globally
```

## How to Install (New Machine)

Run the setup script — it handles everything:

```bash
git clone https://github.com/rishabhcgpt/claude-global-config
cd claude-global-config
bash setup.sh
```

This installs:
- CLAUDE.md, critic agent, stop hook
- Memory MCP (global)

## MCP Connectors

MCP connectors are tied to the **Claude.ai account** (rishabh@customgpt.ai) — they work automatically across all devices and all Claude Code sessions. No per-machine setup required.

### Connected ✅

| Connector | How Connected | Notes |
|-----------|--------------|-------|
| **HubSpot** | claude.ai account | Contacts, companies, deals, carts — read + write. Connected 2026-02-21. |
| **CustomGPT.ai** | claude.ai account | All Sources project (ID: 1403). |
| **Granola** | claude.ai account | Meeting notes. |
| **Memory** | Local MCP (stdio) | `@modelcontextprotocol/server-memory` — installed via setup.sh |

### Needs Authentication ⚠️

These are configured on the account but haven't been authenticated yet:

| Connector | URL |
|-----------|-----|
| BigQuery | customgpt-bcp-fad19d6e4098.herokuapp.com |
| Slack | mcp.slack.com |
| Atlassian | mcp.atlassian.com |
| WordPress.com | public-api.wordpress.com |
| Ahrefs | api.ahrefs.com |
| ZoomInfo | mcp.zoominfo.com |

To authenticate any of these: open Claude Code → `/mcp` → select the connector → complete browser login.

### HubSpot Notes
- OAuth App ID: 31869333 — attempted setup on 2026-02-21 but abandoned (account lacks CMS scopes required by `mcp.hubspot.com/anthropic`)
- Connection works via the claude.ai HubSpot connector instead — no OAuth required
- Available scopes: contacts, companies, deals, tasks, calls, meetings, tickets, notes, line items

---

## Critic Gate (3 Layers)

1. **`CLAUDE.md`** — Claude reads this every session. Instructs it to invoke critic before marking any substantive work done.
2. **`hooks/critic-gate.sh`** — Stop hook that checks if files were written/edited. If yes and critic hasn't run: blocks Claude and forces critic review.
3. **`agents/critic.md`** — The critic agent itself, available globally in every folder.

## Source

Critic agent authored by [@adorosario](https://github.com/adorosario).
Pulled from `adorosario/instantly-freshdesk-campaign` upstream · 2026-02-19.
