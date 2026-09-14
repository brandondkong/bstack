### Opening a PR

Invoked at the end of the code-changing playbooks.

**Worktree.** Work off the default branch in a git worktree when the main checkout has unrelated changes. Parallel writers each get their own worktree.

**Commits.** Follow the user's git rules in CLAUDE.md for message style. Commit liberally, then shape the branch into small, ordered commits that each stand on their own. Stage files by name, never `git add -A` in a dirty tree. Amend when a fix belongs in the commit just made.

**Before review.** Read the whole diff yourself. Strip comments that narrate what the code does. For a risky diff, run `/code-review`.

**Push and open.** Pushing and opening a PR are outward-facing. Do them when the user asked for a PR in this conversation. Otherwise stop at local commits and say the branch is ready. Use `gh`. Open ready, not draft. Check `gh pr view` before you describe PR status.

**Title.** Short and imperative, naming the real symbol or area that changed.

**Description.** A briefing for a reviewer who has the diff. Use these sections in order and drop any with nothing to say:

- `## Why` in one or two short paragraphs: intent and approach.
- `## Scope`: bullets of real symbols and paths. Name both sides of a rename.
- `## Tradeoffs`: only rejected alternatives a reviewer would ask about.
- `## Blast radius`: one to three sentences on what the change touches and why it is safe.
- `## Verification`: each real run and its outcome. For performance, one `before → after` number with its unit.

No SHAs, file-by-file checklists, or `## Summary` / `## Test plan` boilerplate.

**Stacks.** Prefer several narrow PRs to one large one. A child PR targets its parent branch (`gh pr create --base <parent>`).

**After opening.** Post the URL and keep going. Don't babysit CI unless asked.
