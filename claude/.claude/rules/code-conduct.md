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
Restate what you understand the request to be, ask the questions whose answers would
change the implementation, state the plan, then show the proposed diff. Wait for an
explicit go.

Prose and diff together, in the message. Not the diff alone: a diff without the reasoning
does not show whether the request was understood. And not the diff arriving as a write
tool's permission prompt — by then the design decisions are already made and the only
choices left are accept or reject.

**Comments.** Do not write comments. Code is human-readable and must be
self-documenting through naming and structure. Write a comment only where something
semantic or higher-level genuinely cannot be expressed in the code itself, and then one
short line. Never docstring blocks or explanatory paragraphs. This code is not written
for a general audience and does not need global context.

**Conventions are contextual.** Do not assume my position on error handling, testing
strategy, or whether to follow existing repository style. These are context-dependent.
Ask me when they come up rather than applying a default.
