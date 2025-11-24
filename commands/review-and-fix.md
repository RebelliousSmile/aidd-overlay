---
name: review-and-fix
description: Automates code review and critical issue corrections
---

# Command: Review and Fix

You will automate the complete code review and corrections process.

## Step 0: Initialize Tracking

Use TodoWrite to create a tracking todo list with these tasks:
- Read the review file
- Analyze critical issues
- Create correction tasks (one per critical issue)
- Execute corrections
- Validate corrections (PHPStan + Tests + PHP Server)
- Clean up completed tasks
- Generate new review (overwrites the original)

Mark each task as `in_progress` before executing and `completed` after.
Record a commit identifier in the code review to analyze if it's relevant to re-analyze the code (> 10 commits -> yes).

## Step 1: Read the Review File

Ask the user which review file to analyze.

If user doesn't provide component or module name, extract it from filename (ex: `sync-api-review.md` → `sync-api`).

## Step 2: Analyze Critical Issues

Parse the review content and identify all issues marked as **Critical** or **CRITIQUE**.

For each identified issue, extract:
- Issue title
- Complete description
- Affected files with line numbers (format `file.php:123`)
- Section where the issue appears

## Step 3: Create Correction Tasks

For each critical issue identified, create a task in `documentation/tasks/`.

Name tasks according to this pattern: `fix-{module}-{index}-{short-description}.md`

Each task must contain (Markdown format):
- **Title**: Explicit issue name
- **Context**: Issue summary
- **Affected files**: List with paths and line numbers
- **Correction plan**: Detailed steps with PHP code examples
- **Validation criteria**: Tests to execute (`composer test`, `composer phpstan`)
- **Conventions to respect**: `snake_case`, functional prefixes, PHPDoc

## Step 4: Execute Corrections

For each created task:
1. Read the task file
2. Apply necessary corrections to identified files
3. Verify modifications are correct
4. Validate corrections (see Step 5)
5. Mark task as completed

## Step 5: Validate Corrections

**CRITICAL**: After each correction or set of corrections, execute MANDATORY in order:

1. **PHPStan level 5**: `composer phpstan`
   - Must return 0 errors
   - If errors: fix before continuing

2. **Contract tests** (if present): `composer test-contracts` or manual PHP tests
   - All tests must pass
   - If failures: fix before continuing

3. **PHP server startup test**: `timeout 3 php -S localhost:8001 -t public/ 2>&1`
   - Server must start without fatal error
   - Check no function redeclaration (name conflict)
   - If fatal error: fix before continuing

**If a single validation fails, the correction is considered incomplete.**

## Step 6: Clean Up Completed Tasks

Delete only task files that have been completely finished without error AND validated (Step 5).

## Step 7: Generate New Code Review

Generate a new complete code review of the module after corrections, analyzing in depth:
- **Performance and optimizations**: Loops, DB queries, caching, data resilience
- **Code maintainability**: Readability, decoupling, pure functional architecture
- **PHP best practices**:
  - Naming conventions (`snake_case` with prefixes `client_`, `api_`, `provider_`, `db_`, `auth_`)
  - Mandatory PHPDoc documentation
  - PHPStan level 5 analysis
  - Error handling with try/catch and error_log
- **Architecture**: Consistency with 3 layers (clients/apis/providers), cache-first pattern
- **Security**: Data sanitization, client-first authorization validation

This detailed analysis will automatically trigger the super-coder agent.

Compare with initial review and document improvements made.

**IMPORTANT**: Overwrite the original review file (the one provided as input) with the new version. Do NOT create a new file with a different name.

## Issue Detection Format

Search these patterns in the review file:

### Pattern 1: Red emoji with CRITIQUE in capitals (priority)
```markdown
- [🔴] **CRITICAL**: `file.php:123` Issue description (suggestion)
```

### Pattern 2: "Critical Issues Summary" Section
```markdown
## Critical Issues Summary
### 🔴 Critical Issues Identified
1. **Issue title** - `file.php:123`
```

### Pattern 3: Legacy formats (compatibility)
```markdown
**Critical**: Description with `file.php:123`
**CRITIQUE**: Other description with `other.php:456`
```

**Automatic extraction**:
- Capture file and line number with regex: `` `([^:]+\.php):(\d+)` ``
- Capture complete issue description
- Capture correction suggestion (between parentheses)

## Expected Output

Display detailed report:
- Number of critical issues identified
- Tasks created
- Successfully executed tasks
- Failed tasks (keep for debugging)
- Summary of improvements in new review

## Important Notes

- NEVER delete a failed task
- Validate each correction before moving to next (see Step 5)
- Document all modifications made
- Ensure new review accurately reflects post-corrections state
- **MANDATORY**: Execute all 3 validations (PHPStan + Tests + PHP Server) before marking correction as completed
- If PHP server doesn't start (fatal error), correction is INCOMPLETE

## Complete Workflow Example

### 1. Initial Review Generated
```markdown
### Security
- [🔴] **CRITICAL**: `database/mysql.php:287` SQL injection via dynamic table name construction (use db_sanitize_table_name())
- [🟡] **Warning**: `routes/allocations.php:180` Missing DB request timeout
```

### 2. Automatic Detection
Command extracts:
- Issue 1: SQL Injection → `database/mysql.php:287`
- Issue 2: (Ignored because 🟡 non-critical)

### 3. Task Created
File: `documentation/tasks/fix-database-1-sql-injection.md`

Content:
```markdown
# Fix SQL Injection - database/mysql.php

## Context
SQL injection via dynamic table name construction detected in `database/mysql.php:287`

## Affected Files
- `database/mysql.php:287`

## Correction Plan
1. Create function `db_sanitize_table_name($tableName)` with whitelist
2. Apply sanitization at line 287
3. Document with PHPDoc

## Validation Criteria
- `composer phpstan`: No errors
- `composer test`: Tests passing
- Conventions: `snake_case` + `db_` prefix
```

### 4. Correction Applied
Added `db_sanitize_table_name()` in `database/mysql.php`

### 5. Review Updated (overwrites original)
```markdown
### Security
- [🟢] SQL injection risks - Fixed with db_sanitize_table_name()
- [🟡] **Warning**: `routes/allocations.php:180` Missing timeout (remains todo)

**Global score**: 8/10 (was 4/10)
**Decision**: ✅ APPROVED with minor reservations
```
