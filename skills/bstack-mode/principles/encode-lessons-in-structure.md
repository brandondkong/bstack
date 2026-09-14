# Encode Lessons in Structure

**Applies when** you catch yourself writing the same instruction a second time, or notice a recurring correction.

Encode recurring fixes in mechanisms (scripts, lint rules, types, checks, metadata) instead of more text.

**Why:** text instructions need the reader to notice, remember, and comply. A mechanism enforces the rule without cooperation.

When an instruction repeats:
1. Ask whether it can be a lint rule, type, runtime check, script, or eval case.
2. If yes, encode it and delete the instruction.
3. If no, because it needs judgment, make the instruction more prominent and add an example of the failure.

**Pick the strongest mechanism available:** a state that cannot compile, then a lint or check that fails CI, then a shared helper, then a runtime check. Agents copy whatever the surrounding code does, so a weak guard becomes the next template.

**Close the loop.** When the human corrects you or a check fails, decide whether it is a one-off or a pattern. One-off: note it in memory. Recurring: a skill edit, script, or eval case (`/reflect` routes these). Don't acknowledge without recording, and don't record without applying.
