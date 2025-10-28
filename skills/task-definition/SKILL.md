---
name: task-definition
description: Create structured task definition following SmartLockers DoD. Use when defining implementation tasks, features, or technical work. Includes acceptance criteria and Definition of Done.
allowed-tools: Read, Write, Edit, Grep, Glob
---

# Task Definition - SmartLockers Client Manager

Create a well-structured task definition following SmartLockers project standards and Definition of Done.

## Instructions

When this skill is invoked, help the user create a comprehensive task definition.

### What to do:

1. **Gather information** from the user:
   - What needs to be done?
   - Why is it needed?
   - What are the technical constraints?

2. **Check dependencies**:
   - Search for related code using Grep/Glob
   - Identify files that need modification
   - Check existing documentation

3. **Generate task document** using the template below

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
- Composer packages: [if any]
- External APIs: [if any]
- Database changes: [if any]

### Files to Modify
- `path/to/file1.php` - [what changes]
- `path/to/file2.php` - [what changes]

### APIs/Services Involved
- API name - endpoint/function
- SmartLockers Sync - functions used

## Implementation Notes

**Architecture considerations:**
- Function naming: Use appropriate prefix (`client_`, `api_`, `provider_`, `db_`, `auth_`)
- Manual requires: Update `require_once` if new files created
- Cache-first pattern: Only update cache on HTTP 2xx responses

**Database migrations:**
- If database migration needed: use `code/scripts/migrate.php up`
- To edit migration: run `code/scripts/migrate.php down`, fix migration, run `code/scripts/migrate.php up`
- Verify schema against `documentation/architecture/database-schema-complete.md`

**Security:**
- Bearer token authentication (no sessions)
- Input validation and sanitization
- No sensitive data in logs

## Definition of Done

### Code Implemented
- [ ] Code functional and follows architecture fonctionnelle pure
- [ ] Functions use snake_case with proper prefixes
- [ ] Cache-first pattern respected
- [ ] PHPDoc comments on all public functions

### Tests Written and Passing
**Stratégie 70/20/10:**
- [ ] PHPStan niveau 6: 0 erreur (`composer phpstan`)
- [ ] Tests de contrat: 5-8 tests max sur fonctions critiques
- [ ] Tests d'intégration: 2-3 flux critiques si applicable
- [ ] Tests < 10 lignes chacun
- [ ] Exécution rapide (< 2 minutes total)

### Documentation Updated
- [ ] PHPDoc comments in source code
- [ ] Architecture docs updated if structure changed
- [ ] API documentation if new endpoints
- [ ] README.md updated if user-facing changes

### Code Reviewed
- [ ] Validation fonctionnelle
- [ ] Respect conventions (nommage, structure, patterns)
- [ ] Sécurité: audit données sensibles et sanitisation
- [ ] PHPStan passes

### Deployed/Merged
- [ ] Branch created from `develop`
- [ ] Tests pass locally
- [ ] Code review completed
- [ ] Merged to `develop`
- [ ] Ready for merge to `main`

## Priority
- [ ] Critical
- [ ] High
- [ ] Medium
- [ ] Low

## Estimated Effort
**Time:** [hours/days]
**Complexity:** [simple/moderate/complex]

## Related Documentation
- Architecture: `documentation/architecture/`
- Conventions: `documentation/developpement/conventions-nommage.md`
- User Stories: `documentation/fonctionnel/user-stories.md`
```

## Important Reminders

**Before implementing:**
1. Read `documentation/architecture/` to understand structure
2. Check `documentation/developpement/bonnes-pratiques.md`
3. Verify database fields in `documentation/architecture/database-schema-complete.md`
4. Follow PHPDoc comment rules
5. Respect 70/20/10 testing strategy

**SmartLockers Specific Rules:**
- Architecture fonctionnelle pure (no classes)
- Manual `require_once` (no PSR-4 autoloading)
- Three layers: `code/clients/`, `code/apis/`, `code/providers/`
- Cache-first mandatory for API responses
- Bearer token auth only

## Historical Reference

**Before defining a task**, check `documentation/tasks/` for similar past tasks:
```bash
ls documentation/tasks/
```

Use these as reference to:
- Learn from previous task structures
- Understand common pitfalls and solutions
- Maintain consistency with past work
- Estimate effort based on similar completed tasks

**Example past tasks:**
- `implement-request-queue.md` - Queue system implementation
- `fix-client-config-*.md` - Client configuration fixes
- `fix-test-strategy-*.md` - Testing strategy implementation
- `phpstan-level-6-migration.md` - PHPStan upgrade process
