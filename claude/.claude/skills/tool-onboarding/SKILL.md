---
description: Explains a command, CLI, or configuration file by glossing every token and then stating the tool's minimal mental model. Use when the user asks what a command does, what a flag means, how to use an unfamiliar tool, or what a config field controls.
when_to_use: Trigger phrases include "what does this command do", "explain this flag", "what is this config doing", "how do I use", "gloss this", or when the user pastes a command or config file and asks about it.
argument-hint: [command or config to explain]
---

The subject is: $ARGUMENTS

If that is empty, use the command, config, or tool from the surrounding conversation.

Produce two parts, in this order, and nothing else.

**1. The gloss.** Every token, in order: the command, each flag, each argument, each
pipe stage. One clause each. No prose interpretation of what the command is *for* — the
user reads intent themselves.

**2. The minimal mental model.** The single governing idea of the tool, stated as the one
question the user can ask themselves to derive its behavior in other cases. If no
unifying principle exists, say so and give the irreducible cases.

Do not add examples, alternatives, caveats, or history. If the user wants those they will
ask.
