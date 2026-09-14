# Backlog

Mechanisms worth building, and skills worth fixing later. `/reflect` files rows here. One line each.

- **Owner loop is duplicated** between `playbooks/autopilot-full.md` step 2 and `playbooks/autopilot-stack.md` step 1, about 150 words each. Kept separate deliberately, since the router reads one playbook file and a cross-file step 1 risks being skipped. Revisit if the two ever drift, and prefer a shared fragment only once drift actually happens.
- **`playbooks/orchestrate.md` is 1990 words**, five times the median playbook. It carries the brief template, ledger states, and drain points. Check whether a real orchestrate run reads all of it, and split the reference material out if not.
- **No eval case covers `/reflect`.** It needs a fixture transcript. Build one with `case.yaml` `context.history_file` and assert it produces the three lists and makes no edits before approval.
- **No eval case covers the path-scoped language skills.** Needs a `.py` or `.cpp` fixture in the workspace and a grader that the skill loaded.
- **`teach` may fold into `how`.** The porting agent's verdict: it is a thin layer over `how` plus `why` plus a prose style, and its distinctive parts (build the explanation one diagram at a time, keep `why`'s hedges intact) would fit in `how`'s explainer prompt. Kept for now. Settle it with the Eval playbook against a real "teach me this subsystem" task.
- **`technical-writing` may fold into `unslop`.** Same kind of verdict from a different agent: the trigger overlaps `unslop` almost entirely, and only the Diátaxis mode table and the Global English ambiguity rules carry signal the model does not already have. Kept for now, with the descriptions sharpened so the triggers separate. Settle it the same way.
- **`recall` overlaps `playbooks/session-pickup.md`** in its transcript-mining half. The part that earns its keep is the shared-record sweep and the tagged output. Watch whether both get used.
