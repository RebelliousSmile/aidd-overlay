---
name: code-review
description: Perform structured code review following project checklist. Use when reviewing code changes, PRs, or branches. Covers functionality, quality, security, performance, and testing.
allowed-tools: Read, Grep, Glob, Bash, Write
argument-hint: [module-or-branch]
---

# Code Review - SmartLockers

Perform structured code reviews following SmartLockers project standards.

## Quick Start

1. **User provides**: Module name, branch, or file path
2. **Skill analyzes**: Git diff, changed files, patterns
3. **Skill generates**: Review report saved to `documentation/reviews/`

## Workflow

### Step 1: Identify Scope

If no scope provided, ask user:
```
Which scope to review?
A. Git branch (changes since main)
B. Specific module (onet, cosyhosting, halpades, lockandchill)
C. Specific file(s)
```

**Module mappings:**
- `onet`: `code/clients/onet_functions.php` + `code/apis/pilotphone_functions.php` + `code/apis/planet_functions.php`
- `cosyhosting`: `code/clients/cosyhosting_functions.php` + `code/apis/guesty_functions.php`
- `halpades`: `code/clients/halpades_functions.php` + `code/apis/msexchange_functions.php`
- `lockandchill`: `code/clients/lockandchill_functions.php` + `code/apis/beds24_functions.php`

### Step 2: Gather Changes

```bash
# For branch review
git diff main...HEAD --name-status
git log main...HEAD --oneline

# For specific files
git diff HEAD~1 -- path/to/file.php
```

### Step 3: Review Against Checklist

Load checklist from `reference.md`:
```
Read .claude/skills/code-review/reference.md
```

Review each file against:
- Functionality
- Code Quality
- Security
- Performance
- Testing
- SmartLockers Patterns

### Step 4: Generate Report

Use template from `templates/review-report.md`:
```
Read .claude/skills/code-review/templates/review-report.md
```

**Critical format for findings:**
```markdown
### 🔴 Critical Issues
1. **[🔴] CRITICAL**: `file.php:123` - Description (suggestion)

### 🟡 Warnings
1. **[🟡] WARNING**: `file.php:180` - Description (suggestion)

### 🟢 Suggestions
1. **[🟢] SUGGESTION**: `file.php:345` - Description
```

### Step 5: Save Report (MANDATORY)

```
Write to: documentation/reviews/review-{YYYY-MM-DD}-{scope}.md
```

## Supporting Files

| File | Purpose | When to Load |
|------|---------|--------------|
| `reference.md` | Full checklist, patterns | Always |
| `templates/review-report.md` | Report template | When generating |
| `examples/allocation-email.md` | Real review example | When user needs reference |
| `scripts/pre-review.sh` | Prepare review stats | Before starting |

## Output Location

```
documentation/reviews/review-{date}-{scope}.md
```

## Integration with /review-and-fix

The report format is compatible with `/review-and-fix` command which can auto-fix issues marked as:
- `**[🔴] CRITICAL**: \`file.php:line\` - Description`
- `**[🟡] WARNING**: \`file.php:line\` - Description`
