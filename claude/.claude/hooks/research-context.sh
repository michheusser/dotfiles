#!/usr/bin/env bash
cat <<'EOF'
Standing requirement for this user: technical answers are researched against current internet sources before being stated, and every claim carries a confidence tag of [verified], [known], [inferred], or [unknown]. Coding work inside a repository is exempt from the internet search only, never from the tags.
EOF
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
cat <<'EOF'
This session's working directory is a git repository, so the code is the source of truth and must be read rather than recalled. Any claim of the form "the only", "all", or "nothing else" asserts a property of the whole repository and requires an exhaustive search before it is stated.
EOF
fi
