---
name: code-review
description: Perform structured code review following project checklist. Use when reviewing code changes, PRs, or branches. Covers functionality, quality, security, performance, and testing. (project)
allowed-tools: Read, Grep, Glob, Bash
---

# Code Review - SmartLockers Client Manager

Perform a **quick** structured code review following the SmartLockers project standards.

**⚡ Quick Review (< 5 files, < 500 lines, 5 min)**

For in-depth reviews (>= 5 files or complete audits with scoring), use: `/review --depth=full`

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
- [ ] Tests pass (PHPStan level 6)
- [ ] Manual testing completed

### SmartLockers Specific
- [ ] Functions use proper prefixes
- [ ] Manual `require_once` updated if new files added
- [ ] cache-first pattern respected (only update cache on HTTP 2xx)
- [ ] PHPDoc comments present
- [ ] Bearer token authentication (no sessions)
- [ ] Database schema matches `documentation/architecture/database-schema-complete.md`

## Output Format

**⚠️ CRITICAL FORMAT**: Compatible with `/review-and-fix`

Provide a review report in markdown format using **EXACTLY this structure**:

```markdown
# Code Review Report

**Branch/PR:** [name]
**Reviewed files:** [count]
**Date:** [today]
**Review Type:** ⚡ Quick (Skill)

## Summary
[2-3 sentence overview]

## Findings

### 🔴 Critical Issues

1. **[🔴] CRITICAL**: `file.php:123` - Missing cache-first (use api_resilient_call())
2. **[🔴] CRITICAL**: `file.php:287` - Unsanitized input (use sanitize_client_name())

**MANDATORY FORMAT**: `**[🔴] CRITICAL**: \`file.php:line\` - Description (suggestion)`

### 🟡 Warnings

1. **[🟡] WARNING**: `file.php:180` - Variable $lockerId (use $lockerUuid)
2. **[🟡] WARNING**: `file.php:202` - Incomplete PHPDoc (add @return)

### 🟢 Suggestions

1. **[🟢] SUGGESTION**: `file.php:345` - Extract validation logic
2. **[🟢] SUGGESTION**: `file.php:489` - Add example in PHPDoc

### Positive Points
- Good practice 1
- Good practice 2

## Checklist Results
- Functionality: ✅/⚠️/❌
- Code Quality: ✅/⚠️/❌
- Security: ✅/⚠️/❌
- Performance: ✅/⚠️/❌
- Testing: ✅/⚠️/❌
- SmartLockers Patterns: ✅/⚠️/❌

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
