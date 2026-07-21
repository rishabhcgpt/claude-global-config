#!/bin/bash

# Critic Gate Stop Hook
# Intercepts Claude before finishing and requires critic review
# when substantive work (file edits/writes/analysis) was done in the session.

set -euo pipefail

HOOK_INPUT=$(cat)

# Get transcript path
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)

# If no transcript, let it pass
if [[ -z "$TRANSCRIPT_PATH" ]] || [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  exit 0
fi

# Check if session involved substantive tool use (Write, Edit, NotebookEdit, analysis)
# Uses -R + fromjson? so one malformed/truncated line is skipped instead of aborting
# the whole parse and hiding everything after it.
SUBSTANTIVE=$(jq -R -r 'fromjson? | select(.message.content != null) | .message.content[]? | select(.type=="tool_use") | .name' "$TRANSCRIPT_PATH" 2>/dev/null | grep -c -E '^(Write|Edit|NotebookEdit)$' || true)

# If no file writes/edits happened, this is a conversational session — let it pass
if [[ "${SUBSTANTIVE:-0}" -eq 0 ]]; then
  exit 0
fi

# Check if critic was already invoked directly by this session
CRITIC_RAN=$(jq -R -r 'fromjson? | select(.message.content != null) | .message.content[]? | select(.type=="tool_use" and .name=="Agent") | .input.subagent_type // empty' "$TRANSCRIPT_PATH" 2>/dev/null | grep -c '^critic$' || true)

if [[ "${CRITIC_RAN:-0}" -gt 0 ]]; then
  # Critic already ran — allow stop
  exit 0
fi

# Also check for critic invoked from within a forked sub-agent: each subagent
# invocation (including forks) gets its own agent-<id>.meta.json with an
# agentType field in a sibling "subagents" dir next to the transcript.
SUBAGENTS_DIR="${TRANSCRIPT_PATH%.jsonl}/subagents"
if [[ -d "$SUBAGENTS_DIR" ]]; then
  NESTED_CRITIC=$(grep -l '"agentType":"critic"' "$SUBAGENTS_DIR"/*.meta.json 2>/dev/null | wc -l | tr -d ' ' || true)
  if [[ "${NESTED_CRITIC:-0}" -gt 0 ]]; then
    exit 0
  fi
fi

# Substantive work was done but critic hasn't run — block and remind
jq -n '{
  "decision": "block",
  "reason": "You produced substantive work (file writes/edits detected) but the critic agent has not run yet. Invoke the critic agent to verify your work before finishing. The critic should challenge your claims, check for gaps, and confirm evidence backs your conclusions. After critic runs, you may complete.",
  "systemMessage": "🔍 Critic Gate: Substantive work detected. Run the critic agent before completing."
}' || true
