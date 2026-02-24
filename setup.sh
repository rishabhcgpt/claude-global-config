#!/bin/bash

# Claude Code Global Setup Script
# Run this on any new machine to replicate full Claude Code config
# Usage: bash setup.sh

set -e

echo "Setting up Claude Code global config..."
echo ""

# ── 1. Copy global Claude files ───────────────────────────────────────────────
echo "[1/3] Installing CLAUDE.md, agents, hooks..."

mkdir -p ~/.claude/agents ~/.claude/hooks

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp "$SCRIPT_DIR/.claude/CLAUDE.md"            ~/.claude/CLAUDE.md
cp "$SCRIPT_DIR/.claude/agents/critic.md"     ~/.claude/agents/critic.md
cp "$SCRIPT_DIR/.claude/hooks/critic-gate.sh" ~/.claude/hooks/critic-gate.sh
chmod +x ~/.claude/hooks/critic-gate.sh

echo "    ✓ CLAUDE.md, critic agent, and stop hook installed"

# ── 2. Add MCP servers ────────────────────────────────────────────────────────
echo ""
echo "[2/3] Adding MCP servers..."

# Memory MCP
claude mcp add --scope user memory npx -y @modelcontextprotocol/server-memory 2>/dev/null \
  && echo "    ✓ memory MCP added" \
  || echo "    ~ memory MCP already exists, skipping"

# HubSpot — connected via claude.ai account connector, no local setup needed
echo "    ✓ HubSpot: connected via claude.ai account (works on all machines automatically)"

# Gmail MCP
GMAIL_CREDS="$HOME/gmail-credentials.json"
if [ -f "$GMAIL_CREDS" ]; then
  claude mcp add --scope user gmail \
    --env GMAIL_CREDENTIALS_PATH="$GMAIL_CREDS" \
    npx -y @modelcontextprotocol/server-gmail 2>/dev/null \
    && echo "    ✓ Gmail MCP added (credentials found at $GMAIL_CREDS)" \
    || echo "    ~ Gmail MCP already exists, skipping"
else
  echo "    ⚠  Gmail MCP skipped — credentials not found at $GMAIL_CREDS"
  echo "       Copy gmail-credentials.json from your other machine, then re-run:"
  echo "       claude mcp add --scope user gmail --env GMAIL_CREDENTIALS_PATH=\"\$HOME/gmail-credentials.json\" npx -y @modelcontextprotocol/server-gmail"
fi

# ── 3. Done ───────────────────────────────────────────────────────────────────
echo ""
echo "[3/3] Done."
echo ""
echo "    Account-level connectors (HubSpot, CustomGPT, Granola) work automatically"
echo "    on every machine — no setup needed."
echo ""
echo "    Gmail MCP requires ~/gmail-credentials.json on each machine."
echo "    See README.md → 'Gmail Setup' for transfer instructions."
echo ""
echo "    To authenticate pending connectors (Slack, BigQuery, Atlassian etc):"
echo "    1. Open a terminal → run: claude"
echo "    2. Type: /mcp → select connector → complete browser login"
echo ""
echo "Setup complete."
