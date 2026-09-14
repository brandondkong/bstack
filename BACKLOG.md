# Backlog

Mechanisms worth building, and skills worth fixing later. `/reflect` files rows here. One line each.

- **Owner loop is duplicated** between `playbooks/autopilot-full.md` step 2 and `playbooks/autopilot-stack.md` step 1, about 150 words each. Kept separate deliberately, since the router reads one playbook file and a cross-file step 1 risks being skipped. Revisit if the two ever drift, and prefer a shared fragment only once drift actually happens.
- **`playbooks/orchestrate.md` is 1990 words**, five times the median playbook. It carries the brief template, ledger states, and drain points. Check whether a real orchestrate run reads all of it, and split the reference material out if not.
- **No eval case covers `/reflect`.** It needs a fixture transcript. Build one with `case.yaml` `context.history_file` and assert it produces the three lists and makes no edits before approval.
- **No eval case covers the path-scoped language skills.** Needs a `.py` or `.cpp` fixture in the workspace and a grader that the skill loaded.
- **`bstack-check` does not validate playbook or principle prose**, only links and frontmatter. A check for em dashes and for references to skills that do not exist would have caught porting errors mechanically instead of by review.
