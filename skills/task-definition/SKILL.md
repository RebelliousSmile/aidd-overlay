---
name: task-definition
description: Create structured task definition following project DoD. Use when defining implementation tasks, features, or technical work. Includes acceptance criteria and Definition of Done. Consults memory-bank for project-specific standards.
allowed-tools: Read, Write, Edit, Grep, Glob
---

# Task Definition

Create a well-structured task definition following project standards and Definition of Done. **Agnostic** - consults memory-bank for project-specific rules.

## Instructions

When this skill is invoked, help the user create a comprehensive task definition.

### What to do:

1. **Gather information** from the user:
   - What needs to be done?
   - Why is it needed?
   - What are the technical constraints?

2. **Consult memory-bank** (MANDATORY):
   ```bash
   Read documentation/memory-bank/core/conventions-dev.md
   Read documentation/memory-bank/core/architecture-essentials.md
   ```

   **Extract project-specific rules**:
   - Naming conventions
   - Testing strategy
   - Architecture patterns
   - Documentation requirements
   - Definition of Done

3. **Check dependencies**:
   - Search for related code using Grep/Glob
   - Identify files that need modification
   - Check existing documentation

4. **Generate task document** using the template below (adapted to project rules from memory-bank)

## Task Template

```markdown
# Task: [Concise, action-oriented title]

## Description
[What needs to be done and why]

## Acceptance Criteria
- [ ] Criterion 1 (testable)
- [ ] Criterion 2 (testable)
- [ ] Criterion 3 (testable)

## Technical Requirements

### Dependencies
- [List dependencies from project]

### Files to Modify
- `path/to/file1.ext` - [what changes]
- `path/to/file2.ext` - [what changes]

### APIs/Services Involved
- [API/Service names and functions]

## Implementation Notes

**Consult memory-bank before implementing:**
- Architecture patterns required
- Naming conventions to follow
- Security rules to apply
- Performance patterns mandatory

**Project-specific guidelines:**
[Insert from memory-bank/core/conventions-dev.md]

## Definition of Done

### Code Implemented
- [ ] Code functional and follows project architecture
- [ ] Follows naming conventions (from memory-bank)
- [ ] Patterns respected (from memory-bank)
- [ ] Documentation comments per project rules

### Tests Written and Passing
[Extract testing strategy from memory-bank]
- [ ] Static analysis: Pass (tool from memory-bank)
- [ ] Unit/contract tests: Coverage targets met
- [ ] Integration tests: Critical flows validated
- [ ] Test execution time: Within project limits

### Documentation Updated
- [ ] Code documentation (comments/docstrings per project style)
- [ ] Architecture docs if structure changed
- [ ] API documentation if new endpoints
- [ ] User-facing docs if needed

### Code Reviewed
- [ ] Functional validation
- [ ] Respect conventions (from memory-bank)
- [ ] Security audit
- [ ] Quality checks pass

### Deployed/Merged
- [ ] Branch workflow followed (from memory-bank)
- [ ] Tests pass
- [ ] Code review completed
- [ ] Ready for merge

## Priority
- [ ] Critical
- [ ] High
- [ ] Medium
- [ ] Low

## Estimated Effort
**Time:** [hours/days]
**Complexity:** [simple/moderate/complex]

## Related Documentation
- Memory Bank Core: `documentation/memory-bank/core/`
- Architecture Notebooks: `documentation/notebooks/architecture/`
- Project-specific guides: `documentation/memory-bank/guides/`
```

## Task File Placement

**According to documentation-architect (strict 8 directories)**:

```
documentation/tasks/[task-name].md           # Active task
documentation/tasks/plans/[plan-name].md     # Detailed plan
```

**When task completed**: Delete or archive

## Important Reminders

**Before defining task:**
1. **Read memory-bank** to understand project conventions
2. **Search similar past tasks** in `documentation/tasks/` for reference
3. **Verify DoD** matches project standards (from memory-bank)
4. **Consult code-architect** if architectural decisions needed

**Task must be:**
- ✅ Actionable (clear what to do)
- ✅ Testable (acceptance criteria measurable)
- ✅ Documented (DoD from memory-bank)
- ✅ Scoped (not too large, break down if > 2h)

## Historical Reference

**Before defining a task**, check `documentation/tasks/` and `documentation/tasks/plans/` for similar past tasks.

Use these as reference to:
- Learn from previous task structures
- Understand common pitfalls and solutions
- Maintain consistency with past work
- Estimate effort based on similar completed tasks

## Collaboration

- Consult **code-architect** for architectural validation
- Use **super-coder** for implementation (after task defined)
- Use **test-architect** for testing validation
- Use **documentation-architect** for doc placement
