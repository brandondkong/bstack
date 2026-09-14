---
name: architect
description: Architect or design this. Sketch types, signatures, and module shape before code, run two or more competing sketches, and implement the winner. For work where the first shape would lock in.
disable-model-invocation: true
---

# Architect

Design before implementing. Sketch types, signatures, class shapes, and module boundaries with `not implemented` bodies and pseudocode. Compare competing sketches, synthesize one, then fill in code against it. When implementation proves the sketch wrong, throw it out and redesign.

Open a todo list with one entry per phase: Ground, Sketch, Agree, Implement, Scrap.

## Phase A: Ground

Build a traced model of every system the new code touches. Map each subsystem with `Explore` agents, one specific question each: who calls it, which types cross its boundary, which invariants it protects. Naming a file is not grounding. When the design redefines ownership or layering, also recover why the current shape exists (`git log -S` on the load-bearing lines, `git blame`, linked PRs via `gh`) so the rationale becomes a constraint instead of a guess.

Skip this phase only for greenfield work with no surrounding system.

## Phase B: Sketch

Run the `arena` skill on the design-sketch task with the Phase A grounding. Pass `references/runner-prompt.md` verbatim as every runner's prompt, with its placeholders filled. Each candidate returns a design package shaped per `references/rationale-template.md`.

Runners are Claude models, one on the hardest-changes model and one on the code-delegate model (`../bstack-mode/references/models.md`). The diversity is across Claude models and briefs, not vendors. Require at least two structurally distinct candidates before synthesis, whole-shape alternatives rather than point fixes inside one shape (`../bstack-mode/principles/exhaust-the-design-space.md`). When both runners converge on one shape, add a third runner whose brief forbids that shape.

Screen every candidate against `references/design-red-flags.md` before synthesis. Reject or revise shallow modules, information leakage, temporal decomposition, and pass-through methods.

Compare the survivors on interface depth. Prefer the design that hides more complexity behind a smaller public surface.

Arena returns one synthesized package. Its pick-and-graft record fills the rationale's "Synthesis decision" section.

## Phase C: Agree

Default is no checkpoint. Proceed to implementation with the synthesized design (`../bstack-mode/principles/never-block-on-the-human.md`). Pause for sign-off only when the user asked for one ("with checkpoint", "show me before implementing").

The sketch may ship as its own scaffold commit either way (`../bstack-mode/principles/foundational-thinking.md`). For adversarial pressure before any code, run the `interrogate` skill on the sketch.

Pushback on the shape, at a checkpoint or after the fact, is Phase A evidence. Re-ground and re-run Phase B before writing more code.

## Phase D: Implement

Replace `not implemented` bodies with code and pseudocode with logic. Delegate to a `bstack-agent` on the code-delegate model with the sketch as the contract, and review the diff yourself.

A deviation from the sketch is signal, not friction to absorb. When a function needs a parameter the sketch did not anticipate, decide whether the sketch was wrong, a requirement was missed, or the implementation is overreaching, and record the answer.

## Phase E: Scrap

When friction the sketch cannot absorb becomes a pattern, throw the sketch out instead of bolting on fixes (`../bstack-mode/principles/redesign-from-first-principles.md`). Tells:

- The same workaround shape across unrelated code.
- Unrelated edge cases that each need a special-case branch.
- Types that need escape hatches to compile (`any`, casts, optional fields always set in practice).
- A "we need a lock" reflex where the sketch said the state was not shared.
- Callers that need the abstraction's internal rules to use it.
- Two or more Phase D deviations of the same shape.

A few edge cases do not condemn a design. Complexity in the data is not complexity in the design.

To scrap: re-ground over what has been built, redesign as if the new constraints were day-one assumptions, subtract before adding so the new sketch starts smaller than the old one (`../bstack-mode/principles/subtract-before-you-add.md`), then return to Phase B.

## Outputs

The caller's usage first, the type sketch derived from it. One file of new types and signatures for a small change, a module map plus type definitions for larger work. The rationale ships alongside per `references/rationale-template.md`, with the usage sketch and the synthesis decision filled in.
