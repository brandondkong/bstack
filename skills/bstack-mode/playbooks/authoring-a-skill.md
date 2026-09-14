### Authoring or modifying a skill

**You own the skill's voice.** Applies to any SKILL.md, playbook, principle, agent, or reference prompt, in bstack or elsewhere.

1. Check whether an existing skill is the real home before adding a new one. Prefer an edit.
2. Write it. Keep only prose that changes a decision. Tell the agent to do the thing and skip the reason unless the rule is confusing without one. Point at sources by path instead of restating them. Frontmatter: `name`, a `description` that front-loads the words a user would type, and `disable-model-invocation: true` for skills only the user should start.
3. Validate: run `bstack-check <plugin-root>`. It checks frontmatter, relative links, and the router index, then runs `claude plugin validate`.
4. Test behavior. For a structural rule (a file gets read, a tool is or isn't called, a file is written), add or update a case under `evals/` and run `claude plugin eval . --case <name> --no-publish`. For a subjective change to how agents work, run the **Eval** playbook (`playbooks/eval.md`) before promoting it.
5. Commit the skill change on its own, never tangled with feature work. Then run **Opening a PR** (`playbooks/opening-a-pr.md`) if the repo has a remote.

If a skill misbehaves in the middle of another task, don't edit it there. Add a line to bstack's `BACKLOG.md` and keep the task moving.

**Reply:** summary of the skill, key design decisions, and validation and eval results.
