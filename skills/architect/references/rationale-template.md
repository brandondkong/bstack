# Rationale template

The prose that ships alongside the type sketch. One page. Sentence-case headings, no boilerplate. Replace the italic notes with content.

## Problem

*One paragraph. What we are trying to do, and what about the existing system or constraints makes the shape non-obvious. Name the constraints Phase A surfaced that the design must honor: existing types to interoperate with, callers we cannot break, invariants that cross our boundary.*

## Usage (caller's view)

*Write this first, before the type sketch. Show the README or quickstart the consumer reads, plus two or three realistic call sites in their own code. What they import, what they call, what comes back. The Shape section is derived from this and the two must agree. When they diverge, reconcile the sketch to the usage, never the reverse. The caller's experience is the spec. The types serve it.*

## Shape

*The recommended architecture. Data structures first, then how data flows through the signatures. Name the load-bearing decisions. State which invariants are encoded in types, where validation lives, and what the system deliberately does not do. Judge interface depth explicitly: what complexity the public surface hides, what remains exposed to callers, and why the interface is no larger than needed. Cite the principle behind each decision (for example `per boundary-discipline`) without restating it.*

## Synthesis decision

*Filled in by the arena pick-and-graft. Which candidate became the base and why, what was adapted from each of the others, and what was rejected and why.*

## Tradeoffs accepted

*One bullet per tradeoff the chosen shape makes, in the form "we accept X in exchange for Y." Name anything a future reader might mistake for an oversight, including what looks like premature optimization or premature simplification.*

## Alternatives considered

*Required. Name at least one concrete alternative shape with one line on why it lost. Judge each on interface depth, not implementation simplicity alone: the complexity it exposes to callers and the complexity it hides. Two or three belong here when the design space had real contenders. One is fine when the constraints forced the answer, phrased as "this was the only viable shape because...". Do not list flavors of the same shape. This section is about design alternatives the chosen shape considered, not other runner candidates.*

## Open questions and risks

*What you noticed during the sketch that the human needs to weigh in on, and risks worth flagging before implementation starts. Phrase as questions so the human's answer is the resolution.*

## Next implementation step

*The first thing to build against the sketch. One sentence.*
