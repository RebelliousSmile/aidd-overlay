# SmartLockers Client Manager - Claude Code Skills

This directory contains project-specific skills for Claude Code that help with development workflows.

## Available Skills

### `/documentation-sync [mode]`
**Purpose:** Unified documentation management

**Modes:**
- `sync [files]` - Sync code changes to documentation
- `clean` - Clean up obsolete files (> 30 days)
- `quick-ref <component>` - Create concise quick reference
- `check` - Verify memory bank integrity
- `optimize` - Audit and optimize token usage

**Examples:**
```bash
/documentation-sync sync code/apis/beds24_functions.php
/documentation-sync clean
/documentation-sync check
```

**Delegates to:** `documentation-architect` agent

---

### `/code-review [files]`
**Purpose:** Structured code review following SmartLockers standards

Performs comprehensive review:
- Functionality validation
- Code quality (conventions, readability)
- Security audit
- Performance check
- Testing verification
- SmartLockers-specific rules (cache-first, function prefixes, UUID usage)

**Output:** Markdown review report saved to `documentation/reviews/`

---

### `/task-definition <description>`
**Purpose:** Create structured task definitions with DoD

Creates comprehensive task with:
- Acceptance criteria
- Technical requirements (files, APIs, dependencies)
- Implementation notes (architecture, migrations, security)
- Definition of Done (70/20/10 testing strategy)
- Priority and effort estimation

**Output:** Structured task document saved to `documentation/tasks/`

---

### `/api-integration-assistant`
**Purpose:** Guide API integration patterns

Use when integrating new external APIs:
- API function creation patterns
- Authentication setup
- Cache-first implementation
- Error handling

---

## How to Use Skills

### Direct Invocation

```bash
/documentation-sync check
/code-review src/services/sync.php
/task-definition "Add JWT refresh endpoint"
```

### Natural Language

Claude Code automatically discovers skills:
- "Review this code" → Triggers `/code-review`
- "Create a task for..." → Triggers `/task-definition`
- "Sync the docs" → Triggers `/documentation-sync sync`

## Skill Structure

Each skill has supporting files:

```
.claude/skills/
├── documentation-sync/
│   ├── SKILL.md           # Main entry with modes
│   ├── reference.md       # Patterns and mappings
│   ├── templates/         # Output templates
│   ├── examples/          # Real examples
│   └── scripts/           # Helper scripts
│
├── code-review/
│   ├── SKILL.md           # Workflow (~100 lines)
│   ├── reference.md       # Full checklist
│   ├── templates/         # Report template
│   ├── examples/          # Example reviews
│   └── scripts/           # Pre-review script
│
├── task-definition/
│   ├── SKILL.md           # Workflow
│   ├── reference.md       # DoD patterns
│   ├── templates/         # Task template
│   ├── examples/          # Real task examples
│   └── scripts/           # Validation script
│
└── api-integration-assistant/
    ├── SKILL.md           # Workflow
    ├── reference.md       # Auth patterns, questionnaire
    ├── templates/         # PHP, test, config templates
    ├── examples/          # Beds24 OAuth2 example
    └── scripts/           # Validation script
```

## Creating New Skills

1. Create directory: `.claude/skills/my-skill-name/`
2. Create `SKILL.md` with YAML frontmatter:

```yaml
---
name: my-skill-name
description: What it does and when to use it (max 1024 chars)
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# My Skill Title

Instructions for Claude...
```

3. Optional supporting files:
   - `reference.md` - Detailed patterns, rules, mappings
   - `templates/` - Output templates
   - `examples/` - Real examples for context
   - `scripts/` - Helper bash/php scripts

4. Skills are automatically discovered on next Claude Code session

## SmartLockers Standards

All skills enforce SmartLockers project standards:
- Architecture fonctionnelle pure (no classes)
- Function naming with prefixes (client_, api_, provider_, db_, auth_)
- Cache-first pattern mandatory
- JWT authentication
- PHPStan niveau 6 compliance
- 70/20/10 testing strategy
- UUID usage for locker identification
- Database schema validation

## Resources

- **Commands:** `.claude/commands/README.md`
- **Agents:** `.claude/agents/README.md`
- **Project Instructions:** `CLAUDE.md`
- **Memory Bank:** `documentation/memory-bank/`
