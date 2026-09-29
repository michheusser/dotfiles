#!/usr/bin/env bash
# SubagentStop gate. A subagent report must state what it searched and what it did not.
# Blocks at most once per agent_id, because SubagentStop carries no loop-guard field.
set -uo pipefail

input=$(cat)
agent_id=$(jq -r '.agent_id // "unknown"' <<<"$input")
message=$(jq -r '.last_assistant_message // ""' <<<"$input")

state_dir="${TMPDIR:-/tmp}/claude-subagent-gate"
mkdir -p "$state_dir"
find "$state_dir" -type f -mmin +720 -delete 2>/dev/null || true
marker="$state_dir/${agent_id//\//_}"

[[ -f "$marker" ]] && exit 0

if grep -qi 'Completeness:' <<<"$message" && grep -qi 'Not searched:' <<<"$message"; then
  exit 0
fi

: > "$marker"
jq -n '{
  decision: "block",
  reason: "Report rejected: no completeness statement. Append this block and fill it in before stopping.\n\nCompleteness:\n- Criteria: the properties that had to hold for the verdict to be yes\n- Query per criterion: the question asked, whose answer set is closed\n- Searched: the files and symbols actually read\n- Not searched: what was left unsearched, or none\n\nA verdict of clean is a claim about the whole search space. If the space was not searched, say so under Not searched instead of reporting clean. A claim taken from another agent is not verified by that report: either read it and name file and line, or attribute it and mark it unverified."
}'
