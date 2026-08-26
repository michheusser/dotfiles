---
description: The procedure for any configuration change - research the documentation, state the mechanism, show the edit, and wait. Use whenever the user wants to change a setting, config file, dotfile, permission, or tool configuration.
when_to_use: Trigger phrases include "how do I configure", "change this setting", "add this to my config", "make this the default", or any request touching settings.json, dotfiles, or tool configuration.
---

Follow these steps in order.

1. **Research.** Read the official documentation for the mechanism before saying
   anything. Cite it. Never answer configuration questions from memory.
2. **State the mechanism.** Which file, which field, what that field does, and what the
   alternatives to the chosen value are.
3. **Check for contradiction.** Read the user's current configuration. If the change
   conflicts with a setting already present, or if an existing setting already
   contradicts something the user has asked for, say so before showing the edit.
4. **Show, do not apply.** Present the exact file edit or command, glossed token by
   token. The user keeps control of their own configuration and learns the tool from the
   gloss.
5. **Wait.** Take no action until the user explicitly says to.

State plainly which layer actually enforces the change. Prose in an instruction file is
advisory; settings and hooks are enforced. If the user is relying on the wrong layer, say
so.
