---
name: code-review
description: Perform structured code review following project checklist. Use when reviewing code changes, PRs, or branches. Covers functionality, quality, security, performance, and testing.
allowed-tools: Read, Grep, Glob, Bash
---

# Code Review - SmartLockers Client Manager

Perform a comprehensive code review following the SmartLockers project standards.

## Instructions

When this skill is invoked, perform a structured code review using the template below.

### What to do:

1. **Identify the scope**:
   - Ask the user for branch/PR name if not provided
   - Use `git diff` to see changed files
   - Use `git log` to see commit history

2. **Review each file** against the checklist below

3. **Generate a structured report** using the template

## Review Checklist

### Functionality
- [ ] Code works as intended
- [ ] Edge cases handled
- [ ] Error handling appropriate

### Code Quality
- [ ] Follows project conventions (snake_case, function prefixes: `client_`, `api_`, `provider_`, `db_`, `auth_`)
- [ ] Clear and readable
- [ ] No duplicated code
- [ ] Functions are focused and small

### Security
- [ ] No sensitive data exposed
- [ ] Input validation present
- [ ] Authentication/authorization correct

### Performance
- [ ] No obvious performance issues
- [ ] Database queries optimized
- [ ] Caching used appropriately (cache-first pattern)

### Testing
- [ ] Tests cover new functionality
- [ ] Tests pass (PHPStan niveau 6)
- [ ] Manual testing completed

### SmartLockers Specific
- [ ] Functions use proper prefixes
- [ ] Manual `require_once` updated if new files added
- [ ] Cache-first pattern respected (only update cache on HTTP 2xx)
- [ ] PHPDoc comments present
- [ ] Bearer token authentication (no sessions)
- [ ] Database schema matches `documentation/architecture/database-schema-complete.md`

## Output Format

Provide a review report in markdown format:

```markdown
# Code Review Report

**Branch/PR:** [name]
**Reviewed files:** [count]
**Date:** [today]

## Summary
[2-3 sentence overview]

## Files Changed
- file1.php
- file2.php

## Findings

### Critical Issues
- [ ] Issue 1 (file:line)
- [ ] Issue 2 (file:line)

### Suggestions
- [ ] Suggestion 1 (file:line)
- [ ] Suggestion 2 (file:line)

### Positive Points
- Good practice 1
- Good practice 2

## Checklist Results
- Functionality: ✅/⚠️/❌
- Code Quality: ✅/⚠️/❌
- Security: ✅/⚠️/❌
- Performance: ✅/⚠️/❌
- Testing: ✅/⚠️/❌

## Decision
- [ ] Approve
- [ ] Request changes
- [ ] Comment only

## Next Steps
[If changes requested, list specific actions]
```

## Important Notes

- Always reference file:line for issues
- Be specific and constructive
- Prioritize critical issues (security, data integrity, cache-first violations)
- Check that PHPStan passes before approving

## Historical Reference

**Before starting a review**, check `documentation/reviews/` for similar past reviews:
```bash
ls documentation/reviews/
```

Use these as reference to:
- Maintain consistency with project review standards
- Learn from previously identified patterns
- Apply same rigor as past reviews
- Avoid repeating issues already fixed

**Example past reviews:**
- `code-review-async-concurrency.md` - Concurrency and locks patterns
- `code-review-test-strategy-70-20-10.md` - Testing strategy validation
- `code-review-client-configuration.md` - Client configuration patterns
