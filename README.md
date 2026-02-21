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
- HubSpot MCP via OAuth (prompts for client secret)

Then do the one-time browser auth:
1. Open a terminal → run `claude`
2. Type `/mcp` → select **hubspot** → log in via browser

## Critic Gate (3 Layers)

1. **`CLAUDE.md`** — Claude reads this every session. Instructs it to invoke critic before marking any substantive work done.
2. **`hooks/critic-gate.sh`** — Stop hook that checks if files were written/edited. If yes and critic hasn't run: blocks Claude and forces critic review.
3. **`agents/critic.md`** — The critic agent itself, available globally in every folder.

## Source

Critic agent authored by [@adorosario](https://github.com/adorosario).
Pulled from `adorosario/instantly-freshdesk-campaign` upstream · 2026-02-19.
