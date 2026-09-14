### Eval

**You own the experiment design. Frame, blind, run, synthesize.** For testing how a skill, prompt, or structure change affects agent behavior before promoting it.

Two layers. Run the cheap one first.

**Layer 1, the unit tests.** Structural claims (a file gets read, a tool is or isn't called, a file is produced with a given shape) belong in `evals/` and are checked by `claude plugin eval`. They are deterministic, rerunnable, and free apart from `llm` graders. Any rule you would otherwise restate in prose belongs here (`principles/encode-lessons-in-structure.md`).

**Layer 2, the blind comparison.** "Is variant B better than A" is a judgment call. It needs candidates that don't know they are being measured, and a judge that doesn't know which variant it is reading.

#### Blinding, non-negotiable

- No `eval`, `test`, `judge`, `experiment`, `rubric`, `score`, `compare`, `benchmark`, `candidate`, `variant`, or `A/B` in any directory name, file, or prompt a candidate sees.
- The candidate prompt reads like an organic user request. State the goal, not the meta.
- No chain-eliciting cues. Never ask a candidate which skills, principles, or files it used. Grade that from its transcript.
- Sanitize directory and branch names. Use project-shaped names a person would pick.
- Never tell a candidate that other candidates exist.
- The judge may know it is judging. It sees outputs by sanitized label only, never a model name, never which variant produced them.
- Comparing two variants: one judge scores every output in a single pass on one scale.

#### Steps

1. **Frame.** Name the variant under test and what behavior counts as success. Write a rubric of 3 to 6 concrete criteria. The rubric is for the judge and for you. Candidates never see it.
2. **Run layer 1.** Copy the plugin to two directories, A (current) and B (variant), under a scratch path. Run `claude plugin eval <dir> --no-publish --json <dir>-result.json` on each and compare `aggregates.overallScore` and `meanDelta` per case. A structural regression here ends the experiment. Fix it before judging prose.
3. **Set up sanitized workspaces.** One working directory per run, project-shaped name, seeded with whatever an organic task would have: a small repo, fixture files, a git history. Every run starts from an identical seed.
4. **Author one organic prompt.** What a person would actually type. Same prompt to every run.
5. **Run the candidates.** One headless session per run, so each loads exactly one variant and nothing of yours:
   ```
   cd <workspace-n> && claude -p "<organic prompt>" --plugin-dir <A|B> --model <model> \
     --allowedTools Read Glob Grep Edit Write Bash > out-n.md 2>&1
   ```
   At least two models per variant, from `references/models.md`. Run them in the background in one message and wait for all of them.
6. **Verify the chain from transcripts, not self-report.** Run `bstack-trace` on each run's transcript. Grade chain-following from the files it actually opened and the shape of the output. A candidate's claim about its own process is not evidence (`principles/prove-it-works.md`).
7. **Judge blind.** Spawn one `Agent` on a model no candidate used (`references/models.md`). Give it the rubric and the outputs by sanitized label (`run-1`, `run-2`, ...) in a shuffled order, with no model names and no variant labels. It scores each criterion and ranks them.
8. **Read every output yourself** end to end and compare with the judge. Disagreement means the rubric is ambiguous or one model is biased. Investigate before you trust either.
9. **Decide and encode.** Promote or drop the variant. If you promote it, add or update an `evals/` case so the behavior you just proved by hand is checked automatically from now on.

**Reply:** the variant under test, the rubric, layer-1 scores for both arms, per-run notes with what each run actually read, the judge's verdict, your synthesis where it differs, and a promote or drop recommendation with its reason.
