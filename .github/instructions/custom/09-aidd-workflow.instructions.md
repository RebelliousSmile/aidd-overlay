---
description: AIDD workflow — plan before code
---

# aidd workflow

## Agentic mode (autonomous skills, sub-agents)

- Always write a full plan before implementing
- Wait for explicit user approval before coding
- On plan rejection: ask for direction, do not implement alternative
- On session resume: ask before acting on pending plan

## Interactive mode (human-driven conversation)

- Propose approach in conversation before coding (no plan file needed)
- Small scoped changes: state intent, then proceed unless user objects
- Multi-file or cross-module changes: write a plan, wait for approval

## Shared rules

- Clarification is not approval to implement
- Direct feature request is a trigger — no command needed
- Update memory bank if business behavior changed
