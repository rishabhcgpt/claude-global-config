#!/bin/bash

# Critic Gate Stop Hook
# Intercepts Claude before finishing and requires critic review
# when substantive work (file edits/writes/analysis) was done in the session.

set -euo pipefail

HOOK_INPUT=$(cat)

# Get transcript path
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

# If no transcript, let it pass
if [[ -z "$TRANSCRIPT_PATH" ]] || [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  exit 0
fi

# Check if session involved substantive tool use (Write, Edit, NotebookEdit, analysis)
SUBSTANTIVE=$(grep -E '"tool_name"\s*:\s*"(Write|Edit|NotebookEdit)"' "$TRANSCRIPT_PATH" 2>/dev/null | wc -l | tr -d ' ')

# If no file writes/edits happened, this is a conversational session — let it pass
if [[ "$SUBSTANTIVE" -eq 0 ]]; then
  exit 0
fi

# Check if critic was already invoked in this session
CRITIC_RAN=$(grep -i '"name"\s*:\s*"critic"' "$TRANSCRIPT_PATH" 2>/dev/null | wc -l | tr -d ' ')

if [[ "$CRITIC_RAN" -gt 0 ]]; then
  # Critic already ran — allow stop
  exit 0
fi

# Substantive work was done but critic hasn't run — block and remind
jq -n '{
  "decision": "block",
  "reason": "You produced substantive work (file writes/edits detected) but the critic agent has not run yet. Invoke the critic agent to verify your work before finishing. The critic should challenge your claims, check for gaps, and confirm evidence backs your conclusions. After critic runs, you may complete.",
  "systemMessage": "🔍 Critic Gate: Substantive work detected. Run the critic agent before completing."
}'
