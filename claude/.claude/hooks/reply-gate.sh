#!/usr/bin/env bash
# Stop gate. Rejects a reply that breaks a mechanically checkable rule of precise.md.
# Blocks at most once per prompt_id, because Stop carries no loop-guard field.
set -uo pipefail

input=$(cat)
prompt_id=$(jq -r '.prompt_id // "unknown"' <<<"$input")
message=$(jq -r '.last_assistant_message // ""' <<<"$input")

state_dir="${TMPDIR:-/tmp}/claude-reply-gate"
mkdir -p "$state_dir"
find "$state_dir" -type f -mmin +720 -delete 2>/dev/null || true
marker="$state_dir/${prompt_id//\//_}"
[[ -f "$marker" ]] && exit 0

violations=()

grep -q '—' <<<"$message" \
  && violations+=("Rule 2: an em dash is present. Use a comma, a colon, parentheses or a separate sentence.")

tail_text=$(grep -v '^[[:space:]]*$' <<<"$message" | tail -2)
grep -qiE 'want me to|shall i |should i |let me know|do you want|would you like|i can also|next steps' <<<"$tail_text" \
  && violations+=("Rule 10: the reply ends with an offer of further work. Stop when the answer is complete.")

head_text=$(grep -v '^[[:space:]]*$' <<<"$message" | head -1)
grep -qiE "^(great|good) (question|point|catch)|^you'?re (right|correct)|^(sure|certainly|absolutely|of course)\b|^(let me|i'll) (look|check|start|take)" <<<"$head_text" \
  && violations+=("Rule 11: the reply opens with acknowledgement or narration. Lead with the answer.")

words=$(wc -w <<<"$message")
if (( words > 80 )) && ! grep -qE '\[(verified|known|inferred|unknown)\]' <<<"$message"; then
  violations+=("Rule 6: no confidence tag anywhere. Tag each technical claim [verified], [known], [inferred] or [unknown].")
fi

(( ${#violations[@]} == 0 )) && exit 0

: > "$marker"
printf '%s\n' "${violations[@]}" \
  | jq -Rsc '{decision:"block", reason:("Reply rejected before it reached the user. Rewrite it, then stop.\n\n" + .)}'
