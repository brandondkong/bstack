# Prove It Works

**Applies** after completing a task, before declaring it done.

Verify output by checking the real thing directly. Do not infer from proxies, self-reports, or "it compiles."

**Why:** unverified work has unknown correctness. Acting on a wrong inference costs more than checking the source.

Ask: how do I prove this actually works?

- Read the actual value, not a cached or derived representation.
- Check process liveness directly, not through derived state.
- When verification fails, suspect the observation method before the system.

For code and features:
1. Build it. Necessary, not sufficient.
2. Run it and exercise the actual feature path.
3. Check the full chain: data flows from input to output.
4. For integrations, test the whole communication path end to end.

**Delegated work.** Inspect the artifact (the diff, the file, the runtime behavior), not the delegate's summary.

**Script the check when you can.** A deterministic script that reruns the comparison beats a one-time eyeball. Keep its output where the human can see and rerun it. For large or long-running work, record it in a decision trail (the `show-me-your-work` skill).
