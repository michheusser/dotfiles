---
name: refactor-review
description: Review whether a change or refactor is correct by first deriving the properties that must hold, then searching for a violation of each. For "did I break anything", "check the refactor", "review these commits".
disable-model-invocation: true
argument-hint: [what changed]
---

The change under review is: $ARGUMENTS

If that is empty, take it from the surrounding conversation.

Deriving what correctness means for this change is your responsibility. Do not ask the
user which errors to look for, and do not delegate the derivation.

1. Before any agent runs, state the criteria: the properties that must hold for the
   answer to be yes. Derive them from what this change actually moved. Show the criteria
   and the queries, then proceed without waiting.

2. Turn each criterion into a query whose answer set is closed. "Is this correct" has no
   closed answer set and is not a query. "For each data member of this class, which
   statement writes it" has one entry per member and can be closed.

3. These criteria are standing for any transfer of code between units. Extend them for
   the change at hand; never replace them.
   - Every piece of state the moved code reads has a statement that writes it in the
     new unit.
   - Every write runs before the first read of that state. A write in an asynchronous
     callback runs after anything in a constructor or a load function.
   - Every consumer that moved has its producer either moved with it or still reachable
     from the new unit.
   - Every behaviour that depended on declaration order, destruction order or
     initialisation order in the old unit still holds in the new one.
   - Every symbol the old unit still names is defined, and every symbol the new unit
     names is defined.

4. Each delegation prompt carries its criterion, its closed query, the search space, and
   the evidence rules. A subagent inherits no output style, so restate the tag rules in
   the prompt itself.

5. Report per criterion: the query, the space searched, the verdict. A criterion whose
   space was not fully searched is reported as unsearched, never as clean. Do not relay a
   subagent's tag: either you read the code and can name file and line, or you attribute
   the claim to the agent and mark it unverified.
