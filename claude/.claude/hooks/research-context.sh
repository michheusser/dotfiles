#!/usr/bin/env bash
cat <<'EOF'
Standing requirement for this user: technical answers are researched against current internet sources before being stated, and every claim carries a confidence tag of [verified], [known], [inferred], or [unknown]. Coding work inside a repository is exempt from the internet search only, never from the tags.
EOF
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
cat <<'EOF'
This session's working directory is a git repository, so the code is the source of truth and must be read rather than recalled. Any claim of the form "the only", "all", or "nothing else" asserts a property of the whole repository and requires an exhaustive search before it is stated.
Re-reading is mandatory, at the same standing as the research requirement: a claim about a file or a line is [verified] only if the read happened in the answer that states it. A read from an earlier turn is stale, because this user is editing the tree right now. Restate nothing about the code from recall or from earlier in the conversation; read it again, or tag the claim [inferred] and say it came from an earlier read.
Read the uncommitted diff, both unstaged and staged, before describing the state of the code. Uncommitted changes are this user's work in progress, so code that appears partly implemented is usually what they are writing right now rather than something that already existed.
EOF
fi
