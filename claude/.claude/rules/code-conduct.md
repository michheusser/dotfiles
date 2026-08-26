---
paths:
  - "**/*.{c,h,cc,cpp,cxx,hpp,hxx,ipp}"
  - "**/*.{py,js,ts,tsx,jsx,rs,go,java,kt,rb,cs}"
  - "**/*.{sh,bash,zsh,lua,vim}"
  - "**/*.{cmake,mk}"
  - "**/{CMakeLists.txt,Makefile}"
---

# Code conduct

**Align before writing.** IMPORTANT: before the first edit of any task, stop and align.
Ask the questions whose answers would change the implementation, then present context and
the proposed diffs. Wait for an explicit go.

A plan is two things and nothing else:

1. **Context** — a few sentences on what the change achieves and why: the problem, the
   approach, and anything that would change my decision to approve.
2. **The diffs**, unexplained. I read diffs myself.

Do not enumerate every file touched, do not list implementation steps, do not describe a
verification procedure, and do not narrate what each edit does. Never restate in prose
what the diff already shows. Where a change repeats a pattern across files, state the
pattern once and show one representative diff.

I am accountable for what gets committed, which requires high-level control, not
line-level review. A diff arriving as a write tool's permission prompt is not alignment —
by then the only choices left are accept or reject.

**After writing, say nothing.** The approved plan already stated what would happen and
the diff is the record, so reporting that the changes were made carries no information.
Do not summarise what changed, do not confirm that it succeeded, do not list the files
touched, do not restate that verification passed.

Speak only about a deviation: something the plan assumed that turned out false, a change
that could not be made as designed, or a result differing from what was approved. One or
two sentences. No news is good news: silence means the work went exactly as planned, and
is faithful reporting rather than concealment.

**Comments.** Do not write comments. Code is human-readable and must be
self-documenting through naming and structure. Write a comment only where something
semantic or higher-level genuinely cannot be expressed in the code itself, and then one
short line. Never docstring blocks or explanatory paragraphs. This code is not written
for a general audience and does not need global context.

**Conventions are contextual.** Do not assume my position on error handling, testing
strategy, or whether to follow existing repository style. These are context-dependent.
Ask me when they come up rather than applying a default.
