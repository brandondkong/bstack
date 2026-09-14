### Visual parity

**You own pixel-exact equivalence. The baseline is the spec. You do not touch it.** Equivalence is verified by image diff, not by eye.

1. Establish the baseline before any migration. A scripted harness that launches the app (the `run` skill) and screenshots the current component across its states, plus the target when matching two implementations. Pin viewport, fonts, and any animated or time-dependent state so two runs produce identical images. No baseline, no parity claim. A blocking prerequisite, not a follow-up.
2. Anti-shortcut clauses, stated and held. No harness modifications, no baseline tampering, no component restructuring to make a diff pass. If the baseline looks wrong, stop and ask with `AskUserQuestion`. Don't edit it.
3. Migrate one component at a time. Parallelize with one `bstack-agent` per component, each with `isolation: "worktree"`, launched in one message. Shared primitives migrate first as a blocking phase.
4. Verify each component against its baseline. Rerun the harness on the migrated component, then pixel-diff each image against its baseline with a script that prints the changed-pixel count (ImageMagick `compare -metric AE` when installed, otherwise a short script over decoded pixels). Keep the diff script in the harness. Any count above zero is a fail. Investigate the pixel delta, fix, and repeat until zero. Unattended, drive the repeat with the `loop` skill.
5. Run **Opening a PR** (`playbooks/opening-a-pr.md`) per component or per safe batch.

**Reply:** components migrated, the diff result for each, the baseline harness location, and what is left.
