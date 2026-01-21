# Task Definition Reference

Detailed documentation for creating high-quality task definitions.

## Definition of Done (SmartLockers Project)

### Code Implemented
- [ ] Code functional and follows functional architecture (no classes)
- [ ] Naming conventions respected:
  - Functions: `snake_case` with prefixes (`client_`, `api_`, `provider_`, `db_`, `auth_`)
  - Variables: `snake_case` descriptive
- [ ] Cache-first pattern applied (data resilience)
- [ ] PHPDoc on all public functions

### Tests Written and Passing
**Strategy 70/20/10:**
- [ ] **PHPStan level 6**: 0 errors (`composer phpstan`)
- [ ] **Contract tests**: 5-8 max on critical functions (`code/tests/contracts/`)
- [ ] **Integration tests**: 2-3 critical flows (`code/tests/integration/critical_flows/`)

**Quality criteria:**
- Tests simple (< 10 lines per contract test)
- Fast execution (contracts < 30s, total < 2 min)
- No test frameworks (simple PHP scripts)

### Documentation Updated
- [ ] PHPDoc in code (preferred over separate docs)
- [ ] Architecture docs if structure changed
- [ ] Memory-bank guides if new patterns

### Code Reviewed
- [ ] Functional validation
- [ ] Conventions respected
- [ ] Security audit (sanitize external data)

### Deployed/Merged
- [ ] Feature branch → develop → main
- [ ] Tests pass in CI
- [ ] No breaking changes

## Acceptance Criteria Best Practices

### Good Criteria (Testable)
```markdown
- [ ] Function `api_beds24_get_bookings()` returns array with keys: status, source, data
- [ ] PHPStan level 6: 0 errors
- [ ] Cache fallback works when API returns 500
- [ ] Route `/api/client/endpoint` returns HTTP 200 with valid token
```

### Bad Criteria (Vague)
```markdown
- [ ] Code works correctly
- [ ] Tests pass
- [ ] Good performance
```

## Task Sections Explained

### Description
- **What**: Clear statement of what needs to be done
- **Why**: Problem being solved or goal achieved
- **Context**: Current state and desired state

### Technical Requirements
- **Files to modify**: Exact paths with line numbers if known
- **Dependencies**: Functions, services, tables involved
- **Constraints**: Performance, security, compatibility

### Implementation Notes
- Code snippets showing approach
- Questions to investigate
- Risks and mitigations

### Risks and Mitigations

| Risk Level | Description |
|------------|-------------|
| **Critical** | Blocks deployment, data loss possible |
| **High** | Major feature broken, workaround difficult |
| **Medium** | Feature degraded, workaround exists |
| **Low** | Minor issue, easy to fix |

## Common Patterns

### API Integration Task
```markdown
## Acceptance Criteria
- [ ] API credentials stored in `{client}_owners` table
- [ ] Function `api_{service}_get_data()` implements cache-first
- [ ] Fallback to cache on HTTP errors (4xx, 5xx)
- [ ] PHPStan 0 errors
```

### Database Migration Task
```markdown
## Acceptance Criteria
- [ ] Migration file in `code/src/migrations/`
- [ ] Both `up()` and `down()` functions implemented
- [ ] Test table created (`test_{table_name}`)
- [ ] `php code/scripts/tools/migrate.php up` succeeds
```

### Client Route Task
```markdown
## Acceptance Criteria
- [ ] Route defined in `client_{name}_get_routes()`
- [ ] Handler in `client_{name}_handle_{route}()`
- [ ] Bruno collection updated
- [ ] JWT authentication validated
```

## File Naming Convention

```
documentation/tasks/
├── add-feature-name.md           # New feature
├── fix-bug-description.md        # Bug fix
├── refactor-component-name.md    # Refactoring
├── integrate-api-service.md      # API integration
└── update-schema-table.md        # Database change
```

## References

- **Memory Bank**: `documentation/memory-bank/core/`
- **Architecture**: `documentation/notebooks/architecture/`
- **Existing Tasks**: `documentation/tasks/` (for reference)
