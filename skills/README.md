# SmartLockers Client Manager - Claude Code Skills

This directory contains project-specific skills for Claude Code that help with development workflows.

## Available Skills

### 🔍 code-review
**Usage:** When reviewing code changes, PRs, or branches

Performs structured code review following SmartLockers project standards:
- Functionality validation
- Code quality (conventions, readability)
- Security audit
- Performance check
- Testing verification
- SmartLockers-specific rules (cache-first, function prefixes, UUID usage)

**Output:** Markdown review report with findings and recommendations

---

### 📋 task-definition
**Usage:** When defining implementation tasks or technical work

Creates comprehensive task definitions with:
- Acceptance criteria
- Technical requirements (files, APIs, dependencies)
- Implementation notes (architecture, migrations, security)
- Definition of Done (70/20/10 testing strategy)
- Priority and effort estimation

**Output:** Structured task document ready for implementation

---

### 🔄 smartlockers-sync
**Usage:** When implementing client integrations or data synchronization

Defines complete data mappings between external APIs and SmartLockers:
- Client context and business rules
- Source data structure analysis
- Entity mappings (Users, Customers, Lockers, etc.)
- Processing flow with error handling
- Validation rules
- Concrete examples
- Technical implementation guide

**Critical:** Enforces UUID usage for locker identification (not numeric IDs)

**Output:** Complete sync specification document

---

### 📖 user-story
**Usage:** When defining features from user perspective

Creates well-structured user stories with:
- Story format (As a... I want... So that...)
- Acceptance criteria (Given/When/Then)
- Business rules and constraints
- UI/UX requirements
- Technical considerations
- Definition of Done
- Priority and effort estimation

**Output:** Complete user story ready for implementation

---

## How to Use Skills

### In Claude Code Chat

Simply mention what you need:
- "Review this code" → Triggers `code-review` skill
- "Create a task for..." → Triggers `task-definition` skill
- "Define sync mapping for..." → Triggers `smartlockers-sync` skill
- "Write a user story for..." → Triggers `user-story` skill

Claude Code automatically discovers and invokes the appropriate skill based on your request.

### Manually Invoke a Skill

You can also explicitly invoke a skill using the Skill tool:
```
Use the code-review skill to review my changes
```

## Skill Structure

Each skill is in its own directory with a `SKILL.md` file:

```
.claude/skills/
├── code-review/
│   └── SKILL.md
├── task-definition/
│   └── SKILL.md
├── smartlockers-sync/
│   └── SKILL.md
└── user-story/
    └── SKILL.md
```

## Creating New Skills

To create a new skill:

1. Create directory: `.claude/skills/my-skill-name/`
2. Create file: `SKILL.md` with YAML frontmatter:

```yaml
---
name: my-skill-name
description: What it does and when to use it (max 1024 chars)
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# My Skill Title

Instructions for Claude...
```

3. Skills are automatically discovered on next Claude Code session

## SmartLockers Standards

All skills enforce SmartLockers project standards:
- ✅ Architecture fonctionnelle pure (no classes)
- ✅ Function naming with prefixes (client_, api_, provider_, db_, auth_)
- ✅ Cache-first pattern mandatory
- ✅ Bearer token authentication only
- ✅ PHPStan niveau 6 compliance
- ✅ 70/20/10 testing strategy
- ✅ UUID usage for locker identification
- ✅ Database schema validation

## Resources

- **Documentation:** `documentation/`
  - Architecture: `documentation/architecture/`
  - Development: `documentation/developpement/`
  - Functional: `documentation/fonctionnel/`

- **Project Instructions:** `CLAUDE.md`
- **Database Schema:** `documentation/architecture/database-schema-complete.md`

## Version Control

These skills are checked into git and automatically available to all team members working on this project.
