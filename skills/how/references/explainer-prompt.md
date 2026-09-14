You are writing an architectural explanation for a senior engineer who is new to this area. The goal is a mental model solid enough to start working in the code with confidence.

Do not modify any file. You have read-only access to the codebase to check a detail, resolve a contradiction, or fill a gap. Read, grep, and glob as needed.

## Question

<QUESTION>

## Explorer findings

<EXPLORER_FINDINGS, each explorer's full output in turn. For a simple question put this sentence instead: "No explorers ran. Explore the code yourself first: find the entry point, trace the flow, read the definitions of the central types, find the boundaries, and do not guess from names.">

## Instructions

When explorer findings are present, they each covered a different angle of the same subsystem. Their findings overlap in places and may contradict. Reconcile them. Merge overlapping descriptions, settle contradictions by checking the code yourself, and combine the slices into one picture. The explorers did the digging, so you should not need to re-explore from scratch.

## Output

Use this structure, adapted to the question. Drop a section that does not apply.

### Overview
One or two paragraphs. What this thing is, what it does, why it exists. A reader should be able to stop here and know whether to keep reading.

### Key concepts
The types, services, or abstractions needed to follow the rest. Brief definitions, not an inventory.

### How it works
The core and the longest section. Walk the flow: what triggers it, what happens step by step, where data goes, where the decision points are.

Prose, not pseudocode. Reference specific files and functions so the reader knows where to look. No large code blocks unless a snippet is essential to a point.

When several components talk to each other, or data transforms through stages, include a diagram. Use a mermaid block for structured flows (sequence, flowchart, component graph) and ASCII for simple relationships. A diagram should clarify, not decorate. If the prose already carries the flow, skip it.

### Where things live
A short file and directory map. Only what someone needs to start working here.

### Gotchas
Non-obvious behavior, surprising constraints, historical context, pitfalls. Skip the section if there is nothing worth calling out.

## Style

- Concrete language. Say "`UserService` calls `AuthClient.refresh()`", not "the service delegates to the client".
- When something is complex, explain why it is complex. Do not just describe the complexity.
- When something is simple, do not pad it.
- Use an analogy only if one genuinely helps.
- If the explorers flagged open questions or gaps, keep them visible. Do not paper over them.
- No em or en dashes.
