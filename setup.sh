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

# HubSpot MCP (OAuth)
echo ""
echo "    HubSpot MCP requires your Client Secret."
echo "    Client ID: a3ae8e2e-5062-41ed-9811-95e8ec3bcf48"
echo ""
read -s -p "    Paste HubSpot Client Secret and press Enter: " HS_SECRET
echo ""

MCP_CLIENT_SECRET="$HS_SECRET" claude mcp add --transport http --scope user \
  --client-id a3ae8e2e-5062-41ed-9811-95e8ec3bcf48 \
  --client-secret \
  --callback-port 8080 \
  hubspot https://mcp.hubspot.com/anthropic 2>/dev/null \
  && echo "    ✓ HubSpot MCP added" \
  || echo "    ~ HubSpot MCP already exists, skipping"

# ── 3. Authenticate HubSpot ───────────────────────────────────────────────────
echo ""
echo "[3/3] Almost done."
echo ""
echo "    One manual step remaining:"
echo "    1. Open a new terminal"
echo "    2. Run: claude"
echo "    3. Type: /mcp"
echo "    4. Select 'hubspot' → complete browser login"
echo ""
echo "Setup complete. HubSpot will be active in all Claude Code sessions after browser auth."
