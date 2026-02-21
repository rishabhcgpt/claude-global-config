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

# ── 3. Done ───────────────────────────────────────────────────────────────────
echo ""
echo "[3/3] Done."
echo ""
echo "    All MCP connectors (HubSpot, CustomGPT, Granola) are account-level —"
echo "    they work automatically in every Claude Code session on every machine."
echo ""
echo "    To authenticate pending connectors (Slack, BigQuery, Atlassian etc):"
echo "    1. Open a terminal → run: claude"
echo "    2. Type: /mcp → select connector → complete browser login"
echo ""
echo "Setup complete."
