# Guard the Context Window

**Applies when** context is filling up: large outputs, long files, repeated reads, fan-out planning.

The context window is finite within a session. Every token should earn its cost.

**Why:** overflow degrades reasoning, and compaction loses detail.

- **Isolate large payloads.** Route verbose output, logs, and large documents to subagents. The main thread gets summaries, not raw data.
- **Don't read what you won't use.** Read the part of a file you need.
- **Keep frequently used content inline.** A template used on every invocation belongs in the skill file, not a separate file that costs a read each time.
- **Size phases and cap scope.** Limit files per phase and set turn budgets for delegates.
