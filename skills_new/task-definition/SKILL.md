---
name: task-definition
description: Create structured task definition following project DoD. Use when defining implementation tasks, features, or technical work. Includes acceptance criteria and Definition of Done.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: [task-title]
---

# Task Definition

Create well-structured task definitions following SmartLockers project standards.

## Quick Start

1. **User provides**: Task title or description
2. **Skill consults**: Memory-bank for project conventions
3. **Skill generates**: Complete task document in `documentation/tasks/`

## Workflow

### Step 1: Gather Information

Ask user (via AskUserQuestion if unclear):
- What needs to be done?
- Why is it needed? (problem/goal)
- Any technical constraints?

### Step 2: Consult Project Standards

**MANDATORY** - Read memory-bank:
```bash
Read documentation/memory-bank/core/conventions-dev.md
Read documentation/memory-bank/core/architecture-essentials.md
```

Extract:
- Naming conventions (prefixes: `client_`, `api_`, `provider_`, `db_`, `auth_`)
- Testing strategy (70/20/10: PHPStan / Contracts / Integration)
- Architecture patterns (cache-first, functional pure)
- Definition of Done criteria

### Step 3: Analyze Dependencies

```bash
# Search related code
Grep "function_name" code/
Glob "code/clients/*_functions.php"
```

Identify:
- Files to modify
- Related functions
- Existing patterns to follow

### Step 4: Generate Task Document

Use template from `templates/task.md` (load it):
```
Read .claude/skills/task-definition/templates/task.md
```

Fill template with gathered information.

### Step 5: Save Task

Save to: `documentation/tasks/[task-name].md`

## Supporting Files

| File | Purpose | When to Load |
|------|---------|--------------|
| `templates/task.md` | Empty template to fill | Always |
| `reference.md` | DoD details, best practices | When questions about standards |
| `examples/integration-guesty.md` | Real task example | When user needs reference |

## Task Quality Checklist

Before saving, verify:
- [ ] Title is action-oriented (verb + noun)
- [ ] Acceptance criteria are testable
- [ ] Files to modify are identified
- [ ] DoD matches project standards
- [ ] Scope is reasonable (< 2h, otherwise split)

## Output Location

```
documentation/tasks/[task-name].md
```

**Naming**: lowercase, hyphen-separated (e.g., `add-beds24-webhook.md`)

## Collaboration

After task defined, suggest next steps:
- **code-architect**: If architectural decisions needed
- **super-coder**: For implementation
- **test-architect**: For test strategy validation
